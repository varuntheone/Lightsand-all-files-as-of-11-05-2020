//************************************************//
//This class is for the Inventory Allocation Module
//@vinod 23-12-2019
//************************************************//
public class InventoryAllocationMaster {
    //************************************//
    //This method to get all the rows 
    //**************************************************************************************************/
    //Fetching all the online enquiry Id and SalesOrder Ids for the consolidated Weekly Demand Summary from Portal and MagNET
    public Map<string,string> fetchWeeklyEnquiryIdAndSalesOrderIdForTheWeek(Date weekStartDate,Date weekEndDate){   
        System.debug('Start Method fetchWeeklyEnquiryIdAndSalesOrderIdForTheWeek');
        //********************************************************************************************************//
        List<Weekly_Demand_Consolidated_Order_Id__c> weeklyDemandConsIds = new List<Weekly_Demand_Consolidated_Order_Id__c>();
        String getQueryString='SELECT Online_Enquiry__c,Sales_Order__c FROM Weekly_Demand_Consolidated_Order_Id__c WHERE Week_Start_Date__c >=:weekStartDate AND Week_End_Date__c <=:weekEndDate';
        //system.debug('weeklyDemandConsIdsObject:'+Database.Query(getQueryString));
        for(List<Weekly_Demand_Consolidated_Order_Id__c> weeklyDemandConsIdsResult : Database.Query(getQueryString)) {
            weeklyDemandConsIds.addAll(weeklyDemandConsIdsResult);
        }
        //********************************************************************************************************//        
       Map<string,string> weeklyEnqSalesIdMap = new Map<string,string>();                
        System.debug('fetchWeeklyEnquiryIdAndSalesOrderIdForTheWeek::weeklyDemandConsIds list size'+weeklyDemandConsIds.size());
        for (Weekly_Demand_Consolidated_Order_Id__c enqSalesId : weeklyDemandConsIds){
            if(!String.isBlank(enqSalesId.Online_Enquiry__c)){
                weeklyEnqSalesIdMap.put(enqSalesId.Online_Enquiry__c,enqSalesId.Online_Enquiry__c);
            }
            if(!String.isBlank(enqSalesId.Sales_Order__c)){
                weeklyEnqSalesIdMap.put(enqSalesId.Sales_Order__c,enqSalesId.Sales_Order__c);
            }
            
        }
        System.debug('fetchWeeklyEnquiryIdAndSalesOrderIdForTheWeek::weeklyEnqSalesIdMap'+weeklyEnqSalesIdMap);
        System.debug('End Method fetchWeeklyEnquiryIdAndSalesOrderIdForTheWeek');
        return weeklyEnqSalesIdMap;
    }
    //Fetching all the demand details from Portal and MagNET
    public Map<string,Weekly_Demand_Summary__c> fetchWeeklyDemandSummaryForTheWeek(Date weekStartDate,Date weekEndDate){   
        System.debug('Start Method fetchWeeklyDemandSummaryForTheWeek');              
        List<Weekly_Demand_Summary__c> weeklyDemandSummary = new List<Weekly_Demand_Summary__c>();
        String getQueryString = 'Select Id,Order_to_Company__c , Retailer_Code__r.Name ,Mainetti_Model__r.Name,Color__c ,Sizer_Print__c,External_Id__c  FROM Weekly_Demand_Summary__c  WHERE Week_Start_Date__c >=:weekStartDate AND Week_End_Date__c <=:weekEndDate';
        for(List<Weekly_Demand_Summary__c> weeklyDemandSummaryResult : Database.Query(getQueryString)) {
            weeklyDemandSummary.addAll(weeklyDemandSummaryResult);
        } 
        //********************************************************************************************************//
        Map<string,Weekly_Demand_Summary__c> weeklyDemandMap = new Map<string,Weekly_Demand_Summary__c>();
        System.debug('fetchWeeklyDemandSummaryForTheWeek::weeklyDemandSummary list size'+weeklyDemandSummary.size());
        for (Weekly_Demand_Summary__c weeklyDemand : weeklyDemandSummary){
            weeklyDemand.Quantity__c = 0;
            String demandKey =  weeklyDemand.Order_to_Company__c+'#'+weeklyDemand.Retailer_Code__r.Name+'#'+weeklyDemand.Mainetti_Model__r.Name+'#'+weeklyDemand.Color__c+'#'+weeklyDemand.Sizer_Print__c;
            //System.debug('fetchWeeklyDemandSummaryForTheWeek::demandKey'+demandKey);   
            weeklyDemandMap.put(demandKey,weeklyDemand);
        }
        System.debug('fetchWeeklyDemandSummaryForTheWeek::weeklyDemandMap'+weeklyDemandMap);
        System.debug('End Method fetchWeeklyDemandSummaryForTheWeek');
        return weeklyDemandMap;
    }
    //Fetching all the online order details from Portal
    public AggregateResult[] fetchOrderDetailsFromPortal(Date weekStartDate,Date weekEndDate){
        System.debug('Start Method fetchOrderDetailsFromPortal');
        List<AggregateResult> onlineDetailsList = new List<AggregateResult>();
        //List<Online_Detail__c> onlineDetailsList = new List<Online_Detail__c>();
        
        //String getQueryString='SELECT TransactionID__c OnlineEnquiryId,TransactionID__r.Order_Country__c OrderToCompany, TransactionID__r.Retailer_Code__c RetailerCode,TransactionID__r.Retailer_Code__r.Name RetailerName,Model__r.Name ModelName,Model__c Model,Color__c Color,Model__r.Sizer_Print__c Printer,Sum(Qty__c) Quantity  FROM Online_Detail__c WHERE Online_Details_Status__c <> \'Cancel\' GROUP BY TransactionID__r.Order_Country__c,TransactionID__r.Retailer_Code__c,TransactionID__r.Retailer_Code__r.Name,Model__r.Name,Model__c,Color__c,Model__r.Sizer_Print__c,TransactionID__c';
        String getQueryString='SELECT Id detailId, TransactionID__c OnlineEnquiryId,TransactionID__r.Order_Country__c OrderToCompany, TransactionID__r.Retailer_Code__c RetailerCode,TransactionID__r.Retailer_Code__r.Name RetailerName,Model__r.Name ModelName,Model__c Model,Color__c Color,Model__r.Sizer_Print__c Printer,Sum(Remaining_Qty__c) Quantity  FROM Online_Detail__c WHERE Status__c <> \'Cancelled\'  AND Status__c <> \'Shipped\' GROUP BY TransactionID__r.Order_Country__c,TransactionID__r.Retailer_Code__c,TransactionID__r.Retailer_Code__r.Name,Model__r.Name,Model__c,Color__c,Model__r.Sizer_Print__c,TransactionID__c,Id';
        
        for(AggregateResult[] onlineDetailsResult : Database.Query(getQueryString)) {
            onlineDetailsList.addAll(onlineDetailsResult);
        }
        System.debug('fetchOrderDetailsFromPortal:::onlineDetailsList size:::'+onlineDetailsList.size());
        System.debug('End Method fetchOrderDetailsFromPortal');
        return onlineDetailsList;
    } 
    //**************************************************************/
    //Fetching all the online order details from MagNET
    public AggregateResult[] fetchOrderDetailsFromMagNET(Date weekStartDate,Date weekEndDate){
        System.debug('Start Method fetchOrderDetailsFromMagNET');   
        List<AggregateResult> salesOrderLineItemList = new List<AggregateResult>();
        //String getQueryString = 'SELECT Id lineItemId,Sales_Order__c SalesOrder,Sales_Order__r.Company__c OrderToCompany, Sales_Order__r.Retailer_Code1__c RetailerCode,Sales_Order__r.Retailer_Code1__r.Name RetailerName,Price_Specification_Book_Product__r.Name ModelName,Price_Specification_Book_Product__c Model,Price_Specification_Book_Product__r.Color__c Color,Price_Specification_Book_Product__r.Sizer_Print__c Printer,Sum(Ordered_Quantity__c) Quantity  FROM Sales_Order_Line_Items__c WHERE Status__c != \'Cancelled\' GROUP BY Sales_Order__r.Company__c,Sales_Order__r.Retailer_Code1__c,Sales_Order__r.Retailer_Code1__r.Name,Price_Specification_Book_Product__r.Name,Price_Specification_Book_Product__c,Price_Specification_Book_Product__r.Color__c,Price_Specification_Book_Product__r.Sizer_Print__c,Sales_Order__c,Id';
        String getQueryString = 'SELECT Id lineItemId, Sales_Order__c SalesOrder,Sales_Order__r.Company__c OrderToCompany, Sales_Order__r.Retailer_Code1__c RetailerCode,Sales_Order__r.Retailer_Code1__r.Name RetailerName,Price_Specification_Book_Product__r.Name ModelName,Price_Specification_Book_Product__c Model,Price_Specification_Book_Product__r.Color__c Color,Price_Specification_Book_Product__r.Sizer_Print__c Printer,Sum(Remaining_Qty_Form__c) Quantity  FROM Sales_Order_Line_Items__c WHERE Status__c <> \'Cancelled\' AND Status__c <> \'Shipped\' GROUP BY Sales_Order__r.Company__c,Sales_Order__r.Retailer_Code1__c,Sales_Order__r.Retailer_Code1__r.Name,Price_Specification_Book_Product__r.Name,Price_Specification_Book_Product__c,Price_Specification_Book_Product__r.Color__c,Price_Specification_Book_Product__r.Sizer_Print__c,Sales_Order__c,Id';
        for(AggregateResult[] salesOrderLineItemResult : Database.Query(getQueryString)) {
            salesOrderLineItemList.addAll(salesOrderLineItemResult);
        } 
        //********************************************************************************************************//
        System.debug('fetchOrderDetailsFromMagNET:::salesOrderLineItemList size'+salesOrderLineItemList.size()); 
        System.debug('End Method fetchOrderDetailsFromMagNET'); 
        return salesOrderLineItemList; 
    }
    //**************************************************************/
    //Fetching all the online enquiry Id and SalesOrder Ids for the consolidated Weekly Demand Summary from Portal and MagNET
    public Map<string,string> fetchWeeklyDataUploadIdForTheWeek(Date weekStartDate,Date weekEndDate){   
        System.debug('Start Method fetchWeeklyDataUploadIdForTheWeek');
        List<Weekly_Supply_Consolidated_Id__c> weeklyDataUploadIds = new List<Weekly_Supply_Consolidated_Id__c>();
        String getQueryString = 'SELECT Data_Upload_Transaction__c	 FROM Weekly_Supply_Consolidated_Id__c WHERE Week_Start_Date__c >=:weekStartDate AND Week_End_Date__c <=:weekEndDate';
        for(List<Weekly_Supply_Consolidated_Id__c> weeklyDataUploadIdsResult : Database.Query(getQueryString)) {
            weeklyDataUploadIds.addAll(weeklyDataUploadIdsResult);
        } 
        //********************************************************************************************************//
        Map<string,string> weeklyDataUploadIdMap = new Map<string,string>();  
        System.debug('fetchWeeklyDataUploadIdForTheWeek::weeklyDataUploadIds list size'+weeklyDataUploadIds.size());
        for (Weekly_Supply_Consolidated_Id__c dataUpId : weeklyDataUploadIds){
            if(!String.isBlank(dataUpId.Data_Upload_Transaction__c)){
                weeklyDataUploadIdMap.put(dataUpId.Data_Upload_Transaction__c,dataUpId.Data_Upload_Transaction__c);
            }           
        }
        System.debug('fetchWeeklyDataUploadIdForTheWeek::weeklyDataUploadIdMap'+weeklyDataUploadIdMap);
        System.debug('End Method fetchWeeklyDataUploadIdForTheWeek');
        return weeklyDataUploadIdMap;
    }
    //Fetching all the supply details for Virgin
    public Map<string,Weekly_Supply_Summary__c> fetchWeeklySupplyVirginSummaryForTheWeek(Date weekStartDate,Date weekEndDate){
        System.debug('Start Method fetchWeeklySupplyVirginSummaryForTheWeek');       
        List<Weekly_Supply_Summary__c> weeklySupplySummary = new List<Weekly_Supply_Summary__c>();
        String getQueryString = 'Select Id,Mainetti_Company__c , Retailer_Code__r.Name ,Mainetti_Model__r.Name,Color__c ,Sizer_Print__c,Warehouse__c FROM Weekly_Supply_Summary__c  WHERE Source__c=\'Virgin\' AND  Week_Start_Date__c >=:weekStartDate AND Week_End_Date__c <=:weekEndDate';
        for(List<Weekly_Supply_Summary__c> weeklySupplySummaryResult : Database.Query(getQueryString)) {
            weeklySupplySummary.addAll(weeklySupplySummaryResult);
        } 
        //********************************************************************************************************//
        Map<string,Weekly_Supply_Summary__c> weeklySupplyMap = new Map<string,Weekly_Supply_Summary__c>();
        System.debug('fetchWeeklySupplyVirginSummaryForTheWeek::weeklySupplySummary'+weeklySupplySummary.size());  
        for (Weekly_Supply_Summary__c weeklySupply : weeklySupplySummary){
            weeklySupply.Quantity__c = 0;
            String supplyKey =  weeklySupply.Mainetti_Company__c+'#'+weeklySupply.Retailer_Code__r.Name+'#'+weeklySupply.Mainetti_Model__r.Name+'#'+weeklySupply.Color__c+'#'+weeklySupply.Sizer_Print__c;
            //String supplyKey =  weeklySupply.Mainetti_Company__c+'#'+weeklySupply.Retailer_Code__r.Name+'#'+weeklySupply.Mainetti_Model__r.Name+'#'+weeklySupply.Color__c+'#'+weeklySupply.Sizer_Print__c+'#'+weeklySupply.Warehouse__c;
            weeklySupplyMap.put(supplyKey,weeklySupply);
        }
        System.debug('fetchWeeklySupplyVirginSummaryForTheWeek::weeklySupplyMap'+weeklySupplyMap);
        System.debug('End Method fetchWeeklySupplyVirginSummaryForTheWeek');  
        return weeklySupplyMap;
    }
    //Fetching the Stock On Hand where Source = 'Virgin'
    public AggregateResult[] fetchStockOnHandForSourceVirgin(Date weekStartDate,Date weekEndDate){
        System.debug('Start Method fetchStockOnHandForSourceVirgin');  
        List<AggregateResult> stockVirginList = new List<AggregateResult>();
        //String getQueryString = 'SELECT Mainetti_Company__r.Name OrderToCompany,Retailer_Code__c RetailerCode,Retailer_Code__r.Name RetailerName,Inventory_Model__c Model,Inventory_Model__r.Name ModelName,Color__c Color,Sizer_Print__c Printer, SUM(Stock_In_Qty__c) Quantity,Warehouse__c Warehouse FROM  Data_Upload_Transaction__c WHERE Record_Type__c=\'Inventory\' AND  Source__c=\'Virgin\' AND Stock_In_Date__c >=:weekStartDate and Stock_In_Date__c <=:weekEndDate  GROUP BY Mainetti_Company__r.Name,Retailer_Code__c,Retailer_Code__r.Name,Inventory_Model__c,Inventory_Model__r.Name,Color__c ,Sizer_Print__c,Warehouse__c';
        String getQueryString = 'SELECT Mainetti_Company__r.Name OrderToCompany,Retailer_Code__c RetailerCode,Retailer_Code__r.Name RetailerName,Inventory_Model__c Model,Inventory_Model__r.Name ModelName,Color__c Color,Sizer_Print__c Printer, SUM(Stock_In_Qty__c) Quantity,Warehouse__c Warehouse FROM  Data_Upload_Transaction__c WHERE Record_Type__c=\'Inventory\' AND  Source__c=\'Virgin\'  GROUP BY Mainetti_Company__r.Name,Retailer_Code__c,Retailer_Code__r.Name,Inventory_Model__c,Inventory_Model__r.Name,Color__c ,Sizer_Print__c,Warehouse__c';
        for(AggregateResult[]  stockVirginListResult : Database.Query(getQueryString)) {
            stockVirginList.addAll(stockVirginListResult);
        }
        System.debug('fetchWeeklySupplyVirginSummaryForTheWeek:::stockVirginList size'+stockVirginList.size());  
        System.debug('End Method fetchWeeklySupplyVirginSummaryForTheWeek');  
        return stockVirginList;
    } 
    //**************************************************************/
    //Fetching all the supply details for Reuse
    public Map<string,Weekly_Supply_Summary__c> fetchWeeklySupplyReuseSummaryForTheWeek(Date weekStartDate,Date weekEndDate){        
        System.debug('Start Method fetchWeeklySupplyReuseSummaryForTheWeek');  
        List<Weekly_Supply_Summary__c> weeklySupplySummary = new List<Weekly_Supply_Summary__c>();
        String getQueryString = 'Select Id, Mainetti_Company__c , Retailer_Code__r.Name ,Mainetti_Model__r.Name,Color__c ,Sizer_Print__c,Warehouse__c FROM Weekly_Supply_Summary__c  WHERE Source__c=\'Reuse\' AND Week_Start_Date__c >=:weekStartDate AND Week_End_Date__c <=:weekEndDate';
        for(List<Weekly_Supply_Summary__c> weeklySupplySummaryResult : Database.Query(getQueryString)) {
            weeklySupplySummary.addAll(weeklySupplySummaryResult);
        } 
        //********************************************************************************************************//
        Map<string,Weekly_Supply_Summary__c> weeklySupplyMap = new Map<string,Weekly_Supply_Summary__c>();
        
        for (Weekly_Supply_Summary__c weeklySupply : weeklySupplySummary){
            weeklySupply.Quantity__c = 0;
            String supplyKey =  weeklySupply.Mainetti_Company__c+'#'+weeklySupply.Retailer_Code__r.Name+'#'+weeklySupply.Mainetti_Model__r.Name+'#'+weeklySupply.Color__c+'#'+weeklySupply.Sizer_Print__c+'#'+weeklySupply.Warehouse__c;
            weeklySupplyMap.put(supplyKey,weeklySupply);
        }
        System.debug('End Method fetchWeeklySupplyReuseSummaryForTheWeek'); 
        System.debug('fetchWeeklySupplyReuseSummaryForTheWeek:::weeklySupplyMap'+weeklySupplyMap);
        return weeklySupplyMap;
    }
    //Fetching the Stock On Hand where Source = 'Reuse'
    public AggregateResult[] fetchStockOnHandForSourceReuse(Date weekStartDate,Date weekEndDate){
        //System.debug('Start Method fetchStockOnHandForSourceReuse'); 
        List<AggregateResult> stockReuseList = new List<AggregateResult>();
        //String getQueryString = 'SELECT Mainetti_Company__r.Name OrderToCompany,Retailer_Code__c RetailerCode,Retailer_Code__r.Name RetailerName,Inventory_Model__c Model,Inventory_Model__r.Name ModelName,Color__c Color,Sizer_Print__c Printer, SUM(Stock_In_Qty__c) Quantity,Warehouse__c Warehouse FROM  Data_Upload_Transaction__c WHERE Record_Type__c=\'Inventory\' AND  Source__c=\'Reuse\' AND Stock_In_Date__c >=:weekStartDate and Stock_In_Date__c <=:weekEndDate  GROUP BY Mainetti_Company__r.Name,Retailer_Code__c,Retailer_Code__r.Name,Inventory_Model__c,Inventory_Model__r.Name,Color__c,Sizer_Print__c,Warehouse__c';
        String getQueryString = 'SELECT Mainetti_Company__r.Name OrderToCompany,Retailer_Code__c RetailerCode,Retailer_Code__r.Name RetailerName,Inventory_Model__c Model,Inventory_Model__r.Name ModelName,Color__c Color,Sizer_Print__c Printer, SUM(Stock_In_Qty__c) Quantity,Warehouse__c Warehouse FROM  Data_Upload_Transaction__c WHERE Record_Type__c=\'Inventory\' AND  Source__c=\'Reuse\'  GROUP BY Mainetti_Company__r.Name,Retailer_Code__c,Retailer_Code__r.Name,Inventory_Model__c,Inventory_Model__r.Name,Color__c,Sizer_Print__c,Warehouse__c';
        for( AggregateResult[]  stockReuseListResult : Database.Query(getQueryString)) {
            stockReuseList.addAll(stockReuseListResult);
        }
        System.debug(' fetchStockOnHandForSourceReuse:::stockReuseList size'+stockReuseList.size());
        //System.debug('fetchStockOnHandForSourceReuse:::stockReuseList'+stockReuseList); 
        System.debug('End Method fetchStockOnHandForSourceReuse'); 
        return stockReuseList;
    } 
    //**************************************************************/
    //Fetching all the shipment details for Portal and MagNET
     //***********Fetching all the equiry no for which shipment has taken place in the last week for PORTAL***********/
    public MAP<ID,ID> fetchEnquiryNumberForOnlineEnquiryShimpment(Date weekStartDate,Date weekEndDate){
        System.debug('Start Method fetchEnquiryNumberForOnlineEnquiryShimpment'); 
        List<AggregateResult> onLineEnquiry = new List<AggregateResult>();
        String getQueryString = 'Select Online_Enquiry_No__c FROM Online_Enquiry_Shipment_Invoice__c WHERE SystemModStamp >=:weekStartDate AND SystemModStamp <=:weekEndDate GROUP BY Online_Enquiry_No__c ';
        for(AggregateResult[]  onLineEnquiryResult: Database.Query(getQueryString)) {
            onLineEnquiry.addAll(onLineEnquiryResult);
        } 
        //********************************************************************************************************//
        System.debug('onLineEnquiry:'+onLineEnquiry);
        MAP<ID,ID> onlineEqyNo = new MAP<ID,ID>();
        System.debug('fetchEnquiryNumberForOnlineEnquiryShimpment:::onLineEnquiry size::'+onLineEnquiry.size()); 
        for (AggregateResult onLineEnquiryNumber : onLineEnquiry){
            onlineEqyNo.put(String.valueOf(onLineEnquiryNumber.get('Online_Enquiry_No__c')) ,String.valueOf(onLineEnquiryNumber.get('Online_Enquiry_No__c')));
        }  
        //System.debug('fetchEnquiryNumberForOnlineEnquiryShimpment:::onlineEqyNo'+onlineEqyNo); 
        System.debug('End Method fetchEnquiryNumberForOnlineEnquiryShimpment'); 
        return onlineEqyNo;
    }
    //Fetching all the shipment quantity based on the enquiry number and the model details as the key
    public Map<string,Weekly_Demand_Summary__c> fetchWeeklyDemandSummaryForTheWeekShipmentPortal(Date weekStartDate,Date weekEndDate){
        System.debug('Start Method fetchWeeklyDemandSummaryForTheWeekShipmentPortal'); 
        MAP<ID,ID> onLineEnquiry = fetchEnquiryNumberForOnlineEnquiryShimpment(weekStartDate,weekEndDate);
        //System.debug('fetchWeeklyDemandSummaryForTheWeekShipmentPortal:::onLineEnquiry keyset'+onLineEnquiry.keyset()); 
        SET<ID> onlineKeys = onLineEnquiry.keyset(); 
        System.debug('##### onLineEnquiry.keyset()'+onLineEnquiry.keyset());
        MAP<String,String> externalId = new MAP<String,String>();
        //String getQueryString = 'SELECT External_Id__c,Online_Enquiry__c FROM  Weekly_Demand_Consolidated_Order_Id__c	WHERE Online_Enquiry__c IN:onlineKeys';
        String getQueryString = 'SELECT External_Id__c,Online_Enquiry__c FROM  Weekly_Demand_Consolidated_Order_Id__c	WHERE Online_Enquiry__c IN:onlineKeys';
       
        List<Weekly_Demand_Consolidated_Order_Id__c> consolidateId = new List<Weekly_Demand_Consolidated_Order_Id__c>();
        for(List<Weekly_Demand_Consolidated_Order_Id__c> weeklyShipmentSummaryConResult: Database.Query(getQueryString)) {
            consolidateId.addAll(weeklyShipmentSummaryConResult);            
        }
        
        System.debug('##### consolidateId SIZE'+consolidateId.size());
         system.debug('consolidateId:'+consolidateId);
        for (Weekly_Demand_Consolidated_Order_Id__c consId : consolidateId){
            externalId.put(consId.External_Id__c,consId.Online_Enquiry__c);
        }
		         
        SET<String> externalIdKeys = externalId.keyset(); 
        System.debug('##### externalId.keyset()'+externalId.keyset());
        System.debug('externalIdKeys:'+externalIdKeys);
        List<Weekly_Demand_Summary__c> weeklyShipmentSummary = new List<Weekly_Demand_Summary__c>();
        String getQueryDemandString = 'Select Id,External_Id__c,Mainetti_Model__r.Name, Order_to_Company__c, Retailer_Code__r.Name ,Mainetti_Model__c,Color__c ,Sizer_Print__c  FROM  Weekly_Demand_Summary__c	WHERE External_Id__c IN:externalIdKeys';
        for(List<Weekly_Demand_Summary__c> weeklyShipmentSummaryResult: Database.Query(getQueryDemandString)) {
            weeklyShipmentSummary.addAll(weeklyShipmentSummaryResult);
        } 
        //********************************************************************************************************//
        Map<string,Weekly_Demand_Summary__c> weeklyDemandMap = new Map<string,Weekly_Demand_Summary__c>();        
        
        for (Weekly_Demand_Summary__c weeklyShipment : weeklyShipmentSummary){
            Weekly_Demand_Summary__c weeklyDemandSummary = new Weekly_Demand_Summary__c();
            weeklyDemandSummary.Id = weeklyShipment.Id;
            weeklyDemandSummary.Order_to_Company__c = weeklyShipment.Order_to_Company__c;
            weeklyDemandSummary.Mainetti_Model__c = weeklyShipment.Mainetti_Model__c;
            weeklyDemandSummary.Retailer_Code__c = weeklyShipment.Retailer_Code__c;
            weeklyDemandSummary.Color__c = weeklyShipment.Color__c;
            weeklyDemandSummary.Sizer_Print__c = weeklyShipment.Sizer_Print__c;
            String onLineEnquiryNo = externalId.get(weeklyShipment.External_Id__c);
            System.debug('##### onLineEnquiryNo'+onLineEnquiryNo);
            System.debug('##### weeklyShipment.Mainetti_Model__r.Name:'+weeklyShipment.Mainetti_Model__r.Name);
            //String demandKey =  weeklyShipment.Online_Enquiry__c+'#'+weeklyShipment.Weekly_Demand_Summary__r.Mainetti_Model__r.Name;
            String demandKey =  onLineEnquiryNo+'#'+weeklyShipment.Mainetti_Model__r.Name;
             System.debug('##### demandKey:'+demandKey);
            weeklyDemandMap.put(demandKey,weeklyDemandSummary);
        }        
        System.debug('fetchWeeklyDemandSummaryForTheWeekShipmentPortal:::weeklyDemandMap'+weeklyDemandMap); 
        System.debug('End Method fetchWeeklyDemandSummaryForTheWeekShipmentPortal'); 
        return weeklyDemandMap;
    }
    
   
    
