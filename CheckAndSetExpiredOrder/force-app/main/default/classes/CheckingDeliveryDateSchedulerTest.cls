@isTest
public with sharing class CheckingDeliveryDateSchedulerTest {
    
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
        System.schedule('ScheduledApexTest', '0 0 0 1/1 * ? *', new CheckingDeliveryDateScheduler());
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