import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class NotificationAction {
  final String text;

  final VoidCallback? onTap;

  NotificationAction({
    required this.text,
    this.onTap,
  });
}

class ChatUIKitMessageListViewNotificationItem extends StatelessWidget {
  const ChatUIKitMessageListViewNotificationItem({
    required this.infos,
    this.isCenter = true,
    this.textAlign = TextAlign.center,
    this.style,
    super.key,
  });

  final List<NotificationAction> infos;
  final bool isCenter;
  final TextAlign textAlign;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    final defaultStyle = style ??
        TextStyle(
          fontSize: theme.font.labelSmall.fontSize,
          fontWeight: theme.font.labelSmall.fontWeight,
          color: theme.color.isDark
              ? theme.color.neutralColor6
              : theme.color.neutralColor7,
        );

    final actionTextStyle = TextStyle(
      fontSize: theme.font.labelSmall.fontSize,
      fontWeight: theme.font.labelSmall.fontWeight,
      color: theme.color.isDark
          ? theme.color.primaryColor6
          : theme.color.primaryColor5,
    );

    List<InlineSpan> list = [];

    for (var info in infos) {
      bool hasAction = info.onTap != null;

      if (hasAction && info != infos.first) {
        list.add(
          const WidgetSpan(child: SizedBox(width: 2)),
        );
      }

      list.add(
        TextSpan(
            text: info.text,
            style: hasAction ? actionTextStyle : null,
            recognizer: TapGestureRecognizer()..onTap = info.onTap),
      );

      if (hasAction && info != infos.last) {
        list.add(
          const WidgetSpan(child: SizedBox(width: 2)),
        );
      }
    }

    return RichText(
      text: TextSpan(
        style: defaultStyle,
        children: list,
      ),
      textAlign: textAlign,
    );
  }
}
