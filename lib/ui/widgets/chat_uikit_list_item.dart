import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

const double borderHeight = 0.5;

class ChatUIKitListItem extends StatelessWidget {
  const ChatUIKitListItem({
    required this.model,
    this.trailing,
    super.key,
  });
  final ChatUIKitListItemModel model;

  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);

    Widget content = Row(
      children: [
        Text(
          model.title,
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

    if (model.enableArrow) {
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

    double height = 60;
    if (model is NeedAlphabetical) {
      height = model.itemHeight;
    }

    content = Container(
      height: height - borderHeight,
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

    if (model.onTap != null) {
      content = InkWell(
        onTap: model.onTap,
        child: content,
      );
    }

    return content;
  }
}
