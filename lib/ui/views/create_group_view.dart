import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class CreateGroupView extends StatefulWidget {
  CreateGroupView.arguments(
    CreateGroupViewArguments arguments, {
    super.key,
  })  : listViewItemBuilder = arguments.listViewItemBuilder,
        onSearchTap = arguments.onSearchTap,
        fakeSearchHideText = arguments.fakeSearchHideText,
        listViewBackground = arguments.listViewBackground,
        onItemTap = arguments.onItemTap,
        onItemLongPress = arguments.onItemLongPress,
        appBar = arguments.appBar,
        controller = arguments.controller;

  const CreateGroupView({
    this.listViewItemBuilder,
    this.onSearchTap,
    this.fakeSearchHideText,
    this.listViewBackground,
    this.onItemTap,
    this.onItemLongPress,
    this.appBar,
    this.controller,
    super.key,
  });

  final ContactListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final void Function(List<ContactItemModel> data)? onSearchTap;

  final ChatUIKitContactItemBuilder? listViewItemBuilder;
  final void Function(ContactItemModel model)? onItemTap;
  final void Function(ContactItemModel model)? onItemLongPress;
  final String? fakeSearchHideText;
  final Widget? listViewBackground;

  @override
  State<CreateGroupView> createState() => _CreateGroupViewState();
}

class _CreateGroupViewState extends State<CreateGroupView> {
  late final ContactListViewController controller;
  final ValueNotifier<List<ChatUIKitProfile>> selectedProfiles =
      ValueNotifier<List<ChatUIKitProfile>>([]);

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? ContactListViewController();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget content = Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: widget.appBar ??
          ChatUIKitAppBar(
            showBackButton: true,
            leading: InkWell(
              onTap: () {
                Navigator.maybePop(context);
              },
              child: Text(
                '新群组',
                style: TextStyle(
                  color: theme.color.isDark
                      ? theme.color.neutralColor98
                      : theme.color.neutralColor1,
                  fontWeight: theme.font.titleMedium.fontWeight,
                  fontSize: theme.font.titleMedium.fontSize,
                ),
              ),
            ),
            trailing: InkWell(
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
                      value.isEmpty ? '创建' : '创建(${value.length})',
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
            ),
          ),
      body: ValueListenableBuilder(
        valueListenable: selectedProfiles,
        builder: (context, value, child) {
          return ContactListView(
            controller: controller,
            itemBuilder: widget.listViewItemBuilder ??
                (context, model) {
                  return InkWell(
                    onTap: () {
                      tapContactInfo(model.profile);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 19.5, right: 15.5),
                      child: Row(
                        children: [
                          value.contains(model.profile)
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
                          ChatUIKitContactListViewItem(model)
                        ],
                      ),
                    ),
                  );
                },
            searchHideText: widget.fakeSearchHideText,
            background: widget.listViewBackground,
            onSearchTap: widget.onSearchTap ?? onSearchTap,
          );
        },
      ),
    );

    return content;
  }

  void onSearchTap(List<ContactItemModel> data) async {
    List<NeedSearch> list = [];
    for (var item in data) {
      list.add(item);
    }
    final theme = ChatUIKitTheme.of(context);
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return ValueListenableBuilder(
          valueListenable: selectedProfiles,
          builder: (context, value, child) {
            return SearchContactsView(
              itemBuilder: (context, profile, searchKeyword) {
                return InkWell(
                  onTap: () {
                    tapContactInfo(profile);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 19.5, right: 15.5),
                    child: Row(
                      children: [
                        value.contains(profile)
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
                          profile: profile,
                          highlightWord: searchKeyword,
                        ),
                      ],
                    ),
                  ),
                );
              },
              searchHideText: '搜索联系人',
              searchData: list,
            );
          },
        );
      },
    ).then((value) {});
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
