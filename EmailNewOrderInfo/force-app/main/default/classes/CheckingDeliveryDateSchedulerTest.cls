@isTest
public with sharing class CheckingDeliveryDateSchedulerTest {
    
    public static List<DeliveryOrder__c> createNewOrders(Integer count) {
        List<DeliveryOrder__c> orders = new List<DeliveryOrder__c>();
        for (Integer i = 0; i < count; i++) {
            orders.add(new DeliveryOrder__c (Name = 'test' + i, DeliveryDate__c = Date.today()-2, Expired__c = false));
        }
        insert orders;
        return orders;
    }
    
    @isTest
    public static void checkDeliveryDateBatch() {
        List<DeliveryOrder__c> orders = createNewOrders(8);
        test.startTest();
        Id batchId = Database.executeBatch(new CheckingDeliveryDateBatch());
        test.stopTest();
        List<DeliveryOrder__c> ordersAfterChecking = [
            SELECT
            	Id,
            	Expired__c 
            FROM DeliveryOrder__c 
            WHERE Expired__c = true
        ];
        System.assertEquals(8, ordersAfterChecking.size());
    }
    
    @isTest
    public static void checkDeliveryDateScheduler() {
        List<AsyncApexJob> jobsScheduled = [
            SELECT 
                Id
            FROM AsyncApexJob
            WHERE JobType = 'ScheduledApex'
        ];
        System.assertEquals(0, jobsScheduled.size());
        test.startTest();
        String jobId = System.schedule('ScheduledApexTest', '0 0 0 1/1 * ? *', new CheckingDeliveryDateScheduler());
        test.stopTest();
        jobsScheduled = [
            SELECT 
                Id,
                ApexClass.Name
            FROM AsyncApexJob
            WHERE JobType = 'ScheduledApex'
        ];
        System.assertEquals(1, jobsScheduled.size());
        System.assertEquals('CheckingDeliveryDateScheduler', jobsScheduled[0].ApexClass.Name);
    }
}