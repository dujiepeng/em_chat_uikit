import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class CustomTextEditingController extends TextEditingController {
  final List<MentionModel> mentionList = [];

  bool needMention = false;
  int lastAtCount = 0;
  bool willChange = false;
  bool isAtAll = false;

  final TextStyle? mentionStyle;

  CustomTextEditingController({
    String? text,
    this.mentionStyle,
  }) : super(text: text);

  void addUser(ChatUIKitProfile profile) {
    String addText = '${profile.showName} '; // 在nickname后面添加空格
    int cursorOffset = value.selection.baseOffset + addText.length;
    final mention = MentionModel(profile);
    mentionList.add(mention);
    value = TextEditingValue(
      text: text.substring(0, value.selection.baseOffset) +
          addText +
          text.substring(value.selection.baseOffset),
      selection: TextSelection.collapsed(offset: cursorOffset),
    );
  }

  void atAll() {
    isAtAll = true;
    String addText = 'All ';
    int cursorOffset = value.selection.baseOffset + addText.length;
    value = TextEditingValue(
      text: text.substring(0, value.selection.baseOffset) +
          addText +
          text.substring(value.selection.baseOffset),
      selection: TextSelection.collapsed(offset: cursorOffset),
    );
  }

  List<ChatUIKitProfile> getMentionList() {
    return mentionList.map((e) => e.profile).toList();
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

  void clearMentions() {
    mentionList.clear();
    needMention = false;
    lastAtCount = 0;
    willChange = false;
    isAtAll = false;
  }
}

class MentionModel {
  final ChatUIKitProfile profile;

  MentionModel(
    this.profile,
  );
}
