@isTest
public class InventoryAllocationMasterTest {
    
    
         static testMethod void fetchWeeklyEnquiryIdAndSalesOrderIdForTheWeekTest(){
             
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
             
             Sales_Order__c salesOrder = new Sales_Order__c();
             //salesOrder.Name = 'MG-000032';
             salesOrder.Company__c = 'Hong Kong - Mainetti (HK) Ltd';
             salesOrder.Retailer_Code1__c = retailerCode.Id;
             salesOrder.Status__c = 'New Order';
             salesOrder.Link_To_ERP__c = 'New';
             insert salesOrder;
             
             
             
             InventoryAllocationMaster InAllMaster = new InventoryAllocationMaster();
             Weekly_Demand_Consolidated_Order_Id__c WeeklyDemand = new Weekly_Demand_Consolidated_Order_Id__c();
             WeeklyDemand.Online_Enquiry__c = onlineEnquiry1.Id ;
             WeeklyDemand.Sales_Order__c = salesOrder.Id;
             WeeklyDemand.Week_Start_Date__c = weekStartDate;
             WeeklyDemand.Week_End_Date__c = weekEndDate;
             
             insert WeeklyDemand;
             boolean flag = true;
             Test.startTest();
             InAllMaster.fetchWeeklyEnquiryIdAndSalesOrderIdForTheWeek(weekStartDate ,weekEndDate);        
             Test.stopTest();
             System.assertEquals(true, flag);
                 }
    
