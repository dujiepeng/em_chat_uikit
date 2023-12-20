import 'package:flutter/widgets.dart';

class CustomTextEditingController extends TextEditingController {
  final List<String> _userIds = [];

  int atCount = 0;

  CustomTextEditingController({String? text}) : super(text: text);

  void addUserIds(String userId) {
    _userIds.add(userId);
  }

  void deleteUserId(String userId) {
    _userIds.remove(userId);
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final currentCount =
        text.split('').where((element) => element == "@").length;
    if (currentCount == atCount + 1) {}

    return TextSpan(text: text);
  }
}
