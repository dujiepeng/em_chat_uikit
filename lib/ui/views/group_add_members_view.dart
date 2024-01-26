import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class GroupAddMembersView extends StatefulWidget {
  GroupAddMembersView.arguments(GroupAddMembersViewArguments arguments,
      {super.key})
      : listViewItemBuilder = arguments.listViewItemBuilder,
        onSearchTap = arguments.onSearchTap,
        fakeSearchHideText = arguments.fakeSearchHideText,
        listViewBackground = arguments.listViewBackground,
        onTap = arguments.onTap,
        onLongPress = arguments.onLongPress,
        appBar = arguments.appBar,
        controller = arguments.controller,
        groupId = arguments.groupId,
        enableAppBar = arguments.enableAppBar,
        inGroupMembers = arguments.inGroupMembers,
        attributes = arguments.attributes;

  const GroupAddMembersView({
    required this.groupId,
    this.listViewItemBuilder,
    this.onSearchTap,
    this.fakeSearchHideText,
    this.listViewBackground,
    this.onTap,
    this.onLongPress,
    this.appBar,
    this.controller,
    this.inGroupMembers,
    this.enableAppBar = true,
    this.attributes,
    super.key,
  });

  final String groupId;
  final ContactListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final void Function(List<ContactItemModel> data)? onSearchTap;
  final List<String>? inGroupMembers;
  final ChatUIKitContactItemBuilder? listViewItemBuilder;
  final void Function(BuildContext context, ContactItemModel model)? onTap;
  final void Function(BuildContext context, ContactItemModel model)?
      onLongPress;
  final String? fakeSearchHideText;
  final Widget? listViewBackground;
  final bool enableAppBar;
  final String? attributes;

  @override
  State<GroupAddMembersView> createState() => _GroupAddMembersViewState();
}

class _GroupAddMembersViewState extends State<GroupAddMembersView> {
  ValueNotifier<ChatUIKitProfile>? selectedProfile;
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
      appBar: !widget.enableAppBar
          ? null
          : widget.appBar ??
              ChatUIKitAppBar(
                showBackButton: true,
                leading: InkWell(
                  onTap: () {
                    Navigator.maybePop(context);
                  },
                  child: Text(
                    ChatUIKitLocal.groupAddMembersViewTitle.getString(context),
                    textScaleFactor: 1.0,
                    overflow: TextOverflow.ellipsis,
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
                          value.isEmpty
                              ? ChatUIKitLocal.groupAddMembersViewAdd
                                  .getString(context)
                              : '${ChatUIKitLocal.groupAddMembersViewAdd.getString(context)}(${value.length})',
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
                      if (widget.inGroupMembers?.contains(model.profile.id) !=
                          true) {
                        tapContactInfo(model.profile);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 19.5, right: 15.5),
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              widget.inGroupMembers
                                          ?.contains(model.profile.id) ==
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
                              ChatUIKitContactListViewItem(model),
                            ],
                          ),
                          if (widget.inGroupMembers
                                  ?.contains(model.profile.id) ==
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
            return SearchUsersView(
              searchData: list,
              itemBuilder: (context, profile, searchKeyword) {
                return InkWell(
                  onTap: () {
                    tapContactInfo(profile);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 19.5, right: 15.5),
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            widget.inGroupMembers?.contains(profile.id) == true
                                ? Icon(
                                    Icons.check_box,
                                    size: 21,
                                    color: theme.color.isDark
                                        ? theme.color.primaryColor6
                                        : theme.color.primaryColor5,
                                  )
                                : value.contains(profile)
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
                            ChatUIKitSearchListViewItem(profile: profile),
                          ],
                        ),
                        if (widget.inGroupMembers?.contains(profile.id) == true)
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
              },
              searchHideText: ChatUIKitLocal.groupAddMembersViewSearchContact
                  .getString(context),
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
