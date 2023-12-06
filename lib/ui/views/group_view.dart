import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class GroupView extends StatefulWidget {
  GroupView.arguments(GroupViewArguments argument, {super.key})
      : controller = argument.controller,
        appBar = argument.appBar,
        onSearchTap = argument.onSearchTap,
        listViewItemBuilder = argument.listViewItemBuilder,
        onTap = argument.onTap,
        onLongPress = argument.onLongPress,
        fakeSearchHideText = argument.fakeSearchHideText,
        listViewBackground = argument.listViewBackground,
        loadErrorMessage = argument.loadErrorMessage;

  const GroupView({
    this.controller,
    this.appBar,
    this.onSearchTap,
    this.listViewItemBuilder,
    this.onTap,
    this.onLongPress,
    this.fakeSearchHideText,
    this.listViewBackground,
    this.loadErrorMessage,
    super.key,
  });

  final GroupListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final void Function(List<GroupItemModel> data)? onSearchTap;
  final ChatUIKitGroupItemBuilder? listViewItemBuilder;
  final void Function(BuildContext context, GroupItemModel model)? onTap;
  final void Function(BuildContext context, GroupItemModel model)? onLongPress;
  final String? fakeSearchHideText;
  final Widget? listViewBackground;
  final String? loadErrorMessage;

  @override
  State<GroupView> createState() => _GroupViewState();
}

class _GroupViewState extends State<GroupView> {
  int? joinedCount;
  @override
  void initState() {
    super.initState();

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
      body: SafeArea(
          child: GroupListView(
        controller: widget.controller,
        itemBuilder: widget.listViewItemBuilder,
        searchHideText: widget.fakeSearchHideText,
        background: widget.listViewBackground,
        errorMessage: widget.loadErrorMessage,
        onTap: widget.onTap ?? tapGroupInfo,
        onLongPress: widget.onLongPress,
      )),
    );

    return content;
  }

  void tapGroupInfo(BuildContext context, GroupItemModel info) {
    Navigator.of(context).pushNamed(
      ChatUIKitRouteNames.groupDetailsView,
      arguments: GroupDetailsViewArguments(
        profile: info.profile,
        actions: [
          ChatUIKitActionItem(
            title: '发消息',
            icon: 'assets/images/chat.png',
            onTap: (context) {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
