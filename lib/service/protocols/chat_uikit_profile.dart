enum ChatUIKitProfileType {
  /// Profile type for chat
  singleChat,

  /// Profile type for groupChat
  groupChat,

  /// Profile type for contact
  contact,

  /// Profile type for group
  groupMember,
}

class ChatUIKitProfile {
  final String id;
  final String? name;
  final String? avatarUrl;
  final ChatUIKitProfileType? type;
  final int updateTime;

  String get showName => name?.isNotEmpty == true ? name! : id;

  ChatUIKitProfile({
    required this.id,
    this.name,
    this.avatarUrl,
    this.type,
    int? updateTime,
  }) : updateTime = updateTime ?? -1;

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

  ChatUIKitProfile.groupMember({
    required String id,
    String? name,
    String? avatarUrl,
  }) : this(
          id: id,
          name: name,
          avatarUrl: avatarUrl,
          type: ChatUIKitProfileType.groupMember,
        );

  ChatUIKitProfile.singleChat({
    required String id,
    String? name,
    String? avatarUrl,
  }) : this(
          id: id,
          name: name,
          avatarUrl: avatarUrl,
          type: ChatUIKitProfileType.singleChat,
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
