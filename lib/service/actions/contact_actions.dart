import 'package:em_chat_uikit/chat_uikit.dart';

mixin ContactActions on ContactWrapper {
  Future<void> sendContactRequest({required String userId, String? reason}) {
    return Client.getInstance.contactManager.addContact(userId, reason: reason);
  }

  Future<void> acceptContactRequest({required String userId}) {
    return Client.getInstance.contactManager.acceptInvitation(userId);
  }

  Future<void> declineContactRequest({required String userId}) {
    return Client.getInstance.contactManager.declineInvitation(userId);
  }

  Future<void> deleteContact({required String userId}) {
    return Client.getInstance.contactManager.deleteContact(userId);
  }

  // TODO: 升级到新版本后不需要这种api，直接返回EMContact更合理；
  Future<List<String>> fetchAllContacts() {
    return Client.getInstance.contactManager.getAllContactsFromServer();
  }

  Future<List<String>> fetchAllBlockedContacts() {
    return Client.getInstance.contactManager.getBlockListFromServer();
  }

  Future<void> addBlockedContact({required String userId}) {
    return Client.getInstance.contactManager.addUserToBlockList(userId);
  }

  Future<void> deleteBlockedContact({required String userId}) {
    return Client.getInstance.contactManager.removeUserFromBlockList(userId);
  }
}
