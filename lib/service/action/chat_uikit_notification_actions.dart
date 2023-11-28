import 'package:em_chat_uikit/chat_uikit.dart';

mixin ChatUIKitNotificationActions on NotificationActions, ChatWrapper {
  Future<void> setChatUIKitSilentMode({
    required String conversationId,
    required ConversationType type,
  }) async {
    ChatSilentModeParam param =
        ChatSilentModeParam.remindType(ChatPushRemindType.MENTION_ONLY);
    await super.setSilentMode(
      conversationId: conversationId,
      type: type,
      param: param,
    );
    ChatUIKitContext.instance.addConversationMute({conversationId: 1});
    super.onConversationsUpdate();
  }

  Future<void> clearChatUIKitSilentMode({
    required String conversationId,
    required ConversationType type,
  }) async {
    await super.clearSilentMode(
      conversationId: conversationId,
      type: type,
    );
    ChatUIKitContext.instance.deleteConversationMute([conversationId]);
    super.onConversationsUpdate();
  }

  Future<void> setChatUIKitAllSilentMode({required enable}) async {
    ChatSilentModeParam param = ChatSilentModeParam.remindType(
        enable ? ChatPushRemindType.ALL : ChatPushRemindType.MENTION_ONLY);
    await super.setAllSilentMode(param: param);

    super.onConversationsUpdate();
  }
}
