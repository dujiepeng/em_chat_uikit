import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/foundation.dart';

mixin ConnectWrapper on ChatUIKitWrapperBase {
  @protected
  @override
  void addListeners() {
    super.addListeners();
    Client.getInstance.addConnectionEventHandler(
      sdkEventKey,
      ConnectionEventHandler(
        onConnected: _onConnected,
        onDisconnected: _onDisconnected,
        onUserDidLoginFromOtherDevice: _onUserDidLoginFromOtherDevice,
        onUserDidRemoveFromServer: _onUserDidRemoveFromServer,
        onUserDidForbidByServer: _onUserDidForbidByServer,
        onUserDidChangePassword: _onUserDidChangePassword,
        onUserDidLoginTooManyDevice: _onUserDidLoginTooManyDevice,
        onUserKickedByOtherDevice: _onUserKickedByOtherDevice,
        onUserAuthenticationFailed: _onUserAuthenticationFailed,
        onTokenWillExpire: _onTokenWillExpire,
        onTokenDidExpire: _onTokenDidExpire,
        onAppActiveNumberReachLimit: _onAppActiveNumberReachLimit,
      ),
    );
  }

  void _onConnected() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ConnectObserver).onConnected();
    }
  }

  void _onDisconnected() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ConnectObserver).onDisconnected();
    }
  }

  void _onUserDidLoginFromOtherDevice(String deviceName) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ConnectObserver).onUserDidLoginFromOtherDevice(deviceName);
    }
  }

  void _onUserDidRemoveFromServer() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ConnectObserver).onUserDidRemoveFromServer();
    }
  }

  void _onUserDidForbidByServer() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ConnectObserver).onUserDidForbidByServer();
    }
  }

  void _onUserDidChangePassword() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ConnectObserver).onUserDidChangePassword();
    }
  }

  void _onUserDidLoginTooManyDevice() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ConnectObserver).onUserDidLoginTooManyDevice();
    }
  }

  void _onUserKickedByOtherDevice() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ConnectObserver).onUserKickedByOtherDevice();
    }
  }

  void _onUserAuthenticationFailed() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ConnectObserver).onUserAuthenticationFailed();
    }
  }

  void _onTokenWillExpire() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ConnectObserver).onTokenWillExpire();
    }
  }

  void _onTokenDidExpire() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ConnectObserver).onTokenDidExpire();
    }
  }

  void _onAppActiveNumberReachLimit() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ConnectObserver).onAppActiveNumberReachLimit();
    }
  }
}

extension ConnectWrapperAction on ConnectWrapper {}
