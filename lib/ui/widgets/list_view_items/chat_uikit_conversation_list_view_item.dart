import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitConversationListViewItem extends StatelessWidget {
  const ChatUIKitConversationListViewItem(
    this.info, {
    this.showAvatar,
    this.showNewMessageTime = true,
    this.showTitle = true,
    this.showSubTitle = true,
    this.showUnreadCount = true,
    this.showNoDisturb = true,
    super.key,
  });

  final ConversationInfo info;
  final bool? showAvatar;
  final bool showNewMessageTime;
  final bool showTitle;
  final bool showSubTitle;
  final bool showUnreadCount;
  final bool showNoDisturb;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);

    Widget avatar = showAvatar ?? ChatUIKitSettings.showConversationListAvatar
        ? Container(
            margin: const EdgeInsets.only(right: 12),
            child: ChatUIKitAvatar(
              avatarUrl: info.avatarUrl,
              size: 40,
            ),
          )
        : const SizedBox();

    Widget title = showTitle
        ? Text(
            info.showName,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              color: theme.color.isDark
                  ? theme.color.neutralColor98
                  : theme.color.neutralColor1,
              fontSize: theme.font.titleLarge.fontSize,
              fontWeight: theme.font.titleLarge.fontWeight,
            ),
          )
        : const SizedBox();

    Widget muteType = showNoDisturb && info.noDisturb
        ? Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.fromLTRB(2, 1, 0, 1),
            alignment: Alignment.center,
            child: ChatUIKitSettings.conversationListMuteImage != null
                ? Image.asset(ChatUIKitSettings.conversationListMuteImage!)
                : ChatUIKitImageLoader.noDisturb(
                    color: theme.color.isDark
                        ? theme.color.neutralColor5
                        : theme.color.neutralColor6),
          )
        : const SizedBox();

    Widget timeLabel = showNewMessageTime &&
            info.lastMessage?.serverTime != null
        ? Text(
            ChatUIKitTimeTool.getChatTimeStr(info.lastMessage?.serverTime ?? 0),
            style: TextStyle(
              color: theme.color.isDark
                  ? theme.color.neutralColor6
                  : theme.color.neutralColor5,
              fontSize: theme.font.bodySmall.fontSize,
              fontWeight: theme.font.bodySmall.fontWeight,
            ),
          )
        : const SizedBox();

    Widget titleRow = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(flex: 1, fit: FlexFit.loose, child: title),
        muteType,
      ],
    );

    titleRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(flex: 1, fit: FlexFit.tight, child: titleRow),
        timeLabel,
      ],
    );

    Widget subTitle = showSubTitle
        ? RichText(
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            text: TextSpan(
              style: TextStyle(
                color: theme.color.isDark
                    ? theme.color.neutralColor6
                    : theme.color.neutralColor5,
                fontSize: theme.font.labelMedium.fontSize,
                fontWeight: theme.font.labelMedium.fontWeight,
              ),
              children: [
                if (info.hasMention) const TextSpan(text: '[有人@我]'),
                TextSpan(text: () {
                  String str = '';
                  if (info.profile.type == ChatUIKitProfileType.groupChat) {
                    str += info.lastMessage?.nickname ??
                        info.lastMessage?.from ??
                        "";
                    if (str.isNotEmpty) {
                      str = "$str: ";
                    }
                  }

                  str += info.lastMessage?.showInfo(context: context) ?? '';
                  return str;
                }())
              ],
            ),
          )
        : const SizedBox();

    Widget unreadCount;
    if (info.noDisturb) {
      unreadCount = showUnreadCount && info.unreadCount > 0
          ? Container(
              width: 8,
              height: 8,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.color.isDark
                    ? theme.color.primaryColor6
                    : theme.color.primaryColor5,
                borderRadius: BorderRadius.circular(4),
              ),
            )
          : const SizedBox();
    } else {
      unreadCount = showUnreadCount && info.unreadCount > 0
          ? Container(
              padding: const EdgeInsets.fromLTRB(4, 1, 4, 1),
              constraints: const BoxConstraints(
                  minWidth: 20, maxHeight: 20, minHeight: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.color.isDark
                    ? theme.color.primaryColor6
                    : theme.color.primaryColor5,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                info.unreadCount > 99 ? '99+' : info.unreadCount.toString(),
                style: TextStyle(
                  color: theme.color.isDark
                      ? theme.color.neutralColor1
                      : theme.color.neutralColor98,
                  fontSize: theme.font.labelSmall.fontSize,
                  fontWeight: theme.font.labelSmall.fontWeight,
                ),
              ),
            )
          : const SizedBox();
    }

    Widget subTitleRow = Row(
      children: [
        Expanded(child: subTitle),
        unreadCount,
      ],
    );

    Widget content = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        avatar,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              titleRow,
              subTitleRow,
            ],
          ),
        )
      ],
    );
    content = Container(
      padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
      color: info.pinned
          ? (theme.color.isDark
              ? theme.color.neutralColor2
              : theme.color.neutralColor9)
          : theme.color.isDark
              ? theme.color.neutralColor1
              : theme.color.neutralColor98,
      child: content,
    );

    content = Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(child: content),
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
