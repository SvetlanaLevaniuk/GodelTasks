trigger DeliveryOrderTrigger on DeliveryOrder__c (before insert, before update) {
    
    if (Trigger.isBefore){        
        if (Trigger.isInsert){
            DeliveryOrderTriggerHelper.handlerBeforeInsert(Trigger.new);
        }
        if (Trigger.isUpdate){
            DeliveryOrderTriggerHelper.handlerBeforeUpdate(Trigger.new, Trigger.old);
        }
    }
}