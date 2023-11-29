import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class NewChatView extends StatefulWidget {
  const NewChatView({
    this.listViewItemBuilder,
    this.onSearchTap,
    this.fakeSearchHideText,
    this.listViewBackground,
    this.onItemTap,
    this.onItemLongPress,
    this.appBar,
    this.controller,
    super.key,
  });

  final ContactListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final void Function(List<ContactItemModel> data)? onSearchTap;

  final ChatUIKitContactItemBuilder? listViewItemBuilder;
  final void Function(ContactItemModel)? onItemTap;
  final void Function(ContactItemModel)? onItemLongPress;
  final String? fakeSearchHideText;
  final Widget? listViewBackground;

  @override
  State<NewChatView> createState() => _NewChatViewState();
}

class _NewChatViewState extends State<NewChatView> {
  late final ContactListViewController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? ContactListViewController();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget content = Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: widget.appBar ??
          ChatUIKitAppBar(
            autoBackButton: true,
            leading: Text(
              '新会话',
              style: TextStyle(
                color: theme.color.isDark
                    ? theme.color.neutralColor98
                    : theme.color.neutralColor1,
                fontWeight: theme.font.titleMedium.fontWeight,
                fontSize: theme.font.titleMedium.fontSize,
              ),
            ),
          ),
      body: ContactListView(
        controller: controller,
        itemBuilder: widget.listViewItemBuilder,
        searchHideText: widget.fakeSearchHideText,
        background: widget.listViewBackground,
        onTap: widget.onItemTap ?? tapContactInfo,
        onSearchTap: widget.onSearchTap ?? onSearchTap,
      ),
    );

    return content;
  }

  void onSearchTap(List<ContactItemModel> data) async {
    List<NeedSearch> list = [];
    for (var item in data) {
      list.add(item);
    }
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SearchContactsView(
          onTap: (ctx, profile) {
            Navigator.of(ctx).pop(profile);
          },
          searchHideText: '搜索联系人',
          searchData: list,
        );
      },
    ).then((value) {
      if (value != null) {
        Navigator.of(context).pop(value);
      }
    });
  }

  void tapContactInfo(ContactItemModel info) {
    Navigator.of(context).pop(info.profile);
  }
}
