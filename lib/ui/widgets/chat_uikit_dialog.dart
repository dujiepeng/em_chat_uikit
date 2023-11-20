import 'package:chat_uikit_theme/chat_uikit_theme.dart';
import 'package:flutter/material.dart';

Future<T> showChatUIKitDialog<T>({
  required BuildContext context,
  required List<ChatUIKitDialogItem<T>> items,
  String? content,
  String? title,
  List<String>? hiddenList,
  Color barrierColor = Colors.black54,
  bool barrierDismissible = true,
  ChatUIKitRectangleType borderType = ChatUIKitRectangleType.circular,
}) async {
  return await showDialog(
    barrierColor: barrierColor,
    barrierDismissible: barrierDismissible,
    context: context,
    builder: (context) {
      return ChatUIKitDialog(
        title: title,
        content: content,
        hiddenList: hiddenList,
        items: items,
        borderType: borderType,
      );
    },
  );
}

enum ChatUIKitRectangleType {
  circular,
  filletCorner,
  rightAngle,
}

enum ChatUIKitDialogItemType {
  confirm,
  cancel,
  destructive,
}

class ChatUIKitDialogItem<T> {
  ChatUIKitDialogItem.cancel({
    required this.label,
    this.style,
    this.onTap,
  }) : type = ChatUIKitDialogItemType.cancel;

  ChatUIKitDialogItem.confirm({
    required this.label,
    this.style,
    this.onTap,
  }) : type = ChatUIKitDialogItemType.confirm;

  ChatUIKitDialogItem.destructive({
    required this.label,
    this.style,
    this.onTap,
  }) : type = ChatUIKitDialogItemType.destructive;

  ChatUIKitDialogItem({
    required this.type,
    required this.label,
    this.style,
    this.onTap,
  });

  final ChatUIKitDialogItemType type;
  final String label;
  final TextStyle? style;
  final Future<T> Function()? onTap;
}

class ChatUIKitDialog<T> extends StatelessWidget {
  const ChatUIKitDialog({
    required this.items,
    this.title,
    this.content,
    this.titleStyle,
    this.contentStyle,
    this.hiddenList,
    this.borderType = ChatUIKitRectangleType.circular,
    super.key,
  });

