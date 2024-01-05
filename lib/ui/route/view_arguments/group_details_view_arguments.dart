import 'package:em_chat_uikit/chat_uikit.dart';

class GroupDetailsViewArguments implements ChatUIKitViewArguments {
  GroupDetailsViewArguments({
    required this.profile,
    required this.actions,
    this.appBar,
    this.enableAppBar = true,
    this.attributes,
  });
  final ChatUIKitProfile profile;
  final List<ChatUIKitActionItem> actions;
  final ChatUIKitAppBar? appBar;
  final bool enableAppBar;

  @override
  String? attributes;

  GroupDetailsViewArguments copyWith({
    ChatUIKitProfile? profile,
    List<ChatUIKitActionItem>? actions,
    bool? enableAppBar,
    ChatUIKitAppBar? appBar,
    String? attributes,
  }) {
    return GroupDetailsViewArguments(
      profile: profile ?? this.profile,
      actions: actions ?? this.actions,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      appBar: appBar ?? this.appBar,
      attributes: attributes ?? this.attributes,
    );
  }
}
