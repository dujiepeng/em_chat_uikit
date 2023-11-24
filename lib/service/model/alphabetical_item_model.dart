import 'package:em_chat_uikit/chat_uikit.dart';

class AlphabeticalItemModel with ChatUIKitListItemModelBase {
  final String alphabetical;
  final double height;
  AlphabeticalItemModel(this.alphabetical, {this.height = 32}) {
    enableLongPress = false;
    enableTap = false;
  }

  @override
  double get itemHeight => height;
}
