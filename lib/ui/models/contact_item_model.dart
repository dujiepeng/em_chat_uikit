import 'package:em_chat_uikit/chat_uikit.dart';

class ContactItemModel
    with ChatUIKitListItemModelBase, NeedAlphabetical, NeedSearch {
  @override
  ChatUIKitProfile profile;

  ContactItemModel({
    required this.profile,
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

  // TODO: 升级到新版本后不需要这种api，传入Contact 对象更合理；
  static ContactItemModel fromContact(String userId) {
    ChatUIKitProfile profile =
        ChatUIKitContext.instance.contactsCache[userId] ??
            ChatUIKitProfile.contact(id: userId);
    return ContactItemModel(profile: profile);
  }
}
