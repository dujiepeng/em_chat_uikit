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

    ChatUIKitProfile profile =
        ChatUIKitContext.instance.conversationsCache[conversation.id] ??
            ChatUIKitProfile(id: conversation.id, type: type);

    ConversationItemModel info = ConversationItemModel(
      profile: profile,
      unreadCount: unreadCount,
      lastMessage: lastMessage,
      pinned: conversation.isPinned,
      noDisturb: ChatUIKitContext.instance.conversationIsMute(conversation.id),
    );
    return info;
  }

  @override
  String get showName {
    return profile.name ?? profile.id;
  }

  String? get avatarUrl {
    return profile.avatarUrl;
  }
}