    //Fetching all the shipment details for Portal
    public Map<string,Weekly_Shipment_Summary__c> fetchWeeklyShipmentSummaryForTheWeekPortal(Date weekStartDate,Date weekEndDate){
        System.debug('Start Method fetchWeeklyShipmentSummaryForTheWeekPortal'); 
        Map<string,Weekly_Demand_Summary__c> weeklyDemandSummaryMap =  fetchWeeklyDemandSummaryForTheWeekShipmentPortal(weekStartDate,weekEndDate);
        MAP<ID,ID>  weeklyDemandSummaryIdMap = new MAP<ID,ID>();
        for(string shipmentKey : weeklyDemandSummaryMap.keySet()){
            Weekly_Demand_Summary__c  weeklyDemandSummary = weeklyDemandSummaryMap.get(shipmentKey); 
            weeklyDemandSummaryIdMap.put(weeklyDemandSummary.Id, weeklyDemandSummary.Id);
        }
        SET<ID> weeklyDemandSummaryIds = weeklyDemandSummaryIdMap.keyset(); 
        System.debug('  fetchWeeklyShipmentSummaryForTheWeekPortal:::weeklyDemandSummaryIds::'+weeklyDemandSummaryIds);
        Map<string,Weekly_Shipment_Summary__c> weeklyShipMap = new Map<string,Weekly_Shipment_Summary__c>();
        List<Weekly_Shipment_Summary__c> weeklyShipmentSummary = [Select Weekly_Demand_Summary__c,Quantity__c FROM Weekly_Shipment_Summary__c  WHERE  Weekly_Demand_Summary__c IN:weeklyDemandSummaryIds];
        for (Weekly_Shipment_Summary__c weeklyShipment : weeklyShipmentSummary){
            String shipmentKey =  weeklyShipment.Weekly_Demand_Summary__c;
            System.debug('  fetchWeeklyShipmentSummaryForTheWeekPortal:::shipmentKey::'+shipmentKey);
            weeklyShipMap.put(shipmentKey,weeklyShipment);
        }
        System.debug('  fetchWeeklyShipmentSummaryForTheWeekPortal:::weeklyShipMap::'+weeklyShipMap);
        System.debug('End Method fetchWeeklyShipmentSummaryForTheWeekPortal');
        return weeklyShipMap;
    }
    
    //Fetching all the online order details from Portal
    public AggregateResult[] fetchShipmentDetailsForPortal(Date weekStartDate,Date weekEndDate){
        //System.debug('Start Method fetchShipmentDetailsForPortal'); 
        List<AggregateResult> portalShipmentDetailsList = new List<AggregateResult>();
        //String getQueryString = 'Select Online_Enquiry_No__c onLineEnquiry,Product_Name__c productName,SUM(Shipped_Qty__c) Quantity FROM Online_Enquiry_Shipment_Invoice__c GROUP BY Online_Enquiry_No__c,Product_Name__c';
        String getQueryString = 'Select Online_Enquiry_No__c onLineEnquiry,Product_Name__c productName,SUM(Shipped_Qty__c) Quantity FROM Online_Enquiry_Shipment_Invoice__c where SystemModStamp >=:weekStartDate AND SystemModStamp <=:weekEndDate   GROUP BY Online_Enquiry_No__c,Product_Name__c';
        for(AggregateResult[]  portalShipmentDetailsListResult: Database.Query(getQueryString)) {
            portalShipmentDetailsList.addAll(portalShipmentDetailsListResult);
        } 
        //********************************************************************************************************//
        System.debug('fetchShipmentDetailsForPortal::::portalShipmentDetailsList size::'+portalShipmentDetailsList.size()); 
        //System.debug('fetchShipmentDetailsForPortal::::portalShipmentDetailsList:::'+portalShipmentDetailsList);
        System.debug('End Method fetchShipmentDetailsForPortal'); 
        return portalShipmentDetailsList;        
    } 
    //**************************************************************/
    //MAGNET Shipment
    //Fetching all shipment details from FROM Shipment_Line_Item for the week for MagNET
    
    public AggregateResult[] fetchShipmentDetailsForMagNETForTheWeek(Date weekStartDate,Date weekEndDate){
        System.debug('Start Method fetchShipmentDetailsForMagNETForTheWeek'+':::::weekStartDate::'+weekStartDate+'::weekEndDate::'+weekEndDate); 
        List<AggregateResult> magNETShipmentDetailsList = new List<AggregateResult>();
        //String getQueryString = 'SELECT Mainetti_Order_Line_Item__r.Sales_Order__r.Id SalesOrderNumber,Mainetti_Order_Line_Item__r.Id SalesOrderItemNumber, Mainetti_Order_Line_Item__r.Sales_Order__r.Company__c OrderToCompany, Mainetti_Order_Line_Item__r.Sales_Order__r.Retailer_Code1__c RetailerCode,Mainetti_Order_Line_Item__r.Sales_Order__r.Retailer_Code1__r.Name RetailerName ,Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__c Model,Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__r.Name ModelName, Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__r.Color__c Color, Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__r.Sizer_Print__c Printer, Sum(Shipped_Quantity__c) Quantity FROM Shipment_Line_Item__c WHERE Mainetti_Order_Line_Item__c <> null GROUP BY Mainetti_Order_Line_Item__r.Sales_Order__r.Company__c, Mainetti_Order_Line_Item__r.Sales_Order__r.Retailer_Code1__c,Mainetti_Order_Line_Item__r.Sales_Order__r.Retailer_Code1__r.Name,Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__c, Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__r.Name, Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__r.Color__c, Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__r.Sizer_Print__c,Mainetti_Order_Line_Item__r.Sales_Order__r.Id,Mainetti_Order_Line_Item__r.Id';
        String getQueryString = 'SELECT Mainetti_Order_Line_Item__r.Sales_Order__r.Id SalesOrderNumber,Mainetti_Order_Line_Item__r.Id SalesOrderItemNumber, Mainetti_Order_Line_Item__r.Sales_Order__r.Company__c OrderToCompany, Mainetti_Order_Line_Item__r.Sales_Order__r.Retailer_Code1__c RetailerCode,Mainetti_Order_Line_Item__r.Sales_Order__r.Retailer_Code1__r.Name RetailerName ,Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__c Model,Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__r.Name ModelName, Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__r.Color__c Color, Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__r.Sizer_Print__c Printer, Sum(Shipped_Quantity__c) Quantity FROM Shipment_Line_Item__c WHERE SystemModStamp >=:weekStartDate AND SystemModStamp <=:weekEndDate AND Mainetti_Order_Line_Item__c <> null GROUP BY Mainetti_Order_Line_Item__r.Sales_Order__r.Company__c, Mainetti_Order_Line_Item__r.Sales_Order__r.Retailer_Code1__c,Mainetti_Order_Line_Item__r.Sales_Order__r.Retailer_Code1__r.Name,Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__c, Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__r.Name, Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__r.Color__c, Mainetti_Order_Line_Item__r.Price_Specification_Book_Product__r.Sizer_Print__c,Mainetti_Order_Line_Item__r.Sales_Order__r.Id,Mainetti_Order_Line_Item__r.Id';
        for(AggregateResult[]  magNETShipmentDetailsListResult: Database.Query(getQueryString)) {
            magNETShipmentDetailsList.addAll(magNETShipmentDetailsListResult);
        } 
        //********************************************************************************************************//
        System.debug('fetchShipmentDetailsForMagNETForTheWeek:::magNETShipmentDetailsList size::'+magNETShipmentDetailsList.size()); 																																																																																																																																									
        System.debug('fetchShipmentDetailsForMagNETForTheWeek:::magNETShipmentDetailsList ::'+magNETShipmentDetailsList);   
        System.debug('End Method fetchShipmentDetailsForMagNETForTheWeek'); 
        return magNETShipmentDetailsList;  
    }
    
    //***********Fetching all the Sales Order Ids of the records for which shippment has been done for the week for MagNET***********/
    public MAP<ID,ID> fetchSalesOrderItemNumbersForShipmentDoneInTheWeek(Date weekStartDate,Date weekEndDate){
        System.debug('Start Method fetchSalesOrderNumbersForShipmentDoneInTheWeek'); 
        List<AggregateResult> salesOrderItemList = new List<AggregateResult>();
        String getQueryString = 'SELECT Mainetti_Order_Line_Item__c salesItemNo FROM Shipment_Line_Item__c   GROUP BY Mainetti_Order_Line_Item__c';
        for(AggregateResult[]  salesOrderItemListResult: Database.Query(getQueryString)) {
            salesOrderItemList.addAll(salesOrderItemListResult);
        } 
        //********************************************************************************************************//
        MAP<ID,ID> salesOrderNumber = new MAP<ID,ID>();
        System.debug('fetchSalesOrderNumbersForShipmentDoneInTheWeek:::salesOrderList size:::'+salesOrderItemList.size()); 
        for (AggregateResult salesOrderItemNo : salesOrderItemList){
            salesOrderNumber.put(String.valueOf(salesOrderItemNo.get('salesItemNo')) ,String.valueOf(salesOrderItemNo.get('salesItemNo')));
        }                       
        List<Weekly_Demand_Consolidated_Order_Id__c> salesOrdNumDemandList = new List<Weekly_Demand_Consolidated_Order_Id__c>();
        SET<ID> salesOrderItemIds = salesOrderNumber.keySet();
        String getQueryStringDmd = 'Select Weekly_Demand_Summary__c,Sales_Order_Item__c  FROM  Weekly_Demand_Consolidated_Order_Id__c WHERE Sales_Order_Item__c  IN:salesOrderItemIds';
        for( List<Weekly_Demand_Consolidated_Order_Id__c> salesOrdNumDemandListResult: Database.Query(getQueryStringDmd)) {
            salesOrdNumDemandList.addAll(salesOrdNumDemandListResult);
        } 
        //********************************************************************************************************//        
        MAP<ID,ID> salesOrdNumWkDemandSummaryId = new MAP<ID,ID>();
        for (Weekly_Demand_Consolidated_Order_Id__c salesOrderNoDemandId : salesOrdNumDemandList){
            salesOrdNumWkDemandSummaryId.put( salesOrderNoDemandId.Sales_Order_Item__c ,salesOrderNoDemandId.Weekly_Demand_Summary__c);
        }  
        //System.debug('fetchSalesOrderNumbersForShipmentDoneInTheWeek:::salesOrdNumWkDemandSummaryId:::'+salesOrdNumWkDemandSummaryId); 
        System.debug('End Method fetchSalesOrderNumbersForShipmentDoneInTheWeek'); 
        return salesOrdNumWkDemandSummaryId;
    }
    
