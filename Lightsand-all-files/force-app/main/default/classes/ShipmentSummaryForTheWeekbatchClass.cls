global class ShipmentSummaryForTheWeekbatchClass implements Database.Batchable<sObject>{
    global List<AggregateResult> onlineDetailsShipmentList {get; set;} 
    global List<AggregateResult> magNETShipmentDetailsList {get; set;} 
    global List<AggregateResult> onlineDetailItemList {get; set;} 
    global List<AggregateResult> salesOrderItemList {get; set;} 
    global Iterable<SObject> fetchWeeklySupplySummaryForTheWeek {get; set;}     
    
    global ShipmentSummaryForTheWeekbatchClass(List<AggregateResult> onlineDetailsShipmentList,List<AggregateResult> magNETShipmentDetailsList,List<AggregateResult> onlineDetailItemList,List<AggregateResult> salesOrderItemList){ 
        this.onlineDetailsShipmentList = onlineDetailsShipmentList; 
        this.magNETShipmentDetailsList = magNETShipmentDetailsList;
        this.onlineDetailItemList = onlineDetailItemList;
        this.salesOrderItemList = salesOrderItemList;
        
    } 
    global Iterable<Sobject> start(Database.batchableContext bc) {
        System.debug('############# INSIDE START METHOD OF SHIPMENT ################');
        //MAP<ID,ID> onLineEnquiry = fetchEnquiryNumberForOnlineEnquiryShimpment(onLineEnquiry);
        
        return (Iterable<SObject>) new ShipmentSummaryForTheWeekIterable();       
    }    
    global void execute(Database.BatchableContext BC, List<Sobject> scope) {
        System.debug('############# INSIDE EXECUTE METHOD OF SHIPMENT ################');
        List<Partner__c> partnerList = new List<Partner__c> ();
        System.debug('DemandSummaryForTheWeekbatchClass Execute execute::: ');
        
        //Putting the object data to approporiate object
        for(SObject demand : scope)
        { 
            switch on demand {
                when Partner__c partner {		 
                    partnerList.add(partner);
                }                  
            }
        }
        
        ////////////////// Start Processing //////////////////
        System.debug('Start Method upsertAllSupplySummaryFortheWeek'); 
        Date startdate = date.today();
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        System.debug(':::weekStartDate:::'+weekStartDate+':::weekEndDate:::'+weekEndDate);        
        ////////////////// START PORTAL SHIPMENT //////////////////
        System.debug('upsertAllShipmentSummaryFortheWeek::START PORTAL SHIPMENT::'); 
        
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        //Fetching the salesorders mapping Weekly Demand Ids.
        MAP<ID,ID> onlineItemNoDemandIdsMapping = fetchOnlineDetailLineItemShipmentDoneInTheWeek(onlineDetailItemList);
        //Fetching all the Existing Shipment details for MagNET for the week
        
        Map<ID,Weekly_Shipment_Summary__c> existingShipmentSummaryOfShipmentPortal = fetchWeeklyShipmentSummaryForTheWeekPortal( weekStartDate, weekEndDate,onlineDetailItemList);
        
        for (AggregateResult onlineDetailShipDetail : onlineDetailsShipmentList){
            String shipmentKey = getShipmentKey(onlineDetailShipDetail);
            System.debug('upsertAllShipmentSummaryFortheWeek::PORTAL::shipmentKey ::'+shipmentKey+'::::');
            ID WeeklyDemandSummaryID = onlineItemNoDemandIdsMapping.get(String.valueOf(onlineDetailShipDetail.get('onlineDetailId')));
            System.debug('upsertAllShipmentSummaryFortheWeek::PORTAL::WeeklyDemandSummaryID ::'+WeeklyDemandSummaryID+'::::');
            //If the shipment record does not exits then create a new record.
            if(!existingShipmentSummaryOfShipmentPortal.containsKey(WeeklyDemandSummaryID)){
                System.debug('upsertAllShipmentSummaryFortheWeek::PORTAL::INSIDE NOT PRESENT ::');                 
                Weekly_Shipment_Summary__c  weeklyShipmentSummary = new Weekly_Shipment_Summary__c();
                weeklyShipmentSummary.Weekly_Demand_Summary__c = WeeklyDemandSummaryID;
                //System.debug('portal ORDER TO COMPANY'+String.valueOf(onlineDetailShipDetail.get('OrderToCompany')));
                weeklyShipmentSummary.Mainetti_Company__c = String.valueOf(onlineDetailShipDetail.get('OrderToCompany'));
                weeklyShipmentSummary.Retailer_Code__c = String.valueOf(onlineDetailShipDetail.get('RetailerCode'));
                //System.debug('PORTAL MODEL'+String.valueOf(onlineDetailShipDetail.get('Model')));
                weeklyShipmentSummary.Mainetti_Model__c = String.valueOf(onlineDetailShipDetail.get('Model'));                
                weeklyShipmentSummary.Color__c = String.valueOf(onlineDetailShipDetail.get('Color'));
                weeklyShipmentSummary.Sizer_Print__c = String.valueOf(onlineDetailShipDetail.get('Printer'));
                weeklyShipmentSummary.Week_Start_Date__c = weekStartDate;
                weeklyShipmentSummary.Week_End_Date__c = weekEndDate;
                //weeklyShipmentSummary.Week_Number__c = weekNumber;
                System.debug('upsertAllShipmentSummaryFortheWeek::PORTAL::QUANTITY ::'); 
                weeklyShipmentSummary.Quantity__c = Double.valueOf(onlineDetailShipDetail.get('Quantity'));
                existingShipmentSummaryOfShipmentPortal.put(WeeklyDemandSummaryID,weeklyShipmentSummary);                 
            }else{
                System.debug('upsertAllShipmentSummaryFortheWeek::PORTAL::INSIDE PRESENT ::');                 
                //getting the updated quantity for the combination of the Key.
                 
                Weekly_Shipment_Summary__c  weeklyShipmentSummary = existingShipmentSummaryOfShipmentPortal.get(WeeklyDemandSummaryID);                
                Double oldQuantity = weeklyShipmentSummary.Quantity__c;
                if(oldQuantity == null)
                    oldQuantity = 0;               
                Double newQuantity = Double.valueOf(onlineDetailShipDetail.get('Quantity'));  
                if(newQuantity == null)
                    newQuantity = 0;                
                System.debug('upsertAllShipmentSummaryFortheWeek::PORTAL::(oldQuantity+newQuantity) ::'+(oldQuantity+newQuantity));     
                weeklyShipmentSummary.Quantity__c = (oldQuantity+newQuantity);                              
                existingShipmentSummaryOfShipmentPortal.put(WeeklyDemandSummaryID,weeklyShipmentSummary);                
            }
        }     
        //Fetch the Old Portal Shipment Details
        List<Weekly_Shipment_Summary__c> weeklyShipmentSummaryList = new List<Weekly_Shipment_Summary__c>();
        for(string shipmentKey : existingShipmentSummaryOfShipmentPortal.keySet()){            
            Weekly_Shipment_Summary__c  weeklyShipmentSummary = existingShipmentSummaryOfShipmentPortal.get(shipmentKey);
            weeklyShipmentSummaryList.add(weeklyShipmentSummary);
        }
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        System.debug('upsertAllShipmentSummaryFortheWeek::END PORTAL SHIPMENT::SIZE:::'+weeklyShipmentSummaryList.size()); 
        ////////////////// END PORTAL SHIPMENT //////////////////
        
        ////////////////// START MagNET SHIPMENT //////////////////
        System.debug('upsertAllShipmentSummaryFortheWeek::START MagNET SHIPMENT::'); 
        //Fetch the New Portal Order Details from MagNET
        AggregateResult[] magNETShipmentDetailSummary = magNETShipmentDetailsList;
        
        //Fetching the salesorders mapping Weekly Demand Ids.
        MAP<ID,ID> salesOrderItemNoDemandIdsMapping = fetchSalesOrderItemNumbersForShipmentDoneInTheWeek(salesOrderItemList);
        //Fetching all the Existing Shipment details for MagNET for the week
        
        Map<ID,Weekly_Shipment_Summary__c> existingShipmentSummaryOfShipment = fetchWeeklyShipmentSummaryForTheWeekMagNET( weekStartDate, weekEndDate,salesOrderItemList);
        
        for (AggregateResult magNETShipDetail : magNETShipmentDetailSummary){
            String shipmentKey = getShipmentKey(magNETShipDetail);
            
            ID WeeklyDemandSummaryID = salesOrderItemNoDemandIdsMapping.get(String.valueOf(magNETShipDetail.get('SalesOrderItemNumber')));
            
            //If the shipment record does not exits then create a new record.
            if(!existingShipmentSummaryOfShipment.containsKey(WeeklyDemandSummaryID)){
                System.debug('upsertAllShipmentSummaryFortheWeek::MagNET::INSIDE NOT PRESENT ::'); 
                
                Weekly_Shipment_Summary__c  weeklyShipmentSummary = new Weekly_Shipment_Summary__c();
                weeklyShipmentSummary.Weekly_Demand_Summary__c = WeeklyDemandSummaryID;
                System.debug('MAGENET ORDER TO COMPANY'+String.valueOf(magNETShipDetail.get('OrderToCompany')));
                weeklyShipmentSummary.Mainetti_Company__c = String.valueOf(magNETShipDetail.get('OrderToCompany'));
                weeklyShipmentSummary.Retailer_Code__c = String.valueOf(magNETShipDetail.get('RetailerCode'));
                weeklyShipmentSummary.Mainetti_Model__c = String.valueOf(magNETShipDetail.get('Model'));
                System.debug('MAGENET COLOR'+String.valueOf(magNETShipDetail.get('Color')));
                weeklyShipmentSummary.Color__c = String.valueOf(magNETShipDetail.get('Color'));
                weeklyShipmentSummary.Sizer_Print__c = String.valueOf(magNETShipDetail.get('Printer'));
                weeklyShipmentSummary.Week_Start_Date__c = weekStartDate;
                weeklyShipmentSummary.Week_End_Date__c = weekEndDate;
                //weeklyShipmentSummary.Week_Number__c = weekNumber;
                weeklyShipmentSummary.Quantity__c = Double.valueOf(magNETShipDetail.get('Quantity'));
                existingShipmentSummaryOfShipment.put(WeeklyDemandSummaryID,weeklyShipmentSummary);                
            }else{
                System.debug('upsertAllShipmentSummaryFortheWeek::MagNET::INSIDE PRESENT ::');                 
                //getting the updated quantity for the combination of the Key.
                Weekly_Shipment_Summary__c  weeklyShipmentSummary = existingShipmentSummaryOfShipment.get(WeeklyDemandSummaryID);
                Double oldQuantity = weeklyShipmentSummary.Quantity__c;
                Double newQuantity = Double.valueOf(magNETShipDetail.get('Quantity'));                
                weeklyShipmentSummary.Quantity__c = (oldQuantity+newQuantity);                              
                existingShipmentSummaryOfShipment.put(WeeklyDemandSummaryID,weeklyShipmentSummary);                
            }
        }     
        
        for(string shipmentKey : existingShipmentSummaryOfShipment.keySet()){            
            Weekly_Shipment_Summary__c  weeklyShipmentSummary = existingShipmentSummaryOfShipment.get(shipmentKey);
            weeklyShipmentSummaryList.add(weeklyShipmentSummary);
        }
        System.debug('upsertAllShipmentSummaryFortheWeek::END MagNET SHIPMENT ::');  
        ////////////////// END MagNET SHIPMENT //////////////////
        try{
            //upsert weeklyShipmentSummaryList;
            splitShipmentListForUpsert(weeklyShipmentSummaryList);
        }catch(DMLException e){
            System.debug('Exception during Upsert of Weekly Shipment Summary '+e.getMessage());             
        }                   
        System.debug('End Method upsertAllShipmentSummaryFortheWeek::'); 
        
        
        //////////////////////// End of Processing /////////////////////////        
        
    }
    global void finish(Database.BatchableContext BC){
        System.debug('############# INSIDE FINISH METHOD OF SHIPMENT ################');
    }
    public void splitShipmentListForUpsert(List<Weekly_Shipment_Summary__c> weeklyShipmentSummaryList){        
        Integer totalRecCountForUpdate = weeklyShipmentSummaryList.size();
        Integer maxSizeForUpdate = 9900;
        if(totalRecCountForUpdate > maxSizeForUpdate){
            for(Integer i = 0 ; i < (totalRecCountForUpdate / maxSizeForUpdate)+1 ; i++){
                List<Weekly_Shipment_Summary__c> supplyTemp = new  List<Weekly_Shipment_Summary__c>();
                for(Integer j=(i*maxSizeForUpdate);(j<(i*maxSizeForUpdate)+maxSizeForUpdate) && j<totalRecCountForUpdate ; j++){
                    supplyTemp.add(weeklyShipmentSummaryList.get(j));
                }
                upsert supplyTemp;
            }
        }else{
            upsert weeklyShipmentSummaryList;
        } 
    }
    
    
    //***********Fetching all the Sales Order Ids of the records for which shippment has been done for the week for Online Portal***********/
    public MAP<ID,ID> fetchOnlineDetailLineItemShipmentDoneInTheWeek(List<AggregateResult> onlineDetailItemList){     
        System.debug('Start Method fetchOnlineDetailLineItemShipmentDoneInTheWeek');         
        //********************************************************************************************************//
        MAP<ID,ID> onlineDetailItemNumber = new MAP<ID,ID>();
        System.debug('fetchSalesOrderNumbersForShipmentDoneInTheWeek:::salesOrderList size:::'+onlineDetailItemList.size()); 
        for (AggregateResult onlineDetailItemNo : onlineDetailItemList){
            onlineDetailItemNumber.put(String.valueOf(onlineDetailItemNo.get('onlineDetailItemNo')) ,String.valueOf(onlineDetailItemNo.get('onlineDetailItemNo')));
        }                       
        List<Weekly_Demand_Consolidated_Order_Id__c> onlineDetailItemNumDemandList = new List<Weekly_Demand_Consolidated_Order_Id__c>();
        SET<ID> onlineDetailItemIds = onlineDetailItemNumber.keySet();
         System.debug('fetchOnlineDetailLineItemShipmentDoneInTheWeek:::onlineDetailItemIds'+onlineDetailItemIds);
        String getQueryStringDmd = 'Select Weekly_Demand_Summary__c,Online_Detail__c  FROM  Weekly_Demand_Consolidated_Order_Id__c WHERE Online_Detail__c  IN:onlineDetailItemIds';
       
        for( List<Weekly_Demand_Consolidated_Order_Id__c> salesOrdNumDemandListResult: Database.Query(getQueryStringDmd)) {
            onlineDetailItemNumDemandList.addAll(salesOrdNumDemandListResult);
        }
        //********************************************************************************************************//        
        MAP<ID,ID> onlineDetailItemNumWkDemandSummaryId = new MAP<ID,ID>();
        for (Weekly_Demand_Consolidated_Order_Id__c onlineDetailItemDemandId : onlineDetailItemNumDemandList){
            onlineDetailItemNumWkDemandSummaryId.put( onlineDetailItemDemandId.Online_Detail__c ,onlineDetailItemDemandId.Weekly_Demand_Summary__c);
        }  
        System.debug('fetchOnlineDetailLineItemShipmentDoneInTheWeek:::onlineDetailItemNumWkDemandSummaryId:::'+onlineDetailItemNumWkDemandSummaryId); 
        System.debug('End Method fetchOnlineDetailLineItemShipmentDoneInTheWeek'); 
        return onlineDetailItemNumWkDemandSummaryId;
    }
    
    //Fetching all the Existing Shipment details for PORTAL
    public Map<ID,Weekly_Shipment_Summary__c> fetchWeeklyShipmentSummaryForTheWeekPortal(Date weekStartDate,Date weekEndDate,List<AggregateResult> onlineDetailItemList){
        System.debug('Start Method fetchWeeklyShipmentSummaryForTheWeekPortal'); 
        MAP<ID,ID> onlineDetailItemNumDemandIds = fetchOnlineDetailLineItemShipmentDoneInTheWeek(onlineDetailItemList);
        //System.debug('fetchWeeklyShipmentSummaryForTheWeekPortal:::onlineDetailItemNumDemandIds keysets:::'+onlineDetailItemNumDemandIds.keyset()); 
        SET<ID> weeklyDemandIds = new SET<ID>();
        for(ID demandIds : onlineDetailItemNumDemandIds.keySet()){             
            weeklyDemandIds.add(demandIds); 
        }         
        Map<ID,Weekly_Shipment_Summary__c> weeklyShipMap = new Map<ID,Weekly_Shipment_Summary__c>();
        List<Weekly_Shipment_Summary__c> weeklyShipmentSummary = [Select Id, Mainetti_Company__c , Retailer_Code__r.Name ,Mainetti_Model__c,Mainetti_Model__r.Name,Color__c ,Sizer_Print__c ,Quantity__c,Weekly_Demand_Summary__c FROM Weekly_Shipment_Summary__c  WHERE  Weekly_Demand_Summary__c IN:weeklyDemandIds];
        for (Weekly_Shipment_Summary__c weeklyShipment : weeklyShipmentSummary){            
            weeklyShipMap.put(weeklyShipment.Weekly_Demand_Summary__c,weeklyShipment);            
        }
        //System.debug('fetchWeeklyShipmentSummaryForTheWeekPortal:::weeklyShipMap:::'+weeklyShipMap);
        System.debug('End Method fetchWeeklyShipmentSummaryForTheWeekPortal');
        return weeklyShipMap;
    }    
    //***********Fetching all the Sales Order Ids of the records for which shippment has been done for the week for MagNET***********/
    public MAP<ID,ID> fetchSalesOrderItemNumbersForShipmentDoneInTheWeek(List<AggregateResult> salesOrderItemList){     
        System.debug('Start Method fetchSalesOrderNumbersForShipmentDoneInTheWeek');         
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
    public Map<ID,Weekly_Shipment_Summary__c> fetchWeeklyShipmentSummaryForTheWeekMagNET(Date weekStartDate,Date weekEndDate,List<AggregateResult> salesOrderItemList){
        System.debug('Start Method fetchWeeklyShipmentSummaryForTheWeekMagNET'); 
        MAP<ID,ID> salesOrderItemNumDemandIds = fetchSalesOrderItemNumbersForShipmentDoneInTheWeek(salesOrderItemList);
        //System.debug('fetchWeeklyShipmentSummaryForTheWeekMagNET:::salesOrderItemNumDemandIds keysets:::'+salesOrderItemNumDemandIds.keyset()); 
        SET<ID> weeklyDemandIds = new SET<ID>();
        for(ID demandIds : salesOrderItemNumDemandIds.keySet()){             
            weeklyDemandIds.add(demandIds); 
        }         
        Map<ID,Weekly_Shipment_Summary__c> weeklyShipMap = new Map<ID,Weekly_Shipment_Summary__c>();
        List<Weekly_Shipment_Summary__c> weeklyShipmentSummary = [Select Id, Mainetti_Company__c , Retailer_Code__r.Name ,Mainetti_Model__c,Mainetti_Model__r.Name,Color__c ,Sizer_Print__c ,Quantity__c,Weekly_Demand_Summary__c FROM Weekly_Shipment_Summary__c  WHERE  Weekly_Demand_Summary__c IN:weeklyDemandIds];
        for (Weekly_Shipment_Summary__c weeklyShipment : weeklyShipmentSummary){            
            weeklyShipMap.put(weeklyShipment.Weekly_Demand_Summary__c,weeklyShipment);            
        }
        //System.debug('fetchWeeklyShipmentSummaryForTheWeekMagNET:::weeklyShipMap:::'+weeklyShipMap);
        System.debug('End Method fetchWeeklyShipmentSummaryForTheWeekMagNET');
        return weeklyShipMap;
    }
    public String getShipmentKey(AggregateResult shipmentDetail){      
        String shipmentKey =   String.valueOf(shipmentDetail.get('OrderToCompany'))+'#'+String.valueOf(shipmentDetail.get('RetailerName'))+'#'+String.valueOf(shipmentDetail.get('ModelName'))+'#'+String.valueOf(shipmentDetail.get('Color'))+'#'+String.valueOf(shipmentDetail.get('Printer'));
        return shipmentKey;  
    }
    
}