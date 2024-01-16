import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitNewRequestListViewItem extends StatelessWidget {
  const ChatUIKitNewRequestListViewItem(
    this.model, {
    this.onAcceptTap,
    super.key,
  });

  final NewRequestItemModel model;
  final VoidCallback? onAcceptTap;

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
      textScaleFactor: 1.0,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: normalStyle,
    );

    Widget reason = Text(
      model.reason?.isNotEmpty == true
          ? model.reason!
          : ChatUIKitLocal.newRequestItemAddReason.getString(context),
      textScaleFactor: 1.0,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
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
          onTap: onAcceptTap ?? _onAcceptTap,
          child: Container(
            width: 74,
            height: 28,
            decoration: BoxDecoration(
              color: theme.color.primaryColor5,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                ChatUIKitLocal.newRequestItemAdd.getString(context),
                textScaleFactor: 1.0,
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
    content = Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 5),
      child: content,
    );

    content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        content,
        Divider(
          indent: 68,
          height: borderHeight,
          thickness: borderHeight,
          color: theme.color.isDark
              ? theme.color.neutralColor2
              : theme.color.neutralColor9,
        )
      ],
    );
    return content;
  }

  void _onAcceptTap() async {
    try {
      ChatUIKit.instance.acceptContactRequest(userId: model.profile.id);
      // ignore: empty_catches
    } on ChatError {}
  }
}
