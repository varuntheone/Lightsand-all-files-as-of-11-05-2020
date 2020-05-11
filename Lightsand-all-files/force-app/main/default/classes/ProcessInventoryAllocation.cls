//********************************************//
//This class contains all the methods related to the inventory
//allocation which is called in the InventoryAllocationBatch Class
//Also this class uses the master data method of InventoryAllocationMaster
public class ProcessInventoryAllocation {
    
    InventoryAllocationMaster invAllocMaster = new InventoryAllocationMaster();
    
    // Insert the records to calculate all the demand allocation done for the week.
    public boolean upsertAllDemandSummaryFortheWeek(String weekNumber,Date weekStartDate,Date weekEndDate){
        System.debug('Start Method upsertAllDemandSummaryFortheWeek'); 
        boolean status = true;
        System.debug(':::weekStartDate:::'+weekStartDate+':::weekEndDate:::'+weekEndDate);
        //Fetching the existing weeks data
        Map<string,Weekly_Demand_Summary__c> weekMap = invAllocMaster.fetchWeeklyDemandSummaryForTheWeek(weekStartDate,weekEndDate);
        system.debug('weekMap:'+weekMap);
        //fetching the existing online Enquiry and SalesOrder Ids for which consolidation has been done
        Map<string,string> conEnqSalesIdMap = invAllocMaster.fetchWeeklyEnquiryIdAndSalesOrderIdForTheWeek(weekStartDate,weekEndDate);
        system.debug('conEnqSalesIdMap:'+conEnqSalesIdMap);
        
        Map<string,Map<string,string>> enquiryOrderIdsMap = new Map<string,Map<string,string>>();
        Map<string,Map<string,List<String>>> salesOrderIdsMap = new Map<string,Map<string,List<String>>>();
          
        
        Map<string,List<String>> enquiryIdDetailIdsMap = new Map<string,List<String>>(); 
        Map<string,string> detailIdExtSysIDMap = new Map<string,String>(); 
        //Fetch the Old Portal Order Details
        List<Weekly_Demand_Summary__c> weeklyDemandSummaryList = new List<Weekly_Demand_Summary__c>();
        Integer enqCount = 1;  
        //Fetching the Old Portal Order Details 
        AggregateResult[] portalOrderDetailSummary = invAllocMaster.fetchOrderDetailsFromPortal(weekStartDate,weekEndDate);        
         
        for (AggregateResult portalOrderDetail : portalOrderDetailSummary){
            //Generating the key for the Map
            String demandKey = getDemandKey(portalOrderDetail);
            System.debug(' upsertAllDemandSummaryFortheWeek::::PORTAL:::demandKey'+demandKey); 
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
                weeklyDemandSummary.Week_Number__c = weekNumber;
                String random = String.valueof(DateTime.now().getTime())+'_'+String.valueOf(enqCount);
                System.debug(':::random:::'+random);
                weeklyDemandSummary.External_Id__c = random;
                weekMap.put(demandKey,weeklyDemandSummary);
                enqCount++;
                //Setting all the online Enquiry Ids for which consolidation is being done.
                /*String enquiryId = String.valueOf(portalOrderDetail.get('OnlineEnquiryId'));
                if(!conEnqSalesIdMap.containsKey(enquiryId)){                   
                    Map<string,string> enquiryIdMap = new Map<string,string>();                
                    enquiryIdMap.put(enquiryId,enquiryId);
                    enquiryOrderIdsMap.put(demandKey,enquiryIdMap);
                    conEnqSalesIdMap.put(enquiryId,enquiryId);
                }  */     
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
                System.debug(' upsertAllDemandSummaryFortheWeek:::BEFORE QUANTITY'); 
                Double oldQuantity = weeklyDemandSummary.Quantity__c;
                Double newQuantity = Double.valueOf(portalOrderDetail.get('Quantity'));  
                System.debug(' upsertAllDemandSummaryFortheWeek:::AFTER QUANTITY'); 
                
                weeklyDemandSummary.Quantity__c = (oldQuantity+newQuantity);       
                System.debug(' upsertAllDemandSummaryFortheWeek:::Inside NOT Existing onLineEnquiry NEW Quantity'+weeklyDemandSummary.Quantity__c); 
               /* weekMap.put(demandKey,weeklyDemandSummary);
                //Setting all the online Enquiry Ids for which consolidation is being done.
                String enquiryId = String.valueOf(portalOrderDetail.get('OnlineEnquiryId')); 
                if(!conEnqSalesIdMap.containsKey(enquiryId)){
                    Map<string,string> enquiryIdMap = enquiryOrderIdsMap.get(demandKey);                    
                    if(enquiryIdMap != null){
                        if(!enquiryIdMap.containsKey(enquiryId)){
                            enquiryIdMap.put(enquiryId,enquiryId);
                            enquiryOrderIdsMap.put(demandKey,enquiryIdMap); 
                        }  
                    }else{
                        Map<string,string> enquiryIdNewMap = new Map<string,string>();                    
                        enquiryIdNewMap.put(enquiryId,enquiryId);
                        enquiryOrderIdsMap.put(demandKey,enquiryIdNewMap);
                    }
                    conEnqSalesIdMap.put(enquiryId,enquiryId);
                } */
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
        AggregateResult[] magNETOrderDetailSummary = invAllocMaster.fetchOrderDetailsFromMagNET(weekStartDate,weekEndDate);
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
                weeklyDemandSummary.Week_Number__c = weekNumber;
                String random = String.valueof(DateTime.now().getTime())+'_'+String.valueOf(count);
                System.debug(':::random:::'+random);
                weeklyDemandSummary.External_Id__c = random;
                weekMap.put(demandKey,weeklyDemandSummary);
                count++;
                String salesOrder = String.valueOf(magNETOrderDetail.get('SalesOrder'));     
                System.debug('salesOrder:'+salesOrder);
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
                    
                    //itemIdExtSysIDMap.put(itemNumber,weeklyDemandSummary.External_Id__c);
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
            /*if(enquieryIds != null){
                for(string enquiryId : enquieryIds.keySet()){
                    String externalId = weeklyDemandSummary.External_Id__c;
                    Weekly_Demand_Consolidated_Order_Id__c weeklyDemandConsId = new Weekly_Demand_Consolidated_Order_Id__c();
                    weeklyDemandConsId.Online_Enquiry__c =enquiryId; 
                    weeklyDemandConsId.Week_Start_Date__c = weekStartDate;
                    weeklyDemandConsId.Week_End_Date__c = weekEndDate; 
                    weeklyDemandConsId.External_Id__c = externalId;
                    System.debug(':::enquiryId weeklyDemandConsId.External_Id__c:::'+weeklyDemandConsId.External_Id__c);
                    weeklyDemandConsId.Weekly_Demand_Summary__r = new Weekly_Demand_Summary__c(External_Id__c = externalId);
                    weeklyDemandConsolidatedList.add(weeklyDemandConsId);
                }
            } */
            
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
        return status;
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
    // Insert the records to calculate all the supply allocation done for the week.
    public  boolean upsertAllSupplySummaryFortheWeek(String weekNumber,Date weekStartDate,Date weekEndDate){
        System.debug('Start Method upsertAllSupplySummaryFortheWeek'); 
        boolean status = true;
        System.debug(':::weekStartDate:::'+weekStartDate+':::weekEndDate:::'+weekEndDate);        
        //Fetch the Old Portal Order Details
        List<Weekly_Supply_Summary__c> weeklySupplySummaryList = new List<Weekly_Supply_Summary__c>();
        
        //Fetching the existing weeks Virgin data
        Map<string,Weekly_Supply_Summary__c> weekVirginMap = invAllocMaster.fetchWeeklySupplyVirginSummaryForTheWeek(weekStartDate,weekEndDate);
         System.debug('weekVirginMap:'+weekVirginMap); 
        //fetching all the data upload Ids for which consoldition is taken place for the week
        Map<string,string> conDataUploadIdsMap = invAllocMaster.fetchWeeklyDataUploadIdForTheWeek(weekStartDate,weekEndDate);
        
        Map<string,Map<string,string>> dataUploadIdsMap = new Map<string,Map<string,string>>();
        map<string,string> defaultOrderToCompany = getManitteCompanyMap();
        System.debug('##################################################defaultOrderToCompany'+defaultOrderToCompany);
        //Fetching the stock On Hand for Virgin 
        AggregateResult[] stockOnHandVirginSummary = invAllocMaster.fetchStockOnHandForSourceVirgin(weekStartDate,weekEndDate);
        for (AggregateResult stockOnHandVirgin : stockOnHandVirginSummary){
            String supplyKey = getSupplyKeyBatch(stockOnHandVirgin);
            System.debug('upsertAllSupplySummaryFortheWeek:::supplyKey VIRGIN:::'+supplyKey); 
           
            //If the record does not exits then create a new record.
            if(!weekVirginMap.containsKey(supplyKey)){
                System.debug('upsertAllSupplySummaryFortheWeek:::Inside NOT Present VIRGIN:::'); 
                Weekly_Supply_Summary__c  weeklySupplySummary = new Weekly_Supply_Summary__c();
                //Getting the default order to company
                weeklySupplySummary.Mainetti_Company__c = defaultOrderToCompany.get(String.valueOf(stockOnHandVirgin.get('OrderToCompany')));
                weeklySupplySummary.Retailer_Code__c = String.valueOf(stockOnHandVirgin.get('RetailerCode'));
                weeklySupplySummary.Mainetti_Model__c = String.valueOf(stockOnHandVirgin.get('Model'));
                weeklySupplySummary.Color__c = String.valueOf(stockOnHandVirgin.get('Color'));
                weeklySupplySummary.Sizer_Print__c = String.valueOf(stockOnHandVirgin.get('Printer'));
                weeklySupplySummary.Quantity__c = Double.valueOf(stockOnHandVirgin.get('Quantity'));                
                weeklySupplySummary.Week_Start_Date__c = weekStartDate;
                weeklySupplySummary.Week_End_Date__c = weekEndDate;
                weeklySupplySummary.Week_Number__c = weekNumber;
                weeklySupplySummary.Source__c = 'Virgin';
                weeklySupplySummary.Warehouse__c = String.valueOf(stockOnHandVirgin.get('Warehouse'));
                weekVirginMap.put(supplyKey,weeklySupplySummary);
                
                String uploadId = String.valueOf(stockOnHandVirgin.get('ID')); 
                if(!conDataUploadIdsMap.containsKey(uploadId)){                   
                    Map<string,string> uploadIdMap = new Map<string,string>();                
                    uploadIdMap.put(uploadId,uploadId);
                    dataUploadIdsMap.put(supplyKey,uploadIdMap);
                    conDataUploadIdsMap.put(uploadId,uploadId);
                }                        
            }else{
                System.debug('upsertAllSupplySummaryFortheWeek:::Inside Present:::VIRGIN '); 
                //getting the updated quantity for the combination of the Key.
                Weekly_Supply_Summary__c  weeklySupplySummary = weekVirginMap.get(supplyKey);                
                Double oldQuantity = weeklySupplySummary.Quantity__c;
                Double newQuantity = Double.valueOf(stockOnHandVirgin.get('Quantity'));                
                System.debug(' upsertAllSupplySummaryFortheWeek:::Inside NOT Existing salesOrder NEW Quantity'+(oldQuantity+newQuantity)); 
                weeklySupplySummary.Quantity__c = (oldQuantity+newQuantity);                
                weekVirginMap.put(supplyKey,weeklySupplySummary);
                
                String uploadId = String.valueOf(stockOnHandVirgin.get('ID')); 
                if(!conDataUploadIdsMap.containsKey(uploadId)){                
                    Map<string,string> uploadIdMap = dataUploadIdsMap.get(supplyKey);                    
                    if(uploadIdMap != null){
                        if(!uploadIdMap.containsKey(uploadId)){
                            uploadIdMap.put(uploadId,uploadId);
                            dataUploadIdsMap.put(supplyKey,uploadIdMap); 
                        }  
                    }else{
                        Map<string,string> uploadIdNewMap = new Map<string,string>();                    
                        uploadIdNewMap.put(uploadId,uploadId);
                        dataUploadIdsMap.put(supplyKey,uploadIdNewMap);
                    }
                    conDataUploadIdsMap.put(uploadId,uploadId);
                }                
            }
        }  
        System.debug('upsertAllSupplySummaryFortheWeek:::weekVirginMap.keySet():::weekVirginMap.keySet()');
        List<Weekly_Supply_Consolidated_Id__c> weeklySupplpyConsolidatedList = new List<Weekly_Supply_Consolidated_Id__c>();
        for(string supplyKey : weekVirginMap.keySet()){
            Weekly_Supply_Summary__c  weeklySupplySummary = weekVirginMap.get(supplyKey); 
            
            Map<string,string> dataUploadIds = dataUploadIdsMap.get(supplyKey);      
            if(dataUploadIds != null){
                for(string dataId : dataUploadIds.keySet()){
                    Weekly_Supply_Consolidated_Id__c weeklySupplyConsId = new Weekly_Supply_Consolidated_Id__c();
                    weeklySupplyConsId.Data_Upload_Transaction__c = dataId; 
                    weeklySupplyConsId.Week_Start_Date__c = weekStartDate;
                    weeklySupplyConsId.Week_End_Date__c = weekEndDate;
                    weeklySupplyConsId.Weekly_Supply_Summary__r = weeklySupplySummary;
                    weeklySupplpyConsolidatedList.add(weeklySupplyConsId);
                }
            }
            weeklySupplySummaryList.add(weeklySupplySummary); 
        }
        
        //Fetching the existing weeks Reuse data
        Map<string,Weekly_Supply_Summary__c> weekReuseMap = invAllocMaster.fetchWeeklySupplyReuseSummaryForTheWeek(weekStartDate,weekEndDate);    
        ////Fetch the stock on Hand for Reuse
        AggregateResult[] stockOnHandReuseSummary = invAllocMaster.fetchStockOnHandForSourceReuse(weekStartDate,weekEndDate);
        for (AggregateResult stockOnHandReuse : stockOnHandReuseSummary){
            String supplyKey = getSupplyKeyBatch(stockOnHandReuse);
            System.debug('upsertAllSupplySummaryFortheWeek:::supplyKey REUSE:::'+supplyKey); 
            System.debug('weekReuseMap:'+weekReuseMap); 
            //If the record does not exits then create a new record.
            if(!weekReuseMap.containsKey(supplyKey)){
                System.debug('upsertAllSupplySummaryFortheWeek:::INSIDE NOT PRESENT:: REUSE:::'); 
                Weekly_Supply_Summary__c  weeklySupplySummary = new Weekly_Supply_Summary__c();
                weeklySupplySummary.Mainetti_Company__c = defaultOrderToCompany.get(String.valueOf(stockOnHandReuse.get('OrderToCompany')));
                weeklySupplySummary.Retailer_Code__c = String.valueOf(stockOnHandReuse.get('RetailerCode'));
                weeklySupplySummary.Mainetti_Model__c = String.valueOf(stockOnHandReuse.get('Model'));
                weeklySupplySummary.Color__c = String.valueOf(stockOnHandReuse.get('Color'));
                weeklySupplySummary.Sizer_Print__c = String.valueOf(stockOnHandReuse.get('Printer'));
                weeklySupplySummary.Quantity__c = Double.valueOf(stockOnHandReuse.get('Quantity'));
                weeklySupplySummary.Week_Start_Date__c = weekStartDate;
                weeklySupplySummary.Week_End_Date__c = weekEndDate;
                weeklySupplySummary.Week_Number__c = weekNumber;
                weeklySupplySummary.Source__c = 'Reuse';
                weeklySupplySummary.Warehouse__c = String.valueOf(stockOnHandReuse.get('Warehouse'));                
                weekReuseMap.put(supplyKey,weeklySupplySummary);
                
                String uploadId = String.valueOf(stockOnHandReuse.get('ID')); 
                if(!conDataUploadIdsMap.containsKey(uploadId)){                   
                    Map<string,string> uploadIdMap = new Map<string,string>();                
                    uploadIdMap.put(uploadId,uploadId);
                    dataUploadIdsMap.put(supplyKey,uploadIdMap);
                    conDataUploadIdsMap.put(uploadId,uploadId);
                }           
            }else{
                System.debug('upsertAllSupplySummaryFortheWeek:::INSIDE PRESENT:: REUSE:::'); 
                //getting the updated quantity for the combination of the Key.
                Weekly_Supply_Summary__c  weeklySupplySummary = weekReuseMap.get(supplyKey);
                Double oldQuantity = weeklySupplySummary.Quantity__c;
                Double newQuantity = Double.valueOf(stockOnHandReuse.get('Quantity'));                
                System.debug(' upsertAllSupplySummaryFortheWeek:::Inside NOT Existing salesOrder NEW Quantity'+(oldQuantity+newQuantity)); 
                weeklySupplySummary.Quantity__c = (oldQuantity+newQuantity);            
                
                weekReuseMap.put(supplyKey,weeklySupplySummary);
                String uploadId = String.valueOf(stockOnHandReuse.get('ID')); 
                if(!conDataUploadIdsMap.containsKey(uploadId)){                
                    Map<string,string> uploadIdMap = dataUploadIdsMap.get(supplyKey);                    
                    if(uploadIdMap != null){
                        if(!uploadIdMap.containsKey(uploadId)){
                            uploadIdMap.put(uploadId,uploadId);
                            dataUploadIdsMap.put(supplyKey,uploadIdMap); 
                        }  
                    }else{
                        Map<string,string> uploadIdNewMap = new Map<string,string>();                    
                        uploadIdNewMap.put(uploadId,uploadId);
                        dataUploadIdsMap.put(supplyKey,uploadIdNewMap);
                    }
                    conDataUploadIdsMap.put(uploadId,uploadId);
                }                
            }
        }        
        System.debug('upsertAllSupplySummaryFortheWeek:::weekReuseMap.keySet():: REUSE:::'+weekReuseMap.keySet());
        for(string supplyKey : weekReuseMap.keySet()){
            Weekly_Supply_Summary__c  weeklySupplySummary = weekReuseMap.get(supplyKey); 
            Map<string,string> dataUploadIds = dataUploadIdsMap.get(supplyKey);      
            if(dataUploadIds != null){
                for(string dataId : dataUploadIds.keySet()){
                    Weekly_Supply_Consolidated_Id__c weeklySupplyConsId = new Weekly_Supply_Consolidated_Id__c();
                    weeklySupplyConsId.Data_Upload_Transaction__c = dataId; 
                    weeklySupplyConsId.Week_Start_Date__c = weekStartDate;
                    weeklySupplyConsId.Week_End_Date__c = weekEndDate;
                    weeklySupplyConsId.Weekly_Supply_Summary__r = weeklySupplySummary;
                    weeklySupplpyConsolidatedList.add(weeklySupplyConsId);
                }
            }
            weeklySupplySummaryList.add(weeklySupplySummary); 
        }
        try{
            //upsert weeklySupplySummaryList;
            splitSupplyListForUpsert(weeklySupplySummaryList);
            // upsert weeklySupplpyConsolidatedList;
            splitConsolidateSupplyListForUpsert(weeklySupplpyConsolidatedList);
        }catch(DMLException e){
            System.debug('Exception during Upsert of Weekly Supply Summary '+e.getMessage()); 
            status = false;
        }   
        System.debug('upsertAllSupplySummaryFortheWeek:::Return status:::'+status);
        System.debug('End Method upsertAllSupplySummaryFortheWeek:::');
        return status;
    }
    
    
    public void splitSupplyListForUpsert(List<Weekly_Supply_Summary__c> weeklySupplySummaryList){        
        Integer totalRecCountForUpdate = weeklySupplySummaryList.size();
        Integer maxSizeForUpdate = 9900;
        if(totalRecCountForUpdate > maxSizeForUpdate){
            for(Integer i = 0 ; i < (totalRecCountForUpdate / maxSizeForUpdate)+1 ; i++){
                List<Weekly_Supply_Summary__c> supplyTemp = new  List<Weekly_Supply_Summary__c>();
                for(Integer j=(i*maxSizeForUpdate);(j<(i*maxSizeForUpdate)+maxSizeForUpdate) && j<totalRecCountForUpdate ; j++){
                    supplyTemp.add(weeklySupplySummaryList.get(j));
                }
                upsert supplyTemp;
            }
        }else{
            upsert weeklySupplySummaryList;
        }
    }
    public void splitConsolidateSupplyListForUpsert(List<Weekly_Supply_Consolidated_Id__c> weeklySupplpyConsolidatedList ){        
        Integer totalRecCountForUpdate = weeklySupplpyConsolidatedList.size();
        Integer maxSizeForUpdate = 9900;
        if(totalRecCountForUpdate > maxSizeForUpdate){
            for(Integer i = 0 ; i < (totalRecCountForUpdate / maxSizeForUpdate)+1 ; i++){
                List<Weekly_Supply_Consolidated_Id__c> consolTemp = new  List<Weekly_Supply_Consolidated_Id__c>();
                for(Integer j=(i*maxSizeForUpdate);(j<(i*maxSizeForUpdate)+maxSizeForUpdate) && j<totalRecCountForUpdate ; j++){
                    consolTemp.add(weeklySupplpyConsolidatedList.get(j));
                }
                upsert consolTemp;
            }
        }else{
            upsert weeklySupplpyConsolidatedList;
        }
    }
    // Insert the records to calculate all the shipment allocation done for the week.
    public  boolean upsertAllShipmentSummaryFortheWeek(String weekNumber,Date weekStartDate,Date weekEndDate){
        System.debug('Start Method upsertAllShipmentSummaryFortheWeek'); 
        boolean status = true;
        System.debug(':::weekStartDate:::'+weekStartDate+':::weekEndDate:::'+weekEndDate);
        /****************************START PORTAL SHIPMENT *******************************************/
        System.debug('upsertAllShipmentSummaryFortheWeek::START PORTAL SHIPMENT::'); 
        //Fetching the existing weekly demand data
        Map<string,Weekly_Demand_Summary__c> weekDemandMap  = invAllocMaster.fetchWeeklyDemandSummaryForTheWeekShipmentPortal(weekStartDate,weekEndDate);
        System.debug('upsertAllShipmentSummaryFortheWeek::::weekDemandMap Key::'+weekDemandMap.keySet());
        //Fetching the existing weekly shipment data
        Map<string,Weekly_Shipment_Summary__c> weekShipmentMap = invAllocMaster.fetchWeeklyShipmentSummaryForTheWeekPortal(weekStartDate,weekEndDate);
        
        map<string,string> defaultOrderToCompany = getManitteCompanyMap();
        //Fetching the Old Portal Shipment Details 
        AggregateResult[] portalOrderShipmentDetail = invAllocMaster.fetchShipmentDetailsForPortal(weekStartDate,weekEndDate);
        
        for (AggregateResult portalShipmentDetail : portalOrderShipmentDetail){
            //Generating the key for the Map
            String shipmentKey = String.valueOf(portalShipmentDetail.get('onLineEnquiry'))+'#'+String.valueOf(portalShipmentDetail.get('productName'));
            System.debug('upsertAllShipmentSummaryFortheWeek::PORTAL::shipmentKey::'+shipmentKey);
            System.debug('upsertAllShipmentSummaryFortheWeek::PORTAL::::weekDemandMap Key::'+weekDemandMap.keySet());
            //If the record does not exits then create a new record.
            if(weekDemandMap.containsKey(shipmentKey)){
                System.debug('upsertAllShipmentSummaryFortheWeek::PORTAL::Inside NOT Present::'); 
                Weekly_Demand_Summary__c weekDemandRecord =  weekDemandMap.get(shipmentKey);
                System.debug('weekDemandRecord:'+weekDemandRecord);
                System.debug('upsertAllShipmentSummaryFortheWeek::PORTAL::::weekShipmentMap Key::'+weekShipmentMap.keySet());
                if(!weekShipmentMap.containsKey(weekDemandRecord.Id)){
                    Weekly_Shipment_Summary__c  weeklyShipmentSummary = new Weekly_Shipment_Summary__c();
                    weeklyShipmentSummary.Weekly_Demand_Summary__c = weekDemandRecord.Id;
                    System.debug('PORTAL ORDER TO COMPANY'+weekDemandRecord.Order_to_Company__c);
                    weeklyShipmentSummary.Mainetti_Company__c = weekDemandRecord.Order_to_Company__c;
                    weeklyShipmentSummary.Retailer_Code__c = weekDemandRecord.Retailer_Code__c;
                    weeklyShipmentSummary.Mainetti_Model__c = weekDemandRecord.Mainetti_Model__c;
                    System.debug('PORTAL COLOR'+weekDemandRecord.Color__c);
                    weeklyShipmentSummary.Color__c = weekDemandRecord.Color__c;
                    weeklyShipmentSummary.Sizer_Print__c = weekDemandRecord.Sizer_Print__c;
                    weeklyShipmentSummary.Week_Start_Date__c = weekStartDate;
                    weeklyShipmentSummary.Week_End_Date__c = weekEndDate;
                    weeklyShipmentSummary.Week_Number__c = weekNumber;
                    weeklyShipmentSummary.Quantity__c = Double.valueOf(portalShipmentDetail.get('Quantity'));                
                    weekShipmentMap.put(weekDemandRecord.Id,weeklyShipmentSummary);
                    
                }else{
                    System.debug('upsertAllShipmentSummaryFortheWeek::PORTAL::Inside Present::'); 
                    //getting the updated quantity for the combination of the Key.                    
                    Weekly_Shipment_Summary__c  weeklyShipmentSummary = weekShipmentMap.get(weekDemandRecord.Id);               
                    Double newQuantity = Double.valueOf(portalShipmentDetail.get('Quantity'));                
                    weeklyShipmentSummary.Quantity__c = Double.valueOf(portalShipmentDetail.get('Quantity'));
                    weekShipmentMap.put(weekDemandRecord.Id,weeklyShipmentSummary);
                    
                } 
            }
        }  
        //Fetch the Old Portal Shipment Details
        List<Weekly_Shipment_Summary__c> weeklyShipmentSummaryList = new List<Weekly_Shipment_Summary__c>();
        System.debug('upsertAllShipmentSummaryFortheWeek:: PORTAL SHIPMENT::weekShipmentMap.keySet():::'+weekShipmentMap.keySet());
        for(string shipmentKey : weekShipmentMap.keySet()){            
            Weekly_Shipment_Summary__c  weeklyShipmentSummary = weekShipmentMap.get(shipmentKey);
 			weeklyShipmentSummaryList.add(weeklyShipmentSummary);            
        }
        System.debug('upsertAllShipmentSummaryFortheWeek::END PORTAL SHIPMENT::SIZE:::'+weeklyShipmentSummaryList.size()); 
        /****************************END PORTAL SHIPMENT *******************************************/
        
        /****************************START MagNET SHIPMENT *******************************************/
        System.debug('upsertAllShipmentSummaryFortheWeek::START MagNET SHIPMENT::'); 
        //Fetch the New Portal Order Details from MagNET
        AggregateResult[] magNETShipmentDetailSummary = invAllocMaster.fetchShipmentDetailsForMagNETForTheWeek(weekStartDate,weekEndDate);
        
        //Fetching the salesorders mapping Weekly Demand Ids.
        MAP<ID,ID> salesOrderItemNoDemandIdsMapping = invAllocMaster.fetchSalesOrderItemNumbersForShipmentDoneInTheWeek(weekStartDate,weekEndDate);
        //Fetching all the Existing Shipment details for MagNET for the week
        Map<ID,Weekly_Shipment_Summary__c> existingShipmentSummaryOfShipment = invAllocMaster.fetchWeeklyShipmentSummaryForTheWeekMagNET(weekStartDate,weekEndDate);
         System.debug('existingShipmentSummaryOfShipment:'+existingShipmentSummaryOfShipment);
        for (AggregateResult magNETShipDetail : magNETShipmentDetailSummary){
            String shipmentKey = getShipmentKey(magNETShipDetail);
            
            ID WeeklyDemandSummaryID = salesOrderItemNoDemandIdsMapping.get(String.valueOf(magNETShipDetail.get('SalesOrderItemNumber')));
            System.debug('WeeklyDemandSummaryID:'+WeeklyDemandSummaryID);
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
                weeklyShipmentSummary.Week_Number__c = weekNumber;
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
        /****************************END MagNET SHIPMENT *******************************************/
        try{
            //upsert weeklyShipmentSummaryList;
            splitShipmentListForUpsert(weeklyShipmentSummaryList);
        }catch(DMLException e){
            System.debug('Exception during Upsert of Weekly Shipment Summary '+e.getMessage()); 
            status = false;
        }         
        System.debug('upsertAllShipmentSummaryFortheWeek::Return Status ::'+status); 
        System.debug('End Method upsertAllShipmentSummaryFortheWeek::'); 
        return status;
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
    
    public String getDemandKey(AggregateResult demandOrderDetail){		        
        String demandKey =  String.valueOf(demandOrderDetail.get('OrderToCompany'))+'#'+String.valueOf(demandOrderDetail.get('RetailerName'))+'#'+String.valueOf(demandOrderDetail.get('ModelName'))+'#'+String.valueOf(demandOrderDetail.get('Color'))+'#'+String.valueOf(demandOrderDetail.get('Printer'));
        return demandKey;        
    }
    public String getSupplyKey(AggregateResult supplyOrderDetail){
        String supplyKey =  String.valueOf(supplyOrderDetail.get('OrderToCompany'))+'#'+String.valueOf(supplyOrderDetail.get('RetailerName'))+'#'+String.valueOf(supplyOrderDetail.get('ModelName'))+'#'+String.valueOf(supplyOrderDetail.get('Color'))+'#'+String.valueOf(supplyOrderDetail.get('Printer'));
        return supplyKey;  
    }
    public String getSupplyKeyV2(AggregateResult supplyOrderDetail){
        String supplyKey =  String.valueOf(supplyOrderDetail.get('OrderToCompany'))+'#'+String.valueOf(supplyOrderDetail.get('RetailerName'))+'#'+String.valueOf(supplyOrderDetail.get('ModelName'))+'#'+String.valueOf(supplyOrderDetail.get('Color'))+'#'+String.valueOf(supplyOrderDetail.get('Printer'))+'#'+String.valueOf(supplyOrderDetail.get('Warehouse'));
        return supplyKey;  
    }
    public String getSupplyKeyBatch(AggregateResult supplyOrderDetail){
        map<string,string> defaultOrderToCompany = getManitteCompanyMap();
        String supplyKey =  defaultOrderToCompany.get(String.valueOf(supplyOrderDetail.get('OrderToCompany')))+'#'+String.valueOf(supplyOrderDetail.get('RetailerName'))+'#'+String.valueOf(supplyOrderDetail.get('ModelName'))+'#'+String.valueOf(supplyOrderDetail.get('Color'))+'#'+String.valueOf(supplyOrderDetail.get('Printer'))+'#'+String.valueOf(supplyOrderDetail.get('Warehouse'));        
        System.debug('supplyKey:'+supplyKey);
        return supplyKey; 
        
    }
    
    public String getShipmentKey(AggregateResult shipmentDetail){      
        String shipmentKey =   String.valueOf(shipmentDetail.get('OrderToCompany'))+'#'+String.valueOf(shipmentDetail.get('RetailerName'))+'#'+String.valueOf(shipmentDetail.get('ModelName'))+'#'+String.valueOf(shipmentDetail.get('Color'))+'#'+String.valueOf(shipmentDetail.get('Printer'));
        return shipmentKey;  
    }
    public   map<string,string> getManitteCompanyMap(){
        List<Partner__c> partner = new List<Partner__c>();
        Map<string,string> mainettiCompanyMap = new Map<string,string>();        
        partner = [Select  Name, Default_Order_to_Company__c from Partner__c where Default_Order_to_Company__c != null and Partner_Status__c = 'Active' and  RecordType.Name in('Mainetti Company','Licensee Partner')]; 
        for ( Partner__c ptn : partner ){
            mainettiCompanyMap.put(ptn.Name,ptn.Default_Order_to_Company__c); 
        }             
       return mainettiCompanyMap;
    }
}