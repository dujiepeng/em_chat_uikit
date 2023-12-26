import 'package:em_chat_uikit/chat_uikit.dart';

mixin ChatUIKitChatObservers on ChatSDKWrapper {
  @override
  void onMessagesRecalled(List<Message> messages) {
    super.onMessagesRecalled(messages);
  }
}
