import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class ContactView extends StatefulWidget {
  const ContactView({
    this.listViewItemBuilder,
    this.listViewBeforeBuilder,
    this.listViewBeforeList,
    this.listViewAfterBuilder,
    this.listViewAfterList,
    this.onSearchTap,
    this.fakeSearchHideText,
    this.listViewBackground,
    this.onItemTap,
    this.onItemLongPress,
    this.appBar,
    this.controller,
    this.alphabeticalBuilder,
    super.key,
  });

  final ContactListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final VoidCallback? onSearchTap;
  final List<ChatUIKitListItemModel>? listViewBeforeList;
  final List<ChatUIKitListItemModel>? listViewAfterList;
  final ChatUIKitListItemBuilder? listViewBeforeBuilder;
  final ChatUIKitListItemBuilder? listViewAfterBuilder;
  final ChatUIKitListItemBuilder? listViewItemBuilder;
  final void Function(ContactItemModel)? onItemTap;
  final void Function(ContactItemModel)? onItemLongPress;
  final String? fakeSearchHideText;
  final Widget? listViewBackground;
  final Widget Function(
    BuildContext context,
    AlphabeticalItemModel alphabeticalItem,
  )? alphabeticalBuilder;
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
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: ChatUIKitAppBar(
        title: 'Contacts',
        titleTextStyle: TextStyle(
          color: theme.color.isDark
              ? theme.color.primaryColor6
              : theme.color.primaryColor5,
          fontSize: theme.font.titleLarge.fontSize,
          fontWeight: theme.font.titleLarge.fontWeight,
        ),
        autoBackButton: false,
        leading: Container(
          margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
          color: Colors.red,
          width: 32,
          height: 32,
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
        beforeBuilder: widget.listViewBeforeBuilder,
        beforeList: widget.listViewBeforeList,
        afterBuilder: widget.listViewAfterBuilder,
        afterList: widget.listViewAfterList,
        searchHideText: widget.fakeSearchHideText,
        background: widget.listViewBackground,
        onTap: widget.onItemTap ?? tapContactInfo,
        onLongPress: widget.onItemLongPress ?? longContactInfo,
        onSearchTap: widget.onSearchTap ?? onSearchTap,
        alphabeticalBuilder: widget.alphabeticalBuilder,
      ),
    );

    return content;
  }

  void onSearchTap() {
    debugPrint('onSearchTap');
  }

  void tapContactInfo(ContactItemModel info) {}

  void longContactInfo(ContactItemModel info) {}
}
