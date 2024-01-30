import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

typedef MessageItemBuilder = Widget? Function(
  BuildContext context,
  Message message,
);

typedef MessageListItemTapHandler = void Function(
    BuildContext context, Message message);

class MessageListView extends StatefulWidget {
  const MessageListView({
    required this.profile,
    this.controller,
    this.onItemLongPress,
    this.onDoubleTap,
    this.onItemTap,
    this.onAvatarTap,
    this.onAvatarLongPressed,
    this.onNicknameTap,
    this.showAvatar = true,
    this.showNickname = true,
    this.itemBuilder,
    this.alertItemBuilder,
    this.bubbleStyle = ChatUIKitMessageListViewBubbleStyle.arrow,
    this.quoteBuilder,
    this.onErrorTap,
    this.bubbleBuilder,
    this.bubbleContentBuilder,
    this.forceLeft,
    super.key,
  });
  final ChatUIKitProfile profile;
  final MessageListViewController? controller;
  final MessageListItemTapHandler? onItemTap;
  final MessageListItemTapHandler? onItemLongPress;
  final MessageListItemTapHandler? onDoubleTap;
  final MessageListItemTapHandler? onAvatarTap;
  final MessageListItemTapHandler? onAvatarLongPressed;
  final MessageListItemTapHandler? onNicknameTap;
  final ChatUIKitMessageListViewBubbleStyle bubbleStyle;
  final MessageItemBuilder? itemBuilder;
  final MessageItemBuilder? alertItemBuilder;
  final bool showAvatar;
  final bool showNickname;
  final Widget Function(BuildContext context, QuoteModel model)? quoteBuilder;
  final void Function(Message message)? onErrorTap;
  final MessageItemBubbleBuilder? bubbleBuilder;
  final MessageBubbleContentBuilder? bubbleContentBuilder;
  final bool? forceLeft;

  @override
  State<MessageListView> createState() => _MessageListViewState();
}

class _MessageListViewState extends State<MessageListView> {
  late final MessageListViewController controller;
  late final AutoScrollController _scrollController;
  ChatUIKitTheme? theme;
  Size? size;

