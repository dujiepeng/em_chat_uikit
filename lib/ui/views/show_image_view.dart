import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class ShowImageView extends StatefulWidget {
  ShowImageView.arguments(ShowImageViewArguments argument, {super.key})
      : message = argument.message,
        onImageTap = argument.onImageTap,
        onImageLongPressed = argument.onImageLongPressed;

  const ShowImageView({
    required this.message,
    this.onImageLongPressed,
    this.onImageTap,
    super.key,
  });

  final Message message;
  final void Function(Message message)? onImageLongPressed;
  final void Function(Message message)? onImageTap;

  @override
  State<ShowImageView> createState() => _ShowImageViewState();
}

class _ShowImageViewState extends State<ShowImageView> {
  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget content = ChatUIKitShowImageWidget(
      message: widget.message,
      onLongPressed: longPressed,
      onTap: widget.onImageTap ??
          (message) {
            Navigator.of(context).pop();
          },
    );

    content = Scaffold(
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      body: Stack(
        children: [
          content,
        ],
      ),
    );

    content = Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: content,
    );

    return content;
  }

  void longPressed(Message message) {
    showChatUIKitBottomSheet(
        context: context,
        items: [
          ChatUIKitBottomSheetItem.normal(
              label: '保存',
              onTap: () async {
                save();
                Navigator.of(context).pop();
              }),
          ChatUIKitBottomSheetItem.normal(
              label: '转发给朋友',
              onTap: () async {
                Navigator.of(context).pop();
                forward();
              })
        ],
        cancelTitle: '取消');
  }

  void save() async {}

  void forward() async {
    final profile = await Navigator.of(context).pushNamed(
      ChatUIKitRouteNames.selectContactsView,
      arguments: SelectContactViewArguments(
        title: '选择联系人',
        backText: '取消',
      ),
    );

    if (profile != null && profile is ChatUIKitProfile) {
      Message? targetMsg =
          await ChatUIKit.instance.loadMessage(messageId: widget.message.msgId);
      if (targetMsg != null) {
        final msg = Message.createImageSendMessage(
          targetId: profile.id,
          chatType: (profile.type == ChatUIKitProfileType.contact ||
                  profile.type == ChatUIKitProfileType.contact)
              ? ChatType.Chat
              : ChatType.GroupChat,
          filePath: targetMsg.localPath!,
          width: targetMsg.width,
          height: targetMsg.height,
          displayName: targetMsg.displayName,
          fileSize: targetMsg.fileSize,
        );

        ChatUIKit.instance.sendMessage(message: msg);
      }
    }
  }
}
