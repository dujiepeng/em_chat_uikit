import 'package:em_chat_uikit/chat_uikit.dart';

class GroupItemModel with ChatUIKitListItemModelBase, NeedSearch {
  @override
  ChatUIKitProfile profile;

  GroupItemModel({
    required this.profile,
  }) {
    profile = profile;
  }

  @override
  String get showName {
    return profile.name ?? profile.id;
  }

  String? get avatarUrl {
    return profile.avatarUrl;
  }

  static GroupItemModel fromGroup(Group group) {
    ChatUIKitProfile profile = ChatUIKitProfile.group(
      id: group.groupId,
      name: group.name,
    );
    return GroupItemModel(profile: profile);
  }
}
