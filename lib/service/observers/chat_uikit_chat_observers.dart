import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

mixin ChatUIKitChatObservers on ChatSDKWrapper {
  @override
  void onMessagesRecalled(List<Message> messages) {
    onMessagesWillReceived(messages, []);
  }

  void onMessagesWillReceived(
    List<Message> willRecalledList,
    List<Message> replaceList,
  ) {
    debugPrint('onMessagesWillReceived');
  }
}
