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
    // 通过判断@的个数来判断是否需要触发@的逻辑
    final currentCount =
        newValue.text.split('').where((element) => element == "@").length;
    needMention = currentCount == lastAtCount + 1;

    // 判断@是否被删除。
    // 正常删除状态，可以通过extentOffset获取删除的值
    List<MentionModel> needRemove = [];

    if (willChange) {
      List<String> newMentions = newValue.text.split('@');
      List<String> oldMentions = text.split('@');
      // 获取删除的@的index
      List<int> removeIndex = [];
      for (int i = 0; i < oldMentions.length; i++) {
        if (newMentions.length > i && oldMentions[i] != newMentions[i]) {
          removeIndex.add(i);
        }
      }

      for (var model in _mentionList) {
        if (model.start < value.selection.extentOffset &&
            model.start + model.length >= value.selection.extentOffset) {
          needRemove.add(model);
          String str = value.text.substring(0, value.selection.extentOffset);
          int index = str.lastIndexOf('@');
          if (index != -1) {
            newValue = TextEditingValue(
              text: text.substring(0, index) +
                  text.substring(index + model.length),
              selection: TextSelection.collapsed(offset: model.start),
            );
          }
          break;
        }
      }
    }
    _mentionList.removeWhere((element) => needRemove.contains(element));

    lastAtCount = currentCount;

    // willChange = newValue.selection.isCollapsed == false;
    willChange = newValue.selection.isCollapsed == false &&
        newValue.selection.start + 1 == newValue.selection.end;

    return newValue;
  }

  // @override
  // set selection(TextSelection newSelection) {
  //   // 过滤@ 情况，不允许光标移动到@数据之间
  //   TextSelection selection = newSelection;
  //   for (var model in _mentionList) {
  //     if (model.start < selection.baseOffset &&
  //         model.start + model.length >= selection.baseOffset) {
  //       selection = TextSelection.collapsed(offset: model.start);
  //       break;
  //     }
  //   }
  //   super.selection = selection;
  // }
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
