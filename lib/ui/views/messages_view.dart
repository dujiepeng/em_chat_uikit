import 'dart:io';

import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit/ui/custom/chat_uikit_emoji_data.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        alertItemBuilder = arguments.alertItemBuilder,
        onAvatarLongPress = arguments.onAvatarLongPressed,
        moreActionItems = arguments.moreActionItems,
        onItemLongPressActions = arguments.onItemLongPressActions,
        replyBarBuilder = arguments.replyBarBuilder,
        quoteBuilder = arguments.quoteBuilder,
        onErrorTap = arguments.onErrorTap,
        bubbleBuilder = arguments.bubbleBuilder,
        enableAppBar = arguments.enableAppBar,
        onMoreActionsItemsHandler = arguments.onMoreActionsItemsHandler,
        onItemLongPressActionsItemsHandler =
            arguments.onItemLongPressActionsItemsHandler,
        bubbleContentBuilder = arguments.bubbleContentBuilder,
        forceLeft = arguments.forceLeft,
        attributes = arguments.attributes;

  const MessagesView({
    required this.profile,
    this.appBar,
    this.inputBar,
    this.controller,
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
    this.alertItemBuilder,
    this.bubbleStyle = ChatUIKitMessageListViewBubbleStyle.arrow,
    this.onItemLongPressActions,
    this.moreActionItems,
    this.replyBarBuilder,
    this.quoteBuilder,
    this.onErrorTap,
    this.bubbleBuilder,
    this.bubbleContentBuilder,
    this.enableAppBar = true,
    this.onMoreActionsItemsHandler,
    this.onItemLongPressActionsItemsHandler,
    this.forceLeft,
    this.attributes,
    super.key,
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
  final void Function(Message message)? onAvatarTap;
  final void Function(Message message)? onAvatarLongPress;
  final void Function(Message message)? onNicknameTap;
  final ChatUIKitMessageListViewBubbleStyle bubbleStyle;
  final MessageItemBuilder? itemBuilder;
  final MessageItemBuilder? alertItemBuilder;
  final FocusNode? focusNode;
  final List<ChatUIKitBottomSheetItem>? moreActionItems;
  final List<ChatUIKitBottomSheetItem>? Function(
    BuildContext context,
    List<ChatUIKitBottomSheetItem> willShowList,
  )? onMoreActionsItemsHandler;
  final List<ChatUIKitBottomSheetItem>? onItemLongPressActions;
  final List<ChatUIKitBottomSheetItem>? Function(
    BuildContext context,
    List<ChatUIKitBottomSheetItem> willShowList,
    Message message,
  )? onItemLongPressActionsItemsHandler;
  final bool? forceLeft;

  final Widget? emojiWidget;
  final Widget? Function(BuildContext context, Message message)?
      replyBarBuilder;
  final Widget Function(QuoteModel model)? quoteBuilder;
  final void Function(Message message)? onErrorTap;
  final MessageItemBubbleBuilder? bubbleBuilder;
  final MessageBubbleContentBuilder? bubbleContentBuilder;
  final bool enableAppBar;
  final String? attributes;

  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  late final MessageListViewController controller;
  late final CustomTextEditingController inputBarTextEditingController;

  late final FocusNode focusNode;
  bool showEmoji = false;
  bool showMoreBtn = true;
  late final ImagePicker _picker;

  late final AudioPlayer _player;

  bool messageEditCanSend = false;
  TextEditingController? editBarTextEditingController;
  Message? editMessage;
  Message? replyMessage;

  Message? _playingMessage;

  @override
  void initState() {
    super.initState();
    inputBarTextEditingController = CustomTextEditingController();
    inputBarTextEditingController.addListener(() {
      if (showMoreBtn !=
          !inputBarTextEditingController.text.trim().isNotEmpty) {
        showMoreBtn = !inputBarTextEditingController.text.trim().isNotEmpty;
        setState(() {});
      }
      if (inputBarTextEditingController.needMention) {
        if (widget.profile.type == ChatUIKitProfileType.groupChat) {
          needMention();
        }
      }
    });
    controller = MessageListViewController(profile: widget.profile);
    focusNode = widget.focusNode ?? FocusNode();
    _picker = ImagePicker();
    _player = AudioPlayer();
    focusNode.addListener(() {
      if (editMessage != null) return;
      if (focusNode.hasFocus) {
        showEmoji = false;
        setState(() {});
      }
    });
  }

  void needMention() {
    // clearAllType();
    if (controller.conversationType == ConversationType.GroupChat) {
      Navigator.of(context)
          .pushNamed(
        ChatUIKitRouteNames.groupMentionView,
        arguments: GroupMentionViewArguments(groupId: controller.profile.id),
      )
          .then((value) {
        if (value != null) {
          if (value == true) {
            inputBarTextEditingController.atAll();
          } else if (value is ChatUIKitProfile) {
            inputBarTextEditingController.addUser(value);
          }
        }
      });
    }
  }

  @override
  void dispose() {
    editBarTextEditingController?.dispose();
    inputBarTextEditingController.dispose();
    _player.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);

    Widget content = MessageListView(
      forceLeft: widget.forceLeft,
      bubbleContentBuilder: widget.bubbleContentBuilder,
      bubbleBuilder: widget.bubbleBuilder,
      quoteBuilder: widget.quoteBuilder ?? quoteWidget,
      profile: widget.profile,
      controller: controller,
      showAvatar: widget.showAvatar,
      showNickname: widget.showNickname,
      onItemTap: widget.onItemTap ?? bubbleTab,
      onItemLongPress: widget.onItemLongPress ?? onItemLongPress,
      onDoubleTap: widget.onDoubleTap,
      onAvatarTap: widget.onAvatarTap ?? avatarTap,
      onAvatarLongPressed: widget.onAvatarLongPress,
      onNicknameTap: widget.onNicknameTap,
      bubbleStyle: widget.bubbleStyle,
      itemBuilder: widget.itemBuilder ?? voiceItemBuilder,
      alertItemBuilder: widget.alertItemBuilder ?? alertItem,
      onErrorTap: widget.onErrorTap ?? onErrorTap,
    );

    content = NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          if (showEmoji) {
            showEmoji = false;
            if (mounted) {
              setState(() {});
            }
          }
          if (focusNode.hasFocus) {
            focusNode.unfocus();
          }
        }
        return false;
      },
      child: content,
    );

    content = Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: content,
          ),
        ),
        if (replyMessage != null) replyMessageBar(theme),
        widget.inputBar ?? inputBar(),
        AnimatedContainer(
          curve: Curves.linearToEaseOut,
          duration: const Duration(milliseconds: 250),
          height: showEmoji ? 230 : 0,
          child: showEmoji
              ? widget.emojiWidget ??
                  ChatUIKitInputEmojiBar(
                    deleteOnTap: () {
                      inputBarTextEditingController.deleteTextOnCursor();
                    },
                    emojiClicked: (emoji) {
                      final index = ChatUIKitEmojiData.emojiImagePaths
                          .indexWhere((element) => element == emoji);
                      if (index != -1) {
                        inputBarTextEditingController
                            .addText(ChatUIKitEmojiData.emojiList[index]);
                      }
                    },
                  )
              : const SizedBox(),
        ),
      ],
    );

    content = SafeArea(
      child: content,
    );

    content = Scaffold(
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: !widget.enableAppBar
          ? null
          : widget.appBar ??
              ChatUIKitAppBar(
                title: widget.profile.showName,
                leading: InkWell(
                  onTap: () {
                    pushNextPage(widget.profile);
                  },
                  child: ChatUIKitAvatar(
                    avatarUrl: widget.profile.avatarUrl,
                  ),
                ),
              ),
      // body: content,
      body: content,
    );

    content = Stack(
      children: [
        content,
        if (editMessage != null)
          Positioned.fill(
            child: InkWell(
              onTap: () {
                editMessage = null;
                setState(() {});
              },
              child: Opacity(
                opacity: 0.5,
                child: Container(color: Colors.black),
              ),
            ),
          ),
        if (editMessage != null)
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: editMessageBar(theme),
              )
            ],
          ),
      ],
    );

    return content;
  }

  Widget? voiceItemBuilder(BuildContext context, Message message) {
    if (message.bodyType != MessageType.VOICE) return null;

    Widget content = ChatUIKitMessageListViewMessageItem(
      isPlaying: _playingMessage?.msgId == message.msgId,
      onErrorTap: () {
        if (widget.onErrorTap == null) {
          onErrorTap(message);
        } else {
          widget.onErrorTap!.call(message);
        }
      },
      bubbleStyle: widget.bubbleStyle,
      key: ValueKey(message.localTime),
      showAvatar: widget.showAvatar,
      quoteBuilder: widget.quoteBuilder,
      showNickname: widget.showNickname,
      onAvatarTap: () {
        if (widget.onAvatarTap == null) {
          avatarTap(message);
        } else {
          widget.onAvatarTap!.call(message);
        }
      },
      onAvatarLongPressed: () {
        widget.onAvatarLongPress?.call(message);
      },
      onBubbleDoubleTap: () {
        widget.onDoubleTap?.call(message);
      },
      onBubbleLongPressed: () {
        if (widget.onItemLongPress == null) {
          onItemLongPress(message);
        } else {
          widget.onItemLongPress!.call(message);
        }
      },
      onBubbleTap: () {
        if (widget.onItemTap == null) {
          bubbleTab(message);
        } else {
          widget.onItemTap!.call(message);
        }
      },
      onNicknameTap: () {
        widget.onNicknameTap?.call(message);
      },
      message: message,
    );

    double zoom = 0.8;
    if (MediaQuery.of(context).size.width >
        MediaQuery.of(context).size.height) {
      zoom = 0.5;
    }

    content = SizedBox(
      width: MediaQuery.of(context).size.width * zoom,
      child: content,
    );

    content = Align(
      alignment: message.direction == MessageDirection.SEND
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: content,
    );

    return content;
  }

  Widget alertItem(
    BuildContext context,
    Message message,
  ) {
    if (message.isTimeMessageAlert) {
      Widget? content = widget.alertItemBuilder?.call(
        context,
        message,
      );
      content ??= ChatUIKitMessageListViewAlertItem(
        infos: [
          MessageAlertAction(
            text: ChatUIKitTimeFormatter.instance.formatterHandler?.call(
                    context, ChatUIKitTimeType.message, message.serverTime) ??
                ChatUIKitTimeTool.getChatTimeStr(message.serverTime,
                    needTime: true),
          )
        ],
      );
      return content;
    }

    if (message.isRecallAlert) {
      Map<String, String>? map = (message.body as CustomMessageBody).params;
      Widget? content = widget.alertItemBuilder?.call(
        context,
        message,
      );
      content ??= ChatUIKitMessageListViewAlertItem(
        infos: [
          MessageAlertAction(text: map?[alertRecallNameKey] ?? '撤回一条消息'),
        ],
      );
      return content;
    }

    if (message.isCreateGroupAlert) {
      Map<String, String>? map = (message.body as CustomMessageBody).params;
      Widget? content = widget.alertItemBuilder?.call(
        context,
        message,
      );
      content ??= ChatUIKitMessageListViewAlertItem(
        infos: [
          MessageAlertAction(
            text: map?[alertCreateGroupMessageOwnerKey] ?? '',
            onTap: () {
              ChatUIKitProfile profile = ChatUIKitProvider.instance
                  .groupMemberProfile(message.conversationId!,
                      map![alertCreateGroupMessageOwnerKey]!);
              pushNextPage(profile);
            },
          ),
          MessageAlertAction(text: ' 创建群组 '),
          MessageAlertAction(
            text: map?[alertCreateGroupMessageGroupNameKey] ?? '',
            onTap: () {
              pushNextPage(widget.profile);
            },
          ),
        ],
      );
      return content;
    }

    return const SizedBox();
  }

  Widget replyMessageBar(ChatUIKitTheme theme) {
    return widget.replyBarBuilder?.call(context, replyMessage!) ??
        ChatUIKitReplyBar(
          message: replyMessage!,
          onCancelTap: () {
            replyMessage = null;
            setState(() {});
          },
        );
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
          if (!messageEditCanSend) return;
          String text = editBarTextEditingController?.text.trim() ?? '';
          if (text.isNotEmpty) {
            controller.editMessage(editMessage!, text);
            editBarTextEditingController?.clear();
            editMessage = null;
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

    content = SafeArea(child: content);

    return content;
  }

  Widget quoteWidget(QuoteModel model) {
    return ChatUIKitQuoteWidget(
      model: model,
      bubbleStyle: widget.bubbleStyle,
    );
  }

  Widget inputBar() {
    final theme = ChatUIKitTheme.of(context);
    return ChatUIKitInputBar(
      key: const ValueKey('inputKey'),
      focusNode: focusNode,
      textEditingController: inputBarTextEditingController,
      leading: InkWell(
        onTap: () async {
          focusNode.unfocus();
          showEmoji = false;
          setState(() {});
          ChatUIKitRecordModel? model = await showChatUIKitRecordBar(
            context: context,
            statusChangeCallback: (type, duration, path) {
              if (type == ChatUIKitVoiceBarStatusType.playing) {
                // 播放录音
                previewVoice(true, path: path);
              } else if (type == ChatUIKitVoiceBarStatusType.ready) {
                // 停止播放
                previewVoice(false);
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
            if (!showEmoji)
              InkWell(
                onTap: () {
                  focusNode.unfocus();
                  showEmoji = !showEmoji;
                  setState(() {});
                },
                child: ChatUIKitImageLoader.faceKeyboard(),
              ),
            if (showEmoji)
              InkWell(
                onTap: () {
                  showEmoji = !showEmoji;
                  setState(() {});
                },
                child: ChatUIKitImageLoader.textKeyboard(),
              ),
            const SizedBox(width: 8),
            if (showMoreBtn)
              InkWell(
                onTap: () {
                  clearAllType();
                  List<ChatUIKitBottomSheetItem>? items =
                      widget.moreActionItems;
                  if (items == null) {
                    items = [];
                    items.add(ChatUIKitBottomSheetItem.normal(
                      label: '相册',
                      icon: ChatUIKitImageLoader.messageViewMoreAlum(
                        color: theme.color.isDark
                            ? theme.color.primaryColor6
                            : theme.color.primaryColor5,
                      ),
                      onTap: () async {
                        Navigator.of(context).pop();
                        selectImage();
                      },
                    ));
                    items.add(ChatUIKitBottomSheetItem.normal(
                      label: '视频',
                      icon: ChatUIKitImageLoader.messageViewMoreVideo(
                        color: theme.color.isDark
                            ? theme.color.primaryColor6
                            : theme.color.primaryColor5,
                      ),
                      onTap: () async {
                        Navigator.of(context).pop();
                        selectVideo();
                      },
                    ));
                    items.add(ChatUIKitBottomSheetItem.normal(
                      label: '相机',
                      icon: ChatUIKitImageLoader.messageViewMoreCamera(
                        color: theme.color.isDark
                            ? theme.color.primaryColor6
                            : theme.color.primaryColor5,
                      ),
                      onTap: () async {
                        Navigator.of(context).pop();
                        selectCamera();
                      },
                    ));
                    items.add(ChatUIKitBottomSheetItem.normal(
                      label: '文件',
                      icon: ChatUIKitImageLoader.messageViewMoreFile(
                        color: theme.color.isDark
                            ? theme.color.primaryColor6
                            : theme.color.primaryColor5,
                      ),
                      onTap: () async {
                        Navigator.of(context).pop();
                        selectFile();
                      },
                    ));
                    items.add(ChatUIKitBottomSheetItem.normal(
                      label: '名片',
                      icon: ChatUIKitImageLoader.messageViewMoreCard(
                        color: theme.color.isDark
                            ? theme.color.primaryColor6
                            : theme.color.primaryColor5,
                      ),
                      onTap: () async {
                        Navigator.of(context).pop();
                        selectCard();
                      },
                    ));
                  }

                  if (widget.onMoreActionsItemsHandler != null) {
                    items = widget.onMoreActionsItemsHandler!.call(
                      context,
                      items,
                    );
                  }
                  if (items != null) {
                    showChatUIKitBottomSheet(context: context, items: items);
                  }
                },
                child: ChatUIKitImageLoader.moreKeyboard(),
              ),
            if (!showMoreBtn)
              InkWell(
                onTap: () {
                  String text = inputBarTextEditingController.text.trim();
                  if (text.isNotEmpty) {
                    dynamic mention;
                    if (inputBarTextEditingController.isAtAll &&
                        text.contains("@All")) {
                      mention = true;
                    }

                    if (inputBarTextEditingController.mentionList.isNotEmpty) {
                      List<String> mentionList = [];
                      List<ChatUIKitProfile> list =
                          inputBarTextEditingController.getMentionList();
                      for (var element in list) {
                        if (text.contains('@${element.showName}')) {
                          mentionList.add(element.id);
                        }
                      }
                      mention = mentionList;
                    }

                    controller.sendTextMessage(
                      text,
                      replay: replyMessage,
                      mention: mention,
                    );
                    inputBarTextEditingController.clearMentions();
                    inputBarTextEditingController.clear();
                    if (replyMessage != null) {
                      replyMessage = null;
                    }
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

  void clearAllType() {
    showEmoji = false;
    editMessage = null;
    replyMessage = null;
    focusNode.unfocus();
    setState(() {});
  }

  void onItemLongPress(Message message) {
    final theme = ChatUIKitTheme.of(context);
    clearAllType();
    List<ChatUIKitBottomSheetItem>? items = widget.onItemLongPressActions;
    if (items == null) {
      items = [];
      if (message.bodyType == MessageType.TXT) {
        items.add(ChatUIKitBottomSheetItem.normal(
          label: '复制',
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.neutralColor98
                : theme.color.neutralColor1,
            fontWeight: theme.font.bodyLarge.fontWeight,
            fontSize: theme.font.bodyLarge.fontSize,
          ),
          icon: ChatUIKitImageLoader.messageLongPressCopy(
            color: theme.color.isDark
                ? theme.color.neutralColor7
                : theme.color.neutralColor3,
          ),
          onTap: () async {
            Clipboard.setData(ClipboardData(text: message.textContent));
            ChatUIKit.instance.sendChatUIKitEvent(ChatUIKitEvent.messageCopied);
            Navigator.of(context).pop();
          },
        ));
      }

      items.add(ChatUIKitBottomSheetItem.normal(
        icon: ChatUIKitImageLoader.messageLongPressReply(
          color: theme.color.isDark
              ? theme.color.neutralColor7
              : theme.color.neutralColor3,
        ),
        style: TextStyle(
          color: theme.color.isDark
              ? theme.color.neutralColor98
              : theme.color.neutralColor1,
          fontWeight: theme.font.bodyLarge.fontWeight,
          fontSize: theme.font.bodyLarge.fontSize,
        ),
        label: '回复',
        onTap: () async {
          Navigator.of(context).pop();
          replyMessaged(message);
        },
      ));
      if (message.bodyType == MessageType.TXT &&
          message.direction == MessageDirection.SEND) {
        items.add(ChatUIKitBottomSheetItem.normal(
          label: '编辑',
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.neutralColor98
                : theme.color.neutralColor1,
            fontWeight: theme.font.bodyLarge.fontWeight,
            fontSize: theme.font.bodyLarge.fontSize,
          ),
          icon: ChatUIKitImageLoader.messageLongPressEdit(
            color: theme.color.isDark
                ? theme.color.neutralColor7
                : theme.color.neutralColor3,
          ),
          onTap: () async {
            Navigator.of(context).pop();
            textMessageEdit(message);
          },
        ));
      }

      items.add(ChatUIKitBottomSheetItem.normal(
        label: '举报',
        style: TextStyle(
          color: theme.color.isDark
              ? theme.color.neutralColor98
              : theme.color.neutralColor1,
          fontWeight: theme.font.bodyLarge.fontWeight,
          fontSize: theme.font.bodyLarge.fontSize,
        ),
        icon: ChatUIKitImageLoader.messageLongPressReport(
          color: theme.color.isDark
              ? theme.color.neutralColor7
              : theme.color.neutralColor3,
        ),
        onTap: () async {
          Navigator.of(context).pop();
          reportMessage(message);
        },
      ));
      items.add(ChatUIKitBottomSheetItem.normal(
        label: '删除',
        style: TextStyle(
          color: theme.color.isDark
              ? theme.color.neutralColor98
              : theme.color.neutralColor1,
          fontWeight: theme.font.bodyLarge.fontWeight,
          fontSize: theme.font.bodyLarge.fontSize,
        ),
        icon: ChatUIKitImageLoader.messageLongPressDelete(
          color: theme.color.isDark
              ? theme.color.neutralColor7
              : theme.color.neutralColor3,
        ),
        onTap: () async {
          Navigator.of(context).pop();
          deleteMessage(message);
        },
      ));

      if (message.direction == MessageDirection.SEND &&
          message.serverTime >=
              DateTime.now().millisecondsSinceEpoch -
                  ChatUIKitSettings.recallExpandTime * 1000) {
        items.add(ChatUIKitBottomSheetItem.normal(
          label: '撤回',
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.neutralColor98
                : theme.color.neutralColor1,
            fontWeight: theme.font.bodyLarge.fontWeight,
            fontSize: theme.font.bodyLarge.fontSize,
          ),
          icon: ChatUIKitImageLoader.messageLongPressRecall(
            color: theme.color.isDark
                ? theme.color.neutralColor7
                : theme.color.neutralColor3,
          ),
          onTap: () async {
            Navigator.of(context).pop();
            recallMessage(message);
          },
        ));
      }
    }

    if (widget.onItemLongPressActionsItemsHandler != null) {
      items = widget.onItemLongPressActionsItemsHandler!.call(
        context,
        items,
        message,
      );
    }
    if (items != null) {
      showChatUIKitBottomSheet(context: context, items: items);
    }
  }

  void avatarTap(Message message) async {
    ChatUIKitProfile profile = ChatUIKitProvider.instance.conversationProfile(
      message.from!,
      ConversationType.values[message.chatType.index],
    );

    pushNextPage(profile);
  }

  void bubbleTab(Message message) async {
    if (message.bodyType == MessageType.IMAGE) {
      Navigator.of(context).pushNamed(
        ChatUIKitRouteNames.showImageView,
        arguments: ShowImageViewArguments(
          message: message,
          attributes: widget.attributes,
        ),
      );
    } else if (message.bodyType == MessageType.VIDEO) {
      Navigator.of(context).pushNamed(
        ChatUIKitRouteNames.showVideoView,
        arguments: ShowVideoViewArguments(
          message: message,
          attributes: widget.attributes,
        ),
      );
    }

    if (message.bodyType == MessageType.VOICE) {
      playVoiceMessage(message);
    }

    if (message.bodyType == MessageType.CUSTOM && message.isCardMessage) {
      String? userId =
          (message.body as CustomMessageBody).params?[cardContactUserId];
      String avatar =
          (message.body as CustomMessageBody).params?[cardContactAvatar] ?? '';
      String name =
          (message.body as CustomMessageBody).params?[cardContactNickname] ??
              '';
      if (userId?.isNotEmpty == true) {
        ChatUIKitProfile profile = ChatUIKitProfile(
          id: userId!,
          avatarUrl: avatar,
          name: name,
        );
        pushNextPage(profile);
      }
    }
  }

  void onErrorTap(Message message) {
    controller.resendMessage(message);
  }

  void textMessageEdit(Message message) {
    clearAllType();
    if (message.bodyType != MessageType.TXT) return;

    editMessage = message;
    editBarTextEditingController =
        TextEditingController(text: editMessage?.textContent ?? "");
    setState(() {});
  }

  void replyMessaged(Message message) {
    clearAllType();
    focusNode.requestFocus();
    replyMessage = message;
    setState(() {});
  }

  void deleteMessage(Message message) async {
    final delete = await showChatUIKitDialog(
      title: "确认删除这条消息?",
      content: "删除后，对方依旧可以看到这条消息。",
      context: context,
      items: [
        ChatUIKitDialogItem.cancel(
          label: '取消',
          onTap: () async {
            Navigator.of(context).pop();
          },
        ),
        ChatUIKitDialogItem.confirm(
          label: '确认',
          onTap: () async {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
    if (delete == true) {
      controller.deleteMessage(message.msgId);
    }
  }

  void recallMessage(Message message) async {
    final recall = await showChatUIKitDialog(
      title: "确认撤回这条消息?",
      context: context,
      items: [
        ChatUIKitDialogItem.cancel(
          label: '取消',
          onTap: () async {
            Navigator.of(context).pop();
          },
        ),
        ChatUIKitDialogItem.confirm(
          label: '确认',
          onTap: () async {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
    if (recall == true) {
      try {
        controller.recallMessage(message);
        // ignore: empty_catches
      } catch (e) {}
    }
  }

  void selectImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        controller.sendImageMessage(image.path, name: image.name);
      }
    } catch (e) {
      ChatUIKit.instance.sendChatUIKitEvent(ChatUIKitEvent.noStoragePermission);
      // widget.onError?.call(ChatUIKitError.toChatError(
      //     ChatUIKitError.noPermission, "no image library permission"));
    }
  }

  void selectVideo() async {
    try {
      XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        controller.sendVideoMessage(video.path, name: video.name);
      }
    } catch (e) {
      ChatUIKit.instance.sendChatUIKitEvent(ChatUIKitEvent.noStoragePermission);
      // widget.onError?.call(ChatUIKitError.toChatError(
      //     ChatUIKitError.noPermission, "no image library permission"));
    }
  }

  void selectCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        controller.sendImageMessage(photo.path, name: photo.name);
      }
    } catch (e) {
      ChatUIKit.instance.sendChatUIKitEvent(ChatUIKitEvent.noStoragePermission);
    }
  }

  void selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile file = result.files.single;
      if (file.path?.isNotEmpty == true) {
        controller.sendFileMessage(
          file.path!,
          name: file.name,
          fileSize: file.size,
        );
      }
    }
  }

  void selectCard() async {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.95,
          child: SelectContactView(
            backText: '取消',
            title: '选择联系人',
            onTap: (context, model) {
              showChatUIKitDialog(
                title: '分享联系人',
                content: '确定分享给${model.showName}给${widget.profile.showName}吗？',
                context: context,
                items: [
                  ChatUIKitDialogItem.cancel(
                    label: '取消',
                    onTap: () async {
                      Navigator.of(context).pop();
                    },
                  ),
                  ChatUIKitDialogItem.confirm(
                    label: '确认',
                    onTap: () async {
                      Navigator.of(context).pop(model);
                    },
                  )
                ],
              ).then((value) {
                if (value != null) {
                  Navigator.of(context).pop();
                  if (value is ContactItemModel) {
                    controller.sendCardMessage(value.profile);
                  }
                }
              });
            },
          ),
        );
      },
    );
  }

  Future<void> playVoiceMessage(Message message) async {
    if (_playingMessage?.msgId == message.msgId) {
      _playingMessage = null;
      await stopVoice();
    } else {
      await stopVoice();
      File file = File(message.localPath!);
      if (!file.existsSync()) {
        await controller.downloadMessage(message);
        ChatUIKit.instance
            .sendChatUIKitEvent(ChatUIKitEvent.messageDownloading);
      } else {
        if (message.localPath?.endsWith('aac') == true) {
          try {
            await playVoice(message.localPath!);
            _playingMessage = message;
            // ignore: empty_catches
          } catch (e) {
            debugPrint('playVoice: $e');
          }
        } else {
          _playingMessage = null;
          ChatUIKit.instance.sendChatUIKitEvent(
            ChatUIKitEvent.voiceTypeNotSupported,
          );
        }
      }
    }
    setState(() {});
  }

  Future<void> previewVoice(bool play, {String? path}) async {
    if (play) {
      await playVoice(path!);
    } else {
      await stopVoice();
    }
  }

  Future<void> playVoice(String path) async {
    if (_player.state == PlayerState.playing) {
      await _player.stop();
    }

    await _player.play(DeviceFileSource(path));
    _player.onPlayerComplete.first.whenComplete(() async {
      _playingMessage = null;
      setState(() {});
    }).onError((error, stackTrace) {});
  }

  Future<void> stopVoice() async {
    if (_player.state == PlayerState.playing) {
      await _player.stop();
      _playingMessage = null;
    }
  }

  void reportMessage(Message message) async {
    Map<String, String> reasons =
        ChatUIKitSettings.reportMessageReason.call(context);
    List<String> reasonKeys = reasons.keys.toList();
    final reportReason = await Navigator.of(context).pushNamed(
      ChatUIKitRouteNames.reportMessageView,
      arguments: ReportMessageViewArguments(
        messageId: message.msgId,
        reportReasons: reasonKeys.map((e) => reasons[e]!).toList(),
        attributes: widget.attributes,
      ),
    );
    if (reportReason != null && reportReason is String) {
      String? tag;
      for (var entry in reasons.entries) {
        if (entry.value == reportReason) {
          tag = entry.key;
          break;
        }
      }
      if (tag == null) return;
      controller.reportMessage(
        message: message,
        tag: tag,
        reason: reportReason,
      );
    }
  }

  void pushNextPage(ChatUIKitProfile profile) async {
    clearAllType();

    // 如果是自己
    if (profile.id == ChatUIKit.instance.currentUserId()) {
      pushToCurrentUser(profile);
    }
    // 如果是当前聊天对象
    else if (controller.profile.id == profile.id) {
      // 当前聊天对象是群聊
      if (controller.conversationType == ConversationType.GroupChat) {
        pushToGroupInfo(profile);
      }
      // 当前聊天对象，是单聊
      else {
        pushCurrentChatter(profile);
      }
    }
    // 以上都不是时，检查通讯录
    else {
      List<String> contacts = await ChatUIKit.instance.getAllContacts();
      // 是好友，不是当前聊天对象，跳转到好友页面，并可以发消息
      if (contacts.contains(profile.id)) {
        pushNewContactDetail(profile);
      }
      // 不是好友，跳转到添加好友页面
      else {
        pushRequestDetail(profile);
      }
    }
  }

// 处理点击自己头像和点击自己名片
  void pushToCurrentUser(ChatUIKitProfile profile) {
    Navigator.of(context).pushNamed(
      ChatUIKitRouteNames.currentUserInfoView,
      arguments: CurrentUserInfoViewArguments(
        profile: profile,
        attributes: widget.attributes,
      ),
    );
  }

  // 处理当前聊天对象，点击appBar头像，点击对方消息头像，点击名片
  void pushCurrentChatter(ChatUIKitProfile profile) {
    Navigator.of(context).pushNamed(
      ChatUIKitRouteNames.contactDetailsView,
      arguments: ContactDetailsViewArguments(
        attributes: widget.attributes,
        onMessageDidClear: () {
          replyMessage = null;
          controller.clearMessages();
          setState(() {});
        },
        profile: widget.profile,
        actions: [
          ChatUIKitActionItem(
            title: ChatUIKitLocal.contactDetailViewSend.getString(context),
            icon: 'assets/images/chat.png',
            onTap: (context) {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  // 处理当前聊天对象是群时
  void pushToGroupInfo(ChatUIKitProfile profile) {
    Navigator.of(context).pushNamed(
      ChatUIKitRouteNames.groupDetailsView,
      arguments: GroupDetailsViewArguments(
        profile: widget.profile,
        attributes: widget.attributes,
        actions: [
          ChatUIKitActionItem(
            title: ChatUIKitLocal.groupDetailViewSend.getString(context),
            icon: 'assets/images/chat.png',
            onTap: (context) {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  // 处理不是当前聊天对象的好友
  void pushNewContactDetail(ChatUIKitProfile profile) {
    Navigator.of(context).pushNamed(
      ChatUIKitRouteNames.contactDetailsView,
      arguments: ContactDetailsViewArguments(
        profile: profile,
        attributes: widget.attributes,
        actions: [
          ChatUIKitActionItem(
            title: ChatUIKitLocal.contactDetailViewSend.getString(context),
            icon: 'assets/images/chat.png',
            onTap: (ctx) {
              Navigator.of(context).pushNamed(
                ChatUIKitRouteNames.messagesView,
                arguments: MessagesViewArguments(
                  profile: profile,
                  attributes: widget.attributes,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // 处理名片信息非好友
  void pushRequestDetail(ChatUIKitProfile profile) {
    Navigator.of(context).pushNamed(
      ChatUIKitRouteNames.newRequestDetailsView,
      arguments: NewRequestDetailsViewArguments(
        profile: profile,
        attributes: widget.attributes,
      ),
    );
  }
}
