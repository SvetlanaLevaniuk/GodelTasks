public with sharing class DeliveryOrderPdfController {
    public List<Id> usingTypesId { get; set; }
    public List<DeliveryType__c> usingDeliveryTypes {
        get {
            return [
                SELECT
                    Id
                FROM DeliveryType__c
                WHERE Id IN (SELECT TypeOfDelivery__c FROM DeliveryOrder__c)
                LIMIT 100
            ];
        }
        set; 
    }
    
    public DeliveryOrderPdfController(){
       usingTypesId = setUsingTypesIdList();
    }
    
    public List<Id> setUsingTypesIdList() {
        List<Id> typesId = new List<Id>();
        if (usingDeliveryTypes.size() > 0) {
            for (DeliveryType__c item : usingDeliveryTypes) {
                typesId.add(item.Id);
            }
        }
        return typesId;
    }   

   
}