import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class NewRequestView extends StatefulWidget {
 

  NewRequestView.arguments(NewRequestViewArguments argument, {super.key})
      : controller = argument.controller,
        appBar = argument.appBar,
        onSearchTap = argument.onSearchTap,
        listViewItemBuilder = argument.listViewItemBuilder,
        onTap = argument.onTap,
        onLongPress = argument.onLongPress,
        fakeSearchHideText = argument.fakeSearchHideText,
        listViewBackground = argument.listViewBackground,
        loadErrorMessage = argument.loadErrorMessage;

  const NewRequestView({
    this.controller,
    this.appBar,
    this.onSearchTap,
    this.listViewItemBuilder,
    this.onTap,
    this.onLongPress,
    this.fakeSearchHideText,
    this.listViewBackground,
    this.loadErrorMessage,
    super.key,
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

  @override
  State<NewRequestView> createState() => _NewRequestViewState();
}

class _NewRequestViewState extends State<NewRequestView> {
  late final NewRequestListViewController controller;
  int? joinedCount;
  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? NewRequestListViewController();
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
              autoBackButton: true,
              leading: InkWell(
                onTap: () {
                  Navigator.maybePop(context);
                },
                child: Text(
                  '新请求',
                  style: TextStyle(
                    color: theme.color.isDark
                        ? theme.color.neutralColor98
                        : theme.color.neutralColor1,
                    fontWeight: theme.font.titleMedium.fontWeight,
                    fontSize: theme.font.titleMedium.fontSize,
                  ),
                ),
              ),
            ),
        body: SafeArea(
          child: NewRequestsListView(
            controller: controller,
            itemBuilder: widget.listViewItemBuilder,
            searchHideText: widget.fakeSearchHideText,
            background: widget.listViewBackground,
            errorMessage: widget.loadErrorMessage,
            onTap: widget.onTap ?? onItemTap,
            onLongPress: widget.onLongPress,
          ),
        ));

    return content;
  }

  void onItemTap(BuildContext context, NewRequestItemModel model) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return NewRequestDetailsView(
            profile: model.profile,
          );
        },
      ),
    ).then((value) {
      if (value == true) {
        controller.refresh();
      }
    });
  }
}
