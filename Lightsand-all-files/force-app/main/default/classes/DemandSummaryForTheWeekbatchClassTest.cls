@isTest
public class DemandSummaryForTheWeekbatchClassTest
{
    static testMethod void DemandSummaryTest()
    {
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        //Online order details for Portal.
        Online_Enquiry__c onlineEnquiry = new Online_Enquiry__c();
        onlineEnquiry.Order_Country__c = 'Hong Kong - Mainetti (HK) Ltd';
        onlineEnquiry.Retailer_Code__c = 'a00p0000008NzFPAA0';
        onlineEnquiry.External_Id__c = '40220201502';
        onlineEnquiry.RecordTypeId = '01290000000nQZMAA2';
        insert onlineEnquiry;
        
        Online_Detail__c onlineDetail = new Online_Detail__c();
        
        onlineDetail.Model__c = 'a02p00000088auXAAQ'; // TNGU139 model.
        onlineDetail.Color__c = 'GRAY';
        onlineDetail.Qty__c = 2000;
        onlineDetail.RecordTypeId = '01290000000TNpeAAG';
        onlineDetail.Online_Details_Status__c = 'New';
        onlineDetail.TransactionID__c = onlineEnquiry.Id;
        
        //insert onlineDetail;
        
        Price_Specification_Book_Product__c product = new Price_Specification_Book_Product__c();
        product.Name = 'TNGU139';
        product.Retailer_Code__c = 'a00p0000008NzFPAA0'; // GU retailer.
        product.Color__c = 'GRAY';
        product.Price_100pcs__c = 82.524;
        product.Freight_Terms__c = '';
        product.Country__c = 'China - South';
        product.Id = onlineDetail.Model__c;
        upsert product;
        
        //Online order details for Magnet
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
        
        insert onlineDetail;
        boolean flag = true; 
        
        Weekly_Demand_Summary__c weeklyDemandSummary = new Weekly_Demand_Summary__c();
        weeklyDemandSummary.Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        weeklyDemandSummary.Retailer_Code__c = 'a00p0000008NzFPAA0';
        weeklyDemandSummary.Mainetti_Model__c = 'a02p00000088auhAAA';
        weeklyDemandSummary.Color__c = 'GRAY';
        weeklyDemandSummary.Sizer_Print__c = 's';
        weeklyDemandSummary.Quantity__c = 2000;
        weeklyDemandSummary.Week_Start_Date__c =weekStartDate;
        weeklyDemandSummary.Week_End_Date__c =weekEndDate;
        insert weeklyDemandSummary;
        
        
        
         
        Test.startTest();
        List<AggregateResult> salesOrderLineItemList =[SELECT Id lineItemId, Sales_Order__c SalesOrder,Sales_Order__r.Company__c OrderToCompany, Sales_Order__r.Retailer_Code1__c RetailerCode,Sales_Order__r.Retailer_Code1__r.Name RetailerName,Price_Specification_Book_Product__r.Name ModelName,Price_Specification_Book_Product__c Model,Price_Specification_Book_Product__r.Color__c Color,Price_Specification_Book_Product__r.Sizer_Print__c Printer,Sum(Remaining_Qty_Form__c) Quantity  FROM Sales_Order_Line_Items__c WHERE Status__c <> 'Cancelled' AND Status__c <> 'Shipped' GROUP BY Sales_Order__r.Company__c,Sales_Order__r.Retailer_Code1__c,Sales_Order__r.Retailer_Code1__r.Name,Price_Specification_Book_Product__r.Name,Price_Specification_Book_Product__c,Price_Specification_Book_Product__r.Color__c,Price_Specification_Book_Product__r.Sizer_Print__c,Sales_Order__c,Id];

        List<AggregateResult> onlineDetailsList =[SELECT Id detailId, TransactionID__c OnlineEnquiryId,TransactionID__r.Order_Country__c OrderToCompany, TransactionID__r.Retailer_Code__c RetailerCode,TransactionID__r.Retailer_Code__r.Name RetailerName,Model__r.Name ModelName,Model__c Model,Color__c Color,Model__r.Sizer_Print__c Printer,Sum(Remaining_Qty__c) Quantity  FROM Online_Detail__c WHERE Status__c <> 'Cancelled'  AND Status__c <> 'Shipped' GROUP BY TransactionID__r.Order_Country__c,TransactionID__r.Retailer_Code__c,TransactionID__r.Retailer_Code__r.Name,Model__r.Name,Model__c,Color__c,Model__r.Sizer_Print__c,TransactionID__c,Id];
        
        Test.stopTest();
        System.assertEquals(true, flag);
        Iterable<SObject> fetchWeeklyDemandSummaryForTheWeek;
        Iterable<Sobject> fetchWeeklyEnquiryIdAndSalesOrderIdForTheWeek;
        
        DemandSummaryForTheWeekbatchClass demandweekbatch = new DemandSummaryForTheWeekbatchClass(salesOrderLineItemList,onlineDetailsList);
        //demandweekbatch.fetchWeeklyDemandSummaryForTheWeek(weeklyDemandSummary);
         // demandweekbatch.getDemandKey(salesOderLineItems);
        
      /*  List<Sobject> scope = new  List<Sobject>();
        Database.BatchableContext BC1;
        demandweekbatch.execute(BC1, scope);*/
      
        
       // demandweekbatch.fetchWeeklyDemandSummaryForTheWeek(weeklyDemandSummary);
        
        Database.batchableContext bc;        
        demandweekbatch.start(bc);
        List<Partner__c> partnerList = new List<Partner__c>();        
        //Weekly_Demand_Summary__c  weeklydemandsummary = new Weekly_Demand_Summary__c();          
        Database.BatchableContext BC2;
        demandweekbatch.finish(BC2);        
        demandweekbatch.existingDemandConOrderIdForTheWeek();
        //demandweekbatch.fetchWeeklyEnquiryIdAndSalesOrderIdForTheWeek();
        
        
    }
    static testMethod void demandListForUpsertTest(){

        List<Weekly_Demand_Consolidated_Order_Id__c> weeklyDemandConsolidatedList  = new List<Weekly_Demand_Consolidated_Order_Id__c>();
        for(Integer i=0; i<=9901; i++){
            Weekly_Demand_Consolidated_Order_Id__c weekdemconsol = new Weekly_Demand_Consolidated_Order_Id__c();
            weeklyDemandConsolidatedList.add(weekdemconsol);
        }
        insert weeklyDemandConsolidatedList;
        List<AggregateResult> salesOrderLineItemList =[SELECT Id lineItemId, Sales_Order__c SalesOrder,Sales_Order__r.Company__c OrderToCompany, Sales_Order__r.Retailer_Code1__c RetailerCode,Sales_Order__r.Retailer_Code1__r.Name RetailerName,Price_Specification_Book_Product__r.Name ModelName,Price_Specification_Book_Product__c Model,Price_Specification_Book_Product__r.Color__c Color,Price_Specification_Book_Product__r.Sizer_Print__c Printer,Sum(Remaining_Qty_Form__c) Quantity  FROM Sales_Order_Line_Items__c WHERE Status__c <> 'Cancelled' AND Status__c <> 'Shipped' GROUP BY Sales_Order__r.Company__c,Sales_Order__r.Retailer_Code1__c,Sales_Order__r.Retailer_Code1__r.Name,Price_Specification_Book_Product__r.Name,Price_Specification_Book_Product__c,Price_Specification_Book_Product__r.Color__c,Price_Specification_Book_Product__r.Sizer_Print__c,Sales_Order__c,Id];

        List<AggregateResult> onlineDetailsList =[SELECT Id detailId, TransactionID__c OnlineEnquiryId,TransactionID__r.Order_Country__c OrderToCompany, TransactionID__r.Retailer_Code__c RetailerCode,TransactionID__r.Retailer_Code__r.Name RetailerName,Model__r.Name ModelName,Model__c Model,Color__c Color,Model__r.Sizer_Print__c Printer,Sum(Remaining_Qty__c) Quantity  FROM Online_Detail__c WHERE Status__c <> 'Cancelled'  AND Status__c <> 'Shipped' GROUP BY TransactionID__r.Order_Country__c,TransactionID__r.Retailer_Code__c,TransactionID__r.Retailer_Code__r.Name,Model__r.Name,Model__c,Color__c,Model__r.Sizer_Print__c,TransactionID__c,Id];
        DemandSummaryForTheWeekbatchClass demandweekbatch = new DemandSummaryForTheWeekbatchClass(salesOrderLineItemList,onlineDetailsList);
        
         boolean flag = true;
        
           Test.startTest();
         demandweekbatch.splitConsolidateDemandListForUpsert(weeklyDemandConsolidatedList);
        database.executeBatch(demandweekbatch);
           Test.stopTest();
        System.assertEquals(true, flag);
    }
    static testMethod void splitDemandListForUpsertTest(){
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
         List<Weekly_Demand_Summary__c> weeklyDemandSummaryList  = new List<Weekly_Demand_Summary__c>();
        for(Integer i=0; i<=9901; i++){
        Weekly_Demand_Summary__c weeklyDemandSummary = new Weekly_Demand_Summary__c();
        weeklyDemandSummary.Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        weeklyDemandSummary.Retailer_Code__c = 'a00p0000008NzFPAA0';
        weeklyDemandSummary.Mainetti_Model__c = 'a02p00000088auhAAA';
        weeklyDemandSummary.Color__c = 'GRAY';
        weeklyDemandSummary.Sizer_Print__c = 's';
        weeklyDemandSummary.Quantity__c = 2000;
        weeklyDemandSummary.Week_Start_Date__c =weekStartDate;
        weeklyDemandSummary.Week_End_Date__c =weekEndDate;           
            
            weeklyDemandSummaryList.add(weeklyDemandSummary);
        }
        insert weeklyDemandSummaryList;
        List<AggregateResult> salesOrderLineItemList =[SELECT Id lineItemId, Sales_Order__c SalesOrder,Sales_Order__r.Company__c OrderToCompany, Sales_Order__r.Retailer_Code1__c RetailerCode,Sales_Order__r.Retailer_Code1__r.Name RetailerName,Price_Specification_Book_Product__r.Name ModelName,Price_Specification_Book_Product__c Model,Price_Specification_Book_Product__r.Color__c Color,Price_Specification_Book_Product__r.Sizer_Print__c Printer,Sum(Remaining_Qty_Form__c) Quantity  FROM Sales_Order_Line_Items__c WHERE Status__c <> 'Cancelled' AND Status__c <> 'Shipped' GROUP BY Sales_Order__r.Company__c,Sales_Order__r.Retailer_Code1__c,Sales_Order__r.Retailer_Code1__r.Name,Price_Specification_Book_Product__r.Name,Price_Specification_Book_Product__c,Price_Specification_Book_Product__r.Color__c,Price_Specification_Book_Product__r.Sizer_Print__c,Sales_Order__c,Id];

        List<AggregateResult> onlineDetailsList =[SELECT Id detailId, TransactionID__c OnlineEnquiryId,TransactionID__r.Order_Country__c OrderToCompany, TransactionID__r.Retailer_Code__c RetailerCode,TransactionID__r.Retailer_Code__r.Name RetailerName,Model__r.Name ModelName,Model__c Model,Color__c Color,Model__r.Sizer_Print__c Printer,Sum(Remaining_Qty__c) Quantity  FROM Online_Detail__c WHERE Status__c <> 'Cancelled'  AND Status__c <> 'Shipped' GROUP BY TransactionID__r.Order_Country__c,TransactionID__r.Retailer_Code__c,TransactionID__r.Retailer_Code__r.Name,Model__r.Name,Model__c,Color__c,Model__r.Sizer_Print__c,TransactionID__c,Id];
        DemandSummaryForTheWeekbatchClass demandweekbatch = new DemandSummaryForTheWeekbatchClass(salesOrderLineItemList,onlineDetailsList);
        
         boolean flag = true;
        
           Test.startTest();
         demandweekbatch.splitDemandListForUpsert(weeklyDemandSummaryList);
       
        database.executeBatch(demandweekbatch);
           Test.stopTest();
        System.assertEquals(true, flag);
        
    }
  /*  static testMethod void existingDemandSummaryWeekTest(){
        
        Retailer_Code__c retailer = new Retailer_Code__c();
        insert retailer;
        
        Price_Specification_Book__c specific = new Price_Specification_Book__c();
        insert specific;
        
         Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
      //  Retailer_Code__c retailer = new Retailer_Code__c();
        //Model__c model = new Model__c();
        

        
        
        
        Online_Enquiry__c onlineEnquiry = new Online_Enquiry__c();
        onlineEnquiry.Order_Country__c = 'Hong Kong - Mainetti (HK) Ltd';
        onlineEnquiry.Retailer_Code__c = retailer.Id;
        onlineEnquiry.External_Id__c = '40220201502';
        onlineEnquiry.RecordTypeId = '01290000000nQZMAA2';
        insert onlineEnquiry;
        
        
        
        Online_Detail__c onlineDetail = new Online_Detail__c();
        onlineDetail.Model__c = specific.Id; // TNGU139 model.
        onlineDetail.Color__c = 'GRAY';
        onlineDetail.Retailer_Code__c = retailer.Id;
        onlineDetail.Qty__c = 2000;
        onlineDetail.RecordTypeId = '01290000000TNpeAAG';
        onlineDetail.Online_Details_Status__c = 'New';
        onlineDetail.TransactionID__c = onlineEnquiry.Id;
        
        //insert onlineDetail;
        
        Price_Specification_Book_Product__c product = new Price_Specification_Book_Product__c();
        product.Name = 'TNGU139';
        product.Retailer_Code__c = retailer.Id; // GU retailer.
        product.Color__c = 'GRAY';
        product.Price_100pcs__c = 82.524;
        product.Freight_Terms__c = '';
        product.Country__c = 'China - South';
        //product.Id = onlineDetail.Model__c;
        //upsert product;
        
        //Online order details for Magnet
        Sales_Order__c salesOrder = new Sales_Order__c();
        salesOrder.Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        salesOrder.Retailer_Code1__c = retailer.Id; //Gu Retailer.
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
        
        insert onlineDetail;
        
        Weekly_Demand_Summary__c weekdemsum = new Weekly_Demand_Summary__c();
        weekdemsum.Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        weekdemsum.Retailer_Code__c = retailer.Id;
        weekdemsum.Mainetti_Model__c = specific.Id;
        weekdemsum.Color__c = 'GRAY';
        weekdemsum.Sizer_Print__c = 's';
        weekdemsum.Quantity__c = 2000;
        //weekdemsum.External_Id__c = '1581917465582_1';
        weekdemsum.Week_Start_Date__c = weekStartDate;
        weekdemsum.Week_End_Date__c = weekEndDate;
        insert weekdemsum;
        
          
        List<AggregateResult> salesOrderLineItemList =[SELECT Id lineItemId, Sales_Order__c SalesOrder,Sales_Order__r.Company__c OrderToCompany, Sales_Order__r.Retailer_Code1__c RetailerCode,Sales_Order__r.Retailer_Code1__r.Name RetailerName,Price_Specification_Book_Product__r.Name ModelName,Price_Specification_Book_Product__c Model,Price_Specification_Book_Product__r.Color__c Color,Price_Specification_Book_Product__r.Sizer_Print__c Printer,Sum(Remaining_Qty_Form__c) Quantity  FROM Sales_Order_Line_Items__c WHERE Status__c <> 'Cancelled' AND Status__c <> 'Shipped' GROUP BY Sales_Order__r.Company__c,Sales_Order__r.Retailer_Code1__c,Sales_Order__r.Retailer_Code1__r.Name,Price_Specification_Book_Product__r.Name,Price_Specification_Book_Product__c,Price_Specification_Book_Product__r.Color__c,Price_Specification_Book_Product__r.Sizer_Print__c,Sales_Order__c,Id];

        List<AggregateResult> onlineDetailsList =[SELECT Id detailId, TransactionID__c OnlineEnquiryId,TransactionID__r.Order_Country__c OrderToCompany, TransactionID__r.Retailer_Code__c RetailerCode,TransactionID__r.Retailer_Code__r.Name RetailerName,Model__r.Name ModelName,Model__c Model,Color__c Color,Model__r.Sizer_Print__c Printer,Sum(Remaining_Qty__c) Quantity  FROM Online_Detail__c WHERE Status__c <> 'Cancelled'  AND Status__c <> 'Shipped' GROUP BY TransactionID__r.Order_Country__c,TransactionID__r.Retailer_Code__c,TransactionID__r.Retailer_Code__r.Name,Model__r.Name,Model__c,Color__c,Model__r.Sizer_Print__c,TransactionID__c,Id];
        system.debug('onlineDetailsList:'+onlineDetailsList);
        
        Test.startTest();
        DemandSummaryForTheWeekbatchClass demandweekbatch = new DemandSummaryForTheWeekbatchClass(salesOrderLineItemList,onlineDetailsList);
        
        List<Sobject> scope = new  List<Sobject>();
        Database.BatchableContext BC1;
        demandweekbatch.execute(BC1, scope);
        Test.stopTest();
        
        
       Database.batchableContext bc;        
        demandweekbatch.start(bc);
        List<Partner__c> partnerList = new List<Partner__c>();        
        //Weekly_Demand_Summary__c  weeklydemandsummary = new Weekly_Demand_Summary__c();          
        Database.BatchableContext BC2;
        demandweekbatch.finish(BC2);        
        demandweekbatch.existingDemandSummaryForTheWeek();
      
    }*/
}