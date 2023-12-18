import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class MessagesView extends StatefulWidget {
  MessagesView.arguments(MessagesViewArguments arguments, {super.key})
      : profile = arguments.profile,
        controller = arguments.controller,
        inputBar = arguments.inputBar,
        appBar = arguments.appBar,
        showAvatar = arguments.showAvatar,
        showNickname = arguments.showNickname,
        onItemTap = arguments.onItemTap,
        onItemLongPress = arguments.onItemLongPress,
        onDoubleTap = arguments.onDoubleTap,
        onAvatarTap = arguments.onAvatarTap,
        onNicknameTap = arguments.onNicknameTap,
        focusNode = arguments.focusNode,
        bubbleStyle = arguments.bubbleStyle,
        emojiWidget = arguments.emojiWidget,
        itemBuilder = arguments.itemBuilder,
        onAvatarLongPress = arguments.onAvatarLongPressed,
        moreActionItems = arguments.moreActionItems,
        onItemLongPressActions = arguments.onItemLongPressActions;

  const MessagesView({
    required this.profile,
    this.appBar,
    this.inputBar,
    this.controller,
    super.key,
    this.showAvatar = true,
    this.showNickname = true,
    this.onItemTap,
    this.onItemLongPress,
    this.onDoubleTap,
    this.onAvatarTap,
    this.onAvatarLongPress,
    this.onNicknameTap,
    this.focusNode,
    this.emojiWidget,
    this.itemBuilder,
    this.bubbleStyle = ChatUIKitMessageListViewBubbleStyle.arrow,
    this.onItemLongPressActions,
    this.moreActionItems,
  });

  final ChatUIKitProfile profile;
  final MessageListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final Widget? inputBar;
  final bool showAvatar;
  final bool showNickname;
  final void Function(Message message)? onItemTap;
  final void Function(Message message)? onItemLongPress;
  final void Function(Message message)? onDoubleTap;
  final void Function(ChatUIKitProfile profile)? onAvatarTap;
  final void Function(ChatUIKitProfile profile)? onAvatarLongPress;
  final void Function(ChatUIKitProfile profile)? onNicknameTap;
  final ChatUIKitMessageListViewBubbleStyle bubbleStyle;
  final MessageItemBuilder? itemBuilder;
  final FocusNode? focusNode;
  final List<ChatUIKitBottomSheetItem>? moreActionItems;
  final List<ChatUIKitBottomSheetItem>? onItemLongPressActions;
  final Widget? emojiWidget;

  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  late final MessageListViewController controller;
  late final TextEditingController inputBarTextEditingController;

  late final FocusNode focusNode;
  bool showEmojiBtn = false;
  bool showMoreBtn = true;
  late final ImagePicker _picker;

  bool messageEdit = false;
  bool messageEditCanSend = false;
  TextEditingController? editBarTextEditingController;
  Message? editMessage;

  @override
  void initState() {
    super.initState();
    inputBarTextEditingController = TextEditingController();
    controller = MessageListViewController(profile: widget.profile);
    focusNode = widget.focusNode ?? FocusNode();
    _picker = ImagePicker();
    focusNode.addListener(() {
      if (messageEdit) return;
      if (focusNode.hasFocus) {
        showEmojiBtn = false;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    editBarTextEditingController?.dispose();
    inputBarTextEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('MessagesView build');
    final theme = ChatUIKitTheme.of(context);

    Widget content = MessageListView(
        profile: widget.profile,
        controller: controller,
        showAvatar: widget.showAvatar,
        showNickname: widget.showNickname,
        onItemTap: widget.onItemTap,
        onItemLongPress: widget.onItemLongPress ?? onItemLongPress,
        onDoubleTap: widget.onDoubleTap,
        onAvatarTap: widget.onAvatarTap,
        onAvatarLongPressed: widget.onAvatarLongPress,
        onNicknameTap: widget.onNicknameTap,
        bubbleStyle: widget.bubbleStyle,
        itemBuilder: widget.itemBuilder);

    content = Column(
      children: [
        Expanded(
            child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: content)),
        if (messageEdit) editMessageBar(theme),
        if (!messageEdit) widget.inputBar ?? inputBar(),
        AnimatedContainer(
          curve: Curves.linearToEaseOut,
          duration: const Duration(milliseconds: 250),
          height: showEmojiBtn ? 230 : 0,
          child: showEmojiBtn
              ? widget.emojiWidget ?? const ChatUIKitInputEmojiBar()
              : const SizedBox(),
        ),
      ],
    );

    content = Scaffold(
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: widget.appBar ??
          ChatUIKitAppBar(
            title: widget.profile.showName,
          ),
      body: SafeArea(child: content),
    );

    return content;
  }

  Widget editMessageBar(ChatUIKitTheme theme) {
    Widget content = ChatUIKitInputBar(
      key: const ValueKey('editKey'),
      autofocus: true,
      onChanged: (input) {
        if (messageEditCanSend != (input.trim() != editMessage?.textContent)) {
          messageEditCanSend = input.trim() != editMessage?.textContent;
          setState(() {});
        }
      },
      focusNode: focusNode,
      textEditingController: editBarTextEditingController!,
      trailing: InkWell(
        onTap: () {
          String text = editBarTextEditingController?.text.trim() ?? '';
          if (text.isNotEmpty) {
            controller.editMessage(editMessage!, text);
            editBarTextEditingController?.clear();
            editMessage = null;
            messageEdit = false;
            setState(() {});
          }
        },
        child: Icon(
          Icons.check_circle,
          size: 30,
          color: theme.color.isDark
              ? messageEditCanSend
                  ? theme.color.primaryColor6
                  : theme.color.neutralColor5
              : messageEditCanSend
                  ? theme.color.primaryColor5
                  : theme.color.neutralColor7,
        ),
      ),
    );

    Widget header = Row(
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: ChatUIKitImageLoader.messageEdit(),
        ),
        const SizedBox(width: 2),
        Text(
          '编辑中',
          style: TextStyle(
              fontWeight: theme.font.labelSmall.fontWeight,
              fontSize: theme.font.labelSmall.fontSize,
              color: theme.color.isDark
                  ? theme.color.neutralSpecialColor6
                  : theme.color.neutralSpecialColor5),
        ),
      ],
    );
    header = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
          color: theme.color.isDark
              ? theme.color.neutralColor2
              : theme.color.neutralColor9),
      child: header,
    );
    content = Column(
      children: [header, content],
    );

    return content;
  }

  Widget inputBar() {
    return ChatUIKitInputBar(
      key: const ValueKey('inputKey'),
      onChanged: (input) {
        if (showMoreBtn != !input.trim().isNotEmpty) {
          showMoreBtn = !input.trim().isNotEmpty;
          setState(() {});
        }
      },
      focusNode: focusNode,
      textEditingController: inputBarTextEditingController,
      leading: InkWell(
        onTap: () async {
          focusNode.unfocus();
          showEmojiBtn = false;
          setState(() {});
          ChatUIKitRecordModel? model = await showChatUIKitRecordBar(
            context: context,
            statusChangeCallback: (type, duration, path) {
              if (type == ChatUIKitVoiceBarStatusType.playing) {
                // 播放录音
                debugPrint('播放录音');
              } else if (type == ChatUIKitVoiceBarStatusType.ready) {
                // 停止播放
                debugPrint('停止播放');
              }
            },
          );
          if (model != null) {
            controller.sendVoiceMessage(model);
          }
        },
        child: ChatUIKitImageLoader.voiceKeyboard(),
      ),
      trailing: SizedBox(
        child: Row(
          children: [
            if (!showEmojiBtn)
              InkWell(
                onTap: () {
                  focusNode.unfocus();
                  showEmojiBtn = !showEmojiBtn;
                  setState(() {});
                },
                child: ChatUIKitImageLoader.faceKeyboard(),
              ),
            if (showEmojiBtn)
              InkWell(
                onTap: () {
                  focusNode.requestFocus();
                  showEmojiBtn = !showEmojiBtn;
                  setState(() {});
                },
                child: ChatUIKitImageLoader.textKeyboard(),
              ),
            const SizedBox(width: 8),
            if (showMoreBtn)
              InkWell(
                onTap: () {
                  List<ChatUIKitBottomSheetItem>? items =
                      widget.moreActionItems;

                  if (items == null) {
                    items = [];
                    items.add(ChatUIKitBottomSheetItem.normal(
                      label: '相册',
                      onTap: () async {
                        Navigator.of(context).pop();
                        selectImage();
                      },
                    ));
                    items.add(ChatUIKitBottomSheetItem.normal(
                      label: '视频',
                      onTap: () async {
                        Navigator.of(context).pop();
                        selectVideo();
                      },
                    ));
                    items.add(ChatUIKitBottomSheetItem.normal(
                      label: '相机',
                      onTap: () async {
                        Navigator.of(context).pop();
                        selectCamera();
                      },
                    ));
                    items.add(ChatUIKitBottomSheetItem.normal(
                      label: '文件',
                      onTap: () async {
                        Navigator.of(context).pop();
                        selectFile();
                      },
                    ));
                    items.add(ChatUIKitBottomSheetItem.normal(
                      label: '名片',
                      onTap: () async {
                        Navigator.of(context).pop();
                        selectCard();
                      },
                    ));
                  }

                  showChatUIKitBottomSheet(context: context, items: items);
                },
                child: ChatUIKitImageLoader.moreKeyboard(),
              ),
            if (!showMoreBtn)
              InkWell(
                onTap: () {
                  String text = inputBarTextEditingController.text.trim();
                  if (text.isNotEmpty) {
                    controller.sendTextMessage(text);
                    inputBarTextEditingController.clear();
                    showMoreBtn = true;
                    setState(() {});
                  }
                },
                child: ChatUIKitImageLoader.sendKeyboard(),
              ),
          ],
        ),
      ),
    );
  }

  void onItemLongPress(Message message) {
    List<ChatUIKitBottomSheetItem>? items = widget.moreActionItems;

    if (items == null) {
      items = [];
      items.add(ChatUIKitBottomSheetItem.normal(label: '复制'));
      items.add(ChatUIKitBottomSheetItem.normal(label: '回复'));
      items.add(ChatUIKitBottomSheetItem.normal(
        label: '编辑',
        onTap: () async {
          Navigator.of(context).pop();
          textMessageEdit(message);
        },
      ));
      items.add(ChatUIKitBottomSheetItem.normal(label: '举报'));
      items.add(ChatUIKitBottomSheetItem.normal(label: '删除'));
      items.add(ChatUIKitBottomSheetItem.normal(label: '撤回'));
    }

    showChatUIKitBottomSheet(context: context, items: items);
  }

  void bubbleTab(Message message) {
    // TODO:播放音频
    debugPrint('message tapped');
  }

  void textMessageEdit(Message message) {
    if (message.bodyType != MessageType.TXT) return;
    if (showEmojiBtn) {
      showEmojiBtn = false;
    }
    messageEdit = true;
    editMessage = message;
    editBarTextEditingController =
        TextEditingController(text: editMessage?.textContent ?? "");
    setState(() {});
  }

  void selectImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        controller.sendImageMessage(image.path, name: image.name);
      }
    } catch (e) {
      // widget.onError?.call(ChatUIKitError.toChatError(
      //     ChatUIKitError.noPermission, "no image library permission"));
    }
  }

  void selectVideo() {}

  void selectCamera() {}

  void selectFile() {}

  void selectCard() async {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.95,
          child: const SelectContactView(
            backText: '取消',
            title: '选择联系人',
          ),
        );
      },
    ).then((profile) {
      if (profile != null) {
        controller.sendCardMessage(profile);
      }
    });
  }
}
