@isTest
public class viewDemandForecastControllerTest {
    static testMethod void fetchDemandForecastBySearchTest() {
        
        
        Date startdate = date.today();
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        //system.debug('weekStartDate:'+weekStartDate);
        //system.debug('weekEndeDate:'+weekEndDate);
        
        
        String mainettiCompany; //= 'Hong Kong - Mainetti (HK) Ltd';
        String retailerCode;
        String modelName;
        String weekStart = String.valueOf(weekStartDate);
        String weekEnd = String.valueOf(weekEndDate);
        boolean onlyShortFallRecords = false;
        Integer pageNumber = 1;
        Integer recordToDisplay = 10;
        boolean isCurrentWeek = true;
        boolean isCurrentWeekFalse = false;
        boolean onlyShortFallRecordsTrue = true;
        
        //Insert for method getWeeklyDemandSummary in InventoryAllocationMaster Class.
        Weekly_Demand_Summary__c weekdemsum = new Weekly_Demand_Summary__c();
        weekdemsum.Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        weekdemsum.Mainetti_Model__c = 'a02p00000088auhAAA'; //JGU138
        weekdemsum.Retailer_Code__c = 'a00p0000008NzFPAA0';  //GU
        weekdemsum.Color__c = 'GRAY';
        weekdemsum.Quantity__c = 2000;
        weekdemsum.Week_Start_Date__c =weekStartDate;
        weekdemsum.Week_End_Date__c =weekEndDate;
        insert weekdemsum;
        
        //Insert for method getWeeklySupplySummary in InventoryAllocationMaster Class.
        Weekly_Supply_Summary__c weeksupsum = new Weekly_Supply_Summary__c();
        weeksupsum.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        weeksupsum.Retailer_Code__c = 'a00p0000008NzFPAA0';  //GU
        weeksupsum.Mainetti_Model__c = 'a02p00000088auhAAA'; //JGU138
        weeksupsum.Color__c = 'GRAY';
        weeksupsum.Quantity__c = 200;
        weeksupsum.Source__c ='Virgin';
        weeksupsum.Warehouse__c ='LongHua Factory';
        weeksupsum.Week_Start_Date__c =weekStartDate ;
        weeksupsum.Week_End_Date__c =weekEndDate;
        insert weeksupsum;
        
        //Insert for method fetchInventoryAllocationForDemandIds in InventoryAllocationMaster Class.
        Inventory_Allocation__c invAllocation = new Inventory_Allocation__c();
        invAllocation.Quantity__c = 200;
        invAllocation.Inventory_Allocation_Type__c ='Demand';
        invAllocation.Inventory_Allocation_Demand__c = weekdemsum.Id;
        invAllocation.Inventory_Allocation_Supply__c = weeksupsum.Id;
        invAllocation.Week_Start_Date__c = weekStartDate;
        invAllocation.Week_End_Date__c =weekEndDate;
        insert invAllocation;
        
        /*Weekly_Demand_Summary__c weekdemsumPos = new Weekly_Demand_Summary__c();
        weekdemsumPos.Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        weekdemsumPos.Mainetti_Model__c = 'a02p00000088auhAAA'; //JGU138
        weekdemsumPos.Retailer_Code__c = 'a00p0000008NzFPAA0';  //GU
        weekdemsumPos.Color__c = 'GRAY';
        weekdemsumPos.Quantity__c = 2000;
        weekdemsumPos.Week_Start_Date__c =weekStartDate;
        weekdemsumPos.Week_End_Date__c =weekEndDate;
        insert weekdemsumPos;
        
        Weekly_Supply_Summary__c weeksupsumPos = new Weekly_Supply_Summary__c();
        weeksupsumPos.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        weeksupsumPos.Retailer_Code__c = 'a00p0000008NzFPAA0';  //GU
        weeksupsumPos.Mainetti_Model__c = 'a02p00000088auhAAA'; //JGU138
        weeksupsumPos.Color__c = 'GRAY';
        weeksupsumPos.Quantity__c = 2000;
        weeksupsumPos.Source__c ='Virgin';
        weeksupsumPos.Warehouse__c ='LongHua Factory';
        weeksupsumPos.Week_Start_Date__c =weekStartDate ;
        weeksupsumPos.Week_End_Date__c =weekEndDate;
        insert weeksupsumPos;
        
        Inventory_Allocation__c invAllocationPos = new Inventory_Allocation__c();
        invAllocationPos.Quantity__c = 2000;
        invAllocationPos.Inventory_Allocation_Type__c ='Demand';
        invAllocationPos.Inventory_Allocation_Demand__c = weekdemsum.Id;
        invAllocationPos.Inventory_Allocation_Supply__c = weeksupsum.Id;
        invAllocationPos.Week_Start_Date__c = weekStartDate;
        invAllocationPos.Week_End_Date__c =weekEndDate;
        insert invAllocationPos;*/
        
        Reuse_center_Inventory_Manager__c reuseManager = new Reuse_center_Inventory_Manager__c();
        reuseManager.Retailer_Code__c = 'a00p0000008NzFPAA0';
        reuseManager.User__c = '005p0000001gNj6AAE';
        insert reuseManager;
        
        Reuse_center_Inventory_Manager__c reuseManagerRetailer = new Reuse_center_Inventory_Manager__c();
        reuseManagerRetailer.Retailer_Code__c = 'a00p0000008NzFPAA0';
        reuseManagerRetailer.User__c = '00590000001AqYIAA0';
        insert reuseManagerRetailer;
        
        boolean flag = true;
        Test.startTest();
        viewDemandForecastController.fetchDemandForecastBySearch(mainettiCompany,retailerCode,modelName,weekStart,weekEnd,onlyShortFallRecords,pageNumber,recordToDisplay,isCurrentWeek);
        viewDemandForecastController.fetchDemandForecastBySearch(mainettiCompany,retailerCode,modelName,weekStart,weekEnd,onlyShortFallRecordsTrue,pageNumber,recordToDisplay,isCurrentWeekFalse);
        Test.stopTest();
        System.assertEquals(true, flag);
    }
}