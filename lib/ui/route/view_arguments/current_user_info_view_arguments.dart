import 'package:em_chat_uikit/chat_uikit.dart';

class CurrentUserInfoViewArguments implements ChatUIKitViewArguments {
  CurrentUserInfoViewArguments({
    required this.profile,
    this.attributes,
    this.appBar,
    this.enableAppBar = true,
  });

  final ChatUIKitProfile profile;
  final ChatUIKitAppBar? appBar;
  final bool enableAppBar;
  @override
  String? attributes;
}
