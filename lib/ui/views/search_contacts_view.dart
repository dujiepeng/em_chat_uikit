import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit/ui/widgets/chat_uikit_search_item.dart';
import 'package:flutter/material.dart';

class SearchContactsView extends StatefulWidget {
  const SearchContactsView({
    required this.searchData,
    required this.searchHideText,
    this.itemBuilder,
    this.onTap,
    super.key,
  });

  final List<NeedSearch> searchData;
  final String searchHideText;
  final void Function(BuildContext context, ChatUIKitProfile profile)? onTap;
  final Widget Function(BuildContext context, ChatUIKitProfile profile,
      String? searchKeyword)? itemBuilder;

  @override
  State<SearchContactsView> createState() => _SearchContactsViewState();
}

class _SearchContactsViewState extends State<SearchContactsView> {
  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget content = ChatUIKitSearchView(
      builder: (context, searchKeyword, list) {
        return ChatUIKitListView(
            enableSearchBar: false,
            itemBuilder: (context, model) {
              if (model is NeedSearch) {
                if (widget.itemBuilder != null) {
                  return widget.itemBuilder!
                      .call(context, model.profile, searchKeyword);
                }

                return InkWell(
                  onTap: () {
                    widget.onTap?.call(context, model.profile);
                  },
                  child: ChatUIKitSearchItem(
                    profile: model.profile,
                    highlightWord: searchKeyword,
                  ),
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
