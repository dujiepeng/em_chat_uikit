import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit/ui/widgets/chat_uikit_search_item.dart';
import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  const SearchView({
    required this.searchData,
    required this.searchHideText,
    super.key,
  });

  final List<NeedSearch> searchData;
  final String searchHideText;

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget content = ChatUIKitSearchView(
      builder: (context, searchKeyword, list) {
        return ChatUIKitListView(
            enableSearchBar: false,
            itemBuilder: (context, model) {
              if (model is NeedSearch) {
                return ChatUIKitSearchItem(
                  profile: model.profile,
                  highlightWord: searchKeyword,
                );
              }
              return const SizedBox();
            },
            list: list,
            type: list.isEmpty
                ? ChatUIKitListViewType.empty
                : ChatUIKitListViewType.normal);
      },
      searchHideText: widget.searchHideText,
      list: widget.searchData,
      autoFocus: true,
    );

    content = NotificationListener(
      child: content,
      onNotification: (notification) {
        if (notification is SearchNotification) {
          if (!notification.isSearch) {
            Navigator.of(context).pop();
          }
        }
        return false;
      },
    );

    content = Scaffold(
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: const ChatUIKitAppBar(),
      body: content,
    );

    // content = SafeArea(child: content);

    return content;
  }
}
