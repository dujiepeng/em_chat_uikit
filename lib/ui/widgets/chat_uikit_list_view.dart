import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

typedef ChatUIKitListItemBuilder = Widget Function(
    BuildContext context, ChatUIKitListItemModelBase model);

mixin SearchKeyword on ChatUIKitListItemModelBase {
  String get searchKeyword => '';
}

mixin Alphabetical on ChatUIKitListItemModelBase {
  String get showName;
}

abstract mixin class ChatUIKitListItemModelBase {
  double get itemHeight;
  bool get canSearch => false;
}

enum ChatUIKitListViewType { loading, empty, error, normal }

class ChatUIKitListView extends StatefulWidget {
  const ChatUIKitListView({
    required this.itemBuilder,
    required this.list,
    required this.type,
    this.beforeList,
    this.beforeBuilder,
    this.afterList,
    this.afterBuilder,
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
    this.alphabeticalBuilder,
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
  final Widget Function(
          BuildContext context, AlphabeticalItemModel alphabeticalItem)?
      alphabeticalBuilder;
  final String? searchHideText;
  final List<ChatUIKitListItemModelBase> list;
  final List<ChatUIKitListItemModelBase>? beforeList;
  final List<ChatUIKitListItemModelBase>? afterList;
  final ChatUIKitListItemBuilder itemBuilder;
  final ChatUIKitListItemBuilder? beforeBuilder;
  final ChatUIKitListItemBuilder? afterBuilder;

  @override
  State<ChatUIKitListView> createState() => _ChatUIKitListViewState();
}

class _ChatUIKitListViewState extends State<ChatUIKitListView> {
  bool hasError = false;
  bool firstLoad = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    if (widget.type == ChatUIKitListViewType.loading) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          widget.enableSearchBar ? fakeSearchBar() : Container(),
          Expanded(
            child: Center(
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
            ),
          )
        ],
      );
    }

    if (widget.type == ChatUIKitListViewType.empty) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          widget.onSearchTap != null ? fakeSearchBar() : Container(),
          Expanded(
            child: Center(
              child: widget.background ?? ChatUIKitImageLoader.listEmpty(),
            ),
          )
        ],
      );
    }

    if (widget.type == ChatUIKitListViewType.error) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          widget.onSearchTap != null ? fakeSearchBar() : Container(),
          Expanded(
            child: Center(
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
            ),
          )
        ],
      );
    }

    Widget content = CustomScrollView(
      controller: widget.scrollController,
      slivers: [
        if (widget.onSearchTap != null)
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
              if (widget.beforeList?.isNotEmpty == true) {
                ChatUIKitListItemModelBase? model = widget.beforeList?[index];
                double height = model?.itemHeight ?? 0;
                return SizedBox(
                  height: height,
                  child: widget.beforeBuilder?.call(
                    context,
                    widget.beforeList![index],
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
            childCount: widget.beforeList?.length ?? 0,
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              ChatUIKitListItemModelBase model = widget.list[index];

              if (model is AlphabeticalItemModel) {
                Widget content;
                if (widget.alphabeticalBuilder != null) {
                  content = widget.alphabeticalBuilder!(context, model);
                  content = SizedBox(height: model.itemHeight, child: content);
                } else {
                  content = ChatUIKitAlphabeticalItem(model: model);
                }
                return content;
              }

              return SizedBox(
                height: model.itemHeight,
                child: widget.itemBuilder(context, model),
              );
            },
            childCount: widget.list.length,
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (widget.afterList?.isNotEmpty == true) {
                ChatUIKitListItemModelBase? model = widget.afterList?[index];
                double height = model?.itemHeight ?? 0;
                return SizedBox(
                  height: height,
                  child: widget.afterBuilder?.call(
                    context,
                    widget.afterList![index],
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
            childCount: widget.afterList?.length ?? 0,
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
            if (item.canSearch) {
              list.add(item);
            }
          }
          widget.onSearchTap?.call(list);
        },
        child: Container(
          margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
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
