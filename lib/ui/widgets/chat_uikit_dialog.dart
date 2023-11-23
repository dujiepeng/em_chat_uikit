import 'package:chat_uikit_theme/chat_uikit_theme.dart';
import 'package:flutter/material.dart';

const double defaultLeftRightPadding = 14;
Future<T?> showChatUIKitDialog<T>({
  required BuildContext context,
  required List<ChatUIKitDialogItem<T>> items,
  String? content,
  String? title,
  List<String>? hintsText,
  TextStyle? hiddenStyle,
  double? leftRightPadding,
  Color barrierColor = Colors.black54,
  bool barrierDismissible = true,
  ChatUIKitRectangleType borderType = ChatUIKitRectangleType.circular,
}) async {
  return showDialog(
    barrierColor: barrierColor,
    barrierDismissible: barrierDismissible,
    context: context,
    builder: (context) {
      return ChatUIKitDialog(
        title: title,
        content: content,
        hintsText: hintsText,
        leftRightPadding: leftRightPadding ?? defaultLeftRightPadding,
        hiddenStyle: hiddenStyle,
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
  })  : type = ChatUIKitDialogItemType.cancel,
        onInputsTap = null;

  ChatUIKitDialogItem.confirm({
    required this.label,
    this.style,
    this.onTap,
  })  : type = ChatUIKitDialogItemType.confirm,
        onInputsTap = null;

  ChatUIKitDialogItem.inputsConfirm({
    required this.label,
    this.style,
    this.onInputsTap,
  })  : type = ChatUIKitDialogItemType.confirm,
        onTap = null;

  ChatUIKitDialogItem.destructive({
    required this.label,
    this.style,
    this.onTap,
  })  : type = ChatUIKitDialogItemType.destructive,
        onInputsTap = null;

  ChatUIKitDialogItem({
    required this.type,
    required this.label,
    this.style,
    this.onTap,
    this.onInputsTap,
  });

  final ChatUIKitDialogItemType type;
  final String label;
  final TextStyle? style;
  final Future<T?> Function()? onTap;
  final Future<T?> Function(List<String> inputs)? onInputsTap;
}

class ChatUIKitDialog<T> extends StatefulWidget {
  const ChatUIKitDialog({
    required this.items,
    this.title,
    this.content,
    this.titleStyle,
    this.contentStyle,
    this.hintsText,
    this.hiddenStyle,
    this.leftRightPadding = defaultLeftRightPadding,
    this.borderType = ChatUIKitRectangleType.circular,
    super.key,
  });

  final String? title;
  final TextStyle? titleStyle;
  final String? content;
  final TextStyle? contentStyle;
  final List<ChatUIKitDialogItem<T>> items;
  final ChatUIKitRectangleType borderType;
  final List<String>? hintsText;
  final double leftRightPadding;

  final TextStyle? hiddenStyle;

  @override
  State<ChatUIKitDialog> createState() => _ChatUIKitDialogState();
}

class _ChatUIKitDialogState extends State<ChatUIKitDialog> {
  final List<TextEditingController> _controllers = [];
  @override
  void initState() {
    super.initState();
    widget.hintsText?.forEach((element) {
      _controllers.add(TextEditingController());
    });
  }

  @override
  void dispose() {
    for (var element in _controllers) {
      element.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 50;
    return Dialog(
      clipBehavior: Clip.hardEdge,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(() {
          switch (widget.borderType) {
            case ChatUIKitRectangleType.circular:
              return 20.0;
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
          if (widget.title?.isNotEmpty == true)
            Padding(
              padding: EdgeInsets.only(
                  top: 12,
                  left: widget.leftRightPadding,
                  right: widget.leftRightPadding),
              child: Text(
                widget.title!,
                textAlign: TextAlign.center,
                style: widget.titleStyle ??
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
          if (widget.content?.isNotEmpty == true)
            Container(
              padding: EdgeInsets.only(
                  top: 12,
                  left: widget.leftRightPadding,
                  right: widget.leftRightPadding),
              child: Text(
                widget.content!,
                textAlign: TextAlign.center,
                style: widget.contentStyle ??
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
          if (widget.hintsText?.isNotEmpty == true)
            () {
              List<Widget> list = [];
              for (var i = 0; i < widget.hintsText!.length; i++) {
                list.add(
                  Container(
                    margin: EdgeInsets.only(
                        top: 12,
                        left: widget.leftRightPadding,
                        right: widget.leftRightPadding),
                    decoration: BoxDecoration(
                      borderRadius: () {
                        if (widget.borderType ==
                            ChatUIKitRectangleType.circular) {
                          return BorderRadius.circular(24);
                        } else if (widget.borderType ==
                            ChatUIKitRectangleType.filletCorner) {
                          return BorderRadius.circular(4);
                        } else if (widget.borderType ==
                            ChatUIKitRectangleType.rightAngle) {
                          return BorderRadius.circular(0);
                        }
                      }(),
                      color: () {
                        return (ChatUIKitTheme.of(context).color.isDark
                            ? ChatUIKitTheme.of(context).color.neutralColor2
                            : ChatUIKitTheme.of(context).color.neutralColor95);
                      }(),
                    ),
                    height: 48,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      child: TextField(
                        style: TextStyle(
                            fontWeight: ChatUIKitTheme.of(context)
                                .font
                                .bodyLarge
                                .fontWeight,
                            fontSize: ChatUIKitTheme.of(context)
                                .font
                                .bodyLarge
                                .fontSize,
                            color: ChatUIKitTheme.of(context).color.isDark
                                ? Colors.white
                                : Colors.black),
                        controller: _controllers[i],
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              fontWeight: ChatUIKitTheme.of(context)
                                  .font
                                  .bodyLarge
                                  .fontWeight,
                              fontSize: ChatUIKitTheme.of(context)
                                  .font
                                  .bodyLarge
                                  .fontSize,
                              color: ChatUIKitTheme.of(context).color.isDark
                                  ? ChatUIKitTheme.of(context)
                                      .color
                                      .neutralColor4
                                  : ChatUIKitTheme.of(context)
                                      .color
                                      .neutralColor6),
                          hintText: widget.hintsText![i],
                        ),
                      ),
                    ),
                  ),
                );
              }
              return Column(
                children: list,
              );
            }(),
          () {
            if (widget.items.isEmpty) return Container();
            List<Widget> widgets = [];
            for (var item in widget.items) {
              widgets.add(
                InkWell(
                  onTap: () {
                    if (item.onInputsTap != null) {
                      List<String> inputs = [];
                      for (var controller in _controllers) {
                        inputs.add(controller.text);
                      }
                      item.onInputsTap?.call(inputs);
                    } else {
                      item.onTap?.call();
                    }
                  },
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: () {
                        if (widget.borderType ==
                            ChatUIKitRectangleType.circular) {
                          return BorderRadius.circular(24);
                        } else if (widget.borderType ==
                            ChatUIKitRectangleType.filletCorner) {
                          return BorderRadius.circular(4);
                        } else if (widget.borderType ==
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
            if (widget.items.length > 2) {
              return Padding(
                padding: EdgeInsets.fromLTRB(
                  widget.leftRightPadding,
                  10,
                  widget.leftRightPadding,
                  8,
                ),
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
