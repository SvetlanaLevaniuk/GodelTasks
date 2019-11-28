@isTest
public class TestDeliveryOrderApplication {
    public static void createOrdersAndTypesOfDelivery() {
        DeliveryType__c typeRoad = new DeliveryType__c (Name = 'Road transport, Peugeot Boxer Van III', TransportType__c = 'truck', 
                                                        MaxTransportationWeight__c = 3500,
                                                        CountOfDeliveryDays__c = 3, TransportCostPer_1kg__c = 1);
        DeliveryType__c typeAir = new DeliveryType__c (Name = 'Air transportation, Saab 340', TransportType__c = 'plane', 
                                                       MaxTransportationWeight__c = 7000,
                                                       CountOfDeliveryDays__c = 2, TransportCostPer_1kg__c = 2);
        DeliveryType__c typeSea = new DeliveryType__c (Name = 'Sea transportation, Titanic', TransportType__c = 'liner', 
                                                       MaxTransportationWeight__c = 30000,
                                                       CountOfDeliveryDays__c = 22, TransportCostPer_1kg__c = 1);
        insert typeRoad; 
        insert typeAir; 
        insert typeSea;
        List<DeliveryOrder__c> orderList = new List<DeliveryOrder__c>();
        DeliveryOrder__c orderA = new DeliveryOrder__c (Name = 'Atlant', TypeOfDelivery__c = typeRoad.Id, OverallWeight__c = 6000,
                                                        DeliveryDate__c = Date.today());
        orderList.add(orderA);
        DeliveryOrder__c orderB = new DeliveryOrder__c(Name = 'Cat', TypeOfDelivery__c = typeAir.Id, OverallWeight__c = 12000,
                                                       DeliveryDate__c = Date.today() + 10);
        orderList.add(orderB);
        DeliveryOrder__c orderC = new DeliveryOrder__c(Name = 'Board', TypeOfDelivery__c = typeRoad.Id, OverallWeight__c = 3500,
                                                       DeliveryDate__c = Date.today() + 2);
        orderList.add(orderC);
        insert orderList;
    }
    
    //---------------------TEST APEX CONTROLLER------------------- 
    
    @isTest
    static void viewSortedListTest() {
        DeliveryOrderController controller = new DeliveryOrderController();
        createOrdersAndTypesOfDelivery();
        
        controller.viewSortedList();
        System.assertEquals (3, controller.wrappers.size());
        System.assertEquals ('Atlant', controller.wrappers.get(0).wrapOrder.Name);
        System.assertEquals ('Board', controller.wrappers.get(1).wrapOrder.Name);
        System.assertEquals ('Cat', controller.wrappers.get(2).wrapOrder.Name);
        
        controller.sortExp = 'TotalDeliveryCost__c';
        controller.sortDirection = 'ASC';
        controller.getSortDirection();
        controller.viewSortedList();
        System.assertEquals ('Board', controller.wrappers.get(0).wrapOrder.Name);
        System.assertEquals ('Atlant', controller.wrappers.get(1).wrapOrder.Name);
        System.assertEquals ('Cat', controller.wrappers.get(2).wrapOrder.Name);
        
        controller.searchStr = 'aab';
        controller.viewSortedList();
        System.assertEquals (1, controller.wrappers.size());
        System.assertEquals ('Cat', controller.wrappers.get(0).wrapOrder.Name);
        controller.searchStr = '6000';
        controller.viewSortedList();
        System.assertEquals (1, controller.wrappers.size());
        System.assertEquals (6000, controller.wrappers.get(0).wrapOrder.TotalDeliveryCost__c);
        controller.searchStr = '1.10.2020'; // check if Data.parse() catch Exception
        controller.viewSortedList();
        System.assertEquals (0, controller.wrappers.size());
    }
    
    @isTest
    static void testDeleteSelectedOrders(){
        DeliveryOrderController controller = new DeliveryOrderController();
        createOrdersAndTypesOfDelivery();
        controller.viewSortedList();
        System.assertEquals (3, controller.wrappers.size());
        controller.allBool = false;
        controller.selectAll();
        controller.deleteSelectedOrders();
        System.assertEquals (3, controller.wrappers.size());
        controller.allBool = true;
        controller.selectAll();
        controller.deleteSelectedOrders();
        System.assertEquals (0, controller.wrappers.size());
    }
    
