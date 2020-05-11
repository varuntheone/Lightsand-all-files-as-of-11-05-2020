global class ShipmentSummaryForTheWeekScheduleClass implements Schedulable{ 
    @ReadOnly 
    global void execute (SchedulableContext ctx){ 
		Date startdate = date.today();
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        /*
		List<AggregateResult> portalShipmentDetailsList = new List<AggregateResult>();        
        String getQueryString = 'Select Online_Enquiry_No__c onLineEnquiry,Product_Name__c productName,SUM(Shipped_Qty__c) Quantity FROM Online_Enquiry_Shipment_Invoice__c where SystemModStamp >=:weekStartDate AND SystemModStamp <=:weekEndDate   GROUP BY Online_Enquiry_No__c,Product_Name__c';
        for(AggregateResult[]  portalShipmentDetailsListResult: Database.Query(getQueryString)) {
            portalShipmentDetailsList.addAll(portalShipmentDetailsListResult);
        }*/
        
        //New getting the Qty of the online details item based on the shipment modified timestamp       
        List<AggregateResult> onlineDetailsShipmentList = new List<AggregateResult>();       
        String getQueryShipmentString='SELECT Id onlineDetailId, TransactionID__c OnlineEnquiryId,TransactionID__r.Order_Country__c OrderToCompany, TransactionID__r.Retailer_Code__c RetailerCode,TransactionID__r.Retailer_Code__r.Name RetailerName,Model__r.Name ModelName,Model__c Model,Color__c Color,Model__r.Sizer_Print__c Printer,Sum(Shipped_Qty__c) Quantity  FROM Online_Detail__c WHERE ShipmentModStamp__c >=:weekStartDate AND ShipmentModStamp__c <=:weekEndDate GROUP BY TransactionID__r.Order_Country__c,TransactionID__r.Retailer_Code__c,TransactionID__r.Retailer_Code__r.Name,Model__r.Name,Model__c,Color__c,Model__r.Sizer_Print__c,TransactionID__c,Id';
        for(AggregateResult[] onlineDetailsResult : Database.Query(getQueryShipmentString)) {
            onlineDetailsShipmentList.addAll(onlineDetailsResult);
        }
        
        
		List<AggregateResult> magNETShipmentDetailsList = new List<AggregateResult>();
        
        String getQueryMagNETString = 'SELECT Mainetti_Order_Line_Item__r.Sales_Order__r.Id SalesOrderNumber,Mainetti_Order_Line_Item__r.Id SalesOrderItemNumber, Mainetti_Order_Line_Item__r.Sales_Order__r.Company__c OrderToCompany, Mainetti_Order_Line_Item__r.Sales_Order__r.Retailer_Code1__c RetailerCode,Mainetti_Order_Line_Item__r.Sales_Order__r.Retailer_Code1__r.Name RetailerName ,Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__c Model,Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__r.Name ModelName, Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__r.Color__c Color, Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__r.Sizer_Print__c Printer, Sum(Shipped_Quantity__c) Quantity FROM Shipment_Line_Item__c WHERE SystemModStamp >=:weekStartDate AND SystemModStamp <=:weekEndDate AND Mainetti_Order_Line_Item__c <> null GROUP BY Mainetti_Order_Line_Item__r.Sales_Order__r.Company__c, Mainetti_Order_Line_Item__r.Sales_Order__r.Retailer_Code1__c,Mainetti_Order_Line_Item__r.Sales_Order__r.Retailer_Code1__r.Name,Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__c, Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__r.Name, Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__r.Color__c, Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__r.Sizer_Print__c,Mainetti_Order_Line_Item__r.Sales_Order__r.Id,Mainetti_Order_Line_Item__r.Id';
        for(AggregateResult[]  magNETShipmentDetailsListResult: Database.Query(getQueryMagNETString)) {
            magNETShipmentDetailsList.addAll(magNETShipmentDetailsListResult);
        }
        /*
        List<AggregateResult> onLineEnquiry = new List<AggregateResult>();
        String getQueryEnquiryString = 'Select Online_Enquiry_No__c FROM Online_Enquiry_Shipment_Invoice__c WHERE SystemModStamp >=:weekStartDate AND SystemModStamp <=:weekEndDate GROUP BY Online_Enquiry_No__c ';
        for(AggregateResult[]  onLineEnquiryResult: Database.Query(getQueryEnquiryString)) {
            onLineEnquiry.addAll(onLineEnquiryResult);
        }*/
        
        //This query is used to fetch the online details items where there has been an modification of the shipment quantity
        List<AggregateResult> onlineDetailItemList = new List<AggregateResult>();
        String getQueryDetailLineItemString = 'SELECT Id onlineDetailItemNo  FROM Online_Detail__c WHERE ShipmentModStamp__c >=:weekStartDate AND ShipmentModStamp__c <=:weekEndDate GROUP BY Id';
        for(AggregateResult[]  onlineDetailItemListResult: Database.Query(getQueryDetailLineItemString)) {
            onlineDetailItemList.addAll(onlineDetailItemListResult);
        }

        
        List<AggregateResult> salesOrderItemList = new List<AggregateResult>();
        String getQueryLineItemString = 'SELECT Mainetti_Order_Line_Item__c salesItemNo FROM Shipment_Line_Item__c WHERE SystemModStamp >=:weekStartDate AND SystemModStamp <=:weekEndDate AND Status__c <> \'Cancelled\'   GROUP BY Mainetti_Order_Line_Item__c';
        for(AggregateResult[]  salesOrderItemListResult: Database.Query(getQueryLineItemString)) {
            salesOrderItemList.addAll(salesOrderItemListResult);
        }
        
        //System.debug('portalShipmentDetailsList SIZE:::'+portalShipmentDetailsList.size()+'::::magNETShipmentDetailsList SIZE:::'+magNETShipmentDetailsList.size()+'onLineEnquiry ::: SIZE'+onLineEnquiry.size());
        System.debug('onlineDetailsShipmentList SIZE:::'+onlineDetailsShipmentList.size()+'::::magNETShipmentDetailsList SIZE:::'+magNETShipmentDetailsList.size()+'onlineDetailItemList ::: SIZE'+onlineDetailItemList.size()+'salesOrderItemList ::: SIZE'+salesOrderItemList.size());
        ShipmentSummaryForTheWeekbatchClass shipment = new ShipmentSummaryForTheWeekbatchClass(onlineDetailsShipmentList,magNETShipmentDetailsList,onlineDetailItemList,salesOrderItemList); 
        Database.executeBatch(shipment); 
    } 
}