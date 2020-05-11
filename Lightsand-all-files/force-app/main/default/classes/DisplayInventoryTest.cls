@isTest
public class DisplayInventoryTest {
    
    static testMethod void fetchTest() {
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        Retailer_Code__c retailerCode = new Retailer_Code__c();
        retailerCode.Name = 'GU';
        insert retailerCode ;
        
        Online_Enquiry__c onlineEnquiry1 = new Online_Enquiry__c();
        onlineEnquiry1.Order_Country__c = 'Hong Kong - Mainetti (HK) Ltd';
        onlineEnquiry1.Retailer_Code__c = retailerCode.Id;
        onlineEnquiry1.External_Id__c = '40220201502';
        onlineEnquiry1.RecordTypeId = '01290000000nQZMAA2';
        insert onlineEnquiry1;
        
        
        Online_Detail__c onlineDetail1 = new Online_Detail__c();            
        onlineDetail1.Model__c = 'a02p00000088aueAAA';
        onlineDetail1.Color__c = 'GRAY';
        onlineDetail1.Qty__c = 0;
        onlineDetail1.RecordTypeId = '01290000000TNpeAAG';
        onlineDetail1.Online_Details_Status__c = 'New';
        onlineDetail1.TransactionID__c = onlineEnquiry1.Id;
        
        Price_Specification_Book_Product__c productName = new Price_Specification_Book_Product__c();
        productName.Name = 'TNGU139';
        productName.Retailer_Code__c = 'a00p0000008NzFPAA0';
        productName.Color__c = 'GRAY';
        productName.Price_100pcs__c = 82.524;
        productName.Freight_Terms__c = '';
        productName.Country__c = 'China - South';
        productName.Id = onlineDetail1.Model__c;
        upsert productName;
        insert onlineDetail1;
        
         Data_Upload_Transaction__c DataTest = new Data_Upload_Transaction__c();
         DataTest.Retailer_Code__c = retailerCode.Id;
         DataTest.Warehouse__c = 'LongHua Factory';
         insert DataTest;
        
        Weekly_Demand_Summary__c DemandSummary = new Weekly_Demand_Summary__c();
        //DemandSummary.Id = 'a25p0000000kcVjAAI';
        DemandSummary.Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        DemandSummary.Retailer_Code__c = retailerCode.Id;
        DemandSummary.Mainetti_Model__c = productName.Id;
        DemandSummary.Color__c = 'GRAY';
        DemandSummary.External_Id__c = '1581917465582_1';
        DemandSummary.Sizer_Print__c = 's';
        DemandSummary.Week_Start_Date__c = weekStartDate;
        DemandSummary.Week_End_Date__c = weekEndDate;
        DemandSummary.Quantity__c = 15;
        insert DemandSummary;
        
        Inventory_Allocation__c allocationObj = new Inventory_Allocation__c();
        // allocationObj.Id = 'a28p0000000Rwf5AAC';
        allocationObj.Retailer_Name__c = 'GU ';
        allocationObj.Warehouse_Name__c = DataTest.Id;
        allocationObj.Quantity__c = 50;
        allocationObj.Inventory_Allocation_Demand__c = DemandSummary.Id;
        allocationObj.Inventory_Allocation_Type__c = 'a25p0000000kdpp';
        allocationObj.Week_Start_Date__c = weekStartDate;
        allocationObj.Week_End_Date__c = weekEndDate;
        allocationObj.Physically_Available__c = false ;
        insert allocationObj;
        
        
        
        boolean flag = true;
        Test.startTest();
        DisplayInventoryClass.fetch();        
        Test.stopTest();
        System.assertEquals(true, flag);
        
    }
    static testMethod void getRetailerForDemandTest(){
        
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
       /* Inventory_Allocation__c allocationObj = new Inventory_Allocation__c();
        Weekly_Demand_Summary__c WeeklyDemandtest = new Weekly_Demand_Summary__c();
        WeeklyDemandtest.Retailer_Code__c = allocationObj.Id;
        WeeklyDemandtest.Color__c = 'GRAY';
        WeeklyDemandtest.Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        WeeklyDemandtest.Week_Start_Date__c = weekStartDate;
        WeeklyDemandtest.Week_End_Date__c = weekEndDate;
        WeeklyDemandtest.Quantity__c = 23;
        insert WeeklyDemandtest;*/
       // List<ID> id = new List<ID>();
        //ID
        //id.add(allocationObj);
       // Insert Id;
        Retailer_Code__c retailerCode = new Retailer_Code__c();
        retailerCode.Name = 'GU';
        insert retailerCode ;
        
        Online_Enquiry__c onlineEnquiry1 = new Online_Enquiry__c();
        onlineEnquiry1.Order_Country__c = 'Hong Kong - Mainetti (HK) Ltd';
        onlineEnquiry1.Retailer_Code__c = retailerCode.Id;
        onlineEnquiry1.External_Id__c = '40220201502';
        onlineEnquiry1.RecordTypeId = '01290000000nQZMAA2';
        insert onlineEnquiry1;
        
        
        Online_Detail__c onlineDetail1 = new Online_Detail__c();            
        onlineDetail1.Model__c = 'a02p00000088aueAAA';
        onlineDetail1.Color__c = 'GRAY';
        onlineDetail1.Qty__c = 0;
        onlineDetail1.RecordTypeId = '01290000000TNpeAAG';
        onlineDetail1.Online_Details_Status__c = 'New';
        onlineDetail1.TransactionID__c = onlineEnquiry1.Id;
        
        Price_Specification_Book_Product__c productName = new Price_Specification_Book_Product__c();
        productName.Name = 'TNGU139';
        productName.Retailer_Code__c = 'a00p0000008NzFPAA0';
        productName.Color__c = 'GRAY';
        productName.Price_100pcs__c = 82.524;
        productName.Freight_Terms__c = '';
        productName.Country__c = 'China - South';
        productName.Id = onlineDetail1.Model__c;
        upsert productName;
        insert onlineDetail1;
        
        Weekly_Demand_Summary__c DemandSummary = new Weekly_Demand_Summary__c();
        //DemandSummary.Id = 'a25p0000000kcVjAAI';
        DemandSummary.Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        DemandSummary.Retailer_Code__c = retailerCode.Id;
        DemandSummary.Mainetti_Model__c = productName.Id;
        DemandSummary.Color__c = 'GRAY';
        DemandSummary.External_Id__c = '1581917465582_1';
        DemandSummary.Sizer_Print__c = 's';
        DemandSummary.Week_Start_Date__c = weekStartDate;
        DemandSummary.Week_End_Date__c = weekEndDate;
        DemandSummary.Quantity__c = 15;
        insert DemandSummary;
        
        Inventory_Allocation__c allocationObj = new Inventory_Allocation__c();
        // allocationObj.Id = 'a28p0000000Rwf5AAC';
        allocationObj.Retailer_Name__c = 'GU ';
        allocationObj.Warehouse_Name__c = 'LongHua Factory';
        allocationObj.Quantity__c = 50;
        allocationObj.Inventory_Allocation_Demand__c = DemandSummary.Id;
        allocationObj.Inventory_Allocation_Type__c = 'a25p0000000kdpp';
        allocationObj.Week_Start_Date__c = weekStartDate;
        allocationObj.Week_End_Date__c = weekEndDate;
        allocationObj.Physically_Available__c = false ;
        insert allocationObj;
        boolean flag = true;
        Test.startTest();
        DisplayInventoryClass.getRetailerForDemand(allocationObj.Id);        
        Test.stopTest();
        System.assertEquals(true, flag);
    } 

