import 'package:em_chat_uikit/sdk_wrapper/chat_sdk_wrapper.dart';
import 'package:em_chat_uikit/sdk_wrapper/sdk_wrapper_tools.dart';

mixin GroupActions on GroupWrapper {
  Future<Group?> getGroup({required String groupId}) {
    return checkResult(ChatSDKWrapperActionEvent.getGroupId, () {
      return Client.getInstance.groupManager.getGroupWithId(groupId);
    });
  }

  Future<List<Group>> getJoinedGroups() {
    return checkResult(ChatSDKWrapperActionEvent.getJoinedGroups, () {
      return Client.getInstance.groupManager.getJoinedGroups();
    });
  }

  Future<List<Group>> fetchJoinedGroups({
    int pageSize = 20,
    int pageNum = 0,
    bool needMemberCount = false,
    bool needRole = false,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.fetchJoinedGroups, () {
      return Client.getInstance.groupManager.fetchJoinedGroupsFromServer(
        pageSize: pageSize,
        pageNum: pageNum,
        needMemberCount: needMemberCount,
        needRole: needRole,
      );
    });
  }

  Future<CursorResult<GroupInfo>> fetchPublicGroups({
    int pageSize = 20,
    String? cursor,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.fetchPublicGroups, () {
      return Client.getInstance.groupManager.fetchPublicGroupsFromServer(
        pageSize: pageSize,
        cursor: cursor,
      );
    });
  }

  Future<Group> createGroup({
    required String groupName,
    String? desc,
    List<String>? inviteMembers,
    String? inviteReason,
    required GroupOptions options,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.createGroup, () async {
      Group group = await Client.getInstance.groupManager.createGroup(
        groupName: groupName,
        desc: desc,
        inviteMembers: inviteMembers,
        inviteReason: inviteReason,
        options: options,
      );

      onGroupCreatedByMyself(group);
      return group;
    });
  }

  Future<Group> fetchGroupInfo({
    required String groupId,
    bool fetchMembers = false,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.fetchGroupInfo, () {
      return Client.getInstance.groupManager.fetchGroupInfoFromServer(
        groupId,
        fetchMembers: fetchMembers,
      );
    });
  }

  Future<CursorResult<String>> fetchGroupMemberList({
    required String groupId,
    int pageSize = 200,
    String? cursor,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.fetchGroupMemberList, () {
      return Client.getInstance.groupManager.fetchMemberListFromServer(
        groupId,
        pageSize: pageSize,
        cursor: cursor,
      );
    });
  }

  Future<List<String>> fetchGroupBlockList({
    required String groupId,
    int pageSize = 200,
    int pageNum = 1,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.fetchGroupBlockList, () {
      return Client.getInstance.groupManager.fetchBlockListFromServer(
        groupId,
        pageSize: pageSize,
        pageNum: pageNum,
      );
    });
  }

  Future<Map<String, int>> fetchGroupMuteList({
    required String groupId,
    int pageSize = 200,
    int pageNum = 1,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.fetchGroupMuteList, () {
      return Client.getInstance.groupManager.fetchMuteListFromServer(
        groupId,
        pageSize: pageSize,
        pageNum: pageNum,
      );
    });
  }

  Future<List<String>> fetchGroupAllowList(String groupId) {
    return checkResult(ChatSDKWrapperActionEvent.fetchGroupAllowList, () {
      return Client.getInstance.groupManager.fetchAllowListFromServer(groupId);
    });
  }

  Future<bool> fetchGroupMemberIsInAllowList(String groupId) {
    return checkResult(ChatSDKWrapperActionEvent.fetchGroupMemberIsInAllowList,
        () {
      return Client.getInstance.groupManager.isMemberInAllowListFromServer(
        groupId,
      );
    });
  }

  Future<List<GroupSharedFile>> fetchGroupFileList({
    required String groupId,
    int pageSize = 200,
    int pageNum = 1,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.fetchGroupFileList, () {
      return Client.getInstance.groupManager.fetchGroupFileListFromServer(
        groupId,
        pageSize: pageSize,
        pageNum: pageNum,
      );
    });
  }

  Future<String?> fetchGroupAnnouncement(String groupId) {
    return checkResult(ChatSDKWrapperActionEvent.fetchGroupAnnouncement, () {
      return Client.getInstance.groupManager.fetchAnnouncementFromServer(
        groupId,
      );
    });
  }

  Future<void> addGroupMembers({
    required String groupId,
    required List<String> members,
    String? welcome,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.addGroupMembers, () {
      return Client.getInstance.groupManager.addMembers(
        groupId,
        members,
        welcome: welcome,
      );
    });
  }

  Future<void> inviterGroupMembers({
    required String groupId,
    required List<String> members,
    String? reason,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.inviterGroupMembers, () {
      return Client.getInstance.groupManager.inviterUser(
        groupId,
        members,
        reason: reason,
      );
    });
  }

  Future<void> deleteGroupMembers({
    required String groupId,
    required List<String> members,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.deleteGroupMembers, () {
      return Client.getInstance.groupManager.removeMembers(
        groupId,
        members,
      );
    });
  }

  Future<void> addGroupBlockList({
    required String groupId,
    required List<String> members,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.addGroupBlockList, () {
      return Client.getInstance.groupManager.blockMembers(
        groupId,
        members,
      );
    });
  }

  Future<void> deleteGroupBlockList({
    required String groupId,
    required List<String> members,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.deleteGroupBlockList, () {
      return Client.getInstance.groupManager.unblockMembers(
        groupId,
        members,
      );
    });
  }

  Future<void> changeGroupName({
    required String groupId,
    required String name,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.changeGroupName, () async {
      await Client.getInstance.groupManager.changeGroupName(
        groupId,
        name,
      );
      Group? group = await Client.getInstance.groupManager.getGroupWithId(
        groupId,
      );

      onGroupInfoChangedByMeSelf(group!);
    });
  }

  Future<void> changeGroupDescription({
    required String groupId,
    required String desc,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.changeGroupDescription, () {
      return Client.getInstance.groupManager.changeGroupDescription(
        groupId,
        desc,
      );
    });
  }

  Future<void> leaveGroup({required String groupId}) {
    return checkResult(ChatSDKWrapperActionEvent.leaveGroup, () {
      return Client.getInstance.groupManager.leaveGroup(groupId);
    });
  }

  Future<void> destroyGroup({required String groupId}) {
    return checkResult(ChatSDKWrapperActionEvent.destroyGroup, () async {
      await Client.getInstance.groupManager.destroyGroup(groupId);
      SDKWrapperTools.insertGroupDestroyMessage(groupId);
    });
  }

  Future<void> blockGroup({required String groupId}) {
    return checkResult(ChatSDKWrapperActionEvent.blockGroup, () {
      return Client.getInstance.groupManager.blockGroup(groupId);
    });
  }

  Future<void> unblockGroup({required String groupId}) {
    return checkResult(ChatSDKWrapperActionEvent.unblockGroup, () {
      return Client.getInstance.groupManager.unblockGroup(groupId);
    });
  }

  Future<void> changeGroupOwner({
    required String groupId,
    required String newOwner,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.changeGroupOwner, () {
      return Client.getInstance.groupManager.changeOwner(
        groupId,
        newOwner,
      );
    });
  }

  Future<void> addGroupAdmin({
    required String groupId,
    required String memberId,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.addGroupAdmin, () {
      return Client.getInstance.groupManager.addAdmin(
        groupId,
        memberId,
      );
    });
  }

  Future<void> deleteGroupAdmin({
    required String groupId,
    required String memberId,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.deleteGroupAdmin, () {
      return Client.getInstance.groupManager.removeAdmin(
        groupId,
        memberId,
      );
    });
  }

  Future<void> addGroupMuteMembers({
    required String groupId,
    required List<String> members,
    int duration = -1,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.addGroupMuteMembers, () {
      return Client.getInstance.groupManager.muteMembers(
        groupId,
        members,
        duration: duration,
      );
    });
  }

  Future<void> deleteGroupMuteMembers({
    required String groupId,
    required List<String> members,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.deleteGroupMuteMembers, () {
      return Client.getInstance.groupManager.unMuteMembers(
        groupId,
        members,
      );
    });
  }

  Future<void> muteGroupAllMembers({required String groupId}) {
    return checkResult(ChatSDKWrapperActionEvent.muteGroupAllMembers, () {
      return Client.getInstance.groupManager.muteAllMembers(groupId);
    });
  }

  Future<void> unMuteGroupAllMembers({required String groupId}) {
    return checkResult(ChatSDKWrapperActionEvent.unMuteGroupAllMembers, () {
      return Client.getInstance.groupManager.unMuteAllMembers(groupId);
    });
  }

  Future<void> addGroupAllowMembers({
    required String groupId,
    required List<String> members,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.addGroupAllowMembers, () {
      return Client.getInstance.groupManager.addAllowList(
        groupId,
        members,
      );
    });
  }

  Future<void> deleteGroupAllowMembers({
    required String groupId,
    required List<String> members,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.deleteGroupAllowMembers, () {
      return Client.getInstance.groupManager.removeAllowList(
        groupId,
        members,
      );
    });
  }

  Future<void> uploadGroupSharedFile({
    required String groupId,
    required String filePath,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.uploadGroupSharedFile, () {
      return Client.getInstance.groupManager.uploadGroupSharedFile(
        groupId,
        filePath,
      );
    });
  }

  Future<void> downloadGroupSharedFile({
    required String groupId,
    required String fileId,
    required String savePath,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.downloadGroupSharedFile, () {
      return Client.getInstance.groupManager.downloadGroupSharedFile(
        groupId: groupId,
        fileId: fileId,
        savePath: savePath,
      );
    });
  }

  Future<void> removeGroupSharedFile({
    required String groupId,
    required String fileId,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.removeGroupSharedFile, () {
      return Client.getInstance.groupManager.removeGroupSharedFile(
        groupId,
        fileId,
      );
    });
  }

  Future<void> updateGroupAnnouncement({
    required String groupId,
    required String announcement,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.updateGroupAnnouncement, () {
      return Client.getInstance.groupManager.updateGroupAnnouncement(
        groupId,
        announcement,
      );
    });
  }

  Future<void> updateGroupExtension({
    required String groupId,
    required String extension,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.updateGroupExtension, () {
      return Client.getInstance.groupManager.updateGroupExtension(
        groupId,
        extension,
      );
    });
  }

  Future<void> joinPublicGroup({
    required String groupId,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.joinPublicGroup, () {
      return Client.getInstance.groupManager.joinPublicGroup(groupId);
    });
  }

  Future<void> requestToJoinPublicGroup({
    required String groupId,
    String? reason,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.requestToJoinPublicGroup, () {
      return Client.getInstance.groupManager.requestToJoinPublicGroup(
        groupId,
        reason: reason,
      );
    });
  }

  Future<int> fetchJoinedGroupCount() {
    return checkResult(ChatSDKWrapperActionEvent.fetchJoinedGroupCount, () {
      return Client.getInstance.groupManager.fetchJoinedGroupCount();
    });
  }

  Future<void> acceptGroupJoinApplication({
    required String groupId,
    required String userId,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.acceptGroupJoinApplication,
        () {
      return Client.getInstance.groupManager.acceptJoinApplication(
        groupId,
        userId,
      );
    });
  }

  Future<void> declineGroupJoinApplication({
    required String groupId,
    required String userId,
    String? reason,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.declineGroupJoinApplication,
        () {
      return Client.getInstance.groupManager.declineJoinApplication(
        groupId,
        userId,
        reason: reason,
      );
    });
  }

  Future<Group> acceptGroupInvitation({
    required String groupId,
    required String userId,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.acceptGroupInvitation, () {
      return Client.getInstance.groupManager.acceptInvitation(
        groupId,
        userId,
      );
    });
  }

  Future<void> declineGroupInvitation({
    required String groupId,
    required String inviter,
    String? reason,
  }) {
    return checkResult(ChatSDKWrapperActionEvent.declineGroupInvitation, () {
      return Client.getInstance.groupManager.declineInvitation(
        groupId: groupId,
        inviter: inviter,
        reason: reason,
      );
    });
  }

  Future<void> setGroupMemberAttributes({
    required String groupId,
    required Map<String, String> attributes,
    String? userId,
  }) async {
    return checkResult(ChatSDKWrapperActionEvent.setGroupMemberAttributes, () {
      return Client.getInstance.groupManager.setMemberAttributes(
        groupId: groupId,
        attributes: attributes,
        userId: userId,
      );
    });
  }

  Future<void> deleteGroupMemberAttributes({
    required String groupId,
    required List<String> keys,
    String? userId,
  }) async {
    return checkResult(ChatSDKWrapperActionEvent.deleteGroupMemberAttributes,
        () {
      return Client.getInstance.groupManager.removeMemberAttributes(
        groupId: groupId,
        keys: keys,
        userId: userId,
      );
    });
  }

  Future<Map<String, String>> fetchGroupMemberAttributes({
    required String groupId,
    String? userId,
  }) async {
    return checkResult(ChatSDKWrapperActionEvent.fetchGroupMemberAttributes,
        () {
      return Client.getInstance.groupManager.fetchMemberAttributes(
        groupId: groupId,
        userId: userId,
      );
    });
  }

  Future<Map<String, Map<String, String>>> fetchGroupMembersAttributes({
    required String groupId,
    required List<String> userIds,
    List<String>? keys,
  }) async {
    return checkResult(ChatSDKWrapperActionEvent.fetchGroupMembersAttributes,
        () {
      return Client.getInstance.groupManager.fetchMembersAttributes(
        groupId: groupId,
        userIds: userIds,
        keys: keys,
      );
    });
  }
}