    //-----------------------TEST CreateNewOrderPageController_---------------------------
    @isTest
    public static void testInsertNewProductTable() {
        CreateNewOrderPageController controllerForNewOrder = new CreateNewOrderPageController();
        DeliveryOrderController controller = new DeliveryOrderController();
        DeliveryType__c typeD = new DeliveryType__c (Name = 'Road transport, Peugeot Boxer Van III', TransportType__c = 'truck', 
                                                     MaxTransportationWeight__c = 3500,
                                                     CountOfDeliveryDays__c = 3, TransportCostPer_1kg__c = 1);
        insert typeD;
        DeliveryOrder__c rightOrder = new DeliveryOrder__c (Name = 'Atlant', TypeOfDelivery__c = typeD.Id, OverallWeight__c = 6000, DeliveryDate__c = Date.today()+10);
        controllerForNewOrder.newOrder = rightOrder;
        controller.viewSortedList();
        System.assertEquals (0, controller.wrappers.size());
        controllerForNewOrder.insertNewProductTable();
        controller.viewSortedList();
        System.assertEquals (1, controller.wrappers.size());
        System.assertEquals ('Atlant', controller.wrappers.get(0).wrapOrder.Name);
        
        DeliveryOrder__c wrongNameOrder = new DeliveryOrder__c (TypeOfDelivery__c = typeD.Id, OverallWeight__c = 3000, DeliveryDate__c = Date.today()+5);
        controllerForNewOrder.newOrder = wrongNameOrder;
        controller.viewSortedList();
        System.assertEquals (1, controller.wrappers.size());
        controllerForNewOrder.insertNewProductTable();
        controller.viewSortedList();
        System.assertEquals (1, controller.wrappers.size());
        System.assertEquals ('Atlant', controller.wrappers.get(0).wrapOrder.Name);
        
        DeliveryOrder__c wrongWeightOrder = new DeliveryOrder__c (Name = 'WrongWeight', TypeOfDelivery__c = typeD.Id, OverallWeight__c = -3000, DeliveryDate__c = Date.today()+5);
        controllerForNewOrder.newOrder = wrongWeightOrder;
        controller.viewSortedList();
        System.assertEquals (1, controller.wrappers.size());
        controllerForNewOrder.insertNewProductTable();
        controller.viewSortedList();
        System.assertEquals (1, controller.wrappers.size());
        System.assertEquals ('Atlant', controller.wrappers.get(0).wrapOrder.Name);
        
        DeliveryOrder__c wrongDateOrder = new DeliveryOrder__c (Name = 'WrongDate', TypeOfDelivery__c = typeD.Id, OverallWeight__c = 3000, DeliveryDate__c = Date.today()-5);
        controllerForNewOrder.newOrder = wrongDateOrder;
        controller.viewSortedList();
        System.assertEquals (1, controller.wrappers.size());
        controllerForNewOrder.insertNewProductTable();
        controller.viewSortedList();
        System.assertEquals (1, controller.wrappers.size());
        System.assertEquals ('Atlant', controller.wrappers.get(0).wrapOrder.Name);
    }
    
    @isTest
    public static void testGetTypeOfDelivery() {
        CreateNewOrderPageController controllerForNewOrder = new CreateNewOrderPageController();
        createOrdersAndTypesOfDelivery();
        List<SelectOption> typesOfDelivery = controllerForNewOrder.getTypeOfDelivery();
        List<String> typesName = new List<String>();
        for( SelectOption option : typesOfDelivery) {
            typesName.add(option.getLabel());
        }
        System.assertEquals(3, typesOfDelivery.size());
        System.assertEquals('Road transport, Peugeot Boxer Van III', typesName.get(0));
        System.assertEquals('Air transportation, Saab 340', typesName.get(1));
        System.assertEquals('Sea transportation, Titanic', typesName.get(2));
    }
    
