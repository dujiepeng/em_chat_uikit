import 'dart:io';

import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

typedef MessageItemBuilder = Widget? Function(
  BuildContext context,
  Message message,
);

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
  final void Function(Message message)? onItemTap;
  final void Function(Message message)? onItemLongPress;
  final void Function(Message message)? onDoubleTap;
  final void Function(Message message)? onAvatarTap;
  final void Function(Message message)? onAvatarLongPressed;
  final void Function(Message message)? onNicknameTap;
  final ChatUIKitMessageListViewBubbleStyle bubbleStyle;
  final MessageItemBuilder? itemBuilder;
  final MessageItemBuilder? alertItemBuilder;
  final bool showAvatar;
  final bool showNickname;
  final Widget Function(QuoteModel model)? quoteBuilder;
  final void Function(Message message)? onErrorTap;
  final MessageItemBubbleBuilder? bubbleBuilder;
  final MessageBubbleContentBuilder? bubbleContentBuilder;
  final bool? forceLeft;

  @override
  State<MessageListView> createState() => _MessageListViewState();
}

class _MessageListViewState extends State<MessageListView> {
  late final MessageListViewController controller;
  late final ScrollController scrollController;

  bool isFetching = false;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    controller =
        widget.controller ?? MessageListViewController(profile: widget.profile);
    controller.addListener(() {
      if (controller.lastActionType == MessageLastActionType.load) {
        setState(() {});
      }

      if ((controller.lastActionType == MessageLastActionType.receive &&
              scrollController.offset == 0) ||
          controller.lastActionType == MessageLastActionType.send) {
        setState(() {});
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (scrollController.positions.isNotEmpty) {
            scrollController.animateTo(
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
    scrollController.dispose();
    super.dispose();
  }

  void fetchMessages() async {
    if (isFetching || controller.isEmpty) return;
    isFetching = true;
    await controller.fetchItemList();
    isFetching = false;
  }

  @override
  Widget build(BuildContext context) {
    Widget content = CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: scrollController,
      reverse: true,
      slivers: [
        ChatMessageSliver(
          delegate: SliverChildBuilderDelegate(
            findChildIndexCallback: (key) {
              if (Platform.isAndroid) return null;
              if (key is ValueKey<int>) {
                final ValueKey<int> valueKey = key;
                int index = controller.msgList.indexWhere(
                  (msg) => msg.localTime == valueKey.value,
                );

                return index > -1 ? index : null;
              } else {
                return null;
              }
            },
            (context, index) {
              return SizedBox(
                key: ValueKey(controller.msgList[index].localTime),
                child: _item(controller.msgList[index]),
              );
            },
            childCount: controller.msgList.length,
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
          if (controller.hasNew && scrollController.offset < 20) {
            controller.hasNew = false;
            setState(() {});
          }
          if (scrollController.position.maxScrollExtent -
                  scrollController.offset <
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

    return content;
  }

  Widget _item(Message message) {
    controller.sendMessageReadAck(message);
    if (message.isTimeMessageAlert) {
      Widget? content = widget.alertItemBuilder?.call(
        context,
        message,
      );
      content ??= ChatUIKitMessageListViewAlertItem(
        key: ValueKey(message.localTime),
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

    if (message.isRecallAlert || message.isCreateGroupAlert) {
      if (widget.alertItemBuilder != null) {
        return widget.alertItemBuilder!.call(context, message)!;
      }
    }

    Widget? content = widget.itemBuilder?.call(context, message);
    content ??= ChatUIKitMessageListViewMessageItem(
      key: ValueKey(message.localTime),
      forceLeft: widget.forceLeft,
      bubbleContentBuilder: widget.bubbleContentBuilder,
      bubbleBuilder: widget.bubbleBuilder,
      onErrorTap: () {
        widget.onErrorTap?.call(message);
      },
      bubbleStyle: widget.bubbleStyle,
      showAvatar: widget.showAvatar,
      quoteBuilder: (model) {
        Widget? content = widget.quoteBuilder?.call(model);
        content ??= quoteWidget(model);
        return content;
      },
      showNickname: widget.showNickname,
      onAvatarTap: () {
        widget.onAvatarTap?.call(message);
      },
      onAvatarLongPressed: () {
        widget.onAvatarLongPressed?.call(message);
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
      key: ValueKey(message.localTime),
      alignment: widget.forceLeft == true
          ? Alignment.centerLeft
          : message.direction == MessageDirection.SEND
              ? Alignment.centerRight
              : Alignment.centerLeft,
      child: content,
    );

    return content;
  }

  Widget quoteWidget(QuoteModel model) {
    return ChatUIKitQuoteWidget(
      key: ValueKey(model.msgId),
      model: model,
      bubbleStyle: widget.bubbleStyle,
    );
  }
}
