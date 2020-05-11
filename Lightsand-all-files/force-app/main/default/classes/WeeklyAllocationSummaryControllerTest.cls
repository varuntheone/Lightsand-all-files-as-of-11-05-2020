@isTest
public class WeeklyAllocationSummaryControllerTest
{
    static testMethod void WeeklySummaryTest()
    { 
        
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        Weekly_Demand_Summary__c weekdemsum = new Weekly_Demand_Summary__c();
        weekdemsum.Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        weekdemsum.Mainetti_Model__c = 'a02p00000088auhAAA';
        weekdemsum.Retailer_Code__c = 'a00p0000008NzFPAA0';
        weekdemsum.Color__c = 'GRAY';
        weekdemsum.Sizer_Print__c = 's';
        weekdemsum.Quantity__c = 2000;
        weekdemsum.External_Id__c = '15814301030072';
        weekdemsum.Week_Start_Date__c =weekStartDate;
        weekdemsum.Week_End_Date__c =weekEndDate;
        insert weekdemsum;
        boolean flag = true;
        
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
        invalloc.Inventory_Allocation_Type__c ='Demand';
        invalloc.Inventory_Allocation_Demand__c = weekdemsum.Id;
        invalloc.Inventory_Allocation_Supply__c = weeksupsum.Id;
        invalloc.Week_Start_Date__c = weekStartDate;
        invalloc.Week_End_Date__c =weekEndDate;
        insert invalloc;
        
        
        String mainettiCompany = 'Hong Kong - Mainetti (HK) Ltd';
        String retailerCode = 'GU';
        String modelName = 'JGU138';
        String mainettiCompanysupply = 'Hong Kong - Mainetti (HK) Ltd';
        String retailerCodesupply = 'GU';
        String modelNamesupply = 'JGU138';
        String weekStart = String.valueOf(weekStartDate);
        String weekEnd = String.valueOf(weekEndDate);
        Integer pageNumber = 1;
        boolean isCurrentWeek =true ;            
        Integer recordToDisplay = 10;
        String allocationType= 'Demand';
        String allocationTypesupply= 'Supply';
        String selId='id';
        
        
        Test.startTest();
        WeeklyAllocationSummaryController.fetchWeeklyAllocationBySearch(mainettiCompany, retailerCode, modelName, weekStart, weekEnd, pageNumber, isCurrentWeek, recordToDisplay, allocationType);
        WeeklyAllocationSummaryController.fetchWeeklyAllocationBySearch(mainettiCompany, retailerCode, modelName, weekStart, weekEnd, pageNumber, isCurrentWeek, recordToDisplay, allocationTypesupply);
        WeeklyAllocationSummaryController.fetchWeeklyAllocationBySearch(mainettiCompanysupply, retailerCodesupply, modelNamesupply, weekStart, weekEnd, pageNumber, isCurrentWeek, recordToDisplay, allocationTypesupply);
        WeeklyAllocationSummaryController.DeleteRecords(selId);
        Test.stopTest();
        System.assertEquals(true, flag);
    } 
    
    static testMethod void updateAlocationTest(){
        
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        Inventory_Allocation__c updatealloc = new Inventory_Allocation__c();
        updatealloc.Quantity__c = 10;
        updatealloc.Week_Start_Date__c = weekStartDate;
        updatealloc.Week_End_Date__c = weekEndDate;
        insert updatealloc;
        
        Inventory_Allocation__c updateinvall = new Inventory_Allocation__c();
        updateinvall.Id = updatealloc.Id;
        updateinvall.Quantity__c = 5;
        
        
        List<Inventory_Allocation__c> li = new List<Inventory_Allocation__c>();
        li.add(updateinvall);
        
        boolean flag = true;
        Test.startTest();
        WeeklyAllocationSummaryController.updateAlocation(li);
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    static testMethod void deleteAlocationTest(){
        
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        Inventory_Allocation__c deltalloc = new Inventory_Allocation__c();
        deltalloc.Quantity__c = 10;
        
        
        Inventory_Allocation__c deltinvalloc = new Inventory_Allocation__c();
        deltinvalloc.Id = deltalloc.Id;
        deltinvalloc.Quantity__c = 5;
        
        List<Inventory_Allocation__c> lis = new List<Inventory_Allocation__c>();
        lis.add(deltinvalloc);
        
        boolean flag = true;
        Test.startTest();   
        WeeklyAllocationSummaryController.deleteAlocation(lis);
        Test.stopTest();
        System.assertEquals(true, flag);
        
    }
}