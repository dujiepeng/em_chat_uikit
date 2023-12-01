import 'package:em_chat_uikit/chat_uikit.dart';

mixin ChatUIKitNotificationActions on ChatSDKWrapper {
  @override
  Future<void> setSilentMode(
      {required String conversationId,
      required ConversationType type,
      required ChatSilentModeParam param}) async {
    await super.setSilentMode(
      conversationId: conversationId,
      type: type,
      param: param,
    );
    ChatUIKitContext.instance.addConversationMute({conversationId: 1});
    onConversationsUpdate();
  }

  @override
  Future<void> clearSilentMode({
    required String conversationId,
    required ConversationType type,
  }) async {
    await super.clearSilentMode(
      conversationId: conversationId,
      type: type,
    );
    ChatUIKitContext.instance.deleteConversationMute([conversationId]);
    onConversationsUpdate();
  }

  @override
  Future<void> setAllSilentMode({required ChatSilentModeParam param}) async {
    await super.setAllSilentMode(param: param);
    onConversationsUpdate();
  }
}
