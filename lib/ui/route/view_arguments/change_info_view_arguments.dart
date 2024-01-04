import 'package:em_chat_uikit/chat_uikit.dart';

class ChangeInfoViewArguments implements ChatUIKitViewArguments {
  ChangeInfoViewArguments({
    this.title,
    this.hint,
    this.inputTextCallback,
    this.saveButtonTitle,
    this.appBar,
    this.maxLength = 128,
    this.attributes,
    this.enableAppBar = true,
  });

  final String? title;
  final String? hint;
  final String? saveButtonTitle;
  final Future<String?> Function()? inputTextCallback;
  final ChatUIKitAppBar? appBar;
  final int maxLength;
  final bool enableAppBar;

  @override
  String? attributes;
}
