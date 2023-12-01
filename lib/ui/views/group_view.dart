import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class GroupView extends StatefulWidget {
  const GroupView({
    this.controller,
    this.appBar,
    this.onSearchTap,
    this.listViewItemBuilder,
    this.onItemTap,
    this.onItemLongPress,
    this.fakeSearchHideText,
    this.listViewBackground,
    this.loadErrorMessage,
    super.key,
  });

  final GroupListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final void Function(List<GroupItemModel> data)? onSearchTap;
  final ChatUIKitGroupItemBuilder? listViewItemBuilder;
  final void Function(GroupItemModel)? onItemTap;
  final void Function(GroupItemModel)? onItemLongPress;
  final String? fakeSearchHideText;
  final Widget? listViewBackground;
  final String? loadErrorMessage;

  @override
  State<GroupView> createState() => _GroupViewState();
}

class _GroupViewState extends State<GroupView> {
  late final GroupListViewController controller;
  int? joinedCount;
  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? GroupListViewController();
    ChatUIKit.instance.fetchJoinedGroupCount().then((value) {
      if (mounted) {
        joinedCount = value;
        setState(() {});
      }
    }).catchError((e) {});
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
            leading: InkWell(
              onTap: () {
                Navigator.maybePop(context);
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                child: Text(
                  "群聊${joinedCount != null ? '($joinedCount)' : ''}",
                  style: TextStyle(
                    fontWeight: theme.font.titleMedium.fontWeight,
                    fontSize: theme.font.titleMedium.fontSize,
                    color: theme.color.isDark
                        ? theme.color.neutralColor98
                        : theme.color.neutralColor1,
                  ),
                ),
              ),
            ),
          ),
      body: SafeArea(
          child: GroupListView(
        controller: controller,
        itemBuilder: widget.listViewItemBuilder,
        searchHideText: widget.fakeSearchHideText,
        background: widget.listViewBackground,
        errorMessage: widget.loadErrorMessage,
        onTap: widget.onItemTap ?? onItemTap,
        onLongPress: widget.onItemLongPress,
      )),
    );

    return content;
  }

  void onItemTap(GroupItemModel model) {}
}
