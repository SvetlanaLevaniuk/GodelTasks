global class CheckIsDeliveryDateExpired implements Database.Batchable<sObject>, Database.Stateful {
    global Integer recordsProcessed = 0;
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
        'SELECT Id, DeliveryDate__c, Expired__c, CreatedById ' +
        'FROM DeliveryOrder__c ' + 
        'WHERE DeliveryDate__c < Date.today()'
        );
    }
    global void execute(Database.BatchableContext bc, List<DeliveryOrder__c> scope) {
        for (DeliveryOrder__c order : scope) {
            if (order.Expired__c == false) {
                order.Expired__c = true;
                recordsProcessed = recordsProcessed + 1;        
            }
        }
        update scope;
    }    
    global void finish(Database.BatchableContext bc) {
    AsyncApexJob job = [SELECT Id, Status, CompletedDate, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :bc.getJobId()];
    String message = 'Dear, ' + UserInfo.getName() + ' ' + recordsProcessed + ' orders with an expired delivery time were processed at the ' + job.CompletedDate;
    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(UserInfo.getUserEmail());
        email.setPlainTextBody(message);
        Messaging.sendEmail(email);

}    
}