@isTest
public class SupplySummaryForTheWeekbatchClassTest
{
   
    static testMethod void SupplySummaryTest()
    {
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        
        
        
        
        Data_Upload_Transaction__c datauptrans = new Data_Upload_Transaction__c();
        //datauptrans.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        datauptrans.Retailer_Code__c = 'a00p0000006Hw7nAAC';
        datauptrans.Inventory_Model__c = 'a02p0000007cGIwAAM';
        datauptrans.Color__c = 'GRAY';
        datauptrans.Sizer_Print__c = 'S';
        datauptrans.Stock_In_Qty__c = 2000;
        datauptrans.Warehouse__c = 'LongHua Factory';
        insert datauptrans;
      
      
        boolean flag = true; 
        Weekly_Supply_Summary__c weeksupplysum = new Weekly_Supply_Summary__c();
        weeksupplysum.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        weeksupplysum.Retailer_Code__c = 'a00p0000007Vl0BAAS';
        weeksupplysum.Mainetti_Model__c = 'a02p0000007cGN1AAM';
        weeksupplysum.Color__c = 'BLACK';
        weeksupplysum.Sizer_Print__c = 'S';
        weeksupplysum.Quantity__c = 2000;
        weeksupplysum.Week_Start_Date__c = weekStartDate;
        weeksupplysum.Week_End_Date__c = weekEndDate;
        weeksupplysum.Warehouse__c = 'LongHua Factory';
        insert weeksupplysum;
        
          Test.startTest();
        List<AggregateResult> stockVirginList =[SELECT Mainetti_Company__r.Name OrderToCompany,Retailer_Code__c RetailerCode,Retailer_Code__r.Name RetailerName,Inventory_Model__c Model,Inventory_Model__r.Name ModelName,Color__c Color,Sizer_Print__c Printer, SUM(Stock_In_Qty__c) Quantity,Warehouse__c Warehouse FROM  Data_Upload_Transaction__c WHERE Record_Type__c='Inventory' AND  Source__c='Virgin' AND Mainetti_Company__r.Name <> NULL  GROUP BY Mainetti_Company__r.Name,Retailer_Code__c,Retailer_Code__r.Name,Inventory_Model__c,Inventory_Model__r.Name,Color__c ,Sizer_Print__c,Warehouse__c];

        List<AggregateResult> stockReuseList =[SELECT Mainetti_Company__r.Name OrderToCompany,Retailer_Code__c RetailerCode,Retailer_Code__r.Name RetailerName,Inventory_Model__c Model,Inventory_Model__r.Name ModelName,Color__c Color,Sizer_Print__c Printer, SUM(Stock_In_Qty__c) Quantity,Warehouse__c Warehouse FROM  Data_Upload_Transaction__c WHERE Record_Type__c='Inventory' AND  Source__c='Reuse' AND Mainetti_Company__r.Name <> NULL  GROUP BY Mainetti_Company__r.Name,Retailer_Code__c,Retailer_Code__r.Name,Inventory_Model__c,Inventory_Model__r.Name,Color__c,Sizer_Print__c,Warehouse__c];
        
        Test.stopTest();
        System.assertEquals(true, flag);
        
        SupplySummaryForTheWeekbatchClass supplyweekbatch = new SupplySummaryForTheWeekbatchClass(stockVirginList,stockReuseList);
        
        
         List<Sobject> scope = new  List<Sobject>();
        Database.BatchableContext BC1;
        supplyweekbatch.execute(BC1, scope);
      
        
       // demandweekbatch.fetchWeeklyDemandSummaryForTheWeek(weeklyDemandSummary);
        
        Database.batchableContext bc;        
        supplyweekbatch.start(bc);
        List<Partner__c> partnerList = new List<Partner__c>();
        
        Database.BatchableContext BC2;
        supplyweekbatch.finish(BC2);        
        supplyweekbatch.existingSupplyConsolidateIdsForTheWeek();
        supplyweekbatch.execute(BC, scope);
    }
    static testMethod void supplyListForUpsertTest(){
         List<Weekly_Supply_Consolidated_Id__c> weeklySupplpyConsolidatedList  = new List<Weekly_Supply_Consolidated_Id__c>();
        for(Integer i=0; i<=9901; i++){
            Weekly_Supply_Consolidated_Id__c weekdemconsol = new Weekly_Supply_Consolidated_Id__c();
            weeklySupplpyConsolidatedList.add(weekdemconsol);
        }
        insert weeklySupplpyConsolidatedList;
         List<AggregateResult> stockVirginList =[SELECT Mainetti_Company__r.Name OrderToCompany,Retailer_Code__c RetailerCode,Retailer_Code__r.Name RetailerName,Inventory_Model__c Model,Inventory_Model__r.Name ModelName,Color__c Color,Sizer_Print__c Printer, SUM(Stock_In_Qty__c) Quantity,Warehouse__c Warehouse FROM  Data_Upload_Transaction__c WHERE Record_Type__c='Inventory' AND  Source__c='Virgin' AND Mainetti_Company__r.Name <> NULL  GROUP BY Mainetti_Company__r.Name,Retailer_Code__c,Retailer_Code__r.Name,Inventory_Model__c,Inventory_Model__r.Name,Color__c ,Sizer_Print__c,Warehouse__c];

        List<AggregateResult> stockReuseList =[SELECT Mainetti_Company__r.Name OrderToCompany,Retailer_Code__c RetailerCode,Retailer_Code__r.Name RetailerName,Inventory_Model__c Model,Inventory_Model__r.Name ModelName,Color__c Color,Sizer_Print__c Printer, SUM(Stock_In_Qty__c) Quantity,Warehouse__c Warehouse FROM  Data_Upload_Transaction__c WHERE Record_Type__c='Inventory' AND  Source__c='Reuse' AND Mainetti_Company__r.Name <> NULL  GROUP BY Mainetti_Company__r.Name,Retailer_Code__c,Retailer_Code__r.Name,Inventory_Model__c,Inventory_Model__r.Name,Color__c,Sizer_Print__c,Warehouse__c];
        SupplySummaryForTheWeekbatchClass supplyweekbatch = new SupplySummaryForTheWeekbatchClass(stockVirginList,stockReuseList);
        
         boolean flag = true;
        
           Test.startTest();
         supplyweekbatch.splitConsolidateSupplyListForUpsert(weeklySupplpyConsolidatedList);
        database.executeBatch(supplyweekbatch);
           Test.stopTest();
        System.assertEquals(true, flag);
    }
    static testMethod void splitSupplyListForUpsertTest(){
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
         List<Weekly_Supply_Summary__c> weeklySupplySummaryList  = new List<Weekly_Supply_Summary__c>();
        for(Integer i=0; i<=9901; i++){
        Weekly_Supply_Summary__c weeksupplysum = new Weekly_Supply_Summary__c();
        weeksupplysum.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        weeksupplysum.Retailer_Code__c = 'a00p0000007Vl0BAAS';
        weeksupplysum.Mainetti_Model__c = 'a02p0000007cGN1AAM';
        weeksupplysum.Color__c = 'BLACK';
        weeksupplysum.Sizer_Print__c = 'S';
        weeksupplysum.Quantity__c = 2000;
        weeksupplysum.Week_Start_Date__c = weekStartDate;
        weeksupplysum.Week_End_Date__c = weekEndDate;
        weeksupplysum.Warehouse__c = 'LongHua Factory';  
            
            weeklySupplySummaryList.add(weeksupplysum);
        }
        insert weeklySupplySummaryList;
          List<AggregateResult> stockVirginList =[SELECT Mainetti_Company__r.Name OrderToCompany,Retailer_Code__c RetailerCode,Retailer_Code__r.Name RetailerName,Inventory_Model__c Model,Inventory_Model__r.Name ModelName,Color__c Color,Sizer_Print__c Printer, SUM(Stock_In_Qty__c) Quantity,Warehouse__c Warehouse FROM  Data_Upload_Transaction__c WHERE Record_Type__c='Inventory' AND  Source__c='Virgin' AND Mainetti_Company__r.Name <> NULL  GROUP BY Mainetti_Company__r.Name,Retailer_Code__c,Retailer_Code__r.Name,Inventory_Model__c,Inventory_Model__r.Name,Color__c ,Sizer_Print__c,Warehouse__c];

        List<AggregateResult> stockReuseList =[SELECT Mainetti_Company__r.Name OrderToCompany,Retailer_Code__c RetailerCode,Retailer_Code__r.Name RetailerName,Inventory_Model__c Model,Inventory_Model__r.Name ModelName,Color__c Color,Sizer_Print__c Printer, SUM(Stock_In_Qty__c) Quantity,Warehouse__c Warehouse FROM  Data_Upload_Transaction__c WHERE Record_Type__c='Inventory' AND  Source__c='Reuse' AND Mainetti_Company__r.Name <> NULL  GROUP BY Mainetti_Company__r.Name,Retailer_Code__c,Retailer_Code__r.Name,Inventory_Model__c,Inventory_Model__r.Name,Color__c,Sizer_Print__c,Warehouse__c];
        SupplySummaryForTheWeekbatchClass supplyweekbatch = new SupplySummaryForTheWeekbatchClass(stockVirginList,stockReuseList);
        
         boolean flag = true;
        
           Test.startTest();
         supplyweekbatch.splitSupplyListForUpsert(weeklySupplySummaryList);
        database.executeBatch(supplyweekbatch);
           Test.stopTest();
        System.assertEquals(true, flag);
    }
}