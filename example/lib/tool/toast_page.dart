import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ToastPage extends StatefulWidget {
  const ToastPage({required this.child, super.key});
  final Widget child;
  @override
  State<ToastPage> createState() => _ToastPageState();
}

class _ToastPageState extends State<ToastPage>
    with ChatUIKitEventsObservers, ChatSDKActionEventsObserver {
  @override
  void initState() {
    super.initState();
    ChatUIKit.instance.addObserver(this);
  }

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void onChatUIKitEventsReceived(ChatUIKitEvent event) {
    if (event == ChatUIKitEvent.groupIdCopied ||
        event == ChatUIKitEvent.userIdCopied ||
        event == ChatUIKitEvent.messageCopied) {
      EasyLoading.showSuccess('复制成功');
    } else if (event == ChatUIKitEvent.messageDownloading) {
      EasyLoading.showInfo('下载中');
    } else if (event == ChatUIKitEvent.noCameraPermission ||
        event == ChatUIKitEvent.noRecordPermission ||
        event == ChatUIKitEvent.noStoragePermission) {
      EasyLoading.showError('权限不足');
    } else if (event == ChatUIKitEvent.voiceTypeNotSupported) {
      EasyLoading.showError('语音格式不支持');
    }
  }

  @override
  void onEventBegin(ChatSDKWrapperActionEvent event) {
    if (event == ChatSDKWrapperActionEvent.acceptContactRequest ||
        event == ChatSDKWrapperActionEvent.fetchGroupMemberAttributes ||
        event == ChatSDKWrapperActionEvent.setGroupMemberAttributes ||
        event == ChatSDKWrapperActionEvent.sendContactRequest ||
        event == ChatSDKWrapperActionEvent.changeGroupOwner ||
        event == ChatSDKWrapperActionEvent.declineContactRequest ||
        event == ChatSDKWrapperActionEvent.setSilentMode ||
        event == ChatSDKWrapperActionEvent.createGroup ||
        event == ChatSDKWrapperActionEvent.clearSilentMode) {
      EasyLoading.show();
    }
  }

  @override
  void onEventEnd(ChatSDKWrapperActionEvent event, ChatError? error) {
    if (event == ChatSDKWrapperActionEvent.acceptContactRequest ||
        event == ChatSDKWrapperActionEvent.fetchGroupMemberAttributes ||
        event == ChatSDKWrapperActionEvent.setGroupMemberAttributes ||
        event == ChatSDKWrapperActionEvent.sendContactRequest ||
        event == ChatSDKWrapperActionEvent.changeGroupOwner ||
        event == ChatSDKWrapperActionEvent.declineContactRequest ||
        event == ChatSDKWrapperActionEvent.setSilentMode ||
        event == ChatSDKWrapperActionEvent.createGroup ||
        event == ChatSDKWrapperActionEvent.clearSilentMode) {
      EasyLoading.dismiss();
      if (error != null) {
        EasyLoading.showError(error.description);
      }
    }
  }
}
