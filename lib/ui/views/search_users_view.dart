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
        enableAppBar = arguments.enableAppBar,
        appBar = arguments.appBar,
        onTap = arguments.onTap,
        enableMulti = arguments.enableMulti,
        selected = arguments.selected,
        title = arguments.title,
        showBackButton = arguments.showBackButton,
        selectedTitle = arguments.selectedTitle,
        attributes = arguments.attributes;

  const SearchUsersView({
    required this.searchData,
    required this.searchHideText,
    this.itemBuilder,
    this.onTap,
    this.enableAppBar = false,
    this.enableMulti = false,
    this.appBar,
    this.selected,
    this.title,
    this.showBackButton = true,
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
  final ChatUIKitAppBar? appBar;
  final bool enableAppBar;
  final List<String>? selected;
  final String? title;
  final bool showBackButton;
  final String? selectedTitle;
  final String? attributes;

  @override
  State<SearchUsersView> createState() => _SearchUsersViewState();
}

class _SearchUsersViewState extends State<SearchUsersView> {
  ValueNotifier<List<ChatUIKitProfile>> selectedProfiles = ValueNotifier([]);

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
                  enableSearchBar: false,
                  itemBuilder: (context, model) {
                    if (model is NeedSearch) {
                      return InkWell(
                        onTap: () {
                          tapContactInfo(model.profile);
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 19.5, right: 15.5),
                          child: Stack(
                            children: [
                              Row(
                                children: [
                                  widget.selected?.contains(model.profile.id) ==
                                          true
                                      ? Icon(
                                          Icons.check_box,
                                          size: 21,
                                          color: theme.color.isDark
                                              ? theme.color.primaryColor6
                                              : theme.color.primaryColor5,
                                        )
                                      : value.contains(model.profile)
                                          ? Icon(
                                              Icons.check_box,
                                              size: 21,
                                              color: theme.color.isDark
                                                  ? theme.color.primaryColor6
                                                  : theme.color.primaryColor5,
                                            )
                                          : Icon(
                                              Icons.check_box_outline_blank,
                                              size: 21,
                                              color: theme.color.isDark
                                                  ? theme.color.neutralColor4
                                                  : theme.color.neutralColor7,
                                            ),
                                  ChatUIKitSearchListViewItem(
                                      profile: model.profile),
                                ],
                              ),
                              if (widget.selected?.contains(model.profile.id) ==
                                  true)
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
                  list: list,
                  type: list.isEmpty
                      ? ChatUIKitListViewType.empty
                      : ChatUIKitListViewType.normal);
            },
          );
        },
      );
    }

    content = ChatUIKitSearchWidget(
      searchHideText: widget.searchHideText,
      list: widget.searchData,
      autoFocus: true,
      builder: (context, searchKeyword, list) {
        return ChatUIKitListView(
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
            list: list,
            type: list.isEmpty
                ? ChatUIKitListViewType.empty
                : ChatUIKitListViewType.normal);
      },
    );

    content = NotificationListener(
      child: content,
      onNotification: (notification) {
        if (notification is SearchNotification) {
          if (!notification.isSearch) {
            Navigator.of(context).pop();
          }
        }
        return false;
      },
    );

    content = Scaffold(
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: !widget.enableAppBar
          ? null
          : widget.appBar ??
              ChatUIKitAppBar(
                showBackButton: widget.showBackButton,
                title: widget.title,
                trailing: widget.enableMulti
                    ? InkWell(
                        onTap: () {
                          if (selectedProfiles.value.isEmpty) {
                            return;
                          }
                          Navigator.of(context).pop(selectedProfiles.value);
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 5, 24, 5),
                          child: ValueListenableBuilder(
                            valueListenable: selectedProfiles,
                            builder: (context, value, child) {
                              return Text(
                                value.isEmpty
                                    ? widget.selectedTitle ?? ''
                                    : '${widget.selectedTitle ?? ''}(${value.length})',
                                textScaleFactor: 1.0,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: theme.color.isDark
                                      ? theme.color.primaryColor6
                                      : theme.color.primaryColor5,
                                  fontWeight: theme.font.labelMedium.fontWeight,
                                  fontSize: theme.font.labelMedium.fontSize,
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
      body: SafeArea(child: content),
    );

    return content;
  }

  void tapContactInfo(ChatUIKitProfile profile) {
    List<ChatUIKitProfile> list = selectedProfiles.value;
    if (list.contains(profile)) {
      list.remove(profile);
    } else {
      list.add(profile);
    }
    selectedProfiles.value = [...list];
  }
}
