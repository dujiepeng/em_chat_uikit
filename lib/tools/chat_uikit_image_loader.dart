import 'package:flutter/material.dart';

const String packageName = 'em_chat_uikit';

class ChatUIKitImageLoader {
  static Widget chatIcon({double size = 24, Color? color}) {
    return Image.asset(
      'assets/images/chat.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget bubbleVoice(int frame, {double size = 20, Color? color}) {
    return Image.asset(
      'assets/images/voice_$frame.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget emoji(String imageName, {double size = 36}) {
    String name = imageName.substring(0, imageName.length);
    return Image.asset(
      'assets/images/emojis/$name.png',
      package: packageName,
      width: size,
      height: size,
    );
  }

  static Widget file({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/file_icon.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget search({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/search.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget listEmpty({double size = 105, Color? color}) {
    return Image.asset(
      'assets/images/list_empty.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget conversationTitle({Color? color}) {
    return Image.asset(
      'assets/images/chat.png',
      package: packageName,
      width: 60,
      height: 30,
      color: color,
    );
  }

  static Widget noDisturb({double size = 20, Color? color}) {
    return Image.asset(
      'assets/images/no_disturb.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget defaultAvatar({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/avatar.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget emojiDelete({double size = 30, Color? color}) {
    return Icon(Icons.arrow_left, size: size, color: color);
  }

  static Widget textKeyboard({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/input_bar_keyboard.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget voiceKeyboard({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/input_bar_voice.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget moreKeyboard({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/input_bar_more.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget faceKeyboard({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/input_bar_face.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget sendKeyboard({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/input_bar_send.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget networkImage({
    String? image,
    Widget? placeholderWidget,
    double? size,
    BoxFit fit = BoxFit.fill,
  }) {
    if (image == null) {
      return placeholderWidget ?? Container();
    }

    return FadeInImage(
      width: size,
      height: size,
      placeholder: const NetworkImage(''),
      placeholderFit: fit,
      placeholderErrorBuilder: (context, error, stackTrace) {
        return placeholderWidget ?? Container();
      },
      image: NetworkImage(image),
      fit: fit,
      imageErrorBuilder: (context, error, stackTrace) {
        return placeholderWidget ?? Container();
      },
    );
  }
}
