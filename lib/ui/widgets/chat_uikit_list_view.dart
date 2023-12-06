import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit/ui/models/alphabetical_item_model.dart';
import 'package:em_chat_uikit/ui/widgets/chat_uikit_alphabetical_item.dart';

import 'package:flutter/material.dart';

enum ChatUIKitListViewType { loading, empty, error, normal, refresh }

typedef ListViewBuilder = Widget Function(
  BuildContext context,
  List<ChatUIKitListItemModelBase> list,
);

typedef ChatUIKitListItemBuilder = Widget Function(
    BuildContext context, ChatUIKitListItemModelBase model);

class ChatUIKitListView extends StatefulWidget {
  const ChatUIKitListView({
    required this.itemBuilder,
    required this.list,
    required this.type,
    this.hasMore = true,
    this.loadMore,
    this.refresh,
    this.onSearchTap,
    this.searchHideText,
    this.enableSearchBar = true,
    this.background,
    this.errorMessage,
    this.reloadMessage,
    this.scrollController,
    this.beforeWidgets,
    this.afterWidgets,
    super.key,
  });

  final ScrollController? scrollController;
  final bool hasMore;
  final String? errorMessage;
  final String? reloadMessage;
  final ChatUIKitListViewType type;
  final VoidCallback? loadMore;
  final VoidCallback? refresh;
  final Widget? background;
  final void Function(List<ChatUIKitListItemModelBase> data)? onSearchTap;
  final bool enableSearchBar;
  final String? searchHideText;
  final List<ChatUIKitListItemModelBase> list;
  final ChatUIKitListItemBuilder itemBuilder;
  final List<NeedAlphabeticalWidget>? beforeWidgets;
  final List<NeedAlphabeticalWidget>? afterWidgets;

  @override
  State<ChatUIKitListView> createState() => _ChatUIKitListViewState();
}

class _ChatUIKitListViewState extends State<ChatUIKitListView> {
  ScrollController? controller;

  bool hasError = false;
  bool firstLoad = true;
  @override
  void initState() {
    super.initState();
    controller =
        widget.scrollController ?? ScrollController(keepScrollOffset: true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);

    Widget? sliverView;

    if (widget.type == ChatUIKitListViewType.loading) {
      sliverView = Center(
        child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: theme.color.isDark
                ? theme.color.neutralColor4
                : theme.color.neutralColor7,
          ),
        ),
      );
    }

    if (widget.type == ChatUIKitListViewType.empty) {
      sliverView = Center(
        child: widget.background ?? ChatUIKitImageLoader.listEmpty(),
      );
    }

    if (widget.type == ChatUIKitListViewType.error) {
      sliverView = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.background ?? ChatUIKitImageLoader.listEmpty(),
            const SizedBox(height: 8),
            Text(
              widget.errorMessage ?? '加载失败',
              style: TextStyle(
                color: theme.color.isDark
                    ? theme.color.neutralColor7
                    : theme.color.neutralColor4,
                fontWeight: theme.font.bodyMedium.fontWeight,
                fontSize: theme.font.bodyMedium.fontSize,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () {
                widget.refresh?.call();
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 9, 20, 9),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: theme.color.isDark
                      ? theme.color.primaryColor6
                      : theme.color.primaryColor5,
                ),
                child: Text(
                  widget.reloadMessage ?? '重新加载',
                  style: TextStyle(
                    color: theme.color.isDark
                        ? theme.color.neutralColor98
                        : theme.color.neutralColor98,
                    fontWeight: theme.font.labelMedium.fontWeight,
                    fontSize: theme.font.labelMedium.fontSize,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }

    if (sliverView != null) {
      sliverView = SliverFillRemaining(
        hasScrollBody: false,
        child: sliverView,
      );
    }

    Widget content = CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: controller,
      slivers: [
        if (widget.enableSearchBar)
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return fakeSearchBar();
              },
              childCount: 1,
            ),
          ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return widget.beforeWidgets?[index] ?? const SizedBox();
            },
            childCount: widget.beforeWidgets?.length ?? 0,
          ),
        ),
        if (sliverView != null) sliverView,
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              ChatUIKitListItemModelBase model = widget.list[index];

              if (model is NeedAlphabetical) {
                return SizedBox(
                  height: model.itemHeight,
                  child: widget.itemBuilder(context, model),
                );
              }

              if (model is AlphabeticalItemModel) {
                return ChatUIKitAlphabeticalItem(model: model);
              }

              return widget.itemBuilder(context, model);
            },
            childCount: widget.list.length,
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return widget.afterWidgets?[index] ?? const SizedBox();
            },
            childCount: widget.afterWidgets?.length ?? 0,
          ),
        ),
      ],
    );

    return content;
  }

  Widget fakeSearchBar() {
    return SizedBox(
      height: 44,
      child: InkWell(
        onTap: () {
          List<ChatUIKitListItemModelBase> list = [];
          for (var item in widget.list) {
            if (item is NeedSearch) {
              list.add(item);
            }
          }
          widget.onSearchTap?.call(list);
        },
        child: Container(
          margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(CornerRadiusHelper.searchBarRadius(36)),
            color: ChatUIKitTheme.of(context).color.isDark
                ? ChatUIKitTheme.of(context).color.neutralColor2
                : ChatUIKitTheme.of(context).color.neutralColor95,
          ),
          height: 36,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ChatUIKitImageLoader.search(
                  size: 22,
                  color: ChatUIKitTheme.of(context).color.neutralColor3,
                ),
                const SizedBox(width: 4),
                Text(
                  widget.searchHideText ?? '搜索',
                  style: TextStyle(
                    color: ChatUIKitTheme.of(context).color.isDark
                        ? ChatUIKitTheme.of(context).color.neutralColor4
                        : ChatUIKitTheme.of(context).color.neutralColor6,
                  ),
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
