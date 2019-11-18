@isTest
public class SharingContactTest {
    
    @isTest
    public static void testSharihgAboveHierarchy() {
        test.startTest();
        addUserRole('President');
        test.stopTest();
        User  userHigher = [SELECT Id FROM User WHERE Alias LIKE 'bossTest' AND LastName LIKE 'Testing']; 
        Contact testContact = createContact();
        System.runAs(userHigher) {
            UserRecordAccess recAccessSharing = [SELECT RecordId, HasEditAccess FROM UserRecordAccess WHERE UserId = :userHigher.Id AND RecordId = :testContact.Id];
            System.assertEquals (userHigher.Id, UserInfo.getUserId());
            System.assertEquals(true, recAccessSharing.HasEditAccess);
        }    
    }
    
    @isTest
    public static void testSharihgLowerHierarchy() {
        test.startTest();
        addUserRole('Seller');
        test.stopTest();
        User  userLower = [SELECT Id FROM User WHERE Alias LIKE 'bossTest' AND LastName LIKE 'Testing']; 
        Contact testContact = createContact();
        System.runAs(userLower) {
            UserRecordAccess recAccessSharing = [SELECT RecordId, HasEditAccess FROM UserRecordAccess WHERE UserId = :userLower.Id AND RecordId = :testContact.Id];
            System.assertEquals (userLower.Id, UserInfo.getUserId());
            System.assertEquals(false, recAccessSharing.HasEditAccess);
        }  
    } 
    
    @future
    public static void addUserRole(String roleName){ 
        Id roleId = [SELECT Id FROM UserRole WHERE Name LIKE :roleName].Id;
        Profile userProfile = [SELECT Id FROM Profile WHERE Name='systemCopy']; 
        User userTest = new User(Alias = 'bossTest', Email='boss@testorg.com', 
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey = 'en_US', 
                                 LocaleSidKey='en_US', ProfileId = userProfile.Id, UserRoleId = roleId,
                                 TimeZoneSidKey='America/Los_Angeles', UserName='boss@testorg.com');
        insert userTest;  
    }
    
    public static Contact createContact(){
        Account testAccount = new Account(Name = 'AccForTesting');
        insert testAccount;
        Contact testContact = new Contact(Lastname = 'ConForTesting', AccountId = testAccount.Id);
        insert testContact;
        return testContact;
    }
    
}