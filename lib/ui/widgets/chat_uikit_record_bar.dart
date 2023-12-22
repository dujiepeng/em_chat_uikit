import 'dart:async';
import 'dart:io';

import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit/ui/widgets/chat_uikit_water_ripple.dart';
import 'package:flutter/material.dart';

class ChatUIKitRecordModel {
  final int duration;
  final String path;
  final String displayName;

  ChatUIKitRecordModel(
    this.duration,
    this.path,
    this.displayName,
  );
}

typedef ChatUIKitRecordChangedCallback = void Function(
  ChatUIKitVoiceBarStatusType type,
  int duration,
  String? path,
);

Future<T?> showChatUIKitRecordBar<T>({
  required BuildContext context,
  RecordConfig recordConfig = const RecordConfig(),
  Color? backgroundColor,
  bool enableRadius = false,
  int maxDuration = 30,
  Widget? deleteIcon,
  Widget? micIcon,
  Widget? sendIcon,
  ChatUIKitRecordChangedCallback? statusChangeCallback,
}) {
  return showModalBottomSheet(
    useSafeArea: false,
    transitionAnimationController: AnimationController(
      duration: Duration.zero,
      reverseDuration: Duration.zero,
      debugLabel: 'BottomSheet',
      vsync: Navigator.of(context),
    ),
    enableDrag: false,
    isDismissible: false,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.transparent,
    context: context,
    builder: (BuildContext context) {
      return ChatUIKitRecordBar(
        enableRadius: enableRadius,
        backgroundColor: backgroundColor,
        maxDuration: maxDuration,
        statusChangeCallback: statusChangeCallback,
        recordConfig: recordConfig,
        deleteIcon: deleteIcon,
        micIcon: micIcon,
        sendIcon: sendIcon,
      );
    },
  );
}

enum ChatUIKitVoiceBarStatusType {
  recording,
  playing,
  ready,
  none,
}

class ChatUIKitRecordBar extends StatefulWidget {
  const ChatUIKitRecordBar({
    this.maxDuration = 60,
    this.backgroundColor,
    this.enableRadius = false,
    this.statusChangeCallback,
    this.recordConfig = const RecordConfig(),
    this.sendIcon,
    this.deleteIcon,
    this.micIcon,
    this.hintText,
    this.hintTextStyle,
    this.recordText,
    this.recordTextStyle,
    this.playText,
    this.playTextStyle,
    this.playingText,
    this.playingTextStyle,
    super.key,
  });
  final int maxDuration;
  final Color? backgroundColor;
  final bool enableRadius;

  final ChatUIKitRecordChangedCallback? statusChangeCallback;
  final RecordConfig recordConfig;
  final Widget? deleteIcon;
  final Widget? micIcon;
  final Widget? sendIcon;

  final String? hintText;
  final TextStyle? hintTextStyle;
  final String? recordText;
  final TextStyle? recordTextStyle;
  final String? playText;
  final TextStyle? playTextStyle;
  final String? playingText;
  final TextStyle? playingTextStyle;

  @override
  State<ChatUIKitRecordBar> createState() => _ChatUIKitRecordBarState();
}

