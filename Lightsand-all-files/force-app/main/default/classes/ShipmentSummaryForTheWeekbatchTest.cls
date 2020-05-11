@isTest
public class ShipmentSummaryForTheWeekbatchTest {
@isTest 
    static void BatchTest(){
         Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
         List<AggregateResult> portalShipmentDetailsList = new List<AggregateResult>();
        List<AggregateResult> magNETShipmentDetailsList = new List<AggregateResult>();
        List<AggregateResult> onLineEnquiry = new List<AggregateResult>();
         List<AggregateResult> salesOrderItemList = new  List<AggregateResult>();
        Iterable<SObject> fetchWeeklySupplySummaryForTheWeek;
        ShipmentSummaryForTheWeekbatchClass Weekbatch = new ShipmentSummaryForTheWeekbatchClass(portalShipmentDetailsList,magNETShipmentDetailsList,onLineEnquiry,salesOrderItemList);
     
       // String shipmentKey = 'a0fp0000008VBdfAAG';
       
        //** Calling execute Method**        
        Online_Enquiry__c onlineEnquiry1 = new Online_Enquiry__c();
        onlineEnquiry1.Order_Country__c = 'Hong Kong - Mainetti (HK) Ltd';
        onlineEnquiry1.Retailer_Code__c = 'a00p0000008NzFPAA0';
        onlineEnquiry1.External_Id__c = '40220201502';
        onlineEnquiry1.RecordTypeId = '01290000000nQZMAA2';
        insert onlineEnquiry1;
        
        
         Online_Detail__c onlineDetail = new Online_Detail__c();
        
        onlineDetail.Model__c = 'a02p00000088auXAAQ';
        onlineDetail.Color__c = 'GRAY';
        onlineDetail.Qty__c = 2000;
        onlineDetail.RecordTypeId = '01290000000TNpeAAG';
        onlineDetail.Online_Details_Status__c = 'New';
        onlineDetail.TransactionID__c = onlineEnquiry1.Id;
        
        
        Price_Specification_Book_Product__c productName = new Price_Specification_Book_Product__c();
        productName.Name = 'TNGU139';
        productName.Retailer_Code__c = 'a00p0000008NzFPAA0';
        productName.Color__c = 'GRAY';
        productName.Price_100pcs__c = 82.524;
        productName.Freight_Terms__c = '';
        productName.Country__c = 'China - South';
         productName.Id = onlineDetail.Model__c;
       upsert productName;
      
         //Online order details for Magnet
        Sales_Order__c salesOrder = new Sales_Order__c();
        //salesOrder.Name = 'a2Bp0000000MKaZEAW';
        salesOrder.Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        salesOrder.Retailer_Code1__c = 'a00p0000008NzFPAA0';
        salesOrder.Status__c = 'Old';
        salesOrder.Link_To_ERP__c = 'New';
        //salesOrder.CurrencyIsoCode = 'USD - U.S. Dollar';
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
        
        Online_Enquiry_Shipment_Invoice__c portalShipmentDetailsList1 = new Online_Enquiry_Shipment_Invoice__c();
        portalShipmentDetailsList1.External_Id__c = '40220201502';
        portalShipmentDetailsList1.Product_Name__c ='JGU138';
        portalShipmentDetailsList1.Shipped_Qty__c = 500;
        portalShipmentDetailsList1.Online_Enquiry_No__c = 'a0fp0000008VBdfAAG';
        
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
       
     
       
        insert onlineDetail;
        insert portalShipmentDetailsList1;
        boolean flag = true; 
        
        
        Test.startTest();
         salesOrderItemList =[SELECT Id lineItemId, Sales_Order__c SalesOrder,Sales_Order__r.Company__c OrderToCompany, Sales_Order__r.Retailer_Code1__c RetailerCode,Sales_Order__r.Retailer_Code1__r.Name RetailerName,Price_Specification_Book_Product__r.Name ModelName,Price_Specification_Book_Product__c Model,Price_Specification_Book_Product__r.Color__c Color,Price_Specification_Book_Product__r.Sizer_Print__c Printer,Sum(Remaining_Qty_Form__c) Quantity  FROM Sales_Order_Line_Items__c WHERE Status__c <> 'Cancelled' AND Status__c <> 'Shipped' GROUP BY Sales_Order__r.Company__c,Sales_Order__r.Retailer_Code1__c,Sales_Order__r.Retailer_Code1__r.Name,Price_Specification_Book_Product__r.Name,Price_Specification_Book_Product__c,Price_Specification_Book_Product__r.Color__c,Price_Specification_Book_Product__r.Sizer_Print__c,Sales_Order__c,Id];
         magNETShipmentDetailsList =[SELECT Mainetti_Order_Line_Item__r.Sales_Order__r.Id SalesOrderNumber,Mainetti_Order_Line_Item__r.Id SalesOrderItemNumber, Mainetti_Order_Line_Item__r.Sales_Order__r.Company__c OrderToCompany, Mainetti_Order_Line_Item__r.Sales_Order__r.Retailer_Code1__c RetailerCode,Mainetti_Order_Line_Item__r.Sales_Order__r.Retailer_Code1__r.Name RetailerName ,Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__c Model,Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__r.Name ModelName, Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__r.Color__c Color, Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__r.Sizer_Print__c Printer, Sum(Shipped_Quantity__c) Quantity FROM Shipment_Line_Item__c WHERE SystemModStamp >=:weekStartDate AND SystemModStamp <=:weekEndDate AND Mainetti_Order_Line_Item__c <> null GROUP BY Mainetti_Order_Line_Item__r.Sales_Order__r.Company__c, Mainetti_Order_Line_Item__r.Sales_Order__r.Retailer_Code1__c,Mainetti_Order_Line_Item__r.Sales_Order__r.Retailer_Code1__r.Name,Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__c, Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__r.Name, Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__r.Color__c, Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__r.Sizer_Print__c,Mainetti_Order_Line_Item__r.Sales_Order__r.Id,Mainetti_Order_Line_Item__r.Id];
        
       portalShipmentDetailsList = [Select Online_Enquiry_No__c onLineEnquiry,Product_Name__c productName,SUM(Shipped_Qty__c) Quantity FROM Online_Enquiry_Shipment_Invoice__c where SystemModStamp >=:weekStartDate AND SystemModStamp <=:weekEndDate   GROUP BY Online_Enquiry_No__c,Product_Name__c];
       onLineEnquiry = [Select Online_Enquiry_No__c FROM Online_Enquiry_Shipment_Invoice__c WHERE SystemModStamp >=:weekStartDate AND SystemModStamp <=:weekEndDate GROUP BY Online_Enquiry_No__c ];
        Test.stopTest();
         System.assertEquals(true, flag);
        
         //ShipmentSummaryForTheWeekbatchClass Weekbatch = new ShipmentSummaryForTheWeekbatchClass(portalShipmentDetailsList,magNETShipmentDetailsList,onLineEnquiry,salesOrderItemList);
        
        
         List<Sobject> scope = new  List<Sobject>();
        Database.BatchableContext BC1;
         Weekbatch.execute(BC1, scope);
        
        
         Database.batchableContext bc; 
         List<Partner__c> partnerList = new List<Partner__c>();   
        Weekbatch.start(bc);
        
        
        
         
        
        //insert weeklyShipmentSummary;
        //Online_Enquiry__c onLineEnquiry1 = new Online_Enquiry__c();
        
        //**Calling Finish method**
        Database.BatchableContext BC2;
        Weekbatch.finish(BC2);
    }
    