    //Fetching all the Existing Shipment details for MagNET
    public Map<ID,Weekly_Shipment_Summary__c> fetchWeeklyShipmentSummaryForTheWeekMagNET(Date weekStartDate,Date weekEndDate){
        System.debug('Start Method fetchWeeklyShipmentSummaryForTheWeekMagNET'); 
        MAP<ID,ID> salesOrderItemNumDemandIds = fetchSalesOrderItemNumbersForShipmentDoneInTheWeek( weekStartDate, weekEndDate);
        System.debug('fetchWeeklyShipmentSummaryForTheWeekMagNET:::salesOrderItemNumDemandIds keysets:::'+salesOrderItemNumDemandIds.keyset()); 
        SET<ID> weeklyDemandIds = new SET<ID>();
        for(ID demandIds : salesOrderItemNumDemandIds.keySet()){             
            weeklyDemandIds.add(demandIds); 
        }         
        Map<ID,Weekly_Shipment_Summary__c> weeklyShipMap = new Map<ID,Weekly_Shipment_Summary__c>();
        List<Weekly_Shipment_Summary__c> weeklyShipmentSummary = [Select Id, Mainetti_Company__c , Retailer_Code__r.Name ,Mainetti_Model__c,Mainetti_Model__r.Name,Color__c ,Sizer_Print__c ,Quantity__c,Weekly_Demand_Summary__c FROM Weekly_Shipment_Summary__c  WHERE  Weekly_Demand_Summary__c IN:weeklyDemandIds];
        for (Weekly_Shipment_Summary__c weeklyShipment : weeklyShipmentSummary){            
            weeklyShipMap.put(weeklyShipment.Weekly_Demand_Summary__c,weeklyShipment);            
        }
        System.debug('fetchWeeklyShipmentSummaryForTheWeekMagNET:::weeklyShipMap:::'+weeklyShipMap);
        System.debug('End Method fetchWeeklyShipmentSummaryForTheWeekMagNET');
        return weeklyShipMap;
    }
    //This method returns the start of the week number for a given date ie for a month
    public Integer getWeekNumber(Date startdate){
        
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
        Integer currentyear = startdate.year();
        
        Date yearstartdate = date.newinstance(currentyear, 01, 01);
        Date year2ndweek = yearstartdate.adddays(7).tostartofweek();
        
        if(startdate<year2ndweek)
            return 1;
        integer numberDaysDue = year2ndweek.daysBetween(todaydateinstance);
        
        Integer numberOfWeek;
        if(math.mod(numberDaysDue,7)==0)
            numberOfWeek = math.MOD(Integer.valueof(math.FLOOR( ( numberDaysDue )/7)),52)+1;
        else
            numberOfWeek = math.MOD(Integer.valueof(math.FLOOR( ( numberDaysDue )/7)),52)+2;
        if(numberOfWeek==53)
            numberOfWeek=1;
        //system.debug('numberOfWeek'+numberOfWeek);
        return numberOfWeek;
        
    }
    Map<string,Weekly_Demand_Summary__c> getWeeklyDemandSummary(String orderToCompany,String retailerCode,String modelName,Date weekStartDate,Date weekEndDate,Integer pageNumber ,Integer recordToDisplay,Integer totalRecordCount, boolean isCurrentWeek){   
        
        if(isCurrentWeek){
            Date startdate = date.today();
            Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
            weekStartDate = todaydateinstance.toStartOfWeek();
            weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        }
        string searchQuery;
        if(isCurrentWeek){
            searchQuery = 'SELECT Id,Order_to_Company__c OrderToCompany,Retailer_Code__c RetailerCode, Retailer_Code__r.Name RetailerName,Mainetti_Model__c ModelCode,Mainetti_Model__r.Name ModelName,Color__c Color,Sizer_Print__c Printer,Week_Start_Date__c weekStartDate,Week_End_Date__c weekEndDate,SUM(Quantity__c) Quantity  FROM Weekly_Demand_Summary__c';
        }else{
            searchQuery = 'SELECT Order_to_Company__c OrderToCompany,Retailer_Code__c RetailerCode, Retailer_Code__r.Name RetailerName,Mainetti_Model__c ModelCode,Mainetti_Model__r.Name ModelName,Color__c Color,Sizer_Print__c Printer,SUM(Quantity__c) Quantity  FROM Weekly_Demand_Summary__c';
        }    
        if(String.isNotBlank(string.valueOf(weekStartDate)) || String.isNotBlank(string.valueOf(weekEndDate))||String.isNotBlank(orderToCompany)||String.isNotBlank(retailerCode)||String.isNotBlank(modelName)){
            searchQuery += ' WHERE ';
        }         
        boolean dateFieldFrmPresent = false;
        boolean dateFieldToPresent = false;
        boolean orderToCompanyPresent = false;
        boolean retailerCodePresent = false;
        boolean modelNamePresent = false;
        if(String.isNotBlank(string.valueOf(weekStartDate)) || String.isNotBlank(string.valueOf(weekEndDate))){
            if(String.isNotBlank(string.valueOf(weekStartDate)) && String.isNotBlank(string.valueOf(weekEndDate))){
                searchQuery += ' Week_Start_Date__c >=:weekStartDate AND Week_End_Date__c <=:weekEndDate';       
                dateFieldFrmPresent = true; 
                dateFieldToPresent = true;
            }
            if(String.isNotBlank(string.valueOf(weekStartDate)) && String.isBlank(string.valueOf(weekEndDate))){
                searchQuery += ' Week_Start_Date__c >=:weekStartDate';
                dateFieldFrmPresent = true;
            }
            if(String.isBlank(string.valueOf(weekStartDate)) && String.isNotBlank(string.valueOf(weekEndDate))){
                searchQuery += ' Week_End_Date__c >=:weekEndDate';
                dateFieldToPresent = true;
            }            
        }
        if(String.isNotBlank(orderToCompany)){
            if(dateFieldFrmPresent==true || dateFieldToPresent==true){
                searchQuery += ' AND Order_to_Company__c=:orderToCompany';
            }else{
                searchQuery += ' Order_to_Company__c=:orderToCompany';
            }
            orderToCompanyPresent = true;
        }
        if(String.isNotBlank(retailerCode)){
            
            if(dateFieldFrmPresent==true || dateFieldToPresent==true || orderToCompanyPresent==true){
                searchQuery += ' AND Retailer_Code__r.Name=:retailerCode';
            }else{
                searchQuery += ' Retailer_Code__r.Name=:retailerCode';
            }
            retailerCodePresent = true;
        }
        if(String.isNotBlank(modelName)){
            if(dateFieldFrmPresent==true || dateFieldToPresent==true || orderToCompanyPresent==true || retailerCodePresent==true){
                searchQuery += ' AND Mainetti_Model__r.Name=:modelName';
            }else{
                searchQuery += ' Mainetti_Model__r.Name=:modelName';
            }
        }
        if(isCurrentWeek){
            searchQuery += ' GROUP BY Id, Order_to_Company__c , Retailer_Code__c , Retailer_Code__r.Name ,Mainetti_Model__c ,Mainetti_Model__r.Name ,Color__c ,Sizer_Print__c,Week_Start_Date__c,Week_End_Date__c ';
        }else{
            searchQuery += ' GROUP BY  Order_to_Company__c ,Retailer_Code__c , Retailer_Code__r.Name ,Mainetti_Model__c ,Mainetti_Model__r.Name ,Color__c ,Sizer_Print__c ';
        }    
        
        String searchQueryCount = searchQuery;
        Integer offSet = ((pageNumber - 1) * recordToDisplay);
        //system.debug('offSet:'+offSet);
        searchQuery += ' Order by Order_to_Company__c  LIMIT :recordToDisplay OFFSET :offSet';
        
        Map<string,Weekly_Demand_Summary__c> weeklyDemandMap = new Map<string,Weekly_Demand_Summary__c>();
        //Getting the total count of records only the first time 
        if(pageNumber ==1){
            AggregateResult[]  weeklyDemandSummaryCount = Database.query(searchQueryCount);
            totalRecordCount = weeklyDemandSummaryCount.size();
            Weekly_Demand_Summary__c totalRec = new Weekly_Demand_Summary__c();	
            totalRec.Week_Number__c	 = String.valueOf(totalRecordCount);            
            weeklyDemandMap.put('TotalCount',totalRec);            
        }
        //System.debug('searchQuery::::'+searchQuery+':::');
        //System.debug('totalRecordCount::::'+totalRecordCount+':::');        
        AggregateResult[] weeklyDemandSummaryAggreList = Database.query(searchQuery);
        for (AggregateResult weeklyDemandSummaryAgg : weeklyDemandSummaryAggreList){            
            
            Weekly_Demand_Summary__c weeklyDemandSummary = new Weekly_Demand_Summary__c();
            if(isCurrentWeek){
                weeklyDemandSummary.Id = String.valueOf(weeklyDemandSummaryAgg.get('Id'));                
            }
            String demandKey = new ProcessInventoryAllocation().getDemandKey(weeklyDemandSummaryAgg);
            //System.debug('demandKey::::'+demandKey);
            weeklyDemandSummary.Order_to_Company__c = String.valueOf(weeklyDemandSummaryAgg.get('OrderToCompany'));
            weeklyDemandSummary.Retailer_Name__c = String.valueOf(weeklyDemandSummaryAgg.get('RetailerName'));
            weeklyDemandSummary.Mainetti_Model_Name__c = String.valueOf(weeklyDemandSummaryAgg.get('ModelName'));
            weeklyDemandSummary.Color__c = String.valueOf(weeklyDemandSummaryAgg.get('Color'));
            weeklyDemandSummary.Sizer_Print__c = String.valueOf(weeklyDemandSummaryAgg.get('Printer'));   
            if(isCurrentWeek){
                weeklyDemandSummary.Week_Start_Date__c = Date.valueOf(weeklyDemandSummaryAgg.get('weekStartDate'));
                weeklyDemandSummary.Week_End_Date__c = Date.valueOf(weeklyDemandSummaryAgg.get('weekEndDate'));
            }
            weeklyDemandSummary.Quantity__c = Double.valueOf(weeklyDemandSummaryAgg.get('Quantity'));
            weeklyDemandMap.put(demandKey,weeklyDemandSummary);
        }  
        //system.debug('weeklyDemandMapSize:'+weeklyDemandMap.size());
        return weeklyDemandMap;
    } 
    //Checking whether it is the first time or first week of the batch run, for the full scan of the database to get the
    //Fetching all the demand details
    public Map<string,Weekly_Demand_Summary__c> fetchWeeklyDemandSummary(String orderToCompany,String retailerCode,String modelName,Date weekStartDate,Date weekEndDate,Integer pageNumber ,Integer recordToDisplay,boolean isCurrentWeek){   
        //System.debug('Start Method fetchWeeklyDemandSummary');
        Integer totalRecordCount = 0;
        
        Map<string,Weekly_Demand_Summary__c> weeklyDemandSummaryMap = getWeeklyDemandSummary(orderToCompany,retailerCode, modelName, weekStartDate, weekEndDate, pageNumber ,recordToDisplay,totalRecordCount, isCurrentWeek);
        //System.debug('AFTER calling the SEARCH::::'+weeklyDemandSummaryMap.size());        
        return weeklyDemandSummaryMap;
    }

    Map<string,Weekly_Supply_Summary__c> getWeeklySupplySummary(String orderToCompany,String retailerCode,String modelName,Date weekStartDate,Date weekEndDate,boolean isCurrentWeek){  
        
        if(isCurrentWeek){
            Date startdate = date.today();
            Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
            weekStartDate = todaydateinstance.toStartOfWeek();
            weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        }
        string searchQuery;
        if(isCurrentWeek){
            searchQuery = 'SELECT Id, Mainetti_Company__c OrderToCompany, Retailer_Code__c RetailerCode, Retailer_Code__r.Name RetailerName,Mainetti_Model__c ModelCode,Mainetti_Model__r.Name ModelName,Color__c Color,Sizer_Print__c Printer,Week_Start_Date__c weekStartDate,Week_End_Date__c weekEndDate,SUM(Quantity__c) Quantity FROM Weekly_Supply_Summary__c';
        }else{
            searchQuery = 'SELECT Mainetti_Company__c OrderToCompany, Retailer_Code__c RetailerCode, Retailer_Code__r.Name RetailerName,Mainetti_Model__c ModelCode,Mainetti_Model__r.Name ModelName,Color__c Color,Sizer_Print__c Printer,Week_Start_Date__c weekStartDate,Week_End_Date__c weekEndDate,SUM(Quantity__c) Quantity FROM Weekly_Supply_Summary__c';
        }
        if(String.isNotBlank(string.valueOf(weekStartDate)) || String.isNotBlank(string.valueOf(weekEndDate))||String.isNotBlank(orderToCompany)||String.isNotBlank(retailerCode)||String.isNotBlank(modelName)){
            searchQuery += ' WHERE ';
        }         
        boolean dateFieldFrmPresent = false;
        boolean dateFieldToPresent = false;
        boolean orderToCompanyPresent = false;
        boolean retailerCodePresent = false;
        boolean modelNamePresent = false;
        if(String.isNotBlank(string.valueOf(weekStartDate)) || String.isNotBlank(string.valueOf(weekEndDate))){
            if(String.isNotBlank(string.valueOf(weekStartDate)) && String.isNotBlank(string.valueOf(weekEndDate))){
                searchQuery += ' Week_Start_Date__c >=:weekStartDate AND Week_End_Date__c <=:weekEndDate';       
                dateFieldFrmPresent = true; 
                dateFieldToPresent = true;
            }
            if(String.isNotBlank(string.valueOf(weekStartDate)) && String.isBlank(string.valueOf(weekEndDate))){
                searchQuery += ' Week_Start_Date__c >=:weekStartDate';
                dateFieldFrmPresent = true;
            }
            if(String.isBlank(string.valueOf(weekStartDate)) && String.isNotBlank(string.valueOf(weekEndDate))){
                searchQuery += ' Week_End_Date__c >=:weekEndDate';
                dateFieldToPresent = true;
            }            
        }
        if(String.isNotBlank(orderToCompany)){
            if(dateFieldFrmPresent==true || dateFieldToPresent==true){
                searchQuery += ' AND Mainetti_Company__c=:orderToCompany';
            }else{
                searchQuery += ' Mainetti_Company__c=:orderToCompany';
            }
            orderToCompanyPresent = true;
        }
        if(String.isNotBlank(retailerCode)){
            
            if(dateFieldFrmPresent==true || dateFieldToPresent==true || orderToCompanyPresent==true){
                searchQuery += ' AND Retailer_Code__r.Name=:retailerCode';
            }else{
                searchQuery += ' Retailer_Code__r.Name=:retailerCode';
            }
            retailerCodePresent = true;
        }
        if(String.isNotBlank(modelName)){
            if(dateFieldFrmPresent==true || dateFieldToPresent==true || orderToCompanyPresent==true || retailerCodePresent==true){
                searchQuery += ' AND Mainetti_Model__r.Name=:modelName';
            }else{
                searchQuery += ' Mainetti_Model__r.Name=:modelName';
            }
        }
        if(isCurrentWeek){
            searchQuery += ' GROUP BY  Id,Mainetti_Company__c , Retailer_Code__c , Retailer_Code__r.Name ,Mainetti_Model__c ,Mainetti_Model__r.Name ,Color__c ,Sizer_Print__c, Week_Start_Date__c,Week_End_Date__c';
        }else{
            searchQuery += ' GROUP BY Mainetti_Company__c , Retailer_Code__c , Retailer_Code__r.Name ,Mainetti_Model__c ,Mainetti_Model__r.Name ,Color__c ,Sizer_Print__c, Week_Start_Date__c,Week_End_Date__c';
        }
        //searchQuery += ' order by CreatedDate';
        //System.debug('getWeeklySupplySummary searchQuery:::::'+searchQuery);
        
        Map<string,Weekly_Supply_Summary__c> weeklySupplyMap = new Map<string,Weekly_Supply_Summary__c>(); 
        AggregateResult[] weeklySupplySummaryAggreList = Database.query(searchQuery);
        //System.debug('weeklySupplySummaryAggreList:::::'+weeklySupplySummaryAggreList);
        for (AggregateResult weeklySupplySummaryAgg : weeklySupplySummaryAggreList){            
            
            Weekly_Supply_Summary__c weeklySupplySummary = new Weekly_Supply_Summary__c();
            if(isCurrentWeek){
                weeklySupplySummary.Id = String.valueOf(weeklySupplySummaryAgg.get('Id'));
            }
            String supplyKey = new ProcessInventoryAllocation().getSupplyKey(weeklySupplySummaryAgg);
            weeklySupplySummary.Mainetti_Company__c	 = String.valueOf(weeklySupplySummaryAgg.get('OrderToCompany'));
            weeklySupplySummary.Retailer_Name__c = String.valueOf(weeklySupplySummaryAgg.get('RetailerName'));
            weeklySupplySummary.Mainetti_Model_Name__c = String.valueOf(weeklySupplySummaryAgg.get('ModelName'));
            weeklySupplySummary.Color__c = String.valueOf(weeklySupplySummaryAgg.get('Color'));
            weeklySupplySummary.Sizer_Print__c = String.valueOf(weeklySupplySummaryAgg.get('Printer'));
            //weeklySupplySummary.Warehouse__c = String.valueOf(weeklySupplySummaryAgg.get('wareHouse'));
            weeklySupplySummary.Week_Start_Date__c = Date.valueOf(weeklySupplySummaryAgg.get('weekStartDate'));
            weeklySupplySummary.Week_End_Date__c = Date.valueOf(weeklySupplySummaryAgg.get('weekEndDate'));
            weeklySupplySummary.Quantity__c = Double.valueOf(weeklySupplySummaryAgg.get('Quantity'));
            //system.debug('weeklySupplySummary:::supplyKey:::'+supplyKey);
            //weeklySupplyMap.put(supplyKey,weeklySupplySummary);
            
            if(!weeklySupplyMap.containsKey(supplyKey)){
                weeklySupplyMap.put(supplyKey,weeklySupplySummary);
            }else{
                Weekly_Supply_Summary__c weeklySupplySummaryTemp = new Weekly_Supply_Summary__c();
                weeklySupplySummaryTemp = weeklySupplyMap.get(supplyKey);
                weeklySupplySummary.Quantity__c = weeklySupplySummary.Quantity__c + weeklySupplySummaryTemp.Quantity__c;
                weeklySupplyMap.put(supplyKey,weeklySupplySummary);
            }
        }          
        return weeklySupplyMap;
    }
    
    
    
    //Fetching all the supply details
    public Map<string,Weekly_Supply_Summary__c> fetchWeeklySupplySummary(String orderToCompany,String retailerCode,String modelName,Date weekStartDate,Date weekEndDate,boolean isCurrentWeek){
        Map<string,Weekly_Supply_Summary__c> weeklySupplySummaryMap = getWeeklySupplySummary(orderToCompany,retailerCode,modelName,weekStartDate,weekEndDate, isCurrentWeek);   
        return weeklySupplySummaryMap;
    }
    
    Map<string,Weekly_Shipment_Summary__c> getWeeklyShipmentSummary(String orderToCompany,String retailerCode,String modelName,Date weekStartDate,Date weekEndDate,boolean isCurrentWeek){  
        //system.debug('isCurrentWeek:'+isCurrentWeek);
       
        
        if(isCurrentWeek){
             Date startdate = date.today();
        	Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
            weekStartDate = todaydateinstance.toStartOfWeek();
            weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        }
        string searchQuery;
        if(isCurrentWeek){
            searchQuery = 'SELECT Id, Mainetti_Company__c OrderToCompany, Retailer_Code__c RetailerCode, Retailer_Code__r.Name RetailerName,Mainetti_Model__c ModelCode,Mainetti_Model__r.Name ModelName,Color__c Color,Sizer_Print__c Printer,Week_Start_Date__c weekStartDate,Week_End_Date__c weekEndDate,SUM(Quantity__c) Quantity FROM Weekly_Shipment_Summary__c';
        }else{
            searchQuery = 'SELECT Mainetti_Company__c OrderToCompany, Retailer_Code__c RetailerCode, Retailer_Code__r.Name RetailerName,Mainetti_Model__c ModelCode,Mainetti_Model__r.Name ModelName,Color__c Color,Sizer_Print__c Printer,Week_Start_Date__c weekStartDate,Week_End_Date__c weekEndDate,SUM(Quantity__c) Quantity FROM Weekly_Shipment_Summary__c';
        }
        if(String.isNotBlank(string.valueOf(weekStartDate)) || String.isNotBlank(string.valueOf(weekEndDate))||String.isNotBlank(orderToCompany)||String.isNotBlank(retailerCode)||String.isNotBlank(modelName)){
            searchQuery += ' WHERE ';
        }         
        boolean dateFieldFrmPresent = false;
        boolean dateFieldToPresent = false;
        boolean orderToCompanyPresent = false;
        boolean retailerCodePresent = false;
        boolean modelNamePresent = false;
        if(String.isNotBlank(string.valueOf(weekStartDate)) || String.isNotBlank(string.valueOf(weekEndDate))){
            if(String.isNotBlank(string.valueOf(weekStartDate)) && String.isNotBlank(string.valueOf(weekEndDate))){
                searchQuery += ' Week_Start_Date__c >=:weekStartDate AND Week_End_Date__c <=:weekEndDate';       
                dateFieldFrmPresent = true; 
                dateFieldToPresent = true;
            }
            if(String.isNotBlank(string.valueOf(weekStartDate)) && String.isBlank(string.valueOf(weekEndDate))){
                searchQuery += ' Week_Start_Date__c >=:weekStartDate';
                dateFieldFrmPresent = true;
            }
            if(String.isBlank(string.valueOf(weekStartDate)) && String.isNotBlank(string.valueOf(weekEndDate))){
                searchQuery += ' Week_End_Date__c >=:weekEndDate';
                dateFieldToPresent = true;
            }            
        }
        if(String.isNotBlank(orderToCompany)){
            if(dateFieldFrmPresent==true || dateFieldToPresent==true){
                searchQuery += ' AND Mainetti_Company__c=:orderToCompany';
            }else{
                searchQuery += ' Mainetti_Company__c=:orderToCompany';
            }
            orderToCompanyPresent = true;
        }
        if(String.isNotBlank(retailerCode)){
            
            if(dateFieldFrmPresent==true || dateFieldToPresent==true || orderToCompanyPresent==true){
                searchQuery += ' AND Retailer_Code__r.Name=:retailerCode';
            }else{
                searchQuery += ' Retailer_Code__r.Name=:retailerCode';
            }
            retailerCodePresent = true;
        }
        if(String.isNotBlank(modelName)){
            if(dateFieldFrmPresent==true || dateFieldToPresent==true || orderToCompanyPresent==true || retailerCodePresent==true){
                searchQuery += ' AND Mainetti_Model__r.Name=:modelName';
            }else{
                searchQuery += ' Mainetti_Model__r.Name=:modelName';
            }
        }
        if(isCurrentWeek){
            searchQuery += ' GROUP BY  Id,Mainetti_Company__c , Retailer_Code__c , Retailer_Code__r.Name ,Mainetti_Model__c ,Mainetti_Model__r.Name ,Color__c ,Sizer_Print__c, Week_Start_Date__c,Week_End_Date__c';
        }else{
            searchQuery += ' GROUP BY Mainetti_Company__c , Retailer_Code__c , Retailer_Code__r.Name ,Mainetti_Model__c ,Mainetti_Model__r.Name ,Color__c ,Sizer_Print__c, Week_Start_Date__c,Week_End_Date__c';
        }        
        //System.debug('searchQuery:::::'+searchQuery);        
        Map<string,Weekly_Shipment_Summary__c> weeklyShipmentMap = new Map<string,Weekly_Shipment_Summary__c>(); 
        AggregateResult[] weeklyShipmentSummaryAggreList = Database.query(searchQuery);
        for (AggregateResult weeklyShipmentSummaryAgg : weeklyShipmentSummaryAggreList){            
            
            Weekly_Shipment_Summary__c weeklyShipmentSummary = new Weekly_Shipment_Summary__c();
            if(isCurrentWeek){
                weeklyShipmentSummary.Id = String.valueOf(weeklyShipmentSummaryAgg.get('Id'));
            }
            String shipmentKey = new ProcessInventoryAllocation().getShipmentKey(weeklyShipmentSummaryAgg);
            
            weeklyShipmentSummary.Mainetti_Company__c	 = String.valueOf(weeklyShipmentSummaryAgg.get('OrderToCompany'));
            weeklyShipmentSummary.Retailer_Name__c = String.valueOf(weeklyShipmentSummaryAgg.get('RetailerName'));
            weeklyShipmentSummary.Mainetti_Model_Name__c = String.valueOf(weeklyShipmentSummaryAgg.get('ModelName'));
            weeklyShipmentSummary.Color__c = String.valueOf(weeklyShipmentSummaryAgg.get('Color'));
            weeklyShipmentSummary.Sizer_Print__c = String.valueOf(weeklyShipmentSummaryAgg.get('Printer'));            
            weeklyShipmentSummary.Week_Start_Date__c = Date.valueOf(weeklyShipmentSummaryAgg.get('weekStartDate'));
            weeklyShipmentSummary.Week_End_Date__c = Date.valueOf(weeklyShipmentSummaryAgg.get('weekEndDate'));
            weeklyShipmentSummary.Quantity__c = Double.valueOf(weeklyShipmentSummaryAgg.get('Quantity'));
            weeklyShipmentMap.put(shipmentKey,weeklyShipmentSummary);            
        }          
        return weeklyShipmentMap;
    }
   
