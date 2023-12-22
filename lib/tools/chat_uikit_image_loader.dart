import 'package:flutter/material.dart';

const String packageName = 'em_chat_uikit';

class ChatUIKitImageLoader {
  static Widget chatIcon({double size = 24, Color? color}) {
    return Image(
      gaplessPlayback: true,
      image: ResizeImage(
        const AssetImage('assets/images/chat.png', package: packageName),
        width: size.toInt(),
        height: size.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget bubbleVoice(int frame, {double size = 20, Color? color}) {
    return Image(
      gaplessPlayback: true,
      image: ResizeImage(
        AssetImage('assets/images/voice_$frame.png', package: packageName),
        width: size.toInt(),
        height: size.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget emoji(String imageName, {double size = 36}) {
    String name = imageName.substring(0, imageName.length);
    return Image(
      gaplessPlayback: true,
      image: ResizeImage(
        AssetImage('assets/images/emojis/$name.png', package: packageName),
        width: size.toInt(),
        height: size.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget file({double size = 30, Color? color}) {
    return Image(
      gaplessPlayback: true,
      image: ResizeImage(
        const AssetImage('assets/images/file_icon.png', package: packageName),
        width: size.toInt(),
        height: size.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget search({double size = 30, Color? color}) {
    return Image(
      gaplessPlayback: true,
      image: ResizeImage(
        const AssetImage('assets/images/search.png', package: packageName),
        width: size.toInt(),
        height: size.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget listEmpty({double size = 105, Color? color}) {
    return Image(
      gaplessPlayback: true,
      image: ResizeImage(
        const AssetImage('assets/images/list_empty.png', package: packageName),
        width: size.toInt(),
        height: size.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  // static Widget conversationTitle({Color? color}) {
  //   return const Image(
  //     gaplessPlayback: true,
  //     image: ResizeImage(
  //       AssetImage('assets/images/chat.png', package: packageName),
  //       width: 60,
  //       height: 30,
  //     ),
  //     fit: BoxFit.fill,
  //   );
  // }

  static Widget noDisturb({double size = 20, Color? color}) {
    return Image(
      gaplessPlayback: true,
      image: ResizeImage(
        const AssetImage('assets/images/no_disturb.png', package: packageName),
        width: size.toInt(),
        height: size.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget defaultAvatar({double size = 30, Color? color}) {
    return Image(
      gaplessPlayback: true,
      image: ResizeImage(
        const AssetImage('assets/images/avatar.png', package: packageName),
        width: size.toInt(),
        height: size.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget emojiDelete({double size = 30, Color? color}) {
    return Icon(Icons.arrow_left, size: size, color: color);
  }

  static Widget textKeyboard({double size = 30, Color? color}) {
    return Image(
      gaplessPlayback: true,
      image: ResizeImage(
        const AssetImage('assets/images/input_bar_keyboard.png',
            package: packageName),
        width: size.toInt(),
        height: size.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget voiceKeyboard({double size = 30, Color? color}) {
    return Image(
      gaplessPlayback: true,
      image: ResizeImage(
        const AssetImage('assets/images/input_bar_voice.png',
            package: packageName),
        width: size.toInt(),
        height: size.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget messageEdit({double size = 16, Color? color}) {
    return Image(
      gaplessPlayback: true,
      image: ResizeImage(
        const AssetImage('assets/images/edit_bar.png', package: packageName),
        width: size.toInt(),
        height: size.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget moreKeyboard({double size = 30, Color? color}) {
    return Image(
      gaplessPlayback: true,
      image: ResizeImage(
        const AssetImage('assets/images/input_bar_more.png',
            package: packageName),
        width: size.toInt(),
        height: size.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget faceKeyboard({double size = 30, Color? color}) {
    return Image(
      gaplessPlayback: true,
      image: ResizeImage(
        const AssetImage('assets/images/input_bar_face.png',
            package: packageName),
        width: size.toInt(),
        height: size.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget sendKeyboard({double size = 30, Color? color}) {
    return Image(
      gaplessPlayback: true,
      image: ResizeImage(
        const AssetImage('assets/images/input_bar_send.png',
            package: packageName),
        width: size.toInt(),
        height: size.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget voiceDelete({double size = 20, Color? color}) {
    return Image(
      gaplessPlayback: true,
      image: ResizeImage(
        const AssetImage('assets/images/record_delete.png',
            package: packageName),
        width: size.toInt(),
        height: size.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget voiceSend({double size = 20, Color? color}) {
    return Image(
      gaplessPlayback: true,
      image: ResizeImage(
        const AssetImage('assets/images/record_send.png', package: packageName),
        width: size.toInt(),
        height: size.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget voiceMic({double size = 20, Color? color}) {
    return Image(
      gaplessPlayback: true,
      image: ResizeImage(
        const AssetImage('assets/images/record_mic.png', package: packageName),
        width: size.toInt(),
        height: size.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget imageDefault({double size = 44, Color? color}) {
    return Image(
      gaplessPlayback: true,
      image: ResizeImage(
        const AssetImage('assets/images/image_default.png',
            package: packageName),
        width: size.toInt(),
        height: size.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget videoDefault({double size = 44, Color? color}) {
    return Image(
      gaplessPlayback: true,
      image: ResizeImage(
        const AssetImage('assets/images/video_default.png',
            package: packageName),
        width: size.toInt(),
        height: size.toInt(),
      ),
      fit: BoxFit.fill,
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
