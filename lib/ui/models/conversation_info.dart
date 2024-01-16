import 'package:em_chat_uikit/chat_uikit.dart';

import '../../universal/defines.dart';

class ConversationInfo with ChatUIKitListItemModelBase, NeedSearch {
  final Message? lastMessage;
  final int unreadCount;
  final bool pinned;
  final bool noDisturb;
  final bool hasMention;
  final String? attribute;
  @override
  ChatUIKitProfile profile;

  ConversationInfo({
    required this.profile,
    this.lastMessage,
    this.unreadCount = 0,
    this.noDisturb = false,
    this.pinned = false,
    this.hasMention = false,
    this.attribute,
  });

  static Future<ConversationInfo> fromConversation(
    Conversation conversation,
    ChatUIKitProfile profile,
  ) async {
    int unreadCount = await conversation.unreadCount();
    Message? lastMessage = await conversation.latestMessage();

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
