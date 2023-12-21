import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

typedef MessageItemBuilder = Widget? Function(
  BuildContext context,
  ChatUIKitProfile profile,
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
    super.key,
  });
  final ChatUIKitProfile profile;
  final MessageListViewController? controller;
  final void Function(Message message)? onItemTap;
  final void Function(Message message)? onItemLongPress;
  final void Function(Message message)? onDoubleTap;
  final void Function(ChatUIKitProfile profile)? onAvatarTap;
  final void Function(ChatUIKitProfile profile)? onAvatarLongPressed;
  final void Function(ChatUIKitProfile profile)? onNicknameTap;
  final ChatUIKitMessageListViewBubbleStyle bubbleStyle;
  final MessageItemBuilder? itemBuilder;
  final MessageItemBuilder? alertItemBuilder;
  final bool showAvatar;
  final bool showNickname;
  final Widget Function(QuoteModel model)? quoteBuilder;

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
        if (mounted) {
          setState(() {});
        }
      }

      if ((controller.lastActionType == MessageLastActionType.receive &&
              scrollController.offset == 0) ||
          controller.lastActionType == MessageLastActionType.send) {
        if (mounted) {
          setState(() {});
        }
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 100),
            curve: Curves.linear,
          );
        });
      }
    });
    fetchMessages();
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
              final ValueKey<String> valueKey = key as ValueKey<String>;
              int index = controller.msgList
                  .indexWhere((msg) => msg.msgId == valueKey.value);

              return index > -1 ? index : null;
            },
            (context, index) {
              return _item(controller.msgList[index]);
            },
            childCount: controller.msgList.length,
          ),
        ),
      ],
    );

    content = NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          if (controller.hasNew && scrollController.offset == 0) {
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

    return content;
  }

  Widget _item(Message message) {
    if (message.isTimeMessageAlert) {
      Widget? content = widget.alertItemBuilder?.call(
        context,
        widget.profile,
        message,
      );
      content ??= ChatUIKitMessageListViewAlertItem(
        infos: [
          MessageAlertAction(
            text: ChatUIKitTimeTool.getChatTimeStr(message.serverTime),
          )
        ],
      );
      return content;
    }

    if (message.isRecallAlert) {
      Map<String, String>? map = (message.body as CustomMessageBody).params;
      Widget? content = widget.alertItemBuilder?.call(
        context,
        widget.profile,
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
        widget.profile,
        message,
      );
      content ??= ChatUIKitMessageListViewAlertItem(
        infos: [
          MessageAlertAction(text: map?[alertCreateGroupMessageOwnerKey] ?? ''),
          MessageAlertAction(text: ' 创建群组 '),
          MessageAlertAction(
              text: map?[alertCreateGroupMessageGroupNameKey] ?? ''),
        ],
      );
      return content;
    }

    Widget? content =
        widget.itemBuilder?.call(context, widget.profile, message);
    content ??= ChatUIKitMessageListViewMessageItem(
      bubbleStyle: widget.bubbleStyle,
      key: ValueKey(message.msgId),
      showAvatar: widget.showAvatar,
      quoteBuilder: widget.quoteBuilder,
      showNickname: widget.showNickname,
      onAvatarTap: () {
        widget.onAvatarTap?.call(widget.profile);
      },
      onAvatarLongPressed: () {
        widget.onAvatarLongPressed?.call(widget.profile);
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
}
