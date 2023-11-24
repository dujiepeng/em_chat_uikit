import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitContactItem extends StatelessWidget {
  const ChatUIKitContactItem(this.model, {this.searchKeyword, super.key});
  final String? searchKeyword;
  final ContactItemModel model;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);

    TextStyle textStyle = TextStyle(
      color: theme.color.isDark
          ? theme.color.neutralColor98
          : theme.color.neutralColor1,
      fontSize: theme.font.titleMedium.fontSize,
      fontWeight: theme.font.titleMedium.fontWeight,
    );

    Widget avatar = ChatUIKitAvatar(
      avatarUrl: model.avatarUrl,
      size: 40,
    );

    String showName = model.showName.toLowerCase();
    String keyword = searchKeyword?.toLowerCase() ?? '';

    Widget? name;
    int index = showName.indexOf(keyword);
    if (index != -1 && keyword.isNotEmpty) {
      List<InlineSpan> tmp = [];
      tmp.add(TextSpan(text: model.showName.substring(0, index)));
      tmp.add(TextSpan(
        text: model.showName.substring(index, index + keyword.length),
        style: TextStyle(
          color: theme.color.isDark
              ? theme.color.primaryColor6
              : theme.color.primaryColor5,
          fontWeight: theme.font.titleMedium.fontWeight,
          fontSize: theme.font.titleMedium.fontSize,
        ),
      ));
      tmp.add(TextSpan(text: model.showName.substring(index + keyword.length)));

      name = RichText(
        text: TextSpan(
          children: tmp,
          style: textStyle,
        ),
      );
    }

    name ??= Text(
      model.showName,
      style: textStyle,
    );

    Widget content = Row(
      children: [
        avatar,
        const SizedBox(width: 12),
        name,
      ],
    );
    content = Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      height: model.itemHeight - 0.5,
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
    return content;
  }
}
