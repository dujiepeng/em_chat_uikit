import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

typedef ListViewBuilder = Widget Function(
  BuildContext context,
  List<ChatUIKitListItemModelBase> list,
);

class ChatUIKitSingleSelectView extends StatelessWidget {
  const ChatUIKitSingleSelectView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
