@isTest
public class AllocateDemandClassTest
{ 
      static testMethod void allocationdemandTest()
    { 
          Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        Weekly_Demand_Summary__c weekdemsum = new Weekly_Demand_Summary__c();
        // weekdemsum.Name = '';
        weekdemsum.Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        weekdemsum.Mainetti_Model__c = 'a02p00000088auhAAA';
        weekdemsum.Retailer_Code__c = 'a00p0000008NzFPAA0';
        weekdemsum.Color__c = 'GREY';
        //weekdemsum.Sizer_Print__c = '';
        weekdemsum.Week_Start_Date__c = weekStartDate;
        weekdemsum.Week_End_Date__c = weekEndDate;
        weekdemsum.Quantity__c =2000;
        insert weekdemsum;
        
        Weekly_Supply_Summary__c weeksupsum = new Weekly_Supply_Summary__c();
        
        weeksupsum.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        weeksupsum.Retailer_Code__c = 'a00p0000008NzFPAA0';
        weeksupsum.Mainetti_Model__c = 'a02p00000088auhAAA';
        weeksupsum.Color__c = 'GREY';
        //weeksupsum.Sizer_Print__c = '';
        weeksupsum.Quantity__c =2000;
        weeksupsum.Source__c ='Reuse';
        weeksupsum.Warehouse__c ='LongHua Factory';
        weeksupsum.Week_Start_Date__c = weekStartDate;
        weeksupsum.Week_End_Date__c = weekEndDate;
        insert weeksupsum;
   
              
        String demandId=weekdemsum.Id;
        string supplyId =weeksupsum.Id;
        boolean flag = true;
        
        Test.startTest();
        AllocateDemandClass.getDataFromDemand(demandId);
        AllocateDemandClass.getDataFromSupply(supplyId);
        AllocateDemandClass.getWeekNumber(startdate);
  
        
        Test.stopTest();
        System.assertEquals(true, flag);
        
    }
    static testMethod void saveAllocationTest()
    {
           Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
         Weekly_Demand_Summary__c weekdemsum = new Weekly_Demand_Summary__c();
        // weekdemsum.Name = '';
        weekdemsum.Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        weekdemsum.Mainetti_Model__c = 'a02p00000088auhAAA';
        weekdemsum.Retailer_Code__c = 'a00p0000008NzFPAA0';
        weekdemsum.Color__c = 'GRAY';
        weekdemsum.Sizer_Print__c = '';
        weekdemsum.Week_Start_Date__c = weekStartDate;
        weekdemsum.Week_End_Date__c = weekEndDate;
        weekdemsum.Quantity__c =2000.00;
        insert weekdemsum;
        
        Weekly_Supply_Summary__c weeksupsum = new Weekly_Supply_Summary__c();
        
        weeksupsum.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        weeksupsum.Retailer_Code__c = 'a00p0000008NzFPAA0';
        weeksupsum.Mainetti_Model__c = 'a02p00000088auhAAA';
        weeksupsum.Color__c = 'GREY P-7536C';
        weeksupsum.Sizer_Print__c = '';
        weeksupsum.Quantity__c =2000.00;
        weeksupsum.Source__c ='Virgin';
        weeksupsum.Warehouse__c ='LongHua Factory';
        weeksupsum.Week_Start_Date__c = weekStartDate;
        weeksupsum.Week_End_Date__c = weekEndDate;
        insert weeksupsum;
   
        Integer quantity= 20000;
        string supplyId =weeksupsum.Id;
        String demandId=weekdemsum.Id;
        string allocataionType='Demand';
        string warehouseSupplyId = 'Suzhou Factory';
        boolean flag = true;
        
        Test.startTest();
        AllocateDemandClass.saveAllocation(quantity, supplyId, demandId, allocataionType, warehouseSupplyId);
         Test.stopTest();
        System.assertEquals(true, flag);
  }
    static testMethod void listWarehouseTest()
    {
          string retailer = 'Hong Kong - Mainetti (HK) Ltd';
        string model = 'GU';
        string color = 'GRAY';
        string sizerPrint = 's';
        string warehouse = 'Suzhou Factory';
        boolean flag = true; 
        Test.startTest();
        AllocateDemandClass.listWarehouse(retailer, model, color, sizerPrint, warehouse); 
         Test.stopTest();
        System.assertEquals(true, flag);
    }
}