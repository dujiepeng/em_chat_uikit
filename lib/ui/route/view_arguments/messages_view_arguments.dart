import 'package:em_chat_uikit/chat_uikit.dart';

class MessagesViewArguments implements ChatUIKitViewArguments {
  MessagesViewArguments(
      {required this.profile, this.controller, this.appBar, this.attributes});

  final ChatUIKitProfile profile;
  final MessageListViewController? controller;final ChatUIKitAppBar? appBar;
  @override
  String? attributes;
}
