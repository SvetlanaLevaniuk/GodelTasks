public with sharing class DeliveryOrderTriggerHelper {
    
    public static void handlerBeforeInsert(List<DeliveryOrder__c> newOrders) {
        Map<Id, DeliveryType__c> ordersWithTypesOfDelivery = getOrdersWithTypesOfDelivery(newOrders);
        for (DeliveryOrder__c order : newOrders) {
            if (order.TypeOfDelivery__c != null) {
                DeliveryType__c delivery = ordersWithTypesOfDelivery.get(order.TypeOfDelivery__c);
                if (order.OverallWeight__c > delivery.MaxTransportationWeight__c) {
                    Integer countOfDeliveryDays =(Integer)(delivery.CountOfDeliveryDays__c *(Math.ceil(order.OverallWeight__c / delivery.MaxTransportationWeight__c)-1));
                    order.DeliveryDate__c += countOfDeliveryDays;
                }
            }
        }
    } 
    
    public static void handlerAfterInsert(List<DeliveryOrder__c> newOrders) {
        EmailTemplate emailTemplate = [
            Select 
            Id,
            Subject,
            Description,
            HtmlValue,
            DeveloperName,
            Body 
            FROM EmailTemplate 
            WHERE Name LIKE 'OrderInfoEmail'
        ];
        User currentUser = [
            SELECT 
            Id, 
            Name, 
            Email 
            FROM User 
            WHERE Id =: UserInfo.getUserId() 
            LIMIT 1
        ];
        for (DeliveryOrder__c order : newOrders) {
            if (order.TypeOfDelivery__c != null) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setTargetObjectId(currentUser.Id);
                email.setToAddresses(new List<String>{currentUser.Email});
                email.setUseSignature(false); 
                email.setBccSender(false); 
                email.setSaveAsActivity(false);
                email.setTemplateId(emailTemplate.Id);
                email.setWhatId(order.Id);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            }
        }
    }
    
    public static void handlerBeforeUpdate(List<DeliveryOrder__c> newOrders, List<DeliveryOrder__c> oldOrders) {
        Date issueDate;
        Map<Id, DeliveryType__c> ordersWithTypesOfDelivery = getOrdersWithTypesOfDelivery(newOrders);
        for (Integer i = 0; i < newOrders.size(); i++) {
            if (newOrders[i].TypeOfDelivery__c != null) {
                DeliveryType__c delivery = ordersWithTypesOfDelivery.get(newOrders[i].TypeOfDelivery__c);
                if (oldOrders[i].OverallWeight__c <= delivery.MaxTransportationWeight__c){
                    issueDate = oldOrders[i].DeliveryDate__c;
                }
                if (oldOrders[i].OverallWeight__c > delivery.MaxTransportationWeight__c){
                    Integer daysToTakeOff =(Integer)(delivery.CountOfDeliveryDays__c * (Math.ceil(oldOrders[i].OverallWeight__c / delivery.MaxTransportationWeight__c)-1));
                    issueDate = oldOrders[i].DeliveryDate__c - daysToTakeOff;
                }            
                Integer daysToAdd =(Integer)(delivery.CountOfDeliveryDays__c * (Math.ceil(newOrders[i].OverallWeight__c / delivery.MaxTransportationWeight__c)-1));
                newOrders[i].DeliveryDate__c = issueDate + daysToAdd;
            }
        }
    }
    
    public static Map<Id, DeliveryType__c> getOrdersWithTypesOfDelivery(List<DeliveryOrder__c> newOrders) {
        Set<Id> orderTypeIds = new Set<Id>();
        for (DeliveryOrder__c order : newOrders) {
            orderTypeIds.add(order.TypeOfDelivery__c);
        }
        List<DeliveryType__c> typesOfDelivery = [SELECT Id, Name, TransportType__c, MaxTransportationWeight__c,
                                                 CountOfDeliveryDays__c, TransportCostPer_1kg__c 
                                                 FROM DeliveryType__c
                                                 WHERE Id IN :orderTypeIds];
        
        Map<Id, DeliveryType__c> deliveryTypesMap = new Map<Id, DeliveryType__c>();
        for (DeliveryType__c type : typesOfDelivery) {
            deliveryTypesMap.put(type.Id, type);
        }
        return deliveryTypesMap;
        
    }
    
    
}