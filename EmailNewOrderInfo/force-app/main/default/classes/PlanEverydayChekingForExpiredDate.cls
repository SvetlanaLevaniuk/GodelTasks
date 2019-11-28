global with sharing class PlanEverydayChekingForExpiredDate implements Schedulable {
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new CheckIsDeliveryDateExpired(), 200);
    }
}