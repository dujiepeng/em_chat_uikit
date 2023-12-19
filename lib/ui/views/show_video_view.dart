import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class ShowVideoView extends StatefulWidget {
  ShowVideoView.arguments(ShowVideoViewArguments argument, {super.key})
      : message = argument.message,
        onImageLongPressed = argument.onImageLongPressed;

  const ShowVideoView({
    required this.message,
    this.onImageLongPressed,
    super.key,
  });

  final Message message;
  final void Function(Message message)? onImageLongPressed;

  @override
  State<ShowVideoView> createState() => _ShowVideoViewState();
}

class _ShowVideoViewState extends State<ShowVideoView> {
  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget content = ChatUIKitShowVideoWidget(
      message: widget.message,
      onLongPressed: longPressed,
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
