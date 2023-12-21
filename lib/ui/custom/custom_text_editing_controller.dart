import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class CustomTextEditingController extends TextEditingController {
  final List<MentionModel> _mentionList = [];
  final bool enableMention;
  bool mentionAll = false;
  bool lastNeedMention = false;
  int lastAtCount = 0;

  final TextStyle? mentionStyle;

  CustomTextEditingController({
    String? text,
    this.enableMention = false,
    this.mentionStyle,
  }) : super(text: text);

  void addUser(ChatUIKitProfile profile) {
    String addText = profile.showName;

    int cursorOffset = value.selection.baseOffset + addText.length;

    _mentionList.add(MentionModel(profile));

    value = TextEditingValue(
      text: text.substring(0, value.selection.baseOffset) +
          addText +
          text.substring(value.selection.baseOffset),
      selection: TextSelection.collapsed(offset: cursorOffset),
    );
  }

  @override
  set value(TextEditingValue newValue) {
    if (!enableMention) {
      super.value = newValue;
    }

    final currentCount =
        newValue.text.split('').where((element) => element == "@").length;
    lastNeedMention = currentCount == lastAtCount + 1;
    lastAtCount = currentCount;
    // Ensure the cursor position is correct
    if (newValue.selection.start > newValue.text.length) {
      newValue = newValue.copyWith(
        selection: TextSelection.collapsed(offset: newValue.text.length),
      );
    }

    // Remove mention models if the corresponding mention is deleted
    final removedMentions = _mentionList.where((mention) {
      // List<String> newMentions = newValue.text.split('@');
      // List<String> oldMentions = value.text.split('@');
      // 算法有问题，如果元数据中有重复的名字，会导致删除不了
      final ret = !newValue.text.contains('@${mention.profile.showName}');
      return ret;
    }).toList();

    _mentionList.removeWhere((mention) => removedMentions.contains(mention));

    if (removedMentions.length == 1) {
      String str = newValue.text.substring(0, newValue.selection.baseOffset);
      int index = str.lastIndexOf('@');
      if (index != -1) {
        newValue = TextEditingValue(
          text: value.text.substring(0, index) +
              value.text.substring(
                  index + removedMentions[0].profile.showName.length + 1),
          selection: TextSelection.collapsed(offset: index),
        );
      }
    }

    super.value = newValue;
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    if (!enableMention) {
      super.buildTextSpan(context: context, withComposing: withComposing);
    }

    List<String> list = text.split('@');

    List<InlineSpan> children = [];

    for (var txt in list) {
      bool isMentioned = false; // Flag to check if txt is mentioned

      for (var model in _mentionList) {
        if (txt.startsWith(model.profile.showName)) {
          String mentionText = txt.substring(0, model.profile.showName.length);
          children.add(
            TextSpan(text: '@$mentionText', style: mentionStyle ?? style),
          );
          String lessText = txt.substring(model.profile.showName.length);
          if (lessText.isNotEmpty == true) {
            children.add(
              TextSpan(text: lessText, style: style),
            );
          }
          isMentioned = true; // Set flag to true if txt is mentioned
          break; // Exit the loop if txt is mentioned
        }
      }

      if (!isMentioned) {
        children.add(TextSpan(text: txt, style: style));
      }
    }
    return TextSpan(children: children, style: style);
  }
}

class MentionModel {
  final ChatUIKitProfile profile;
  // final int location;
  // final int length;

  MentionModel(
    this.profile,
    // this.location,
    // this.length,
  );
}
