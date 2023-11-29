import 'package:em_chat_uikit/chat_uikit.dart';

class ChatUIKit extends ChatSDKWrapper {
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
  }) async {
    await super.init(
      appkey: appkey,
      autoLogin: autoLogin,
      debugMode: debugMode,
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
  void onReceiveFriendRequest(String userId, String? reason) {
    // 回调好友通知之前需要先存储好友请求数据
    ChatUIKitContext.instance.addFriendRequest(userId, reason);
    super.onReceiveFriendRequest(userId, reason);
  }
}

extension Contact on ChatUIKit {
  Future<void> acceptContactRequest({required String userId}) async {
    await acceptContactRequest(userId: userId);
  }

  Future<void> declineContactRequest({required String userId}) async {
    await declineContactRequest(userId: userId);
  }
}

extension SilentActions on ChatUIKit {
  Future<void> setChatUIKitSilentMode({
    required String conversationId,
    required ConversationType type,
  }) async {
    ChatSilentModeParam param =
        ChatSilentModeParam.remindType(ChatPushRemindType.MENTION_ONLY);
    await setSilentMode(
      conversationId: conversationId,
      type: type,
      param: param,
    );
    ChatUIKitContext.instance.addConversationMute({conversationId: 1});
    onConversationsUpdate();
  }

  Future<void> clearChatUIKitSilentMode({
    required String conversationId,
    required ConversationType type,
  }) async {
    await clearSilentMode(
      conversationId: conversationId,
      type: type,
    );
    ChatUIKitContext.instance.deleteConversationMute([conversationId]);
    onConversationsUpdate();
  }

  Future<void> setChatUIKitAllSilentMode({required enable}) async {
    ChatSilentModeParam param = ChatSilentModeParam.remindType(
        enable ? ChatPushRemindType.ALL : ChatPushRemindType.MENTION_ONLY);
    await setAllSilentMode(param: param);

    onConversationsUpdate();
  }
}
