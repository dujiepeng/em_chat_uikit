abstract mixin class ChatUIKitListItemModelBase {
  double get itemHeight;
  bool get canSearch => false;
}

mixin SearchKeyword on ChatUIKitListItemModelBase {
  String get searchKeyword => '';
}

mixin Alphabetical on ChatUIKitListItemModelBase {
  String get showName;
}
