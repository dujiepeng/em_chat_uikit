import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactDetailsView extends StatefulWidget {
  ContactDetailsView.arguments(ContactDetailsViewArguments arguments,
      {super.key})
      : actions = arguments.actions,
        profile = arguments.profile;

  const ContactDetailsView({
    required this.profile,
    required this.actions,
    super.key,
  });

  final ChatUIKitProfile profile;
  final List<ChatUIKitActionItem> actions;
  @override
  State<ContactDetailsView> createState() => _ContactDetailsViewState();
}

class _ContactDetailsViewState extends State<ContactDetailsView> {
  ValueNotifier<bool> isNotDisturb = ValueNotifier<bool>(false);

  late final List<ChatUIKitActionItem>? actions;
  @override
  void initState() {
    super.initState();
    assert(widget.actions.length <= 5,
        'The number of actions in the list cannot exceed 5');
    actions = widget.actions;
    fetchInfo();
  }

  void fetchInfo() async {
    Conversation conversation = await ChatUIKit.instance.createConversation(
        conversationId: widget.profile.id, type: ConversationType.Chat);
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
                        type: ConversationType.Chat,
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

  void doNotDisturb() {}

  void blockUser() {}

  void clearAllHistory() {
    showChatUIKitDialog(
      title: '确认清空聊天记录?',
      content: '清空聊天记录后，你将无法查看与该联系人的聊天记录。',
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
    bool? ret = await showChatUIKitBottomSheet(
      cancelTitle: '取消',
      context: context,
      items: [
        ChatUIKitBottomSheetItem.destructive(
          label: '删除联系人',
          onTap: () async {
            Navigator.of(context).pop(true);
            return true;
          },
        ),
      ],
    );

    if (ret == true) {
      deleteContact();
    }
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

  void deleteContact() {
    showChatUIKitDialog(
      title: '确认删除联系人?',
      content: '确认删除${widget.profile.name ?? widget.profile.id}同时删除与该联系人的聊天记录。',
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
            ChatUIKit.instance.deleteContact(userId: widget.profile.id);
          },
        ),
      ],
    );
  }
}
