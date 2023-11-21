import 'package:flutter/foundation.dart';
import '../chat_sdk_wrapper.dart';

mixin ConnectWrapper on ChatUIKitWrapperBase {
  @protected
  @override
  void addListeners() {
    super.addListeners();
    Client.getInstance.addConnectionEventHandler(
      sdkEventKey,
      ConnectionEventHandler(
        onConnected: onConnected,
        onDisconnected: onDisconnected,
        onUserDidLoginFromOtherDevice: onUserDidLoginFromOtherDevice,
        onUserDidRemoveFromServer: onUserDidRemoveFromServer,
        onUserDidForbidByServer: onUserDidForbidByServer,
        onUserDidChangePassword: onUserDidChangePassword,
        onUserDidLoginTooManyDevice: onUserDidLoginTooManyDevice,
        onUserKickedByOtherDevice: onUserKickedByOtherDevice,
        onUserAuthenticationFailed: onUserAuthenticationFailed,
        onTokenWillExpire: onTokenWillExpire,
        onTokenDidExpire: onTokenDidExpire,
        onAppActiveNumberReachLimit: onAppActiveNumberReachLimit,
      ),
    );
  }

  @protected
  void onConnected() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ConnectObserver).onConnected();
    }
  }

  @protected
  void onDisconnected() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ConnectObserver).onDisconnected();
    }
  }

  void onUserDidLoginFromOtherDevice(String deviceName) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ConnectObserver).onUserDidLoginFromOtherDevice(deviceName);
    }
  }

  @protected
  void onUserDidRemoveFromServer() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ConnectObserver).onUserDidRemoveFromServer();
    }
  }

  @protected
  void onUserDidForbidByServer() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ConnectObserver).onUserDidForbidByServer();
    }
  }

  @protected
  void onUserDidChangePassword() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ConnectObserver).onUserDidChangePassword();
    }
  }

  @protected
  void onUserDidLoginTooManyDevice() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ConnectObserver).onUserDidLoginTooManyDevice();
    }
  }

  @protected
  void onUserKickedByOtherDevice() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ConnectObserver).onUserKickedByOtherDevice();
    }
  }

  @protected
  void onUserAuthenticationFailed() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ConnectObserver).onUserAuthenticationFailed();
    }
  }

  @protected
  void onTokenWillExpire() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ConnectObserver).onTokenWillExpire();
    }
  }

  @protected
  void onTokenDidExpire() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ConnectObserver).onTokenDidExpire();
    }
  }

  @protected
  void onAppActiveNumberReachLimit() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as ConnectObserver).onAppActiveNumberReachLimit();
    }
  }
}
