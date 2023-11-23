import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class ConversationView extends StatefulWidget {
  ConversationView({
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
    ConversationListViewController? controller,
    super.key,
  }) {
    this.controller = controller ?? ConversationListViewController();
  }

  late final ConversationListViewController controller;
  final ChatUIKitAppBar? appBar;
  final VoidCallback? onSearchTap;
  final List<ChatUIKitListItemModel>? listViewBeforeList;
  final List<ChatUIKitListItemModel>? listViewAfterList;
  final ChatUIKitListItemBuilder? listViewBeforeBuilder;
  final ChatUIKitListItemBuilder? listViewAfterBuilder;
  final ChatUIKitListItemBuilder? listViewItemBuilder;
  final void Function(ConversationItemModel)? onItemTap;
  final void Function(ConversationItemModel)? onItemLongPress;
  final String? fakeSearchHideText;
  final Widget? listViewBackground;
  @override
  State<ConversationView> createState() => _ConversationViewState();
}

class _ConversationViewState extends State<ConversationView> {
  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget content = Scaffold(
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: widget.appBar ??
          ChatUIKitAppBar(
            title: 'Chats',
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
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () {},
            ),
          ),
      body: ConversationListView(
        controller: widget.controller,
        itemBuilder: widget.listViewItemBuilder,
        beforeBuilder: widget.listViewBeforeBuilder,
        beforeList: widget.listViewBeforeList,
        afterBuilder: widget.listViewAfterBuilder,
        afterList: widget.listViewAfterList,
        searchHideText: widget.fakeSearchHideText,
        background: widget.listViewBackground,
        onTap: widget.onItemTap ??
            (ConversationItemModel model) {
              pushToMessageInfoPage();
            },
        onLongPress: widget.onItemLongPress ??
            (ConversationItemModel model) {
              showBottomSheet();
            },
        onSearchTap: widget.onSearchTap ?? onSearchTap,
      ),
    );

    return content;
  }

  void onSearchTap() {
    debugPrint('onSearchTap');
  }

  void pushToMessageInfoPage() {}

  void showBottomSheet() {}
}