    //Fetching all the supply details
    public Map<string,Weekly_Shipment_Summary__c> fetchWeeklyShipmentSummary(String orderToCompany,String retailerCode,String modelName,Date weekStartDate,Date weekEndDate,boolean isCurrentWeek){
        
        Map<string,Weekly_Shipment_Summary__c> weeklyShipmentSummaryMap = getWeeklyShipmentSummary(orderToCompany,retailerCode,modelName,weekStartDate,weekEndDate, isCurrentWeek);   
        
        return weeklyShipmentSummaryMap;
    }
     
    
    
    
    //Fetching all the shipment details
    public Map<string,Weekly_Shipment_Summary__c> fetchWeeklyShipmentSummaryForDemandId(SET<ID> weeklyDemandIds){ 
        
        Map<string,Weekly_Shipment_Summary__c> weeklyShipMap = new Map<string,Weekly_Shipment_Summary__c>();
        
        AggregateResult[] weeklyShipmentSummaryAggreList = [SELECT Id, Mainetti_Company__c OrderToCompany, Retailer_Code__c RetailerCode, Retailer_Code__r.Name RetailerName,Mainetti_Model__c ModelCode,Mainetti_Model__r.Name ModelName,Color__c Color,Sizer_Print__c Printer,Week_Start_Date__c weekStartDate,Week_End_Date__c weekEndDate,SUM(Quantity__c) Quantity FROM Weekly_Shipment_Summary__c WHERE  Weekly_Demand_Summary__c IN:weeklyDemandIds GROUP BY  Id,Mainetti_Company__c , Retailer_Code__c , Retailer_Code__r.Name ,Mainetti_Model__c ,Mainetti_Model__r.Name ,Color__c ,Sizer_Print__c,Week_Start_Date__c,Week_End_Date__c];
        Map<string,Weekly_Shipment_Summary__c> weeklyShipmentMap = new Map<string,Weekly_Shipment_Summary__c>(); 
        
        for (AggregateResult weeklyShipmentSummaryAgg : weeklyShipmentSummaryAggreList){            
            
            Weekly_Shipment_Summary__c weeklyShipmentSummary = new Weekly_Shipment_Summary__c();        
            String shipmentKey = new ProcessInventoryAllocation().getShipmentKey(weeklyShipmentSummaryAgg);
            weeklyShipmentSummary.Mainetti_Company__c	 = String.valueOf(weeklyShipmentSummaryAgg.get('OrderToCompany'));
            weeklyShipmentSummary.Retailer_Name__c = String.valueOf(weeklyShipmentSummaryAgg.get('RetailerName'));
            weeklyShipmentSummary.Mainetti_Model_Name__c = String.valueOf(weeklyShipmentSummaryAgg.get('ModelName'));
            weeklyShipmentSummary.Color__c = String.valueOf(weeklyShipmentSummaryAgg.get('Color'));
            weeklyShipmentSummary.Sizer_Print__c = String.valueOf(weeklyShipmentSummaryAgg.get('Printer'));            
            weeklyShipmentSummary.Week_Start_Date__c = Date.valueOf(weeklyShipmentSummaryAgg.get('weekStartDate'));
            weeklyShipmentSummary.Week_End_Date__c = Date.valueOf(weeklyShipmentSummaryAgg.get('weekEndDate'));
            weeklyShipmentSummary.Quantity__c = Double.valueOf(weeklyShipmentSummaryAgg.get('Quantity'));
            weeklyShipmentMap.put(shipmentKey,weeklyShipmentSummary);
            
        }
        return weeklyShipmentMap;
    }
    
    //Fetching all the shipment details
    public Map<string,Weekly_Demand_Summary__c> fetchInventoryAllocationForDemandIds(SET<ID> weeklyDemandIds){ 
        //System.debug('#########3'+weeklyDemandIds);
        Map<string,Weekly_Demand_Summary__c> weeklyAllocationMap = new Map<string,Weekly_Demand_Summary__c>();
        AggregateResult[] inventoryAllocationList = new List<AggregateResult>();
        //String getQueryStringDmd = 'SELECT Inventory_Allocation_Demand__c invAllocDemandId,Inventory_Allocation_Demand__r.Order_to_Company__c OrderToCompany, Inventory_Allocation_Demand__r.Retailer_Code__c RetailerCode,Inventory_Allocation_Demand__r.Retailer_Code__r.Name RetailerName,Inventory_Allocation_Demand__r.Mainetti_Model__r.Name ModelName,Inventory_Allocation_Demand__r.Mainetti_Model__c Model,Inventory_Allocation_Demand__r.Color__c Color,Inventory_Allocation_Demand__r.Mainetti_Model__r.Sizer_Print__c Printer,Sum(Quantity__c) Quantity  FROM Inventory_Allocation__c WHERE Inventory_Allocation_Demand__c IN:weeklyDemandIds GROUP BY Inventory_Allocation_Demand__r.Order_to_Company__c,Inventory_Allocation_Demand__r.Retailer_Code__c,Inventory_Allocation_Demand__r.Retailer_Code__r.Name,Inventory_Allocation_Demand__r.Mainetti_Model__r.Name,Inventory_Allocation_Demand__r.Mainetti_Model__c,Inventory_Allocation_Demand__r.Color__c,Inventory_Allocation_Demand__r.Mainetti_Model__r.Sizer_Print__c,Inventory_Allocation_Demand__c ';
        String getQueryStringDmd = 'SELECT Inventory_Allocation_Demand__c invAllocDemandId,Physically_Available__c physicalyAvailable,Sum(Quantity__c) Quantity  FROM Inventory_Allocation__c WHERE Inventory_Allocation_Demand__c IN:weeklyDemandIds AND Physically_Available__c=true GROUP BY Inventory_Allocation_Demand__c,Physically_Available__c ';
        for( AggregateResult[] inventoryAllocationListResult: Database.Query(getQueryStringDmd)) {
            inventoryAllocationList.addAll(inventoryAllocationListResult);
        }
        //System.debug('########inventoryAllocationList'+inventoryAllocationList.size());
        for (AggregateResult inventoryAllocation : inventoryAllocationList){
            Weekly_Demand_Summary__c  weeklyDemandSummary = new Weekly_Demand_Summary__c();
            weeklyDemandSummary.ID = String.valueOf(inventoryAllocation.get('invAllocDemandId')); 
            weeklyDemandSummary.Quantity__c = Double.valueOf(inventoryAllocation.get('Quantity'));
            weeklyDemandSummary.isAllocationDone__c = Boolean.valueOf(inventoryAllocation.get('physicalyAvailable')); 
            weeklyAllocationMap.put(weeklyDemandSummary.ID,weeklyDemandSummary);
            //Generating the key for the Map
            
           /* String demandKey = new ProcessInventoryAllocation().getDemandKey(inventoryAllocation);
            //System.debug(' fetchInventoryAllocationSummary::::demandKey'+demandKey); 
            //If the record does not exits then create a new record.
            if(!weeklyAllocationMap.containsKey(demandKey)){
                //System.debug(' fetchInventoryAllocationSummary:::Inside NOT Present');                 
                Weekly_Demand_Summary__c  weeklyDemandSummary = new Weekly_Demand_Summary__c();
                weeklyDemandSummary.ID = String.valueOf(inventoryAllocation.get('invAllocDemandId')); 
                weeklyDemandSummary.Quantity__c = Double.valueOf(inventoryAllocation.get('Quantity'));     
                //System.debug(' fetchInventoryAllocationSummary:::AFTER'); 
                weeklyAllocationMap.put(demandKey,weeklyDemandSummary);
            }else{
                //System.debug(' fetchInventoryAllocationSummary:::Inside Present'); 
                //getting the updated quantity for the combination of the Key.
                Weekly_Demand_Summary__c  weeklyDemandSummary = weeklyAllocationMap.get(demandKey);
                //System.debug(' fetchInventoryAllocationSummary:::BEFORE QUANTITY'); 
                Double oldQuantity = weeklyDemandSummary.Quantity__c;
                Double newQuantity = Double.valueOf(inventoryAllocation.get('Quantity'));      
                //System.debug(' fetchInventoryAllocationSummary:::AFTER QUANTITY'); 
                //System.debug(' fetchInventoryAllocationSummary:::Inside Existing NEW Quantity'+(oldQuantity+newQuantity)); 
                weeklyDemandSummary.Quantity__c = (oldQuantity+newQuantity);                                
                weeklyAllocationMap.put(demandKey,weeklyDemandSummary);                                 
            }*/                        
       }
        return weeklyAllocationMap;
    } 
    
    public Map<string,Weekly_Demand_Summary__c> fetchInventoryAllocationForDemandIdsQtyNotAvailable(SET<ID> weeklyDemandIds){ 
        //System.debug('#########3'+weeklyDemandIds);
        Map<string,Weekly_Demand_Summary__c> weeklyAllocationMap = new Map<string,Weekly_Demand_Summary__c>();
        AggregateResult[] inventoryAllocationList = new List<AggregateResult>();
        //String getQueryStringDmd = 'SELECT Inventory_Allocation_Demand__c invAllocDemandId,Inventory_Allocation_Demand__r.Order_to_Company__c OrderToCompany, Inventory_Allocation_Demand__r.Retailer_Code__c RetailerCode,Inventory_Allocation_Demand__r.Retailer_Code__r.Name RetailerName,Inventory_Allocation_Demand__r.Mainetti_Model__r.Name ModelName,Inventory_Allocation_Demand__r.Mainetti_Model__c Model,Inventory_Allocation_Demand__r.Color__c Color,Inventory_Allocation_Demand__r.Mainetti_Model__r.Sizer_Print__c Printer,Sum(Quantity__c) Quantity  FROM Inventory_Allocation__c WHERE Inventory_Allocation_Demand__c IN:weeklyDemandIds GROUP BY Inventory_Allocation_Demand__r.Order_to_Company__c,Inventory_Allocation_Demand__r.Retailer_Code__c,Inventory_Allocation_Demand__r.Retailer_Code__r.Name,Inventory_Allocation_Demand__r.Mainetti_Model__r.Name,Inventory_Allocation_Demand__r.Mainetti_Model__c,Inventory_Allocation_Demand__r.Color__c,Inventory_Allocation_Demand__r.Mainetti_Model__r.Sizer_Print__c,Inventory_Allocation_Demand__c ';
        String getQueryStringDmd = 'SELECT Inventory_Allocation_Demand__c invAllocDemandId,Physically_Available__c physicalyAvailable,Sum(Quantity__c) Quantity  FROM Inventory_Allocation__c WHERE Inventory_Allocation_Demand__c IN:weeklyDemandIds AND Physically_Available__c=false GROUP BY Inventory_Allocation_Demand__c,Physically_Available__c ';
        for( AggregateResult[] inventoryAllocationListResult: Database.Query(getQueryStringDmd)) {
            inventoryAllocationList.addAll(inventoryAllocationListResult);
        }
        //System.debug('########inventoryAllocationList'+inventoryAllocationList.size());
        for (AggregateResult inventoryAllocation : inventoryAllocationList){
            Weekly_Demand_Summary__c  weeklyDemandSummary = new Weekly_Demand_Summary__c();
            weeklyDemandSummary.ID = String.valueOf(inventoryAllocation.get('invAllocDemandId')); 
            weeklyDemandSummary.Quantity__c = Double.valueOf(inventoryAllocation.get('Quantity'));
            weeklyDemandSummary.isAllocationDone__c = Boolean.valueOf(inventoryAllocation.get('physicalyAvailable')); 
            weeklyAllocationMap.put(weeklyDemandSummary.ID,weeklyDemandSummary);
            //Generating the key for the Map
            
           /* String demandKey = new ProcessInventoryAllocation().getDemandKey(inventoryAllocation);
            //System.debug(' fetchInventoryAllocationSummary::::demandKey'+demandKey); 
            //If the record does not exits then create a new record.
            if(!weeklyAllocationMap.containsKey(demandKey)){
                //System.debug(' fetchInventoryAllocationSummary:::Inside NOT Present');                 
                Weekly_Demand_Summary__c  weeklyDemandSummary = new Weekly_Demand_Summary__c();
                weeklyDemandSummary.ID = String.valueOf(inventoryAllocation.get('invAllocDemandId')); 
                weeklyDemandSummary.Quantity__c = Double.valueOf(inventoryAllocation.get('Quantity'));     
                //System.debug(' fetchInventoryAllocationSummary:::AFTER'); 
                weeklyAllocationMap.put(demandKey,weeklyDemandSummary);
            }else{
                //System.debug(' fetchInventoryAllocationSummary:::Inside Present'); 
                //getting the updated quantity for the combination of the Key.
                Weekly_Demand_Summary__c  weeklyDemandSummary = weeklyAllocationMap.get(demandKey);
                //System.debug(' fetchInventoryAllocationSummary:::BEFORE QUANTITY'); 
                Double oldQuantity = weeklyDemandSummary.Quantity__c;
                Double newQuantity = Double.valueOf(inventoryAllocation.get('Quantity'));      
                //System.debug(' fetchInventoryAllocationSummary:::AFTER QUANTITY'); 
                //System.debug(' fetchInventoryAllocationSummary:::Inside Existing NEW Quantity'+(oldQuantity+newQuantity)); 
                weeklyDemandSummary.Quantity__c = (oldQuantity+newQuantity);                                
                weeklyAllocationMap.put(demandKey,weeklyDemandSummary);                                 
            }*/                        
       }
        return weeklyAllocationMap;
    } 
    public  Map<string,Weekly_Demand_Summary__c> getWeeklyInventoryAllocationSummary(String orderToCompany,String retailerCode,String modelName,Date weekStartDate,Date weekEndDate,boolean isCurrentWeek){   
        
        if(isCurrentWeek){
            Date startdate = date.today();
            Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
            weekStartDate = todaydateinstance.toStartOfWeek();
            weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        }
        String searchQuery = 'SELECT Inventory_Allocation_Demand__c Id,Inventory_Allocation_Demand__r.Order_to_Company__c OrderToCompany,Inventory_Allocation_Demand__r.Retailer_Code__c RetailerCode,Inventory_Allocation_Demand__r.Retailer_Code__r.Name RetailerName,Inventory_Allocation_Demand__r.Mainetti_Model__r.Name ModelName,Inventory_Allocation_Demand__r.Mainetti_Model__c Model,Inventory_Allocation_Demand__r.Color__c Color,Inventory_Allocation_Demand__r.Mainetti_Model__r.Sizer_Print__c Printer,Physically_Available__c physicalyAvailable,Sum(Quantity__c) Quantity  FROM Inventory_Allocation__c  WHERE Physically_Available__c=true ';
        
        if(String.isNotBlank(string.valueOf(weekStartDate)) || String.isNotBlank(string.valueOf(weekEndDate))||String.isNotBlank(orderToCompany)||String.isNotBlank(retailerCode)||String.isNotBlank(modelName)){
            searchQuery += ' AND ';
        }         
        boolean dateFieldFrmPresent = false;
        boolean dateFieldToPresent = false;
        boolean orderToCompanyPresent = false;
        boolean retailerCodePresent = false;
        boolean modelNamePresent = false;
        if(String.isNotBlank(string.valueOf(weekStartDate)) || String.isNotBlank(string.valueOf(weekEndDate))){
            if(String.isNotBlank(string.valueOf(weekStartDate)) && String.isNotBlank(string.valueOf(weekEndDate))){
                searchQuery += ' Inventory_Allocation_Demand__r.Week_Start_Date__c >=:weekStartDate AND Inventory_Allocation_Demand__r.Week_End_Date__c <=:weekEndDate';       
                dateFieldFrmPresent = true; 
                dateFieldToPresent = true;
            }
            if(String.isNotBlank(string.valueOf(weekStartDate)) && String.isBlank(string.valueOf(weekEndDate))){
                searchQuery += ' Inventory_Allocation_Demand__r.Week_Start_Date__c >=:weekStartDate';
                dateFieldFrmPresent = true;
            }
            if(String.isBlank(string.valueOf(weekStartDate)) && String.isNotBlank(string.valueOf(weekEndDate))){
                searchQuery += ' Inventory_Allocation_Demand__r.Week_End_Date__c >=:weekEndDate';
                dateFieldToPresent = true;
            }            
        }
        if(String.isNotBlank(orderToCompany)){
            if(dateFieldFrmPresent==true || dateFieldToPresent==true){
                searchQuery += ' AND Inventory_Allocation_Demand__r.Order_to_Company__c=:orderToCompany';
            }else{
                searchQuery += ' Inventory_Allocation_Demand__r.Order_to_Company__c=:orderToCompany';
            }
            orderToCompanyPresent = true;
        }
        if(String.isNotBlank(retailerCode)){
            
            if(dateFieldFrmPresent==true || dateFieldToPresent==true || orderToCompanyPresent==true){
                searchQuery += ' AND Inventory_Allocation_Demand__r.Retailer_Code__r.Name =:retailerCode';
            }else{
                searchQuery += ' Inventory_Allocation_Demand__r.Retailer_Code__r.Name =:retailerCode';
            }
            retailerCodePresent = true;
        }
        if(String.isNotBlank(modelName)){
            if(dateFieldFrmPresent==true || dateFieldToPresent==true || orderToCompanyPresent==true || retailerCodePresent==true){
                searchQuery += ' AND Inventory_Allocation_Demand__r.Mainetti_Model__r.Name=:modelName';
            }else{
                searchQuery += ' Inventory_Allocation_Demand__r.Mainetti_Model__r.Name=:modelName';
            }
        }        
        searchQuery += ' GROUP BY  Inventory_Allocation_Demand__r.Order_to_Company__c,Inventory_Allocation_Demand__r.Retailer_Code__c,Inventory_Allocation_Demand__r.Retailer_Code__r.Name,Inventory_Allocation_Demand__r.Mainetti_Model__r.Name,Inventory_Allocation_Demand__r.Mainetti_Model__c,Inventory_Allocation_Demand__r.Color__c,Inventory_Allocation_Demand__r.Mainetti_Model__r.Sizer_Print__c,Inventory_Allocation_Demand__c,Physically_Available__c ';
        
        Map<string,Weekly_Demand_Summary__c> weeklyDemandMap = new Map<string,Weekly_Demand_Summary__c>();
        //Getting the total count of records only the first time         
        //System.debug('searchQuery::::'+searchQuery+':::');        
        AggregateResult[] weeklyDemandSummaryAggreList = Database.query(searchQuery);
        //System.debug('weeklyDemandSummaryAggreListSize:'+weeklyDemandSummaryAggreList.size());
        //System.debug('weeklyDemandSummaryAggreListAvail:'+weeklyDemandSummaryAggreList);
        for (AggregateResult weeklyDemandSummaryAgg : weeklyDemandSummaryAggreList){            
            
            Weekly_Demand_Summary__c weeklyDemandSummary = new Weekly_Demand_Summary__c();
            weeklyDemandSummary.Id = String.valueOf(weeklyDemandSummaryAgg.get('Id'));            
            String demandKey = new ProcessInventoryAllocation().getDemandKey(weeklyDemandSummaryAgg);
            //System.debug('demandKey::::'+demandKey);
            weeklyDemandSummary.Order_to_Company__c = String.valueOf(weeklyDemandSummaryAgg.get('OrderToCompany'));
            weeklyDemandSummary.Retailer_Name__c = String.valueOf(weeklyDemandSummaryAgg.get('RetailerName'));
            weeklyDemandSummary.Mainetti_Model_Name__c = String.valueOf(weeklyDemandSummaryAgg.get('ModelName'));
            weeklyDemandSummary.Color__c = String.valueOf(weeklyDemandSummaryAgg.get('Color'));
            weeklyDemandSummary.Sizer_Print__c = String.valueOf(weeklyDemandSummaryAgg.get('Printer'));            
            weeklyDemandSummary.Quantity__c = Double.valueOf(weeklyDemandSummaryAgg.get('Quantity'));
            weeklyDemandSummary.isAllocationDone__c = Boolean.valueOf(weeklyDemandSummaryAgg.get('physicalyAvailable'));
            weeklyDemandMap.put(demandKey,weeklyDemandSummary);
        }  
        return weeklyDemandMap;
    }
    
