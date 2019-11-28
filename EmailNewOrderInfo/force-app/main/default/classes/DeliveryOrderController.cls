public with sharing class DeliveryOrderController {
    public List<WrapperClass> wrappers {get;set;}
    public Boolean allBool {get; set;}   
    public Boolean displayPopup {get; set;}
    public String searchStr {get;set;}
    public String sortDirection = 'ASC';
    public String sortExp = 'Name';
    
    public String sortExpression {
        get {
            return sortExp;
        }
        set {
            if (value == sortExp){
                sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
            } else {
                sortDirection = 'ASC';
            }
            sortExp = value;
        }
    }
    
    public String getSortDirection() {                                    //if  column is not selected 
        if (sortExpression == null || sortExpression == '') {
            return 'ASC';
        } else {
            return sortDirection;
        }
    }
    
    public void setSortDirection(String value) {  
        sortDirection = value;
    }
    
    public DeliveryOrderController() {
        wrappers = new List<WrapperClass>();
        viewSortedList();
    }
    
    public void showPopup() {        
        displayPopup = true;    
    }
    
    public Boolean checkIsSringDate(){
        String expression = '(0?[1-9]|1[012])(.|-|\\/)(0?[1-9]|[12][0-9]|3[01])(\\2)((19|20)\\d\\d)';
        return Pattern.compile(expression).matcher(searchStr).find();
    }
    
    public void deleteSelectedOrders() {
        List<DeliveryOrder__c> ordersForDel = new List<DeliveryOrder__c>();
        List<WrapperClass> tempWrappers = new List<WrapperClass>();
        for(WrapperClass wrapperForOrders : wrappers) {
            if(wrapperForOrders.checked) {
                ordersForDel.add(wrapperForOrders.wrapOrder);
            } else {
                tempWrappers.add(wrapperForOrders);
            }
        }
        if(ordersForDel.size() > 0) {
            delete ordersForDel;
            wrappers = tempWrappers;
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Select at least one order to delete'));
        }
    }
    
    public void selectAll() {
        if(allBool) {
            for(WrapperClass w : wrappers) {
                w.checked = true;
            }
        } else {
            for(WrapperClass w : wrappers) {
                w.checked = false;
            }
        }
      }
    
    public void viewSortedList() {
        List<DeliveryOrder__c> orders = new List<DeliveryOrder__c>();
        String sortBy = sortExpression  + ' ' + sortDirection;
        if(wrappers.size()!=0) {
            wrappers.clear();
        }
        if(!(String.isEmpty(searchStr) || searchStr == null)) {
            String additionalCondition = '';
            if (checkIsSringDate()){
                try {
                    Date searchDate = Date.parse(searchStr);
                } catch (Exception e) {
                    apexPages.addmessage(new apexpages.message(apexpages.severity.ERROR, e.getMessage() + '  right format for searching Date is MM/DD/YYYY'));
                }
                additionalCondition = 'WHERE DeliveryDate__c = :searchDate';
            } else if (searchStr.isNumeric()){
                Integer searchPrice = Integer.valueOf(searchStr); 
                additionalCondition = 'WHERE TotalDeliveryCost__c = :searchPrice';
            } else {
                additionalCondition = 'WHERE TypeOfDelivery__r.Name LIKE  \'%' + searchStr +'%\'';
            }
            orders = Database.query('SELECT Name, TypeOfDelivery__r.Name, OverallWeight__c, ' +
                                    'TotalDeliveryCost__c, DeliveryDate__c ' +
                                    'FROM DeliveryOrder__c ' + additionalCondition +
                                    ' ORDER BY ' + sortBy +
                                    ' LIMIT 100'
                                   );
            if(orders.size() == 0) {
                apexPages.addmessage(new apexpages.message(apexpages.severity.ERROR, 'Sorry, no results for you...'));
                return;
            }
        } else {
            orders = Database.query('SELECT Name, TypeOfDelivery__r.Name, OverallWeight__c, ' +
                                    'TotalDeliveryCost__c, DeliveryDate__c ' +
                                    'FROM DeliveryOrder__c ' +
                                    'ORDER BY ' + sortBy +
                                    ' LIMIT 100'
                                   );
        }
        if(orders.size() > 0) {
            for(DeliveryOrder__c order : orders) {
                wrappers.add(new WrapperClass(order));
            }
        }
    }
    
    public class WrapperClass {
        public Boolean checked {get;set;}
        public DeliveryOrder__c wrapOrder {get;set;}
        
        public WrapperClass(DeliveryOrder__c wrapOrder) {
            this.wrapOrder = wrapOrder;
        }
    }
    
    
}