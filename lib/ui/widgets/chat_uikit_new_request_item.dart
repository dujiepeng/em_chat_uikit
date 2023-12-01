import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitNewRequestItem extends StatelessWidget {
  const ChatUIKitNewRequestItem(this.model, {super.key});

  final NewRequestItemModel model;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);

    TextStyle normalStyle = TextStyle(
      color: theme.color.isDark
          ? theme.color.neutralColor98
          : theme.color.neutralColor1,
      fontSize: theme.font.titleMedium.fontSize,
      fontWeight: theme.font.titleMedium.fontWeight,
    );

    Widget name = Text(
      model.showName,
      overflow: TextOverflow.ellipsis,
      style: normalStyle,
    );

    Widget reason = Text(
      model.reason?.isNotEmpty == true ? model.reason! : '请求添加您为好友',
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: theme.color.isDark
            ? theme.color.neutralColor6
            : theme.color.neutralColor5,
        fontSize: theme.font.titleSmall.fontSize,
        fontWeight: theme.font.titleSmall.fontWeight,
      ),
    );

    Widget avatar = ChatUIKitAvatar(
      avatarUrl: model.avatarUrl,
      size: 40,
    );

    Widget content = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        avatar,
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [name, reason],
          ),
        ),
        InkWell(
          onTap: onAcceptTap,
          child: Container(
            width: 74,
            height: 28,
            decoration: BoxDecoration(
              color: theme.color.primaryColor5,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                '添加',
                style: TextStyle(
                  color: theme.color.isDark
                      ? theme.color.neutralColor1
                      : theme.color.neutralColor98,
                  fontSize: theme.font.labelMedium.fontSize,
                  fontWeight: theme.font.labelMedium.fontWeight,
                ),
              ),
            ),
          ),
        ),
      ],
    );
    content = Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 5),
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

  void onAcceptTap() async {
    try {
      ChatUIKit.instance.acceptContactRequest(userId: model.profile.id);
      // ignore: empty_catches
    } on ChatError {}
  }
}
