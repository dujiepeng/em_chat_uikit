import 'package:em_chat_uikit/chat_uikit.dart';

class ChangeInfoViewArguments implements ChatUIKitViewArguments {
  ChangeInfoViewArguments({
    required this.title,
    this.hint,
    this.inputTextCallback,
    this.attributes,
  });

  final String title;
  final String? hint;
  final Future<String?> Function()? inputTextCallback;

  @override
  String? attributes;
}
