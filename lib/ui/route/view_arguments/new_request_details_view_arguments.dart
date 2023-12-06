import 'package:em_chat_uikit/chat_uikit.dart';

class NewRequestDetailsViewArguments implements ChatUIKitViewArguments {
  NewRequestDetailsViewArguments({
    required this.profile,
    this.attributes,
  });
  final ChatUIKitProfile profile;

  @override
  String? attributes;
}
