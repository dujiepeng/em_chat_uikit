import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class ContactView extends StatefulWidget {
  const ContactView({
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
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
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
            title: 'Contacts',
            titleTextStyle: TextStyle(
              color: theme.color.isDark
                  ? theme.color.primaryColor6
                  : theme.color.primaryColor5,
              fontSize: theme.font.titleLarge.fontSize,
              fontWeight: FontWeight.w900,
            ),
            autoBackButton: false,
            leading: Container(
              margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
              child: const ChatUIKitAvatar(size: 32),
            ),
            trailing: IconButton(
              iconSize: 24,
              color: theme.color.isDark
                  ? theme.color.neutralColor95
                  : theme.color.neutralColor3,
              icon: const Icon(Icons.person_add_alt_1_outlined),
              onPressed: () {},
            ),
          ),
      body: ContactListView(
        controller: controller,
        itemBuilder: widget.listViewItemBuilder,
        beforeWidgets: beforeWidgets,
        searchHideText: widget.fakeSearchHideText,
        background: widget.listViewBackground,
        onTap: widget.onItemTap ?? tapContactInfo,
        onLongPress: widget.onItemLongPress ?? longContactInfo,
        onSearchTap: widget.onSearchTap ?? onSearchTap,
      ),
    );

    return content;
  }

  List<ChatUIKitListMoreItem> get beforeWidgets {
    return [
      ChatUIKitListMoreItem(
          title: '新请求',
          onTap: () {
            debugPrint('新请求');
          }),
      ChatUIKitListMoreItem(
          title: '群聊',
          onTap: () {
            debugPrint('群聊');
          }),
    ];
  }

  void onSearchTap(List<ContactItemModel> data) {
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
            Navigator.of(ctx).pop();
            debugPrint('onTap: ${profile.id}');
          },
          searchHideText: '搜索联系人',
          searchData: list,
        );
      },
    );
  }

  void tapContactInfo(ContactItemModel info) {
    debugPrint('tapContactInfo');
  }

  void longContactInfo(ContactItemModel info) {
    debugPrint('longContactInfo');
  }
}
