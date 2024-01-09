import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit/service/actions/chat_uikit_chat_actions.dart';
import 'package:em_chat_uikit/service/actions/chat_uikit_contact_actions.dart';
import 'package:em_chat_uikit/service/actions/chat_uikit_events_actions.dart';
import 'package:em_chat_uikit/service/actions/chat_uikit_notification_actions.dart';

import 'package:em_chat_uikit/service/observers/chat_uikit_contact_observers.dart';

class ChatUIKit extends ChatSDKWrapper
    with
        ChatUIKitChatActions,
        ChatUIKitContactActions,
        ChatUIKitEventsActions,
        ChatUIKitNotificationActions,
        ChatUIKitContactObservers,
        ChatUIKitEventsObservers {
  static ChatUIKit? _instance;
  static ChatUIKit get instance {
    return _instance ??= ChatUIKit();
  }

  ChatUIKit() : super() {
    ChatUIKitContext.instance;
  }

  @override
  Future<void> init({
    required String appkey,
    bool autoLogin = true,
    bool debugMode = false,
    bool requireDeliveryAck = false,
  }) async {
    await super.init(
      appkey: appkey,
      autoLogin: autoLogin,
      debugMode: debugMode,
      requireDeliveryAck: requireDeliveryAck,
    );
    ChatUIKitContext.instance.currentUserId = currentUserId();
  }

  @override
  Future<void> login({
    required String userId,
    required String password,
  }) async {
    try {
      await super.login(userId: userId, password: password);
      ChatUIKitContext.instance.currentUserId = userId;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await super.logout();
      ChatUIKitContext.instance.currentUserId = null;
      ChatUIKitProvider.instance.clearAllCache();
    } catch (e) {
      rethrow;
    }
  }

  int contactRequestCount() {
    return ChatUIKitContext.instance.requestList().length;
  }
}
