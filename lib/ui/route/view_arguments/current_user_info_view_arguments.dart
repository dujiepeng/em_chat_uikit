import 'package:em_chat_uikit/chat_uikit.dart';

class CurrentUserInfoViewArguments implements ChatUIKitViewArguments {
  CurrentUserInfoViewArguments({
    required this.profile,
    this.attributes,
  });

  final ChatUIKitProfile profile;

  @override
  String? attributes;
}
