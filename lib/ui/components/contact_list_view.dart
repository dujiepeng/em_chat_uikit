import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

typedef ChatUIKitContactItemBuilder = Widget Function(
    BuildContext context, ContactItemModel model);

class ContactListView extends StatefulWidget {
  const ContactListView({
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

  final void Function(List<ContactItemModel> data)? onSearchTap;
  final List<NeedAlphabeticalWidget>? beforeWidgets;
  final List<NeedAlphabeticalWidget>? afterWidgets;
  final ChatUIKitContactItemBuilder? itemBuilder;
  final void Function(ContactItemModel)? onTap;
  final void Function(ContactItemModel)? onLongPress;
  final String? searchHideText;
  final Widget? background;
  final String? errorMessage;
  final String? reloadMessage;
  final ContactListViewController? controller;

  @override
  State<ContactListView> createState() => _ContactListViewState();
}

class _ContactListViewState extends State<ContactListView>
    with ContactObserver {
  ScrollController scrollController = ScrollController();
  late final ContactListViewController controller;
  bool enableSearchBar = true;

  @override
  void initState() {
    super.initState();
    ChatUIKit.instance.addObserver(this);
    controller = widget.controller ?? ContactListViewController();
    controller.fetchItemList();
  }

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ValueListenableBuilder<ChatUIKitListViewType>(
      valueListenable: controller.loadingType,
      builder: (context, type, child) {
        return ChatUIKitAlphabeticalView(
          onTapCancel: () {
            debugPrint('tap cancel');
          },
          onTap: (context, alphabetical) {
            debugPrint('tap $alphabetical');
          },
          beforeWidgets: widget.beforeWidgets,
          listViewHasSearchBar: enableSearchBar,
          list: controller.list,
          scrollController: scrollController,
          builder: (context, list) {
            return ChatUIKitListView(
              scrollController: scrollController,
              type: type,
              list: list,
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
                List<ContactItemModel> list = [];
                for (var item in data) {
                  if (item is ContactItemModel) {
                    list.add(item);
                  }
                }
                widget.onSearchTap?.call(list);
              },
              searchHideText: widget.searchHideText,
              itemBuilder: (context, model) {
                if (model is ContactItemModel) {
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
                    child: ChatUIKitContactItem(model),
                  );

                  return item;
                } else {
                  return const SizedBox();
                }
              },
            );
          },
        );
      },
    );

    return content;
  }

  @override
  void onContactAdded(String userId) {
    controller.fetchItemList();
  }

  @override
  void onContactDeleted(String userId) {
    controller.fetchItemList();
  }
}
