import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class _GroupDetailsViewState extends State<GroupDetailsView>
    with GroupObserver {
  ValueNotifier<bool> isNotDisturb = ValueNotifier<bool>(false);
  int memberCount = 0;
  Group? group;
  late final List<ChatUIKitActionItem>? actions;
  @override
  void initState() {
    super.initState();
    assert(widget.actions.length <= 5,
        'The number of actions in the list cannot exceed 5');

    ChatUIKit.instance.addObserver(this);
    actions = widget.actions;
    isNotDisturb.value =
        ChatUIKitContext.instance.conversationIsMute(widget.profile.id);
    fetchInfo();
    fetchGroup();
    fetchMembersAttrs();
  }

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onMemberJoinedFromGroup(String groupId, String member) {
    if (groupId == widget.profile.id) {
      memberCount += 1;
    }
  }

  @override
  void onMemberExitedFromGroup(String groupId, String member) {
    if (groupId == widget.profile.id) {
      memberCount -= 1;
    }
  }

  void fetchGroup() async {
    try {
      group = await ChatUIKit.instance.getGroup(groupId: widget.profile.id);
      group ??=
          await ChatUIKit.instance.fetchGroupInfo(groupId: widget.profile.id);
      memberCount = group?.memberCount ?? 0;
      setState(() {});
      // ignore: empty_catches
    } catch (e) {}
  }

  void fetchInfo() async {
    Conversation conversation = await ChatUIKit.instance.createConversation(
        conversationId: widget.profile.id, type: ConversationType.GroupChat);
    Map<String, ChatSilentModeResult> map = await ChatUIKit.instance
        .fetchSilentModel(conversations: [conversation]);
    isNotDisturb.value = map.values.first.remindType != ChatPushRemindType.ALL;
  }

  void fetchMembersAttrs() async {
    // TODO 缓存用户属性
    await ChatUIKit.instance.fetchGroupMemberAttributes(
      groupId: widget.profile.id,
    );
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
          showBackButton: true,
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
      widget.profile.showName,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
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
      maxLines: 1,
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    action.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: theme.font.bodySmall.fontSize,
                      fontWeight: theme.font.bodySmall.fontWeight,
                      color: theme.color.isDark
                          ? theme.color.primaryColor6
                          : theme.color.primaryColor5,
                    ),
                  ),
                )
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
            Navigator.of(context).pushNamed(
              ChatUIKitRouteNames.groupMembersView,
              arguments: GroupMembersViewArguments(
                groupId: widget.profile.id,
                enableMemberOperation:
                    group?.permissionType == GroupPermissionType.Owner,
              ),
            );
          },
          child: ChatUIKitDetailsListViewItem(
            title: '群成员',
            trailing: SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  () {
                    if (memberCount == 0) {
                      return const SizedBox();
                    } else {
                      return Text(
                        '$memberCount人',
                        style: TextStyle(
                          color: theme.color.isDark
                              ? theme.color.neutralColor6
                              : theme.color.neutralColor5,
                          fontSize: theme.font.labelLarge.fontSize,
                          fontWeight: theme.font.labelLarge.fontWeight,
                        ),
                      );
                    }
                  }(),
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
            changeGroupNickname();
          },
          child: ChatUIKitDetailsListViewItem(
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
        ChatUIKitDetailsListViewItem(
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
          child: const ChatUIKitDetailsListViewItem(title: '清空聊天记录'),
        ),
        if (group?.permissionType == GroupPermissionType.Owner) ...[
          Container(height: 20),
          InkWell(
            onTap: () {
              changeGroupName();
            },
            child: ChatUIKitDetailsListViewItem(
              title: '群名称',
              trailing: SizedBox(
                width: 100,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        group?.name ?? "",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: theme.color.isDark
                              ? theme.color.neutralColor6
                              : theme.color.neutralColor5,
                          fontSize: theme.font.labelLarge.fontSize,
                          fontWeight: theme.font.labelLarge.fontWeight,
                        ),
                      ),
                    ),
                    const SizedBox(width: 2),
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
              changeGroupDesc();
            },
            child: ChatUIKitDetailsListViewItem(
              title: '群描述',
              trailing: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        group?.description ?? "",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        maxLines: 1,
                        style: TextStyle(
                          color: theme.color.isDark
                              ? theme.color.neutralColor6
                              : theme.color.neutralColor5,
                          fontSize: theme.font.labelLarge.fontSize,
                          fontWeight: theme.font.labelLarge.fontWeight,
                        ),
                      ),
                    ),
                    const SizedBox(width: 2),
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
        ]
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
            Navigator.of(context).pop();
            changeOwner();
          },
        ),
      );
      list.add(
        ChatUIKitBottomSheetItem.destructive(
          label: '解散群组',
          onTap: () async {
            Navigator.of(context).pop();
            destroyGroup();
          },
        ),
      );
    } else {
      list.add(
        ChatUIKitBottomSheetItem.destructive(
          label: '退出群聊',
          onTap: () async {
            Navigator.of(context).pop();
            leaveGroup();
          },
        ),
      );
    }

    showChatUIKitBottomSheet(
      cancelTitle: '取消',
      context: context,
      items: list,
    );
  }

  Widget statusAvatar() {
    // 暂时不需要订阅
    return ChatUIKitAvatar(
      avatarUrl: widget.profile.avatarUrl,
      size: 100,
    );
    // final theme = ChatUIKitTheme.of(context);
    // return FutureBuilder(
    //   future:
    //       ChatUIKit.instance.fetchPresenceStatus(members: [widget.profile.id]),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData == false) {
    //       return ChatUIKitAvatar(
    //         avatarUrl: widget.profile.avatarUrl,
    //         size: 100,
    //       );
    //     }
    //     Widget content;
    //     if (snapshot.data?.isNotEmpty == true) {
    //       Presence presence = snapshot.data![0];
    //       if (presence.statusDetails?.values.any((element) => element != 0) ==
    //           true) {
    //         content = Stack(
    //           children: [
    //             const SizedBox(width: 110, height: 110),
    //             ChatUIKitAvatar(
    //               avatarUrl: widget.profile.avatarUrl,
    //               size: 100,
    //             ),
    //             Positioned(
    //               right: 0,
    //               bottom: 0,
    //               child: Container(
    //                 width: 15,
    //                 height: 20,
    //                 color: theme.color.isDark
    //                     ? theme.color.primaryColor1
    //                     : theme.color.primaryColor98,
    //               ),
    //             ),
    //             Positioned(
    //               right: 5,
    //               bottom: 10,
    //               child: Container(
    //                 width: 22,
    //                 height: 22,
    //                 decoration: BoxDecoration(
    //                   color: theme.color.isDark
    //                       ? theme.color.secondaryColor6
    //                       : theme.color.secondaryColor5,
    //                   border: Border.all(
    //                     color: theme.color.isDark
    //                         ? theme.color.primaryColor1
    //                         : theme.color.primaryColor98,
    //                     width: 4,
    //                   ),
    //                   borderRadius: BorderRadius.circular(15),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         );
    //       } else {
    //         content = ChatUIKitAvatar(
    //           avatarUrl: widget.profile.avatarUrl,
    //           size: 100,
    //         );
    //       }
    //     } else {
    //       content = ChatUIKitAvatar(
    //         avatarUrl: widget.profile.avatarUrl,
    //         size: 100,
    //       );
    //     }
    //     return content;
    //   },
    // );
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
            ChatUIKit.instance
                .destroyGroup(groupId: widget.profile.id)
                .then((value) {
              Navigator.of(context).pop(true);
            }).catchError((e) {});
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
            ChatUIKit.instance
                .leaveGroup(groupId: widget.profile.id)
                .then((value) {
              Navigator.of(context).pop(true);
            }).catchError((e) {});
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

  void changeGroupNickname() {
    Navigator.of(context)
        .pushNamed(ChatUIKitRouteNames.changeInfoView,
            arguments: ChangeInfoViewArguments(
                title: '我在本群的昵称',
                maxLength: 32,
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
          ChatUIKit.instance.setGroupMemberAttributes(
              groupId: group!.groupId,
              userId: ChatUIKit.instance.currentUserId(),
              attributes: {userGroupName: value}).then((_) {
            fetchMembersAttrs();
          }).catchError(
            (e) {
              debugPrint(e.toString());
            },
          );
        }
      }
    });
  }

  void changeGroupName() {
    Navigator.of(context)
        .pushNamed(ChatUIKitRouteNames.changeInfoView,
            arguments: ChangeInfoViewArguments(
                title: '修改群名称',
                maxLength: 32,
                inputTextCallback: () async {
                  if (group?.groupId != null) {
                    return group!.name ?? '';
                  }
                  return null;
                }))
        .then((value) {
      if (value != null) {
        if (value is String) {
          ChatUIKit.instance
              .changeGroupName(groupId: group!.groupId, name: value)
              .then((_) {
            fetchGroup();
          }).catchError((e) {
            debugPrint(e.toString());
          });
        }
      }
    });
  }

  void changeGroupDesc() {
    Navigator.of(context)
        .pushNamed(
      ChatUIKitRouteNames.changeInfoView,
      arguments: ChangeInfoViewArguments(
        title: '修改群描述',
        maxLength: 512,
        inputTextCallback: () async {
          if (group?.groupId != null) {
            if (group?.groupId != null) {
              return group!.description ?? '';
            }
          }
          return null;
        },
      ),
    )
        .then((value) {
      if (value != null) {
        if (value is String) {
          ChatUIKit.instance
              .changeGroupDescription(groupId: group!.groupId, desc: value)
              .then((_) {
            fetchGroup();
          }).catchError((e) {
            debugPrint(e.toString());
          });
        }
      }
    });
  }
}
