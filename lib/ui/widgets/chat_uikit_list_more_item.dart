import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

const double borderHeight = 0.5;

class ChatUIKitListMoreItem extends StatelessWidget
    with NeedAlphabeticalWidget {
  const ChatUIKitListMoreItem({
    required this.title,
    this.trailing,
    this.enableArrow = true,
    this.onTap,
    super.key,
  });
  final String title;

  final Widget? trailing;

  final bool enableArrow;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);

    Widget content = Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.neutralColor98
                : theme.color.neutralColor1,
            fontSize: theme.font.titleMedium.fontSize,
            fontWeight: theme.font.titleMedium.fontWeight,
          ),
        )
      ],
    );

    if (enableArrow) {
      content = Row(
        children: [
          Expanded(
            child: content,
          ),
          trailing ?? const SizedBox(),
          Icon(
            Icons.arrow_forward_ios,
            size: 13,
            color: theme.color.isDark
                ? theme.color.neutralColor5
                : theme.color.neutralColor3,
          ),
        ],
      );
    }

    content = Container(
      height: itemHeight - borderHeight,
      decoration: BoxDecoration(
        color: theme.color.isDark
            ? theme.color.neutralColor1
            : theme.color.neutralColor98,
      ),
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: content,
    );

    content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        content,
        Container(
          height: borderHeight,
          color: theme.color.isDark
              ? theme.color.neutralColor2
              : theme.color.neutralColor9,
          margin: const EdgeInsets.only(left: 16),
        )
      ],
    );

    content = InkWell(
      onTap: onTap,
      child: content,
    );

    return content;
  }
  
  @override
  double get itemHeight => 56;
}
