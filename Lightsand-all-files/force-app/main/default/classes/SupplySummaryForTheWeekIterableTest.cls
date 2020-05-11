@isTest
public class SupplySummaryForTheWeekIterableTest
{
    static testMethod void SupplySummaryItrTest(){
        string recType = [SELECT id from RecordType where Name ='Mainetti Company'].Id;
        integer i=0;
        
        Partner__c partner = new Partner__c();
        partner.Default_Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        partner.Partner_Status__c ='Active';
        partner.RecordTypeId = recType;
        insert partner;
        
        SupplySummaryForTheWeekIterable supplyitr = new SupplySummaryForTheWeekIterable();
        supplyitr.hasNext();
        supplyitr.iterator();
        supplyitr.next();
    }
    static testMethod void  hasNext(){
        SupplySummaryForTheWeekIterable supplyitr = new SupplySummaryForTheWeekIterable();
        supplyitr.hasNext();
        
    }
}