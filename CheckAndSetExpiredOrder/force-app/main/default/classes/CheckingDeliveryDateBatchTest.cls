@isTest
public with sharing class CheckingDeliveryDateBatchTest {

    public static Integer COUNT = 202;
    
    @TestSetup
    public static void createNewOrders() {
        List<DeliveryOrder__c> orders = new List<DeliveryOrder__c>();
        for (Integer i = 0; i < COUNT; i++) {
            orders.add(new DeliveryOrder__c (Name = 'test' + i, DeliveryDate__c = Date.today()-2, Expired__c = false));
        }
        insert orders;
    }
    
    @isTest
    public static void checkDeliveryDateBatch() {
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
        System.assertEquals(202, ordersAfterChecking.size());
    }
}