    public  Map<string,Weekly_Demand_Summary__c> getWeeklyInventoryAllocationSummaryQtyNotAvailable(String orderToCompany,String retailerCode,String modelName,Date weekStartDate,Date weekEndDate,boolean isCurrentWeek){   
        
        if(isCurrentWeek){
            Date startdate = date.today();
            Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
            weekStartDate = todaydateinstance.toStartOfWeek();
            weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        }
        String searchQuery = 'SELECT Inventory_Allocation_Demand__c Id,Inventory_Allocation_Demand__r.Order_to_Company__c OrderToCompany,Inventory_Allocation_Demand__r.Retailer_Code__c RetailerCode,Inventory_Allocation_Demand__r.Retailer_Code__r.Name RetailerName,Inventory_Allocation_Demand__r.Mainetti_Model__r.Name ModelName,Inventory_Allocation_Demand__r.Mainetti_Model__c Model,Inventory_Allocation_Demand__r.Color__c Color,Inventory_Allocation_Demand__r.Mainetti_Model__r.Sizer_Print__c Printer,Physically_Available__c physicalyAvailable,Sum(Quantity__c) Quantity  FROM Inventory_Allocation__c  WHERE  Physically_Available__c=false ';
        
        if(String.isNotBlank(string.valueOf(weekStartDate)) || String.isNotBlank(string.valueOf(weekEndDate))||String.isNotBlank(orderToCompany)||String.isNotBlank(retailerCode)||String.isNotBlank(modelName)){
            searchQuery += ' AND ';
        }         
        boolean dateFieldFrmPresent = false;
        boolean dateFieldToPresent = false;
        boolean orderToCompanyPresent = false;
        boolean retailerCodePresent = false;
        boolean modelNamePresent = false;
        if(String.isNotBlank(string.valueOf(weekStartDate)) || String.isNotBlank(string.valueOf(weekEndDate))){
            if(String.isNotBlank(string.valueOf(weekStartDate)) && String.isNotBlank(string.valueOf(weekEndDate))){
                searchQuery += ' Inventory_Allocation_Demand__r.Week_Start_Date__c >=:weekStartDate AND Inventory_Allocation_Demand__r.Week_End_Date__c <=:weekEndDate';       
                dateFieldFrmPresent = true; 
                dateFieldToPresent = true;
            }
            if(String.isNotBlank(string.valueOf(weekStartDate)) && String.isBlank(string.valueOf(weekEndDate))){
                searchQuery += ' Inventory_Allocation_Demand__r.Week_Start_Date__c >=:weekStartDate';
                dateFieldFrmPresent = true;
            }
            if(String.isBlank(string.valueOf(weekStartDate)) && String.isNotBlank(string.valueOf(weekEndDate))){
                searchQuery += ' Inventory_Allocation_Demand__r.Week_End_Date__c >=:weekEndDate';
                dateFieldToPresent = true;
            }            
        }
        if(String.isNotBlank(orderToCompany)){
            if(dateFieldFrmPresent==true || dateFieldToPresent==true){
                searchQuery += ' AND Inventory_Allocation_Demand__r.Order_to_Company__c=:orderToCompany';
            }else{
                searchQuery += ' Inventory_Allocation_Demand__r.Order_to_Company__c=:orderToCompany';
            }
            orderToCompanyPresent = true;
        }
        if(String.isNotBlank(retailerCode)){
            
            if(dateFieldFrmPresent==true || dateFieldToPresent==true || orderToCompanyPresent==true){
                searchQuery += ' AND Inventory_Allocation_Demand__r.Retailer_Code__r.Name =:retailerCode';
            }else{
                searchQuery += ' Inventory_Allocation_Demand__r.Retailer_Code__r.Name =:retailerCode';
            }
            retailerCodePresent = true;
        }
        if(String.isNotBlank(modelName)){
            if(dateFieldFrmPresent==true || dateFieldToPresent==true || orderToCompanyPresent==true || retailerCodePresent==true){
                searchQuery += ' AND Inventory_Allocation_Demand__r.Mainetti_Model__r.Name=:modelName';
            }else{
                searchQuery += ' Inventory_Allocation_Demand__r.Mainetti_Model__r.Name=:modelName';
            }
        }        
        searchQuery += ' GROUP BY  Inventory_Allocation_Demand__r.Order_to_Company__c,Inventory_Allocation_Demand__r.Retailer_Code__c,Inventory_Allocation_Demand__r.Retailer_Code__r.Name,Inventory_Allocation_Demand__r.Mainetti_Model__r.Name,Inventory_Allocation_Demand__r.Mainetti_Model__c,Inventory_Allocation_Demand__r.Color__c,Inventory_Allocation_Demand__r.Mainetti_Model__r.Sizer_Print__c,Inventory_Allocation_Demand__c,Physically_Available__c ';
        
        Map<string,Weekly_Demand_Summary__c> weeklyDemandMap = new Map<string,Weekly_Demand_Summary__c>();
        //Getting the total count of records only the first time         
        //System.debug('searchQuery::::'+searchQuery+':::');        
        AggregateResult[] weeklyDemandSummaryAggreList = Database.query(searchQuery);
        //System.debug('weeklyDemandSummaryAggreListSize:'+weeklyDemandSummaryAggreList.size());
        //System.debug('weeklyDemandSummaryAggreListNotAvail:'+weeklyDemandSummaryAggreList);
        for (AggregateResult weeklyDemandSummaryAgg : weeklyDemandSummaryAggreList){            
            
            Weekly_Demand_Summary__c weeklyDemandSummary = new Weekly_Demand_Summary__c();
            weeklyDemandSummary.Id = String.valueOf(weeklyDemandSummaryAgg.get('Id'));            
            String demandKey = new ProcessInventoryAllocation().getDemandKey(weeklyDemandSummaryAgg);
            //System.debug('demandKey::::'+demandKey);
            weeklyDemandSummary.Order_to_Company__c = String.valueOf(weeklyDemandSummaryAgg.get('OrderToCompany'));
            weeklyDemandSummary.Retailer_Name__c = String.valueOf(weeklyDemandSummaryAgg.get('RetailerName'));
            weeklyDemandSummary.Mainetti_Model_Name__c = String.valueOf(weeklyDemandSummaryAgg.get('ModelName'));
            weeklyDemandSummary.Color__c = String.valueOf(weeklyDemandSummaryAgg.get('Color'));
            weeklyDemandSummary.Sizer_Print__c = String.valueOf(weeklyDemandSummaryAgg.get('Printer'));            
            weeklyDemandSummary.Quantity__c = Double.valueOf(weeklyDemandSummaryAgg.get('Quantity'));
            weeklyDemandSummary.isAllocationDone__c = Boolean.valueOf(weeklyDemandSummaryAgg.get('physicalyAvailable'));
            weeklyDemandMap.put(demandKey,weeklyDemandSummary);
        }  
        //system.debug('weeklyDemandMap:'+weeklyDemandMap);
        return weeklyDemandMap;
    }
    
    
    
    
    
    
    //Fetching all the shipment details
    public Map<string,Weekly_Supply_Summary__c> fetchInventoryAllocationForSupplierIds(SET<ID> weeklySupplyIds){ 
        Map<string,Weekly_Supply_Summary__c> weeklyAllocationMap = new Map<string,Weekly_Supply_Summary__c>();
        AggregateResult[] inventoryAllocationList = new List<AggregateResult>();
        String getQueryStringDmd = 'SELECT Inventory_Allocation_Supply__c invAllocSupplyId,Inventory_Allocation_Supply__r.Mainetti_Company__c OrderToCompany, Inventory_Allocation_Supply__r.Retailer_Code__c RetailerCode,Inventory_Allocation_Supply__r.Retailer_Code__r.Name RetailerName,Inventory_Allocation_Supply__r.Mainetti_Model__r.Name ModelName,Inventory_Allocation_Supply__r.Mainetti_Model__c Model,Inventory_Allocation_Supply__r.Color__c Color,Inventory_Allocation_Supply__r.Mainetti_Model__r.Sizer_Print__c Printer,Inventory_Allocation_Supply__r.Warehouse__c wareHouse,Sum(Quantity__c) Quantity  FROM Inventory_Allocation__c WHERE Inventory_Allocation_Supply__c IN:weeklySupplyIds GROUP BY Inventory_Allocation_Supply__r.Mainetti_Company__c,Inventory_Allocation_Supply__r.Retailer_Code__c,Inventory_Allocation_Supply__r.Retailer_Code__r.Name,Inventory_Allocation_Supply__r.Mainetti_Model__r.Name,Inventory_Allocation_Supply__r.Mainetti_Model__c,Inventory_Allocation_Supply__r.Color__c,Inventory_Allocation_Supply__r.Mainetti_Model__r.Sizer_Print__c,Inventory_Allocation_Supply__r.Warehouse__c,Inventory_Allocation_Supply__c ';
        for( AggregateResult[] inventoryAllocationListResult: Database.Query(getQueryStringDmd)) {
            inventoryAllocationList.addAll(inventoryAllocationListResult);
        }
        //System.debug('inventoryAllocationList'+inventoryAllocationList.size());
        for (AggregateResult inventoryAllocation : inventoryAllocationList){
            //Generating the key for the Map
            String SupplyKey = new ProcessInventoryAllocation().getSupplyKey(inventoryAllocation);
            //System.debug(' fetchInventoryAllocationSummary::::SupplyKey'+SupplyKey); 
            //If the record does not exits then create a new record.
            if(!weeklyAllocationMap.containsKey(SupplyKey)){
                //System.debug(' fetchInventoryAllocationSummary:::Inside NOT Present');                 
                Weekly_Supply_Summary__c  weeklySupplySummary = new Weekly_Supply_Summary__c();
                weeklySupplySummary.ID = String.valueOf(inventoryAllocation.get('invAllocSupplyId')); 
                weeklySupplySummary.Quantity__c = Double.valueOf(inventoryAllocation.get('Quantity'));     
                //System.debug(' fetchInventoryAllocationSummary:::AFTER'); 
                weeklyAllocationMap.put(SupplyKey,weeklySupplySummary);
            }else{
                //System.debug(' fetchInventoryAllocationSummary:::Inside Present'); 
                //getting the updated quantity for the combination of the Key.
                Weekly_Supply_Summary__c  weeklySupplySummary = weeklyAllocationMap.get(SupplyKey);
                //System.debug(' fetchInventoryAllocationSummary:::BEFORE QUANTITY'); 
                Double oldQuantity = weeklySupplySummary.Quantity__c;
                Double newQuantity = Double.valueOf(inventoryAllocation.get('Quantity'));      
                //System.debug(' fetchInventoryAllocationSummary:::AFTER QUANTITY'); 
                //System.debug(' fetchInventoryAllocationSummary:::Inside Existing NEW Quantity'+(oldQuantity+newQuantity)); 
                weeklySupplySummary.Quantity__c = (oldQuantity+newQuantity);                                
                weeklyAllocationMap.put(SupplyKey,weeklySupplySummary);                 
                
            }            
            
        }
        return weeklyAllocationMap;
    }
    
        public Map<string,Weekly_Supply_Summary__c> fetchInventoryAllocationForSupplierIdsV2(SET<ID> weeklySupplyIds){ 
        Map<string,Weekly_Supply_Summary__c> weeklyAllocationMap = new Map<string,Weekly_Supply_Summary__c>();
        AggregateResult[] inventoryAllocationList = new List<AggregateResult>();
        String getQueryStringDmd = 'SELECT Inventory_Allocation_Supply__c invAllocSupplyId,Inventory_Allocation_Supply__r.Mainetti_Company__c OrderToCompany, Inventory_Allocation_Supply__r.Retailer_Code__c RetailerCode,Inventory_Allocation_Supply__r.Retailer_Code__r.Name RetailerName,Inventory_Allocation_Supply__r.Mainetti_Model__r.Name ModelName,Inventory_Allocation_Supply__r.Mainetti_Model__c Model,Inventory_Allocation_Supply__r.Color__c Color,Inventory_Allocation_Supply__r.Mainetti_Model__r.Sizer_Print__c Printer,Inventory_Allocation_Supply__r.Warehouse__c wareHouse,Sum(Quantity__c) Quantity  FROM Inventory_Allocation__c WHERE Inventory_Allocation_Supply__c IN:weeklySupplyIds GROUP BY Inventory_Allocation_Supply__r.Mainetti_Company__c,Inventory_Allocation_Supply__r.Retailer_Code__c,Inventory_Allocation_Supply__r.Retailer_Code__r.Name,Inventory_Allocation_Supply__r.Mainetti_Model__r.Name,Inventory_Allocation_Supply__r.Mainetti_Model__c,Inventory_Allocation_Supply__r.Color__c,Inventory_Allocation_Supply__r.Mainetti_Model__r.Sizer_Print__c,Inventory_Allocation_Supply__r.Warehouse__c,Inventory_Allocation_Supply__c ';
        for( AggregateResult[] inventoryAllocationListResult: Database.Query(getQueryStringDmd)) {
            inventoryAllocationList.addAll(inventoryAllocationListResult);
        }
        //System.debug('inventoryAllocationList'+inventoryAllocationList.size());
        for (AggregateResult inventoryAllocation : inventoryAllocationList){
            //Generating the key for the Map
            String SupplyKey = new ProcessInventoryAllocation().getSupplyKeyV2(inventoryAllocation);
            //System.debug(' fetchInventoryAllocationSummary::::SupplyKey'+SupplyKey); 
            //If the record does not exits then create a new record.
            if(!weeklyAllocationMap.containsKey(SupplyKey)){
                //System.debug(' fetchInventoryAllocationSummary:::Inside NOT Present');                 
                Weekly_Supply_Summary__c  weeklySupplySummary = new Weekly_Supply_Summary__c();
                weeklySupplySummary.ID = String.valueOf(inventoryAllocation.get('invAllocSupplyId')); 
                weeklySupplySummary.Quantity__c = Double.valueOf(inventoryAllocation.get('Quantity'));     
                //System.debug(' fetchInventoryAllocationSummary:::AFTER'); 
                weeklyAllocationMap.put(SupplyKey,weeklySupplySummary);
            }else{
                //System.debug(' fetchInventoryAllocationSummary:::Inside Present'); 
                //getting the updated quantity for the combination of the Key.
                Weekly_Supply_Summary__c  weeklySupplySummary = weeklyAllocationMap.get(SupplyKey);
                //System.debug(' fetchInventoryAllocationSummary:::BEFORE QUANTITY'); 
                Double oldQuantity = weeklySupplySummary.Quantity__c;
                Double newQuantity = Double.valueOf(inventoryAllocation.get('Quantity'));      
                //System.debug(' fetchInventoryAllocationSummary:::AFTER QUANTITY'); 
                //System.debug(' fetchInventoryAllocationSummary:::Inside Existing NEW Quantity'+(oldQuantity+newQuantity)); 
                weeklySupplySummary.Quantity__c = (oldQuantity+newQuantity);                                
                weeklyAllocationMap.put(SupplyKey,weeklySupplySummary);                 
                
            }            
            
        }
        return weeklyAllocationMap;
    }
    
