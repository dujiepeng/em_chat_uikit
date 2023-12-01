import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ContactDetailsView extends StatefulWidget {
  const ContactDetailsView({required this.profile, super.key});

  final ChatUIKitProfile profile;

  @override
  State<ContactDetailsView> createState() => _ContactDetailsViewState();
}

class _ContactDetailsViewState extends State<ContactDetailsView> {
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
        body: Container());

    return content;
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
