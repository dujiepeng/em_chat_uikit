import 'package:em_chat_uikit/chat_uikit.dart';

class ConversationInfo implements ChatUIKitListItemModel {
  final String id;
  final String? avatarUrl;
  final String? nickName;
  final Message? lastMessage;
  final int unreadCount;
  final ConversationType type;
  final bool pinned = false;
  final bool noDisturb = false;

  ConversationInfo({
    required this.id,
    required this.type,
    this.avatarUrl,
    this.nickName,
    this.lastMessage,
    this.unreadCount = 0,
  });
}
