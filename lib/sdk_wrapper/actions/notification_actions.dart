import 'package:em_chat_uikit/chat_uikit.dart';

mixin NotificationActions on NotificationWrapper {
  Future<PushConfigs> fetchPushConfig() async {
    return Client.getInstance.pushManager.fetchPushConfigsFromServer();
  }

  Future<void> uploadPushDisplayName({required displayName}) async {
    return Client.getInstance.pushManager.updatePushNickname(displayName);
  }

  Future<void> updatePushDisplayStyle({required DisplayStyle style}) async {
    return Client.getInstance.pushManager.updatePushDisplayStyle(style);
  }

  Future<void> uploadHMSPushToken({required String token}) async {
    return Client.getInstance.pushManager.updateHMSPushToken(token);
  }

  Future<void> uploadFCMPushToken({required String token}) async {
    return Client.getInstance.pushManager.updateFCMPushToken(token);
  }

  Future<void> uploadAPNsPushToken({required String token}) async {
    return Client.getInstance.pushManager.updateAPNsDeviceToken(token);
  }

  Future<void> setSilentMode({
    required String conversationId,
    required ConversationType type,
  }) async {
    ChatSilentModeParam param =
        ChatSilentModeParam.remindType(ChatPushRemindType.MENTION_ONLY);
    return Client.getInstance.pushManager.setConversationSilentMode(
      conversationId: conversationId,
      type: type,
      param: param,
    );
  }

  Future<void> clearSilentMode({
    required String conversationId,
    required ConversationType type,
  }) async {
    return Client.getInstance.pushManager.removeConversationSilentMode(
      conversationId: conversationId,
      type: type,
    );
  }

  Future<Map<String, ChatSilentModeResult>> fetchSilentModel({
    required List<Conversation> conversations,
  }) async {
    return Client.getInstance.pushManager
        .fetchSilentModeForConversations(conversations);
  }

  Future<void> setAllSilentMode({required bool enable}) async {
    ChatSilentModeParam param = ChatSilentModeParam.remindType(
        enable ? ChatPushRemindType.ALL : ChatPushRemindType.MENTION_ONLY);
    return Client.getInstance.pushManager.setSilentModeForAll(param: param);
  }
}
