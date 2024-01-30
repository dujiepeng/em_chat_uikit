import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class SearchUsersViewArguments implements ChatUIKitViewArguments {
  SearchUsersViewArguments({
    required this.searchData,
    required this.searchHideText,
    this.onTap,
    this.itemBuilder,
    this.enableMulti = false,
    this.selected,
    this.selectedCanChange = false,
    this.selectedTitle,
    this.attributes,
  });

  final List<NeedSearch> searchData;
  final String searchHideText;
  final void Function(BuildContext context, ChatUIKitProfile profile)? onTap;
  final Widget Function(BuildContext context, ChatUIKitProfile profile,
      String? searchKeyword)? itemBuilder;
  final bool enableMulti;
  final List<ChatUIKitProfile>? selected;
  final bool selectedCanChange;
  final String? selectedTitle;
  @override
  String? attributes;

  SearchUsersViewArguments copyWith({
    List<NeedSearch>? searchData,
    String? searchHideText,
    void Function(BuildContext context, ChatUIKitProfile profile)? onTap,
    Widget Function(BuildContext context, ChatUIKitProfile profile,
            String? searchKeyword)?
        itemBuilder,
    bool? enableMulti,
    List<ChatUIKitProfile>? selected,
    bool? selectedCanChange,
    String? selectedTitle,
    String? attributes,
  }) {
    return SearchUsersViewArguments(
      searchData: searchData ?? this.searchData,
      searchHideText: searchHideText ?? this.searchHideText,
      onTap: onTap ?? this.onTap,
      itemBuilder: itemBuilder ?? this.itemBuilder,
      enableMulti: enableMulti ?? this.enableMulti,
      selected: selected ?? this.selected,
      selectedCanChange: selectedCanChange ?? this.selectedCanChange,
      selectedTitle: selectedTitle ?? this.selectedTitle,
      attributes: attributes ?? this.attributes,
    );
  }
}
