import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class CustomTextEditingController extends TextEditingController {
  final List<MentionModel> _mentionList = [];
  bool mentionAll = false;
  bool needMention = false;
  int lastAtCount = 0;
  bool willChange = false;

  final TextStyle? mentionStyle;

  CustomTextEditingController({
    String? text,
    this.mentionStyle,
  }) : super(text: text);

  void addUser(ChatUIKitProfile profile) {
    String addText = '${profile.showName} '; // 在nickname后面添加空格
    int cursorOffset = value.selection.baseOffset + addText.length;
    final mention = MentionModel(
      profile,
      value.selection.baseOffset - 1, // 因为前面已经有了@字符，所以此处-1
      addText.length + 1, // 因为前面已经有了@字符，所以此处 +1 ，example：'@du001 '
    );
    _mentionList.add(mention);
    value = TextEditingValue(
      text: text.substring(0, value.selection.baseOffset) +
          addText +
          text.substring(value.selection.baseOffset),
      selection: TextSelection.collapsed(offset: cursorOffset),
    );
  }

  @override
  set value(TextEditingValue newValue) {
    newValue = mentionFilter(newValue);
    super.value = newValue;
  }

  TextEditingValue mentionFilter(TextEditingValue newValue) {
    final currentCount =
        newValue.text.split('').where((element) => element == "@").length;
    needMention = currentCount == lastAtCount + 1;
    lastAtCount = currentCount;
    return newValue;
  }
}

class MentionModel {
  final ChatUIKitProfile profile;
  final int start;
  final int length;

  MentionModel(
    this.profile,
    this.start,
    this.length,
  );
}
