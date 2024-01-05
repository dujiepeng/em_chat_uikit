import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/services.dart';

class ContactDetailsViewArguments implements ChatUIKitViewArguments {
  ContactDetailsViewArguments({
    required this.profile,
    required this.actions,
    this.onMessageDidClear,
    this.attributes,
    this.enableAppBar = true,
    this.appBar,
  });

  final ChatUIKitProfile profile;
  final List<ChatUIKitActionItem> actions;
  final VoidCallback? onMessageDidClear;
  final bool enableAppBar;
  final ChatUIKitAppBar? appBar;
  @override
  String? attributes;

  ContactDetailsViewArguments copyWith({
    ChatUIKitProfile? profile,
    List<ChatUIKitActionItem>? actions,
    VoidCallback? onMessageDidClear,
    bool? enableAppBar,
    ChatUIKitAppBar? appBar,
    String? attributes,
  }) {
    return ContactDetailsViewArguments(
      profile: profile ?? this.profile,
      actions: actions ?? this.actions,
      onMessageDidClear: onMessageDidClear ?? this.onMessageDidClear,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      appBar: appBar ?? this.appBar,
      attributes: attributes ?? this.attributes,
    );
  }
}
