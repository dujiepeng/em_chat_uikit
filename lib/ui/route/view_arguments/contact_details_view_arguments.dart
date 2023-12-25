import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/services.dart';

class ContactDetailsViewArguments implements ChatUIKitViewArguments {
  ContactDetailsViewArguments({
    required this.profile,
    required this.actions,
    this.onMessageDidClear,
    this.attributes,
  });

  final ChatUIKitProfile profile;
  final List<ChatUIKitActionItem> actions;
  final VoidCallback? onMessageDidClear;

  @override
  String? attributes;
}
