@isTest
public class ShipmentSummaryForTheWeekIterableTest 
{    
    static testMethod void ShipmentSummaryWeekIterableTest(){
        string recType = [SELECT id from RecordType where Name ='Mainetti Company'].Id;
        integer i=0;
        
        Partner__c partner = new Partner__c();
        partner.Default_Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        partner.Partner_Status__c ='Active';
        partner.RecordTypeId = recType;
        insert partner;
        
        ShipmentSummaryForTheWeekIterable Shipmentsummaryitr = new ShipmentSummaryForTheWeekIterable();
        Shipmentsummaryitr.hasNext();
        Shipmentsummaryitr.next();
        Shipmentsummaryitr.iterator();
    }
    
    static testMethod void  hasNext(){
        ShipmentSummaryForTheWeekIterable Shipmentsummaryitr = new ShipmentSummaryForTheWeekIterable();
        Shipmentsummaryitr.hasNext();
    }
    
}