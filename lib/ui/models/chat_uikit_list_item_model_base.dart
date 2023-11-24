abstract mixin class ChatUIKitListItemModelBase {}

mixin SearchKeyword on ChatUIKitListItemModelBase {
  String get searchKeyword => '';
}

mixin NeedAlphabetical on ChatUIKitListItemModelBase, NeedHeight {
  String get showName;
}

mixin NeedHeight on ChatUIKitListItemModelBase {
  double get itemHeight;
}
