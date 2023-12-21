import 'package:em_chat_uikit/chat_uikit.dart';

class ReportMessageViewArguments implements ChatUIKitViewArguments {
  ReportMessageViewArguments({
    required this.messageId,
    required this.reportReasons,
    this.appBar,
    this.attributes,
  });
  final String messageId;
  final List<String> reportReasons;
  final ChatUIKitAppBar? appBar;

  @override
  String? attributes;
}
