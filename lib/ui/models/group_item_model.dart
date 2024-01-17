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
    return profile.showName;
  }

  String? get avatarUrl {
    return profile.avatarUrl;
  }

  static GroupItemModel fromGroup(Group group) {
    // 因为不需要向用户要群组的Profile,所以单独创建一个profile。
    ChatUIKitProfile profile = ChatUIKitProfile.group(
      id: group.groupId,
      name: group.name,
    );
    return GroupItemModel(profile: profile);
  }
}
