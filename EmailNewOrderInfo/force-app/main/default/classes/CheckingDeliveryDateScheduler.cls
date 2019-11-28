global with sharing class CheckingDeliveryDateScheduler  implements Schedulable {
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new CheckingDeliveryDateBatch(), 200);
    }
}