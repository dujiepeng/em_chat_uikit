enum ChatUIKitProfileType {
  /// Profile type for chat
  chat,

  /// Profile type for groupChat
  groupChat,

  /// Profile type for contact
  contact,
}

class ChatUIKitProfile {
  final String id;
  final String? name;
  final String? avatarUrl;
  final ChatUIKitProfileType? type;
  final int updateTime;

  ChatUIKitProfile({
    required this.id,
    this.name,
    this.avatarUrl,
    this.type,
    this.updateTime = -1,
  });

  ChatUIKitProfile.contact({
    required String id,
    String? name,
    String? avatarUrl,
  }) : this(
          id: id,
          name: name,
          avatarUrl: avatarUrl,
          type: ChatUIKitProfileType.contact,
        );

  ChatUIKitProfile.groupChat({
    required String id,
    String? name,
    String? avatarUrl,
  }) : this(
          id: id,
          name: name,
          avatarUrl: avatarUrl,
          type: ChatUIKitProfileType.groupChat,
        );

  ChatUIKitProfile.chat({
    required String id,
    String? name,
    String? avatarUrl,
  }) : this(
          id: id,
          name: name,
          avatarUrl: avatarUrl,
          type: ChatUIKitProfileType.chat,
        );

  ChatUIKitProfile copy({
    String? name,
    String? avatarUrl,
  }) {
    return ChatUIKitProfile(
      id: id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      type: type,
      updateTime: DateTime.now().millisecondsSinceEpoch,
    );
  }
}
