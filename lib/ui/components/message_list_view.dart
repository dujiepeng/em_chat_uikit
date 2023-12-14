import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class MessageListView extends StatefulWidget {
  const MessageListView({required this.profile, this.controller, super.key});
  final ChatUIKitProfile profile;
  final MessageListViewController? controller;
  @override
  State<MessageListView> createState() => _MessageListViewState();
}

class _MessageListViewState extends State<MessageListView> {
  late final MessageListViewController controller;
  final ScrollController scrollController = ScrollController();
  final centerKey = const ValueKey('center');
  bool isFetching = false;

  @override
  void initState() {
    super.initState();

    controller =
        widget.controller ?? MessageListViewController(profile: widget.profile);
    controller.addListener(() {
      if (controller.lastActionType == MessageLastActionType.load) {
        setState(() {});
      }
      if (controller.lastActionType == MessageLastActionType.send) {
        setState(() {});
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
            (context, index) {
              return _item(controller.newData[index]);
            },
            childCount: controller.newData.length,
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
    return ChatUIKitMessageListViewMessageItem(
      // enableAvatar: false,
      onAvatarTap: () {
        debugPrint('onAvatarTap');
      },
      onBubbleDoubleTap: () {
        debugPrint('onBubbleDoubleTap');
      },
      onBubbleLongPressed: () {
        debugPrint('onBubbleLongPressed');
      },
      onBubbleTap: () {
        debugPrint('onBubbleTap');
      },
      onNicknameTap: () {
        debugPrint('onNicknameTap');
      },
      message: message,
    );
  }
}
