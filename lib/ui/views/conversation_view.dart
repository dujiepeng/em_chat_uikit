import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class ConversationView extends StatefulWidget {
  const ConversationView({
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
    super.key,
  });

  final ConversationListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final void Function(List<ChatUIKitListItemModelBase> data)? onSearchTap;
  final List<ChatUIKitListItemModelBase>? listViewBeforeList;
  final List<ChatUIKitListItemModelBase>? listViewAfterList;
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
  late ConversationListViewController controller;
  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? ConversationListViewController();
  }

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
            subTitle: 'Online',
            centerTitle: false,
            titleTextStyle: TextStyle(
              color: theme.color.isDark
                  ? theme.color.primaryColor6
                  : theme.color.primaryColor5,
              fontSize: theme.font.titleLarge.fontSize,
              fontWeight: FontWeight.w900,
            ),
            autoBackButton: true,
            leading: const ChatUIKitAvatar(size: 32),
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
        controller: controller,
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
        onSearchTap: widget.onSearchTap,
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