    public  Map<string,Weekly_Supply_Summary__c> getWeeklySupplyInventoryAllocationSummary(String orderToCompany,String retailerCode,String modelName,Date weekStartDate,Date weekEndDate,boolean isCurrentWeek){   
        
        if(isCurrentWeek){
            Date startdate = date.today();
            Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
            weekStartDate = todaydateinstance.toStartOfWeek();
            weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        }
        String searchQuery = 'SELECT Inventory_Allocation_Supply__c Id,Inventory_Allocation_Supply__r.Mainetti_Company__c OrderToCompany,Inventory_Allocation_Supply__r.Retailer_Code__c RetailerCode,Inventory_Allocation_Supply__r.Retailer_Code__r.Name RetailerName,Inventory_Allocation_Supply__r.Mainetti_Model__r.Name ModelName,Inventory_Allocation_Supply__r.Mainetti_Model__c Model,Inventory_Allocation_Supply__r.Color__c Color,Inventory_Allocation_Supply__r.Mainetti_Model__r.Sizer_Print__c Printer,Inventory_Allocation_Supply__r.Warehouse__c wareHouse,Sum(Quantity__c) Quantity  FROM Inventory_Allocation__c';
        
        if(String.isNotBlank(string.valueOf(weekStartDate)) || String.isNotBlank(string.valueOf(weekEndDate))||String.isNotBlank(orderToCompany)||String.isNotBlank(retailerCode)||String.isNotBlank(modelName)){
            searchQuery += ' WHERE ';
        }         
        boolean dateFieldFrmPresent = false;
        boolean dateFieldToPresent = false;
        boolean orderToCompanyPresent = false;
        boolean retailerCodePresent = false;
        boolean modelNamePresent = false;
        if(String.isNotBlank(string.valueOf(weekStartDate)) || String.isNotBlank(string.valueOf(weekEndDate))){
            if(String.isNotBlank(string.valueOf(weekStartDate)) && String.isNotBlank(string.valueOf(weekEndDate))){
                searchQuery += ' Inventory_Allocation_Supply__r.Week_Start_Date__c >=:weekStartDate AND Inventory_Allocation_Supply__r.Week_End_Date__c <=:weekEndDate';       
                dateFieldFrmPresent = true; 
                dateFieldToPresent = true;
            }
            if(String.isNotBlank(string.valueOf(weekStartDate)) && String.isBlank(string.valueOf(weekEndDate))){
                searchQuery += ' Inventory_Allocation_Supply__r.Week_Start_Date__c >=:weekStartDate';
                dateFieldFrmPresent = true;
            }
            if(String.isBlank(string.valueOf(weekStartDate)) && String.isNotBlank(string.valueOf(weekEndDate))){
                searchQuery += ' Inventory_Allocation_Supply__r.Week_End_Date__c >=:weekEndDate';
                dateFieldToPresent = true;
            }            
        }
        if(String.isNotBlank(orderToCompany)){
            if(dateFieldFrmPresent==true || dateFieldToPresent==true){
                searchQuery += ' AND Inventory_Allocation_Supply__r.Mainetti_Company__c=:orderToCompany';
            }else{
                searchQuery += ' Inventory_Allocation_Supply__r.Mainetti_Company__c=:orderToCompany';
            }
            orderToCompanyPresent = true;
        }
        if(String.isNotBlank(retailerCode)){
            
            if(dateFieldFrmPresent==true || dateFieldToPresent==true || orderToCompanyPresent==true){
                searchQuery += ' AND Inventory_Allocation_Supply__r.Retailer_Code__r.Name=:retailerCode';
            }else{
                searchQuery += ' Inventory_Allocation_Supply__r.Retailer_Code__r.Name=:retailerCode';
            }
            retailerCodePresent = true;
        }
        if(String.isNotBlank(modelName)){
            if(dateFieldFrmPresent==true || dateFieldToPresent==true || orderToCompanyPresent==true || retailerCodePresent==true){
                searchQuery += ' AND Inventory_Allocation_Supply__r.Mainetti_Model__r.Name=:modelName';
            }else{
                searchQuery += ' Inventory_Allocation_Supply__r.Mainetti_Model__r.Name=:modelName';
            }
        }        
        searchQuery += ' GROUP BY  Inventory_Allocation_Supply__r.Mainetti_Company__c,Inventory_Allocation_Supply__r.Retailer_Code__c,Inventory_Allocation_Supply__r.Retailer_Code__r.Name,Inventory_Allocation_Supply__r.Mainetti_Model__r.Name,Inventory_Allocation_Supply__r.Mainetti_Model__c,Inventory_Allocation_Supply__r.Color__c,Inventory_Allocation_Supply__r.Mainetti_Model__r.Sizer_Print__c,Inventory_Allocation_Supply__r.Warehouse__c,Inventory_Allocation_Supply__c ';
        
        Map<string,Weekly_Supply_Summary__c> weeklySupplyMap = new Map<string,Weekly_Supply_Summary__c>();
        //Getting the total count of records only the first time 
        
        //System.debug('searchQuery::::'+searchQuery+':::');
        
        AggregateResult[] weeklySupplySummaryAggreList = Database.query(searchQuery);
        System.debug('weeklySupplySummaryAggreList::::'+weeklySupplySummaryAggreList);
        for (AggregateResult weeklySupplySummaryAgg : weeklySupplySummaryAggreList){            
            
            Weekly_Supply_Summary__c weeklySupplySummary = new Weekly_Supply_Summary__c();
            weeklySupplySummary.Id = String.valueOf(weeklySupplySummaryAgg.get('Id'));            
            String SupplyKey = new ProcessInventoryAllocation().getSupplyKey(weeklySupplySummaryAgg);
            weeklySupplySummary.Quantity__c = Double.valueOf(weeklySupplySummaryAgg.get('Quantity'));
            weeklySupplyMap.put(SupplyKey,weeklySupplySummary);
        }  
        return weeklySupplyMap;
    }
    
    public  Map<string,Weekly_Supply_Summary__c> getWeeklySupplyInventoryAllocationSummaryV2(String orderToCompany,String retailerCode,String modelName,Date weekStartDate,Date weekEndDate,boolean isCurrentWeek){   
        
        if(isCurrentWeek){
            Date startdate = date.today();
            Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
            weekStartDate = todaydateinstance.toStartOfWeek();
            weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        }
        String searchQuery = 'SELECT Inventory_Allocation_Supply__c Id,Inventory_Allocation_Supply__r.Mainetti_Company__c OrderToCompany,Inventory_Allocation_Supply__r.Retailer_Code__c RetailerCode,Inventory_Allocation_Supply__r.Retailer_Code__r.Name RetailerName,Inventory_Allocation_Supply__r.Mainetti_Model__r.Name ModelName,Inventory_Allocation_Supply__r.Mainetti_Model__c Model,Inventory_Allocation_Supply__r.Color__c Color,Inventory_Allocation_Supply__r.Mainetti_Model__r.Sizer_Print__c Printer,Inventory_Allocation_Supply__r.Warehouse__c wareHouse,Sum(Quantity__c) Quantity  FROM Inventory_Allocation__c';
        
        if(String.isNotBlank(string.valueOf(weekStartDate)) || String.isNotBlank(string.valueOf(weekEndDate))||String.isNotBlank(orderToCompany)||String.isNotBlank(retailerCode)||String.isNotBlank(modelName)){
            searchQuery += ' WHERE ';
        }         
        boolean dateFieldFrmPresent = false;
        boolean dateFieldToPresent = false;
        boolean orderToCompanyPresent = false;
        boolean retailerCodePresent = false;
        boolean modelNamePresent = false;
        if(String.isNotBlank(string.valueOf(weekStartDate)) || String.isNotBlank(string.valueOf(weekEndDate))){
            if(String.isNotBlank(string.valueOf(weekStartDate)) && String.isNotBlank(string.valueOf(weekEndDate))){
                searchQuery += ' Inventory_Allocation_Supply__r.Week_Start_Date__c >=:weekStartDate AND Inventory_Allocation_Supply__r.Week_End_Date__c <=:weekEndDate';       
                dateFieldFrmPresent = true; 
                dateFieldToPresent = true;
            }
            if(String.isNotBlank(string.valueOf(weekStartDate)) && String.isBlank(string.valueOf(weekEndDate))){
                searchQuery += ' Inventory_Allocation_Supply__r.Week_Start_Date__c >=:weekStartDate';
                dateFieldFrmPresent = true;
            }
            if(String.isBlank(string.valueOf(weekStartDate)) && String.isNotBlank(string.valueOf(weekEndDate))){
                searchQuery += ' Inventory_Allocation_Supply__r.Week_End_Date__c >=:weekEndDate';
                dateFieldToPresent = true;
            }            
        }
        if(String.isNotBlank(orderToCompany)){
            if(dateFieldFrmPresent==true || dateFieldToPresent==true){
                searchQuery += ' AND Inventory_Allocation_Supply__r.Mainetti_Company__c=:orderToCompany';
            }else{
                searchQuery += ' Inventory_Allocation_Supply__r.Mainetti_Company__c=:orderToCompany';
            }
            orderToCompanyPresent = true;
        }
        if(String.isNotBlank(retailerCode)){
            
            if(dateFieldFrmPresent==true || dateFieldToPresent==true || orderToCompanyPresent==true){
                searchQuery += ' AND Inventory_Allocation_Supply__r.Retailer_Code__r.Name=:retailerCode';
            }else{
                searchQuery += ' Inventory_Allocation_Supply__r.Retailer_Code__r.Name=:retailerCode';
            }
            retailerCodePresent = true;
        }
        if(String.isNotBlank(modelName)){
            if(dateFieldFrmPresent==true || dateFieldToPresent==true || orderToCompanyPresent==true || retailerCodePresent==true){
                searchQuery += ' AND Inventory_Allocation_Supply__r.Mainetti_Model__r.Name=:modelName';
            }else{
                searchQuery += ' Inventory_Allocation_Supply__r.Mainetti_Model__r.Name=:modelName';
            }
        }        
        searchQuery += ' GROUP BY  Inventory_Allocation_Supply__r.Mainetti_Company__c,Inventory_Allocation_Supply__r.Retailer_Code__c,Inventory_Allocation_Supply__r.Retailer_Code__r.Name,Inventory_Allocation_Supply__r.Mainetti_Model__r.Name,Inventory_Allocation_Supply__r.Mainetti_Model__c,Inventory_Allocation_Supply__r.Color__c,Inventory_Allocation_Supply__r.Mainetti_Model__r.Sizer_Print__c,Inventory_Allocation_Supply__r.Warehouse__c,Inventory_Allocation_Supply__c ';
        
        Map<string,Weekly_Supply_Summary__c> weeklySupplyMap = new Map<string,Weekly_Supply_Summary__c>();
        //Getting the total count of records only the first time 
        
        //System.debug('searchQuery::::'+searchQuery+':::');
        
        AggregateResult[] weeklySupplySummaryAggreList = Database.query(searchQuery);
        System.debug('weeklySupplySummaryAggreList::::'+weeklySupplySummaryAggreList);
        for (AggregateResult weeklySupplySummaryAgg : weeklySupplySummaryAggreList){            
            
            Weekly_Supply_Summary__c weeklySupplySummary = new Weekly_Supply_Summary__c();
            weeklySupplySummary.Id = String.valueOf(weeklySupplySummaryAgg.get('Id'));            
            String SupplyKey = new ProcessInventoryAllocation().getSupplyKeyV2(weeklySupplySummaryAgg);
            weeklySupplySummary.Quantity__c = Double.valueOf(weeklySupplySummaryAgg.get('Quantity'));
            weeklySupplyMap.put(SupplyKey,weeklySupplySummary);
        }  
        return weeklySupplyMap;
    }
    
    public  Map<string,Inventory_Allocation__c> getWeeklyAllocationForDemandForDisplay(String orderToCompany,String retailerCode,String modelName,Date weekStartDate,Date weekEndDate,boolean isCurrentWeek,Integer pageNumber ,Integer recordToDisplay,string allocationType){   
        
        if(isCurrentWeek){
            Date startdate = date.today();
            Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());            
            weekStartDate = todaydateinstance.toStartOfWeek();
            weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        }
        string searchQuery;
        if(isCurrentWeek){
        searchQuery = 'SELECT Id recordId,Inventory_Allocation_Demand__r.Order_to_Company__c OrderToCompany,Inventory_Allocation_Demand__r.Retailer_Code__c RetailerCode,Inventory_Allocation_Demand__r.Retailer_Code__r.Name RetailerName,Inventory_Allocation_Demand__r.Mainetti_Model__r.Name ModelName,Inventory_Allocation_Demand__r.Mainetti_Model__c Model,Inventory_Allocation_Demand__r.Color__c Color,Inventory_Allocation_Demand__r.Mainetti_Model__r.Sizer_Print__c Printer,Sum(Quantity__c) Quantity,AllocatedDate__c allocateddate,Inventory_Allocation_Type__c allocationType  FROM Inventory_Allocation__c';
        }
        else {
        searchQuery = 'SELECT Inventory_Allocation_Demand__r.Order_to_Company__c OrderToCompany,Inventory_Allocation_Demand__r.Retailer_Code__c RetailerCode,Inventory_Allocation_Demand__r.Retailer_Code__r.Name RetailerName,Inventory_Allocation_Demand__r.Mainetti_Model__r.Name ModelName,Inventory_Allocation_Demand__r.Mainetti_Model__c Model,Inventory_Allocation_Demand__r.Color__c Color,Inventory_Allocation_Demand__r.Mainetti_Model__r.Sizer_Print__c Printer,Sum(Quantity__c) Quantity, AllocatedDate__c allocateddate,Inventory_Allocation_Type__c allocationType  FROM Inventory_Allocation__c';  
        }
        if(String.isNotBlank(string.valueOf(weekStartDate)) || String.isNotBlank(string.valueOf(weekEndDate))||String.isNotBlank(orderToCompany)||String.isNotBlank(retailerCode)||String.isNotBlank(modelName)||String.isNotBlank(allocationType)){
            searchQuery += ' WHERE ';
        }         
        boolean dateFieldFrmPresent = false;
        boolean dateFieldToPresent = false;
        boolean orderToCompanyPresent = false;
        boolean retailerCodePresent = false;
        boolean modelNamePresent = false;
        boolean allocationTypePresent = false;
        if(String.isNotBlank(string.valueOf(weekStartDate)) || String.isNotBlank(string.valueOf(weekEndDate))){
            if(String.isNotBlank(string.valueOf(weekStartDate)) && String.isNotBlank(string.valueOf(weekEndDate))){
                searchQuery += ' Week_Start_Date__c >=:weekStartDate AND Week_End_Date__c <=:weekEndDate';       
                dateFieldFrmPresent = true; 
                dateFieldToPresent = true;
            }
            if(String.isNotBlank(string.valueOf(weekStartDate)) && String.isBlank(string.valueOf(weekEndDate))){
                searchQuery += ' Week_Start_Date__c >=:weekStartDate';
                dateFieldFrmPresent = true;
            }
            if(String.isBlank(string.valueOf(weekStartDate)) && String.isNotBlank(string.valueOf(weekEndDate))){
                searchQuery += ' Week_End_Date__c >=:weekEndDate';
                dateFieldToPresent = true;
            }            
        }
        if(String.isNotBlank(orderToCompany)){
            if(dateFieldFrmPresent==true || dateFieldToPresent==true){
                searchQuery += ' AND Inventory_Allocation_Demand__r.Order_to_Company__c=:orderToCompany';
            }else{
                searchQuery += ' Inventory_Allocation_Demand__r.Order_to_Company__c=:orderToCompany';
            }
            orderToCompanyPresent = true;
        }
        if(String.isNotBlank(retailerCode)){
            
            if(dateFieldFrmPresent==true || dateFieldToPresent==true || orderToCompanyPresent==true){
                searchQuery += ' AND Inventory_Allocation_Demand__r.Retailer_Code__r.Name =:retailerCode';
            }else{
                searchQuery += ' Inventory_Allocation_Demand__r.Retailer_Code__r.Name =:retailerCode';
            }
            retailerCodePresent = true;
        }
        if(String.isNotBlank(modelName)){
            if(dateFieldFrmPresent==true || dateFieldToPresent==true || orderToCompanyPresent==true || retailerCodePresent==true){
                searchQuery += ' AND Inventory_Allocation_Demand__r.Mainetti_Model__r.Name=:modelName';
            }else{
                searchQuery += ' Inventory_Allocation_Demand__r.Mainetti_Model__r.Name=:modelName';
            }
            modelNamePresent = true;
        }
        if(String.isNotBlank(allocationType)){
            if(dateFieldFrmPresent==true || dateFieldToPresent==true || orderToCompanyPresent==true || retailerCodePresent==true || modelNamePresent == true ){
                searchQuery += ' AND Inventory_Allocation_Type__c =:allocationType';
            }else{
                searchQuery += 'Inventory_Allocation_Type__c =:allocationType';
            }
        }
        if(isCurrentWeek){
            searchQuery += ' GROUP BY  Id,Inventory_Allocation_Demand__r.Order_to_Company__c,Inventory_Allocation_Demand__r.Retailer_Code__c,Inventory_Allocation_Demand__r.Retailer_Code__r.Name,Inventory_Allocation_Demand__r.Mainetti_Model__r.Name,Inventory_Allocation_Demand__r.Mainetti_Model__c,Inventory_Allocation_Demand__r.Color__c,Inventory_Allocation_Demand__r.Mainetti_Model__r.Sizer_Print__c,Inventory_Allocation_Demand__c,AllocatedDate__c,Inventory_Allocation_Type__c ';
        }else{
            searchQuery += ' GROUP BY  Inventory_Allocation_Demand__r.Order_to_Company__c,Inventory_Allocation_Demand__r.Retailer_Code__c,Inventory_Allocation_Demand__r.Retailer_Code__r.Name,Inventory_Allocation_Demand__r.Mainetti_Model__r.Name,Inventory_Allocation_Demand__r.Mainetti_Model__c,Inventory_Allocation_Demand__r.Color__c,Inventory_Allocation_Demand__r.Mainetti_Model__r.Sizer_Print__c,Inventory_Allocation_Demand__c,AllocatedDate__c,Inventory_Allocation_Type__c ';    
        }
        //searchQuery += ' order by CreatedDate';
        
        String searchQueryCount = searchQuery;
        Integer offSet = ((pageNumber - 1) * recordToDisplay);
        searchQuery += ' LIMIT :recordToDisplay OFFSET :offSet';
        
        Map<string,Inventory_Allocation__c> weeklyDemandMap = new Map<string,Inventory_Allocation__c>();
        Integer totalRecordCount = 0;
        //Getting the total count of records only the first time
        if(pageNumber ==1){
            AggregateResult[]  weeklyDemandSummaryCount = Database.query(searchQueryCount);
            totalRecordCount = weeklyDemandSummaryCount.size();
            Inventory_Allocation__c totalRec = new Inventory_Allocation__c();	
            totalRec.Week_Number__c	 = String.valueOf(totalRecordCount);            
            weeklyDemandMap.put('TotalCount',totalRec);            
        } 
        
        System.debug('searchQuery::'+searchQuery);
        
