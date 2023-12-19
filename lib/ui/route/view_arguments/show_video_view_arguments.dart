import 'package:em_chat_uikit/chat_uikit.dart';

class ShowVideoViewArguments implements ChatUIKitViewArguments {
  ShowVideoViewArguments({
    required this.message,
    this.onImageLongPressed,
    this.attributes,
  });

  final Message message;
  final void Function(Message message)? onImageLongPressed;

  @override
  String? attributes;
}