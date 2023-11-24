import 'package:em_chat_uikit/chat_uikit.dart';

class AlphabeticalItemModel with ChatUIKitListItemModel {
  final String alphabetical;
  AlphabeticalItemModel(this.alphabetical) {
    height = 32;
    enableLongPress = false;
    enableTap = false;
  }
}
