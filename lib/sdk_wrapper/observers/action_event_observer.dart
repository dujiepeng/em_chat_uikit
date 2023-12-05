import 'package:em_chat_uikit/sdk_wrapper/chat_sdk_wrapper.dart';

abstract mixin class ChatSDKActionEventsObserver
    implements ChatUIKitObserverBase {
  void onEventErrorHandler(ChatSDKWrapperActionEvent event, ChatError error) {}

  void onEventBegin(ChatSDKWrapperActionEvent event) {}

  void onEventEnd(ChatSDKWrapperActionEvent event) {}
}
