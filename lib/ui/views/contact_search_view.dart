import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ContactListSearchView extends StatefulWidget {
  const ContactListSearchView(this.searchData, {super.key});

  final List<ChatUIKitListItemModelBase> searchData;

  @override
  State<ContactListSearchView> createState() => _ContactListSearchViewState();
}

class _ContactListSearchViewState extends State<ContactListSearchView> {
  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget content = ChatUIKitSearchView(
      builder: (context, searchKeyword, list) {
        return ChatUIKitListView(
            enableSearchBar: false,
            itemBuilder: (context, model) {
              if (model is ContactItemModel) {
                return ChatUIKitContactItem(
                  model,
                  searchKeyword: searchKeyword,
                );
              }
              return const SizedBox();
            },
            list: list,
            type: list.isEmpty
                ? ChatUIKitListViewType.empty
                : ChatUIKitListViewType.normal);
      },
      searchHideText: '搜索联系人',
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
