import 'package:em_chat_uikit/chat_uikit.dart';

class ConversationInfo with ChatUIKitListItemModelBase, NeedSearch {
  final Message? lastMessage;
  final int unreadCount;
  final bool pinned;
  final bool noDisturb;
  final bool hasMention;
  @override
  ChatUIKitProfile profile;

  ConversationInfo({
    required this.profile,
    this.lastMessage,
    this.unreadCount = 0,
    this.noDisturb = false,
    this.pinned = false,
    this.hasMention = false,
  });

  static Future<ConversationInfo> fromConversation(
    Conversation conversation,
  ) async {
    int unreadCount = await conversation.unreadCount();
    Message? lastMessage = await conversation.latestMessage();
    ChatUIKitProfileType type = conversation.type == ConversationType.Chat
        ? ChatUIKitProfileType.singleChat
        : ChatUIKitProfileType.groupChat;

    ChatUIKitProfile profile =
        ChatUIKitContext.instance.conversationsCache[conversation.id] ??
            ChatUIKitProfile(
              id: conversation.id,
              type: type,
            );

    ConversationInfo info = ConversationInfo(
      profile: profile,
      unreadCount: unreadCount,
      lastMessage: lastMessage,
      pinned: conversation.isPinned,
      noDisturb: ChatUIKitContext.instance.conversationIsMute(conversation.id),
      hasMention: conversation.ext?[hasMentionKey] == hasMentionValue,
    );
    return info;
  }

  @override
  String get showName {
    return profile.showName;
  }

  String? get avatarUrl {
    return profile.avatarUrl;
  }
}
