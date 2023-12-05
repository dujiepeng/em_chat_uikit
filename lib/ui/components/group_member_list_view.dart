import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class GroupMemberListView extends StatefulWidget {
  const GroupMemberListView({
    required this.groupId,
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
    this.enableSearchBar = false,
    super.key,
  });

  final void Function(List<ContactItemModel> data)? onSearchTap;
  final List<NeedAlphabeticalWidget>? beforeWidgets;
  final List<NeedAlphabeticalWidget>? afterWidgets;
  final ChatUIKitContactItemBuilder? itemBuilder;
  final void Function(BuildContext context, ContactItemModel model)? onTap;
  final void Function(BuildContext context, ContactItemModel model)?
      onLongPress;
  final String? searchHideText;
  final Widget? background;
  final String? errorMessage;
  final String? reloadMessage;
  final GroupMemberListViewController? controller;
  final String groupId;
  final bool enableSearchBar;

  @override
  State<GroupMemberListView> createState() => _GroupMemberListViewState();
}

class _GroupMemberListViewState extends State<GroupMemberListView> {
  ScrollController scrollController = ScrollController();
  late final GroupMemberListViewController controller;
  bool enableSearchBar = true;

  @override
  void initState() {
    super.initState();

    controller =
        widget.controller ?? GroupMemberListViewController(widget.groupId);
    controller.fetchItemList();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget content = ValueListenableBuilder<ChatUIKitListViewType>(
      valueListenable: controller.loadingType,
      builder: (context, type, child) {
        debugPrint('${controller.list}, type: $type');
        return ChatUIKitListView(
          scrollController: scrollController,
          type: type,
          list: controller.list,
          refresh: () {
            controller.fetchItemList();
          },
          enableSearchBar: widget.enableSearchBar,
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
                  if (controller.owner != model.profile.id) {
                    widget.onTap?.call(context, model);
                  }
                },
                onLongPress: () {
                  if (controller.owner != model.profile.id) {
                    widget.onLongPress?.call(context, model);
                  }
                },
                // child: ChatUIKitContactItem(model),
                child: controller.owner == model.profile.id
                    ? Stack(
                        children: [
                          ChatUIKitContactItem(model),
                          Opacity(
                            opacity: 0.4,
                            child: Container(
                                color: theme.color.isDark
                                    ? theme.color.neutralColor1
                                    : theme.color.neutralColor98),
                          ),
                        ],
                      )
                    : ChatUIKitContactItem(model),
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
}
