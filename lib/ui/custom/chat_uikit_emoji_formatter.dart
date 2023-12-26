import 'package:flutter/services.dart';

RegExp emojiExp = RegExp(r"\[.{1,4}?\]");

class ChatUIKitEmojiFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue;
  }
}
