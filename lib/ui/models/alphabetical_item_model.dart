import 'package:em_chat_uikit/chat_uikit.dart';

class AlphabeticalItemModel with ChatUIKitListItemModelBase, NeedHeight {
  final String alphabetical;
  final double height;
  AlphabeticalItemModel(this.alphabetical, {this.height = 32});

  @override
  double get itemHeight => height;
}
