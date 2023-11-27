import 'package:em_chat_uikit/chat_uikit.dart';

class ConversationItemModel with ChatUIKitListItemModelBase, NeedSearch {
  final String id;
  final String? avatarUrl;
  final String? name;
  final Message? lastMessage;
  final int unreadCount;
  final ConversationType type;
  final bool pinned;
  final bool noDisturb;

  ConversationItemModel({
    required this.id,
    required this.type,
    this.avatarUrl,
    this.name,
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

    ConversationItemModel info = ConversationItemModel(
      id: conversation.id,
      type: conversation.type,
      unreadCount: unreadCount,
      lastMessage: lastMessage,
      name: ChatUIKitContext
          .instance.conversationsCache[conversation.id]?.nickName,
      avatarUrl: ChatUIKitContext
          .instance.conversationsCache[conversation.id]?.avatarUrl,
      pinned: conversation.isPinned,
      noDisturb: ChatUIKitContext.instance.conversationIsMute(conversation.id),
    );
    return info;
  }

  @override
  String get showName => name ?? id;

  @override
  ChatUIKitProfile get profile => ChatUIKitProfile.chat(id: id);
}