        AggregateResult[] weeklyDemandSummaryAggreList = Database.query(searchQuery);        
        for (AggregateResult weeklyDemandSummaryAgg : weeklyDemandSummaryAggreList){            
            
            Inventory_Allocation__c weeklyDemandSummary = new Inventory_Allocation__c();
            String demandKey = new ProcessInventoryAllocation().getDemandKey(weeklyDemandSummaryAgg);
            //System.debug('demandKey::::'+demandKey);
            if(isCurrentWeek){
                weeklyDemandSummary.Id = String.valueOf(weeklyDemandSummaryAgg.get('recordId'));
            }
            weeklyDemandSummary.Order_to_Company__c = String.valueOf(weeklyDemandSummaryAgg.get('OrderToCompany'));
            weeklyDemandSummary.Retailer_Name__c = String.valueOf(weeklyDemandSummaryAgg.get('RetailerName'));
            weeklyDemandSummary.Mainetti_Model_Name__c = String.valueOf(weeklyDemandSummaryAgg.get('ModelName'));
            weeklyDemandSummary.Color__c = String.valueOf(weeklyDemandSummaryAgg.get('Color'));
            weeklyDemandSummary.Sizer_Print__c = String.valueOf(weeklyDemandSummaryAgg.get('Printer'));
            //System.debug('allocateddate'+String.valueOf(weeklyDemandSummaryAgg.get('allocateddate')));
            weeklyDemandSummary.AllocatedDateText__c =String.valueOf(weeklyDemandSummaryAgg.get('allocateddate'));           
            weeklyDemandSummary.Inventory_Allocation_Type__c = String.valueOf(weeklyDemandSummaryAgg.get('allocationType'));
           // weeklyDemandSummary.Quantity__c = Double.valueOf(weeklyDemandSummaryAgg.get('Quantity'));
            weeklyDemandSummary.isCurrentWeek__c = isCurrentWeek;
            if(!weeklyDemandMap.containsKey(demandKey)){
                weeklyDemandSummary.Quantity__c = Double.valueOf(weeklyDemandSummaryAgg.get('Quantity'));
                weeklyDemandMap.put(demandKey,weeklyDemandSummary);
            }else{
                Inventory_Allocation__c  weeklyDemandSummaryNew = weeklyDemandMap.get(demandKey);
                Double oldQuantity = weeklyDemandSummaryNew.Quantity__c;
                Double newQuantity = Double.valueOf(weeklyDemandSummaryAgg.get('Quantity'));      
                weeklyDemandSummary.Quantity__c = (oldQuantity+newQuantity);                                
                weeklyDemandMap.put(demandKey,weeklyDemandSummary);                                 
            }
          }  
        system.debug('weeklyDemandMap Size:'+weeklyDemandMap.size());
        system.debug('weeklyDemandMap:'+weeklyDemandMap);
        return weeklyDemandMap;
    }
    
    public  Map<string,Inventory_Allocation__c> getWeeklyAllocationForSupplyForDisplay(String orderToCompany,String retailerCode,String modelName,Date weekStartDate,Date weekEndDate,boolean isCurrentWeek,Integer pageNumber ,Integer recordToDisplay,string allocationType){   
        
        if(allocationType.equalsIgnoreCase('All')){
            allocationType = '';
        }
        
        if(isCurrentWeek){
            Date startdate = date.today();
            Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
            
            weekStartDate = todaydateinstance.toStartOfWeek();
            weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        }
        string searchQuery;
        if(isCurrentWeek){
         searchQuery = 'SELECT Id recId,Inventory_Allocation_Supply__r.Mainetti_Company__c OrderToCompany,Inventory_Allocation_Supply__r.Retailer_Code__c RetailerCode,Inventory_Allocation_Supply__r.Retailer_Code__r.Name RetailerName,Inventory_Allocation_Supply__r.Mainetti_Model__r.Name ModelName,Inventory_Allocation_Supply__r.Mainetti_Model__c Model,Inventory_Allocation_Supply__r.Color__c Color,Inventory_Allocation_Supply__r.Mainetti_Model__r.Sizer_Print__c Printer,Inventory_Allocation_Supply__r.Warehouse__c wareHouse,Sum(Quantity__c) Quantity,AllocatedDate__c allocateddate,Inventory_Allocation_Type__c allocationType FROM Inventory_Allocation__c';
        }   
        else{
            searchQuery = 'SELECT Inventory_Allocation_Supply__r.Mainetti_Company__c OrderToCompany,Inventory_Allocation_Supply__r.Retailer_Code__c RetailerCode,Inventory_Allocation_Supply__r.Retailer_Code__r.Name RetailerName,Inventory_Allocation_Supply__r.Mainetti_Model__r.Name ModelName,Inventory_Allocation_Supply__r.Mainetti_Model__c Model,Inventory_Allocation_Supply__r.Color__c Color,Inventory_Allocation_Supply__r.Mainetti_Model__r.Sizer_Print__c Printer,Inventory_Allocation_Supply__r.Warehouse__c wareHouse,Sum(Quantity__c) Quantity,AllocatedDate__c allocateddate,Inventory_Allocation_Type__c allocationType FROM Inventory_Allocation__c';
        
        }
        if(String.isNotBlank(string.valueOf(weekStartDate)) || String.isNotBlank(string.valueOf(weekEndDate))||String.isNotBlank(orderToCompany)||String.isNotBlank(retailerCode)||String.isNotBlank(modelName)||String.isNotBlank(allocationType)){
            searchQuery += ' WHERE ';
        }         
        boolean dateFieldFrmPresent = false;
        boolean dateFieldToPresent = false;
        boolean orderToCompanyPresent = false;
        boolean retailerCodePresent = false;
        boolean modelNamePresent = false;
        
        if(String.isNotBlank(string.valueOf(weekStartDate)) || String.isNotBlank(string.valueOf(weekEndDate))){
            if(String.isNotBlank(string.valueOf(weekStartDate)) && String.isNotBlank(string.valueOf(weekEndDate))){
                searchQuery += ' Week_Start_Date__c >=:weekStartDate AND Week_End_Date__c <=:weekEndDate';       
                dateFieldFrmPresent = true; 
                dateFieldToPresent = true;
            }
            if(String.isNotBlank(string.valueOf(weekStartDate)) && String.isBlank(string.valueOf(weekEndDate))){
                searchQuery += ' Week_Start_Date__c >=:weekStartDate';
                dateFieldFrmPresent = true;
            }
            if(String.isBlank(string.valueOf(weekStartDate)) && String.isNotBlank(string.valueOf(weekEndDate))){
                searchQuery += ' Week_End_Date__c >=:weekEndDate';
                dateFieldToPresent = true;
            }            
        }
        if(String.isNotBlank(orderToCompany)){
            if(dateFieldFrmPresent==true || dateFieldToPresent==true){
                searchQuery += ' AND Inventory_Allocation_Supply__r.Mainetti_Company__c=:orderToCompany';
            }else{
                searchQuery += ' Inventory_Allocation_Supply__r.Mainetti_Company__c=:orderToCompany';
            }
            orderToCompanyPresent = true;
        }
        if(String.isNotBlank(retailerCode)){
            
            if(dateFieldFrmPresent==true || dateFieldToPresent==true || orderToCompanyPresent==true){
                searchQuery += ' AND Inventory_Allocation_Supply__r.Retailer_Code__r.Name=:retailerCode';
            }else{
                searchQuery += ' Inventory_Allocation_Supply__r.Retailer_Code__r.Name=:retailerCode';
            }
            retailerCodePresent = true;
        }
        if(String.isNotBlank(modelName)){
            if(dateFieldFrmPresent==true || dateFieldToPresent==true || orderToCompanyPresent==true || retailerCodePresent==true){
                searchQuery += ' AND Inventory_Allocation_Supply__r.Mainetti_Model__r.Name=:modelName';
            }else{
                searchQuery += ' Inventory_Allocation_Supply__r.Mainetti_Model__r.Name=:modelName';
            }
            modelNamePresent = true;
        }
        if(String.isNotBlank(allocationType)){
            if(dateFieldFrmPresent==true || dateFieldToPresent==true || orderToCompanyPresent==true || retailerCodePresent==true || modelNamePresent == true){
                searchQuery += ' AND Inventory_Allocation_Type__c=:allocationType';
            }else{
                searchQuery += 'Inventory_Allocation_Type__c=:allocationType';
            }
        }
        if(isCurrentWeek){
            searchQuery += ' GROUP BY  Id,Inventory_Allocation_Supply__r.Mainetti_Company__c,Inventory_Allocation_Supply__r.Retailer_Code__c,Inventory_Allocation_Supply__r.Retailer_Code__r.Name,Inventory_Allocation_Supply__r.Mainetti_Model__r.Name,Inventory_Allocation_Supply__r.Mainetti_Model__c,Inventory_Allocation_Supply__r.Color__c,Inventory_Allocation_Supply__r.Mainetti_Model__r.Sizer_Print__c,AllocatedDate__c,Inventory_Allocation_Supply__r.Warehouse__c,Inventory_Allocation_Supply__c, Inventory_Allocation_Type__c';
        }else{
            searchQuery += ' GROUP BY  Inventory_Allocation_Supply__r.Mainetti_Company__c,Inventory_Allocation_Supply__r.Retailer_Code__c,Inventory_Allocation_Supply__r.Retailer_Code__r.Name,Inventory_Allocation_Supply__r.Mainetti_Model__r.Name,Inventory_Allocation_Supply__r.Mainetti_Model__c,Inventory_Allocation_Supply__r.Color__c,Inventory_Allocation_Supply__r.Mainetti_Model__r.Sizer_Print__c,AllocatedDate__c,Inventory_Allocation_Supply__r.Warehouse__c,Inventory_Allocation_Supply__c, Inventory_Allocation_Type__c ';
        }
        //searchQuery += ' order by CreatedDate';
        
        String searchQueryCount = searchQuery;
        Integer offSet = ((pageNumber - 1) * recordToDisplay);
        searchQuery += ' LIMIT :recordToDisplay OFFSET :offSet';
        
        System.debug('offSet::::'+offSet+':::');
        System.debug('recordToDisplay::::'+recordToDisplay+':::');
        Map<string,Inventory_Allocation__c> weeklyDemandMap = new Map<string,Inventory_Allocation__c>();
        Integer totalRecordCount = 0;
        //Getting the total count of records only the first time 
        if(pageNumber ==1){
            AggregateResult[]  weeklySupplySummaryCount = Database.query(searchQueryCount);
            totalRecordCount = weeklySupplySummaryCount.size();
            Inventory_Allocation__c totalRec = new Inventory_Allocation__c();	
            totalRec.Week_Number__c	 = String.valueOf(totalRecordCount); 
            weeklyDemandMap.put('TotalCount',totalRec);            
        }
        System.debug('searchQuery::::'+searchQuery+':::');
        //System.debug('totalRecordCount::::'+totalRecordCount+':::');
        
        AggregateResult[] weeklySupplySummaryAggreList = Database.query(searchQuery);        
        for (AggregateResult weeklySupplySummaryAgg : weeklySupplySummaryAggreList){ 
            
            //system.debug('weeklySupplySummaryAgg.recId'+String.valueOf(weeklySupplySummaryAgg.get('recId')));
           
            Inventory_Allocation__c weeklyDemandSummary = new Inventory_Allocation__c();         
            String SupplyKey = new ProcessInventoryAllocation().getSupplyKey(weeklySupplySummaryAgg);
            System.debug('SupplyKey::::'+SupplyKey);
             if(isCurrentWeek){
            weeklyDemandSummary.Id = String.valueOf(weeklySupplySummaryAgg.get('recId'));
             }
            weeklyDemandSummary.Order_to_Company__c = String.valueOf(weeklySupplySummaryAgg.get('OrderToCompany'));
            weeklyDemandSummary.Retailer_Name__c = String.valueOf(weeklySupplySummaryAgg.get('RetailerName'));
            weeklyDemandSummary.Mainetti_Model_Name__c = String.valueOf(weeklySupplySummaryAgg.get('ModelName'));
            weeklyDemandSummary.Color__c = String.valueOf(weeklySupplySummaryAgg.get('Color'));
            weeklyDemandSummary.Sizer_Print__c = String.valueOf(weeklySupplySummaryAgg.get('Printer'));
            weeklyDemandSummary.AllocatedDateText__c =String.valueOf(weeklySupplySummaryAgg.get('allocateddate'));
            weeklyDemandSummary.Inventory_Allocation_Type__c =String.valueOf(weeklySupplySummaryAgg.get('allocationType'));
            //weeklyDemandSummary.Quantity__c = Double.valueOf(weeklySupplySummaryAgg.get('Quantity'));
            weeklyDemandSummary.isCurrentWeek__c = isCurrentWeek;
            
            if(!weeklyDemandMap.containsKey(SupplyKey)){
                //System.debug(' fetchInventoryAllocationSummary:::Inside NOT Present');                 
                //Weekly_Demand_Summary__c  weeklyDemandSummary = new Weekly_Demand_Summary__c();
                //weeklyDemandSummary.ID = String.valueOf(inventoryAllocation.get('invAllocDemandId')); 
                //system.debug('new Qty:'+Double.valueOf(weeklySupplySummaryAgg.get('Quantity')));
                weeklyDemandSummary.Quantity__c = Double.valueOf(weeklySupplySummaryAgg.get('Quantity'));
                weeklyDemandMap.put(SupplyKey,weeklyDemandSummary);
            }else{
                //System.debug(' fetchInventoryAllocationSummary:::Inside Present'); 
                //getting the updated quantity for the combination of the Key.
                Inventory_Allocation__c  weeklyDemandSummaryNew = weeklyDemandMap.get(SupplyKey);
                //System.debug(' fetchInventoryAllocationSummary:::BEFORE QUANTITY'); 
                Double oldQuantity = weeklyDemandSummaryNew.Quantity__c;
                Double newQuantity = Double.valueOf(weeklySupplySummaryAgg.get('Quantity'));      
                //System.debug(' fetchInventoryAllocationSummary:::AFTER QUANTITY');
                //System.debug(' oldQuantity:'+oldQuantity);
                //System.debug(' fetchInventoryAllocationSummary:::Inside Existing NEW Quantity'+(oldQuantity+newQuantity)); 
                weeklyDemandSummary.Quantity__c = (oldQuantity+newQuantity);                                
                weeklyDemandMap.put(SupplyKey,weeklyDemandSummary);                                 
            }
            
            
            
            //weeklyDemandMap.put(SupplyKey,weeklyDemandSummary);
        }  
        system.debug('weeklyDemandMap Size:'+weeklyDemandMap.size());
        system.debug('weeklyDemandMap:'+weeklyDemandMap);
        return weeklyDemandMap;
    }
    //Method used for displaying supply screen.
    Map<string,Weekly_Supply_Summary__c> getWeeklySupplySummaryDisplay(String orderToCompany,String retailerCode,String modelName,Date weekStartDate,Date weekEndDate,boolean isCurrentWeek,Integer pageNumber ,Integer recordToDisplay,Integer totalRecordCount,String source, String warehouse){  
        
        if(isCurrentWeek){
            Date startdate = date.today();
            Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
            weekStartDate = todaydateinstance.toStartOfWeek();
            weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        }
        string searchQuery;
        if(isCurrentWeek){
            searchQuery = 'SELECT Id, Mainetti_Company__c OrderToCompany, Retailer_Code__c RetailerCode, Retailer_Code__r.Name RetailerName,Mainetti_Model__c ModelCode,Mainetti_Model__r.Name ModelName,Color__c Color,Sizer_Print__c Printer,Warehouse__c wareHouse,Source__c source,Week_Start_Date__c weekStartDate,Week_End_Date__c weekEndDate,SUM(Quantity__c) Quantity FROM Weekly_Supply_Summary__c';
        }else{
            searchQuery = 'SELECT Mainetti_Company__c OrderToCompany, Retailer_Code__c RetailerCode, Retailer_Code__r.Name RetailerName,Mainetti_Model__c ModelCode,Mainetti_Model__r.Name ModelName,Color__c Color,Sizer_Print__c Printer,Warehouse__c wareHouse,Source__c source,Week_Start_Date__c weekStartDate,Week_End_Date__c weekEndDate,SUM(Quantity__c) Quantity FROM Weekly_Supply_Summary__c';
        }
        if(String.isNotBlank(string.valueOf(weekStartDate)) || String.isNotBlank(string.valueOf(weekEndDate))||String.isNotBlank(orderToCompany)||String.isNotBlank(retailerCode)||String.isNotBlank(modelName)||String.isNotBlank(warehouse)||String.isNotBlank(source)){
            searchQuery += ' WHERE ';
        }         
        boolean dateFieldFrmPresent = false;
        boolean dateFieldToPresent = false;
        boolean orderToCompanyPresent = false;
        boolean retailerCodePresent = false;
        boolean modelNamePresent = false;
        boolean warehousePresent = false;
        boolean sourcePresent = false;
        if(String.isNotBlank(string.valueOf(weekStartDate)) || String.isNotBlank(string.valueOf(weekEndDate))){
            if(String.isNotBlank(string.valueOf(weekStartDate)) && String.isNotBlank(string.valueOf(weekEndDate))){
                searchQuery += ' Week_Start_Date__c >=:weekStartDate AND Week_End_Date__c <=:weekEndDate';       
                dateFieldFrmPresent = true; 
                dateFieldToPresent = true;
            }
            if(String.isNotBlank(string.valueOf(weekStartDate)) && String.isBlank(string.valueOf(weekEndDate))){
                searchQuery += ' Week_Start_Date__c >=:weekStartDate';
                dateFieldFrmPresent = true;
            }
            if(String.isBlank(string.valueOf(weekStartDate)) && String.isNotBlank(string.valueOf(weekEndDate))){
                searchQuery += ' Week_End_Date__c >=:weekEndDate';
                dateFieldToPresent = true;
            }            
        }
        if(String.isNotBlank(orderToCompany)){
            if(dateFieldFrmPresent==true || dateFieldToPresent==true){
                searchQuery += ' AND Mainetti_Company__c=:orderToCompany';
            }else{
                searchQuery += ' Mainetti_Company__c=:orderToCompany';
            }
            orderToCompanyPresent = true;
        }
        if(String.isNotBlank(retailerCode)){
            
            if(dateFieldFrmPresent==true || dateFieldToPresent==true || orderToCompanyPresent==true){
                searchQuery += ' AND Retailer_Code__r.Name=:retailerCode';
            }else{
                searchQuery += ' Retailer_Code__r.Name=:retailerCode';
            }
            retailerCodePresent = true; 
        }
        if(String.isNotBlank(modelName)){
            if(dateFieldFrmPresent==true || dateFieldToPresent==true || orderToCompanyPresent==true || retailerCodePresent==true){
                searchQuery += ' AND Mainetti_Model__r.Name=:modelName';
            }else{
                searchQuery += ' Mainetti_Model__r.Name=:modelName';
            }
            modelNamePresent = true;
        }
        if(String.isNotBlank(warehouse)){
            if(dateFieldFrmPresent==true || dateFieldToPresent==true || orderToCompanyPresent==true || retailerCodePresent==true || modelNamePresent == true){
                searchQuery += ' AND Warehouse__c=:warehouse';
            }else{
                searchQuery += ' Warehouse__c=:warehouse';
            }
            warehousePresent = true;
        }
        if(String.isNotBlank(source)){
            if(dateFieldFrmPresent==true || dateFieldToPresent==true || orderToCompanyPresent==true || retailerCodePresent==true || modelNamePresent == true || warehousePresent == true){
                searchQuery += ' AND Source__c=:source';
            }else{
                searchQuery += ' Source__c=:source';
            }
        }
        
        if(isCurrentWeek){
            searchQuery += ' GROUP BY  Id,Mainetti_Company__c , Retailer_Code__c , Retailer_Code__r.Name ,Mainetti_Model__c ,Mainetti_Model__r.Name ,Color__c ,Sizer_Print__c,Warehouse__c,Source__c, Week_Start_Date__c,Week_End_Date__c';
        }else{
            searchQuery += ' GROUP BY Mainetti_Company__c , Retailer_Code__c , Retailer_Code__r.Name ,Mainetti_Model__c ,Mainetti_Model__r.Name ,Color__c ,Sizer_Print__c,Warehouse__c,Source__c, Week_Start_Date__c,Week_End_Date__c';
        }
        //searchQuery += ' order by CreatedDate';
        
        String searchQueryCount = searchQuery;
        Integer offSet = ((pageNumber - 1) * recordToDisplay);
        searchQuery += ' LIMIT :recordToDisplay OFFSET :offSet';
        
        //System.debug('searchQueryCount::::'+searchQueryCount+':::');
        Map<string,Weekly_Supply_Summary__c> weeklySupplyMap = new Map<string,Weekly_Supply_Summary__c>();
        //Getting the total count of records only the first time 
        if(pageNumber ==1){
            AggregateResult[]  weeklySupplySummaryCount = Database.query(searchQueryCount);
            totalRecordCount = weeklySupplySummaryCount.size();
            Weekly_Supply_Summary__c totalRec = new Weekly_Supply_Summary__c();	
            totalRec.Week_Number__c	 = String.valueOf(totalRecordCount);            
            weeklySupplyMap.put('TotalCount',totalRec);            
        }
        
        AggregateResult[] weeklySupplySummaryAggreList = Database.query(searchQuery);
        
        for (AggregateResult weeklySupplySummaryAgg : weeklySupplySummaryAggreList){            
            
            Weekly_Supply_Summary__c weeklySupplySummary = new Weekly_Supply_Summary__c();
            if(isCurrentWeek){
                weeklySupplySummary.Id = String.valueOf(weeklySupplySummaryAgg.get('Id'));
            }
            String supplyKey = new ProcessInventoryAllocation().getSupplyKeyV2(weeklySupplySummaryAgg);
            //System.debug('supplyKey::'+supplyKey);
            weeklySupplySummary.Mainetti_Company__c	 = String.valueOf(weeklySupplySummaryAgg.get('OrderToCompany'));
            weeklySupplySummary.Retailer_Name__c = String.valueOf(weeklySupplySummaryAgg.get('RetailerName'));
            weeklySupplySummary.Mainetti_Model_Name__c = String.valueOf(weeklySupplySummaryAgg.get('ModelName'));
            weeklySupplySummary.Color__c = String.valueOf(weeklySupplySummaryAgg.get('Color'));
            weeklySupplySummary.Sizer_Print__c = String.valueOf(weeklySupplySummaryAgg.get('Printer'));
            weeklySupplySummary.Warehouse__c = String.valueOf(weeklySupplySummaryAgg.get('wareHouse'));
            weeklySupplySummary.Source__c = String.valueOf(weeklySupplySummaryAgg.get('source'));
            weeklySupplySummary.Week_Start_Date__c = Date.valueOf(weeklySupplySummaryAgg.get('weekStartDate'));
            weeklySupplySummary.Week_End_Date__c = Date.valueOf(weeklySupplySummaryAgg.get('weekEndDate'));
            weeklySupplySummary.Quantity__c = Double.valueOf(weeklySupplySummaryAgg.get('Quantity'));
            //weeklySupplyMap.put(supplyKey,weeklySupplySummary);  
            
            if(!weeklySupplyMap.containsKey(supplyKey)){
                weeklySupplyMap.put(supplyKey,weeklySupplySummary);
            }else{
                Weekly_Supply_Summary__c weeklySupplySummaryTemp = new Weekly_Supply_Summary__c();
                weeklySupplySummaryTemp = weeklySupplyMap.get(supplyKey);
                weeklySupplySummary.Quantity__c = weeklySupplySummary.Quantity__c + weeklySupplySummaryTemp.Quantity__c;
                weeklySupplyMap.put(supplyKey,weeklySupplySummary);
            }
        }          
        return weeklySupplyMap;
    }
    
    //Fetching all the supply details
    //Method used for displaying supply screen.
    public Map<string,Weekly_Supply_Summary__c> fetchWeeklySupplySummaryDisplay(String orderToCompany,String retailerCode,String modelName,Date weekStartDate,Date weekEndDate,boolean isCurrentWeek,Integer pageNumber ,Integer recordToDisplay,String source, String warehouse){
        
        Map<string,Weekly_Supply_Summary__c> weeklySupplySummaryMap = new Map<string,Weekly_Supply_Summary__c>();
        Integer totalRecordCount = 0;
        
        if(source.equalsIgnoreCase('all')){
            weeklySupplySummaryMap = getWeeklySupplySummaryDisplayAllSource(orderToCompany,retailerCode,modelName,weekStartDate,weekEndDate, isCurrentWeek,pageNumber,recordToDisplay,totalRecordCount,source,warehouse);
        }else{
            weeklySupplySummaryMap = getWeeklySupplySummaryDisplay(orderToCompany,retailerCode,modelName,weekStartDate,weekEndDate, isCurrentWeek,pageNumber,recordToDisplay,totalRecordCount,source,warehouse);
        }       
        return weeklySupplySummaryMap;
    }
    
    //Method used for displaying supply screen.
    Map<string,Weekly_Supply_Summary__c> getWeeklySupplySummaryDisplayAllSource(String orderToCompany,String retailerCode,String modelName,Date weekStartDate,Date weekEndDate,boolean isCurrentWeek,Integer pageNumber ,Integer recordToDisplay,Integer totalRecordCount,String source, String warehouse){  
        
        if(isCurrentWeek){
            Date startdate = date.today();
            Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
            weekStartDate = todaydateinstance.toStartOfWeek();
            weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        }
        string searchQuery;
        if(isCurrentWeek){
            searchQuery = 'SELECT Id, Mainetti_Company__c OrderToCompany, Retailer_Code__c RetailerCode, Retailer_Code__r.Name RetailerName,Mainetti_Model__c ModelCode,Mainetti_Model__r.Name ModelName,Color__c Color,Sizer_Print__c Printer,Warehouse__c wareHouse,Source__c source,Week_Start_Date__c weekStartDate,Week_End_Date__c weekEndDate,SUM(Quantity__c) Quantity FROM Weekly_Supply_Summary__c';
        }else{
            searchQuery = 'SELECT Mainetti_Company__c OrderToCompany, Retailer_Code__c RetailerCode, Retailer_Code__r.Name RetailerName,Mainetti_Model__c ModelCode,Mainetti_Model__r.Name ModelName,Color__c Color,Sizer_Print__c Printer,Warehouse__c wareHouse,Source__c source,Week_Start_Date__c weekStartDate,Week_End_Date__c weekEndDate,SUM(Quantity__c) Quantity FROM Weekly_Supply_Summary__c';
        }
        if(String.isNotBlank(string.valueOf(weekStartDate)) || String.isNotBlank(string.valueOf(weekEndDate))||String.isNotBlank(orderToCompany)||String.isNotBlank(retailerCode)||String.isNotBlank(modelName)||String.isNotBlank(warehouse)){
            searchQuery += ' WHERE ';
        }         
        boolean dateFieldFrmPresent = false;
        boolean dateFieldToPresent = false;
        boolean orderToCompanyPresent = false;
        boolean retailerCodePresent = false;
        boolean modelNamePresent = false;
        boolean warehousePresent = false;
        boolean sourcePresent = false;
        if(String.isNotBlank(string.valueOf(weekStartDate)) || String.isNotBlank(string.valueOf(weekEndDate))){
            if(String.isNotBlank(string.valueOf(weekStartDate)) && String.isNotBlank(string.valueOf(weekEndDate))){
                searchQuery += ' Week_Start_Date__c >=:weekStartDate AND Week_End_Date__c <=:weekEndDate';       
                dateFieldFrmPresent = true; 
                dateFieldToPresent = true;
            }
            if(String.isNotBlank(string.valueOf(weekStartDate)) && String.isBlank(string.valueOf(weekEndDate))){
                searchQuery += ' Week_Start_Date__c >=:weekStartDate';
                dateFieldFrmPresent = true;
            }
            if(String.isBlank(string.valueOf(weekStartDate)) && String.isNotBlank(string.valueOf(weekEndDate))){
                searchQuery += ' Week_End_Date__c >=:weekEndDate';
                dateFieldToPresent = true;
            }            
        }
        if(String.isNotBlank(orderToCompany)){
            if(dateFieldFrmPresent==true || dateFieldToPresent==true){
                searchQuery += ' AND Mainetti_Company__c=:orderToCompany';
            }else{
                searchQuery += ' Mainetti_Company__c=:orderToCompany';
            }
            orderToCompanyPresent = true;
        }
        if(String.isNotBlank(retailerCode)){
            
            if(dateFieldFrmPresent==true || dateFieldToPresent==true || orderToCompanyPresent==true){
                searchQuery += ' AND Retailer_Code__r.Name=:retailerCode';
            }else{
                searchQuery += ' Retailer_Code__r.Name=:retailerCode';
            }
            retailerCodePresent = true; 
        }
        if(String.isNotBlank(modelName)){
            if(dateFieldFrmPresent==true || dateFieldToPresent==true || orderToCompanyPresent==true || retailerCodePresent==true){
                searchQuery += ' AND Mainetti_Model__r.Name=:modelName';
            }else{
                searchQuery += ' Mainetti_Model__r.Name=:modelName';
            }
            modelNamePresent = true;
        }
        if(String.isNotBlank(warehouse)){
            if(dateFieldFrmPresent==true || dateFieldToPresent==true || orderToCompanyPresent==true || retailerCodePresent==true || modelNamePresent == true){
                searchQuery += ' AND Warehouse__c=:warehouse';
            }else{
                searchQuery += ' Warehouse__c=:warehouse';
            }
            warehousePresent = true;
        }        
        
        if(isCurrentWeek){
            searchQuery += ' GROUP BY  Id,Mainetti_Company__c , Retailer_Code__c , Retailer_Code__r.Name ,Mainetti_Model__c ,Mainetti_Model__r.Name ,Color__c ,Sizer_Print__c,Warehouse__c,Source__c, Week_Start_Date__c,Week_End_Date__c';
        }else{
            searchQuery += ' GROUP BY Mainetti_Company__c , Retailer_Code__c , Retailer_Code__r.Name ,Mainetti_Model__c ,Mainetti_Model__r.Name ,Color__c ,Sizer_Print__c,Warehouse__c,Source__c, Week_Start_Date__c,Week_End_Date__c';
        }
        //searchQuery += ' order by CreatedDate';
        
        String searchQueryCount = searchQuery;
        Integer offSet = ((pageNumber - 1) * recordToDisplay);
        searchQuery += ' LIMIT :recordToDisplay OFFSET :offSet';
        //system.debug('pageNumber:'+pageNumber);
        //system.debug('recordToDisplay:'+recordToDisplay);
        //system.debug('offSet:'+offSet);
        //system.debug('searchQuery:'+searchQuery);
        
        Map<string,Weekly_Supply_Summary__c> weeklySupplyMap = new Map<string,Weekly_Supply_Summary__c>();
        //Getting the total count of records only the first time 
        if(pageNumber ==1){
            AggregateResult[]  weeklySupplySummaryCount = Database.query(searchQueryCount);
            totalRecordCount = weeklySupplySummaryCount.size();
            Weekly_Supply_Summary__c totalRec = new Weekly_Supply_Summary__c();	
            totalRec.Week_Number__c	 = String.valueOf(totalRecordCount);            
            weeklySupplyMap.put('TotalCount',totalRec);            
        }
        
        
        AggregateResult[] weeklySupplySummaryAggreList = Database.query(searchQuery);
        //system.debug('Record size:'+weeklySupplySummaryAggreList.size());
        //system.debug('weeklySupplySummaryAggreList:'+weeklySupplySummaryAggreList);
        
        for (AggregateResult weeklySupplySummaryAgg : weeklySupplySummaryAggreList){            
            
            Weekly_Supply_Summary__c weeklySupplySummary = new Weekly_Supply_Summary__c();
            if(isCurrentWeek){
                weeklySupplySummary.Id = String.valueOf(weeklySupplySummaryAgg.get('Id'));
            }
            String supplyKey = getSupplyKeyForsearchV2(weeklySupplySummaryAgg); //Changed by varun on 08-05-2020
            System.debug('supplyKey::'+supplyKey);
            weeklySupplySummary.Mainetti_Company__c	 = String.valueOf(weeklySupplySummaryAgg.get('OrderToCompany'));
            weeklySupplySummary.Retailer_Name__c = String.valueOf(weeklySupplySummaryAgg.get('RetailerName'));
            weeklySupplySummary.Mainetti_Model_Name__c = String.valueOf(weeklySupplySummaryAgg.get('ModelName'));
            weeklySupplySummary.Color__c = String.valueOf(weeklySupplySummaryAgg.get('Color'));
            weeklySupplySummary.Sizer_Print__c = String.valueOf(weeklySupplySummaryAgg.get('Printer'));
            weeklySupplySummary.Warehouse__c = String.valueOf(weeklySupplySummaryAgg.get('wareHouse'));
            weeklySupplySummary.Source__c = String.valueOf(weeklySupplySummaryAgg.get('source'));
            weeklySupplySummary.Week_Start_Date__c = Date.valueOf(weeklySupplySummaryAgg.get('weekStartDate'));
            weeklySupplySummary.Week_End_Date__c = Date.valueOf(weeklySupplySummaryAgg.get('weekEndDate'));
            weeklySupplySummary.Quantity__c = Double.valueOf(weeklySupplySummaryAgg.get('Quantity'));
            //weeklySupplyMap.put(supplyKey,weeklySupplySummary);
            
            if(!weeklySupplyMap.containsKey(supplyKey)){
                weeklySupplyMap.put(supplyKey,weeklySupplySummary);
            }else{
                Weekly_Supply_Summary__c weeklySupplySummaryTemp = new Weekly_Supply_Summary__c();
                weeklySupplySummaryTemp = weeklySupplyMap.get(supplyKey);
                weeklySupplySummary.Quantity__c = weeklySupplySummary.Quantity__c + weeklySupplySummaryTemp.Quantity__c;
                weeklySupplyMap.put(supplyKey,weeklySupplySummary);
            }
           
        }  
       //System.debug('weeklySupplyMap:'+weeklySupplyMap.size());        
        return weeklySupplyMap;
    }
    public String getSupplyKeyForsearch(AggregateResult supplyOrderDetail){
        String supplyKey =  String.valueOf(supplyOrderDetail.get('OrderToCompany'))+'#'+String.valueOf(supplyOrderDetail.get('RetailerName'))+'#'+String.valueOf(supplyOrderDetail.get('ModelName'))+'#'+String.valueOf(supplyOrderDetail.get('Color'))+'#'+String.valueOf(supplyOrderDetail.get('Printer'))+'#'+String.valueOf(supplyOrderDetail.get('source'));
        return supplyKey;  
    }
    public String getSupplyKeyForsearchV2(AggregateResult supplyOrderDetail){ //Changed by varun on 08-05-2020
        String supplyKey =  String.valueOf(supplyOrderDetail.get('OrderToCompany'))+'#'+String.valueOf(supplyOrderDetail.get('RetailerName'))+'#'+String.valueOf(supplyOrderDetail.get('ModelName'))+'#'+String.valueOf(supplyOrderDetail.get('Color'))+'#'+String.valueOf(supplyOrderDetail.get('Printer'))+'#'+String.valueOf(supplyOrderDetail.get('source'))+'#'+String.valueOf(supplyOrderDetail.get('wareHouse'));
        return supplyKey;  
    }
    
    Map<string,Weekly_Shipment_Summary__c> getWeeklyShipmentSummaryDisplay(String orderToCompany,String retailerCode,String modelName,Date weekStartDate,Date weekEndDate,boolean isCurrentWeek,Integer pageNumber ,Integer recordToDisplay,Integer totalRecordCount){  
        
        if(isCurrentWeek){
            Date startdate = date.today();
            Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
            
            weekStartDate = todaydateinstance.toStartOfWeek();
            weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        }
        string searchQuery;
        if(isCurrentWeek){
            searchQuery = 'SELECT Id, Mainetti_Company__c OrderToCompany, Retailer_Code__c RetailerCode, Retailer_Code__r.Name RetailerName,Mainetti_Model__c ModelCode,Mainetti_Model__r.Name ModelName,Color__c Color,Sizer_Print__c Printer,Week_Start_Date__c weekStartDate,Week_End_Date__c weekEndDate,SUM(Quantity__c) Quantity FROM Weekly_Shipment_Summary__c';
        }else{
            searchQuery = 'SELECT Mainetti_Company__c OrderToCompany, Retailer_Code__c RetailerCode, Retailer_Code__r.Name RetailerName,Mainetti_Model__c ModelCode,Mainetti_Model__r.Name ModelName,Color__c Color,Sizer_Print__c Printer,Week_Start_Date__c weekStartDate,Week_End_Date__c weekEndDate,SUM(Quantity__c) Quantity FROM Weekly_Shipment_Summary__c';
        }
        if(String.isNotBlank(string.valueOf(weekStartDate)) || String.isNotBlank(string.valueOf(weekEndDate))||String.isNotBlank(orderToCompany)||String.isNotBlank(retailerCode)||String.isNotBlank(modelName)){
            searchQuery += ' WHERE ';
        }         
        boolean dateFieldFrmPresent = false;
        boolean dateFieldToPresent = false;
        boolean orderToCompanyPresent = false;
        boolean retailerCodePresent = false;
        boolean modelNamePresent = false;
        if(String.isNotBlank(string.valueOf(weekStartDate)) || String.isNotBlank(string.valueOf(weekEndDate))){
            if(String.isNotBlank(string.valueOf(weekStartDate)) && String.isNotBlank(string.valueOf(weekEndDate))){
                searchQuery += ' Week_Start_Date__c >=:weekStartDate AND Week_End_Date__c <=:weekEndDate';       
                dateFieldFrmPresent = true; 
                dateFieldToPresent = true;
            }
            if(String.isNotBlank(string.valueOf(weekStartDate)) && String.isBlank(string.valueOf(weekEndDate))){
                searchQuery += ' Week_Start_Date__c >=:weekStartDate';
                dateFieldFrmPresent = true;
            }
            if(String.isBlank(string.valueOf(weekStartDate)) && String.isNotBlank(string.valueOf(weekEndDate))){
                searchQuery += ' Week_End_Date__c >=:weekEndDate';
                dateFieldToPresent = true;
            }            
        }
        if(String.isNotBlank(orderToCompany)){
            if(dateFieldFrmPresent==true || dateFieldToPresent==true){
                searchQuery += ' AND Mainetti_Company__c=:orderToCompany';
            }else{
                searchQuery += ' Mainetti_Company__c=:orderToCompany';
            }
            orderToCompanyPresent = true;
        }
        if(String.isNotBlank(retailerCode)){
            
            if(dateFieldFrmPresent==true || dateFieldToPresent==true || orderToCompanyPresent==true){
                searchQuery += ' AND Retailer_Code__r.Name=:retailerCode';
            }else{
                searchQuery += ' Retailer_Code__r.Name=:retailerCode';
            }
            retailerCodePresent = true;
        }
        if(String.isNotBlank(modelName)){
            if(dateFieldFrmPresent==true || dateFieldToPresent==true || orderToCompanyPresent==true || retailerCodePresent==true){
                searchQuery += ' AND Mainetti_Model__r.Name=:modelName';
            }else{
                searchQuery += ' Mainetti_Model__r.Name=:modelName';
            }
        }
        if(isCurrentWeek){
            searchQuery += ' GROUP BY  Id,Mainetti_Company__c , Retailer_Code__c , Retailer_Code__r.Name ,Mainetti_Model__c ,Mainetti_Model__r.Name ,Color__c ,Sizer_Print__c, Week_Start_Date__c,Week_End_Date__c';
        }else{
            searchQuery += ' GROUP BY Mainetti_Company__c , Retailer_Code__c , Retailer_Code__r.Name ,Mainetti_Model__c ,Mainetti_Model__r.Name ,Color__c ,Sizer_Print__c, Week_Start_Date__c,Week_End_Date__c';
        }
        String searchQueryCount = searchQuery;
        Integer offSet = ((pageNumber - 1) * recordToDisplay);
        searchQuery += ' LIMIT :recordToDisplay OFFSET :offSet';
        
        Map<string,Weekly_Shipment_Summary__c> weeklyShipmentMap = new Map<string,Weekly_Shipment_Summary__c>(); 
        //Getting the total count of records only the first time 
        if(pageNumber ==1){
            AggregateResult[]  weeklyShipmentSummaryCount = Database.query(searchQueryCount);
            totalRecordCount = weeklyShipmentSummaryCount.size();
            Weekly_Shipment_Summary__c totalRec = new Weekly_Shipment_Summary__c();	
            totalRec.Week_Number__c	 = String.valueOf(totalRecordCount);            
            weeklyShipmentMap.put('TotalCount',totalRec);            
        }
        //System.debug('searchQuery::::'+searchQuery+':::');
        //System.debug('totalRecordCount::::'+totalRecordCount+':::');
        
        AggregateResult[] weeklyShipmentSummaryAggreList = Database.query(searchQuery);
        for (AggregateResult weeklyShipmentSummaryAgg : weeklyShipmentSummaryAggreList){            
            
            Weekly_Shipment_Summary__c weeklyShipmentSummary = new Weekly_Shipment_Summary__c();
            if(isCurrentWeek){
                weeklyShipmentSummary.Id = String.valueOf(weeklyShipmentSummaryAgg.get('Id'));
            }
            String shipmentKey = new ProcessInventoryAllocation().getShipmentKey(weeklyShipmentSummaryAgg);
            weeklyShipmentSummary.Mainetti_Company__c	 = String.valueOf(weeklyShipmentSummaryAgg.get('OrderToCompany'));
            weeklyShipmentSummary.Retailer_Name__c = String.valueOf(weeklyShipmentSummaryAgg.get('RetailerName'));
            weeklyShipmentSummary.Mainetti_Model_Name__c = String.valueOf(weeklyShipmentSummaryAgg.get('ModelName'));
            weeklyShipmentSummary.Color__c = String.valueOf(weeklyShipmentSummaryAgg.get('Color'));
            weeklyShipmentSummary.Sizer_Print__c = String.valueOf(weeklyShipmentSummaryAgg.get('Printer'));            
            weeklyShipmentSummary.Week_Start_Date__c = Date.valueOf(weeklyShipmentSummaryAgg.get('weekStartDate'));
            weeklyShipmentSummary.Week_End_Date__c = Date.valueOf(weeklyShipmentSummaryAgg.get('weekEndDate'));
            weeklyShipmentSummary.Quantity__c = Double.valueOf(weeklyShipmentSummaryAgg.get('Quantity'));
            
            weeklyShipmentMap.put(shipmentKey,weeklyShipmentSummary);            
        }          
        return weeklyShipmentMap;
    }
    
    //Fetching all the supply details
    public Map<string,Weekly_Shipment_Summary__c> fetchWeeklyShipmentSummaryDisplay(String orderToCompany,String retailerCode,String modelName,Date weekStartDate,Date weekEndDate,boolean isCurrentWeek,Integer pageNumber ,Integer recordToDisplay){
        //system.debug('orderToCompanyAll1:'+orderToCompany);
        Integer totalRecordCount = 0;
        Map<string,Weekly_Shipment_Summary__c> weeklyShipmentMap = getWeeklyShipmentSummaryDisplay(orderToCompany, retailerCode, modelName,weekStartDate,weekEndDate,isCurrentWeek,pageNumber,recordToDisplay,totalRecordCount);   
        
        return weeklyShipmentMap;
    } 
    
}