    //---------------------TEST APEX TRIGGER-------------------
    @isTest
    static void testHandlerBeforeInsertBeforeUpdate() {
        DeliveryType__c typeRoad= new DeliveryType__c ( Name = 'Road transport, Peugeot Boxer Van III', TransportType__c = 'truck', 
                                                       MaxTransportationWeight__c = 3500,
                                                       CountOfDeliveryDays__c = 3, TransportCostPer_1kg__c = 1);
        insert typeRoad;
        DeliveryOrder__c orderBiggerMaxWeight = new DeliveryOrder__c(Name = 'Atlant', TypeOfDelivery__c = typeRoad.Id, OverallWeight__c = 6000,
                                                                     DeliveryDate__c = Date.today());
        DeliveryOrder__c orderLessMaxWeight = new DeliveryOrder__c(Name = 'Delfy', TypeOfDelivery__c = typeRoad.Id, OverallWeight__c = 3000,
                                                                   DeliveryDate__c = Date.today());
        DeliveryOrder__c orderMaxWeight = new DeliveryOrder__c(Name = 'Monty', TypeOfDelivery__c = typeRoad.Id, OverallWeight__c = 3500,
                                                               DeliveryDate__c = Date.today());
        insert orderBiggerMaxWeight;      
        insert orderLessMaxWeight;
        insert orderMaxWeight;
        DeliveryOrder__c orderBiggerMaxWeightAfterInsert = [SELECT Id, DeliveryDate__c From DeliveryOrder__c WHERE Id = :orderBiggerMaxWeight.Id];
        DeliveryOrder__c orderLessMaxWeightAfterInsert = [SELECT Id, DeliveryDate__c From DeliveryOrder__c WHERE Id = :orderLessMaxWeight.Id];
        DeliveryOrder__c orderMaxWeightAfterInsert = [SELECT Id, DeliveryDate__c From DeliveryOrder__c WHERE Id = :orderMaxWeight.Id];
        System.assertEquals((Date.today() + 3), orderBiggerMaxWeightAfterInsert.DeliveryDate__c);
        System.assertEquals(Date.today(), orderLessMaxWeightAfterInsert.DeliveryDate__c);
        System.assertEquals(Date.today(), orderMaxWeightAfterInsert.DeliveryDate__c);
        
        orderLessMaxWeightAfterInsert.OverallWeight__c = 8000;
        orderBiggerMaxWeightAfterInsert.OverallWeight__c = 11000;
        update orderLessMaxWeightAfterInsert;
        update orderBiggerMaxWeightAfterInsert;
        DeliveryOrder__c orderLessMaxWeightAfterUpdate = [SELECT Id, DeliveryDate__c From DeliveryOrder__c WHERE Id = :orderLessMaxWeight.Id];
        DeliveryOrder__c orderBiggerMaxWeightAfterUpdate = [SELECT Id, DeliveryDate__c From DeliveryOrder__c WHERE Id = :orderBiggerMaxWeight.Id];
        System.assertEquals((Date.today() + 6), orderLessMaxWeightAfterUpdate.DeliveryDate__c);
        System.assertEquals((Date.today() + 9), orderBiggerMaxWeightAfterUpdate.DeliveryDate__c);
        
        orderLessMaxWeightAfterUpdate.OverallWeight__c = 5000;
        orderBiggerMaxWeightAfterUpdate.OverallWeight__c = 3000;
        update orderBiggerMaxWeightAfterUpdate;
        update orderLessMaxWeightAfterUpdate;
        DeliveryOrder__c orderLessMaxWeightAfterSecondUpdate = [SELECT Id, DeliveryDate__c From DeliveryOrder__c WHERE Id = :orderLessMaxWeight.Id];
        DeliveryOrder__c orderBiggerMaxWeightAfterSecondUpdate = [SELECT Id, DeliveryDate__c From DeliveryOrder__c WHERE Id = :orderBiggerMaxWeight.Id];
        System.assertEquals((Date.today() + 3), orderLessMaxWeightAfterSecondUpdate.DeliveryDate__c);
        System.assertEquals(Date.today(), orderBiggerMaxWeightAfterSecondUpdate.DeliveryDate__c);
    }    
    
    
    
    
}