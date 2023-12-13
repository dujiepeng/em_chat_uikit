import 'package:em_chat_uikit/chat_uikit.dart';

extension CornerRadiusHelper on CornerRadius {
  static double searchBarRadius(double height, {CornerRadius? cornerRadius}) {
    double circularRadius = 0;
    switch (cornerRadius ?? ChatUIKitSettings.searchBarRadius) {
      case CornerRadius.extraSmall:
        circularRadius = height / 16;
        break;
      case CornerRadius.small:
        circularRadius = height / 8;
        break;
      case CornerRadius.medium:
        circularRadius = height / 4;
        break;
      case CornerRadius.large:
        circularRadius = height / 2;
        break;
    }
    return circularRadius;
  }

  static double avatarRadius(double height, {CornerRadius? cornerRadius}) {
    double circularRadius = 0;
    switch (cornerRadius ?? ChatUIKitSettings.avatarRadius) {
      case CornerRadius.extraSmall:
        circularRadius = height / 16;
        break;
      case CornerRadius.small:
        circularRadius = height / 8;
        break;
      case CornerRadius.medium:
        circularRadius = height / 4;
        break;
      case CornerRadius.large:
        circularRadius = height / 2;
        break;
    }
    return circularRadius;
  }
}
