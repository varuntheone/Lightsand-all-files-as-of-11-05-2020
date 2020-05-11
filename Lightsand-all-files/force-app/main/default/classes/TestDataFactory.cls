@isTest
public class TestDataFactory {
    public static void create()
        {
            Partner__c partner = new Partner__c(Name = 'Mainetti (HK) Ltd', Default_Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd');
            insert partner;
        }

}