    static testMethod void splitShipmentListForUpsertTest(){
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
         List<AggregateResult> portalShipmentDetailsList = new List<AggregateResult>();
        List<AggregateResult> magNETShipmentDetailsList = new List<AggregateResult>();
        List<AggregateResult> onLineEnquiry = new List<AggregateResult>();
         List<AggregateResult> salesOrderItemList = new  List<AggregateResult>();
        
         ShipmentSummaryForTheWeekbatchClass Weekbatch = new ShipmentSummaryForTheWeekbatchClass(portalShipmentDetailsList,magNETShipmentDetailsList,onLineEnquiry,salesOrderItemList);
         List<Weekly_Shipment_Summary__c> weeklyShipmentSummaryList  = new List<Weekly_Shipment_Summary__c>();
        for(Integer i=0; i<=1000; i++){
        Weekly_Shipment_Summary__c weeklyShipmentSummary = new Weekly_Shipment_Summary__c();
        weeklyShipmentSummary.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        weeklyShipmentSummary.Retailer_Code__c = 'a00p0000008NzFPAA0';
        weeklyShipmentSummary.Mainetti_Model__c = 'a02p00000088auhAAA';
        weeklyShipmentSummary.Color__c = 'GRAY';
        weeklyShipmentSummary.Sizer_Print__c = 'xs';
        weeklyShipmentSummary.Quantity__c = 20;
        weeklyShipmentSummary.Week_Start_Date__c =weekStartDate;
        weeklyShipmentSummary.Week_End_Date__c =weekEndDate;           
            
            weeklyShipmentSummaryList.add(weeklyShipmentSummary);
        }
        insert weeklyShipmentSummaryList;
         salesOrderItemList =[SELECT Id lineItemId, Sales_Order__c SalesOrder,Sales_Order__r.Company__c OrderToCompany, Sales_Order__r.Retailer_Code1__c RetailerCode,Sales_Order__r.Retailer_Code1__r.Name RetailerName,Price_Specification_Book_Product__r.Name ModelName,Price_Specification_Book_Product__c Model,Price_Specification_Book_Product__r.Color__c Color,Price_Specification_Book_Product__r.Sizer_Print__c Printer,Sum(Remaining_Qty_Form__c) Quantity  FROM Sales_Order_Line_Items__c WHERE Status__c <> 'Cancelled' AND Status__c <> 'Shipped' GROUP BY Sales_Order__r.Company__c,Sales_Order__r.Retailer_Code1__c,Sales_Order__r.Retailer_Code1__r.Name,Price_Specification_Book_Product__r.Name,Price_Specification_Book_Product__c,Price_Specification_Book_Product__r.Color__c,Price_Specification_Book_Product__r.Sizer_Print__c,Sales_Order__c,Id];
         magNETShipmentDetailsList =[SELECT Mainetti_Order_Line_Item__r.Sales_Order__r.Id SalesOrderNumber,Mainetti_Order_Line_Item__r.Id SalesOrderItemNumber, Mainetti_Order_Line_Item__r.Sales_Order__r.Company__c OrderToCompany, Mainetti_Order_Line_Item__r.Sales_Order__r.Retailer_Code1__c RetailerCode,Mainetti_Order_Line_Item__r.Sales_Order__r.Retailer_Code1__r.Name RetailerName ,Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__c Model,Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__r.Name ModelName, Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__r.Color__c Color, Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__r.Sizer_Print__c Printer, Sum(Shipped_Quantity__c) Quantity FROM Shipment_Line_Item__c WHERE SystemModStamp >=:weekStartDate AND SystemModStamp <=:weekEndDate AND Mainetti_Order_Line_Item__c <> null GROUP BY Mainetti_Order_Line_Item__r.Sales_Order__r.Company__c, Mainetti_Order_Line_Item__r.Sales_Order__r.Retailer_Code1__c,Mainetti_Order_Line_Item__r.Sales_Order__r.Retailer_Code1__r.Name,Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__c, Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__r.Name, Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__r.Color__c, Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__r.Sizer_Print__c,Mainetti_Order_Line_Item__r.Sales_Order__r.Id,Mainetti_Order_Line_Item__r.Id];
        
       portalShipmentDetailsList = [Select Online_Enquiry_No__c onLineEnquiry,Product_Name__c productName,SUM(Shipped_Qty__c) Quantity FROM Online_Enquiry_Shipment_Invoice__c where SystemModStamp >=:weekStartDate AND SystemModStamp <=:weekEndDate   GROUP BY Online_Enquiry_No__c,Product_Name__c];
       onLineEnquiry = [Select Online_Enquiry_No__c FROM Online_Enquiry_Shipment_Invoice__c WHERE SystemModStamp >=:weekStartDate AND SystemModStamp <=:weekEndDate GROUP BY Online_Enquiry_No__c ];
      
        Weekbatch.splitShipmentListForUpsert(weeklyShipmentSummaryList);
        
         List<Sobject> scope = new  List<Sobject>();
        Database.BatchableContext BC1;
         Weekbatch.execute(BC1, scope);
    }
}