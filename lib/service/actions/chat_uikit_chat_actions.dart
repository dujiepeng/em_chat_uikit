import 'package:em_chat_uikit/chat_uikit.dart';

mixin ChatUIKitChatActions on ChatSDKWrapper {
  @override
  Future<int> getUnreadMessageCount() async {
    int unreadCount = 0;
    List<Conversation> list = await ChatUIKit.instance.getAllConversations();
    if (list.isEmpty) return unreadCount;
    for (var conversation in list) {
      if (!ChatUIKitContext.instance.conversationIsMute(conversation.id)) {
        unreadCount += await conversation.unreadCount();
      }
    }
    return unreadCount;
  }

  @override
  Future<Message> sendMessage({required Message message}) async {
    message.addAvatarURL(
      ChatUIKitProvider.instance.currentUserProfile?.avatarUrl,
    );

    message.addNickname(
      ChatUIKitProvider.instance.currentUserProfile?.name,
    );
    return super.sendMessage(message: message);
  }
}
