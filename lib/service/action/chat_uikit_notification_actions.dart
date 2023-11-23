import 'package:em_chat_uikit/chat_uikit.dart';

mixin ChatUIKitNotificationActions on NotificationActions {
  Future<void> setChatUIKitSilentMode({
    required String conversationId,
    required ConversationType type,
  }) async {
    ChatSilentModeParam param =
        ChatSilentModeParam.remindType(ChatPushRemindType.MENTION_ONLY);
    return super.setSilentMode(
      conversationId: conversationId,
      type: type,
      param: param,
    );
  }

  Future<void> setChatUIKitAllSilentMode({required enable}) async {
    ChatSilentModeParam param = ChatSilentModeParam.remindType(
        enable ? ChatPushRemindType.ALL : ChatPushRemindType.MENTION_ONLY);
    return super.setAllSilentMode(param: param);
  }
}
