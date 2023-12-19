import 'dart:io';

import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitShowVideoWidget extends StatefulWidget {
  const ChatUIKitShowVideoWidget({
    required this.message,
    this.onImageLongPressed,
    this.onImageTap,
    this.onError,
    this.onProgress,
    this.onSuccess,
    super.key,
  });

  final void Function(Message message)? onImageLongPressed;
  final void Function(Message message)? onImageTap;
  final Message message;

  final void Function(ChatError error)? onError;
  final void Function(int progress)? onProgress;
  final VoidCallback? onSuccess;

  @override
  State<ChatUIKitShowVideoWidget> createState() =>
      _ChatUIKitShowVideoWidgetState();
}

class _ChatUIKitShowVideoWidgetState extends State<ChatUIKitShowVideoWidget>
    with MessageObserver {
  late final Message? message;
  VideoPlayerController? _controller;

  String? localThumbPath;
  String? remoteThumbPath;
  bool isPlaying = false;
  bool downloading = false;
  final ValueNotifier _hasThumb = ValueNotifier(false);

  final ValueNotifier<int> _progress = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    debugPrint('init!');
    ChatUIKit.instance.addObserver(this);
    ChatUIKit.instance
        .loadMessage(messageId: widget.message.msgId)
        .then((value) {
      if (value != null) {
        message = value;
        checkFile();
      }
    });
  }

  void checkFile() async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (message?.localPath?.isNotEmpty == true) {
      File file = File(message!.localPath!);

      if (file.existsSync()) {
        await updateController(file);
      } else {
        ChatUIKit.instance.downloadAttachment(message: message!);
        downloading = true;
      }
    }

    if (message?.thumbnailLocalPath?.isNotEmpty == true) {
      File file = File(message!.thumbnailLocalPath!);
      if (file.existsSync()) {
        localThumbPath = message!.thumbnailLocalPath;
      }
    } else {
      ChatUIKit.instance.downloadThumbnail(message: message!);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _hasThumb.dispose();
    _progress.dispose();
    _controller?.dispose();
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onProgress(String msgId, int progress) {
    if (message?.msgId == msgId) {
      if (downloading) {
        _progress.value = progress;
        widget.onProgress?.call(progress);
      }
    }
  }

  @override
  void onError(String msgId, Message msg, ChatError error) {
    if (message?.msgId == msgId) {
      message = msg;
      widget.onError?.call(error);
    }
  }

  @override
  void onSuccess(String msgId, Message msg) {
    if (message?.msgId == msgId) {
      if (downloading) {
        if ((msg.body as VideoMessageBody).fileStatus ==
            DownloadStatus.SUCCESS) {
          downloading = false;
        }
      }
      message = msg;
      checkFile();
    }
  }

  Future<void> updateController(File file) async {
    if (_controller != null) return;
    _controller = VideoPlayerController.file(file);
    await _controller?.initialize();
    _controller?.addListener(() {
      if (mounted) {
        if (_controller?.value.isInitialized == true) {
          isPlaying = _controller?.value.isPlaying ?? false;
        }
        setState(() {});
      }
    });
  }

  Widget loadingWidget() {
    if (!downloading) {
      return const SizedBox();
    }
    return ValueListenableBuilder(
      valueListenable: _progress,
      builder: (context, value, child) {
        if (_progress.value == 100) {
          return const SizedBox();
        }
        return SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(value: value / 100));
      },
    );
  }

  Widget thumbWidget() {
    Widget? content;
    if (localThumbPath?.isNotEmpty == true) {
      content = Image.file(
        File(localThumbPath!),
        fit: BoxFit.contain,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      );
    }
    content ??= const SizedBox();
    return content;
  }

  Widget playerWidget() {
    final theme = ChatUIKitTheme.of(context);
    return Center(
      child: Stack(
        children: [
          () {
            if (_controller?.value.isInitialized == true) {
              return AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!));
            } else {
              return const SizedBox();
            }
          }(),
          Positioned.fill(
            child: InkWell(
              onTap: () {
                setState(() {
                  if (_controller!.value.isPlaying) {
                    _controller?.pause();
                    isPlaying = false;
                  } else {
                    _controller?.play();
                    isPlaying = true;
                  }
                });
              },
              child: isPlaying
                  ? const SizedBox()
                  : Center(
                      child: Icon(
                        Icons.play_circle_outline,
                        size: 70,
                        color: theme.color.isDark
                            ? theme.color.neutralColor2
                            : theme.color.neutralColor95,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("play: $isPlaying");
    Widget content = Stack(
      children: [
        Positioned.fill(child: thumbWidget()),
        if (_controller?.value.isInitialized == true)
          Positioned.fill(child: playerWidget()),
        Positioned.fill(child: Center(child: loadingWidget())),
      ],
    );

    content = Stack(
      children: [
        Container(
          color: Colors.black,
        ),
        Positioned.fill(child: content)
      ],
    );
    return content;
  }
}
