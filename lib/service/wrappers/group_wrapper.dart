import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/foundation.dart';

mixin GroupWrapper on ChatUIKitWrapperBase {
  @protected
  @override
  void addListeners() {
    super.addListeners();
    Client.getInstance.groupManager.addEventHandler(
      sdkEventKey,
      GroupEventHandler(
        onGroupDestroyed: _onGroupDestroyed,
        onAdminAddedFromGroup: _onAdminAddedFromGroup,
        onAdminRemovedFromGroup: _onAdminRemovedFromGroup,
        onAllGroupMemberMuteStateChanged: _onAllGroupMemberMuteStateChanged,
        onAllowListAddedFromGroup: _onAllowListAddedFromGroup,
        onAllowListRemovedFromGroup: _onAllowListRemovedFromGroup,
        onAnnouncementChangedFromGroup: _onAnnouncementChangedFromGroup,
        onAutoAcceptInvitationFromGroup: _onAutoAcceptInvitationFromGroup,
        onInvitationAcceptedFromGroup: _onInvitationAcceptedFromGroup,
        onInvitationDeclinedFromGroup: _onInvitationDeclinedFromGroup,
        onInvitationReceivedFromGroup: _onInvitationReceivedFromGroup,
        onMemberExitedFromGroup: _onMemberExitedFromGroup,
        onMemberJoinedFromGroup: _onMemberJoinedFromGroup,
        onMuteListAddedFromGroup: _onMuteListAddedFromGroup,
        onMuteListRemovedFromGroup: _onMuteListRemovedFromGroup,
        onOwnerChangedFromGroup: _onOwnerChangedFromGroup,
        onRequestToJoinAcceptedFromGroup: _onRequestToJoinAcceptedFromGroup,
        onRequestToJoinDeclinedFromGroup: _onRequestToJoinDeclinedFromGroup,
        onRequestToJoinReceivedFromGroup: _onRequestToJoinReceivedFromGroup,
        onSharedFileAddedFromGroup: _onSharedFileAddedFromGroup,
        onSpecificationDidUpdate: _onSpecificationDidUpdate,
        onDisableChanged: _onDisableChanged,
        onSharedFileDeletedFromGroup: _onSharedFileDeletedFromGroup,
        onUserRemovedFromGroup: _onUserRemovedFromGroup,
        onAttributesChangedOfGroupMember: _onAttributesChangedOfGroupMember,
      ),
    );
  }

  void _onGroupDestroyed(String groupId, String? groupName) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver).onGroupDestroyed(groupId, groupName);
    }
  }

  void _onAdminAddedFromGroup(String groupId, String admin) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver).onAdminAddedFromGroup(groupId, admin);
    }
  }

  void _onAdminRemovedFromGroup(String groupId, String admin) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver).onAdminRemovedFromGroup(groupId, admin);
    }
  }

  void _onAllGroupMemberMuteStateChanged(String groupId, bool isAllMuted) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver)
          .onAllGroupMemberMuteStateChanged(groupId, isAllMuted);
    }
  }

  void _onAllowListAddedFromGroup(String groupId, List<String> members) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver).onAllowListAddedFromGroup(groupId, members);
    }
  }

  void _onAllowListRemovedFromGroup(String groupId, List<String> members) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver).onAllowListRemovedFromGroup(groupId, members);
    }
  }

  void _onAnnouncementChangedFromGroup(String groupId, String announcement) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver)
          .onAnnouncementChangedFromGroup(groupId, announcement);
    }
  }

  void _onAutoAcceptInvitationFromGroup(
      String groupId, String inviter, String? inviteMessage) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver)
          .onAutoAcceptInvitationFromGroup(groupId, inviter, inviteMessage);
    }
  }

  void _onInvitationAcceptedFromGroup(
      String groupId, String invitee, String? reason) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver)
          .onInvitationAcceptedFromGroup(groupId, invitee, reason);
    }
  }

  void _onInvitationDeclinedFromGroup(
      String groupId, String invitee, String? reason) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver)
          .onInvitationDeclinedFromGroup(groupId, invitee, reason);
    }
  }

  void _onInvitationReceivedFromGroup(
      String groupId, String? groupName, String inviter, String? reason) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver)
          .onInvitationReceivedFromGroup(groupId, groupName, inviter, reason);
    }
  }

  void _onMemberExitedFromGroup(String groupId, String member) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver).onMemberExitedFromGroup(groupId, member);
    }
  }

  void _onMemberJoinedFromGroup(String groupId, String member) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver).onMemberJoinedFromGroup(groupId, member);
    }
  }

  void _onMuteListAddedFromGroup(
      String groupId, List<String> mutes, int? muteExpire) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver)
          .onMuteListAddedFromGroup(groupId, mutes, muteExpire);
    }
  }

  void _onMuteListRemovedFromGroup(String groupId, List<String> mutes) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver).onMuteListRemovedFromGroup(groupId, mutes);
    }
  }

  void _onOwnerChangedFromGroup(
      String groupId, String newOwner, String oldOwner) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver)
          .onOwnerChangedFromGroup(groupId, newOwner, oldOwner);
    }
  }

  void _onRequestToJoinAcceptedFromGroup(
      String groupId, String? groupName, String accepter) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver)
          .onRequestToJoinAcceptedFromGroup(groupId, groupName, accepter);
    }
  }

  void _onRequestToJoinDeclinedFromGroup(
      String groupId, String? groupName, String decliner, String? reason) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver).onRequestToJoinDeclinedFromGroup(
          groupId, groupName, decliner, reason);
    }
  }

  void _onRequestToJoinReceivedFromGroup(
      String groupId, String? groupName, String applicant, String? reason) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver).onRequestToJoinReceivedFromGroup(
          groupId, groupName, applicant, reason);
    }
  }

  void _onSharedFileAddedFromGroup(String groupId, GroupSharedFile sharedFile) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver)
          .onSharedFileAddedFromGroup(groupId, sharedFile);
    }
  }

  void _onSpecificationDidUpdate(Group group) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver).onSpecificationDidUpdate(group);
    }
  }

  void _onDisableChanged(String groupId, bool isDisable) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver).onDisableChanged(groupId, isDisable);
    }
  }

  void _onSharedFileDeletedFromGroup(String groupId, String fileId) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver).onSharedFileDeletedFromGroup(groupId, fileId);
    }
  }

  void _onUserRemovedFromGroup(String groupId, String? groupName) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver).onUserRemovedFromGroup(groupId, groupName);
    }
  }

  void _onAttributesChangedOfGroupMember(String groupId, String userId,
      Map<String, String>? attributes, String? operatorId) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      (observer as GroupObserver).onAttributesChangedOfGroupMember(
          groupId, userId, attributes, operatorId);
    }
  }
}

extension GroupWrapperAction on GroupWrapper {}
