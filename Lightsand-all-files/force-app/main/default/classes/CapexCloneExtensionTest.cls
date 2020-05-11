@isTest public class CapexCloneExtensionTest{
	public static String budgtedRecordTypeId = '01290000000SVCF';
    public static String budgetedCapexId = 'a0D900000085l2u';
   @IsTest(SeeAllData=true) public static void genericTest1(){
        Capex__c capex = [select Id from Capex__c where Id=:budgetedCapexId];
       capex.Budget_Invested__c = false;
       update capex;
       //delete [select Id from Capex__c where Budgeted_Capex__c=:capex.Id];
        ApexPages.StandardController stdController = new ApexPages.StandardController(capex);
        CapexCloneExtension ext = new CapexCloneExtension(stdController);
        ext.init();
      
           
	} 
    @IsTest(SeeAllData=true) public static void genericTest2(){
         Capex__c capex = [select Id from Capex__c where Id=:budgetedCapexId];
         capex.Capex_Category__c = 'Mould for New Business/New Production';
         capex.Budget_Invested__c = false;
      update capex;
       ApexPages.StandardController stdController1 = new ApexPages.StandardController(capex);
        CapexCloneExtension ext1 = new CapexCloneExtension(stdController1);
       ext1.init();
    } 
}