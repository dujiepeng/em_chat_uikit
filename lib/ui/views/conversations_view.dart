import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

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
        enableAppBar = arguments.enableAppBar;

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
    super.key,
  });

  final ConversationListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final void Function(List<ConversationInfo> data)? onSearchTap;
  final List<NeedAlphabeticalWidget>? beforeWidgets;
  final List<NeedAlphabeticalWidget>? afterWidgets;
  final ChatUIKitListItemBuilder? listViewItemBuilder;
  final void Function(BuildContext context, ConversationInfo info)? onTap;
  final void Function(BuildContext context, ConversationInfo info)? onLongPress;
  final String? fakeSearchHideText;
  final Widget? listViewBackground;
  final bool enableAppBar;
  @override
  State<ConversationsView> createState() => _ConversationsViewState();
}

class _ConversationsViewState extends State<ConversationsView>
    with ChatUIKitProviderObserver {
  late ConversationListViewController controller;
  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? ConversationListViewController();
    ChatUIKitProvider.instance.addObserver(this);
  }

  @override
  void dispose() {
    ChatUIKitProvider.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onConversationProfilesUpdate(
    Map<String, ChatUIKitProfile> map,
  ) {
    controller.reload();
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
                title: 'Chats',
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
                  child: const ChatUIKitAvatar(size: 32),
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
          onLongPress: widget.onLongPress ??
              (BuildContext context, ConversationInfo info) {
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
        return SearchContactsView(
          onTap: (ctx, profile) {
            Navigator.of(ctx).pop(profile);
          },
          searchHideText: '搜索',
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
          controller.reload();
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
      controller.reload();
    });
  }

  void longPressed(ConversationInfo info) async {
    showChatUIKitBottomSheet(
      cancelTitle:
          ChatUIKitLocal.conversationListLongPressMenuCancel.getString(context),
      context: context,
      items: [
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
                  ChatPushRemindType.MENTION_ONLY);
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
      ],
    );
  }

  void showMoreInfo() {
    final theme = ChatUIKitTheme.of(context);
    showChatUIKitBottomSheet(
      cancelTitle: ChatUIKitLocal.conversationViewMenuCancel.getString(context),
      context: context,
      items: [
        ChatUIKitBottomSheetItem.normal(
          label: ChatUIKitLocal.conversationViewMenuCreateNewChat
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
              ChatUIKitLocal.conversationViewMenuAddContact.getString(context),
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
              ChatUIKitLocal.conversationViewMenuCreateGroup.getString(context),
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
      ],
    );
  }

  void newConversations() async {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.95,
          child: SelectContactView(
            backText: ChatUIKitLocal.conversationViewMenuCreateNewChat
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
      arguments: CreateGroupViewArguments(),
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
      controller.reload();
    });
  }
}
