import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class GroupsView extends StatefulWidget {
  GroupsView.arguments(GroupsViewArguments argument, {super.key})
      : controller = argument.controller,
        appBar = argument.appBar,
        onSearchTap = argument.onSearchTap,
        listViewItemBuilder = argument.listViewItemBuilder,
        onTap = argument.onTap,
        onLongPress = argument.onLongPress,
        fakeSearchHideText = argument.fakeSearchHideText,
        listViewBackground = argument.listViewBackground,
        enableAppBar = argument.enableAppBar,
        loadErrorMessage = argument.loadErrorMessage,
        attributes = argument.attributes;

  const GroupsView({
    this.controller,
    this.appBar,
    this.onSearchTap,
    this.listViewItemBuilder,
    this.onTap,
    this.onLongPress,
    this.fakeSearchHideText,
    this.listViewBackground,
    this.loadErrorMessage,
    this.enableAppBar = true,
    this.attributes,
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
  final bool enableAppBar;
  final String? attributes;

  @override
  State<GroupsView> createState() => _GroupsViewState();
}

class _GroupsViewState extends State<GroupsView> {
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
      appBar: !widget.enableAppBar
          ? null
          : widget.appBar ??
              ChatUIKitAppBar(
                showBackButton: true,
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
        controller: controller,
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

  void tapGroupInfo(BuildContext context, GroupItemModel model) {
    Navigator.of(context)
        .pushNamed(
      ChatUIKitRouteNames.groupDetailsView,
      arguments: GroupDetailsViewArguments(
        profile: model.profile,
        actions: [
          ChatUIKitActionItem(
            title: ChatUIKitLocal.groupDetailViewSend.getString(context),
            icon: 'assets/images/chat.png',
            onTap: (context) {
              Navigator.of(context).pushNamed(
                ChatUIKitRouteNames.messagesView,
                arguments: MessagesViewArguments(
                  profile: model.profile,
                  attributes: widget.attributes,
                ),
              );
            },
          ),
        ],
      ),
    )
        .then((value) {
      if (value != null && value == true) {
        controller.list.removeWhere((element) {
          return element is GroupItemModel &&
              element.profile.id == model.profile.id;
        });
        controller.refresh();
      }
    });
  }
}
