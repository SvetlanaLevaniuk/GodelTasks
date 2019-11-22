public with sharing class ContactTriggerAddOperatorToMobileHendler {
    public static void addMobileOperatorToContact(List<Contact> newContacts) {
        map<String, String> codesVsOperators = createMapOfOperatorsVsCode();
        for (Contact newContact : newContacts) {
            if (!String.isEmpty(newContact.MobilePhone) && Pattern.compile('.+375-[0-9]{2}-[0-9]{7}').matcher(newContact.MobilePhone).find()) {
                String numberCode = newContact.MobilePhone.split('-').get(1);
                if (codesVsOperators.containsKey(numberCode)) {
                    newContact.Mobile_Operator__c = codesVsOperators.get(numberCode); 
                } 
            }
        }
    }
    
    public static map<String, String> createMapOfOperatorsVsCode() {
        List<Mobile_Operator_Code__mdt> mobileOperators = [SELECT Label, Phone_Number_Code__c  FROM Mobile_Operator_Code__mdt];
        map<String, String> codesVsOperators = new map <String, String>();
        if(mobileOperators.size() > 0) {
            for (Mobile_Operator_Code__mdt operatorCods : mobileOperators) {
                codesVsOperators.put(operatorCods.Phone_Number_Code__c, operatorCods.Label);
            }
        }
        return codesVsOperators;
    }
}