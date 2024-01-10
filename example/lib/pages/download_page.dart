import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class DownloadFileWidget extends StatefulWidget {
  const DownloadFileWidget({required this.message, super.key});
  final Message message;
  @override
  State<DownloadFileWidget> createState() => _DownloadFileWidgetState();
}

class _DownloadFileWidgetState extends State<DownloadFileWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.message.displayName ?? '文件下载'),
      ),
      body: ChatUIKitDownloadsHelperWidget(
        message: widget.message,
        builder: (context, path, name, state, progress) {
          if (state == ChatUIKitMessageDownloadState.success) {
            return Center(
              child: TextButton(
                onPressed: () {
                  EasyLoading.showToast('需要你根据后缀，实现打开文件的逻辑');
                },
                child: const Text('打开文件'),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(
              value: progress.toDouble(),
            ),
          );
        },
      ),
    );
  }
}
