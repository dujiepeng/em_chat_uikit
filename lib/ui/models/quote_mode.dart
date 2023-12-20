import 'package:em_chat_uikit/chat_uikit.dart';

class QuoteModel {
  final String msgId;
  final int msgType;
  final String preview;
  final String sender;

  QuoteModel.fromMessage(Message message)
      : msgId = message.msgId,
        msgType = message.bodyType.index,
        preview = message.showInfo(),
        sender = message.from!;

  QuoteModel(
    this.msgId,
    this.msgType,
    this.preview,
    this.sender,
  );

  Map<String, dynamic> toJson() {
    return {
      quoteMsgIdKey: msgId,
      quoteMsgTypeKey: msgType,
      quoteMsgPreviewKey: preview,
      quoteMsgSenderKey: sender,
    };
  }
}


  //  map[quoteMsgIdKey] = message.msgId;
  //   map[quoteMsgTypeKey] = message.bodyType.index;
  //   map[quoteMsgPreviewKey] = message.showInfo();
  //   map[quoteMsgSenderKey] = message.from!;