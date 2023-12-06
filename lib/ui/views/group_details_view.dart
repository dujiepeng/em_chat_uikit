import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const String userGroupName = 'chatUIKit_group_member_nick_name';

class GroupDetailsView extends StatefulWidget {
  GroupDetailsView.arguments(
    GroupDetailsViewArguments arguments, {
    super.key,
  })  : profile = arguments.profile,
        actions = arguments.actions;

  const GroupDetailsView(
      {required this.profile, required this.actions, super.key});
  final List<ChatUIKitActionItem> actions;
  final ChatUIKitProfile profile;

  @override
  State<GroupDetailsView> createState() => _GroupDetailsViewState();
}

class _GroupDetailsViewState extends State<GroupDetailsView> {
  ValueNotifier<bool> isNotDisturb = ValueNotifier<bool>(false);
  ValueNotifier<int> memberCount = ValueNotifier<int>(0);
  Group? group;
  late final List<ChatUIKitActionItem>? actions;
  @override
  void initState() {
    super.initState();
    assert(widget.actions.length <= 5,
        'The number of actions in the list cannot exceed 5');
    actions = widget.actions;
    fetchInfo();
    fetchGroup();
  }

  void fetchGroup() async {
    group = await ChatUIKit.instance.getGroup(groupId: widget.profile.id);
    group ??=
        await ChatUIKit.instance.fetchGroupInfo(groupId: widget.profile.id);
    debugPrint(group?.memberCount.toString());
    memberCount.value = (group?.memberCount ?? 0) + 1;
  }

  void fetchInfo() async {
    Conversation conversation = await ChatUIKit.instance.createConversation(
        conversationId: widget.profile.id, type: ConversationType.GroupChat);
    Map<String, ChatSilentModeResult> map = await ChatUIKit.instance
        .fetchSilentModel(conversations: [conversation]);
    isNotDisturb.value = map.values.first.remindType != ChatPushRemindType.ALL;
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget content = Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: theme.color.isDark
            ? theme.color.neutralColor1
            : theme.color.neutralColor98,
        appBar: ChatUIKitAppBar(
          autoBackButton: true,
          trailing: IconButton(
            iconSize: 24,
            color: theme.color.isDark
                ? theme.color.neutralColor95
                : theme.color.neutralColor3,
            icon: const Icon(Icons.more_vert),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onPressed: showBottom,
          ),
        ),
        body: _buildContent());