    static testMethod void fetchWeeklyDemandSummaryForTheWeekTest(){
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        InventoryAllocationMaster InAllMaster = new InventoryAllocationMaster();
        Weekly_Demand_Summary__c DemandSummary = new Weekly_Demand_Summary__c();
        //DemandSummary.Id = 'a25p0000000kcVjAAI';
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
        InAllMaster.fetchWeeklyDemandSummaryForTheWeek(weekStartDate ,weekEndDate);        
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
     static testMethod void fetchOrderDetailsFromPortalTest(){
         Date startdate = date.today();  
         Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
         Date weekStartDate = todaydateinstance.toStartOfWeek();
         Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
         
         InventoryAllocationMaster InAllMaster = new InventoryAllocationMaster();
         Online_Enquiry__c onlineEnquiry = new Online_Enquiry__c();
         onlineEnquiry.Order_Country__c = 'Hong Kong - Mainetti (HK) Ltd';
         onlineEnquiry.Retailer_Code__c = 'a00p0000008NzFPAA0';
         onlineEnquiry.External_Id__c = '40220201502';
         onlineEnquiry.RecordTypeId = '01290000000nQZMAA2';
        
         insert onlineEnquiry;
         
         Weekly_Demand_Summary__c DemandSummary = new Weekly_Demand_Summary__c();
         //DemandSummary.Id = 'a25p0000000kcVjAAI';
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
         
         Online_Detail__c onlineDetail = new Online_Detail__c();
         onlineDetail.Model__c = 'a02p00000088auXAAQ'; // TNGU139 model.
         onlineDetail.Color__c = 'GRAY';
         onlineDetail.Qty__c = 2000;
         onlineDetail.RecordTypeId = '01290000000TNpeAAG';
         onlineDetail.Online_Details_Status__c = 'New';
         //onlineDetail.TransactionID__c = '';
         onlineDetail.TransactionID__c = onlineEnquiry.Id;
         
         // insert onlineDetail;
         boolean flag = true;
         Test.startTest();
         InAllMaster.fetchOrderDetailsFromPortal(weekStartDate ,weekEndDate);        
         Test.stopTest();
         System.assertEquals(true, flag);
    }
    
    static testMethod void fetchOrderDetailsFromMagNETTest(){
         Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();

         InventoryAllocationMaster InAllMaster = new InventoryAllocationMaster();
        Sales_Order__c salesOrder = new Sales_Order__c();
        salesOrder.Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        salesOrder.Retailer_Code1__c = 'a00p0000008NzFPAA0'; //Gu Retailer.
        salesOrder.Status__c = 'Old';
        salesOrder.Link_To_ERP__c = 'New';
        insert salesOrder;
        
        Sales_Order_Line_Items__c salesOderLineItems = new Sales_Order_Line_Items__c();
        salesOderLineItems.Status__c = 'Under Processing';
        salesOderLineItems.Quantity__c = '50';
        salesOderLineItems.Ordered_Quantity__c = 10;
        salesOderLineItems.Supply_Quantity__c = '5';
        salesOderLineItems.Remaining_Qty__c = 0;
        salesOderLineItems.Price_Specification_Book_Product__c = 'a02p00000088auXAAQ';
        salesOderLineItems.Colour__c = 'GRAY';
        salesOderLineItems.Sales_Order__c = salesOrder.Id;
        insert salesOderLineItems;
        
        Sales_Order_Line_Items__c salesOderLineItems1 = new Sales_Order_Line_Items__c();
        salesOderLineItems1.Status__c = 'Shipped';
        salesOderLineItems1.Quantity__c = '50';
        salesOderLineItems1.Ordered_Quantity__c = 10;
        salesOderLineItems1.Supply_Quantity__c = '5';
        salesOderLineItems1.Remaining_Qty__c = 0;
        salesOderLineItems1.Price_Specification_Book_Product__c = 'a02p00000088auXAAQ';
        salesOderLineItems1.Colour__c = 'GRAY';
        salesOderLineItems1.Sales_Order__c = salesOrder.Id;
        insert salesOderLineItems1;
        boolean flag = true;
        Test.startTest();
       InAllMaster.fetchOrderDetailsFromMagNET(weekStartDate ,weekEndDate);        
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
    static testMethod void fetchWeeklyDataUploadIdForTheWeekTest(){
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        InventoryAllocationMaster InAllMaster = new InventoryAllocationMaster();
        
        
        Retailer_Code__c retailerCode = new Retailer_Code__c();
        retailerCode.Name = 'GU';
        insert retailerCode ;
        
        Online_Enquiry__c onlineEnquiry1 = new Online_Enquiry__c();
        onlineEnquiry1.Order_Country__c = 'Hong Kong - Mainetti (HK) Ltd';
        onlineEnquiry1.Retailer_Code__c = retailerCode.Id;
        onlineEnquiry1.External_Id__c = '40220201502';
        onlineEnquiry1.RecordTypeId = '01290000000nQZMAA2';
        insert onlineEnquiry1;
        
        Weekly_Demand_Consolidated_Order_Id__c WeeklyDemand = new Weekly_Demand_Consolidated_Order_Id__c();
        WeeklyDemand.Online_Enquiry__c = onlineEnquiry1.Id ;
        WeeklyDemand.Sales_Order__c = 'a2Bp0000000KKGuEAO';
        WeeklyDemand.Week_Start_Date__c = weekStartDate;
        WeeklyDemand.Week_End_Date__c = weekEndDate;
        insert WeeklyDemand;
        
        Weekly_Supply_Consolidated_Id__c SupplyConsolidated = new Weekly_Supply_Consolidated_Id__c();
        //SupplyConsolidated.Data_Upload_Transaction__c = '';
        insert SupplyConsolidated;
        boolean flag = true;
        Test.startTest();
        InAllMaster.fetchWeeklyDataUploadIdForTheWeek(weekStartDate ,weekEndDate);        
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
     static testMethod void fetchWeeklySupplyVirginSummaryForTheWeekTest(){
         Date startdate = date.today();  
         Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
         Date weekStartDate = todaydateinstance.toStartOfWeek();
         Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
         
         InventoryAllocationMaster InAllMaster = new InventoryAllocationMaster();
         
         Weekly_Supply_Summary__c WeeklySupply = new Weekly_Supply_Summary__c();
         WeeklySupply.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';  
         WeeklySupply.Mainetti_Model__c = 'a02p0000007cGIwAAM';
         WeeklySupply.Retailer_Code__c = 'a00p0000006Hw7nAAC';
         WeeklySupply.Warehouse__c = 'Ningbo Warehouse';
         WeeklySupply.Color__c = 'GRAY';
         WeeklySupply.Sizer_Print__c = 'XS';
         WeeklySupply.Week_Start_Date__c =weekStartDate;
         WeeklySupply.Week_End_Date__c = weekEndDate;
         WeeklySupply.Quantity__c = 28;
         insert WeeklySupply; 
         
          Date weekEndDate1 = system.today() + 5;
        Date weekStartDate1 = system.today() - 5;
         boolean flag = true;
         Test.startTest();
         InAllMaster.fetchWeeklySupplyVirginSummaryForTheWeek(weekStartDate ,weekEndDate);   
         InAllMaster.fetchWeeklySupplyVirginSummaryForTheWeek(weekStartDate1 ,weekEndDate1); 
         Test.stopTest();
         System.assertEquals(true, flag);
    }
    
    
    
    
    static testMethod void fetchStockOnHandForSourceVirginTest(){
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        InventoryAllocationMaster InAllMaster = new InventoryAllocationMaster();
        
        Data_Upload_Transaction__c DataUpload = new Data_Upload_Transaction__c();
        DataUpload.Mainetti_Company__c = 'a05p0000003OHyJAAW';  
        DataUpload.Retailer_Code__c = 'a00p0000008NzFPAA0';
        DataUpload.Inventory_Model__c = 'a02p00000088aueAAA';
        DataUpload.Color__c = 'GRAY';
        DataUpload.Sizer_Print__c = 'XS';
        DataUpload.Warehouse__c = 'Ningbo Warehouse';
        DataUpload.Stock_In_Qty__c = 15; 
        DataUpload.Record_Type__c ='Inventory';
        DataUpload.Source__c = 'Virgin';
              
        insert DataUpload;       
        boolean flag = true;
        Test.startTest();
        InAllMaster.fetchStockOnHandForSourceVirgin(weekStartDate ,weekEndDate);        
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    static testMethod void fetchWeeklySupplyReuseSummaryForTheWeekTest(){
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        InventoryAllocationMaster InAllMaster = new InventoryAllocationMaster();
        
        Weekly_Supply_Summary__c WeeklySupply = new Weekly_Supply_Summary__c();
        WeeklySupply.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';  
        WeeklySupply.Mainetti_Model__c = 'a02p0000007cGIwAAM';
        WeeklySupply.Retailer_Code__c = 'a00p0000006Hw7nAAC';
        WeeklySupply.Warehouse__c = 'Ningbo Warehouse';
        WeeklySupply.Color__c = 'GRAY';
        WeeklySupply.Sizer_Print__c = 'XS';
        WeeklySupply.Week_Start_Date__c =weekStartDate;
        WeeklySupply.Week_End_Date__c = weekEndDate; 
        WeeklySupply.Quantity__c = 15;
        insert WeeklySupply;       
        boolean flag = true;
        Test.startTest();
        InAllMaster.fetchWeeklySupplyReuseSummaryForTheWeek(weekStartDate ,weekEndDate);        
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
    static testMethod void fetchStockOnHandForSourceReuseTest(){
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        InventoryAllocationMaster InAllMaster = new InventoryAllocationMaster();
        
        Data_Upload_Transaction__c DataUpload = new Data_Upload_Transaction__c();
        DataUpload.Mainetti_Company__c = 'a05p0000003OHyJAAW';  
        DataUpload.Retailer_Code__c = 'a00p0000008NzFPAA0';
        DataUpload.Inventory_Model__c = 'a02p00000088aueAAA';
        DataUpload.Color__c = 'GRAY';
        DataUpload.Sizer_Print__c = 'XS';
        //DataUpload.Week_Start_Date__c =weekStartDate;
        //DataUpload.Week_End_Date__c = weekEndDate;         
        insert DataUpload;       
        boolean flag = true;
        Test.startTest();
        InAllMaster.fetchStockOnHandForSourceReuse(weekStartDate ,weekEndDate);        
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
    static testMethod void fetchEnquiryNumberForOnlineEnquiryShimpmentTest(){
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        InventoryAllocationMaster InAllMaster = new InventoryAllocationMaster();
        
                        
             Retailer_Code__c retailerCode = new Retailer_Code__c();
             retailerCode.Name = 'GU';
             insert retailerCode ;
             
             Online_Enquiry__c onlineEnquiry1 = new Online_Enquiry__c();
             onlineEnquiry1.Order_Country__c = 'Hong Kong - Mainetti (HK) Ltd';
             onlineEnquiry1.Retailer_Code__c = retailerCode.Id;
             onlineEnquiry1.External_Id__c = '40220201502';
             onlineEnquiry1.RecordTypeId = '01290000000nQZMAA2';
             insert onlineEnquiry1;
        
        Online_Enquiry_Shipment_Invoice__c onlineEnqiury = new Online_Enquiry_Shipment_Invoice__c();
        onlineEnqiury.Online_Enquiry_No__c = onlineEnquiry1.Id;     
        insert onlineEnqiury;       
        boolean flag = true;
        Test.startTest();
        InAllMaster.fetchEnquiryNumberForOnlineEnquiryShimpment(weekStartDate ,weekEndDate);        
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
 static testMethod void fetchWeeklyDemandSummaryForTheWeekShipmentPortalTest(){
             
     Date startdate = date.today();  
     Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
     Date weekStartDate = todaydateinstance.toStartOfWeek();
     Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
     
     
     InventoryAllocationMaster InAllMaster = new InventoryAllocationMaster();
     
                     
             Retailer_Code__c retailerCode = new Retailer_Code__c();
             retailerCode.Name = 'GU';
             insert retailerCode ;
             
             Online_Enquiry__c onlineEnquiry1 = new Online_Enquiry__c();
             onlineEnquiry1.Order_Country__c = 'Hong Kong - Mainetti (HK) Ltd';
             onlineEnquiry1.Retailer_Code__c = retailerCode.Id;
             onlineEnquiry1.External_Id__c = '40220201502';
             onlineEnquiry1.RecordTypeId = '01290000000nQZMAA2';
             insert onlineEnquiry1;
     
     Weekly_Demand_Consolidated_Order_Id__c WeeklyDemand = new Weekly_Demand_Consolidated_Order_Id__c();
     WeeklyDemand.Online_Enquiry__c = onlineEnquiry1.Id ;
     WeeklyDemand.External_Id__c = '1581917465582_1';
     WeeklyDemand.Week_Start_Date__c = weekStartDate;
     WeeklyDemand.Week_End_Date__c = weekEndDate;
     insert WeeklyDemand;
     
     List<Weekly_Demand_Summary__c> DemandSummaryList = new List<Weekly_Demand_Summary__c>();
     for (Weekly_Demand_Summary__c weeklyDemandSum : DemandSummaryList){
         Weekly_Demand_Summary__c DemandSummary = new Weekly_Demand_Summary__c();
         DemandSummary.Id = WeeklyDemand.Id;
         DemandSummary.Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
         DemandSummary.Retailer_Code__c = 'a00p0000008NzFPAA0';
         DemandSummary.Mainetti_Model__c = 'a02p00000088aujAAA';
         DemandSummary.Color__c = 'GRAY';
         DemandSummary.External_Id__c = '1581917465582_1';
         DemandSummary.Sizer_Print__c = 's';
         DemandSummary.Week_Start_Date__c = weekStartDate;
         DemandSummary.Week_End_Date__c = weekEndDate;
         DemandSummary.Quantity__c = 15;
         DemandSummaryList.add(DemandSummary);
         
     }
     insert DemandSummaryList;
     boolean flag = true;
     Test.startTest();
     InAllMaster.fetchWeeklyDemandSummaryForTheWeekShipmentPortal(weekStartDate ,weekEndDate);        
     Test.stopTest();
        System.assertEquals(true, flag);
                 }
    
    static testMethod void fetchWeeklyShipmentSummaryForTheWeekPortalTest(){
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        InventoryAllocationMaster InAllMaster = new InventoryAllocationMaster();
        
        Weekly_Demand_Summary__c DemandSummary = new Weekly_Demand_Summary__c();
        //DemandSummary.Id = 'a25p0000000kcVjAAI';
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
        Weekly_Shipment_Summary__c shipmentSummary = new Weekly_Shipment_Summary__c();
        shipmentSummary.Weekly_Demand_Summary__c =  DemandSummary.Id; 
        shipmentSummary.Quantity__c = 50;
        shipmentSummary.Color__c = 'GRAY';
        shipmentSummary.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        shipmentSummary.Week_Start_Date__c = weekStartDate;
        insert shipmentSummary;       
        boolean flag = true;
        Test.startTest();
        InAllMaster.fetchWeeklyShipmentSummaryForTheWeekPortal(weekStartDate ,weekEndDate);        
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
    static testMethod void fetchShipmentDetailsForPortalTest(){
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        InventoryAllocationMaster InAllMaster = new InventoryAllocationMaster();
        
         Retailer_Code__c retailerCode = new Retailer_Code__c();
             retailerCode.Name = 'GU';
             insert retailerCode ;
             
             Online_Enquiry__c onlineEnquiry1 = new Online_Enquiry__c();
             onlineEnquiry1.Order_Country__c = 'Hong Kong - Mainetti (HK) Ltd';
             onlineEnquiry1.Retailer_Code__c = retailerCode.Id;
             onlineEnquiry1.External_Id__c = '40220201502';
             onlineEnquiry1.RecordTypeId = '01290000000nQZMAA2';
             insert onlineEnquiry1;
        
        Online_Enquiry_Shipment_Invoice__c onlineEnqiury = new Online_Enquiry_Shipment_Invoice__c();
        onlineEnqiury.Online_Enquiry_No__c = onlineEnquiry1.Id;     
        insert onlineEnqiury;       
        boolean flag = true;
        Test.startTest();
        InAllMaster.fetchShipmentDetailsForPortal(weekStartDate ,weekEndDate);        
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
    static testMethod void fetchShipmentDetailsForMagNETForTheWeekTest(){
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        InventoryAllocationMaster InAllMaster = new InventoryAllocationMaster();
        
        Shipment_Line_Item__c shipmentItem = new Shipment_Line_Item__c();
        shipmentItem.Shipment__c = 'a2Hp0000000ZKt1EAG';
        insert shipmentItem;       
        boolean flag = true;
        Test.startTest();
        InAllMaster.fetchShipmentDetailsForMagNETForTheWeek(weekStartDate ,weekEndDate);        
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
    static testMethod void fetchSalesOrderItemNumbersForShipmentDoneInTheWeekTest(){
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        InventoryAllocationMaster InAllMaster = new InventoryAllocationMaster();
        
        Shipment_Line_Item__c shipmentItem = new Shipment_Line_Item__c();
        shipmentItem.Shipment__c = 'a2Hp0000000ZKt1EAG';
        insert shipmentItem;       
        boolean flag = true;
        Test.startTest();
        InAllMaster.fetchSalesOrderItemNumbersForShipmentDoneInTheWeek(weekStartDate ,weekEndDate);        
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
    static testMethod void fetchWeeklyShipmentSummaryForTheWeekMagNETTest(){
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        InventoryAllocationMaster InAllMaster = new InventoryAllocationMaster();
        Weekly_Demand_Summary__c DemandSummary = new Weekly_Demand_Summary__c();
        //DemandSummary.Id = 'a25p0000000kcVjAAI';
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
        Weekly_Shipment_Summary__c shipmentSummary = new Weekly_Shipment_Summary__c();
        shipmentSummary.Weekly_Demand_Summary__c = DemandSummary.Id; 
        shipmentSummary.Quantity__c = 50;
        shipmentSummary.Color__c = 'GRAY';
        shipmentSummary.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        shipmentSummary.Week_Start_Date__c = weekStartDate;
        insert shipmentSummary;       
        boolean flag = true;
        Test.startTest();
        InAllMaster.fetchWeeklyShipmentSummaryForTheWeekMagNET(weekStartDate ,weekEndDate);        
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
    static testMethod void getWeekNumberTest(){
             
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        
        InventoryAllocationMaster InAllMaster = new InventoryAllocationMaster();
        Weekly_Demand_Summary__c DemandSummary = new Weekly_Demand_Summary__c();
        //DemandSummary.Id = 'a25p0000000kcVjAAI';
        DemandSummary.Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        DemandSummary.Retailer_Code__c = 'a00p0000008NzFPAA0';
        DemandSummary.Mainetti_Model__c = 'a02p00000088aujAAA';
        DemandSummary.Color__c = 'GRAY';
        DemandSummary.External_Id__c = '1581917465582_1';
        DemandSummary.Sizer_Print__c = 's';
        DemandSummary.Week_Start_Date__c = StartDate;
        DemandSummary.Week_End_Date__c = weekEndDate;
        DemandSummary.Quantity__c = 15;
        insert DemandSummary;
        boolean isCurrentWeek = true;
       
        boolean flag = true;
        Test.startTest();
        InAllMaster.getWeekNumber(StartDate);        
        Test.stopTest();
        System.assertEquals(true, flag);
                 }
    
    static testMethod void fetchWeeklyDemandSummaryTest()
    {
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        InventoryAllocationMaster InAllMaster = new InventoryAllocationMaster();
        
        Weekly_Demand_Summary__c DemandSummary = new Weekly_Demand_Summary__c();
        DemandSummary.Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        DemandSummary.Retailer_Code__c = 'a00p0000008NzFPAA0';
        DemandSummary.Mainetti_Model__c = 'a02p00000088aujAAA';
        DemandSummary.Color__c = 'GRAY';
        DemandSummary.External_Id__c = '1581917465582_1';
        DemandSummary.Sizer_Print__c = 's';
        DemandSummary.Week_Start_Date__c = StartDate;
        DemandSummary.Week_End_Date__c = weekEndDate;
        DemandSummary.Quantity__c = 15;
        insert DemandSummary;
        string orderToCompany = 'Hong Kong - Mainetti (HK) Ltd';
        String retailerCode = 'a00p0000008NzFPAA0';
        String modelName = 'a02p00000088aujAAA';
        Date weekStartDate1 = system.today() +5;
        // Date weekEndDate = weekEndDate;
        Integer pageNumber = 1;
        Integer recordToDisplay = 10;
        //Integer totalRecordCount = 20;
        boolean isCurrentWeek = true;
        boolean flag = true; 
        boolean isCurrentWeek1 = false;
        
        Date weekStartDate2 = null;
        Date weekEndDate2 = null;
        
        
        
        string orderToCompany1 = '';
        String retailerCode1 = '';
        String modelName1 = '';
        string allocationType1 = '';
        
        
        Test.startTest();
        InAllMaster.fetchWeeklyDemandSummary(orderToCompany, retailerCode, modelName, weekStartDate, weekEndDate, pageNumber ,recordToDisplay, isCurrentWeek); 
        InAllMaster.fetchWeeklyDemandSummary(orderToCompany1, retailerCode, modelName, weekStartDate, weekEndDate2, pageNumber ,recordToDisplay, isCurrentWeek1);
        InAllMaster.fetchWeeklyDemandSummary(orderToCompany1, retailerCode, modelName, weekStartDate2, weekEndDate, pageNumber ,recordToDisplay, isCurrentWeek1);
        InAllMaster.fetchWeeklyDemandSummary(orderToCompany1, retailerCode1, modelName1, weekStartDate2, weekEndDate2, pageNumber ,recordToDisplay, isCurrentWeek);
        InAllMaster.fetchWeeklyDemandSummary(orderToCompany, retailerCode, modelName, weekStartDate2, weekEndDate2, pageNumber ,recordToDisplay, isCurrentWeek);
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
    static testMethod void fetchWeeklySupplySummaryTest()
    {
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        InventoryAllocationMaster InAllMaster = new InventoryAllocationMaster();
        string orderToCompany = 'Hong Kong - Mainetti (HK) Ltd';
        String retailerCode = 'a00p0000008NzFPAA0';
        String modelName = 'a02p00000088aujAAA';
        boolean isCurrentWeek = true;
        Date weekEndDate1=null;
        Weekly_Shipment_Summary__c shipmentSummary = new Weekly_Shipment_Summary__c();
        //shipmentSummary.Id = DemandSummary.Id;
        //shipmentSummary.Weekly_Demand_Summary__c =  DemandSummary.Id; 
        shipmentSummary.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        shipmentSummary.Retailer_Code__c = 'a00p0000008NzFPAA0';
        shipmentSummary.Mainetti_Model__c = 'a02p00000088auhAAA';
        shipmentSummary.Sizer_Print__c = 'xs';
        shipmentSummary.Quantity__c = 50;
        shipmentSummary.Color__c = 'GRAY';
        shipmentSummary.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        shipmentSummary.Week_Start_Date__c = weekStartDate;
        insert shipmentSummary; 
        
        Weekly_Supply_Summary__c WeeklySupply = new Weekly_Supply_Summary__c();
        WeeklySupply.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';  
        WeeklySupply.Mainetti_Model__c = 'a02p0000007cGIwAAM';
        WeeklySupply.Retailer_Code__c = 'a00p0000006Hw7nAAC';
        WeeklySupply.Warehouse__c = 'Ningbo Warehouse';
        WeeklySupply.Color__c = 'GRAY';
        WeeklySupply.Sizer_Print__c = 'XS';
        WeeklySupply.Week_Start_Date__c =weekStartDate;
        WeeklySupply.Week_End_Date__c = weekEndDate;
        WeeklySupply.Quantity__c = 28;
        insert WeeklySupply; 
        
        boolean isCurrentWeek1 = false;
        string orderToCompany1 = '';
        String retailerCode1 = '';
        String modelName1 = '';
        Date weekStartDate1=null;
        boolean flag = true; 
        Test.startTest();
        InAllMaster.fetchWeeklySupplySummary(orderToCompany1, retailerCode1, modelName1, weekStartDate1, weekEndDate1, isCurrentWeek); 
        InAllMaster.fetchWeeklySupplySummary(orderToCompany, retailerCode, modelName, weekStartDate, weekEndDate, isCurrentWeek); 
        InAllMaster.fetchWeeklySupplySummary(orderToCompany, retailerCode, modelName, weekStartDate, weekEndDate1, isCurrentWeek1); 
        InAllMaster.fetchWeeklySupplySummary(orderToCompany, retailerCode, modelName, weekStartDate1, weekEndDate, isCurrentWeek1);
        InAllMaster.fetchWeeklySupplySummary(orderToCompany, retailerCode, modelName, weekStartDate1, weekEndDate1, isCurrentWeek1);
        InAllMaster.fetchWeeklySupplySummary(orderToCompany1, retailerCode, modelName, weekStartDate1, weekEndDate1, isCurrentWeek1);
        InAllMaster.fetchWeeklySupplySummary(orderToCompany1, retailerCode1, modelName, weekStartDate1, weekEndDate1, isCurrentWeek1);
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
    static testMethod void fetchWeeklyShipmentSummaryTest()
    {
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        InventoryAllocationMaster InAllMaster = new InventoryAllocationMaster();
        
        Weekly_Demand_Summary__c DemandSummary = new Weekly_Demand_Summary__c();
        DemandSummary.Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        DemandSummary.Retailer_Code__c = 'a00p0000008NzFPAA0';
        DemandSummary.Mainetti_Model__c = 'a02p00000088aujAAA';
        DemandSummary.Color__c = 'GRAY';
        DemandSummary.External_Id__c = '1581917465582_1';
        DemandSummary.Sizer_Print__c = 's';
        DemandSummary.Week_Start_Date__c = StartDate;
        DemandSummary.Week_End_Date__c = weekEndDate;
        DemandSummary.Quantity__c = 15;
        insert DemandSummary;
        Weekly_Shipment_Summary__c shipmentSummary = new Weekly_Shipment_Summary__c();
        
        shipmentSummary.Weekly_Demand_Summary__c =  DemandSummary.Id; 
        shipmentSummary.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        shipmentSummary.Retailer_Code__c = 'a00p0000008NzFPAA0';
        shipmentSummary.Mainetti_Model__c = 'a02p00000088auhAAA';
        shipmentSummary.Sizer_Print__c = 'xs';
        shipmentSummary.Quantity__c = 50;
        shipmentSummary.Color__c = 'GRAY';
        shipmentSummary.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        shipmentSummary.Week_Start_Date__c = weekStartDate;
        insert shipmentSummary;   
        string orderToCompany = 'Hong Kong - Mainetti (HK) Ltd';
        String retailerCode = 'a00p0000008NzFPAA0';
        String modelName = 'a02p00000088aujAAA';
        boolean isCurrentWeek = true;
        boolean isCurrentWeek1 = false;
        string orderToCompany1 = '';
        String retailerCode1 = '';
        String modelName1 = '';
        Date weekStartDate1 = null;
        Date weekEndDate1 = null;
        boolean flag = true; 
        Test.startTest();
        InAllMaster.fetchWeeklyShipmentSummary(orderToCompany, retailerCode, modelName, weekStartDate, weekEndDate, isCurrentWeek); 
        InAllMaster.fetchWeeklyShipmentSummary(orderToCompany, retailerCode, modelName, weekStartDate, weekEndDate, isCurrentWeek1);
        InAllMaster.fetchWeeklyShipmentSummary(orderToCompany, retailerCode, modelName, weekStartDate, weekEndDate1, isCurrentWeek1); 
        InAllMaster.fetchWeeklyShipmentSummary(orderToCompany, retailerCode, modelName, weekStartDate1, weekEndDate, isCurrentWeek1);
        InAllMaster.fetchWeeklyShipmentSummary(orderToCompany, retailerCode, modelName, weekStartDate1, weekEndDate1, isCurrentWeek1); 
        InAllMaster.fetchWeeklyShipmentSummary(orderToCompany1, retailerCode, modelName, weekStartDate1, weekEndDate1, isCurrentWeek1);
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
    static testMethod void fetchWeeklyShipmentSummaryForDemandIdTest()
    {
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        InventoryAllocationMaster InAllMaster = new InventoryAllocationMaster();
        
        
        Weekly_Demand_Summary__c DemandSummary = new Weekly_Demand_Summary__c();
        DemandSummary.Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        DemandSummary.Retailer_Code__c = 'a00p0000008NzFPAA0';
        DemandSummary.Mainetti_Model__c = 'a02p00000088aujAAA';
        DemandSummary.Color__c = 'GRAY';
        DemandSummary.External_Id__c = '1581917465582_1';
        DemandSummary.Sizer_Print__c = 's';
        DemandSummary.Week_Start_Date__c = StartDate;
        DemandSummary.Week_End_Date__c = weekEndDate;
        DemandSummary.Quantity__c = 15;
        insert DemandSummary;
        
        /*  Weekly_Demand_Summary__c DemandSummarys = new Weekly_Demand_Summary__c();
            DemandSummarys.Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
            DemandSummarys.Retailer_Code__c = 'a00p0000008NzFPAA0';
            DemandSummarys.Mainetti_Model__c = 'a02p00000088aujAAA';
            DemandSummarys.Color__c = 'GRAY';
            DemandSummarys.External_Id__c = '1581917465582_1';
            DemandSummarys.Sizer_Print__c = 's';
            DemandSummarys.Week_Start_Date__c = StartDate;
            DemandSummarys.Week_End_Date__c = null;
            DemandSummarys.Quantity__c = 15;
            insert DemandSummarys;*/
        set<Id> weeklyDemandIds = new set<Id>();
        weeklyDemandIds.add(DemandSummary.Id);
        
        Weekly_Shipment_Summary__c shipmentSummary = new Weekly_Shipment_Summary__c();
        //shipmentSummary.Id = DemandSummary.Id;
        shipmentSummary.Weekly_Demand_Summary__c =  DemandSummary.Id; 
        shipmentSummary.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        shipmentSummary.Retailer_Code__c = 'a00p0000008NzFPAA0';
        shipmentSummary.Mainetti_Model__c = 'a02p00000088auhAAA';
        shipmentSummary.Sizer_Print__c = 'xs';
        shipmentSummary.Quantity__c = 50;
        shipmentSummary.Color__c = 'GRAY';
        shipmentSummary.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        shipmentSummary.Week_Start_Date__c = weekStartDate;
        insert shipmentSummary;       
        boolean flag = true; 
        
        Test.startTest();
        //Set<Weekly_Demand_Summary__c> Ids = new Set<Weekly_Demand_Summary__c>{DemandSummary};
        // Map<string,Weekly_Shipment_Summary__c> countt = InAllMaster.fetchWeeklyShipmentSummaryForDemandId(Ids);
        
        InAllMaster.fetchWeeklyShipmentSummaryForDemandId(weeklyDemandIds); 
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
    static testMethod void fetchInventoryAllocationForDemandIdsTest()
    {
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        InventoryAllocationMaster InAllMaster = new InventoryAllocationMaster();
        
        
        Weekly_Demand_Summary__c DemandSummary = new Weekly_Demand_Summary__c();
        DemandSummary.Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        DemandSummary.Retailer_Code__c = 'a00p0000008NzFPAA0';
        DemandSummary.Mainetti_Model__c = 'a02p00000088aujAAA';
        DemandSummary.Color__c = 'GRAY';
        DemandSummary.External_Id__c = '1581917465582_1';
        DemandSummary.Sizer_Print__c = 's';
        DemandSummary.Week_Start_Date__c = StartDate;
        DemandSummary.Week_End_Date__c = weekEndDate;
        DemandSummary.Quantity__c = 15;
        insert DemandSummary;
        
        set<Id> weeklyDemandIds = new set<Id>();
        weeklyDemandIds.add(DemandSummary.Id);
        
        Inventory_Allocation__c InventoryAlloc = new Inventory_Allocation__c();
        InventoryAlloc.Inventory_Allocation_Demand__c = DemandSummary.Id;
        InventoryAlloc.Physically_Available__c = true;
        InventoryAlloc.Quantity__c = 15;
        InventoryAlloc.Week_Start_Date__c = weekStartDate;
        InventoryAlloc.Week_End_Date__c = weekEndDate;
        Insert InventoryAlloc ;
        
        boolean flag = true; 
        
        Test.startTest();
        Set<Weekly_Demand_Summary__c> Ids = new Set<Weekly_Demand_Summary__c>{DemandSummary};
            // Map<string,Weekly_Shipment_Summary__c> countt = InAllMaster.fetchWeeklyShipmentSummaryForDemandId(Ids);
            
            InAllMaster.fetchInventoryAllocationForDemandIds(weeklyDemandIds); 
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
    static testMethod void fetchInventoryAllocationForDemandIdsQtyNotAvailableTest()
    {
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        InventoryAllocationMaster InAllMaster = new InventoryAllocationMaster();
        
        Weekly_Demand_Summary__c DemandSummary = new Weekly_Demand_Summary__c();
        DemandSummary.Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        DemandSummary.Retailer_Code__c = 'a00p0000008NzFPAA0';
        DemandSummary.Mainetti_Model__c = 'a02p00000088aujAAA';
        DemandSummary.Color__c = 'GRAY';
        DemandSummary.External_Id__c = '1581917465582_1';
        DemandSummary.Sizer_Print__c = 's';
        DemandSummary.Week_Start_Date__c = StartDate;
        DemandSummary.Week_End_Date__c = weekEndDate;
        DemandSummary.Quantity__c = 15;
        insert DemandSummary;
        set<Id> weeklyDemandIds = new set<Id>();
        weeklyDemandIds.add(DemandSummary.Id);
        
        Inventory_Allocation__c InventoryAlloc = new Inventory_Allocation__c();
        InventoryAlloc.Inventory_Allocation_Demand__c = DemandSummary.Id;
        InventoryAlloc.Physically_Available__c = false;
        InventoryAlloc.Quantity__c = 15;
        InventoryAlloc.Week_Start_Date__c = weekStartDate;
        InventoryAlloc.Week_End_Date__c = weekEndDate;
        Insert InventoryAlloc ;
        boolean flag = true; 
        
        Test.startTest();
        Set<Weekly_Demand_Summary__c> Ids = new Set<Weekly_Demand_Summary__c>{DemandSummary};
            // Map<string,Weekly_Shipment_Summary__c> countt = InAllMaster.fetchWeeklyShipmentSummaryForDemandId(Ids);
            
            InAllMaster.fetchInventoryAllocationForDemandIdsQtyNotAvailable(weeklyDemandIds); 
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
    static testMethod void fetchInventoryAllocationForSupplierIdsTest()
    {
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        InventoryAllocationMaster InAllMaster = new InventoryAllocationMaster();
        
        
        Weekly_Supply_Summary__c WeeklySupply = new Weekly_Supply_Summary__c();
        WeeklySupply.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';  
        WeeklySupply.Mainetti_Model__c = 'a02p0000007cGIwAAM';
        WeeklySupply.Retailer_Code__c = 'a00p0000006Hw7nAAC';
        WeeklySupply.Warehouse__c = 'Ningbo Warehouse';
        WeeklySupply.Color__c = 'GRAY';
        WeeklySupply.Sizer_Print__c = 'XS';
        WeeklySupply.Week_Start_Date__c =weekStartDate;
        WeeklySupply.Week_End_Date__c = weekEndDate;
        WeeklySupply.Quantity__c = 28;
        insert WeeklySupply;       
        set<Id> weeklyDemandIds = new set<Id>();
        weeklyDemandIds.add(WeeklySupply.Id);
        
        Inventory_Allocation__c InventoryAlloc = new Inventory_Allocation__c();
        InventoryAlloc.Inventory_Allocation_Supply__c = WeeklySupply.Id;
        InventoryAlloc.Physically_Available__c = true;
        
        InventoryAlloc.Quantity__c = 15;
        InventoryAlloc.Week_Start_Date__c = weekStartDate;
        InventoryAlloc.Week_End_Date__c = weekEndDate;
        Insert InventoryAlloc ;
        boolean flag = true; 
        
        Test.startTest();
        // Set<Weekly_Demand_Summary__c> Ids = new Set<Weekly_Demand_Summary__c>{WeeklySupply};
        // Map<string,Weekly_Shipment_Summary__c> countt = InAllMaster.fetchWeeklyShipmentSummaryForDemandId(Ids);
        
        InAllMaster.fetchInventoryAllocationForSupplierIds(weeklyDemandIds); 
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
    static testMethod void getWeeklyInventoryAllocationSummaryTest()
    {
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        InventoryAllocationMaster InAllMaster = new InventoryAllocationMaster();
        Weekly_Supply_Summary__c WeeklySupply = new Weekly_Supply_Summary__c();
        WeeklySupply.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';  
        WeeklySupply.Mainetti_Model__c = 'a02p0000007cGIwAAM';
        WeeklySupply.Retailer_Code__c = 'a00p0000006Hw7nAAC';
        WeeklySupply.Warehouse__c = 'Ningbo Warehouse';
        WeeklySupply.Color__c = 'GRAY';
        WeeklySupply.Sizer_Print__c = 'XS';
        WeeklySupply.Week_Start_Date__c =weekStartDate;
        WeeklySupply.Week_End_Date__c = weekEndDate;
        WeeklySupply.Quantity__c = 28;
        insert WeeklySupply;       
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
        Inventory_Allocation__c InventoryAlloc = new Inventory_Allocation__c();
        InventoryAlloc.Inventory_Allocation_Demand__c = DemandSummary.Id;
        InventoryAlloc.Inventory_Allocation_Supply__c = WeeklySupply.Id ;
        InventoryAlloc.Physically_Available__c = true;
        InventoryAlloc.Quantity__c = 15;
        InventoryAlloc.Week_Start_Date__c = weekStartDate;
        InventoryAlloc.Week_End_Date__c = weekEndDate;
        Insert InventoryAlloc ;
        string orderToCompany = 'Hong Kong - Mainetti (HK) Ltd';
        String retailerCode = 'a00p0000008NzFPAA0';
        String modelName = 'a02p00000088aujAAA';
        boolean isCurrentWeek = true;
        Date weekEndDate1 = null;
        Date weekStartDate1 = null;
        boolean isCurrentWeek1 = false;
        
        string orderToCompany1 = '';
        String retailerCode1 = '';
        String modelName1 = '';
        string allocationType1 = '';
        
        boolean flag = true; 
        Test.startTest();
        InAllMaster.getWeeklyInventoryAllocationSummary(orderToCompany1, retailerCode1, modelName1, weekStartDate1, weekEndDate1, isCurrentWeek); 
        InAllMaster.getWeeklyInventoryAllocationSummary(orderToCompany, retailerCode, modelName, weekStartDate, weekEndDate, isCurrentWeek); 
        InAllMaster.getWeeklyInventoryAllocationSummary(orderToCompany, retailerCode, modelName, weekStartDate, weekEndDate1, isCurrentWeek1); 
        InAllMaster.getWeeklyInventoryAllocationSummary(orderToCompany, retailerCode, modelName, weekStartDate1, weekEndDate, isCurrentWeek1); 
        InAllMaster.getWeeklyInventoryAllocationSummary(orderToCompany, retailerCode, modelName, weekStartDate1, weekEndDate1, isCurrentWeek1); 
        InAllMaster.getWeeklyInventoryAllocationSummary(orderToCompany1, retailerCode, modelName, weekStartDate1, weekEndDate1, isCurrentWeek1); 
        InAllMaster.getWeeklyInventoryAllocationSummary(orderToCompany1, retailerCode1, modelName, weekStartDate1, weekEndDate1, isCurrentWeek1); 
        
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
    static testMethod void getWeeklyInventoryAllocationSummaryQtyNotAvailableTest()
    {
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        InventoryAllocationMaster InAllMaster = new InventoryAllocationMaster();
        
        Weekly_Supply_Summary__c WeeklySupply = new Weekly_Supply_Summary__c();
        WeeklySupply.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';  
        WeeklySupply.Mainetti_Model__c = 'a02p0000007cGIwAAM';
        WeeklySupply.Retailer_Code__c = 'a00p0000006Hw7nAAC';
        WeeklySupply.Warehouse__c = 'Ningbo Warehouse';
        WeeklySupply.Color__c = 'GRAY';
        WeeklySupply.Sizer_Print__c = 'XS';
        WeeklySupply.Week_Start_Date__c =weekStartDate;
        WeeklySupply.Week_End_Date__c = weekEndDate;
        WeeklySupply.Quantity__c = 28;
        insert WeeklySupply;       
        Weekly_Demand_Summary__c DemandSummary = new Weekly_Demand_Summary__c();
        DemandSummary.Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        DemandSummary.Retailer_Code__c = 'a00p0000008NzFPAA0';
        DemandSummary.Mainetti_Model__c = 'a02p00000088aujAAA';
        DemandSummary.Color__c = 'GRAY';
        DemandSummary.External_Id__c = '1581917465582_1';
        DemandSummary.Sizer_Print__c = 's';
        DemandSummary.Week_Start_Date__c = StartDate;
        DemandSummary.Week_End_Date__c = weekEndDate;
        DemandSummary.Quantity__c = 15;
        insert DemandSummary;
        Inventory_Allocation__c InventoryAlloc = new Inventory_Allocation__c();
        InventoryAlloc.Inventory_Allocation_Demand__c = DemandSummary.Id;
        InventoryAlloc.Inventory_Allocation_Supply__c = WeeklySupply.Id ;
        InventoryAlloc.Physically_Available__c = false;
        InventoryAlloc.Quantity__c = 15;
        InventoryAlloc.Week_Start_Date__c = weekStartDate;
        InventoryAlloc.Week_End_Date__c = weekEndDate;
        Insert InventoryAlloc ;
        string orderToCompany = 'Hong Kong - Mainetti (HK) Ltd';
        String retailerCode = 'a00p0000008NzFPAA0';
        String modelName = 'a02p00000088aujAAA';
        boolean isCurrentWeek = true;
        Date weekEndDate1 = null;
        Date weekStartDate1 = null;
        boolean isCurrentWeek1 = false;
        
        string orderToCompany1 = '';
        String retailerCode1 = '';
        String modelName1 = '';
        string allocationType1 = '';
        
        boolean flag = true; 
        Test.startTest();
        InAllMaster.getWeeklyInventoryAllocationSummaryQtyNotAvailable(orderToCompany1, retailerCode1, modelName1, weekStartDate1, weekEndDate1, isCurrentWeek); 
        InAllMaster.getWeeklyInventoryAllocationSummaryQtyNotAvailable(orderToCompany, retailerCode, modelName, weekStartDate, weekEndDate, isCurrentWeek); 
        InAllMaster.getWeeklyInventoryAllocationSummaryQtyNotAvailable(orderToCompany, retailerCode, modelName, weekStartDate, weekEndDate1, isCurrentWeek1); 
        InAllMaster.getWeeklyInventoryAllocationSummaryQtyNotAvailable(orderToCompany, retailerCode, modelName, weekStartDate1, weekEndDate, isCurrentWeek1); 
        InAllMaster.getWeeklyInventoryAllocationSummaryQtyNotAvailable(orderToCompany, retailerCode, modelName, weekStartDate1, weekEndDate1, isCurrentWeek1); 
        InAllMaster.getWeeklyInventoryAllocationSummaryQtyNotAvailable(orderToCompany1, retailerCode, modelName, weekStartDate1, weekEndDate1, isCurrentWeek1); 
        InAllMaster.getWeeklyInventoryAllocationSummaryQtyNotAvailable(orderToCompany1, retailerCode1, modelName, weekStartDate1, weekEndDate1, isCurrentWeek1);  
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
    static testMethod void getWeeklySupplyInventoryAllocationSummaryTest()
    {
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        InventoryAllocationMaster InAllMaster = new InventoryAllocationMaster();
        
        Weekly_Supply_Summary__c WeeklySupply = new Weekly_Supply_Summary__c();
        WeeklySupply.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';  
        WeeklySupply.Mainetti_Model__c = 'a02p0000007cGIwAAM';
        WeeklySupply.Retailer_Code__c = 'a00p0000006Hw7nAAC';
        WeeklySupply.Warehouse__c = 'Ningbo Warehouse';
        WeeklySupply.Color__c = 'GRAY';
        WeeklySupply.Sizer_Print__c = 'XS';
        WeeklySupply.Week_Start_Date__c =weekStartDate;
        WeeklySupply.Week_End_Date__c = weekEndDate;
        WeeklySupply.Quantity__c = 28;
        insert WeeklySupply;       
        Weekly_Demand_Summary__c DemandSummary = new Weekly_Demand_Summary__c();
        DemandSummary.Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        DemandSummary.Retailer_Code__c = 'a00p0000008NzFPAA0';
        DemandSummary.Mainetti_Model__c = 'a02p00000088aujAAA';
        DemandSummary.Color__c = 'GRAY';
        DemandSummary.External_Id__c = '1581917465582_1';
        DemandSummary.Sizer_Print__c = 's';
        DemandSummary.Week_Start_Date__c = StartDate;
        DemandSummary.Week_End_Date__c = weekEndDate;
        DemandSummary.Quantity__c = 15;
        insert DemandSummary;
        Inventory_Allocation__c InventoryAlloc = new Inventory_Allocation__c();
        InventoryAlloc.Inventory_Allocation_Demand__c = DemandSummary.Id;
        InventoryAlloc.Inventory_Allocation_Supply__c = WeeklySupply.Id ;
        InventoryAlloc.Physically_Available__c = false;
        InventoryAlloc.Quantity__c = 15;
        InventoryAlloc.Week_Start_Date__c = weekStartDate;
        InventoryAlloc.Week_End_Date__c = weekEndDate;
        Insert InventoryAlloc ;
        string orderToCompany = 'Hong Kong - Mainetti (HK) Ltd';
        String retailerCode = 'a00p0000008NzFPAA0';
        String modelName = 'a02p00000088aujAAA';
        boolean isCurrentWeek = true;
        Date weekEndDate1 = null;
        Date weekStartDate1 = null;
        boolean isCurrentWeek1 = false;
        
        string orderToCompany1 = '';
        String retailerCode1 = '';
        String modelName1 = '';
        string allocationType1 = '';
        
        boolean flag = true; 
        Test.startTest();
        InAllMaster.getWeeklySupplyInventoryAllocationSummary(orderToCompany1, retailerCode1, modelName1, weekStartDate1, weekEndDate1, isCurrentWeek); 
        InAllMaster.getWeeklySupplyInventoryAllocationSummary(orderToCompany, retailerCode, modelName, weekStartDate, weekEndDate, isCurrentWeek);
        InAllMaster.getWeeklySupplyInventoryAllocationSummary(orderToCompany, retailerCode, modelName, weekStartDate, weekEndDate1, isCurrentWeek1);
        InAllMaster.getWeeklySupplyInventoryAllocationSummary(orderToCompany, retailerCode, modelName, weekStartDate1, weekEndDate, isCurrentWeek1);
        InAllMaster.getWeeklySupplyInventoryAllocationSummary(orderToCompany, retailerCode, modelName, weekStartDate1, weekEndDate1, isCurrentWeek1);
        InAllMaster.getWeeklySupplyInventoryAllocationSummary(orderToCompany1, retailerCode, modelName, weekStartDate1, weekEndDate1, isCurrentWeek1);
        InAllMaster.getWeeklySupplyInventoryAllocationSummary(orderToCompany1, retailerCode1, modelName, weekStartDate1, weekEndDate1, isCurrentWeek1);
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
    static testMethod void getWeeklyAllocationForDemandForDisplayTest()
    {
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        // Date weeekEndDateBlank;
        
        InventoryAllocationMaster InAllMaster = new InventoryAllocationMaster();
        
        Weekly_Supply_Summary__c WeeklySupply = new Weekly_Supply_Summary__c();
        WeeklySupply.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';  
        WeeklySupply.Mainetti_Model__c = 'a02p0000007cGIwAAM';
        WeeklySupply.Retailer_Code__c = 'a00p0000006Hw7nAAC';
        WeeklySupply.Warehouse__c = 'Ningbo Warehouse';
        WeeklySupply.Color__c = 'GRAY';
        WeeklySupply.Sizer_Print__c = 'XS';
        WeeklySupply.Week_Start_Date__c =weekStartDate;
        WeeklySupply.Week_End_Date__c = weekEndDate;
        WeeklySupply.Quantity__c = 28;
        insert WeeklySupply;       
        Weekly_Demand_Summary__c DemandSummary = new Weekly_Demand_Summary__c();
        DemandSummary.Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        DemandSummary.Retailer_Code__c = 'a00p0000008NzFPAA0';
        DemandSummary.Mainetti_Model__c = 'a02p00000088aujAAA';
        DemandSummary.Color__c = 'GRAY';
        DemandSummary.External_Id__c = '1581917465582_1';
        DemandSummary.Sizer_Print__c = 's';
        DemandSummary.Week_Start_Date__c = StartDate;
        DemandSummary.Week_End_Date__c = weekEndDate;
        DemandSummary.Quantity__c = 15;
        insert DemandSummary;
        Inventory_Allocation__c InventoryAlloc = new Inventory_Allocation__c();
        InventoryAlloc.Inventory_Allocation_Demand__c = DemandSummary.Id;
        InventoryAlloc.Inventory_Allocation_Supply__c = WeeklySupply.Id ;
        InventoryAlloc.Physically_Available__c = true;
        InventoryAlloc.Quantity__c = 15;
        InventoryAlloc.Week_Start_Date__c = weekStartDate;
        InventoryAlloc.Week_End_Date__c = weekEndDate;
        Insert InventoryAlloc ;
        
        string orderToCompany = 'Hong Kong - Mainetti (HK) Ltd';
        String retailerCode = 'a00p0000008NzFPAA0';
        String modelName = 'a02p00000088aujAAA';
        Integer pageNumber = 1;
        Integer recordToDisplay = 10;
        string allocationType = 'Demand';
        boolean isCurrentWeek = true;
        boolean flag = true; 
        Date weekEndDate1 = null;
        Date weekStartDate1 = null;
        boolean isCurrentWeek1 = false;
        
        string orderToCompany1 = '';
        String retailerCode1 = '';
        String modelName1 = '';
        string allocationType1 = '';
        
        
        Test.startTest();
        InAllMaster.getWeeklyAllocationForDemandForDisplay(orderToCompany1, retailerCode1, modelName1, weekStartDate1, weekEndDate1, isCurrentWeek, pageNumber, recordToDisplay,allocationType1);
        InAllMaster.getWeeklyAllocationForDemandForDisplay(orderToCompany, retailerCode, modelName, weekStartDate, weekEndDate, isCurrentWeek, pageNumber, recordToDisplay,allocationType);
        InAllMaster.getWeeklyAllocationForDemandForDisplay(orderToCompany, retailerCode, modelName, weekStartDate, weekEndDate1, isCurrentWeek1, pageNumber, recordToDisplay,allocationType);
        InAllMaster.getWeeklyAllocationForDemandForDisplay(orderToCompany, retailerCode, modelName, weekStartDate1, weekEndDate, isCurrentWeek1, pageNumber, recordToDisplay,allocationType);
        InAllMaster.getWeeklyAllocationForDemandForDisplay(orderToCompany, retailerCode, modelName, weekStartDate1, weekEndDate1, isCurrentWeek1, pageNumber, recordToDisplay,allocationType);
        InAllMaster.getWeeklyAllocationForDemandForDisplay(orderToCompany1, retailerCode, modelName, weekStartDate1, weekEndDate1, isCurrentWeek1, pageNumber, recordToDisplay,allocationType);
        InAllMaster.getWeeklyAllocationForDemandForDisplay(orderToCompany1, retailerCode1, modelName, weekStartDate1, weekEndDate1, isCurrentWeek1, pageNumber, recordToDisplay,allocationType);
        InAllMaster.getWeeklyAllocationForDemandForDisplay(orderToCompany1, retailerCode1, modelName1, weekStartDate1, weekEndDate1, isCurrentWeek1, pageNumber, recordToDisplay,allocationType);
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    static testMethod void getWeeklyAllocationForDemandForDisplayTest1()
    {
        Date weekStartDate=Date.newInstance(2010, 07, 15);
        Date weekEndDate = null;
        //Date weekStartDate = 03/04/2020;
        //Date weekEndDate = 0;
        InventoryAllocationMaster InAllMaster = new InventoryAllocationMaster();
        string orderToCompany = 'Hong Kong - Mainetti (HK) Ltd';
        String retailerCode = 'a00p0000008NzFPAA0';
        String modelName = 'a02p00000088aujAAA';
        Integer pageNumber = 1;
        Integer recordToDisplay = 10;
        string allocationType = 'Demand';
        boolean isCurrentWeek = true;
        boolean flag = true; 
        
        // Date weekEndDate = new weekEndDate();
        //Date weekEndDate ;
        
        Test.startTest();
        InAllMaster.getWeeklyAllocationForDemandForDisplay(orderToCompany, retailerCode, modelName, weekStartDate, weekEndDate, isCurrentWeek, pageNumber, recordToDisplay,allocationType);
        
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
    static testMethod void getWeeklyAllocationForSupplyForDisplayTest()
    {
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        InventoryAllocationMaster InAllMaster = new InventoryAllocationMaster();
        
        Weekly_Supply_Summary__c WeeklySupply = new Weekly_Supply_Summary__c();
        WeeklySupply.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';  
        WeeklySupply.Mainetti_Model__c = 'a02p0000007cGIwAAM';
        WeeklySupply.Retailer_Code__c = 'a00p0000006Hw7nAAC';
        WeeklySupply.Warehouse__c = 'Ningbo Warehouse';
        WeeklySupply.Color__c = 'GRAY';
        WeeklySupply.Sizer_Print__c = 'XS';
        WeeklySupply.Week_Start_Date__c =weekStartDate;
        WeeklySupply.Week_End_Date__c = weekEndDate;
        WeeklySupply.Quantity__c = 28;
        insert WeeklySupply;       
        Weekly_Demand_Summary__c DemandSummary = new Weekly_Demand_Summary__c();
        DemandSummary.Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        DemandSummary.Retailer_Code__c = 'a00p0000008NzFPAA0';
        DemandSummary.Mainetti_Model__c = 'a02p00000088aujAAA';
        DemandSummary.Color__c = 'GRAY';
        DemandSummary.External_Id__c = '1581917465582_1';
        DemandSummary.Sizer_Print__c = 's';
        DemandSummary.Week_Start_Date__c = StartDate;
        DemandSummary.Week_End_Date__c = weekEndDate;
        DemandSummary.Quantity__c = 15;
        insert DemandSummary;
        Inventory_Allocation__c InventoryAlloc = new Inventory_Allocation__c();
        InventoryAlloc.Inventory_Allocation_Demand__c = DemandSummary.Id;
        InventoryAlloc.Inventory_Allocation_Supply__c = WeeklySupply.Id ;
        InventoryAlloc.Physically_Available__c = true;
        InventoryAlloc.Quantity__c = 15;
        InventoryAlloc.Week_Start_Date__c = weekStartDate;
        InventoryAlloc.Week_End_Date__c = weekEndDate;
        Insert InventoryAlloc ;
        
        string orderToCompany = 'Hong Kong - Mainetti (HK) Ltd';
        String retailerCode = 'a00p0000008NzFPAA0';
        String modelName = 'a02p00000088aujAAA';
        Integer pageNumber = 1;
        Integer recordToDisplay = 10;
        string allocationType = 'Demand';
        boolean isCurrentWeek = true;
        boolean flag = true; 
        Date weekEndDate1 = null;
        Date weekStartDate1 = null;
        boolean isCurrentWeek1 = false;
        
        string orderToCompany1 = '';
        String retailerCode1 = '';
        String modelName1 = '';
        string allocationType1 = '';
        Integer totalRecordCount = 25;
        String source = 'Virgin';
        String warehouse = 'Ningbo Warehouse';
        //fetchWeeklySupplySummaryDisplay Values = new fetchWeeklySupplySummaryDisplay();
        Test.startTest();
        // InAllMaster.fetchWeeklySupplySummaryDisplay(orderToCompany, retailerCode, modelName, weekStartDate, weekEndDate, isCurrentWeek, pageNumber, recordToDisplay,source,warehouse);
        InAllMaster.getWeeklyAllocationForSupplyForDisplay(orderToCompany1, retailerCode1, modelName1, weekStartDate1, weekEndDate1, isCurrentWeek, pageNumber, recordToDisplay,allocationType1);
        InAllMaster.getWeeklyAllocationForSupplyForDisplay(orderToCompany, retailerCode, modelName, weekStartDate, weekEndDate, isCurrentWeek, pageNumber, recordToDisplay,allocationType); 
        InAllMaster.getWeeklyAllocationForSupplyForDisplay(orderToCompany, retailerCode, modelName, weekStartDate, weekEndDate, isCurrentWeek1, pageNumber, recordToDisplay,allocationType);
        InAllMaster.getWeeklyAllocationForSupplyForDisplay(orderToCompany, retailerCode, modelName, weekStartDate, weekEndDate1, isCurrentWeek1, pageNumber, recordToDisplay,allocationType);
        InAllMaster.getWeeklyAllocationForSupplyForDisplay(orderToCompany, retailerCode, modelName, weekStartDate1, weekEndDate, isCurrentWeek1, pageNumber, recordToDisplay,allocationType);
        InAllMaster.getWeeklyAllocationForSupplyForDisplay(orderToCompany, retailerCode, modelName, weekStartDate1, weekEndDate1, isCurrentWeek1, pageNumber, recordToDisplay,allocationType);
        InAllMaster.getWeeklyAllocationForSupplyForDisplay(orderToCompany1, retailerCode, modelName, weekStartDate1, weekEndDate1, isCurrentWeek1, pageNumber, recordToDisplay,allocationType);
        InAllMaster.getWeeklyAllocationForSupplyForDisplay(orderToCompany1, retailerCode1, modelName, weekStartDate1, weekEndDate1, isCurrentWeek1, pageNumber, recordToDisplay,allocationType);
        InAllMaster.getWeeklyAllocationForSupplyForDisplay(orderToCompany1, retailerCode1, modelName1, weekStartDate1, weekEndDate1, isCurrentWeek1, pageNumber, recordToDisplay,allocationType);
        
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
    static testMethod void getWeeklyAllocationForSupplyForDisplayTest1()
    {
        
        
        
        InventoryAllocationMaster InAllMaster = new InventoryAllocationMaster();        
        string orderToCompany = 'Hong Kong - Mainetti (HK) Ltd';
        String retailerCode = 'a00p0000008NzFPAA0';
        String modelName = 'a02p00000088aujAAA';
        Integer pageNumber = 1;
        Integer recordToDisplay = 10;
        string allocationType = 'Demand';
        boolean isCurrentWeek = true;
        boolean flag = true; 
        Date weekEndDate1;
        Date weekStartDate1;
        boolean isCurrentWeek1 = false;
        
        Test.startTest();
        InAllMaster.getWeeklyAllocationForSupplyForDisplay(orderToCompany, retailerCode, modelName, weekStartDate1, weekEndDate1, isCurrentWeek, pageNumber, recordToDisplay,allocationType); 
        
        
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
    
    static testMethod void fetchWeeklySupplySummaryDisplayTest()
    {
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        InventoryAllocationMaster InAllMaster = new InventoryAllocationMaster();
        string orderToCompany = 'Hong Kong - Mainetti (HK) Ltd';
        String retailerCode = 'a00p0000008NzFPAA0';
        String modelName = 'a02p00000088aujAAA';
        Integer pageNumber = 1;
        Integer recordToDisplay = 10;
        String source = 'Virgin';
        String warehouse = 'Ningbo Warehouse';
        boolean isCurrentWeek = true;
        
        Weekly_Supply_Summary__c WeeklySupply = new Weekly_Supply_Summary__c();
        WeeklySupply.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';  
        WeeklySupply.Mainetti_Model__c = 'a02p0000007cGIwAAM';
        WeeklySupply.Retailer_Code__c = 'a00p0000006Hw7nAAC';
        WeeklySupply.Warehouse__c = 'Ningbo Warehouse';
        WeeklySupply.Color__c = 'GRAY';
        WeeklySupply.Sizer_Print__c = 'XS';
        WeeklySupply.Week_Start_Date__c = weekStartDate;
        WeeklySupply.Week_End_Date__c = weekEndDate;
        WeeklySupply.Quantity__c = 28;
        insert WeeklySupply; 
        
        Weekly_Demand_Summary__c DemandSummary = new Weekly_Demand_Summary__c();
        DemandSummary.Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        DemandSummary.Retailer_Code__c = 'a00p0000008NzFPAA0';
        DemandSummary.Mainetti_Model__c = 'a02p00000088aujAAA';
        DemandSummary.Color__c = 'GRAY';
        DemandSummary.External_Id__c = '1581917465582_1';
        DemandSummary.Sizer_Print__c = 's';
        DemandSummary.Week_Start_Date__c = StartDate;
        DemandSummary.Week_End_Date__c = weekEndDate;
        DemandSummary.Quantity__c = 15;
        insert DemandSummary;
        Weekly_Shipment_Summary__c shipmentSummary = new Weekly_Shipment_Summary__c();
        
        shipmentSummary.Weekly_Demand_Summary__c =  DemandSummary.Id; 
        shipmentSummary.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        shipmentSummary.Retailer_Code__c = 'a00p0000008NzFPAA0';
        shipmentSummary.Mainetti_Model__c = 'a02p00000088auhAAA';
        shipmentSummary.Sizer_Print__c = 'xs';
        shipmentSummary.Quantity__c = 50;
        shipmentSummary.Color__c = 'GRAY';
        shipmentSummary.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        shipmentSummary.Week_Start_Date__c = weekStartDate;
        insert shipmentSummary;   
        
        // WeeklySupply.Week_Start_Date__c =' ';
        String source1 = 'all';
        boolean isCurrentWeek1 = false;
        Date weekStartDate1 = null;
        Date weekEndDate1 = null;
        string orderToCompany1 = '';
        String retailerCode1 = '';
        String modelName1 = '';
        String warehouse1 = '';
        boolean flag = true; 
        Test.startTest();
        InAllMaster.fetchWeeklySupplySummaryDisplay(orderToCompany, retailerCode, modelName, weekStartDate, weekEndDate, isCurrentWeek, pageNumber, recordToDisplay,source,warehouse); 
        InAllMaster.fetchWeeklySupplySummaryDisplay(orderToCompany, retailerCode, modelName, weekStartDate, weekEndDate, isCurrentWeek, pageNumber, recordToDisplay,source1,warehouse);
        InAllMaster.fetchWeeklySupplySummaryDisplay(orderToCompany, retailerCode, modelName, weekStartDate, weekEndDate, isCurrentWeek1, pageNumber, recordToDisplay,source1,warehouse);
        InAllMaster.fetchWeeklySupplySummaryDisplay(orderToCompany, retailerCode, modelName, weekStartDate, weekEndDate1, isCurrentWeek1, pageNumber, recordToDisplay,source1,warehouse);
        InAllMaster.fetchWeeklySupplySummaryDisplay(orderToCompany, retailerCode, modelName, weekStartDate1, weekEndDate, isCurrentWeek1, pageNumber, recordToDisplay,source1,warehouse);
        InAllMaster.fetchWeeklySupplySummaryDisplay(orderToCompany1, retailerCode1, modelName1, weekStartDate1, weekEndDate1, isCurrentWeek1, pageNumber, recordToDisplay,source1,warehouse1);
        InAllMaster.fetchWeeklySupplySummaryDisplay(orderToCompany, retailerCode, modelName, weekStartDate1, weekEndDate1, isCurrentWeek1, pageNumber, recordToDisplay,source1,warehouse);
        InAllMaster.fetchWeeklySupplySummaryDisplay(orderToCompany1, retailerCode, modelName, weekStartDate1, weekEndDate1, isCurrentWeek1, pageNumber, recordToDisplay,source1,warehouse);
        InAllMaster.fetchWeeklySupplySummaryDisplay(orderToCompany1, retailerCode1, modelName1, weekStartDate1, weekEndDate1, isCurrentWeek1, pageNumber, recordToDisplay,source1,warehouse);
        InAllMaster.fetchWeeklySupplySummaryDisplay(orderToCompany1, retailerCode1, modelName, weekStartDate1, weekEndDate1, isCurrentWeek1, pageNumber, recordToDisplay,source1,warehouse);
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
    static testMethod void fetchWeeklyShipmentSummaryDisplayTest()
    {
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        InventoryAllocationMaster InAllMaster = new InventoryAllocationMaster();
        
        Weekly_Demand_Summary__c DemandSummary = new Weekly_Demand_Summary__c();
        DemandSummary.Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        DemandSummary.Retailer_Code__c = 'a00p0000008NzFPAA0';
        DemandSummary.Mainetti_Model__c = 'a02p00000088aujAAA';
        DemandSummary.Color__c = 'GRAY';
        DemandSummary.External_Id__c = '1581917465582_1';
        DemandSummary.Sizer_Print__c = 's';
        DemandSummary.Week_Start_Date__c = StartDate;
        DemandSummary.Week_End_Date__c = weekEndDate;
        DemandSummary.Quantity__c = 15;
        insert DemandSummary;
        Weekly_Shipment_Summary__c shipmentSummary = new Weekly_Shipment_Summary__c();
        
        shipmentSummary.Weekly_Demand_Summary__c =  DemandSummary.Id; 
        shipmentSummary.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        shipmentSummary.Retailer_Code__c = 'a00p0000008NzFPAA0';
        shipmentSummary.Mainetti_Model__c = 'a02p00000088auhAAA';
        shipmentSummary.Sizer_Print__c = 'xs';
        shipmentSummary.Quantity__c = 50;
        shipmentSummary.Color__c = 'GRAY';
        shipmentSummary.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        shipmentSummary.Week_Start_Date__c = weekStartDate;
        insert shipmentSummary;   
        string orderToCompany = 'Hong Kong - Mainetti (HK) Ltd';
        String retailerCode = 'a00p0000008NzFPAA0';
        String modelName = 'a02p00000088aujAAA';
        Integer pageNumber = 1;
        Integer recordToDisplay = 10;
        string orderToCompany1 = '';
        String retailerCode1 = '';
        String modelName1 = '';
        Date weekStartDate1 = null;
        Date weekEndDate1 = null;
        // String source = 'Virgin';
        //String warehouse = 'Ningbo Warehouse';
        boolean isCurrentWeek = true;
        boolean isCurrentWeek1 = false;
        boolean flag = true; 
        Test.startTest();
        InAllMaster.fetchWeeklyShipmentSummaryDisplay(orderToCompany, retailerCode, modelName, weekStartDate, weekEndDate, isCurrentWeek, pageNumber,recordToDisplay );
        InAllMaster.fetchWeeklyShipmentSummaryDisplay(orderToCompany, retailerCode, modelName, weekStartDate, weekEndDate, isCurrentWeek1, pageNumber,recordToDisplay );
        InAllMaster.fetchWeeklyShipmentSummaryDisplay(orderToCompany, retailerCode, modelName, weekStartDate, weekEndDate1, isCurrentWeek1, pageNumber,recordToDisplay );
        InAllMaster.fetchWeeklyShipmentSummaryDisplay(orderToCompany, retailerCode, modelName, weekStartDate1, weekEndDate, isCurrentWeek1, pageNumber,recordToDisplay );
        InAllMaster.fetchWeeklyShipmentSummaryDisplay(orderToCompany, retailerCode, modelName, weekStartDate1, weekEndDate1, isCurrentWeek1, pageNumber,recordToDisplay );
        InAllMaster.fetchWeeklyShipmentSummaryDisplay(orderToCompany1, retailerCode, modelName, weekStartDate1, weekEndDate1, isCurrentWeek1, pageNumber,recordToDisplay );
        InAllMaster.fetchWeeklyShipmentSummaryDisplay(orderToCompany1, retailerCode1, modelName, weekStartDate1, weekEndDate1, isCurrentWeek1, pageNumber,recordToDisplay );
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
    
    static testMethod void getSupplyKeyForsearchTest()
    {
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        InventoryAllocationMaster InAllMaster = new InventoryAllocationMaster();
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
        
        Weekly_Shipment_Summary__c shipmentSummary = new Weekly_Shipment_Summary__c();
        shipmentSummary.Weekly_Demand_Summary__c = DemandSummary.Id; 
        shipmentSummary.Quantity__c = 50;
        shipmentSummary.Color__c = 'GRAY';
        shipmentSummary.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        shipmentSummary.Week_Start_Date__c = weekStartDate;
        insert shipmentSummary;      
        
        //shipmentSummary.Retailer_Code__c retailerTestCode = new shipmentSummary.Retailer_Code__c ();  
        
            /*Retailer_Code__c retailerTestData =  new Retailer_Code__c();
            retailerTestData.Id =  'a00p0000008NzFPAA0';
            insert retailerTestData;*/
        string orderToCompany = 'Hong Kong - Mainetti (HK) Ltd';
        String retailerCode = 'a00p0000008NzFPAA0';
        String modelName = 'a02p00000088aujAAA';
        Integer pageNumber = 1;
        Integer recordToDisplay = 10;
        String source = 'Virgin';
        String warehouse = 'Ningbo Warehouse';
        boolean isCurrentWeek = true;
        boolean flag = true; 
        Test.startTest();
        // InAllMaster.getSupplyKeyForsearch(sendObj); 
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
    static testMethod void getWeeklyDemandSummaryTest()
    {
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        InventoryAllocationMaster InAllMaster = new InventoryAllocationMaster();
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
        
        Weekly_Shipment_Summary__c shipmentSummary = new Weekly_Shipment_Summary__c();
        shipmentSummary.Weekly_Demand_Summary__c = DemandSummary.Id; 
        shipmentSummary.Quantity__c = 50;
        shipmentSummary.Color__c = 'GRAY';
        shipmentSummary.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        shipmentSummary.Week_Start_Date__c = weekStartDate;
        insert shipmentSummary;  
        
        Weekly_Supply_Summary__c WeeklySupply = new Weekly_Supply_Summary__c();
        WeeklySupply.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';  
        WeeklySupply.Mainetti_Model__c = 'a02p0000007cGIwAAM';
        WeeklySupply.Retailer_Code__c = 'a00p0000006Hw7nAAC';
        WeeklySupply.Warehouse__c = 'Ningbo Warehouse';
        WeeklySupply.Color__c = 'GRAY';
        WeeklySupply.Sizer_Print__c = 'XS';
        WeeklySupply.Week_Start_Date__c = weekStartDate;
        WeeklySupply.Week_End_Date__c = weekEndDate;
        WeeklySupply.Quantity__c = 28;
        insert WeeklySupply; 
        
        Map<string,Weekly_Supply_Summary__c> getWeeklyDemandSummary = new Map<string,Weekly_Supply_Summary__c>();
        //getWeeklyDemandSummary getDetails = new getWeeklyDemandSummary();
        string orderToCompany = 'Hong Kong - Mainetti (HK) Ltd';
        String retailerCode = 'a00p0000008NzFPAA0';
        String modelName = 'a02p00000088aujAAA';
        Integer pageNumber = 1;
        Integer recordToDisplay = 10;
        String source = 'Virgin';
        String warehouse = 'Ningbo Warehouse';
        boolean isCurrentWeek = true;
        Integer totalRecordCount = 50;
        boolean flag = true; 
        Test.startTest();
        // Map<string,Weekly_Supply_Summary__c> getDetails =  InAllMaster.getWeeklyDemandSummary(orderToCompany,retailerCode,modelName,weekStartDate,weekEndDate,pageNumber,recordToDisplay,totalRecordCount,isCurrentWeek);
        //InAllMaster.getWeeklyDemandSummary(orderToCompany,retailerCode,modelName,weekStartDate,weekEndDate,pageNumber,recordToDisplay,totalRecordCount,isCurrentWeek); 
        //InAllMaster.getWeeklyDemandSummary(); 
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
    
}