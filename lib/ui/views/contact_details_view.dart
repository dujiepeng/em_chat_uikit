import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ContactDetailsView extends StatefulWidget {
  const ContactDetailsView({required this.profile, super.key});

  final ChatUIKitProfile profile;

  @override
  State<ContactDetailsView> createState() => _ContactDetailsViewState();
}

class _ContactDetailsViewState extends State<ContactDetailsView> {
  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget content = Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: theme.color.isDark
            ? theme.color.neutralColor1
            : theme.color.neutralColor98,
        appBar: ChatUIKitAppBar(
          autoBackButton: true,
          trailing: IconButton(
            iconSize: 24,
            color: theme.color.isDark
                ? theme.color.neutralColor95
                : theme.color.neutralColor3,
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ),
        body: Container());

    return content;
  }
}
