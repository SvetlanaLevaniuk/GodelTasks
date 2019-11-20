trigger FillGiftDescription on Gift__c (before insert) {
if (trigger.isInsert) {
        FillGiftDescriptionHendler.fillGiftDescriptionUsingHierarchy(trigger.new);
    }
}