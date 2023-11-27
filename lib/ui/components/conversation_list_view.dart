import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

typedef ChatUIKitConversationItemBuilder = Widget Function(
    BuildContext context, ConversationItemModel model);

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
    super.key,
  });

  final void Function(List<ChatUIKitListItemModelBase> data)? onSearchTap;
  final ChatUIKitConversationItemBuilder? itemBuilder;
  final void Function(ConversationItemModel)? onTap;
  final List<NeedAlphabeticalWidget>? beforeWidgets;
  final List<NeedAlphabeticalWidget>? afterWidgets;
  final void Function(ConversationItemModel)? onLongPress;
  final String? searchHideText;
  final Widget? background;
  final String? errorMessage;
  final String? reloadMessage;
  final ConversationListViewController? controller;

  @override
  State<ConversationListView> createState() => _ConversationListViewState();
}

class _ConversationListViewState extends State<ConversationListView>
    with ChatObserver {
  late ConversationListViewController controller;
  bool enableSearchBar = true;
  @override
  void initState() {
    super.initState();
    ChatUIKit.instance.addObserver(this);
    controller = widget.controller ?? ConversationListViewController();
    controller.fetchItemList();
  }

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onMessagesReceived(List<Message> messages) {
    controller.fetchItemList();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ChatUIKitListViewType>(
      valueListenable: controller.loadingType,
      builder: (context, type, child) {
        return ChatUIKitListView(
          type: type,
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
          onSearchTap: widget.onSearchTap,
          searchHideText: widget.searchHideText,
          itemBuilder: (context, model) {
            if (model is ConversationItemModel) {
              Widget? item;
              if (widget.itemBuilder != null) {
                item = widget.itemBuilder!(context, model);
              }
              item ??= InkWell(
                onTap: () {
                  widget.onTap?.call(model);
                },
                onLongPress: () {
                  widget.onLongPress?.call(model);
                },
                child: ChatUIKitConversationItem(model),
              );

              return item;
            } else {
              return const SizedBox();
            }
          },
        );
      },
    );
  }
}
