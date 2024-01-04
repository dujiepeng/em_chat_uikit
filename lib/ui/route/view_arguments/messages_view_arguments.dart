import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class MessagesViewArguments implements ChatUIKitViewArguments {
  MessagesViewArguments({
    required this.profile,
    this.controller,
    this.appBar,
    this.inputBar,
    this.attributes,
    this.showAvatar = true,
    this.showNickname = true,
    this.onItemTap,
    this.onItemLongPress,
    this.onDoubleTap,
    this.onAvatarTap,
    this.onAvatarLongPressed,
    this.onNicknameTap,
    this.focusNode,
    this.emojiWidget,
    this.itemBuilder,
    this.alertItemBuilder,
    this.moreActionItems,
    this.onItemLongPressActions,
    this.bubbleStyle = ChatUIKitMessageListViewBubbleStyle.arrow,
    this.replyBarBuilder,
    this.quoteBuilder,
    this.onErrorTap,
    this.bubbleBuilder,
    this.enableAppBar = true,
    this.bubbleContentBuilder,
  });

  final ChatUIKitProfile profile;
  final MessageListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final Widget? inputBar;
  final bool showAvatar;
  final bool showNickname;
  final void Function(Message message)? onItemTap;
  final void Function(Message message)? onItemLongPress;
  final void Function(Message message)? onDoubleTap;
  final void Function(Message message)? onAvatarTap;
  final void Function(Message message)? onAvatarLongPressed;
  final void Function(Message message)? onNicknameTap;
  final ChatUIKitMessageListViewBubbleStyle bubbleStyle;
  final List<ChatUIKitBottomSheetItem>? moreActionItems;
  final List<ChatUIKitBottomSheetItem>? onItemLongPressActions;
  final MessageItemBuilder? itemBuilder;
  final MessageItemBuilder? alertItemBuilder;
  final FocusNode? focusNode;
  final Widget? emojiWidget;
  final Widget? Function(BuildContext context, Message message)?
      replyBarBuilder;
  final Widget Function(QuoteModel model)? quoteBuilder;
  final void Function(Message message)? onErrorTap;
  final MessageItemBubbleBuilder? bubbleBuilder;
  final MessageBubbleContentBuilder? bubbleContentBuilder;
  final bool enableAppBar;
  @override
  String? attributes;
}
