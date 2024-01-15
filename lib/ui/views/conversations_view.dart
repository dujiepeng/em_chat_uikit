import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

typedef AppBarMoreActionsBuilder = List<ChatUIKitBottomSheetItem> Function(
    BuildContext context, List<ChatUIKitBottomSheetItem> items);

class ConversationsView extends StatefulWidget {
  ConversationsView.arguments(ConversationsViewArguments arguments, {super.key})
      : listViewItemBuilder = arguments.listViewItemBuilder,
        beforeWidgets = arguments.beforeWidgets,
        afterWidgets = arguments.afterWidgets,
        onSearchTap = arguments.onSearchTap,
        fakeSearchHideText = arguments.fakeSearchHideText,
        listViewBackground = arguments.listViewBackground,
        onTap = arguments.onTap,
        onLongPress = arguments.onLongPress,
        appBar = arguments.appBar,
        controller = arguments.controller,
        appBarMoreActionsBuilder = arguments.appBarMoreActionsBuilder,
        enableAppBar = arguments.enableAppBar,
        title = arguments.title,
        attributes = arguments.attributes;

  const ConversationsView({
    this.listViewItemBuilder,
    this.beforeWidgets,
    this.afterWidgets,
    this.onSearchTap,
    this.fakeSearchHideText,
    this.listViewBackground,
    this.onTap,
    this.onLongPress,
    this.appBar,
    this.controller,
    this.enableAppBar = true,
    this.appBarMoreActionsBuilder,
    this.title,
    this.attributes,
    super.key,
  });

  final ConversationListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final void Function(List<ConversationInfo> data)? onSearchTap;
  final List<Widget>? beforeWidgets;
  final List<Widget>? afterWidgets;
  final ChatUIKitConversationItemBuilder? listViewItemBuilder;
  final void Function(BuildContext context, ConversationInfo info)? onTap;
  final List<ChatUIKitBottomSheetItem> Function(
    BuildContext context,
    ConversationInfo info,
    List<ChatUIKitBottomSheetItem> defaultActions,
  )? onLongPress;
  final String? fakeSearchHideText;
  final Widget? listViewBackground;
  final AppBarMoreActionsBuilder? appBarMoreActionsBuilder;
  final bool enableAppBar;
  final String? title;
  final String? attributes;

  @override
  State<ConversationsView> createState() => _ConversationsViewState();
}

class _ConversationsViewState extends State<ConversationsView> {
  late ConversationListViewController controller;
  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? ConversationListViewController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget content = Scaffold(
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: !widget.enableAppBar
          ? null
          : widget.appBar ??
              ChatUIKitAppBar(
                title: widget.title ?? 'Chats',
                showBackButton: false,
                titleTextStyle: TextStyle(
                  color: theme.color.isDark
                      ? theme.color.primaryColor6
                      : theme.color.primaryColor5,
                  fontSize: theme.font.titleLarge.fontSize,
                  fontWeight: FontWeight.w900,
                ),
                leading: Container(
                  margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                  child: ChatUIKitAvatar(
                    size: 32,
                    avatarUrl:
                        ChatUIKitProvider.instance.currentUserData?.avatarUrl,
                  ),
                ),
                trailing: IconButton(
                  iconSize: 24,
                  color: theme.color.isDark
                      ? theme.color.neutralColor95
                      : theme.color.neutralColor3,
                  icon: const Icon(Icons.add_circle_outline),
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onPressed: showMoreInfo,
                ),
              ),
      body: SafeArea(
        child: ConversationListView(
          controller: controller,
          itemBuilder: widget.listViewItemBuilder,
          beforeWidgets: widget.beforeWidgets,
          afterWidgets: widget.afterWidgets,
          searchHideText: widget.fakeSearchHideText,
          background: widget.listViewBackground,
          onTap: widget.onTap ??
              (BuildContext context, ConversationInfo info) {
                pushToMessagePage(info);
              },
          onLongPress: (BuildContext context, ConversationInfo info) {
            longPressed(info);
          },
          onSearchTap: widget.onSearchTap ?? onSearchTap,
        ),
      ),
    );

