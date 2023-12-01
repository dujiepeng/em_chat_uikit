import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

typedef ChatUIKitNewRequestItemBuilder = Widget Function(
    BuildContext context, NewRequestItemModel model);

class NewRequestsListView extends StatefulWidget {
  const NewRequestsListView({
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

  final void Function(List<NewRequestItemModel> data)? onSearchTap;
  final List<NeedAlphabeticalWidget>? beforeWidgets;
  final List<NeedAlphabeticalWidget>? afterWidgets;
  final ChatUIKitNewRequestItemBuilder? itemBuilder;
  final void Function(NewRequestItemModel model)? onTap;
  final void Function(NewRequestItemModel model)? onLongPress;
  final String? searchHideText;
  final Widget? background;
  final String? errorMessage;
  final String? reloadMessage;
  final NewRequestListViewController? controller;

  @override
  State<NewRequestsListView> createState() => _NewRequestsListViewState();
}

class _NewRequestsListViewState extends State<NewRequestsListView>
    with ContactObserver {
  late final NewRequestListViewController controller;

  @override
  void initState() {
    super.initState();
    ChatUIKit.instance.addObserver(this);
    controller = NewRequestListViewController();
    controller.fetchItemList();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ValueListenableBuilder<ChatUIKitListViewType>(
      valueListenable: controller.loadingType,
      builder: (context, type, child) {
        return ChatUIKitListView(
          type: type,
          list: controller.list,
          refresh: () {
            controller.fetchItemList();
          },
          enableSearchBar: false,
          errorMessage: widget.errorMessage,
          reloadMessage: widget.reloadMessage,
          background: widget.background,
          itemBuilder: (context, model) {
            if (model is NewRequestItemModel) {
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
                child: ChatUIKitNewRequestItem(model),
              );

              return item;
            } else {
              return const SizedBox();
            }
          },
        );
      },
    );

    return content;
  }

  @override
  void onReceiveFriendRequest(String userId, String? reason) {
    controller.fetchItemList();
  }

  @override
  void onContactAdded(String userId) {
    controller.fetchItemList();
  }
}
