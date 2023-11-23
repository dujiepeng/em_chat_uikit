import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

typedef ChatUIKitConversationItemBuilder = Widget Function(
    BuildContext context, ConversationInfo model);

class ConversationListView extends StatefulWidget {
  const ConversationListView({
    required this.controller,
    this.itemBuilder,
    this.beforeBuilder,
    this.beforeList,
    this.afterBuilder,
    this.afterList,
    this.onSearchTap,
    this.searchHideText,
    this.background,
    this.errorMessage,
    this.reloadMessage,
    this.onTap,
    this.onLongPress,
    super.key,
  });

  final VoidCallback? onSearchTap;
  final List<ChatUIKitListItemModel>? beforeList;
  final List<ChatUIKitListItemModel>? afterList;
  final ChatUIKitListItemBuilder? beforeBuilder;
  final ChatUIKitListItemBuilder? afterBuilder;
  final ChatUIKitConversationItemBuilder? itemBuilder;
  final void Function(ConversationInfo)? onTap;
  final void Function(ConversationInfo)? onLongPress;
  final String? searchHideText;
  final Widget? background;
  final String? errorMessage;
  final String? reloadMessage;
  final ChatUIKitListViewControllerBase controller;

  @override
  State<ConversationListView> createState() => _ConversationListViewState();
}

class _ConversationListViewState extends State<ConversationListView>
    with ChatObserver {
  

  @override
  void initState() {
    super.initState();
    ChatUIKit.instance.addObserver(this);
    widget.controller.fetchItemList();
  }

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onMessagesReceived(List<Message> messages) {
    widget.controller.fetchItemList();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ChatUIKitListViewType>(
      valueListenable: widget.controller.loadingType,
      builder: (context, type, child) {
        return ChatUIKitListView(
          type: type,
          list: widget.controller.list,
          refresh: () {
            widget.controller.fetchItemList();
          },
          errorMessage: widget.errorMessage,
          reloadMessage: widget.reloadMessage,
          afterBuilder: widget.afterBuilder,
          afterList: widget.afterList,
          beforeBuilder: widget.beforeBuilder,
          beforeList: widget.beforeList,
          background: widget.background,
          onSearchTap: widget.onSearchTap,
          searchHideText: widget.searchHideText,
          itemBuilder: (context, model) {
            ConversationInfo info = model as ConversationInfo;
            Widget? item;
            if (widget.itemBuilder != null) {
              item = widget.itemBuilder!(context, info);
            }
            item ??= InkWell(
              onTap: () {
                widget.onTap?.call(info);
              },
              onLongPress: () {
                widget.onLongPress?.call(info);
              },
              child: const ListTile(
                title: Text('title'),
                subtitle: Text('model.subtitle'),
                trailing: Text('model.time'),
                isThreeLine: true,
                titleAlignment: ListTileTitleAlignment.titleHeight,
              ),
            );

            return item;
          },
        );
      },
    );
  }
}