    return content;
  }

  Widget _buildContent() {
    final theme = ChatUIKitTheme.of(context);
    Widget avatar = statusAvatar();

    Widget name = Text(
      widget.profile.name ?? widget.profile.id,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: theme.font.headlineLarge.fontSize,
        fontWeight: theme.font.headlineLarge.fontWeight,
        color: theme.color.isDark
            ? theme.color.neutralColor100
            : theme.color.neutralColor1,
      ),
    );

    Widget easeId = Text(
      '环信ID: ${widget.profile.id}',
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: theme.font.bodySmall.fontSize,
        fontWeight: theme.font.bodySmall.fontWeight,
        color: theme.color.isDark
            ? theme.color.neutralColor5
            : theme.color.neutralColor7,
      ),
    );

    Widget row = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        easeId,
        const SizedBox(width: 2),
        InkWell(
          onTap: () {
            Clipboard.setData(ClipboardData(text: widget.profile.id));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('复制成功'),
              ),
            );
          },
          child: Icon(
            Icons.file_copy_sharp,
            size: 16,
            color: theme.color.isDark
                ? theme.color.neutralColor5
                : theme.color.neutralColor7,
          ),
        ),
      ],
    );

    List<Widget> items = [];

    double width = () {
      if (widget.actions.length > 2) {
        return (MediaQuery.of(context).size.width -
                24 -
                widget.actions.length * 8 -
                MediaQuery.of(context).padding.left -
                MediaQuery.of(context).padding.right) /
            widget.actions.length;
      } else {
        return 114.0;
      }
    }();

    for (var action in widget.actions) {
      items.add(
        InkWell(
          onTap: () => action.onTap?.call(context),
          child: Container(
            margin: const EdgeInsets.only(left: 4, right: 4),
            height: 62,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: theme.color.isDark
                  ? theme.color.neutralColor2
                  : theme.color.neutralColor95,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Image.asset(
                    action.icon,
                    color: theme.color.isDark
                        ? theme.color.primaryColor6
                        : theme.color.primaryColor5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  action.title,
                  style: TextStyle(
                    fontSize: theme.font.bodySmall.fontSize,
                    fontWeight: theme.font.bodySmall.fontWeight,
                    color: theme.color.isDark
                        ? theme.color.primaryColor6
                        : theme.color.primaryColor5,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget actionItem = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: items,
    );

    Widget content = Column(
      children: [
        const SizedBox(height: 20),
        avatar,
        const SizedBox(height: 12),
        name,
        const SizedBox(height: 4),
        row,
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: actionItem,
        ),
        const SizedBox(height: 20),
      ],
    );

    content = ListView(
      children: [
        content,
        InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return GroupMemberListView(
                  groupId: widget.profile.id,
                );
              },
            ));
          },
          child: ChatUIKitDetailsItem(
            title: '群成员',
            trailing: SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ValueListenableBuilder(
                    valueListenable: memberCount,
                    builder: (context, value, child) {
                      if (memberCount.value == 0) {
                        return const SizedBox();
                      } else {
                        return Text(
                          '${memberCount.value}人',
                          style: TextStyle(
                            color: theme.color.isDark
                                ? theme.color.neutralColor6
                                : theme.color.neutralColor5,
                            fontSize: theme.font.labelLarge.fontSize,
                            fontWeight: theme.font.labelLarge.fontWeight,
                          ),
                        );
                      }
                    },
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: theme.color.isDark
                        ? theme.color.neutralColor5
                        : theme.color.neutralColor7,
                    size: 18,
                  )
                ],
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            changeInfo('我在本群的昵称', hint: '请输入');
          },
          child: ChatUIKitDetailsItem(
            title: '我在本群昵称',
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: theme.color.isDark
                  ? theme.color.neutralColor5
                  : theme.color.neutralColor7,
              size: 18,
            ),
          ),
        ),
        ChatUIKitDetailsItem(
          title: '消息免打扰',
          trailing: ValueListenableBuilder(
            valueListenable: isNotDisturb,
            builder: (context, value, child) {
              return CupertinoSwitch(
                value: isNotDisturb.value,
                activeColor: theme.color.isDark
                    ? theme.color.primaryColor6
                    : theme.color.primaryColor5,
                trackColor: theme.color.isDark
                    ? theme.color.neutralColor3
                    : theme.color.neutralColor9,
                onChanged: (value) async {
                  if (value == true) {
                    await ChatUIKit.instance.setSilentMode(
                        conversationId: widget.profile.id,
                        type: ConversationType.GroupChat,
                        param: ChatSilentModeParam.remindType(
                            ChatPushRemindType.MENTION_ONLY));
                  } else {
                    await ChatUIKit.instance.clearSilentMode(
                        conversationId: widget.profile.id,
                        type: ConversationType.Chat);
                  }
                  setState(() {
                    isNotDisturb.value = value;
                  });
                },
              );
            },
          ),
        ),
        InkWell(
          onTap: clearAllHistory,
          child: const ChatUIKitDetailsItem(title: '清空聊天记录'),
        ),
      ],
    );

    return content;
  }

  void clearAllHistory() {
    showChatUIKitDialog(
      title: '确认清空聊天记录?',
      context: context,
      items: [
        ChatUIKitDialogItem.cancel(
          label: '取消',
          onTap: () async {
            Navigator.of(context).pop();
          },
        ),
        ChatUIKitDialogItem.confirm(
          label: '确认',
          onTap: () async {
            Navigator.of(context).pop();
            Conversation conversation = await ChatUIKit.instance
                .createConversation(
                    conversationId: widget.profile.id,
                    type: ConversationType.Chat);
            await conversation.deleteAllMessages();
          },
        ),
      ],
    );
  }

  void showBottom() async {
    List<ChatUIKitBottomSheetItem> list = [];
    if (group?.permissionType == GroupPermissionType.Owner) {
      list.add(
        ChatUIKitBottomSheetItem.normal(
          label: '转移群组',
          onTap: () async {
            Navigator.of(context).pop(true);
            changeOwner();
          },
        ),
      );
      list.add(
        ChatUIKitBottomSheetItem.destructive(
          label: '解散群组',
          onTap: () async {
            Navigator.of(context).pop(true);
            destroyGroup();
          },
        ),
      );
    } else {
      list.add(
        ChatUIKitBottomSheetItem.destructive(
          label: '退出群聊',
          onTap: () async {
            Navigator.of(context).pop(true);
            leaveGroup();
          },
        ),
      );
    }

    await showChatUIKitBottomSheet(
      cancelTitle: '取消',
      context: context,
      items: list,
    );
  }

  Widget statusAvatar() {
    final theme = ChatUIKitTheme.of(context);
    return FutureBuilder(
      future:
          ChatUIKit.instance.fetchPresenceStatus(members: [widget.profile.id]),
      builder: (context, snapshot) {
        if (snapshot.hasData == false) {
          return ChatUIKitAvatar(
            avatarUrl: widget.profile.avatarUrl,
            size: 100,
          );
        }
        Widget content;
        if (snapshot.data?.isNotEmpty == true) {
          Presence presence = snapshot.data![0];
          if (presence.statusDetails?.values.any((element) => element != 0) ==
              true) {
            content = Stack(
              children: [
                const SizedBox(width: 110, height: 110),
                ChatUIKitAvatar(
                  avatarUrl: widget.profile.avatarUrl,
                  size: 100,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 15,
                    height: 20,
                    color: theme.color.isDark
                        ? theme.color.primaryColor1
                        : theme.color.primaryColor98,
                  ),
                ),
                Positioned(
                  right: 5,
                  bottom: 10,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: theme.color.isDark
                          ? theme.color.secondaryColor6
                          : theme.color.secondaryColor5,
                      border: Border.all(
                        color: theme.color.isDark
                            ? theme.color.primaryColor1
                            : theme.color.primaryColor98,
                        width: 4,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ],
            );
          } else {
            content = ChatUIKitAvatar(
              avatarUrl: widget.profile.avatarUrl,
              size: 100,
            );
          }
        } else {
          content = ChatUIKitAvatar(
            avatarUrl: widget.profile.avatarUrl,
            size: 100,
          );
        }
        return content;
      },
    );
  }

  void destroyGroup() {
    showChatUIKitDialog(
      title: '确认解散群组?',
      content: '确认解散群组，同时删除该群的聊天记录。',
      context: context,
      items: [
        ChatUIKitDialogItem.cancel(
          label: '取消',
          onTap: () async {
            Navigator.of(context).pop();
          },
        ),
        ChatUIKitDialogItem.confirm(
          label: '解散',
          onTap: () async {
            Navigator.of(context).pop();
            ChatUIKit.instance.destroyGroup(groupId: widget.profile.id);
          },
        ),
      ],
    );
  }

  void leaveGroup() {
    showChatUIKitDialog(
      title: '确认退出群聊?',
      content: '确认退出群组，同时删除该群的聊天记录。',
      context: context,
      items: [
        ChatUIKitDialogItem.cancel(
          label: '取消',
          onTap: () async {
            Navigator.of(context).pop();
          },
        ),
        ChatUIKitDialogItem.confirm(
          label: '退出',
          onTap: () async {
            Navigator.of(context).pop();
            ChatUIKit.instance.leaveGroup(groupId: widget.profile.id);
          },
        ),
      ],
    );
  }

  void changeOwner() {
    Navigator.of(context).pushNamed(
      ChatUIKitRouteNames.groupChangeOwnerView,
      arguments: GroupChangeOwnerViewArguments(
        groupId: widget.profile.id,
      ),
    );
  }

  void changeInfo(String title, {String? hint}) {
    Navigator.of(context)
        .pushNamed(ChatUIKitRouteNames.changeInfoView,
            arguments: ChangeInfoViewArguments(
                title: title,
                hint: hint,
                inputTextCallback: () async {
                  if (group?.groupId != null) {
                    Map<String, String> map = await ChatUIKit.instance
                        .fetchGroupMemberAttributes(
                            groupId: group!.groupId,
                            userId: ChatUIKit.instance.currentUserId());

                    return map[userGroupName];
                  }
                  return null;
                }))
        .then((value) {
      if (value != null) {
        if (value is String) {
          ChatUIKit.instance
              .setGroupMemberAttributes(
                  groupId: group!.groupId,
                  userId: ChatUIKit.instance.currentUserId(),
                  attributes: {userGroupName: value})
              .then((_) {})
              .catchError((e) {
                debugPrint(e.toString());
              });
        }
      }
    });
  }
}
