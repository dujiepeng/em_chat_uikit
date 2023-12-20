import 'package:flutter/widgets.dart';

class CustomTextEditingController extends TextEditingController {
  final List<String> _userIds = [];
  bool lastNeedMention = false;
  int lastAtCount = 0;

  CustomTextEditingController({
    String? text,
  }) : super(text: text);

  void addUserIds(String userId) {
    _userIds.add(userId);
  }

  void deleteUserId(String userId) {
    _userIds.remove(userId);
  }

  @override
  set value(TextEditingValue newValue) {
    final currentCount =
        newValue.text.split('').where((element) => element == "@").length;
    lastNeedMention = currentCount == lastAtCount + 1;
    lastAtCount = currentCount;
    super.value = newValue;
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    return TextSpan(text: text, style: style);
  }
}
