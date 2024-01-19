import 'package:em_chat_uikit/sdk_wrapper/chat_sdk_wrapper.dart';

abstract mixin class ChatSDKActionEventsObserver
    implements ChatUIKitObserverBase {
  void onEventBegin(ChatSDKWrapperActionEvent event) {}

  void onEventEnd(ChatSDKWrapperActionEvent event, ChatError? error) {}
}
