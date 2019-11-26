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
    AsyncApexJob job = [SELECT Id, Status, CompletedDate FROM AsyncApexJob WHERE Id = :bc.getJobId()];
    User currentUser = [SELECT Id, Name, Email FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
		email.setToAddresses(new List<String>{currentUser.Email});
		email.setPlainTextBody('Dear ' + currentUser.Name + ' ' + recordsProcessed + 'orders with an expired delivery time were processed at the ' + job.CompletedDate);
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
	}
}