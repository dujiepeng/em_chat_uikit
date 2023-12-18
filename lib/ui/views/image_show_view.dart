import 'dart:io';

import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ImageShowView extends StatefulWidget {
  ImageShowView.arguments(ImageShowViewArguments argument, {super.key})
      : message = argument.message,
        onImageLongPressed = argument.onImageLongPressed;

  const ImageShowView({
    required this.message,
    this.onImageLongPressed,
    super.key,
  });

  final Message message;
  final void Function(Message message)? onImageLongPressed;

  @override
  State<ImageShowView> createState() => _ImageShowViewState();
}

class _ImageShowViewState extends State<ImageShowView> with MessageObserver {
  late final Message message;

  final ValueNotifier<int> _progress = ValueNotifier(0);

  String? localPath;
  String? localThumbPath;
  String? remoteThumbPath;

  @override
  void initState() {
    super.initState();
    message = widget.message;
    ChatUIKit.instance.addObserver(this);
    checkFile();
  }

  void checkFile() {
    if (message.localPath?.isNotEmpty == true) {
      File file = File(message.localPath!);
      if (file.existsSync()) {
        localPath = message.localPath;
      } else {
        ChatUIKit.instance.downloadAttachment(message: message);
      }
    }

    if (localPath?.isNotEmpty == true) {
      setState(() {});
      return;
    }

    if (message.thumbnailLocalPath?.isNotEmpty == true) {
      File file = File(message.thumbnailLocalPath!);
      if (file.existsSync()) {
        localThumbPath = message.thumbnailLocalPath;
      }
    }

    if (localThumbPath?.isNotEmpty == true) {
      setState(() {});
      return;
    }

    if (message.thumbnailRemotePath?.isNotEmpty == true) {
      remoteThumbPath = message.thumbnailRemotePath;
    }

    if (remoteThumbPath?.isNotEmpty == true) {
      setState(() {});
      return;
    }
  }

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onProgress(String msgId, int progress) {
    if (message.msgId == msgId) {
      _progress.value = progress;
    }
  }

  @override
  void onError(String msgId, Message msg, ChatError error) {
    if (message.msgId == msgId) {
      message = msg;
    }
  }

  @override
  void onSuccess(String msgId, Message msg) {
    if (message.msgId == msgId) {
      message = msg;
      checkFile();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget? content;
    if (localPath?.isNotEmpty == true) {
      content = Image.file(File(localPath!));
    }

    if (content == null && localThumbPath?.isNotEmpty == true) {
      content = Image.file(File(localThumbPath!));
    }

    if (content == null && remoteThumbPath?.isNotEmpty == true) {
      content = Image.network(remoteThumbPath ?? '');
    }

    content ??= const Icon(Icons.broken_image, size: 58, color: Colors.white);

    content = InteractiveViewer(
      child: content,
    );
    content = SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: content,
    );

    content = InkWell(
      onLongPress: () {
        if (widget.onImageLongPressed == null) {
          longPressed();
        } else {
          widget.onImageLongPressed!.call(message);
        }
      },
      child: content,
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

    appBar = SafeArea(child: appBar);

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

    return content;
  }

  void longPressed() {
    showChatUIKitBottomSheet(
        context: context,
        items: [
          ChatUIKitBottomSheetItem.normal(label: '保存', onTap: () async {}),
          ChatUIKitBottomSheetItem.normal(label: '转发给朋友', onTap: () async {})
        ],
        cancelTitle: '取消');
  }
}
