import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class GroupMentionView extends StatefulWidget {
  GroupMentionView.arguments(GroupMentionViewArguments arguments, {super.key})
      : listViewItemBuilder = arguments.listViewItemBuilder,
        onSearchTap = arguments.onSearchTap,
        fakeSearchHideText = arguments.fakeSearchHideText,
        listViewBackground = arguments.listViewBackground,
        onTap = arguments.onTap,
        onLongPress = arguments.onLongPress,
        appBar = arguments.appBar,
        controller = arguments.controller,
        groupId = arguments.groupId;

  const GroupMentionView({
    required this.groupId,
    this.listViewItemBuilder,
    this.onSearchTap,
    this.fakeSearchHideText,
    this.listViewBackground,
    this.onTap,
    this.onLongPress,
    this.appBar,
    this.controller,
    super.key,
  });

  final String groupId;
  final GroupMemberListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final void Function(List<ContactItemModel> data)? onSearchTap;

  final ChatUIKitContactItemBuilder? listViewItemBuilder;
  final void Function(BuildContext context, ContactItemModel model)? onTap;
  final void Function(BuildContext context, ContactItemModel model)?
      onLongPress;
  final String? fakeSearchHideText;
  final Widget? listViewBackground;

  @override
  State<GroupMentionView> createState() => _GroupMentionViewState();
}

class _GroupMentionViewState extends State<GroupMentionView> {
  final ValueNotifier<List<ChatUIKitProfile>> selectedProfiles =
      ValueNotifier<List<ChatUIKitProfile>>([]);
  late final GroupMemberListViewController controller;

  bool enableMulti = false;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ??
        GroupMemberListViewController(groupId: widget.groupId);
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
            showBackButton: true,
            leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Text(
                '@提及',
                style: TextStyle(
                  color: theme.color.isDark
                      ? theme.color.neutralColor98
                      : theme.color.neutralColor1,
                  fontWeight: theme.font.titleMedium.fontWeight,
                  fontSize: theme.font.titleMedium.fontSize,
                ),
              ),
            ),
          ),
      body: ValueListenableBuilder(
        valueListenable: selectedProfiles,
        builder: (context, value, child) {
          return GroupMemberListView(
            // beforeWidgets: enableMulti
            //     ? []
            //     : [
            //         ChatUIKitListViewMoreItem(
            //           title: '所有人',
            //           onTap: () {
            //             Navigator.of(context).pushNamed(
            //               ChatUIKitRouteNames.newRequestsView,
            //               arguments: NewRequestsViewArguments(),
            //             );
            //           },
            //           trailing: Padding(
            //             padding: const EdgeInsets.only(right: 5),
            //             child: ChatUIKitBadge(
            //                 ChatUIKitContext.instance.requestList().length),
            //           ),
            //         ),
            //       ],
            groupId: widget.groupId,
            controller: controller,
            itemBuilder: widget.listViewItemBuilder ??
                (context, model) {
                  return InkWell(
                    onTap: () {
                      if (enableMulti) {
                        tapContactInfo(model.profile);
                      } else {
                        Navigator.of(context).pop(model.profile);
                      }
                    },
                    child: enableMulti
                        ? Padding(
                            padding:
                                const EdgeInsets.only(left: 19.5, right: 15.5),
                            child: Row(
                              children: [
                                value.contains(model.profile)
                                    ? Icon(
                                        Icons.check_box,
                                        size: 21,
                                        color: theme.color.isDark
                                            ? theme.color.primaryColor6
                                            : theme.color.primaryColor5,
                                      )
                                    : Icon(
                                        Icons.check_box_outline_blank,
                                        size: 21,
                                        color: theme.color.isDark
                                            ? theme.color.neutralColor4
                                            : theme.color.neutralColor7,
                                      ),
                                ChatUIKitContactListViewItem(model)
                              ],
                            ),
                          )
                        : ChatUIKitContactListViewItem(model),
                  );
                },
            searchHideText: widget.fakeSearchHideText,
            background: widget.listViewBackground,
            onSearchTap: widget.onSearchTap ?? onSearchTap,
          );
        },
      ),
    );

    return content;
  }

  void onSearchTap(List<ContactItemModel> data) async {
    List<NeedSearch> list = [];
    for (var item in data) {
      list.add(item);
    }
    final theme = ChatUIKitTheme.of(context);
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return ValueListenableBuilder(
          valueListenable: selectedProfiles,
          builder: (context, value, child) {
            return SearchContactsView(
              itemBuilder: (context, profile, searchKeyword) {
                return InkWell(
                  onTap: () {
                    tapContactInfo(profile);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 19.5, right: 15.5),
                    child: Row(
                      children: [
                        value.contains(profile)
                            ? Icon(
                                Icons.check_box,
                                size: 21,
                                color: theme.color.isDark
                                    ? theme.color.primaryColor6
                                    : theme.color.primaryColor5,
                              )
                            : Icon(
                                Icons.check_box_outline_blank,
                                size: 21,
                                color: theme.color.isDark
                                    ? theme.color.neutralColor4
                                    : theme.color.neutralColor7,
                              ),
                        ChatUIKitSearchListViewItem(
                          profile: profile,
                          highlightWord: searchKeyword,
                        ),
                      ],
                    ),
                  ),
                );
              },
              searchHideText: '搜索联系人',
              searchData: list,
            );
          },
        );
      },
    ).then((value) {});
  }

  void tapContactInfo(ChatUIKitProfile profile) {
    List<ChatUIKitProfile> list = selectedProfiles.value;
    if (list.contains(profile)) {
      list.remove(profile);
    } else {
      list.add(profile);
    }
    selectedProfiles.value = [...list];
  }
}