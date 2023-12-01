import 'package:em_chat_uikit/chat_uikit.dart';

class NewRequestItemModel
    with ChatUIKitListItemModelBase, NeedAlphabetical, NeedSearch {
  @override
  ChatUIKitProfile profile;

  final String? reason;

  NewRequestItemModel({
    required this.profile,
    this.reason,
  }) {
    profile = profile;
  }

  @override
  double get itemHeight => 60;

  @override
  String get showName {
    return profile.name ?? profile.id;
  }

  String? get avatarUrl {
    return profile.avatarUrl;
  }

  static NewRequestItemModel fromUserId(String userId, [String? reason]) {
    ChatUIKitProfile profile =
        ChatUIKitContext.instance.contactsCache[userId] ??
            ChatUIKitProfile.contact(id: userId);
    return NewRequestItemModel(profile: profile, reason: reason);
  }
}
