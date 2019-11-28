public class CreateNewOrderPageController {
    public String errorMessage{get; set;}
    public DeliveryOrder__c newOrder{get; set;}
    public Boolean showErrorMessage{get; set;}
    public CreateNewOrderPageController() {
        newOrder = new DeliveryOrder__c();
    }
    
    public List<SelectOption> getTypeOfDelivery() {
        List<SelectOption> options = new List<SelectOption>();
        List<DeliveryType__c> types = [Select Id, Name From  DeliveryType__c Limit 20];
        for( DeliveryType__c t : types) {
            options.add(new SelectOption(t.Id, t.Name));
        }       
        return options;
    }
    
    public PageReference insertNewProductTable() {
        errorMessage = '';
        if (newOrder.Name == null || String.isEmpty(newOrder.Name)) {
            errorMessage += 'Enter your name! ';
        }
        if (newOrder.OverallWeight__c <= 0) {
            errorMessage += 'Wrong weight! ';
        }
        if (newOrder.DeliveryDate__c < Date.today()) {
            errorMessage += 'Wrong date! ';
        }
        if (!String.isEmpty(errorMessage)) {
            showErrorMessage = true;
            return null;
        } else {
            insert newOrder;
            return redirectPopup();
        }
    }
    
    public PageReference redirectPopup() {
        PageReference pageRef = Page.DeliveryOrdersList;
        pageRef.setRedirect(true);
        return PageRef;
    }
    
    
}