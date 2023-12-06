import 'package:em_chat_uikit/chat_uikit.dart';

class ContactDetailsViewArguments implements ChatUIKitViewArguments {
  ContactDetailsViewArguments({
    required this.profile,
    required this.actions,
    this.attributes,
  });

  final ChatUIKitProfile profile;
  final List<ChatUIKitActionItem> actions;

  @override
  String? attributes;
}
