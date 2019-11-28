trigger DeliveryOrderTrigger on DeliveryOrder__c (before insert, before update, after insert) {
    
    if (Trigger.isBefore){        
        if (Trigger.isInsert){
            DeliveryOrderTriggerHelper.handlerBeforeInsert(Trigger.new);
        }
        if (Trigger.isUpdate){
            DeliveryOrderTriggerHelper.handlerBeforeUpdate(Trigger.new, Trigger.old);
        }
    }
    if (Trigger.isAfter) {
        DeliveryOrderTriggerHelper.handlerAfterInsert(Trigger.new);
    }
}