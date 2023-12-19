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
          ChatUIKitBottomSheetItem.normal(label: '保存', onTap: () async {}),
          ChatUIKitBottomSheetItem.normal(label: '转发给朋友', onTap: () async {})
        ],
        cancelTitle: '取消');
  }
}
