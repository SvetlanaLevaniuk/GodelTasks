global with sharing class PlanEverydayChekingForExpiredDate  implements Schedulable {
    global void execute(SchedulableContext ctx) {
        CheckIsDeliveryDateExpired batchClass = new CheckIsDeliveryDateExpired();
        Database.executeBatch(batchClass, 200);
    }
}
