global class SupplySummaryForTheWeekbatchClass implements Database.Batchable<sObject>{
    global List<AggregateResult> stockVirginList {get; set;} 
    global List<AggregateResult> stockReuseList {get; set;} 
    global Iterable<SObject> fetchWeeklySupplySummaryForTheWeek {get; set;} 
    
    
    global SupplySummaryForTheWeekbatchClass(List<AggregateResult> stockVirginList,List<AggregateResult> stockReuseList){ 
        this.stockVirginList = stockVirginList; 
        this.stockReuseList = stockReuseList;
    } 
    global Iterable<Sobject> start(Database.batchableContext bc) {
        System.debug('############# INSIDE START OF StartSupplySummaryForTheWeekbatchClass SUPPLY METHOD ##############');
        return (Iterable<SObject>) new SupplySummaryForTheWeekIterable();       
    }    
    global void execute(Database.BatchableContext BC, List<Sobject> scope) {
        System.debug('::::::::::INSIDE THE EXECUTE METHOD OF SUPPLY::::::::::::::::::::');
        List<Weekly_Supply_Summary__c> supplyVirginSummaryList =existingSupplyVirginSummaryForTheWeek ();
        List<Weekly_Supply_Summary__c> supplyReuseSummaryList = existingSupplyReuseSummaryForTheWeek ();
        List<Weekly_Supply_Consolidated_Id__c> weeklySupplyConsIdsObj = existingSupplyConsolidateIdsForTheWeek ();
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
        
        ///////////////////////// Start Processing /////////////////////////////////
        System.debug('Start Method upsertAllSupplySummaryFortheWeek'); 
        Date startdate = date.today();
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        System.debug(':::weekStartDate:::'+weekStartDate+':::weekEndDate:::'+weekEndDate);        
        //Fetch the Old Portal Order Details
        List<Weekly_Supply_Summary__c> weeklySupplySummaryList = new List<Weekly_Supply_Summary__c>();
        
        //Fetching the existing weeks Virgin data
        Map<string,Weekly_Supply_Summary__c> weekVirginMap = fetchWeeklySupplyVirginSummaryForTheWeek(supplyVirginSummaryList);
        //fetching all the data upload Ids for which consoldition is taken place for the week
        Map<string,string> conDataUploadIdsMap = fetchWeeklyDataUploadIdForTheWeek(weeklySupplyConsIdsObj);
        
        Map<string,Map<string,string>> dataUploadIdsMap = new Map<string,Map<string,string>>();
        map<string,string> defaultOrderToCompany = getManitteCompanyMap(partnerList);
        System.debug('##################################################defaultOrderToCompany'+defaultOrderToCompany);
        //Fetching the stock On Hand for Virgin 
        AggregateResult[] stockOnHandVirginSummary = stockVirginList;
        for (AggregateResult stockOnHandVirgin : stockOnHandVirginSummary){
            String supplyKey = getSupplyKeyBatch(stockOnHandVirgin,partnerList);
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
                //weeklySupplySummary.Week_Number__c = weekNumber;
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
        Map<string,Weekly_Supply_Summary__c> weekReuseMap = fetchWeeklySupplyReuseSummaryForTheWeek(supplyReuseSummaryList);    
        ////Fetch the stock on Hand for Reuse
        AggregateResult[] stockOnHandReuseSummary = stockReuseList;
        for (AggregateResult stockOnHandReuse : stockOnHandReuseSummary){
            String supplyKey = getSupplyKeyBatch(stockOnHandReuse,partnerList);
            System.debug('upsertAllSupplySummaryFortheWeek:::supplyKey REUSE:::'+supplyKey); 
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
                //weeklySupplySummary.Week_Number__c = weekNumber;
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
        }            
        System.debug('End Method upsertAllSupplySummaryFortheWeek:::');
         
        /*************************End of Processing****************************/
    }
    global void finish(Database.BatchableContext BC){
        System.debug('::::::::::INSIDE THE FINISH METHOD OF SUPPLY::::::::::::::::::::');
    }
    
    //Fetching all the supply details for Virgin
    public Map<string,Weekly_Supply_Summary__c> fetchWeeklySupplyVirginSummaryForTheWeek(List<Weekly_Supply_Summary__c> weeklySupplySummary){
        System.debug('Start Method fetchWeeklySupplyVirginSummaryForTheWeek');               
        //********************************************************************************************************//
        Map<string,Weekly_Supply_Summary__c> weeklySupplyMap = new Map<string,Weekly_Supply_Summary__c>();
        System.debug('fetchWeeklySupplyVirginSummaryForTheWeek::weeklySupplySummary'+weeklySupplySummary.size());  
        for (Weekly_Supply_Summary__c weeklySupply : weeklySupplySummary){
            weeklySupply.Quantity__c = 0;
            String supplyKey =  weeklySupply.Mainetti_Company__c+'#'+weeklySupply.Retailer_Code__r.Name+'#'+weeklySupply.Mainetti_Model__r.Name+'#'+weeklySupply.Color__c+'#'+weeklySupply.Sizer_Print__c+'#'+weeklySupply.Warehouse__c;            
            System.debug('############# supplyKey'+supplyKey);
            weeklySupplyMap.put(supplyKey,weeklySupply);
        }
        System.debug('fetchWeeklySupplyVirginSummaryForTheWeek::weeklySupplyMap'+weeklySupplyMap);
        System.debug('End Method fetchWeeklySupplyVirginSummaryForTheWeek');  
        return weeklySupplyMap;
    }

     public Map<string,string> fetchWeeklyDataUploadIdForTheWeek(List<Weekly_Supply_Consolidated_Id__c> weeklyDataUploadIds){   
        System.debug('Start Method fetchWeeklyDataUploadIdForTheWeek');
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
     //Fetching all the supply details for Reuse
    public Map<string,Weekly_Supply_Summary__c> fetchWeeklySupplyReuseSummaryForTheWeek(List<Weekly_Supply_Summary__c> weeklySupplySummary){        
        System.debug('Start Method fetchWeeklySupplyReuseSummaryForTheWeek');  
       
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
    public String getSupplyKey(AggregateResult supplyOrderDetail){
        String supplyKey =  String.valueOf(supplyOrderDetail.get('OrderToCompany'))+'#'+String.valueOf(supplyOrderDetail.get('RetailerName'))+'#'+String.valueOf(supplyOrderDetail.get('ModelName'))+'#'+String.valueOf(supplyOrderDetail.get('Color'))+'#'+String.valueOf(supplyOrderDetail.get('Printer'))+'#'+String.valueOf(supplyOrderDetail.get('Warehouse'));
        return supplyKey;  
    }
    public String getSupplyKeyBatch(AggregateResult supplyOrderDetail,List<Partner__c> partner){
        map<string,string> defaultOrderToCompany = getManitteCompanyMap(partner);
        String supplyKey =  defaultOrderToCompany.get(String.valueOf(supplyOrderDetail.get('OrderToCompany')))+'#'+String.valueOf(supplyOrderDetail.get('RetailerName'))+'#'+String.valueOf(supplyOrderDetail.get('ModelName'))+'#'+String.valueOf(supplyOrderDetail.get('Color'))+'#'+String.valueOf(supplyOrderDetail.get('Printer'))+'#'+String.valueOf(supplyOrderDetail.get('Warehouse'));
	//	String supplyKey =  defaultOrderToCompany.get(String.valueOf(supplyOrderDetail.get('OrderToCompany')))+'#'+String.valueOf(supplyOrderDetail.get('RetailerName'))+'#'+String.valueOf(supplyOrderDetail.get('ModelName'))+'#'+String.valueOf(supplyOrderDetail.get('Color'))+'#'+String.valueOf(supplyOrderDetail.get('Printer'));                
        return supplyKey;  
    }
   
    public   map<string,string> getManitteCompanyMap(List<Partner__c> partner){        
        Map<string,string> mainettiCompanyMap = new Map<string,string>();           
        for ( Partner__c ptn : partner ){
            mainettiCompanyMap.put(ptn.Name,ptn.Default_Order_to_Company__c); 
        }             
       return mainettiCompanyMap;
    }
    public List<Weekly_Supply_Summary__c> existingSupplyVirginSummaryForTheWeek(){
         System.debug('Start existingSupplyVirginSummaryForTheWeek');
        Date startdate = date.today();
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
         
        List<Weekly_Supply_Summary__c> sobjs = new List<Weekly_Supply_Summary__c>();
        List<Weekly_Supply_Summary__c> supplyVirginSummary = [Select Id,Mainetti_Company__c , Retailer_Code__r.Name ,Mainetti_Model__r.Name,Color__c ,Sizer_Print__c,Warehouse__c FROM Weekly_Supply_Summary__c  WHERE Source__c='Virgin' AND  Week_Start_Date__c >=:weekStartDate AND Week_End_Date__c <=:weekEndDate]; 
       for( Weekly_Supply_Summary__c supplyVirgin : supplyVirginSummary ) {
           sobjs.add(supplyVirgin);
       }
       integer supplyVirginSummarySize = sobjs.size();
       System.debug('##### existingSupplyVirginSummaryForTheWeek:::: Weekly_Supply_Summary__c: VIRGIN:::SIZE'+supplyVirginSummarySize);
        return sobjs;
    }
    public List<Weekly_Supply_Summary__c> existingSupplyReuseSummaryForTheWeek(){
         System.debug('Start existingSupplyReuseSummaryForTheWeek');
        Date startdate = date.today();
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
       List<Weekly_Supply_Summary__c> sobjs = new List<Weekly_Supply_Summary__c>();
                                                              
       List<Weekly_Supply_Summary__c> supplyReuseSummary = [Select Id, Mainetti_Company__c , Retailer_Code__r.Name ,Mainetti_Model__r.Name,Color__c ,Sizer_Print__c,Warehouse__c FROM Weekly_Supply_Summary__c  WHERE Source__c='Reuse' AND Week_Start_Date__c >=:weekStartDate AND Week_End_Date__c <=:weekEndDate]; 
       for( Weekly_Supply_Summary__c supplyRuse : supplyReuseSummary ) {
           sobjs.add(supplyRuse);
       }
       integer supplyReuseSummarySize = sobjs.size() ;
       System.debug('##### existingSupplyReuseSummaryForTheWeek:::: Weekly_Supply_Summary__c: Reuse:::SIZE'+supplyReuseSummarySize);
        return sobjs;
    }
    public List<Weekly_Supply_Consolidated_Id__c> existingSupplyConsolidateIdsForTheWeek(){
        System.debug('Start existingSupplyConsolidateIdsForTheWeek');
        Date startdate = date.today();
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
       List<Weekly_Supply_Consolidated_Id__c> sobjs = new List<Weekly_Supply_Consolidated_Id__c>();
        
       List<Weekly_Supply_Consolidated_Id__c> consId = [SELECT Data_Upload_Transaction__c	 FROM Weekly_Supply_Consolidated_Id__c WHERE Week_Start_Date__c >=:weekStartDate AND Week_End_Date__c <=:weekEndDate]; 
       for( Weekly_Supply_Consolidated_Id__c con : consId ) {
           sobjs.add(con);
       }
         integer supplyConsSize = sobjs.size();
                                                        
        System.debug('##### existingSupplyConsolidateIdsForTheWeek:::: Weekly_Supply_Consolidated_Id__c::::SIZE'+supplyConsSize);
        return sobjs;  
    }
}