    return content;
  }

  void onSearchTap(List<ConversationInfo> data) {
    List<NeedSearch> list = [];
    for (var item in data) {
      list.add(item);
    }
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SearchUsersView(
          onTap: (ctx, profile) {
            Navigator.of(ctx).pop(profile);
          },
          searchHideText:
              ChatUIKitLocal.conversationsViewSearchHint.getString(context),
          searchData: list,
        );
      },
    ).then((value) {
      if (value != null && value is ChatUIKitProfile) {
        Navigator.of(context)
            .pushNamed(
          ChatUIKitRouteNames.messagesView,
          arguments: MessagesViewArguments(
            profile: value,
          ),
        )
            .then((value) {
          if (mounted) {
            controller.reload();
          }
        });
      }
    });
  }

  void pushToMessagePage(ConversationInfo info) {
    Navigator.of(context)
        .pushNamed(
      ChatUIKitRouteNames.messagesView,
      arguments: MessagesViewArguments(
        profile: info.profile,
      ),
    )
        .then((value) {
      if (mounted) {
        controller.reload();
      }
    });
  }

  void longPressed(ConversationInfo info) async {
    List<ChatUIKitBottomSheetItem> list = defaultLongPressActions(info);

    list = widget.onLongPress
            ?.call(context, info, defaultLongPressActions(info)) ??
        list;

    showChatUIKitBottomSheet(
      cancelTitle:
          ChatUIKitLocal.conversationListLongPressMenuCancel.getString(context),
      context: context,
      items: list,
    );
  }

  List<ChatUIKitBottomSheetItem> defaultLongPressActions(
      ConversationInfo info) {
    return [
      ChatUIKitBottomSheetItem.normal(
        label: info.noDisturb
            ? ChatUIKitLocal.conversationListLongPressMenuUnmute
                .getString(context)
            : ChatUIKitLocal.conversationListLongPressMenuMute
                .getString(context),
        onTap: () async {
          final type = info.profile.type == ChatUIKitProfileType.groupChat
              ? ConversationType.GroupChat
              : ConversationType.Chat;

          if (info.noDisturb) {
            ChatUIKit.instance.clearSilentMode(
              conversationId: info.profile.id,
              type: type,
            );
          } else {
            final param = ChatSilentModeParam.remindType(
              ChatPushRemindType.MENTION_ONLY,
            );
            ChatUIKit.instance.setSilentMode(
              param: param,
              conversationId: info.profile.id,
              type: type,
            );
          }

          Navigator.of(context).pop();
        },
      ),
      ChatUIKitBottomSheetItem.normal(
        label: info.pinned
            ? ChatUIKitLocal.conversationListLongPressMenuUnPin
                .getString(context)
            : ChatUIKitLocal.conversationListLongPressMenuPin
                .getString(context),
        onTap: () async {
          ChatUIKit.instance.pinConversation(
            conversationId: info.profile.id,
            isPinned: !info.pinned,
          );
          Navigator.of(context).pop();
        },
      ),
      if (info.unreadCount > 0)
        ChatUIKitBottomSheetItem.normal(
          label: ChatUIKitLocal.conversationListLongPressMenuRead
              .getString(context),
          onTap: () async {
            ChatUIKit.instance.markConversationAsRead(
              conversationId: info.profile.id,
            );
            Navigator.of(context).pop();
          },
        ),
      ChatUIKitBottomSheetItem.destructive(
        label: ChatUIKitLocal.conversationListLongPressMenuDelete
            .getString(context),
        onTap: () async {
          ChatUIKit.instance.deleteLocalConversation(
            conversationId: info.profile.id,
          );
          Navigator.of(context).pop();
        },
      ),
    ];
  }

  void showMoreInfo() {
    List<ChatUIKitBottomSheetItem> list = defaultItems();
    list = widget.appBarMoreActionsBuilder?.call(context, list) ?? list;
    showChatUIKitBottomSheet(
      cancelTitle:
          ChatUIKitLocal.conversationsViewMenuCancel.getString(context),
      context: context,
      items: list,
    );
  }

  List<ChatUIKitBottomSheetItem> defaultItems() {
    final theme = ChatUIKitTheme.of(context);
    return [
      ChatUIKitBottomSheetItem.normal(
        label: ChatUIKitLocal.conversationsViewMenuCreateNewChat
            .getString(context),
        icon: Icon(
          Icons.message,
          color: theme.color.isDark
              ? theme.color.primaryColor5
              : theme.color.primaryColor5,
        ),
        onTap: () async {
          Navigator.of(context).pop();
          newConversations();
        },
      ),
      ChatUIKitBottomSheetItem.normal(
        label:
            ChatUIKitLocal.conversationsViewMenuAddContact.getString(context),
        icon: Icon(
          Icons.person_add_alt_1,
          color: theme.color.isDark
              ? theme.color.primaryColor5
              : theme.color.primaryColor5,
        ),
        onTap: () async {
          Navigator.of(context).pop();
          addContact();
        },
      ),
      ChatUIKitBottomSheetItem.normal(
        label:
            ChatUIKitLocal.conversationsViewMenuCreateGroup.getString(context),
        icon: Icon(
          Icons.group,
          color: theme.color.isDark
              ? theme.color.primaryColor5
              : theme.color.primaryColor5,
        ),
        onTap: () async {
          Navigator.of(context).pop();
          newGroup();
        },
      ),
    ];
  }

  void newConversations() async {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.95,
          child: SelectContactView(
            backText: ChatUIKitLocal.conversationsViewMenuCreateNewChat
                .getString(context),
          ),
        );
      },
    ).then((profile) {
      if (profile != null) {
        pushNewConversation(profile);
      }
    });
  }

  void addContact() async {
    String? userId = await showChatUIKitDialog(
      borderType: ChatUIKitRectangleType.filletCorner,
      title: ChatUIKitLocal.addContactTitle.getString(context),
      content: ChatUIKitLocal.addContactSubTitle.getString(context),
      context: context,
      hintsText: [ChatUIKitLocal.addContactInputHints.getString(context)],
      items: [
        ChatUIKitDialogItem.cancel(
          label: ChatUIKitLocal.addContactCancel.getString(context),
          onTap: () async {
            Navigator.of(context).pop();
          },
        ),
        ChatUIKitDialogItem.inputsConfirm(
          label: ChatUIKitLocal.addContactConfirm.getString(context),
          onInputsTap: (inputs) async {
            Navigator.of(context).pop(inputs.first);
          },
        ),
      ],
    );

    if (userId?.isNotEmpty == true) {
      try {
        await ChatUIKit.instance.sendContactRequest(userId: userId!);
        // ignore: empty_catches
      } catch (e) {}
    }
  }

  void newGroup() async {
    final group = await Navigator.of(context).pushNamed(
      ChatUIKitRouteNames.createGroupView,
      arguments: CreateGroupViewArguments(
        attributes: widget.attributes,
      ),
    );
    if (group is Group) {
      await ChatUIKitInsertMessageTool.insertCreateGroupMessage(
        group: group,
      );
      pushNewConversation(ChatUIKitProfile.groupMember(
        id: group.groupId,
        name: group.name,
      ));
    }
  }

  void pushNewConversation(ChatUIKitProfile profile) {
    Navigator.of(context)
        .pushNamed(
      ChatUIKitRouteNames.messagesView,
      arguments: MessagesViewArguments(
        profile: profile,
      ),
    )
        .then((value) {
      if (mounted) {
        controller.reload();
      }
    });
  }
}
