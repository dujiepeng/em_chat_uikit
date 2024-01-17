import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

typedef ChatUIKitConversationItemBuilder = Widget? Function(
    BuildContext context, ConversationInfo model);

class ConversationListView extends StatefulWidget {
  const ConversationListView({
    this.controller,
    this.itemBuilder,
    this.beforeWidgets,
    this.afterWidgets,
    this.onSearchTap,
    this.searchHideText,
    this.background,
    this.errorMessage,
    this.reloadMessage,
    this.onTap,
    this.onLongPress,
    this.enableLongPress = true,
    super.key,
  });

  final void Function(List<ConversationInfo> data)? onSearchTap;
  final ChatUIKitConversationItemBuilder? itemBuilder;
  final void Function(BuildContext context, ConversationInfo info)? onTap;
  final void Function(BuildContext context, ConversationInfo info)? onLongPress;
  final List<Widget>? beforeWidgets;
  final List<Widget>? afterWidgets;

  final String? searchHideText;
  final Widget? background;
  final String? errorMessage;
  final String? reloadMessage;
  final ConversationListViewController? controller;
  final bool enableLongPress;

  @override
  State<ConversationListView> createState() => _ConversationListViewState();
}

class _ConversationListViewState extends State<ConversationListView>
    with ChatObserver, MultiObserver, ChatUIKitProviderObserver {
  late ConversationListViewController controller;
  bool enableSearchBar = true;
  @override
  void initState() {
    super.initState();
    ChatUIKit.instance.addObserver(this);
    ChatUIKitProvider.instance.addObserver(this);
    controller = widget.controller ?? ConversationListViewController();
    controller.fetchItemList();

    controller.loadingType.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    ChatUIKitProvider.instance.removeObserver(this);
    controller.dispose();
    super.dispose();
  }

  @override
  void onConversationProfilesUpdate(
    Map<String, ChatUIKitProfile> map,
  ) {
    controller.reload();
  }

  @override
  void onMessagesReceived(List<Message> messages) async {
    for (var msg in messages) {
      if (msg.hasMention) {
        Conversation? conversation = await ChatUIKit.instance.getConversation(
          conversationId: msg.conversationId!,
          type: ConversationType.values[msg.chatType.index],
        );
        await conversation?.addMention();
      }
    }
    if (mounted) {
      controller.reload();
    }
  }

  @override
  void onConversationsUpdate() {
    controller.reload();
  }

  @override
  void onConversationEvent(
      MultiDevicesEvent event, String conversationId, ConversationType type) {
    if (event == MultiDevicesEvent.CONVERSATION_DELETE ||
        event == MultiDevicesEvent.CONVERSATION_PINNED ||
        event == MultiDevicesEvent.CONVERSATION_UNPINNED) {
      controller.fetchItemList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChatUIKitListView(
      type: controller.loadingType.value,
      list: controller.list,
      refresh: () {
        controller.fetchItemList();
      },
      enableSearchBar: enableSearchBar,
      errorMessage: widget.errorMessage,
      reloadMessage: widget.reloadMessage,
      beforeWidgets: widget.beforeWidgets,
      afterWidgets: widget.afterWidgets,
      background: widget.background,
      onSearchTap: (data) {
        List<ConversationInfo> list = [];
        for (var item in data) {
          if (item is ConversationInfo) {
            list.add(item);
          }
        }
        widget.onSearchTap?.call(list);
      },
      searchHideText: widget.searchHideText,
      findChildIndexCallback: (key) {
        int index = -1;
        if (key is ValueKey<String>) {
          final ValueKey<String> valueKey = key;
          index = controller.list.indexWhere((info) {
            if (info is ConversationInfo) {
              return info.profile.id == valueKey.value;
            } else {
              return false;
            }
          });
        }
        debugPrint('index: $index');

        return index > -1 ? index : null;
      },
      itemBuilder: (context, model) {
        if (model is ConversationInfo) {
          Widget? item;
          if (widget.itemBuilder != null) {
            item = widget.itemBuilder!(context, model);
          }
          item ??= InkWell(
            onTap: () {
              widget.onTap?.call(context, model);
            },
            onLongPress: () {
              if (widget.enableLongPress) {
                widget.onLongPress?.call(context, model);
              }
            },
            child: ChatUIKitConversationListViewItem(
              model,
            ),
          );

          item = SizedBox(
            key: ValueKey(model.profile.id),
            child: item,
          );

          return item;
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
