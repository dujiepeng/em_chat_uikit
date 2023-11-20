
import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/foundation.dart';


const String sdkEventKey = 'chat_uikit';

abstract mixin class ChatUIKitObserverBase {}

abstract class ChatUIKitWrapperBase {
  @protected
  final List<ChatUIKitObserverBase> observers = [];

  @protected
  @mustCallSuper
  void addListeners() {}

  ChatUIKitWrapperBase() {
    addListeners();
  }

  void addObserver(ChatUIKitObserverBase observer) {
    observers.add(observer);
  }

  void removeObserver(ChatUIKitObserverBase observer) {
    observers.remove(observer);
  }
}

class ChatUIKit extends ChatUIKitWrapperBase
    with
        ChatWrapper,
        GroupWrapper,
        ContactWrapper,
        ConnectWrapper,
        MultiWrapper,
        MessageWrapper,
        ChatActions,
        ChatActions,
        GroupActions {
  static ChatUIKit? _instance;
  static ChatUIKit get instance {
    return _instance ??= ChatUIKit();
  }
}
