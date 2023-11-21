import 'package:flutter/foundation.dart';
import '../chat_sdk_wrapper.dart';

mixin MessageWrapper on ChatUIKitWrapperBase {
  @protected
  @override
  void addListeners() {
    super.addListeners();
    Client.getInstance.chatManager.addMessageEvent(
      sdkEventKey,
      MessageEvent(
        onSuccess: onSuccess,
        onError: onError,
        onProgress: onProgress,
      ),
    );
  }

  @protected
  void onSuccess(String msgId, Message msg) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as MessageObserver).onSuccess(msgId, msg);
    }
  }

  @protected
  void onError(String msgId, Message message, ChatError error) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as MessageObserver).onError(msgId, message, error);
    }
  }

  @protected
  void onProgress(String msgId, int progress) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as MessageObserver).onProgress(msgId, progress);
    }
  }
}
