import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitDetailsListViewItem extends StatelessWidget {
  const ChatUIKitDetailsListViewItem(
      {required this.title, this.trailing, super.key});
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    return SizedBox(
      child: Column(children: [
        ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontWeight: theme.font.titleMedium.fontWeight,
              fontSize: theme.font.titleMedium.fontSize,
              color: theme.color.isDark
                  ? theme.color.neutralColor100
                  : theme.color.neutralColor1,
            ),
          ),
          trailing: trailing,
        ),
        Container(
          height: borderHeight,
          color: theme.color.isDark
              ? theme.color.neutralColor2
              : theme.color.neutralColor9,
          margin: const EdgeInsets.only(left: 16),
        )
      ]),
    );
  }
}
