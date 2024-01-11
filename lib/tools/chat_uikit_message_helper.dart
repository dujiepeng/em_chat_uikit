import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

double defaultWidth = 225;
double defaultHeight = 300;

extension MessageHelper on Message {
  MessageType get bodyType => body.type;

  String? get avatarUrl {
    Map? userInfo = attributes?[msgUserInfoKey];
    return userInfo?[userAvatarKey];
  }

  String? get nickname {
    Map? userInfo = attributes?[msgUserInfoKey];
    return userInfo?[userNicknameKey];
  }

  void addNickname(String? nickname) {
    if (nickname?.isNotEmpty == true) {
      attributes ??= {};
      attributes![msgUserInfoKey][userNicknameKey] = nickname;
    }
  }

  void addAvatarURL(String? avatarUrl) {
    if (avatarUrl?.isNotEmpty == true) {
      attributes ??= {};
      attributes![msgUserInfoKey][userAvatarKey] = avatarUrl;
    }
  }

  String get textContent {
    if (bodyType == MessageType.TXT) {
      return (body as TextMessageBody).content;
    }
    return '';
  }

  bool get isEdit {
    if (bodyType == MessageType.TXT) {
      if ((body as TextMessageBody).modifyCount == null) return false;
      return (body as TextMessageBody).modifyCount! > 0;
    }
    return false;
  }

  String? get displayName {
    if (bodyType == MessageType.IMAGE) {
      return (body as ImageMessageBody).displayName;
    } else if (bodyType == MessageType.VOICE) {
      return (body as VoiceMessageBody).displayName;
    } else if (bodyType == MessageType.VIDEO) {
      return (body as VideoMessageBody).displayName;
    } else if (bodyType == MessageType.FILE) {
      return (body as FileMessageBody).displayName;
    }
    return null;
  }

  int get duration {
    if (bodyType == MessageType.VOICE) {
      return (body as VoiceMessageBody).duration;
    } else if (bodyType == MessageType.VIDEO) {
      return (body as VideoMessageBody).duration ?? 0;
    }
    return 0;
  }

  int get fileSize {
    int? length;
    if (bodyType == MessageType.IMAGE) {
      length = (body as ImageMessageBody).fileSize;
    } else if (bodyType == MessageType.VOICE) {
      length = (body as VoiceMessageBody).fileSize;
    } else if (bodyType == MessageType.VIDEO) {
      length = (body as VideoMessageBody).fileSize;
    } else if (bodyType == MessageType.FILE) {
      length = (body as FileMessageBody).fileSize;
    } else {
      length = 0;
    }
    return length!;
  }

  String get fileSizeStr {
    int? length;
    if (bodyType == MessageType.IMAGE) {
      length = (body as ImageMessageBody).fileSize;
    } else if (bodyType == MessageType.VOICE) {
      length = (body as VoiceMessageBody).fileSize;
    } else if (bodyType == MessageType.VIDEO) {
      length = (body as VideoMessageBody).fileSize;
    } else if (bodyType == MessageType.FILE) {
      length = (body as FileMessageBody).fileSize;
    } else {
      length = 0;
    }
    return ChatUIKitFileSizeTool.fileSize(length!);
  }

  String? get thumbnailLocalPath {
    if (bodyType == MessageType.IMAGE) {
      return (body as ImageMessageBody).thumbnailLocalPath;
    } else if (bodyType == MessageType.VIDEO) {
      return (body as VideoMessageBody).thumbnailLocalPath;
    }
    return null;
  }

  String? get thumbnailRemotePath {
    if (bodyType == MessageType.IMAGE) {
      return (body as ImageMessageBody).thumbnailRemotePath;
    } else if (bodyType == MessageType.VIDEO) {
      return (body as VideoMessageBody).thumbnailRemotePath;
    }
    return null;
  }

  String? get localPath {
    if (bodyType == MessageType.IMAGE) {
      return (body as ImageMessageBody).localPath;
    } else if (bodyType == MessageType.VOICE) {
      return (body as VoiceMessageBody).localPath;
    } else if (bodyType == MessageType.VIDEO) {
      return (body as VideoMessageBody).localPath;
    } else if (bodyType == MessageType.FILE) {
      return (body as FileMessageBody).localPath;
    }
    return null;
  }

  String? get remotePath {
    if (bodyType == MessageType.IMAGE) {
      return (body as ImageMessageBody).remotePath;
    } else if (bodyType == MessageType.VOICE) {
      return (body as VoiceMessageBody).remotePath;
    } else if (bodyType == MessageType.VIDEO) {
      return (body as VideoMessageBody).remotePath;
    } else if (bodyType == MessageType.FILE) {
      return (body as FileMessageBody).remotePath;
    }
    return null;
  }

  double get width {
    if (bodyType == MessageType.IMAGE) {
      return (body as ImageMessageBody).width ?? defaultWidth;
    } else if (bodyType == MessageType.VIDEO) {
      return (body as VideoMessageBody).width ?? defaultWidth;
    }
    return 0;
  }

