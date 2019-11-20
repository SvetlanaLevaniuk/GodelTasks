public with sharing class FillGiftDescriptionHendler {
public static void fillGiftDescriptionUsingHierarchy(List<Gift__c> newGifts) {
    for (Gift__c gift : newGifts){
        Gifts__c  gifts = Gifts__c.getInstance(gift.Gift_Recipient__c);
        String gifToUser = gifts.Gift__c;
        gift.Gift_Description__c = gifToUser;
    }
}
}