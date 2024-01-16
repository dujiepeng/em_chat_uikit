import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit_example/pages/conversation/custom_conversation_controller.dart';
import 'package:em_chat_uikit_example/pages/tool/user_data_store.dart';
import 'package:flutter/material.dart';

class CustomConversationPage extends StatefulWidget {
  const CustomConversationPage({super.key});

  @override
  State<CustomConversationPage> createState() => _CustomConversationPageState();
}

class _CustomConversationPageState extends State<CustomConversationPage> {
  CustomConversationController controller = CustomConversationController();
  @override
  Widget build(BuildContext context) {
    return ConversationsView(
      onLongPress: (context, info, defaultActions) {
        defaultActions.removeWhere((element) => element.label == '置顶');
        defaultActions.add(
          ChatUIKitBottomSheetItem.normal(
            label: '移出群助手',
            onTap: () async {
              UserDataStore().unNotifyGroupIds.remove(info.profile.id);
              controller.reload();
              Navigator.of(context).pop();
            },
          ),
        );
        return defaultActions;
      },
      appBar: const ChatUIKitAppBar(
        centerTitle: false,
        title: '群助手',
      ),
      controller: controller,
    );
  }
}
