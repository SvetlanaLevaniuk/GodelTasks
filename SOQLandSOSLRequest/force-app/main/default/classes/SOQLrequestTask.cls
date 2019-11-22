public with sharing class SOQLrequestTask {
    // Написать SOQL запрос для получения таблицы из объекта Contact c полями Id, Name, а также поле Name связанного с ним Аккаунта где LastName ‘Leon’   
    public static List<Contact> getContactsWhereLastnameLeon() { // 
        return [SELECT Id, Name, Account.Name FROM Contact WHERE LastName LIKE '\'Leon\''];
    }
    
    // Написать SOQL запрос для получения таблицы из объекта Contact c полями Id, Name, а также поле Name связанного с ним Аккаунта где LastName будет начинаться с G’  
    public static List<Contact> getContactsWhereLastnameBeginsWithG() {
        return [SELECT Id, Name, Account.Name FROM Contact WHERE LastName LIKE 'G%'];
    }
    
    //Написать SOQL запрос для получения таблицы из объекта Contact c полями Id, Name, а также поле Name связанного с ним Аккаунта и отсортировать по LastName(возрастание)
    public static List<Contact> getContactsSortedByLastname() {
      return  [SELECT Id, Name, Account.Name FROM Contact ORDER BY LastName ASC];
    }
    
    //Написать SOQL запрос для получения таблицы из объекта Contact c полями Id, Name, а также поле Name связанного с ним Аккаунта где FirstName Godel или LastName Brest
    public static List<Contact> getContactsGodelBrest() {
      return [SELECT Id, Name, Account.Name FROM Contact WHERE FirstName LIKE 'Godel' AND LastName LIKE 'Brest'];
    }
    
    //Написать SOQL запрос для получения таблицы из объекта Opportunity с Amount более 200.000
    public static List<Opportunity> getOpportunities() {
       return  [SELECT Id, Account.Name, Amount FROM Opportunity WHERE Amount > 200000];
    }
    
    //Написать SOQL запрос для получения таблицы из объекта Account у которой есть контакты
   public static List<Account> getAccounts() {
      return  [SELECT Id, Name FROM Account WHERE Id IN (SELECT AccountId FROM Contact)];
    }
    
    //Написать SOQL запрос для получения таблицы из объекта Gift с полями Id, Name, а также поле Name связанного с ними User’a
    public static List<Gift__c> getGift() {
      return  [SELECT Id, Name, Gift_Recipient__r.Username FROM Gift__c];
    }
    
    //Написать SOQL запрос для получения таблицы из объекта Account c полем Name у которой есть контакты, а также поля Id и Name Контактов
    public static List<Account> getAccountsWithContacts() {
      return  [SELECT Name, (SELECT Id, Name FROM contacts) FROM Account WHERE Id IN (SELECT AccountId FROM Contact)];
    }   
    
    //Написать SOSL запрос, который возвращает Имя и Номер телефона контакта, который содержит в себе код 33
   public static  List<List<Contact>> getContacts() {
     List<List<Contact>> contacts = [FIND '-33-' IN PHONE FIELDS RETURNING Contact (Name, MobilePhone)];
     return contacts;
   }
    
    
}