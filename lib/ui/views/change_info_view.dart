import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class ChangeInfoView extends StatefulWidget {
  ChangeInfoView.arguments(ChangeInfoViewArguments arguments, {super.key})
      : title = arguments.title,
        hint = arguments.hint,
        inputTextCallback = arguments.inputTextCallback,
        saveButtonTitle = arguments.saveButtonTitle,
        maxLength = arguments.maxLength,
        appBar = arguments.appBar;

  const ChangeInfoView({
    this.title,
    this.hint,
    this.inputTextCallback,
    this.saveButtonTitle,
    this.maxLength = 128,
    this.appBar,
    super.key,
  });
  final String? title;
  final String? hint;
  final String? saveButtonTitle;
  final int maxLength;
  final ChatUIKitAppBar? appBar;
  final Future<String?> Function()? inputTextCallback;

  @override
  State<ChangeInfoView> createState() => _ChangeInfoViewState();
}

class _ChangeInfoViewState extends State<ChangeInfoView> {
  final TextEditingController controller = TextEditingController();

  String? originalStr;

  ValueNotifier<bool> isChanged = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      controller.text != originalStr
          ? isChanged.value = true
          : isChanged.value = false;
    });

    widget.inputTextCallback?.call().then((value) {
      originalStr = value ?? '';
      controller.text = value ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);

    Widget content = Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: theme.color.isDark
                ? theme.color.neutralColor3
                : theme.color.neutralColor95,
          ),
          child: TextField(
            keyboardAppearance: ChatUIKitTheme.of(context).color.isDark
                ? Brightness.dark
                : Brightness.light,
            maxLines: 4,
            minLines: 1,
            buildCounter: (
              context, {
              required int currentLength,
              required int? maxLength,
              required bool isFocused,
            }) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 13),
                child: Container(
                    alignment: Alignment.topRight,
                    child: Text(
                      "$currentLength/$maxLength",
                      style: TextStyle(
                          color: theme.color.isDark
                              ? theme.color.neutralColor5
                              : theme.color.neutralColor7),
                    )),
              );
            },
            maxLength: widget.maxLength,
            controller: controller,
            style: TextStyle(
              fontWeight: theme.font.titleMedium.fontWeight,
              fontSize: theme.font.titleMedium.fontSize,
              color: theme.color.isDark
                  ? theme.color.neutralColor98
                  : theme.color.neutralColor1,
            ),
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              hintText: widget.hint ?? '请输入',
              hintStyle: TextStyle(
                fontWeight: theme.font.titleMedium.fontWeight,
                fontSize: theme.font.titleMedium.fontSize,
                color: theme.color.isDark
                    ? theme.color.neutralColor5
                    : theme.color.neutralColor7,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
        Container(
          height: borderHeight,
          color: theme.color.isDark
              ? theme.color.neutralColor2
              : theme.color.neutralColor9,
          margin: const EdgeInsets.only(left: 16),
        )
      ],
    );

    content = SafeArea(child: content);

    content = Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: widget.appBar ??
          ChatUIKitAppBar(
            // title: widget.title,
            leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Text(
                widget.title ?? '',
                style: TextStyle(
                    fontWeight: theme.font.titleMedium.fontWeight,
                    fontSize: theme.font.titleMedium.fontSize,
                    color: theme.color.isDark
                        ? theme.color.neutralColor98
                        : theme.color.neutralColor1),
              ),
            ),
            centerTitle: false,
            trailing: Padding(
              padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
              child: ValueListenableBuilder(
                valueListenable: isChanged,
                builder: (context, value, child) {
                  return InkWell(
                    onTap: () {
                      if (value) {
                        Navigator.of(context).pop(controller.text);
                      }
                    },
                    child: Text(
                      widget.saveButtonTitle ?? '保存',
                      style: TextStyle(
                        fontWeight: theme.font.labelMedium.fontWeight,
                        fontSize: theme.font.labelMedium.fontSize,
                        color: value
                            ? (theme.color.isDark
                                ? theme.color.primaryColor6
                                : theme.color.primaryColor5)
                            : (theme.color.isDark
                                ? theme.color.neutralColor5
                                : theme.color.neutralColor6),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
      body: content,
    );

    return content;
  }
}
