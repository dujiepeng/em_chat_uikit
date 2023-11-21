import 'package:flutter/foundation.dart';
import '../chat_sdk_wrapper.dart';

mixin GroupWrapper on ChatUIKitWrapperBase {
  @protected
  @override
  void addListeners() {
    super.addListeners();
    Client.getInstance.groupManager.addEventHandler(
      sdkEventKey,
      GroupEventHandler(
        onGroupDestroyed: onGroupDestroyed,
        onAdminAddedFromGroup: onAdminAddedFromGroup,
        onAdminRemovedFromGroup: onAdminRemovedFromGroup,
        onAllGroupMemberMuteStateChanged: onAllGroupMemberMuteStateChanged,
        onAllowListAddedFromGroup: onAllowListAddedFromGroup,
        onAllowListRemovedFromGroup: onAllowListRemovedFromGroup,
        onAnnouncementChangedFromGroup: onAnnouncementChangedFromGroup,
        onAutoAcceptInvitationFromGroup: onAutoAcceptInvitationFromGroup,
        onInvitationAcceptedFromGroup: onInvitationAcceptedFromGroup,
        onInvitationDeclinedFromGroup: onInvitationDeclinedFromGroup,
        onInvitationReceivedFromGroup: onInvitationReceivedFromGroup,
        onMemberExitedFromGroup: onMemberExitedFromGroup,
        onMemberJoinedFromGroup: onMemberJoinedFromGroup,
        onMuteListAddedFromGroup: onMuteListAddedFromGroup,
        onMuteListRemovedFromGroup: onMuteListRemovedFromGroup,
        onOwnerChangedFromGroup: onOwnerChangedFromGroup,
        onRequestToJoinAcceptedFromGroup: onRequestToJoinAcceptedFromGroup,
        onRequestToJoinDeclinedFromGroup: onRequestToJoinDeclinedFromGroup,
        onRequestToJoinReceivedFromGroup: onRequestToJoinReceivedFromGroup,
        onSharedFileAddedFromGroup: onSharedFileAddedFromGroup,
        onSpecificationDidUpdate: onSpecificationDidUpdate,
        onDisableChanged: onDisableChanged,
        onSharedFileDeletedFromGroup: onSharedFileDeletedFromGroup,
        onUserRemovedFromGroup: onUserRemovedFromGroup,
        onAttributesChangedOfGroupMember: onAttributesChangedOfGroupMember,
      ),
    );
  }

  @protected
  void onGroupDestroyed(String groupId, String? groupName) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver).onGroupDestroyed(groupId, groupName);
    }
  }

  @protected
  void onAdminAddedFromGroup(String groupId, String admin) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver).onAdminAddedFromGroup(groupId, admin);
    }
  }

  @protected
  void onAdminRemovedFromGroup(String groupId, String admin) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver).onAdminRemovedFromGroup(groupId, admin);
    }
  }

  @protected
  void onAllGroupMemberMuteStateChanged(String groupId, bool isAllMuted) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver)
          .onAllGroupMemberMuteStateChanged(groupId, isAllMuted);
    }
  }

  @protected
  void onAllowListAddedFromGroup(String groupId, List<String> members) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver).onAllowListAddedFromGroup(groupId, members);
    }
  }

  @protected
  void onAllowListRemovedFromGroup(String groupId, List<String> members) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver).onAllowListRemovedFromGroup(groupId, members);
    }
  }

  @protected
  void onAnnouncementChangedFromGroup(String groupId, String announcement) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver)
          .onAnnouncementChangedFromGroup(groupId, announcement);
    }
  }

  @protected
  void onAutoAcceptInvitationFromGroup(
      String groupId, String inviter, String? inviteMessage) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver)
          .onAutoAcceptInvitationFromGroup(groupId, inviter, inviteMessage);
    }
  }

  @protected
  void onInvitationAcceptedFromGroup(
      String groupId, String invitee, String? reason) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver)
          .onInvitationAcceptedFromGroup(groupId, invitee, reason);
    }
  }

  @protected
  void onInvitationDeclinedFromGroup(
      String groupId, String invitee, String? reason) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver)
          .onInvitationDeclinedFromGroup(groupId, invitee, reason);
    }
  }

  @protected
  void onInvitationReceivedFromGroup(
      String groupId, String? groupName, String inviter, String? reason) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver)
          .onInvitationReceivedFromGroup(groupId, groupName, inviter, reason);
    }
  }

  @protected
  void onMemberExitedFromGroup(String groupId, String member) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver).onMemberExitedFromGroup(groupId, member);
    }
  }

  @protected
  void onMemberJoinedFromGroup(String groupId, String member) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver).onMemberJoinedFromGroup(groupId, member);
    }
  }

  @protected
  void onMuteListAddedFromGroup(
      String groupId, List<String> mutes, int? muteExpire) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver)
          .onMuteListAddedFromGroup(groupId, mutes, muteExpire);
    }
  }

  @protected
  void onMuteListRemovedFromGroup(String groupId, List<String> mutes) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver).onMuteListRemovedFromGroup(groupId, mutes);
    }
  }

  @protected
  void onOwnerChangedFromGroup(
      String groupId, String newOwner, String oldOwner) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver)
          .onOwnerChangedFromGroup(groupId, newOwner, oldOwner);
    }
  }

  @protected
  void onRequestToJoinAcceptedFromGroup(
      String groupId, String? groupName, String accepter) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver)
          .onRequestToJoinAcceptedFromGroup(groupId, groupName, accepter);
    }
  }

  @protected
  void onRequestToJoinDeclinedFromGroup(
      String groupId, String? groupName, String decliner, String? reason) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver).onRequestToJoinDeclinedFromGroup(
          groupId, groupName, decliner, reason);
    }
  }

  @protected
  void onRequestToJoinReceivedFromGroup(
      String groupId, String? groupName, String applicant, String? reason) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver).onRequestToJoinReceivedFromGroup(
          groupId, groupName, applicant, reason);
    }
  }

  @protected
  void onSharedFileAddedFromGroup(String groupId, GroupSharedFile sharedFile) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver)
          .onSharedFileAddedFromGroup(groupId, sharedFile);
    }
  }

  @protected
  void onSpecificationDidUpdate(Group group) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver).onSpecificationDidUpdate(group);
    }
  }

  @protected
  void onDisableChanged(String groupId, bool isDisable) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver).onDisableChanged(groupId, isDisable);
    }
  }

  @protected
  void onSharedFileDeletedFromGroup(String groupId, String fileId) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver).onSharedFileDeletedFromGroup(groupId, fileId);
    }
  }

  @protected
  void onUserRemovedFromGroup(String groupId, String? groupName) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver).onUserRemovedFromGroup(groupId, groupName);
    }
  }

  @protected
  void onAttributesChangedOfGroupMember(String groupId, String userId,
      Map<String, String>? attributes, String? operatorId) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver).onAttributesChangedOfGroupMember(
          groupId, userId, attributes, operatorId);
    }
  }
}
