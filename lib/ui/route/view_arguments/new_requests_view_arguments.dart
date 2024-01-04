import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class NewRequestsViewArguments implements ChatUIKitViewArguments {
  NewRequestsViewArguments({
    this.controller,
    this.appBar,
    this.onSearchTap,
    this.listViewItemBuilder,
    this.onTap,
    this.onLongPress,
    this.fakeSearchHideText,
    this.listViewBackground,
    this.loadErrorMessage,
    this.enableAppBar = true,
    this.attributes,
  });

  final NewRequestListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final void Function(List<NewRequestItemModel> data)? onSearchTap;
  final ChatUIKitNewRequestItemBuilder? listViewItemBuilder;
  final void Function(BuildContext context, NewRequestItemModel model)? onTap;
  final void Function(BuildContext context, NewRequestItemModel model)?
      onLongPress;
  final String? fakeSearchHideText;
  final Widget? listViewBackground;
  final String? loadErrorMessage;
  final bool enableAppBar;

  @override
  String? attributes;
}
