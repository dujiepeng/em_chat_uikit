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
    Widget content = SizedBox(
      height: 54,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 53.5,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  textScaleFactor: 1.0,
                  style: TextStyle(
                    fontWeight: theme.font.titleMedium.fontWeight,
                    fontSize: theme.font.titleMedium.fontSize,
                    color: theme.color.isDark
                        ? theme.color.neutralColor100
                        : theme.color.neutralColor1,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: trailing ?? const SizedBox(),
                  ),
                )
              ],
            ),
          ),
          Divider(
            height: borderHeight,
            thickness: borderHeight,
            color: theme.color.isDark
                ? theme.color.neutralColor2
                : theme.color.neutralColor9,
          )
        ],
      ),
    );

    content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: content,
    );

    return content;
  }
}
