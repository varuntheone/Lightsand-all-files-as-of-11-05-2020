@isTest
public class DemandSummaryForTheWeekIterableTest 
{    
    static testMethod void DemandSummaryWeekIterableTest(){
        string recType = [SELECT id from RecordType where Name ='Mainetti Company'].Id;
        integer i=0;
        
        Partner__c partner = new Partner__c();
        partner.Default_Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        partner.Partner_Status__c ='Active';
        partner.RecordTypeId = recType;
        insert partner;
        
        DemandSummaryForTheWeekIterable demandsummaryitr = new DemandSummaryForTheWeekIterable();
        demandsummaryitr.hasNext();
        demandsummaryitr.next();
        demandsummaryitr.iterator();
    }
    
    static testMethod void  hasNext(){
        DemandSummaryForTheWeekIterable demandsummaryitr = new DemandSummaryForTheWeekIterable();
        demandsummaryitr.hasNext();
    }
    
}