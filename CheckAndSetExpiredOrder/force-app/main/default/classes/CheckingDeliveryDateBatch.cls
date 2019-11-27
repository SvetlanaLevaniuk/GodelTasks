global class CheckingDeliveryDateBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT ' + 
            'Id, ' +
            'DeliveryDate__c, ' +
            'Expired__c ' +
            'FROM DeliveryOrder__c ' + 
            'WHERE DeliveryDate__c < TODAY ' +
            'AND Expired__c = false'
        );
    }
    
    global void execute(Database.BatchableContext bc, List<DeliveryOrder__c> orders) {
        for (DeliveryOrder__c order : orders) {
            order.Expired__c = true;
        }
        update orders;
    }
    
    global void finish(Database.BatchableContext bc) {
        AsyncApexJob job = [
            SELECT 
                Id, 
                CompletedDate,
                recordsProcessed 
            FROM AsyncApexJob 
            WHERE Id = :bc.getJobId()
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
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new List<String>{currentUser.Email});
        email.setPlainTextBody('Dear ' + currentUser.Name + ' ' + job.recordsProcessed + 
            ' orders with an expired delivery time were processed at the ' + 
            job.CompletedDate);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }
}