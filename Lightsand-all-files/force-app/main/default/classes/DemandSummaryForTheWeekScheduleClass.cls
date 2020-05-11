global class DemandSummaryForTheWeekScheduleClass implements Schedulable{ 
    
    @ReadOnly global void execute (SchedulableContext ctx){ 
		Date startdate = date.today();
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
		List<AggregateResult> onlineDetailsList = new List<AggregateResult>();
       
        /*String getQueryString='SELECT Id detailId, TransactionID__c OnlineEnquiryId,TransactionID__r.Order_Country__c OrderToCompany, TransactionID__r.Retailer_Code__c RetailerCode,TransactionID__r.Retailer_Code__r.Name RetailerName,Model__r.Name ModelName,Model__c Model,Color__c Color,Model__r.Sizer_Print__c Printer,Sum(Remaining_Qty__c) Quantity  FROM Online_Detail__c WHERE Status__c <> \'Cancelled\'  AND Status__c <> \'Shipped\' GROUP BY TransactionID__r.Order_Country__c,TransactionID__r.Retailer_Code__c,TransactionID__r.Retailer_Code__r.Name,Model__r.Name,Model__c,Color__c,Model__r.Sizer_Print__c,TransactionID__c,Id';
        
        for(AggregateResult[] onlineDetailsResult : Database.Query(getQueryString)) {
            onlineDetailsList.addAll(onlineDetailsResult);
        }*/
        
        List<AggregateResult> detailQuery = [SELECT Id detailId, TransactionID__c OnlineEnquiryId,TransactionID__r.Order_Country__c OrderToCompany, TransactionID__r.Retailer_Code__c RetailerCode,TransactionID__r.Retailer_Code__r.Name RetailerName,Model__r.Name ModelName,Model__c Model,Color__c Color,Model__r.Sizer_Print__c Printer,Sum(Remaining_Qty__c) Quantity  FROM Online_Detail__c WHERE Status__c <> 'Cancelled'  AND Status__c <> 'Shipped' GROUP BY TransactionID__r.Order_Country__c,TransactionID__r.Retailer_Code__c,TransactionID__r.Retailer_Code__r.Name,Model__r.Name,Model__c,Color__c,Model__r.Sizer_Print__c,TransactionID__c,Id];  
        for(AggregateResult onlineDetailsResult : detailQuery){  
            onlineDetailsList.add(onlineDetailsResult);
        }  
        
        List<AggregateResult> salesOrderLineItemList = new List<AggregateResult>();
        
       /*String getQueryStringSalesOrder = 'SELECT Id lineItemId, Sales_Order__c SalesOrder,Sales_Order__r.Company__c OrderToCompany, Sales_Order__r.Retailer_Code1__c RetailerCode,Sales_Order__r.Retailer_Code1__r.Name RetailerName,Price_Specification_Book_Product__r.Name ModelName,Price_Specification_Book_Product__c Model,Price_Specification_Book_Product__r.Color__c Color,Price_Specification_Book_Product__r.Sizer_Print__c Printer,Sum(Remaining_Qty_Form__c) Quantity  FROM Sales_Order_Line_Items__c WHERE Status__c <> \'Cancelled\' AND Status__c <> \'Shipped\' GROUP BY Sales_Order__r.Company__c,Sales_Order__r.Retailer_Code1__c,Sales_Order__r.Retailer_Code1__r.Name,Price_Specification_Book_Product__r.Name,Price_Specification_Book_Product__c,Price_Specification_Book_Product__r.Color__c,Price_Specification_Book_Product__r.Sizer_Print__c,Sales_Order__c,Id';
        for(AggregateResult[] salesOrderLineItemResult : Database.Query(getQueryStringSalesOrder)) {
            salesOrderLineItemList.addAll(salesOrderLineItemResult);
        }*/
        List<AggregateResult> query = [SELECT Id lineItemId, Sales_Order__c SalesOrder,Sales_Order__r.Company__c OrderToCompany, Sales_Order__r.Retailer_Code1__c RetailerCode,Sales_Order__r.Retailer_Code1__r.Name RetailerName,Price_Specification_Book_Product__r.Name ModelName,Price_Specification_Book_Product__c Model,Price_Specification_Book_Product__r.Color__c Color,Price_Specification_Book_Product__r.Sizer_Print__c Printer,Sum(Remaining_Qty_Form__c) Quantity  FROM Sales_Order_Line_Items__c WHERE Status__c <>'Cancelled' AND Status__c <>'Shipped' GROUP BY Sales_Order__r.Company__c,Sales_Order__r.Retailer_Code1__c,Sales_Order__r.Retailer_Code1__r.Name,Price_Specification_Book_Product__r.Name,Price_Specification_Book_Product__c,Price_Specification_Book_Product__r.Color__c,Price_Specification_Book_Product__r.Sizer_Print__c,Sales_Order__c,Id];  
        for(AggregateResult salesOrderLineItemResult : query){  
            salesOrderLineItemList.add(salesOrderLineItemResult);
        }  
                                       
        System.debug('salesOrderLineItemList SIZE:::'+salesOrderLineItemList.size()+'::::onlineDetailsList SIZE:::'+onlineDetailsList.size());
        DemandSummaryForTheWeekbatchClass demand = new DemandSummaryForTheWeekbatchClass(salesOrderLineItemList,onlineDetailsList); 
        Database.executeBatch(demand); 
    } 
}