  double get height {
    if (bodyType == MessageType.IMAGE) {
      return (body as ImageMessageBody).height ?? defaultHeight;
    } else if (bodyType == MessageType.VIDEO) {
      return (body as VideoMessageBody).height ?? defaultHeight;
    }
    return 0;
  }

  bool get isCardMessage {
    if (bodyType == MessageType.CUSTOM) {
      final customBody = body as CustomMessageBody;
      if (customBody.event == cardMessageKey) {
        return true;
      }
    }
    return false;
  }

  String? get cardUserNickname {
    if (bodyType == MessageType.CUSTOM) {
      final customBody = body as CustomMessageBody;
      if (customBody.event == cardMessageKey) {
        return customBody.params?[cardNickname];
      }
    }
    return null;
  }

  String? get cardUserAvatar {
    if (bodyType == MessageType.CUSTOM) {
      final customBody = body as CustomMessageBody;
      if (customBody.event == cardMessageKey) {
        return customBody.params?[cardContactAvatar];
      }
    }
    return null;
  }

  get cardNickname => null;

  String? get cardUserId {
    if (bodyType == MessageType.CUSTOM) {
      final customBody = body as CustomMessageBody;
      if (customBody.event == cardMessageKey) {
        return customBody.params?[cardContactUserId];
      }
    }
    return null;
  }

  String showInfo({BuildContext? context}) {
    String str = '';
    switch (body.type) {
      case MessageType.TXT:
        str = (body as TextMessageBody).content;
        break;
      case MessageType.IMAGE:
        str = '[Image]';
        break;
      case MessageType.VIDEO:
        str = '[Video]';
        break;
      case MessageType.VOICE:
        str = '[Voice]';
        break;
      case MessageType.LOCATION:
        str = '[Location]';
        break;
      case MessageType.COMBINE:
        str = '[Combine]';
        break;
      case MessageType.FILE:
        str = '[File]';
        break;
      case MessageType.CUSTOM:
        if (isCardMessage) {
          str = '[Card]';
        } else {
          str = '[Custom]';
        }

        break;
      default:
    }

    return str;
  }

  bool get hasMention {
    bool ret = false;
    if (attributes == null) {
      ret = false;
    }
    if (attributes?[mentionKey] == null) {
      ret = false;
    }
    if (attributes?[mentionKey] is List) {
      List mentionList = attributes?[mentionKey];
      if (mentionList.isNotEmpty) {
        ret = mentionList.contains(ChatUIKit.instance.currentUserId());
      }
    } else if (attributes?[mentionKey] is String) {
      if (attributes?[mentionKey] == mentionAllValue) {
        ret = true;
      }
    }

    return ret;
  }

  bool get isTimeMessageAlert {
    if (bodyType == MessageType.CUSTOM) {
      if ((body as CustomMessageBody).event == alertTimeMessageEventKey) {
        return true;
      }
    }
    return false;
  }

  bool get isCreateGroupAlert {
    if (bodyType == MessageType.CUSTOM) {
      if ((body as CustomMessageBody).event ==
          alertCreateGroupMessageEventKey) {
        return true;
      }
    }
    return false;
  }

  bool get isRecallAlert {
    if (bodyType == MessageType.CUSTOM) {
      if ((body as CustomMessageBody).event == alertRecalledKey) {
        return true;
      }
    }
    return false;
  }

  MessageType? get recalledMessageType {
    if (bodyType == MessageType.CUSTOM) {
      if ((body as CustomMessageBody).event == alertRecalledKey) {
        String? type =
            (body as CustomMessageBody).params?[alertRecallMessageTypeKey];
        if (type == null) return null;
        return MessageType.values[int.parse(type)];
      }
    }
    return null;
  }

  String? get recallMessageInfo {
    if (bodyType == MessageType.CUSTOM) {
      if ((body as CustomMessageBody).event == alertRecalledKey) {
        return (body as CustomMessageBody).params?[alertRecallInfoKey];
      }
    }
    return null;
  }

  String? get recallMessageFrom {
    if (bodyType == MessageType.CUSTOM) {
      if ((body as CustomMessageBody).event == alertRecalledKey) {
        return (body as CustomMessageBody).params?[alertRecallMessageFromKey];
      }
    }
    return null;
  }

  MessageDirection? get recallMessageDirection {
    if (bodyType == MessageType.CUSTOM) {
      if ((body as CustomMessageBody).event == alertRecalledKey) {
        String? directionStr =
            (body as CustomMessageBody).params?[alertRecallMessageDirectionKey];
        if (directionStr == null) return null;
        return MessageDirection.values[int.parse(directionStr)];
      }
    }
    return null;
  }

  void addQuote(Message message) {
    attributes ??= {};
    attributes![quoteKey] = message.toQuote().toJson();
  }

  QuoteModel toQuote() {
    return QuoteModel.fromMessage(this);
  }

  QuoteModel? getQuote() {
    Map? quoteMap = attributes?[quoteKey];
    if (quoteMap != null) {
      return QuoteModel(
        quoteMap[quoteMsgIdKey],
        quoteMap[quoteMsgTypeKey],
        quoteMap[quoteMsgPreviewKey],
        quoteMap[quoteMsgSenderKey],
      );
    }
    return null;
  }
}
