// ignore_for_file: duplicate_export

library chat_sdk_wrapper;

import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit/sdk_wrapper/actions/presence_actions.dart';
import 'package:flutter/material.dart';

export 'actions/chat_actions.dart';
export 'actions/group_actions.dart';
export 'actions/notification_actions.dart';
export 'actions/contact_actions.dart';

export 'typedef_define.dart';

export 'wrappers/chat_wrapper.dart';
export 'wrappers/connect_wrapper.dart';
export 'wrappers/contact_wrapper.dart';
export 'wrappers/group_wrapper.dart';
export 'wrappers/message_wrapper.dart';
export 'wrappers/multi_wrapper.dart';
export 'wrappers/presence_wrapper.dart';
export 'wrappers/notification_wrapper.dart';

export 'observers/chat_observer.dart';
export 'observers/connect_observer.dart';
export 'observers/contact_observer.dart';
export 'observers/group_observer.dart';
export 'observers/message_observer.dart';
export 'observers/multi_observer.dart';
export 'observers/presence_observer.dart';
export 'observers/action_event_observer.dart';

export 'chat_sdk_wrapper_action_events.dart';
export 'typedef_define.dart';
export 'chat_sdk_wrapper_action_events.dart';

const String sdkEventKey = 'chat_uikit';

abstract mixin class ChatUIKitObserverBase {}

abstract class ChatUIKitWrapperBase {
  @protected
  final List<ChatUIKitObserverBase> observers = [];

  @protected
  @mustCallSuper
  void addListeners() {}

  @protected
  @mustCallSuper
  void removeListeners() {}

  ChatUIKitWrapperBase() {
    addListeners();
  }

  void addObserver(ChatUIKitObserverBase observer) {
    observers.add(observer);
  }

  void removeObserver(ChatUIKitObserverBase observer) {
    observers.remove(observer);
  }

  @protected
  Future<T> checkResult<T>(
    ChatSDKWrapperActionEvent actionEvent,
    Future<T> Function() method,
  ) async {
    T result;
    try {
      _onEventBegin(actionEvent);
      result = await method.call();
      _onEventEnd(actionEvent);
      return result;
    } on ChatError catch (e) {
      _onEventError(actionEvent, e);
      rethrow;
    }
  }

  void _onEventBegin(ChatSDKWrapperActionEvent event) {
    for (var observer in observers) {
      if (observer is ChatSDKActionEventsObserver) {
        observer.onEventBegin(event);
      }
    }
  }

  void _onEventEnd(ChatSDKWrapperActionEvent event) {
    for (var observer in observers) {
      if (observer is ChatSDKActionEventsObserver) {
        observer.onEventEnd(event);
      }
    }
  }

  void _onEventError(ChatSDKWrapperActionEvent event, ChatError error) {
    for (var observer in observers) {
      if (observer is ChatSDKActionEventsObserver) {
        observer.onEventErrorHandler(event, error);
      }
    }
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
        PresenceWrapper,
        ChatActions,
        ContactActions,
        GroupActions,
        NotificationActions,
        PresenceActions,
        ChatSDKActionEventsObserver {
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
    Client.getInstance.startCallback();
  }

  Future<void> login({
    required String userId,
    required String password,
  }) async {
    return checkResult(ChatSDKWrapperActionEvent.acceptContactRequest,
        () async {
      await Client.getInstance.loginWithPassword(userId, password);
      await Client.getInstance.startCallback();
    });
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