class _ChatUIKitRecordBarState extends State<ChatUIKitRecordBar> {
  late final AudioRecorder _audioRecorder;
  bool voiceShow = false;
  bool isClose = false;
  late final Directory _directory;
  ChatUIKitVoiceBarStatusType statusType = ChatUIKitVoiceBarStatusType.none;
  String? recordPath;
  String? fileName;
  Timer? recordTimer;
  int recordCounter = 0;
  Timer? playTimer;
  int playCounter = 0;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
    getTemporaryDirectory().then((value) => _directory = value);
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    recordTimer?.cancel();
    playTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!voiceShow && !isClose) {
        voiceShow = true;
        setState(() {});
      }
    });

    Widget content = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _removeButton(theme),
        _voiceButton(theme),
        _sendButton(theme),
      ],
    );

    content = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        content,
        const SizedBox(height: 16),
        _label(theme),
        _remainingLabel(theme)
      ],
    );

    content = Container(
      decoration: BoxDecoration(
        borderRadius: widget.enableRadius
            ? const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              )
            : null,
        color: theme.color.isDark
            ? theme.color.neutralColor1
            : theme.color.neutralColor98,
      ),
      child: content,
    );

    content = Stack(
      children: [
        Positioned.fill(
            child: InkWell(
                onTap: () async {
                  if (statusType == ChatUIKitVoiceBarStatusType.recording) {
                    return;
                  }
                  if (recordPath?.isNotEmpty == true) {
                    final file = File(recordPath!);
                    if (file.existsSync()) {
                      file.deleteSync();
                    }
                  }
                  voiceShow = false;
                  isClose = true;
                  setState(() {});
                },
                child: AnimatedOpacity(
                  curve: Curves.linearToEaseOut,
                  opacity: voiceShow ? 1 : 0,
                  duration: Duration(milliseconds: voiceShow ? 10 : 100),
                  child: Container(
                    color:
                        widget.backgroundColor ?? Colors.black.withOpacity(0.5),
                  ),
                ))),
        AnimatedPositioned(
          left: 0,
          right: 0,
          bottom: voiceShow ? 0 : -200,
          height: 200,
          duration: Duration(milliseconds: voiceShow ? 30 : 200),
          curve: Curves.linearToEaseOut,
          child: content,
          onEnd: () {
            if (!voiceShow) {
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );

    return content;
  }

  Widget _label(ChatUIKitTheme theme) {
    final style = TextStyle(
      fontWeight: theme.font.bodyLarge.fontWeight,
      fontSize: theme.font.bodyLarge.fontSize,
      color: theme.color.isDark
          ? theme.color.neutralColor7
          : theme.color.neutralColor5,
    );
    if (statusType == ChatUIKitVoiceBarStatusType.none) {
      return Text(
        widget.hintText ?? '点击录音',
        style: widget.hintTextStyle ?? style,
      );
    } else if (statusType == ChatUIKitVoiceBarStatusType.recording) {
      return Text(
        widget.recordText ?? '正在录音',
        style: widget.recordTextStyle ?? style,
      );
    } else if (statusType == ChatUIKitVoiceBarStatusType.ready) {
      return Text(
        widget.playText ?? '点击播放',
        style: widget.playTextStyle ?? style,
      );
    } else if (statusType == ChatUIKitVoiceBarStatusType.playing) {
      return Text(
        widget.playingText ?? '播放中',
        style: widget.playingTextStyle ?? style,
      );
    }

    return const SizedBox();
  }

  Widget _remainingLabel(ChatUIKitTheme theme) {
    Widget content;
    if (widget.maxDuration - recordCounter <= 10 &&
        statusType == ChatUIKitVoiceBarStatusType.recording) {
      content = Text("${widget.maxDuration - recordCounter}'后自动停止",
          style: TextStyle(
            fontWeight: theme.font.bodySmall.fontWeight,
            fontSize: theme.font.bodySmall.fontSize,
            color: theme.color.isDark
                ? theme.color.neutralColor7
                : theme.color.neutralColor5,
          ));
    } else {
      content = const SizedBox();
    }
    return SizedBox(
      height: 16,
      child: content,
    );
  }

  Widget _voiceButton(ChatUIKitTheme theme) {
    Widget content = InkWell(
      onTap: () async {
        if (statusType == ChatUIKitVoiceBarStatusType.recording) {
          await stopRecord();
        } else if (statusType == ChatUIKitVoiceBarStatusType.none) {
          await startRecord();
        } else if (statusType == ChatUIKitVoiceBarStatusType.ready) {
          play();
        } else if (statusType == ChatUIKitVoiceBarStatusType.playing) {
          stopPlay();
        }
      },
      child: Container(
          width: 72,
          height: 48,
          decoration: BoxDecoration(
            color: theme.color.isDark
                ? theme.color.primaryColor6
                : theme.color.primaryColor5,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Center(
            child: () {
              if (statusType == ChatUIKitVoiceBarStatusType.none) {
                return widget.micIcon ?? ChatUIKitImageLoader.voiceMic();
              } else if (statusType == ChatUIKitVoiceBarStatusType.recording ||
                  statusType == ChatUIKitVoiceBarStatusType.ready) {
                return Text(
                  '${recordCounter}s',
                  style: TextStyle(
                      color: theme.color.isDark
                          ? theme.color.neutralColor98
                          : theme.color.neutralColor98,
                      fontWeight: theme.font.headlineSmall.fontWeight,
                      fontSize: theme.font.headlineSmall.fontSize),
                );
              } else if (statusType == ChatUIKitVoiceBarStatusType.playing) {
                return Text(
                  '${playCounter}s',
                  style: TextStyle(
                      color: theme.color.isDark
                          ? theme.color.neutralColor98
                          : theme.color.neutralColor98,
                      fontWeight: theme.font.headlineSmall.fontWeight,
                      fontSize: theme.font.headlineSmall.fontSize),
                );
              }
              return const SizedBox();
            }(),
          )),
    );

    content = ChatUIKitWaterRipper(
      color: theme.color.isDark
          ? theme.color.primaryColor6
          : theme.color.primaryColor5,
      duration: const Duration(milliseconds: 1000),
      count: 7,
      enable: ChatUIKitVoiceBarStatusType.recording == statusType,
      child: content,
    );

    return content;
  }

  Widget _removeButton(ChatUIKitTheme theme) {
    return SizedBox(
      width: 36,
      height: 36,
      child: (statusType == ChatUIKitVoiceBarStatusType.recording ||
              statusType == ChatUIKitVoiceBarStatusType.ready ||
              statusType == ChatUIKitVoiceBarStatusType.playing)
          ? InkWell(
              onTap: () async {
                if (await _audioRecorder.isRecording()) {
                  recordPath = await _audioRecorder.stop();
                  stopRecordTimer();
                }
                statusType = ChatUIKitVoiceBarStatusType.none;
                setState(() {});
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  if (recordPath?.isNotEmpty == true) {
                    File file = File(recordPath!);
                    if (file.existsSync()) {
                      file.deleteSync();
                    }
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: theme.color.isDark
                      ? theme.color.neutralColor2
                      : theme.color.neutralColor9,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                    child: ChatUIKitImageLoader.voiceDelete(
                  color: theme.color.isDark
                      ? theme.color.neutralColor7
                      : theme.color.neutralColor5,
                )),
              ),
            )
          : const SizedBox(),
    );
  }

  Widget _sendButton(ChatUIKitTheme theme) {
    return SizedBox(
      width: 36,
      height: 36,
      child: (statusType == ChatUIKitVoiceBarStatusType.recording ||
              statusType == ChatUIKitVoiceBarStatusType.ready ||
              statusType == ChatUIKitVoiceBarStatusType.playing)
          ? InkWell(
              onTap: () async {
                if (await _audioRecorder.isRecording()) {
                  recordPath = await _audioRecorder.stop();
                }
                statusType = ChatUIKitVoiceBarStatusType.ready;
                widget.statusChangeCallback
                    ?.call(statusType, recordCounter, recordPath!);
                sendVoice();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: theme.color.isDark
                      ? theme.color.primaryColor6
                      : theme.color.primaryColor5,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                    child: ChatUIKitImageLoader.voiceSend(
                  color: theme.color.isDark
                      ? theme.color.neutralColor98
                      : theme.color.neutralColor98,
                )),
              ),
            )
          : const SizedBox(),
    );
  }

  void sendVoice() {
    final model = ChatUIKitRecordModel(recordCounter, recordPath!, fileName!);
    Navigator.of(context).pop(model);
  }

  Future<void> startRecord() async {
    if (await _audioRecorder.hasPermission()) {
      fileName =
          "${DateTime.now().millisecondsSinceEpoch.toString()}.${extensionName()}";
      await _audioRecorder.start(widget.recordConfig,
          path: "${_directory.path}/$fileName");

      startRecordTimer();
      statusType = ChatUIKitVoiceBarStatusType.recording;
      widget.statusChangeCallback?.call(statusType, 0, null);
      setState(() {});
    }else {
      // TODO: show permission error.
    }
  }

  Future<void> stopRecord() async {
    recordPath = await _audioRecorder.stop();
    stopRecordTimer();
    statusType = ChatUIKitVoiceBarStatusType.ready;
    widget.statusChangeCallback?.call(statusType, recordCounter, recordPath!);
    setState(() {});
  }

  void play() {
    statusType = ChatUIKitVoiceBarStatusType.playing;
    widget.statusChangeCallback?.call(statusType, recordCounter, recordPath!);
    startPlayTimer();
    setState(() {});
  }

  void stopPlay() {
    statusType = ChatUIKitVoiceBarStatusType.ready;
    widget.statusChangeCallback?.call(statusType, recordCounter, recordPath!);
    stopPlayTimer();
    setState(() {});
  }

  void startPlayTimer() {
    playCounter = 0;
    playTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      playTimerRun();
    });
  }

  void stopPlayTimer() {
    playTimer?.cancel();
    playTimer = null;
  }

  void playTimerRun() {
    playCounter++;
    if (playCounter >= recordCounter) {
      stopPlay();
      return;
    }
    setState(() {});
  }

  void startRecordTimer() {
    recordCounter = 0;
    recordTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      recordTimerRun();
    });
  }

  void stopRecordTimer() {
    recordTimer?.cancel();
    recordTimer = null;
  }

  void recordTimerRun() {
    recordCounter++;
    if (recordCounter >= widget.maxDuration) {
      stopRecord();
      return;
    }
    setState(() {});
  }

  String extensionName() {
    switch (widget.recordConfig.encoder) {
      case AudioEncoder.aacLc:
        return 'aac';
      case AudioEncoder.aacEld:
        return 'aac';
      case AudioEncoder.aacHe:
        return 'aac';
      case AudioEncoder.amrNb:
        return 'amr';
      case AudioEncoder.amrWb:
        return 'amr';
      case AudioEncoder.opus:
        return 'opus';
      case AudioEncoder.flac:
        return 'flac';
      case AudioEncoder.wav:
        return 'wav';
      case AudioEncoder.pcm16bits:
        return 'pcm';
    }
  }
}
