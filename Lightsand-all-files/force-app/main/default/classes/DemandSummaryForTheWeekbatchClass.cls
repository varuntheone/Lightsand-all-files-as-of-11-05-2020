global class DemandSummaryForTheWeekbatchClass implements Database.Batchable<sObject>{
    global List<AggregateResult> salesOrderLineItemList {get; set;} 
    global List<AggregateResult> onlineDetailsList {get; set;} 
    global Iterable<SObject> fetchWeeklyDemandSummaryForTheWeek {get; set;} 
    
    global DemandSummaryForTheWeekbatchClass(List<AggregateResult> salesOrderLineItemList,List<AggregateResult> onlineDetailsList){ 
        this.salesOrderLineItemList = salesOrderLineItemList; 
        this.onlineDetailsList = onlineDetailsList;
    } 
    global Iterable<Sobject> start(Database.batchableContext bc) {
         System.debug('########### INSIDE THE DEMAND BATCH START METHOD ##############');
        return (Iterable<SObject>) new DemandSummaryForTheWeekIterable();        
    }    
    global void execute(Database.BatchableContext BC, List<Sobject> scope) {
        List<Weekly_Demand_Summary__c> weeklyDemandSummaryObj = existingDemandSummaryForTheWeek();
        List<Weekly_Demand_Consolidated_Order_Id__c> weeklyDemandConsIdsObj = existingDemandConOrderIdForTheWeek ();
        List<Partner__c> partnerList = new List<Partner__c> ();
        System.debug('########### INSIDE THE DEMAND BATCH EXECUTE METHOD ##############');
        
        //Putting the object data to approporiate object
        for(SObject demand : scope)
        { 
            switch on demand {
                when Partner__c partner {		 
                    partnerList.add(partner);
                }  
            }
        }
        /**********************Start Processing********************************/
        System.debug('Start Method upsertAllDemandSummaryFortheWeek'); 
      
        Date startdate = date.today();
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        boolean status = true;
        //Fetching the existing weeks data
        Map<string,Weekly_Demand_Summary__c> weekMap = fetchWeeklyDemandSummaryForTheWeek(weeklyDemandSummaryObj);
        system.debug('weekMapSize:'+weekMap.size());
        //fetching the existing online Enquiry and SalesOrder Ids for which consolidation has been done
        Map<string,string> conEnqSalesIdMap = fetchWeeklyEnquiryIdAndSalesOrderIdForTheWeek(weeklyDemandConsIdsObj);
        
        Map<string,Map<string,string>> enquiryOrderIdsMap = new Map<string,Map<string,string>>();
        Map<string,Map<string,List<String>>> salesOrderIdsMap = new Map<string,Map<string,List<String>>>();
        
        
        Map<string,List<String>> enquiryIdDetailIdsMap = new Map<string,List<String>>(); 
        Map<string,string> detailIdExtSysIDMap = new Map<string,String>(); 
        //Fetch the Old Portal Order Details
        List<Weekly_Demand_Summary__c> weeklyDemandSummaryList = new List<Weekly_Demand_Summary__c>();
        Integer enqCount = 1;  
         System.debug('EXECUTE onlineDetailsList::: SIZE'+onlineDetailsList.size());
        //Fetching the Old Portal Order Details 
        AggregateResult[] portalOrderDetailSummary = onlineDetailsList;        
        
        for (AggregateResult portalOrderDetail : portalOrderDetailSummary){
            //Generating the key for the Map
            String demandKey = getDemandKey(portalOrderDetail);
            System.debug(' upsertAllDemandSummaryFortheWeek::::PORTAL:::demandKey'+demandKey);
            system.debug('weekMap:'+weekMap);
            //If the record does not exits then create a new record.
            if(!weekMap.containsKey(demandKey)){
                System.debug(' upsertAllDemandSummaryFortheWeek:::Inside NOT Present'); 
                Weekly_Demand_Summary__c  weeklyDemandSummary = new Weekly_Demand_Summary__c();                
                weeklyDemandSummary.Order_to_Company__c =  String.valueOf(portalOrderDetail.get('OrderToCompany'));
                weeklyDemandSummary.Retailer_Code__c = String.valueOf(portalOrderDetail.get('RetailerCode'));
                weeklyDemandSummary.Mainetti_Model__c = String.valueOf(portalOrderDetail.get('Model'));
                weeklyDemandSummary.Color__c = String.valueOf(portalOrderDetail.get('Color'));
                weeklyDemandSummary.Sizer_Print__c = String.valueOf(portalOrderDetail.get('Printer'));
                weeklyDemandSummary.Quantity__c = Double.valueOf(portalOrderDetail.get('Quantity'));
                
                
                System.debug(' upsertAllDemandSummaryFortheWeek:::Inside NOT Present::::weeklyDemandSummary.Quantity__c'+weeklyDemandSummary.Quantity__c); 
                weeklyDemandSummary.Week_Start_Date__c = weekStartDate;
                weeklyDemandSummary.Week_End_Date__c = weekEndDate;
                //weeklyDemandSummary.Week_Number__c = weekNumber;
                String random = String.valueof(DateTime.now().getTime())+'_'+String.valueOf(enqCount);
                System.debug(':::random:::'+random);
                weeklyDemandSummary.External_Id__c = random;
                weekMap.put(demandKey,weeklyDemandSummary);
                enqCount++;
               
                String enquiryId = String.valueOf(portalOrderDetail.get('OnlineEnquiryId'));    
                
                if(!enquiryIdDetailIdsMap.containsKey(enquiryId)){  
                    List<String> detailItems = new List<String>();
                    detailItems.add(String.valueOf(portalOrderDetail.get('detailId')));
                    enquiryIdDetailIdsMap.put(enquiryId,detailItems);
                }else{
                    List<String> detailItems = enquiryIdDetailIdsMap.get(enquiryId);
                    detailItems.add(String.valueOf(portalOrderDetail.get('detailId')));
                    enquiryIdDetailIdsMap.put(enquiryId,detailItems);
                }
                String itemNumber = String.valueOf(portalOrderDetail.get('detailId')); 
                if(!detailIdExtSysIDMap.containsKey(itemNumber)){
                    detailIdExtSysIDMap.put(itemNumber,random);
                }
            }else{
                System.debug(' upsertAllDemandSummaryFortheWeek:::Inside Present'+demandKey); 
                //getting the updated quantity for the combination of the Key.
                Weekly_Demand_Summary__c  weeklyDemandSummary = weekMap.get(demandKey);
                String externalId = weeklyDemandSummary.External_Id__c;
                System.debug('upsertAllDemandSummaryFortheWeek:::BEFORE QUANTITY'); 
                Double oldQuantity = weeklyDemandSummary.Quantity__c;
                Double newQuantity = Double.valueOf(portalOrderDetail.get('Quantity'));  
                System.debug(' upsertAllDemandSummaryFortheWeek:::AFTER QUANTITY'); 
                
                weeklyDemandSummary.Quantity__c = (oldQuantity+newQuantity);       
                System.debug(' upsertAllDemandSummaryFortheWeek:::Inside NOT Existing onLineEnquiry NEW Quantity'+weeklyDemandSummary.Quantity__c); 
                
                weekMap.put(demandKey,weeklyDemandSummary);  
                String enquiryId = String.valueOf(portalOrderDetail.get('OnlineEnquiryId'));                
                if(!enquiryIdDetailIdsMap.containsKey(enquiryId)){  
                    List<String> detailItems = new List<String>();
                    detailItems.add(String.valueOf(portalOrderDetail.get('detailId')));
                    enquiryIdDetailIdsMap.put(enquiryId,detailItems);
                }else{
                    List<String> detailItems = enquiryIdDetailIdsMap.get(enquiryId);
                    detailItems.add(String.valueOf(portalOrderDetail.get('detailId')));
                    enquiryIdDetailIdsMap.put(enquiryId,detailItems);
                }
                String itemNumber = String.valueOf(portalOrderDetail.get('detailId')); 
                if(!detailIdExtSysIDMap.containsKey(itemNumber)){
                    detailIdExtSysIDMap.put(itemNumber,externalId);
                }
            }            
        }
        Map<string,List<String>> salesOrderItemIDMap = new Map<string,List<String>>(); 
        Map<string,string> itemIdExtSysIDMap = new Map<string,String>(); 
        Integer count = 1;  
        ////Fetch the New Portal Order Details from MagNET
        AggregateResult[] magNETOrderDetailSummary = salesOrderLineItemList;
        for (AggregateResult magNETOrderDetail : magNETOrderDetailSummary){
            String demandKey = getDemandKey(magNETOrderDetail);
            System.debug(' upsertAllDemandSummaryFortheWeek::::MagNET:::demandKey'+demandKey); 
            //If the record does not exits then create a new record.
            if(!weekMap.containsKey(demandKey)){
                System.debug(' upsertAllDemandSummaryFortheWeek::::MagNET:::Inside NOT Present'); 
                Weekly_Demand_Summary__c  weeklyDemandSummary = new Weekly_Demand_Summary__c();
                weeklyDemandSummary.Order_to_Company__c =  String.valueOf(magNETOrderDetail.get('OrderToCompany'));
                weeklyDemandSummary.Retailer_Code__c = String.valueOf(magNETOrderDetail.get('RetailerCode'));
                weeklyDemandSummary.Mainetti_Model__c = String.valueOf(magNETOrderDetail.get('Model'));
                weeklyDemandSummary.Color__c = String.valueOf(magNETOrderDetail.get('Color'));
                weeklyDemandSummary.Sizer_Print__c = String.valueOf(magNETOrderDetail.get('Printer'));
                weeklyDemandSummary.Quantity__c = Double.valueOf(magNETOrderDetail.get('Quantity'));
                weeklyDemandSummary.Week_Start_Date__c = weekStartDate;
                weeklyDemandSummary.Week_End_Date__c = weekEndDate;
                //weeklyDemandSummary.Week_Number__c = weekNumber;
                String random = String.valueof(DateTime.now().getTime())+'_'+String.valueOf(count);
                System.debug(':::random:::'+random);
                weeklyDemandSummary.External_Id__c = random;
                weekMap.put(demandKey,weeklyDemandSummary);
                count++;
                String salesOrder = String.valueOf(magNETOrderDetail.get('SalesOrder'));                
                if(!salesOrderItemIDMap.containsKey(salesOrder)){  
                    List<String> salesOrderItems = new List<String>();
                    salesOrderItems.add(String.valueOf(magNETOrderDetail.get('lineItemId')));
                    salesOrderItemIDMap.put(salesOrder,salesOrderItems);
                }else{
                    List<String> salesOrderItems = salesOrderItemIDMap.get(salesOrder);
                    salesOrderItems.add(String.valueOf(magNETOrderDetail.get('lineItemId')));
                    salesOrderItemIDMap.put(salesOrder,salesOrderItems);
                }
                String itemNumber = String.valueOf(magNETOrderDetail.get('lineItemId')); 
                if(!itemIdExtSysIDMap.containsKey(itemNumber)){
                    itemIdExtSysIDMap.put(itemNumber,random);
                }
            }else{
                System.debug(' upsertAllDemandSummaryFortheWeek::::MagNET:::Inside Present'); 
                //getting the updated quantity for the combination of the Key.
                Weekly_Demand_Summary__c  weeklyDemandSummary = weekMap.get(demandKey);
                Double oldQuantity = weeklyDemandSummary.Quantity__c;
                Double newQuantity = Double.valueOf(magNETOrderDetail.get('Quantity')); 
                String externalId = weeklyDemandSummary.External_Id__c;
                System.debug(' upsertAllDemandSummaryFortheWeek:::Inside NOT Existing salesOrder NEW Quantity'+(oldQuantity+newQuantity)); 
                weeklyDemandSummary.Quantity__c = (oldQuantity+newQuantity);
                weekMap.put(demandKey,weeklyDemandSummary);  
                String salesOrder = String.valueOf(magNETOrderDetail.get('SalesOrder'));
                if(!salesOrderItemIDMap.containsKey(salesOrder)){  
                    List<String> salesOrderItems = new List<String>();
                    salesOrderItems.add(String.valueOf(magNETOrderDetail.get('lineItemId')));
                    salesOrderItemIDMap.put(salesOrder,salesOrderItems);
                }else{
                    List<String> salesOrderItems = salesOrderItemIDMap.get(salesOrder);
                    salesOrderItems.add(String.valueOf(magNETOrderDetail.get('lineItemId')));
                    salesOrderItemIDMap.put(salesOrder,salesOrderItems);
                }
                String itemNumber = String.valueOf(magNETOrderDetail.get('lineItemId')); 
                if(!itemIdExtSysIDMap.containsKey(itemNumber)){
                     itemIdExtSysIDMap.put(itemNumber,externalId);
                }                
            }
        }    
        
        List<Weekly_Demand_Consolidated_Order_Id__c> weeklyDemandConsolidatedList = new List<Weekly_Demand_Consolidated_Order_Id__c>();
        
        boolean isSalesOrderComplete = false;
        for(string demandKey : weekMap.keySet()){
            System.debug(' upsertAllDemandSummaryFortheWeek:::weekMap.keySet()::::demandKey'+demandKey);
            Weekly_Demand_Summary__c  weeklyDemandSummary = weekMap.get(demandKey); 
            Map<string,string>enquieryIds = enquiryOrderIdsMap.get(demandKey);
            
            if(salesOrderItemIDMap != null){
                if(!isSalesOrderComplete){
                    for(string salesOrderId : salesOrderItemIDMap.keySet()){
                        List<String> salesOrderItems = salesOrderItemIDMap.get(salesOrderId);
                        System.debug('salesOrderItems LIST ITEM SIZE'+salesOrderItems.size()+'salesOrderItems'+salesOrderItems);
                        for (String salesItem : salesOrderItems){
                            String externalId = itemIdExtSysIDMap.get(salesItem);
                            Weekly_Demand_Consolidated_Order_Id__c weeklyDemandConsId = new Weekly_Demand_Consolidated_Order_Id__c();
                            weeklyDemandConsId.Sales_Order__c =salesOrderId; 
                            weeklyDemandConsId.Week_Start_Date__c = weekStartDate;
                            weeklyDemandConsId.Week_End_Date__c = weekEndDate;
                            weeklyDemandConsId.External_Id__c = externalId;
                            weeklyDemandConsId.Sales_Order_Item__c = salesItem;
                            System.debug(':::SalesORder weeklyDemandConsId.External_Id__c:::'+weeklyDemandConsId.External_Id__c);
                            weeklyDemandConsId.Weekly_Demand_Summary__r = new Weekly_Demand_Summary__c(External_Id__c = externalId);
                            weeklyDemandConsolidatedList.add(weeklyDemandConsId);
                        }                        
                    }
                    if(enquiryIdDetailIdsMap != null){
                        for(string enquiryId : enquiryIdDetailIdsMap.keySet()){
                            List<String> enquiryDetailItems = enquiryIdDetailIdsMap.get(enquiryId);
                            System.debug('enquiryDetailItems LIST ITEM SIZE'+enquiryDetailItems.size()+'enquiryDetailItems'+enquiryDetailItems);
                            for (String detailItem : enquiryDetailItems){
                                String externalId = detailIdExtSysIDMap.get(detailItem);
                                Weekly_Demand_Consolidated_Order_Id__c weeklyDemandConsId = new Weekly_Demand_Consolidated_Order_Id__c();
                                weeklyDemandConsId.Online_Enquiry__c  =enquiryId; 
                                weeklyDemandConsId.Week_Start_Date__c = weekStartDate;
                                weeklyDemandConsId.Week_End_Date__c = weekEndDate;
                                weeklyDemandConsId.External_Id__c = externalId;
                                weeklyDemandConsId.Online_Detail__c = detailItem;
                                System.debug(':::SalesORder weeklyDemandConsId.External_Id__c:::'+weeklyDemandConsId.External_Id__c);
                                weeklyDemandConsId.Weekly_Demand_Summary__r = new Weekly_Demand_Summary__c(External_Id__c = externalId);
                                weeklyDemandConsolidatedList.add(weeklyDemandConsId);
                            }                        
                        }
                    }
                    isSalesOrderComplete = true;
                }
            }
                      
            System.debug(' upsertAllDemandSummaryFortheWeek::::Weekly_Demand_Summary__c:::Quantity'+weeklyDemandSummary.Quantity__c);            
            weeklyDemandSummaryList.add(weeklyDemandSummary); 
            
        }        
        try{
            //upsert weeklyDemandSummaryList;
            splitDemandListForUpsert(weeklyDemandSummaryList);
            //upsert weeklyDemandConsolidatedList;
            splitConsolidateDemandListForUpsert(weeklyDemandConsolidatedList);
        }catch(DMLException e){
            System.debug('Exception during Upsert of Weekly Demand Summary '+e.getMessage()); 
            status = false;
        }   
        System.debug(' upsertAllDemandSummaryFortheWeek:::return status:::'+status);  

        System.debug('End Method upsertAllDemandSummaryFortheWeek'); 
        //return status;
        
        /*************************End of Processing****************************/
    }
    global void finish(Database.BatchableContext BC){
        System.debug('##########INSIDE THE END FUNCTION OF DEMAND BATCH###############');
    }
    
    public Map<string,Weekly_Demand_Summary__c> fetchWeeklyDemandSummaryForTheWeek(List<Weekly_Demand_Summary__c> weeklyDemandSummary){ 
        
        Map<string,Weekly_Demand_Summary__c> weeklyDemandMap = new Map<string,Weekly_Demand_Summary__c>();
        //System.debug('fetchWeeklyDemandSummaryForTheWeek::weeklyDemandSummary list size'+weeklyDemandSummary.size());
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
    public Map<string,string> fetchWeeklyEnquiryIdAndSalesOrderIdForTheWeek(List<Weekly_Demand_Consolidated_Order_Id__c> weeklyDemandConsIds){ 
        Map<string,string> weeklyEnqSalesIdMap = new Map<string,string>();                
        //System.debug('fetchWeeklyEnquiryIdAndSalesOrderIdForTheWeek::weeklyDemandConsIds list size'+weeklyDemandConsIds.size());
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
    public String getDemandKey(AggregateResult demandOrderDetail){		        
        String demandKey =  String.valueOf(demandOrderDetail.get('OrderToCompany'))+'#'+String.valueOf(demandOrderDetail.get('RetailerName'))+'#'+String.valueOf(demandOrderDetail.get('ModelName'))+'#'+String.valueOf(demandOrderDetail.get('Color'))+'#'+String.valueOf(demandOrderDetail.get('Printer'));
        return demandKey;        
    }
    
    public void splitDemandListForUpsert(List<Weekly_Demand_Summary__c> weeklyDemandSummaryList){        
        Integer totalRecCountForUpdate = weeklyDemandSummaryList.size();
        Integer maxSizeForUpdate = 9900;
        if(totalRecCountForUpdate > maxSizeForUpdate){
            for(Integer i = 0 ; i < (totalRecCountForUpdate / maxSizeForUpdate)+1 ; i++){
                List<Weekly_Demand_Summary__c> demandTemp = new  List<Weekly_Demand_Summary__c>();
                for(Integer j=(i*maxSizeForUpdate);(j<(i*maxSizeForUpdate)+maxSizeForUpdate) && j<totalRecCountForUpdate ; j++){
                    demandTemp.add(weeklyDemandSummaryList.get(j));
                }
                upsert demandTemp;
            }
        }else{
            upsert weeklyDemandSummaryList;
        }
    }
    public void splitConsolidateDemandListForUpsert(List<Weekly_Demand_Consolidated_Order_Id__c> weeklyDemandConsolidatedList ){        
        Integer totalRecCountForUpdate = weeklyDemandConsolidatedList.size();
        Integer maxSizeForUpdate = 9900;
        system.debug('weeklyDemandConsolidatedList.size:'+weeklyDemandConsolidatedList.size());
        if(totalRecCountForUpdate > maxSizeForUpdate){
            for(Integer i = 0 ; i < (totalRecCountForUpdate / maxSizeForUpdate)+1 ; i++){
                List<Weekly_Demand_Consolidated_Order_Id__c> consolTemp = new  List<Weekly_Demand_Consolidated_Order_Id__c>();
                for(Integer j=(i*maxSizeForUpdate);(j<(i*maxSizeForUpdate)+maxSizeForUpdate) && j<totalRecCountForUpdate ; j++){
                    consolTemp.add(weeklyDemandConsolidatedList.get(j));
                }
                upsert consolTemp;
            }
        }else{
            upsert weeklyDemandConsolidatedList;
        }
    }
    public List<Weekly_Demand_Summary__c> existingDemandSummaryForTheWeek(){ 
         System.debug('Start existingDemandSummaryForTheWeek');
        Date startdate = date.today();
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();         
       List<Weekly_Demand_Summary__c> sobjs = new List<Weekly_Demand_Summary__c>();
       
       String getQueryDemandString='Select Id,Order_to_Company__c , Retailer_Code__r.Name ,Mainetti_Model__r.Name,Color__c ,Sizer_Print__c,External_Id__c  FROM Weekly_Demand_Summary__c  WHERE Week_Start_Date__c >=:weekStartDate AND Week_End_Date__c <=:weekEndDate';
        for(List<Weekly_Demand_Summary__c> demand : Database.Query(getQueryDemandString)) {
           sobjs.addAll(demand);
       }
       integer demandSummarySize = sobjs.size();
        System.debug('##### existingDemandSummaryForTheWeek:Weekly_Demand_Summary__c:'+Database.Query(getQueryDemandString));
       System.debug('##### existingDemandSummaryForTheWeek:::: Weekly_Demand_Summary__c::::SIZE'+demandSummarySize);        
        return sobjs;
    }
    public List<Weekly_Demand_Consolidated_Order_Id__c> existingDemandConOrderIdForTheWeek(){ 
        System.debug('Start existingDemandConOrderIdForTheWeek');
        Date startdate = date.today();
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();         
       List<Weekly_Demand_Consolidated_Order_Id__c> sobjs = new List<Weekly_Demand_Consolidated_Order_Id__c>();
       
       String getQueryConsIdString='SELECT Online_Enquiry__c,Sales_Order__c FROM Weekly_Demand_Consolidated_Order_Id__c WHERE Week_Start_Date__c >=:weekStartDate AND Week_End_Date__c <=:weekEndDate';
        for(List<Weekly_Demand_Consolidated_Order_Id__c> con : Database.Query(getQueryConsIdString)) {    
           sobjs.addAll(con);
       }
         integer demandConsSize = (sobjs.size());        
         System.debug('##### existingDemandConOrderIdForTheWeek:::: Weekly_Demand_Consolidated_Order_Id__c::::SIZE'+demandConsSize);      
        return sobjs;
    }
}