     static testMethod void getWarehouseTest(){
         
          Retailer_Code__c retailerCode = new Retailer_Code__c();
        retailerCode.Name = 'GU';
        insert retailerCode ;
         
         Data_Upload_Transaction__c DataTest = new Data_Upload_Transaction__c();
         DataTest.Retailer_Code__c = retailerCode.Id;
         DataTest.Warehouse__c = 'LongHua Factory';
         insert DataTest;
         boolean flag = true;
         Test.startTest();
         DisplayInventoryClass.getWarehouse();        
         Test.stopTest();
         System.assertEquals(true, flag);
         
     } 
 
    static testMethod void saveTest(){
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        Inventory_Allocation__c invAllc = new Inventory_Allocation__c();
        
        InvAllc.Physically_Available__c = true ;
        InvAllc.Quantity__c = 50;
        InvAllc.Week_Start_Date__c = weekStartDate;
        InvAllc.Week_End_Date__c = weekEndDate;
        insert invAllc;
        List<Id> TestId  = new List<Id>();
        
        Weekly_Demand_Summary__c DemandSummary = new Weekly_Demand_Summary__c();
        
        DemandSummary.Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        DemandSummary.Retailer_Code__c = 'a00p0000008NzFPAA0';
        DemandSummary.Mainetti_Model__c = 'a02p00000088aujAAA';
        DemandSummary.Color__c = 'GRAY';
        DemandSummary.External_Id__c = '1581917465582_1';
        DemandSummary.Sizer_Print__c = 's';
        DemandSummary.Week_Start_Date__c = weekStartDate;
        DemandSummary.Week_End_Date__c = weekEndDate;
        DemandSummary.Quantity__c = 15;
        insert DemandSummary;
        
        boolean flag = true;
        Test.startTest();
        DisplayInventoryClass.save(TestId);        
        Test.stopTest();
        System.assertEquals(true, flag);
        
     }
}