  final String? title;
  final TextStyle? titleStyle;
  final String? content;
  final TextStyle? contentStyle;
  final List<ChatUIKitDialogItem> items;
  final ChatUIKitRectangleType borderType;
  final List<String>? hiddenList;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 50;
    return Dialog(
      clipBehavior: Clip.hardEdge,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(() {
          switch (borderType) {
            case ChatUIKitRectangleType.circular:
              return 16.0;
            case ChatUIKitRectangleType.filletCorner:
              return 8.0;
            case ChatUIKitRectangleType.rightAngle:
              return 0.0;
          }
        }()),
      ),
      child: SizedBox(
        width: width,
        child: _buildContent(context),
      ),
    );
  }

  _buildContent(BuildContext context) {
    Widget contentWidget = Container(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 16),
      color: (ChatUIKitTheme.of(context).color.isDark
          ? ChatUIKitTheme.of(context).color.neutralColor1
          : ChatUIKitTheme.of(context).color.neutralColor98),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title?.isNotEmpty == true)
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
              child: Text(
                title!,
                textAlign: TextAlign.center,
                style: this.titleStyle ??
                    TextStyle(
                      fontWeight:
                          ChatUIKitTheme.of(context).font.titleLarge.fontWeight,
                      fontSize:
                          ChatUIKitTheme.of(context).font.titleLarge.fontSize,
                      color: ChatUIKitTheme.of(context).color.isDark
                          ? ChatUIKitTheme.of(context).color.neutralColor98
                          : Colors.black,
                    ),
              ),
            ),
          if (content?.isNotEmpty == true)
            Container(
              padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
              child: Text(
                content!,
                textAlign: TextAlign.center,
                style: this.contentStyle ??
                    TextStyle(
                      fontWeight: ChatUIKitTheme.of(context)
                          .font
                          .labelMedium
                          .fontWeight,
                      fontSize:
                          ChatUIKitTheme.of(context).font.labelMedium.fontSize,
                      color: (ChatUIKitTheme.of(context).color.isDark
                          ? ChatUIKitTheme.of(context).color.neutralColor6
                          : ChatUIKitTheme.of(context).color.neutralColor5),
                    ),
              ),
            ),
          () {
            if (items.isEmpty) return Container();
            List<Widget> widgets = [];
            for (var item in items) {
              widgets.add(
                InkWell(
                  onTap: item.onTap,
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: () {
                        if (borderType == ChatUIKitRectangleType.circular) {
                          return BorderRadius.circular(24);
                        } else if (borderType ==
                            ChatUIKitRectangleType.filletCorner) {
                          return BorderRadius.circular(4);
                        } else if (borderType ==
                            ChatUIKitRectangleType.rightAngle) {
                          return BorderRadius.circular(0);
                        }
                      }(),
                      border: Border.all(
                        width: 1,
                        color: () {
                          if (item.type ==
                              ChatUIKitDialogItemType.destructive) {
                            return (ChatUIKitTheme.of(context).color.isDark
                                ? ChatUIKitTheme.of(context).color.errorColor6
                                : ChatUIKitTheme.of(context).color.errorColor5);
                          } else if (item.type ==
                              ChatUIKitDialogItemType.confirm) {
                            return (ChatUIKitTheme.of(context).color.isDark
                                ? ChatUIKitTheme.of(context).color.primaryColor6
                                : ChatUIKitTheme.of(context)
                                    .color
                                    .primaryColor5);
                          } else {
                            return (ChatUIKitTheme.of(context).color.isDark
                                ? ChatUIKitTheme.of(context).color.neutralColor4
                                : ChatUIKitTheme.of(context)
                                    .color
                                    .neutralColor7);
                          }
                        }(),
                      ),
                      color: () {
                        if (item.type == ChatUIKitDialogItemType.destructive) {
                          return (ChatUIKitTheme.of(context).color.isDark
                              ? ChatUIKitTheme.of(context).color.errorColor6
                              : ChatUIKitTheme.of(context).color.errorColor5);
                        } else if (item.type ==
                            ChatUIKitDialogItemType.confirm) {
                          return (ChatUIKitTheme.of(context).color.isDark
                              ? ChatUIKitTheme.of(context).color.primaryColor6
                              : ChatUIKitTheme.of(context).color.primaryColor5);
                        }
                      }(),
                    ),
                    child: Center(
                      child: Text(
                        item.label,
                        style: TextStyle(
                          fontSize: ChatUIKitTheme.of(context)
                              .font
                              .headlineSmall
                              .fontSize,
                          fontWeight: ChatUIKitTheme.of(context)
                              .font
                              .headlineSmall
                              .fontWeight,
                          color: () {
                            if (item.type ==
                                ChatUIKitDialogItemType.destructive) {
                              return (ChatUIKitTheme.of(context).color.isDark
                                  ? ChatUIKitTheme.of(context)
                                      .color
                                      .neutralColor98
                                  : ChatUIKitTheme.of(context)
                                      .color
                                      .neutralColor98);
                            } else if (item.type ==
                                ChatUIKitDialogItemType.confirm) {
                              return (ChatUIKitTheme.of(context).color.isDark
                                  ? ChatUIKitTheme.of(context)
                                      .color
                                      .neutralColor98
                                  : ChatUIKitTheme.of(context)
                                      .color
                                      .neutralColor98);
                            } else {
                              return ChatUIKitTheme.of(context).color.isDark
                                  ? ChatUIKitTheme.of(context)
                                      .color
                                      .neutralColor98
                                  : Colors.black;
                            }
                          }(),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
            if (items.length > 2) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(12, 20, 12, 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: () {
                    return widgets
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                            child: e,
                          ),
                        )
                        .toList();
                  }(),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: () {
                    return widgets
                        .map(
                          (e) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(6, 12, 6, 0),
                              child: e,
                            ),
                          ),
                        )
                        .toList();
                  }(),
                ),
              );
            }
          }()
        ],
      ),
    );

    contentWidget = ListView(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      children: [contentWidget],
    );
    contentWidget = Scrollbar(
      child: contentWidget,
    );
    return contentWidget;
  }
}
