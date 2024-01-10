import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class MessagesViewArguments implements ChatUIKitViewArguments {
  MessagesViewArguments({
    required this.profile,
    this.controller,
    this.appBar,
    this.inputBar,
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
    this.onMoreActionsItemsHandler,
    this.onItemLongPressActionsItemsHandler,
    this.inputBarTextEditingController,
    this.forceLeft,
    this.attributes,
  });

  final ChatUIKitProfile profile;
  final MessageListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final Widget? inputBar;
  final bool showAvatar;
  final bool showNickname;
  final MessageItemTapCallback? onItemTap;
  final MessageItemTapCallback? onItemLongPress;
  final MessageItemTapCallback? onDoubleTap;
  final MessageItemTapCallback? onAvatarTap;
  final MessageItemTapCallback? onAvatarLongPressed;
  final MessageItemTapCallback? onNicknameTap;
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
  final List<ChatUIKitBottomSheetItem>? Function(
    BuildContext context,
    List<ChatUIKitBottomSheetItem> willShowList,
  )? onMoreActionsItemsHandler;
  final List<ChatUIKitBottomSheetItem>? Function(
    BuildContext context,
    List<ChatUIKitBottomSheetItem> willShowList,
    Message message,
  )? onItemLongPressActionsItemsHandler;
  final bool enableAppBar;
  final CustomTextEditingController? inputBarTextEditingController;
  bool? forceLeft;
  @override
  String? attributes;

  MessagesViewArguments copyWith({
    ChatUIKitProfile? profile,
    MessageListViewController? controller,
    ChatUIKitAppBar? appBar,
    Widget? inputBar,
    bool? showAvatar,
    bool? showNickname,
    MessageItemTapCallback? onItemTap,
    MessageItemTapCallback? onItemLongPress,
    MessageItemTapCallback? onDoubleTap,
    MessageItemTapCallback? onAvatarTap,
    MessageItemTapCallback? onAvatarLongPressed,
    MessageItemTapCallback? onNicknameTap,
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
    List<ChatUIKitBottomSheetItem>? Function(
      BuildContext context,
      List<ChatUIKitBottomSheetItem> willShowList,
    )? onMoreActionsItemsHandler,
    List<ChatUIKitBottomSheetItem>? Function(
      BuildContext context,
      List<ChatUIKitBottomSheetItem> willShowList,
      Message message,
    )? onItemLongPressActionsItemsHandler,
    CustomTextEditingController? inputBarTextEditingController,
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
      onMoreActionsItemsHandler:
          onMoreActionsItemsHandler ?? this.onMoreActionsItemsHandler,
      onItemLongPressActionsItemsHandler: onItemLongPressActionsItemsHandler ??
          this.onItemLongPressActionsItemsHandler,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      inputBarTextEditingController:
          inputBarTextEditingController ?? this.inputBarTextEditingController,
      attributes: attributes ?? this.attributes,
    );
  }
}