  @override
  void initState() {
    super.initState();
    _scrollController = AutoScrollController(
        // viewportBoundaryGetter: () =>
        //     Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        // axis: Axis.vertical,
        );
    controller =
        widget.controller ?? MessageListViewController(profile: widget.profile);
    controller.addListener(() {
      if (controller.lastActionType == MessageLastActionType.load) {
        setState(() {});
      }

      if ((controller.lastActionType == MessageLastActionType.receive &&
              _scrollController.offset == 0) ||
          controller.lastActionType == MessageLastActionType.send) {
        setState(() {});
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (_scrollController.positions.isNotEmpty) {
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 100),
              curve: Curves.linear,
            );
          }
        });
      }
    });
    fetchMessages();
    controller.sendConversationsReadAck();
    controller.clearMentionIfNeed();
  }

  @override
  void dispose() {
    controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void fetchMessages() {
    if (controller.isEmpty) return;
    controller.fetchItemList();
  }

  @override
  Widget build(BuildContext context) {
    theme ??= ChatUIKitTheme.of(context);
    size ??= MediaQuery.of(context).size;
    Widget content = CustomScrollView(
      controller: _scrollController,
      reverse: true,
      shrinkWrap: controller.msgList.length > 30 ? false : true,
      cacheExtent: 1500,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.zero,
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              findChildIndexCallback: (key) {
                if (key is ValueKey<String>) {
                  final ValueKey<String> valueKey = key;
                  int index = controller.msgList.indexWhere(
                    (msg) => msg.msgId == valueKey.value,
                  );
                  return index > -1 ? index : null;
                } else {
                  return null;
                }
              },
              (context, index) {
                return SizedBox(
                  key: ValueKey(controller.msgList[index].msgId),
                  child: _item(controller.msgList[index], index),
                );
              },
              childCount: controller.msgList.length,
            ),
          ),
        ),
      ],
    );

    content = MessageListShareUserData(
      data: controller.userMap,
      child: content,
    );

    content = NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          if (controller.hasNew && _scrollController.offset < 20) {
            controller.hasNew = false;
            setState(() {});
          }
          if (_scrollController.position.maxScrollExtent -
                  _scrollController.offset <
              1500) {
            fetchMessages();
          }
        }

        return false;
      },
      child: content,
    );

    content = ScrollConfiguration(
      behavior: const ScrollBehavior(),
      child: content,
    );

    content = WillPopScope(
      child: content,
      onWillPop: () async {
        controller.markAllMessageAsRead();
        return true;
      },
    );

    content = Scaffold(
      key: ValueKey(controller.profile.id),
      body: content,
      backgroundColor: theme!.color.isDark
          ? theme!.color.neutralColor1
          : theme!.color.neutralColor98,
    );

    return content;
  }

  Widget _item(Message message, int index) {
    controller.sendMessageReadAck(message);
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
                ChatUIKitTimeTool.getChatTimeStr(
                  message.serverTime,
                  needTime: true,
                ),
          )
        ],
      );
      return content;
    }

    if (message.isRecallAlert ||
        message.isCreateGroupAlert ||
        message.isDestroyGroupAlert) {
      if (widget.alertItemBuilder != null) {
        return widget.alertItemBuilder!.call(context, message)!;
      }
    }

    Widget? content = widget.itemBuilder?.call(context, message);
    content ??= ChatUIKitMessageListViewMessageItem(
      forceLeft: widget.forceLeft,
      bubbleContentBuilder: widget.bubbleContentBuilder,
      bubbleBuilder: widget.bubbleBuilder,
      onErrorTap: () {
        widget.onErrorTap?.call(message);
      },
      bubbleStyle: widget.bubbleStyle,
      showAvatar: widget.showAvatar,
      quoteBuilder: (context, model) {
        Widget? content = widget.quoteBuilder?.call(context, model);
        content ??= quoteWidget(model);
        return content;
      },
      showNickname: widget.showNickname,
      onAvatarTap: () {
        widget.onAvatarTap?.call(context, message);
      },
      onAvatarLongPressed: () {
        widget.onAvatarLongPressed?.call(context, message);
      },
      onBubbleDoubleTap: () {
        widget.onDoubleTap?.call(context, message);
      },
      onBubbleLongPressed: () {
        widget.onItemLongPress?.call(context, message);
      },
      onBubbleTap: () {
        widget.onItemTap?.call(context, message);
      },
      onNicknameTap: () {
        widget.onNicknameTap?.call(context, message);
      },
      message: message,
    );

    double zoom = 0.8;
    if (size!.width > size!.height) {
      zoom = 0.5;
    }

    content = SizedBox(
      width: size!.width * zoom,
      child: content,
    );

    content = Align(
      alignment: widget.forceLeft == true
          ? Alignment.centerLeft
          : message.direction == MessageDirection.SEND
              ? Alignment.centerRight
              : Alignment.centerLeft,
      child: content,
    );

    content = AutoScrollTag(
      key: ValueKey(message.msgId),
      controller: _scrollController,
      index: index,
      highlightColor: theme!.color.isDark
          ? theme!.color.neutralColor2
          : theme!.color.neutralColor95,
      child: content,
    );

    return content;
  }

  Widget quoteWidget(QuoteModel model) {
    return InkWell(
      onTap: () {
        jumpToQuoteModel(model);
      },
      child: ChatUIKitQuoteWidget(
        model: model,
        bubbleStyle: widget.bubbleStyle,
      ),
    );
  }

  void jumpToQuoteModel(QuoteModel model) async {
    int index = controller.msgList
        .indexWhere((element) => element.msgId == model.msgId);

    if (index != -1) {
      _scrollController.scrollToIndex(
        index,
        preferPosition: AutoScrollPosition.end,
        duration: const Duration(milliseconds: 100),
      );
      await _scrollController.scrollToIndex(
        index,
        preferPosition: AutoScrollPosition.end,
        duration: const Duration(milliseconds: 100),
      );

      await _scrollController.highlight(
        index,
        highlightDuration: const Duration(milliseconds: 100),
      );
    }
  }
}
