public with sharing class SharingContactTriggerHelper {
    
    public static Set<ID> getParentRoleId(Set<ID> roleIds) {       // get all parent for our user
        Set<ID> currentRoleIds = new Set<ID>();
        for(UserRole userRole :[SELECT Id, ParentRoleId FROM UserRole WHERE Id IN: roleIds AND ParentRoleId != null]) {
            currentRoleIds.add(userRole.ParentRoleId);
        }
        if(currentRoleIds.size() > 0) {
            currentRoleIds.addAll(getParentRoleId(currentRoleIds));
        }
        return currentRoleIds;
    }
    
    public static List<User> getUsersOver(Id userRoleId) {        //get all users above our user role
        Set<Id> userIdSet = new Set<Id>();
        userIdSet.add(userRoleId);
        Set<ID> parentIdSet = getParentRoleId(new Set<Id>(userIdSet));
        return [SELECT Id FROM User WHERE UserRoleId IN :parentIdSet];
    }
    
    public static void addAccessForSharingContacts (List<Contact> newContacts) {
        List<ContactShare> contactsForSharing = new List<ContactShare>();
        Id userRodeId = [SELECT Id, UserRoleId FROM User WHERE Id = :UserInfo.getUserId()].UserRoleId;
        List<User> usersAboveHierarhy = getUsersOver(userRodeId);
        for (Contact contact : newContacts) {
            for (User user : usersAboveHierarhy) { 
                ContactShare contactSharing = new ContactShare();
                contactSharing.ContactId = contact.Id;
                contactSharing.UserOrGroupId = user.Id;
                contactSharing.ContactAccessLevel = 'Edit';
                contactSharing.RowCause = 'Manual';
                contactsForSharing.add(contactSharing);
            }
        }
        Database.SaveResult[] contactShareInsertResult = Database.insert(contactsForSharing, false);
    }
    
}