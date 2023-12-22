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
  final Map<String, String>? extension;

  String get showName => name?.isNotEmpty == true ? name! : id;

  ChatUIKitProfile({
    required this.id,
    this.name,
    this.avatarUrl,
    this.type,
    this.extension,
    int? updateTime,
  }) : updateTime = updateTime ?? -1;

  ChatUIKitProfile.contact({
    required String id,
    String? name,
    String? avatarUrl,
    Map<String, String>? extension,
  }) : this(
          id: id,
          name: name,
          avatarUrl: avatarUrl,
          type: ChatUIKitProfileType.contact,
          extension: extension,
        );

  ChatUIKitProfile.groupChat({
    required String id,
    String? name,
    String? avatarUrl,
    Map<String, String>? extension,
  }) : this(
          id: id,
          name: name,
          avatarUrl: avatarUrl,
          type: ChatUIKitProfileType.groupChat,
          extension: extension,
        );

  ChatUIKitProfile.groupMember({
    required String id,
    String? name,
    String? avatarUrl,
    Map<String, String>? extension,
  }) : this(
          id: id,
          name: name,
          avatarUrl: avatarUrl,
          type: ChatUIKitProfileType.groupMember,
          extension: extension,
        );

  ChatUIKitProfile.singleChat({
    required String id,
    String? name,
    String? avatarUrl,
    Map<String, String>? extension,
  }) : this(
          id: id,
          name: name,
          avatarUrl: avatarUrl,
          type: ChatUIKitProfileType.singleChat,
          extension: extension,
        );

  ChatUIKitProfile copy({
    String? name,
    String? avatarUrl,
    Map<String, String>? extension,
  }) {
    return ChatUIKitProfile(
      id: id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      type: type,
      updateTime: DateTime.now().millisecondsSinceEpoch,
      extension: extension ?? this.extension,
    );
  }
}
