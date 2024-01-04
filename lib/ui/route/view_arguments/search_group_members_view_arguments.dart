import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class SearchGroupMembersViewArguments implements ChatUIKitViewArguments {
  SearchGroupMembersViewArguments({
    required this.searchData,
    required this.searchHideText,
    this.onTap,
    this.itemBuilder,
    this.appBar,
    this.enableAppBar = true,
    this.attributes,
  });

  final List<NeedSearch> searchData;
  final String searchHideText;
  final void Function(BuildContext context, ChatUIKitProfile profile)? onTap;
  final Widget Function(BuildContext context, ChatUIKitProfile profile,
      String? searchKeyword)? itemBuilder;
  final ChatUIKitAppBar? appBar;
  final bool enableAppBar;
  @override
  String? attributes;
}
