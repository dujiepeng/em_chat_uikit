import 'package:em_chat_uikit/chat_uikit.dart';

class ConversationItemModel with ChatUIKitListItemModelBase, NeedSearch {
  final Message? lastMessage;
  final int unreadCount;
  final bool pinned;
  final bool noDisturb;
  @override
  ChatUIKitProfile profile;

  ConversationItemModel({
    required this.profile,
    this.lastMessage,
    this.unreadCount = 0,
    this.noDisturb = false,
    this.pinned = false,
  });

  static Future<ConversationItemModel> fromConversation(
    Conversation conversation,
  ) async {
    int unreadCount = await conversation.unreadCount();
    Message? lastMessage = await conversation.latestMessage();
    ChatUIKitProfileType type = conversation.type == ConversationType.Chat
        ? ChatUIKitProfileType.chat
        : ChatUIKitProfileType.groupChat;

    int? updateTime;
    if (ChatUIKitContext.instance.conversationsCache[conversation.id] != null) {
      updateTime = DateTime.now().microsecondsSinceEpoch;
    }
    ConversationItemModel info = ConversationItemModel(
      profile: ChatUIKitProfile(
        id: conversation.id,
        type: type,
        name: ChatUIKitContext
            .instance.conversationsCache[conversation.id]?.nickName,
        avatarUrl: ChatUIKitContext
            .instance.conversationsCache[conversation.id]?.avatarUrl,
        updateTime: updateTime,
      ),
      unreadCount: unreadCount,
      lastMessage: lastMessage,
      pinned: conversation.isPinned,
      noDisturb: ChatUIKitContext.instance.conversationIsMute(conversation.id),
    );
    return info;
  }

  @override
  String get showName => profile.name ?? profile.id;
}
