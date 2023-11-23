import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

typedef ChatUIKitContactItemBuilder = Widget Function(
    BuildContext context, ContactInfo model);

class ContactListView extends StatefulWidget {
  const ContactListView({
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
  final ChatUIKitContactItemBuilder? itemBuilder;
  final void Function(ContactInfo)? onTap;
  final void Function(ContactInfo)? onLongPress;
  final String? searchHideText;
  final Widget? background;
  final String? errorMessage;
  final String? reloadMessage;
  final ChatUIKitListViewControllerBase controller;

  @override
  State<ContactListView> createState() => _ContactListViewState();
}

class _ContactListViewState extends State<ContactListView> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.controller.fetchItemList();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ChatUIKitListViewType>(
      valueListenable: widget.controller.loadingType,
      builder: (context, type, child) {
        return ChatUIKitAlphabeticalView(
          list: widget.controller.list,
          controller: scrollController,
          builder: (context, list) {
            return ChatUIKitListView(
              type: type,
              list: list,
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
                ContactInfo info = model as ContactInfo;
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
      },
    );
  }
}
