import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class ShowImageView extends StatefulWidget {
  ShowImageView.arguments(ShowImageViewArguments argument, {super.key})
      : message = argument.message,
        onImageLongPressed = argument.onImageLongPressed;

  const ShowImageView({
    required this.message,
    this.onImageLongPressed,
    super.key,
  });

  final Message message;
  final void Function(Message message)? onImageLongPressed;

  @override
  State<ShowImageView> createState() => _ShowImageViewState();
}

class _ShowImageViewState extends State<ShowImageView> {
  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget content = ChatUIKitShowImageWidget(
      message: widget.message,
      onImageLongPressed: longPressed,
      onImageTap: (message) {
        Navigator.of(context).pop();
      },
    );

    Widget appBar = Positioned(
      left: 5,
      top: 5,
      child: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(
          Icons.arrow_back_ios,
          size: 16,
          color: theme.color.isDark
              ? theme.color.neutralColor95
              : theme.color.neutralColor3,
        ),
      ),
    );

    content = Scaffold(
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      body: Stack(
        children: [
          content,
          appBar,
        ],
      ),
    );

    content = SafeArea(child: content);

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
