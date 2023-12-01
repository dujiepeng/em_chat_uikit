import 'package:em_chat_uikit/chat_uikit.dart';

abstract mixin class ChatSDKActionEventsObserver
    implements ChatUIKitObserverBase {
  void onEventHandler(ChatSDKWrapperActionEvent event, ChatError? error) {}
}
