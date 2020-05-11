@isTest
public class deleteTheRecordsBasedonIdTest {
   
    static testMethod void testMethod1() 
    {
        
      /*  List<Sales_Transaction_Stage__c> records = new List<Sales_Transaction_Stage__c>();
        for(Integer i=0 ;i <200;i++)
        {*/
            Sales_Transaction_Stage__c records = new Sales_Transaction_Stage__c();
            records.Color__c ='BLACK';
			  insert records;		
       // }
      

        
        Test.startTest();        
        deleteTheRecordsBasedonId obj = new deleteTheRecordsBasedonId('a1Np000000IxdzyEAB');
           List<Sales_Transaction_Stage__c> salesTransStage = new  List<Sales_Transaction_Stage__c>();
        Database.BatchableContext BC1;
        obj.execute(BC1, salesTransStage);
        DataBase.executeBatch(obj);         
        Test.stopTest();
    }
    
}