import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class ConversationsViewArguments implements ChatUIKitViewArguments {
  ConversationsViewArguments({
    this.controller,
    this.appBar,
    this.onSearchTap,
    this.beforeWidgets,
    this.afterWidgets,
    this.listViewItemBuilder,
    this.onTap,
    this.onLongPress,
    this.fakeSearchHideText,
    this.listViewBackground,
    this.enableAppBar = true,
    this.appBarMoreActionsBuilder,
    this.title,
    this.attributes,
  });

  final ConversationListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final void Function(List<ConversationInfo> data)? onSearchTap;
  final List<Widget>? beforeWidgets;
  final List<Widget>? afterWidgets;
  final ChatUIKitConversationItemBuilder? listViewItemBuilder;
  final void Function(BuildContext context, ConversationInfo model)? onTap;
  final List<ChatUIKitBottomSheetItem> Function(
    BuildContext context,
    ConversationInfo info,
    List<ChatUIKitBottomSheetItem> defaultActions,
  )? onLongPress;
  final String? fakeSearchHideText;
  final Widget? listViewBackground;
  final bool enableAppBar;
  final AppBarMoreActionsBuilder? appBarMoreActionsBuilder;
  final String? title;
  @override
  String? attributes;

  ConversationsViewArguments copyWith({
    ConversationListViewController? controller,
    ChatUIKitAppBar? appBar,
    void Function(List<ConversationInfo> data)? onSearchTap,
    List<NeedAlphabeticalWidget>? beforeWidgets,
    List<NeedAlphabeticalWidget>? afterWidgets,
    ChatUIKitListItemBuilder? listViewItemBuilder,
    void Function(BuildContext context, ConversationInfo model)? onTap,
    final List<ChatUIKitBottomSheetItem> Function(
      BuildContext context,
      ConversationInfo info,
      List<ChatUIKitBottomSheetItem> defaultActions,
    )? onLongPress,
    String? fakeSearchHideText,
    Widget? listViewBackground,
    bool? enableAppBar,
    AppBarMoreActionsBuilder? appBarMoreActionsBuilder,
    String? attributes,
  }) {
    return ConversationsViewArguments(
      controller: controller ?? this.controller,
      appBar: appBar ?? this.appBar,
      onSearchTap: onSearchTap ?? this.onSearchTap,
      beforeWidgets: beforeWidgets ?? this.beforeWidgets,
      afterWidgets: afterWidgets ?? this.afterWidgets,
      listViewItemBuilder: listViewItemBuilder ?? this.listViewItemBuilder,
      onTap: onTap ?? this.onTap,
      onLongPress: onLongPress ?? this.onLongPress,
      fakeSearchHideText: fakeSearchHideText ?? this.fakeSearchHideText,
      listViewBackground: listViewBackground ?? this.listViewBackground,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      appBarMoreActionsBuilder:
          appBarMoreActionsBuilder ?? this.appBarMoreActionsBuilder,
      attributes: attributes ?? this.attributes,
    );
  }
}
