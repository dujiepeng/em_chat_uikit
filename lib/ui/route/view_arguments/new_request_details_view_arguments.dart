import 'package:em_chat_uikit/chat_uikit.dart';

class NewRequestDetailsViewArguments implements ChatUIKitViewArguments {
  NewRequestDetailsViewArguments({
    required this.profile,
    this.isReceivedRequest = false,
    this.btnText,
    this.attributes,
  });
  final ChatUIKitProfile profile;
  final bool isReceivedRequest;
  final String? btnText;

  @override
  String? attributes;
}
