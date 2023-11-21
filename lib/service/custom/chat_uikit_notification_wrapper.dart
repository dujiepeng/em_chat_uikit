import 'package:em_chat_uikit/chat_uikit.dart';

mixin CustomNotificationActions on NotificationActions {
  @override
  Future<Map<String, ChatSilentModeResult>> fetchSilentModel({
    required List<Conversation> conversations,
  }) async {
    Map<String, ChatSilentModeResult> ret =
        await super.fetchSilentModel(conversations: conversations);

    return ret;
  }

  @override
  Future<void> setSilentMode({
    required String conversationId,
    required ConversationType type,
  }) async {
    await super.setSilentMode(conversationId: conversationId, type: type);
  }
}
