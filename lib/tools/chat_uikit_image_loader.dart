import 'package:flutter/material.dart';

const String packageName = 'em_chat_uikit';

class ChatUIKitImageLoader {
  static Widget chatIcon(
      {double width = 24, double height = 24, Color? color}) {
    return Image(
      gaplessPlayback: true,
      color: color,
      image: ResizeImage(
        const AssetImage('assets/images/chat.png', package: packageName),
        width: width.toInt(),
        height: height.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget bubbleVoice(int frame,
      {double width = 20, double height = 20, Color? color}) {
    return Image(
      gaplessPlayback: true,
      color: color,
      image: ResizeImage(
        AssetImage('assets/images/voice_$frame.png', package: packageName),
        width: width.toInt(),
        height: height.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget emoji(String imageName, {double width = 36, height = 36}) {
    String name = imageName.substring(0, imageName.length);
    return Image(
      gaplessPlayback: true,
      image: ResizeImage(
        AssetImage('assets/images/emojis/$name.png', package: packageName),
        width: width.toInt(),
        height: height.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget file({double width = 30, double height = 30, Color? color}) {
    return Image(
      gaplessPlayback: true,
      color: color,
      image: ResizeImage(
        const AssetImage('assets/images/file_icon.png', package: packageName),
        width: width.toInt(),
        height: height.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget search({double width = 30, double height = 30, Color? color}) {
    return Image(
      width: width,
      height: height,
      color: color,
      image: const AssetImage(
        'assets/images/search.png',
        package: packageName,
      ),
      fit: BoxFit.fill,
    );
    // return Image(
    //   gaplessPlayback: true,
    //   color: color,
    //   image: ResizeImage(
    //     const AssetImage('assets/images/search.png', package: packageName),
    //     width: width.toInt(),
    //     height: height.toInt(),
    //   ),
    //   fit: BoxFit.fill,
    // );
  }

  static Widget listEmpty(
      {double width = 105, double height = 105, Color? color}) {
    return Image(
      gaplessPlayback: true,
      color: color,
      image: ResizeImage(
        const AssetImage('assets/images/list_empty.png', package: packageName),
        width: width.toInt(),
        height: height.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  // static Widget conversationTitle({double height = 24, Color? color}) {
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

  static Widget noDisturb(
      {double width = 20, double height = 20, Color? color}) {
    return Image(
      gaplessPlayback: true,
      color: color,
      image: ResizeImage(
        const AssetImage('assets/images/no_disturb.png', package: packageName),
        width: width.toInt(),
        height: height.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget defaultAvatar(
      {double width = 30, double height = 30, Color? color}) {
    return Image(
      gaplessPlayback: true,
      color: color,
      image: ResizeImage(
        const AssetImage('assets/images/avatar.png', package: packageName),
        width: width.toInt(),
        height: height.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget emojiDelete({double size = 20, Color? color}) {
    return Icon(
      Icons.arrow_back,
      size: size,
      color: color,
      weight: 3,
    );
  }

  static Widget textKeyboard(
      {double width = 30, double height = 30, Color? color}) {
    // return Image(
    //   filterQuality: FilterQuality.high,
    //   gaplessPlayback: true,
    //   image: ResizeImage(
    //     const AssetImage('assets/images/input_bar_keyboard.png',
    //         package: packageName),
    //     width: width.toInt(),
    //     height: height.toInt(),
    //   ),
    //   fit: BoxFit.fill,
    // );

    return Image(
      width: width,
      height: height,
      color: color,
      image: const AssetImage(
        'assets/images/input_bar_keyboard.png',
        package: packageName,
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget voiceKeyboard(
      {double width = 30, double height = 30, Color? color}) {
    // return Image(
    //   gaplessPlayback: true,
    //   image: ResizeImage(
    //     const AssetImage('assets/images/input_bar_voice.png',
    //         package: packageName),
    //     width: width.toInt(),
    //     height: height.toInt(),
    //   ),
    //   fit: BoxFit.fill,
    // );

    return Image(
      color: color,
      width: width,
      height: height,
      image: const AssetImage(
        'assets/images/input_bar_voice.png',
        package: packageName,
      ),
      // fit: BoxFit.fill,
    );
  }

  static Widget messageEdit(
      {double width = 16, double height = 16, Color? color}) {
    return Image(
      color: color,
      gaplessPlayback: true,
      image: ResizeImage(
        const AssetImage('assets/images/edit_bar.png', package: packageName),
        width: width.toInt(),
        height: height.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget moreKeyboard(
      {double width = 30, double height = 30, Color? color}) {
    // return Image(
    //   gaplessPlayback: true,
    //   image: ResizeImage(
    //     const AssetImage('assets/images/input_bar_more.png',
    //         package: packageName),
    //     width: width.toInt(),
    //     height: height.toInt(),
    //   ),
    //   fit: BoxFit.fill,
    // );
    return Image(
      color: color,
      width: width,
      height: height,
      gaplessPlayback: true,
      image: const AssetImage('assets/images/input_bar_more.png',
          package: packageName),
      // fit: BoxFit.fill,
    );
  }

  static Widget faceKeyboard(
      {double width = 30, double height = 30, Color? color}) {
    // return Image(
    //   gaplessPlayback: true,
    //   image: ResizeImage(
    //     const AssetImage('assets/images/input_bar_face.png',
    //         package: packageName),
    //     width: width.toInt(),
    //     height: height.toInt(),
    //   ),
    //   fit: BoxFit.fill,
    // );
    return Image(
      color: color,
      width: width,
      height: height,
      gaplessPlayback: true,
      image: const AssetImage('assets/images/input_bar_face.png',
          package: packageName),
      // fit: BoxFit.fill,
    );
  }

  static Widget sendKeyboard(
      {double width = 30, double height = 30, Color? color}) {
    return Image(
      color: color,
      gaplessPlayback: true,
      image: ResizeImage(
        const AssetImage('assets/images/input_bar_send.png',
            package: packageName),
        width: width.toInt(),
        height: height.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget voiceDelete(
      {double width = 20, double height = 20, Color? color}) {
    return Image(
      color: color,
      gaplessPlayback: true,
      image: ResizeImage(
        const AssetImage('assets/images/record_delete.png',
            package: packageName),
        width: width.toInt(),
        height: height.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget voiceSend(
      {double width = 20, double height = 20, Color? color}) {
    return Image(
      color: color,
      gaplessPlayback: true,
      image: ResizeImage(
        const AssetImage('assets/images/record_send.png', package: packageName),
        width: width.toInt(),
        height: height.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget voiceMic(
      {double width = 20, double height = 20, Color? color}) {
    return Image(
      color: color,
      gaplessPlayback: true,
      image: ResizeImage(
        const AssetImage('assets/images/record_mic.png', package: packageName),
        width: width.toInt(),
        height: height.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget imageDefault(
      {double width = 44, double height = 44, Color? color}) {
    return Image(
      color: color,
      gaplessPlayback: true,
      image: ResizeImage(
        const AssetImage('assets/images/image_default.png',
            package: packageName),
        width: width.toInt(),
        height: height.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget videoDefault(
      {double width = 44, double height = 44, Color? color}) {
    return Image(
      color: color,
      gaplessPlayback: true,
      image: ResizeImage(
        const AssetImage('assets/images/video_default.png',
            package: packageName),
        width: width.toInt(),
        height: height.toInt(),
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

  static Widget messageViewMoreAlbum(
      {double width = 24, double height = 24, Color? color}) {
    return Image(
      gaplessPlayback: true,
      color: color,
      image: ResizeImage(
        const AssetImage('assets/images/image.png', package: packageName),
        width: width.toInt(),
        height: height.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget messageViewMoreVideo(
      {double width = 24, double height = 24, Color? color}) {
    return Image(
      color: color,
      gaplessPlayback: true,
      image: ResizeImage(
        const AssetImage('assets/images/video.png', package: packageName),
        width: width.toInt(),
        height: height.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget messageViewMoreCamera(
      {double width = 24, double height = 24, Color? color}) {
    return Image(
      color: color,
      gaplessPlayback: true,
      image: ResizeImage(
        const AssetImage('assets/images/camera.png', package: packageName),
        width: width.toInt(),
        height: height.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget messageViewMoreFile(
      {double width = 24, double height = 24, Color? color}) {
    return Image(
      color: color,
      gaplessPlayback: true,
      image: ResizeImage(
        const AssetImage('assets/images/folder.png', package: packageName),
        width: width.toInt(),
        height: height.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget messageViewMoreCard(
      {double width = 24, double height = 24, Color? color}) {
    return Image(
      gaplessPlayback: true,
      color: color,
      image: ResizeImage(
        const AssetImage('assets/images/person.png', package: packageName),
        width: width.toInt(),
        height: height.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget messageLongPressCopy(
      {double width = 24, double height = 24, Color? color}) {
    return Image(
      gaplessPlayback: true,
      color: color,
      image: ResizeImage(
        const AssetImage('assets/images/message_long_press_copy.png',
            package: packageName),
        width: width.toInt(),
        height: height.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget messageLongPressReply(
      {double width = 24, double height = 24, Color? color}) {
    return Image(
      gaplessPlayback: true,
      color: color,
      image: ResizeImage(
        const AssetImage('assets/images/message_long_press_reply.png',
            package: packageName),
        width: width.toInt(),
        height: height.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget messageLongPressEdit(
      {double width = 24, double height = 24, Color? color}) {
    return Image(
      gaplessPlayback: true,
      color: color,
      image: ResizeImage(
        const AssetImage('assets/images/message_long_press_edit.png',
            package: packageName),
        width: width.toInt(),
        height: height.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget messageLongPressReport(
      {double width = 24, double height = 24, Color? color}) {
    return Image(
      gaplessPlayback: true,
      color: color,
      image: ResizeImage(
        const AssetImage('assets/images/message_long_press_report.png',
            package: packageName),
        width: width.toInt(),
        height: height.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget messageLongPressDelete(
      {double width = 24, double height = 24, Color? color}) {
    return Image(
      color: color,
      gaplessPlayback: true,
      image: ResizeImage(
        const AssetImage('assets/images/message_long_press_delete.png',
            package: packageName),
        width: width.toInt(),
        height: height.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }

  static Widget messageLongPressRecall(
      {double width = 24, double height = 24, Color? color}) {
    return Image(
      color: color,
      gaplessPlayback: true,
      image: ResizeImage(
        const AssetImage('assets/images/message_long_press_recall.png',
            package: packageName),
        width: width.toInt(),
        height: height.toInt(),
      ),
      fit: BoxFit.fill,
    );
  }
}
