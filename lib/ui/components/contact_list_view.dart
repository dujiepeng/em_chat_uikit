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
  final List<Widget>? beforeWidgets;
  final List<Widget>? afterWidgets;
  final ChatUIKitContactItemBuilder? itemBuilder;
  final void Function(BuildContext context, ContactItemModel model)? onTap;
  final void Function(BuildContext context, ContactItemModel model)?
      onLongPress;
  final String? searchHideText;
  final Widget? background;
  final String? errorMessage;
  final String? reloadMessage;
  final ContactListViewController? controller;

  @override
  State<ContactListView> createState() => _ContactListViewState();
}

class _ContactListViewState extends State<ContactListView>
    with ChatUIKitProviderObserver {
  ScrollController scrollController = ScrollController();
  late final ContactListViewController controller;
  bool enableSearchBar = true;

  @override
  void initState() {
    super.initState();
    ChatUIKitProvider.instance.addObserver(this);
    controller = widget.controller ?? ContactListViewController();
    controller.fetchItemList();
    controller.loadingType.addListener(() {
      setState(() {});
    });
  }

  @override
  void onContactProfilesUpdate(
    Map<String, ChatUIKitProfile> map,
  ) {
    controller.reload();
  }

  @override
  void dispose() {
    ChatUIKitProvider.instance.removeObserver(this);
    scrollController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChatUIKitAlphabeticalWidget(
      onTapCancel: () {},
      onTap: (context, alphabetical) {},
      beforeWidgets: widget.beforeWidgets,
      listViewHasSearchBar: enableSearchBar,
      list: controller.list,
      scrollController: scrollController,
      builder: (context, list) {
        return ChatUIKitListView(
          scrollController: scrollController,
          type: controller.loadingType.value,
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
                  widget.onTap?.call(context, model);
                },
                onLongPress: () {
                  widget.onLongPress?.call(context, model);
                },
                child: ChatUIKitContactListViewItem(model),
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
