import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/foundation.dart';

mixin MessageWrapper on ChatUIKitWrapperBase {
  @protected
  @override
  void addListeners() {
    super.addListeners();
    Client.getInstance.chatManager.addMessageEvent(
      sdkEventKey,
      MessageEvent(
        onSuccess: _onSuccess,
        onError: _onError,
        onProgress: _onProgress,
      ),
    );
  }

  void _onSuccess(String msgId, Message msg) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as MessageObserver).onSuccess(msgId, msg);
    }
  }

  void _onError(String msgId, Message message, ChatError error) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as MessageObserver).onError(msgId, message, error);
    }
  }

  void _onProgress(String msgId, int progress) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as MessageObserver).onProgress(msgId, progress);
    }
  }
}

extension MessageWrapperAction on MessageWrapper {}
