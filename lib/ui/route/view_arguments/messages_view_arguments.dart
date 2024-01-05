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

  MessagesViewArguments copyWith({
    ChatUIKitProfile? profile,
    MessageListViewController? controller,
    ChatUIKitAppBar? appBar,
    Widget? inputBar,
    bool? showAvatar,
    bool? showNickname,
    void Function(Message message)? onItemTap,
    void Function(Message message)? onItemLongPress,
    void Function(Message message)? onDoubleTap,
    void Function(Message message)? onAvatarTap,
    void Function(Message message)? onAvatarLongPressed,
    void Function(Message message)? onNicknameTap,
    ChatUIKitMessageListViewBubbleStyle? bubbleStyle,
    List<ChatUIKitBottomSheetItem>? moreActionItems,
    List<ChatUIKitBottomSheetItem>? onItemLongPressActions,
    MessageItemBuilder? itemBuilder,
    MessageItemBuilder? alertItemBuilder,
    FocusNode? focusNode,
    Widget? emojiWidget,
    Widget? Function(BuildContext context, Message message)? replyBarBuilder,
    Widget Function(QuoteModel model)? quoteBuilder,
    void Function(Message message)? onErrorTap,
    MessageItemBubbleBuilder? bubbleBuilder,
    MessageBubbleContentBuilder? bubbleContentBuilder,
    bool? enableAppBar,
    String? attributes,
  }) {
    return MessagesViewArguments(
      profile: profile ?? this.profile,
      controller: controller ?? this.controller,
      appBar: appBar ?? this.appBar,
      inputBar: inputBar ?? this.inputBar,
      showAvatar: showAvatar ?? this.showAvatar,
      showNickname: showNickname ?? this.showNickname,
      onItemTap: onItemTap ?? this.onItemTap,
      onItemLongPress: onItemLongPress ?? this.onItemLongPress,
      onDoubleTap: onDoubleTap ?? this.onDoubleTap,
      onAvatarTap: onAvatarTap ?? this.onAvatarTap,
      onAvatarLongPressed: onAvatarLongPressed ?? this.onAvatarLongPressed,
      onNicknameTap: onNicknameTap ?? this.onNicknameTap,
      bubbleStyle: bubbleStyle ?? this.bubbleStyle,
      moreActionItems: moreActionItems ?? this.moreActionItems,
      onItemLongPressActions:
          onItemLongPressActions ?? this.onItemLongPressActions,
      itemBuilder: itemBuilder ?? this.itemBuilder,
      alertItemBuilder: alertItemBuilder ?? this.alertItemBuilder,
      focusNode: focusNode ?? this.focusNode,
      emojiWidget: emojiWidget ?? this.emojiWidget,
      replyBarBuilder: replyBarBuilder ?? this.replyBarBuilder,
      quoteBuilder: quoteBuilder ?? this.quoteBuilder,
      onErrorTap: onErrorTap ?? this.onErrorTap,
      bubbleBuilder: bubbleBuilder ?? this.bubbleBuilder,
      bubbleContentBuilder: bubbleContentBuilder ?? this.bubbleContentBuilder,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      attributes: attributes ?? this.attributes,
    );
  }
}
