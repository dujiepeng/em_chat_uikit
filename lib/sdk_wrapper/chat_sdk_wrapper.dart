library chat_sdk_wrapper;

import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit/sdk_wrapper/actions/contact_actions.dart';
import 'package:flutter/material.dart';

export 'actions/chat_actions.dart';
export 'actions/group_actions.dart';
export 'actions/notification_actions.dart';

export 'typedef_define.dart';

export 'wrappers/chat_wrapper.dart';
export 'wrappers/connect_wrapper.dart';
export 'wrappers/contact_wrapper.dart';
export 'wrappers/group_wrapper.dart';
export 'wrappers/message_wrapper.dart';
export 'wrappers/multi_wrapper.dart';
export 'wrappers/notification_wrapper.dart';

export 'observers/chat_wrapper_observer.dart';
export 'observers/connect_wrapper_observer.dart';
export 'observers/contact_wrapper_observer.dart';
export 'observers/group_wrapper_observer.dart';
export 'observers/message_wrapper_observer.dart';
export 'observers/multi_wrapper_observer.dart';

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

class ChatSDKWrapper extends ChatUIKitWrapperBase
    with
        ChatWrapper,
        GroupWrapper,
        ContactWrapper,
        ConnectWrapper,
        MultiWrapper,
        MessageWrapper,
        NotificationWrapper,
        ChatActions,
        ContactActions,
        GroupActions,
        NotificationActions {
  static ChatSDKWrapper? _instance;
  static ChatSDKWrapper get instance {
    return _instance ??= ChatSDKWrapper();
  }

  Future<void> init({
    required String appkey,
    bool autoLogin = true,
    bool debugMode = false,
  }) async {
    WidgetsFlutterBinding.ensureInitialized();
    final options = Options(
      appKey: appkey,
      autoLogin: autoLogin,
      debugMode: debugMode,
    );
    await Client.getInstance.init(options);
  }

  Future<void> login({
    required String userId,
    required String password,
  }) async {
    await Client.getInstance.loginWithPassword(userId, password);
  }

  Future<void> logout() async {
    await Client.getInstance.logout();
  }

  bool isLogin() {
    return Client.getInstance.currentUserId != null;
  }

  String? currentUserId() {
    return Client.getInstance.currentUserId;
  }
}
