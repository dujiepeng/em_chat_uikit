import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage>
    with ChatSDKActionEventsObserver {
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
    return const ContactView();
  }

  @override
  void onEventEnd(ChatSDKWrapperActionEvent event) {
    if (event == ChatSDKWrapperActionEvent.acceptContactRequest ||
        event == ChatSDKWrapperActionEvent.fetchGroupMemberAttributes ||
        event == ChatSDKWrapperActionEvent.setGroupMemberAttributes) {
      EasyLoading.dismiss();
    }
  }

  @override
  void onEventBegin(ChatSDKWrapperActionEvent event) {
    if (event == ChatSDKWrapperActionEvent.acceptContactRequest ||
        event == ChatSDKWrapperActionEvent.fetchGroupMemberAttributes ||
        event == ChatSDKWrapperActionEvent.setGroupMemberAttributes) {
      EasyLoading.show();
    }
  }

  @override
  void onEventErrorHandler(
    ChatSDKWrapperActionEvent event,
    ChatError error,
  ) {
    EasyLoading.showError(error.description);
  }
}
