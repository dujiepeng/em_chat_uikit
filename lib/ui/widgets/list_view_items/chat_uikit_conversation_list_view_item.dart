// ignore_for_file: deprecated_member_use
import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitConversationListViewItem extends StatelessWidget {
  const ChatUIKitConversationListViewItem(
    this.info, {
    this.showAvatar,
    this.subTitleLabel,
    this.unreadCount,
    this.showNewMessageTime = true,
    this.showTitle = true,
    this.showSubTitle = true,
    this.showUnreadCount = true,
    this.showNoDisturb = true,
    this.timestamp,
    super.key,
  });

  final ConversationModel info;
  final bool? showAvatar;
  final bool showNewMessageTime;
  final bool showTitle;
  final bool showSubTitle;
  final bool showUnreadCount;
  final bool showNoDisturb;
  final String? subTitleLabel;
  final String? unreadCount;
  final int? timestamp;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);

    Widget avatar = showAvatar ?? ChatUIKitSettings.showConversationListAvatar
        ? Container(
            margin: const EdgeInsets.only(right: 12),
            child: ChatUIKitAvatar(
              avatarUrl: info.avatarUrl,
              size: 50,
            ),
          )
        : const SizedBox();

    Widget title = showTitle
        ? Text(
            info.showName,
            textScaleFactor: 1.0,
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
                ? Image(image: ChatUIKitSettings.conversationListMuteImage!)
                : ChatUIKitImageLoader.noDisturb(
                    color: theme.color.isDark
                        ? theme.color.neutralColor5
                        : theme.color.neutralColor6),
          )
        : const SizedBox();

    Widget timeLabel = showNewMessageTime
        ? Text(
            ChatUIKitTimeFormatter.instance.formatterHandler?.call(
                    context,
                    ChatUIKitTimeType.conversation,
                    timestamp ?? info.lastMessage?.serverTime ?? 0) ??
                ChatUIKitTimeTool.getChatTimeStr(
                    timestamp ?? info.lastMessage?.serverTime ?? 0),
            textScaleFactor: 1.0,
            overflow: TextOverflow.ellipsis,
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

    final style = TextStyle(
      color: theme.color.isDark
          ? theme.color.neutralColor6
          : theme.color.neutralColor5,
      fontSize: theme.font.labelMedium.fontSize,
      fontWeight: theme.font.labelMedium.fontWeight,
    );

    Widget? subTitle;
    if (!showSubTitle) {
      subTitle = const SizedBox();
    } else {
      subTitle = subTitleLabel?.isNotEmpty == true
          ? Text(
              subTitleLabel!,
              style: style,
            )
          : RichText(
              textScaleFactor: 1.0,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              text: TextSpan(
                style: style,
                children: [
                  if (info.hasMention)
                    TextSpan(
                        text:
                            '[${ChatUIKitLocal.conversationListItemMention.getString(context)}]',
                        style: () {
                          final style = TextStyle(
                            color: theme.color.isDark
                                ? theme.color.primaryColor6
                                : theme.color.primaryColor5,
                            fontSize: theme.font.labelMedium.fontSize,
                            fontWeight: theme.font.labelMedium.fontWeight,
                          );
                          return style;
                        }()),
                  TextSpan(
                      text: info.lastMessage?.showInfo(context: context) ?? '')
                ],
              ),
            );
    }

    Widget unreadCount;
    if (info.noDisturb) {
      unreadCount = showUnreadCount && info.unreadCount > 0
          ? Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: theme.color.isDark
                    ? theme.color.primaryColor6
                    : theme.color.primaryColor5,
                borderRadius: BorderRadius.circular(4),
              ),
            )
          : const SizedBox();
      unreadCount = Center(
        child: unreadCount,
      );
    } else {
      unreadCount = showUnreadCount &&
              info.unreadCount > 0 &&
              ChatUIKitSettings.showConversationListUnreadCount == true
          ? Container(
              padding: const EdgeInsets.fromLTRB(4, 1, 4, 1),
              constraints: const BoxConstraints(
                minWidth: 20,
                maxHeight: 20,
                minHeight: 20,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.color.isDark
                    ? theme.color.primaryColor6
                    : theme.color.primaryColor5,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                info.unreadCount > 99 ? '99+' : info.unreadCount.toString(),
                textScaleFactor: 1.0,
                overflow: TextOverflow.ellipsis,
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

    unreadCount = SizedBox(
      height: 20,
      child: unreadCount,
    );

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
        Flexible(
          flex: 1,
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
              : theme.color.neutralColor95)
          : theme.color.isDark
              ? theme.color.neutralColor1
              : theme.color.neutralColor98,
      child: content,
    );

    content = Stack(
      children: [
        content,
        Positioned(
          bottom: 0,
          left: 78 - (ChatUIKitSettings.showConversationListAvatar ? 0 : 60),
          right: 0,
          height: 0.5,
          child: Divider(
            height: borderHeight,
            thickness: borderHeight,
            color: theme.color.isDark
                ? theme.color.neutralColor2
                : theme.color.neutralColor9,
          ),
        )
      ],
    );

    content = SizedBox(height: 76, child: content);

    return content;
  }
}
