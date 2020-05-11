@isTest
public class SupplySummaryTest 
{
    static testMethod void WeeklySummaryTest(){
        
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        
        Weekly_Supply_Summary__c weeksupsum = new Weekly_Supply_Summary__c();
        weeksupsum.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        weeksupsum.Retailer_Code__c = 'a00p0000008NzFPAA0';
        weeksupsum.Mainetti_Model__c = 'a02p00000088auhAAA';
        weeksupsum.Color__c = 'GRAY';
        weeksupsum.Sizer_Print__c = '';
        weeksupsum.Quantity__c = 2000;
        weeksupsum.Source__c ='Virgin';
        weeksupsum.Warehouse__c ='LongHua Factory';
        weeksupsum.Week_Start_Date__c =weekStartDate ;
        weeksupsum.Week_End_Date__c =weekEndDate;
        insert weeksupsum;
        
        
        
        Inventory_Allocation__c invalloc = new Inventory_Allocation__c();
        invalloc.Quantity__c = 2000;
        invalloc.Inventory_Allocation_Type__c ='Supply';
        invalloc.Inventory_Allocation_Supply__c = weeksupsum.Id;
        invalloc.Week_Start_Date__c = weekStartDate;
        invalloc.Week_End_Date__c =weekEndDate;
        insert invalloc;
        
        
        
        
        String orderToCompany = 'Hong Kong - Mainetti (HK) Ltd';
        String retailerCode = 'GU';
        String modelName = 'JGU138';
        String weekStart = String.valueOf(weekStartDate);
        String weekEnd = String.valueOf(weekEndDate);
        Integer pageNumber = 1;
        boolean isCurrentWeek =true ;            
        Integer recordToDisplay = 10;
        String allocationTypesupply= 'Supply';
        string source = 'Virgin';
        string warehouse='LongHua Factory';
        boolean flag = true;
        
        String orderToCompany1 = 'Hong Kong - Mainetti (HK) Ltd';
        String retailerCode1 = 'GU';
        String modelName1 = 'JGU138';
        String weekStart1 = String.valueOf(weekStartDate);
        String weekEnd1 = String.valueOf(weekEndDate);
        Integer pageNumber1 = 1;
        boolean isCurrentWeek1 = false ;            
        Integer recordToDisplay1 = 10;
        String allocationTypesupply1= 'Supply';
        string source1 = 'Virgin';
        string warehouse1='LongHua Factory';
        boolean flag1 = true;
        
        
        Reuse_center_Inventory_Manager__c reuseManager = new Reuse_center_Inventory_Manager__c();
        reuseManager.Retailer_Code__c = 'a00p0000008NzFPAA0';
        reuseManager.User__c = '005p0000001gNj6AAE';
        insert reuseManager;
        
        Reuse_center_Inventory_Manager__c reuseManagerRetailer = new Reuse_center_Inventory_Manager__c();
        reuseManagerRetailer.Retailer_Code__c = 'a00p0000008NzFPAA0';
        reuseManagerRetailer.User__c = '00590000001AqYIAA0';
        insert reuseManagerRetailer;
        
        
        
        Test.startTest();
            WeeklySupplySummaryClass.fetchSupplySummaryBySearch(orderToCompany, retailerCode, modelName, weekStart, weekEnd, isCurrentWeek, pageNumber, recordToDisplay, source, warehouse);
            WeeklySupplySummaryClass.fetchSupplySummaryBySearch(orderToCompany1, retailerCode1, modelName1, weekStart1, weekEnd1, isCurrentWeek1, pageNumber1, recordToDisplay1, source1, warehouse1);
     
        Test.stopTest();
        System.assertEquals(true, flag);
        
    }
}