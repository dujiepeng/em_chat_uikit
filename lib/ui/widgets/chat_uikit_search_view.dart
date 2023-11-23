import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class SearchNotification extends Notification {
  SearchNotification(this.isSearch);
  final bool isSearch;
}

typedef ListViewSearchBuilder = Widget Function(
  BuildContext context,
  String? searchKeyword,
  List<ChatUIKitListItemModel> list,
);

class ChatUIKitSearchView extends StatefulWidget {
  const ChatUIKitSearchView({
    required this.builder,
    required this.searchHideText,
    required this.list,
    super.key,
  });
  final ListViewSearchBuilder builder;
  final String searchHideText;
  final List<ChatUIKitListItemModel> list;

  @override
  State<ChatUIKitSearchView> createState() => _ChatUIKitSearchViewState();
}

class _ChatUIKitSearchViewState extends State<ChatUIKitSearchView> {
  late final List<ChatUIKitListItemModel> list;
  TextEditingController searchController = TextEditingController();
  bool isSearch = false;
  bool isShowClear = false;
  ValueNotifier<String> searchKeyword = ValueNotifier('');
  @override
  void initState() {
    super.initState();
    list = widget.list;
    searchController.addListener(() {
      searchKeyword.value = searchController.text;
    });
  }

  @override
  void didUpdateWidget(covariant ChatUIKitSearchView oldWidget) {
    if (widget.list != oldWidget.list) {
      list.clear();
      list.addAll(widget.list);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      children: [
        isSearch ? searchTextInputBar() : searchBar(),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: searchKeyword,
            builder: (context, keyword, child) {
              return widget.builder(context, keyword, list);
            },
          ),
        ),
      ],
    );
    return content;
  }

  Widget searchTextInputBar() {
    return SizedBox(
      height: 44,
      child: Container(
        margin: const EdgeInsets.fromLTRB(8, 4, 0, 4),
        height: 36,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(6, 7, 0, 7),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: ChatUIKitTheme.of(context).color.isDark
                      ? ChatUIKitTheme.of(context).color.neutralColor2
                      : ChatUIKitTheme.of(context).color.neutralColor95,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ChatUIKitImageLoader.search(
                      size: 22,
                      color: ChatUIKitTheme.of(context).color.neutralColor3,
                    ),
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        controller: searchController,
                        scrollPadding: EdgeInsets.zero,
                        decoration: InputDecoration(
                          hintText: widget.searchHideText,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                          hintStyle: TextStyle(
                            color: ChatUIKitTheme.of(context).color.isDark
                                ? ChatUIKitTheme.of(context).color.neutralColor4
                                : ChatUIKitTheme.of(context)
                                    .color
                                    .neutralColor6,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: searchKeyword,
                      builder: (context, value, child) {
                        // TODO
                        if (value.isEmpty) {
                          return const SizedBox();
                        } else {
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: InkWell(
                              onTap: () {
                                searchController.clear();
                              },
                              child: Icon(
                                Icons.cancel,
                                size: 22,
                                color: ChatUIKitTheme.of(context)
                                    .color
                                    .neutralColor7,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  isSearch = false;
                });
                searchController.clear();
                SearchNotification(isSearch).dispatch(context);
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Text(
                  '取消',
                  style: TextStyle(
                    color: ChatUIKitTheme.of(context).color.isDark
                        ? ChatUIKitTheme.of(context).color.primaryColor6
                        : ChatUIKitTheme.of(context).color.primaryColor5,
                    fontWeight:
                        ChatUIKitTheme.of(context).font.labelMedium.fontWeight,
                    fontSize:
                        ChatUIKitTheme.of(context).font.labelMedium.fontSize,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchBar() {
    return SizedBox(
      height: 44,
      child: InkWell(
        onTap: () {
          setState(() {
            isSearch = true;
          });
          SearchNotification(isSearch).dispatch(context);
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
                  '搜索',
                  style: TextStyle(
                    color: ChatUIKitTheme.of(context).color.isDark
                        ? ChatUIKitTheme.of(context).color.neutralColor4
                        : ChatUIKitTheme.of(context).color.neutralColor6,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
