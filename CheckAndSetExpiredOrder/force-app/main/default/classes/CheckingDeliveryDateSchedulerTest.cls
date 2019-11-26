@isTest
public with sharing class CheckingDeliveryDateSchedulerTest {

public static List<DeliveryOrder__c> createNewOrders(Integer count) {
    List<DeliveryOrder__c> orders = new List<DeliveryOrder__c>();
        for (Integer i = 0; i < count; i++) {
            orders.add(new DeliveryOrder__c (Name = 'test' + i, DeliveryDate__c = Date.today() - 2, Expired__c = false));
        }
        insert orders;
}



    @isTest
    public static void checkDeliveryDate() {
        List<DeliveryOrder__c> orders = createNewOrders(8);
        test.startTest();
        String jobId = System.schedule('ScheduledApexTest', '0 0/1 * 1/1 * ? *', new CheckingDeliveryDateScheduler());
        test.stopTest();
        List<DeliveryOrder__c> ordersAfterChecking = [SELECT Id, Expired__c FROM DeliveryOrder__c WHERE Expired__c = true];
        System.assertEquals(8, ordersAfterChecking.size());




    }
}
