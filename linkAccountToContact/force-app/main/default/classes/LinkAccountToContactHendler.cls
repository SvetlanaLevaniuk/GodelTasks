public with sharing class LinkAccountToContactHendler {
    public static void linkAccountToContact(List<Contact> newContacts){
        AccountLinking__c  accountWithEmailId = AccountLinking__c.getValues('FilledContactEmail');
        AccountLinking__c  accountMissingEmailId = AccountLinking__c.getValues('MissedContactEmail');
        for (Contact newContact : newContacts) {
            if (newContacts.size() == 1 && newContact.AccountId != null) {
                if (newContact.Email != null) {
                    accountWithEmailId.DefaultAccountId__c = newContact.AccountId;
                } 
                if (newContact.Email == null) {
                    accountMissingEmailId.DefaultAccountId__c = newContact.AccountId;
                }
                update accountWithEmailId;
                update accountMissingEmailId;
            }
            if (newContact.AccountId == null) {
                if (newContact.Email == null) {
                    newContact.AccountId = accountMissingEmailId.DefaultAccountId__c;
                } 
                if (newContact.Email != null) {
                    newContact.AccountId = accountWithEmailId.DefaultAccountId__c;
                }                
            }
        }
    }
}