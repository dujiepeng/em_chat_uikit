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
  State<MessagesView> createState() => MessagesViewState();
}

class MessagesViewState extends State<MessagesView> {
  late final MessageListViewController controller;
  late final TextEditingController textEditingController;
  late final FocusNode focusNode;
  bool showEmojiBtn = false;
  bool showMoreBtn = true;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    controller = MessageListViewController(profile: widget.profile);
    focusNode = widget.focusNode ?? FocusNode();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        showEmojiBtn = false;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      itemBuilder: widget.itemBuilder ??
          (profile, message) {
            if (message.bodyType == MessageType.VOICE) {
              return ChatUIKitMessageListViewMessageItem(
                bubbleStyle: widget.bubbleStyle,
                key: ValueKey(message.msgId),
                showAvatar: widget.showAvatar,
                showNickname: widget.showNickname,
                onAvatarTap: () {
                  widget.onAvatarTap?.call(widget.profile);
                },
                onBubbleDoubleTap: () {
                  widget.onDoubleTap?.call(message);
                },
                onBubbleLongPressed: () {
                  widget.onItemLongPress?.call(message);
                },
                onBubbleTap: () {
                  widget.onItemTap?.call(message);
                },
                onNicknameTap: () {
                  widget.onNicknameTap?.call(widget.profile);
                },
                message: message,
              );
            } else {
              return null;
            }
          },
    );

    content = Column(
      children: [
        Expanded(
            child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: content)),
        widget.inputBar ?? inputBar(),
        AnimatedContainer(
          curve: Curves.linearToEaseOut,
          duration: const Duration(milliseconds: 250),
          height: showEmojiBtn ? 230 : 0,
          child: showEmojiBtn
              ? widget.emojiWidget ?? const ChatInputEmoji()
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

  Widget inputBar() {
    return ChatUIKitInputBar(
      onChanged: (input) {
        showMoreBtn = !input.trim().isNotEmpty;
        setState(() {});
      },
      focusNode: focusNode,
      textEditingController: textEditingController,
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
                    items.add(ChatUIKitBottomSheetItem.normal(label: '相册'));
                    items.add(ChatUIKitBottomSheetItem.normal(label: '视频'));
                    items.add(ChatUIKitBottomSheetItem.normal(label: '相机'));
                    items.add(ChatUIKitBottomSheetItem.normal(label: '文件'));
                    items.add(ChatUIKitBottomSheetItem.normal(label: '名片'));
                  }

                  showChatUIKitBottomSheet(context: context, items: items);
                },
                child: ChatUIKitImageLoader.moreKeyboard(),
              ),
            if (!showMoreBtn)
              InkWell(
                onTap: () {
                  String text = textEditingController.text.trim();
                  if (text.isNotEmpty) {
                    controller.sendTextMessage(text);
                    textEditingController.clear();
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
      items.add(ChatUIKitBottomSheetItem.normal(label: '编辑'));
      items.add(ChatUIKitBottomSheetItem.normal(label: '举报'));
      items.add(ChatUIKitBottomSheetItem.normal(label: '删除'));
      items.add(ChatUIKitBottomSheetItem.normal(label: '撤回'));
    }

    showChatUIKitBottomSheet(context: context, items: items);
  }
}
