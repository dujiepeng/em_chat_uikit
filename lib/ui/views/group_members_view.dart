import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class GroupMembersView extends StatefulWidget {
  GroupMembersView.arguments(GroupMembersViewArguments arguments, {Key? key})
      : groupId = arguments.groupId,
        listViewItemBuilder = arguments.listViewItemBuilder,
        onSearchTap = arguments.onSearchTap,
        fakeSearchHideText = arguments.fakeSearchHideText,
        listViewBackground = arguments.listViewBackground,
        onTap = arguments.onTap,
        onLongPress = arguments.onLongPress,
        appBar = arguments.appBar,
        controller = arguments.controller,
        loadErrorMessage = arguments.loadErrorMessage,
        enableMemberOperation = arguments.enableMemberOperation,
        super(key: key);

  const GroupMembersView({
    required this.groupId,
    this.listViewItemBuilder,
    this.onSearchTap,
    this.fakeSearchHideText,
    this.listViewBackground,
    this.onTap,
    this.onLongPress,
    this.appBar,
    this.controller,
    this.loadErrorMessage,
    this.enableMemberOperation = false,
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
  final String? loadErrorMessage;
  final bool enableMemberOperation;

  @override
  State<GroupMembersView> createState() => _GroupMembersViewState();
}

class _GroupMembersViewState extends State<GroupMembersView>
    with GroupObserver {
  late final GroupMemberListViewController controller;
  List<ContactItemModel>? addedBuffers;
  List<ContactItemModel>? deleteBuffer;
  ValueNotifier<int> memberCount = ValueNotifier<int>(0);
  Group? group;
  @override
  void initState() {
    super.initState();
    ChatUIKit.instance.addObserver(this);
    controller = widget.controller ??
        GroupMemberListViewController(groupId: widget.groupId);
    fetchGroup();
  }

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onMemberJoinedFromGroup(String groupId, String member) {
    memberCount.value = memberCount.value + 1;
  }

  @override
  void onMemberExitedFromGroup(String groupId, String member) {
    memberCount.value = memberCount.value - 1;
  }

  void fetchGroup() async {
    try {
      group = await ChatUIKit.instance.getGroup(groupId: widget.groupId);
      group ??=
          await ChatUIKit.instance.fetchGroupInfo(groupId: widget.groupId);
      debugPrint(group?.memberCount.toString());
      memberCount.value = group?.memberCount ?? 0;
      // ignore: empty_catches
    } catch (e) {}
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
            trailing: widget.enableMemberOperation
                ? actionsWidget()
                : const SizedBox(),
            leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: ValueListenableBuilder(
                valueListenable: memberCount,
                builder: (context, value, child) {
                  if (memberCount.value == 0) {
                    return Text(
                      '群成员',
                      style: TextStyle(
                        color: theme.color.isDark
                            ? theme.color.neutralColor98
                            : theme.color.neutralColor1,
                        fontWeight: theme.font.titleMedium.fontWeight,
                        fontSize: theme.font.titleMedium.fontSize,
                      ),
                    );
                  } else {
                    return Text(
                      '群成员(${memberCount.value})',
                      style: TextStyle(
                        color: theme.color.isDark
                            ? theme.color.neutralColor98
                            : theme.color.neutralColor1,
                        fontWeight: theme.font.titleMedium.fontWeight,
                        fontSize: theme.font.titleMedium.fontSize,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
      body: GroupMemberListView(
        groupId: widget.groupId,
        controller: controller,
        itemBuilder: widget.listViewItemBuilder,
        searchHideText: widget.fakeSearchHideText,
        background: widget.listViewBackground,
        onTap: widget.onTap ??
            (context, model) {
              onMemberTap(context, model.profile);
            },
        onSearchTap: widget.onSearchTap ?? onSearchTap,
      ),
    );

    return content;
  }

  Widget actionsWidget() {
    final theme = ChatUIKitTheme.of(context);
    Widget content = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: pushToAddMember,
          child: Icon(
            Icons.person_add_alt_1_outlined,
            color: theme.color.isDark
                ? theme.color.neutralColor9
                : theme.color.neutralColor3,
            size: 24,
          ),
        ),
        InkWell(
          onTap: pushToRemoveMember,
          child: Icon(
            Icons.person_remove_alt_1_outlined,
            color: theme.color.isDark
                ? theme.color.neutralColor9
                : theme.color.neutralColor3,
            size: 24,
          ),
        )
      ],
    );

    content = Container(
      margin: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      width: 74,
      height: 36,
      child: content,
    );
    return content;
  }

  void onMemberTap(BuildContext context, ChatUIKitProfile profile) async {
    List<String> contacts = await ChatUIKit.instance.getAllContacts();
    if (contacts.contains(profile.id)) {
      pushContactDetails(profile);
    } else {
      pushNewRequestDetails(profile);
    }
  }

  void pushContactDetails(ChatUIKitProfile profile) {
    Navigator.of(context).pushNamed(
      ChatUIKitRouteNames.contactDetailsView,
      arguments: ContactDetailsViewArguments(
        profile: profile,
        actions: [
          ChatUIKitActionItem(
            title: '发消息',
            icon: 'assets/images/chat.png',
            onTap: (context) {
              // TODO: 直接跳转到聊天页面
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void pushNewRequestDetails(ChatUIKitProfile profile) {
    Navigator.of(context).pushNamed(
      ChatUIKitRouteNames.newRequestDetailsView,
      arguments: NewRequestDetailsViewArguments(profile: profile),
    );
  }

  void pushToAddMember() async {
    List<String> members = [];

    List list = controller.list;
    for (var element in list) {
      if (element is ContactItemModel) {
        members.add(element.profile.id);
      }
    }

    await Navigator.of(context)
        .pushNamed(
          ChatUIKitRouteNames.groupAddMembersView,
          arguments: GroupAddMembersViewArguments(
            groupId: widget.groupId,
            inGroupMembers: members,
          ),
        )
        .then((value) {
          if (value != null && value is List<ChatUIKitProfile>) {
            List<ContactItemModel> models = [];
            List<String> userIds = [];
            for (var item in value) {
              userIds.add(item.id);
              models.add(ContactItemModel(profile: item));
            }
            ChatUIKit.instance.addGroupMembers(
              groupId: widget.groupId,
              members: userIds,
            );

            controller.list.addAll(models);
            controller.reload();
          }
        })
        .then((value) {})
        .catchError((e) {});
  }

  void pushToRemoveMember() {
    Navigator.of(context)
        .pushNamed(
          ChatUIKitRouteNames.groupDeleteMembersView,
          arguments: GroupDeleteMembersViewArguments(groupId: widget.groupId),
        )
        .then((value) {
          if (value != null && value is List<ChatUIKitProfile>) {
            List<String> userIds = [];
            for (var item in value) {
              userIds.add(item.id);
            }
            ChatUIKit.instance.deleteGroupMembers(
              groupId: widget.groupId,
              members: userIds,
            );

            for (var userId in userIds) {
              controller.list.removeWhere((element) {
                return (element is ContactItemModel &&
                    element.profile.id == userId);
              });
            }
            controller.refresh();
          }
        })
        .then((value) {})
        .catchError((e) {});
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
        return SearchGroupMembersView(
          itemBuilder: (context, profile, searchKeyword) {
            return InkWell(
              onTap: () {
                onMemberTap(context, profile);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 19.5, right: 15.5),
                child: ChatUIKitSearchListViewItem(
                  profile: profile,
                  highlightWord: searchKeyword,
                ),
              ),
            );
          },
          searchHideText: '搜索群成员',
          searchData: list,
        );
      },
    ).then((value) {});
  }
}
