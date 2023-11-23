import 'dart:math';

import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

typedef ListViewBuilder = Widget Function(
  BuildContext context,
  List<ChatUIKitListItemModel> list,
);

class AlphabeticalItemModel with ChatUIKitListItemModel {
  final String alphabetical;
  AlphabeticalItemModel(this.alphabetical) {
    height = 32;
    enableLongPress = false;
    enableTap = false;
  }
}

const double letterHeight = 16;
const double letterWidth = 16;

class ChatUIKitAlphabeticalItem extends StatelessWidget {
  const ChatUIKitAlphabeticalItem({
    required this.model,
    super.key,
  });

  final AlphabeticalItemModel model;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);

    return Container(
      padding: const EdgeInsets.only(left: 16, bottom: 6, top: 6),
      height: model.height,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(model.alphabetical,
            style: TextStyle(
              fontWeight: theme.font.titleSmall.fontWeight,
              fontSize: theme.font.titleSmall.fontSize,
              color: theme.color.isDark
                  ? theme.color.neutralColor6
                  : theme.color.neutralColor5,
            )),
      ),
    );
  }
}

class ChatUIKitAlphabeticalView extends StatefulWidget {
  const ChatUIKitAlphabeticalView({
    required this.list,
    required this.controller,
    required this.builder,
    this.enableSorting = true,
    this.special = '#',
    this.targets = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ#',
    this.rightPadding = 10,
    this.onTap,
    this.onTapCancel,
    this.highlight = true,
    super.key,
  });

  final String targets;
  final ScrollController controller;
  final String special;
  final ListViewBuilder builder;
  final bool enableSorting;
  final double rightPadding;
  final void Function(BuildContext context, String alphabetical)? onTap;
  final VoidCallback? onTapCancel;
  final bool highlight;

  final List<ChatUIKitListItemModel> list;

  @override
  State<ChatUIKitAlphabeticalView> createState() =>
      _ChatUIKitAlphabeticalViewState();
}

class _ChatUIKitAlphabeticalViewState extends State<ChatUIKitAlphabeticalView> {
  List<String> targets = [];
  String? latestSelected;
  ValueNotifier<int> selectIndex = ValueNotifier(-1);

  Map<String, double> positionMap = {};

  @override
  Widget build(BuildContext context) {
    if (!widget.enableSorting || widget.list.isEmpty) {
      return widget.builder.call(
        context,
        widget.list,
      );
    }

    List<ChatUIKitListItemModel> list = sortList();
    Widget content = widget.builder.call(
      context,
      list,
    );

    content = Stack(
      children: [
        content,
        Positioned(
          top: 0,
          bottom: 0,
          width: 30,
          right: widget.rightPadding,
          child: letterWidget(),
        ),
      ],
    );

    return content;
  }

  Widget letterWidget() {
    final theme = ChatUIKitTheme.of(context);
    List<Widget> letters = [];
    for (var i = 0; i < targets.length; i++) {
      final element = targets[i];
      letters.add(
        ValueListenableBuilder(
          valueListenable: selectIndex,
          builder: (context, value, child) {
            bool selected = false;
            if (widget.highlight) {
              selected = value == i;
            }

            Widget? content = Container(
              clipBehavior: Clip.hardEdge,
              width: letterWidth,
              height: letterHeight,
              decoration: BoxDecoration(
                color: selected
                    ? (theme.color.isDark
                        ? theme.color.primaryColor6
                        : theme.color.primaryColor5)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(letterHeight / 2),
              ),
              padding: const EdgeInsets.all(2),
              child: Center(
                child: Text(
                  element.toUpperCase(),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: selected
                        ? (theme.color.isDark
                            ? theme.color.neutralColor98
                            : theme.color.neutralColor98)
                        : (theme.color.isDark
                            ? theme.color.neutralColor6
                            : theme.color.neutralColor5),
                    fontSize: theme.font.labelExtraSmall.fontSize,
                    fontWeight: theme.font.labelExtraSmall.fontWeight,
                  ),
                ),
              ),
            );

            return content;
          },
        ),
      );
    }

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: letters,
    );

    // 设置最大响应宽度为100
    content = SizedBox(
      width: 100,
      child: content,
    );

    content = GestureDetector(
      child: content,
      onVerticalDragDown: (details) {
        onSelected(targets[getIndex(details.localPosition)]);
      },
      onVerticalDragUpdate: (details) {
        onSelected(targets[getIndex(details.localPosition)]);
      },
      onVerticalDragCancel: () {
        cancelSelected();
      },
      onLongPressUp: () {
        cancelSelected();
      },
      onLongPressStart: (details) {
        onSelected(targets[getIndex(details.localPosition)]);
      },
      onLongPressMoveUpdate: (details) {
        onSelected(targets[getIndex(details.localPosition)]);
      },
      onVerticalDragEnd: (details) {
        cancelSelected();
      },
    );

    content = Center(
      child: content,
    );

    return content;
  }

  int getIndex(Offset localPosition) {
    double y = localPosition.dy;
    int index = (y ~/ letterHeight).clamp(0, targets.length - 1);
    selectIndex.value = index;
    return index;
  }

  void onSelected(String str) {
    if (latestSelected == str) {
      return;
    }

    widget.onTap?.call(context, str);
    latestSelected = str;
    moveTo(str);
  }

  void cancelSelected() {
    latestSelected = null;
    selectIndex.value = -1;
    widget.onTapCancel?.call();
  }

  List<ChatUIKitListItemModel> sortList() {
    targets.clear();
    List<String> targetList = widget.targets.toLowerCase().split('');

    List<ChatUIKitListItemModel> ret = [];
    List<AlphabeticalProtocol> tmp = [];
    for (var item in widget.list) {
      if (item is AlphabeticalProtocol) {
        tmp.add(item as AlphabeticalProtocol);
      }
    }

    Map<String, List<AlphabeticalProtocol>> map = {};
    for (var letter in targetList) {
      map[letter] = [];
    }
    map[widget.special] = [];

    for (var item in tmp) {
      if (item.alphabetical.isEmpty) {
        map[widget.special]?.add(item);
      }
      String letter = item.alphabetical.substring(0, 1).toLowerCase();
      if (!targetList.contains(letter)) {
        map[widget.special]?.add(item);
      } else {
        map[letter]?.add(item);
      }
    }
    // 对序列内容排序
    for (var item in map.keys) {
      map[item]!.sort((a, b) => a.alphabetical.compareTo(b.alphabetical));
    }

    // 清空空序列
    map.removeWhere((key, value) => value.isEmpty);

    // 修改special位置，如果target中没有special，则把special在最后。
    if (!targetList.contains(widget.special)) {
      targetList.add(widget.special);
    }

    // 清空不存在的target
    targetList.removeWhere((element) => !map.containsKey(element));

    positionMap.clear();
    double position = 0;

    // 计算index 位置 转为最终序列
    for (var item in targetList) {
      positionMap[item] = position;
      final letterModel = AlphabeticalItemModel(item.toUpperCase());
      ret.add(letterModel);
      position += letterModel.height;
      List<AlphabeticalProtocol> list = map[item]!;
      for (var element in list) {
        final model = element as ChatUIKitListItemModel;
        ret.add(model);
        position += model.height;
      }

      targets.add(item);
    }

    return ret;
  }

  void moveTo(String alphabetical) {
    if (!positionMap.containsKey(alphabetical)) {
      return;
    }
    double position = positionMap[alphabetical]!;

    widget.controller.animateTo(
      min(position, widget.controller.position.maxScrollExtent),
      duration: const Duration(milliseconds: 100),
      curve: Curves.linear,
    );
  }
}
