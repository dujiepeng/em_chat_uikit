// ignore_for_file: deprecated_member_use
import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class SearchUsersView extends StatefulWidget {
  SearchUsersView.arguments(
    SearchUsersViewArguments arguments, {
    super.key,
  })  : searchData = arguments.searchData,
        searchHideText = arguments.searchHideText,
        itemBuilder = arguments.itemBuilder,
        onTap = arguments.onTap,
        enableMulti = arguments.enableMulti,
        selected = arguments.selected,
        selectedCanChange = arguments.selectedCanChange,
        selectedTitle = arguments.selectedTitle,
        attributes = arguments.attributes;

  const SearchUsersView({
    required this.searchData,
    required this.searchHideText,
    this.itemBuilder,
    this.onTap,
    this.enableMulti = false,
    this.selected,
    this.selectedCanChange = false,
    this.selectedTitle,
    this.attributes,
    super.key,
  });

  final List<NeedSearch> searchData;
  final bool enableMulti;
  final String searchHideText;
  final void Function(BuildContext context, ChatUIKitProfile profile)? onTap;
  final Widget Function(BuildContext context, ChatUIKitProfile profile,
      String? searchKeyword)? itemBuilder;

  final List<ChatUIKitProfile>? selected;
  final bool selectedCanChange;
  final String? selectedTitle;
  final String? attributes;

  @override
  State<SearchUsersView> createState() => _SearchUsersViewState();
}

class _SearchUsersViewState extends State<SearchUsersView> {
  ValueNotifier<List<ChatUIKitProfile>> selectedProfiles = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    if (widget.selected?.isNotEmpty == true && widget.selectedCanChange) {
      selectedProfiles.value = widget.selected!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget? content;
    if (widget.enableMulti) {
      content = ValueListenableBuilder(
        valueListenable: selectedProfiles,
        builder: (context, value, child) {
          return ChatUIKitSearchWidget(
            searchHideText: widget.searchHideText,
            list: widget.searchData,
            autoFocus: true,
            builder: (context, searchKeyword, list) {
              return ChatUIKitListView(
                list: list,
                type: list.isEmpty
                    ? ChatUIKitListViewType.empty
                    : ChatUIKitListViewType.normal,
                enableSearchBar: false,
                itemBuilder: (context, model) {
                  if (model is NeedSearch) {
                    return InkWell(
                      onTap: () {
                        tapContactInfo(model.profile);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 19.5, right: 15.5),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                widget.selected != null &&
                                        widget.selected!.any((element) =>
                                                element.id ==
                                                model.profile.id) ==
                                            true &&
                                        widget.selectedCanChange == false
                                    ? Icon(
                                        Icons.check_box,
                                        size: 28,
                                        color: theme.color.isDark
                                            ? theme.color.primaryColor6
                                            : theme.color.primaryColor5,
                                      )
                                    : value.contains(model.profile)
                                        ? Icon(
                                            Icons.check_box,
                                            size: 28,
                                            color: theme.color.isDark
                                                ? theme.color.primaryColor6
                                                : theme.color.primaryColor5,
                                          )
                                        : Icon(
                                            Icons.check_box_outline_blank,
                                            size: 28,
                                            color: theme.color.isDark
                                                ? theme.color.neutralColor4
                                                : theme.color.neutralColor7,
                                          ),
                                ChatUIKitSearchListViewItem(
                                  profile: model.profile,
                                ),
                              ],
                            ),
                            if (widget.selected?.any((element) =>
                                        element.id == model.profile.id) ==
                                    true &&
                                widget.selectedCanChange == false)
                              Opacity(
                                opacity: 0.6,
                                child: Container(
                                  color: theme.color.isDark
                                      ? theme.color.neutralColor1
                                      : theme.color.neutralColor98,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              );
            },
          );
        },
      );
    } else {
      content = ChatUIKitSearchWidget(
        searchHideText: widget.searchHideText,
        list: widget.searchData,
        autoFocus: true,
        builder: (context, searchKeyword, list) {
          return ChatUIKitListView(
            list: list,
            type: list.isEmpty
                ? ChatUIKitListViewType.empty
                : ChatUIKitListViewType.normal,
            enableSearchBar: false,
            itemBuilder: (context, model) {
              if (model is NeedSearch) {
                if (widget.itemBuilder != null) {
                  return widget.itemBuilder!
                      .call(context, model.profile, searchKeyword);
                }

                return InkWell(
                  onTap: () {
                    Navigator.of(context).pop(model.profile);
                  },
                  child: ChatUIKitSearchListViewItem(
                    profile: model.profile,
                    highlightWord: searchKeyword,
                  ),
                );
              }
              return const SizedBox();
            },
          );
        },
      );
    }

    content = NotificationListener(
      child: content,
      onNotification: (notification) {
        if (notification is SearchNotification) {
          if (!notification.isSearch) {
            if (widget.enableMulti) {
              List<ChatUIKitProfile> list = [];
              list.addAll(selectedProfiles.value);
              Navigator.of(context).pop(list);
            } else {
              Navigator.of(context).pop();
            }
          }
        }
        return false;
      },
    );

    content = Scaffold(
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      body: SafeArea(child: content),
    );

    return content;
  }

  void tapContactInfo(ChatUIKitProfile profile) {
    if (widget.selected
                ?.where((element) => element.id == profile.id)
                .isNotEmpty ==
            true &&
        widget.selectedCanChange == false) {
      return;
    }
    List<ChatUIKitProfile> list = selectedProfiles.value;
    if (list.contains(profile)) {
      list.remove(profile);
    } else {
      list.add(profile);
    }
    selectedProfiles.value = [...list];
  }
}
