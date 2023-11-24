import 'package:em_chat_uikit/chat_uikit.dart';

class ContactItemModel
    with ChatUIKitListItemModelBase, SearchKeyword, Alphabetical {
  final String id;
  final String? avatarUrl;
  final String? nickName;

  ContactItemModel({
    required this.id,
    this.avatarUrl,
    this.nickName,
  });

  @override
  bool get canSearch => true;

  @override
  String get showName {
    return nickName ?? id;
  }

  @override
  String get searchKeyword => nickName ?? id;

  // TODO: 升级到新版本后不需要这种api，传入Contact 对象更合理；
  static ContactItemModel fromContact(String userId) {
    return ContactItemModel(id: userId);
  }

  @override
  double get itemHeight => 60;
}
