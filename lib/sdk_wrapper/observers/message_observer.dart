import 'package:em_chat_uikit/chat_uikit.dart';

abstract mixin class MessageObserver implements ChatUIKitObserverBase {
  void onSuccess(String msgId, Message msg) {}
  void onError(String msgId, Message message, ChatError error) {}
  void onProgress(String msgId, int progress) {}
}
