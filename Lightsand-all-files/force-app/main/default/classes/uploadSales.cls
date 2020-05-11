public class uploadSales {
    
        //get Inventory Transcation Master Record Status Picklist Values
    @AuraEnabled 
    public static Map<String, String> getRecordStatus(){
        Map<String, String> options = new Map<String, String>();
        //get Account Industry Field Describe
        Schema.DescribeFieldResult fieldResult = Inventory_Transaction_Master__c.Record_Type__c.getDescribe();
        //get Account Industry Picklist Values
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            //Put Picklist Value & Label in Map
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }
    
    //get Inventory Transcation Master Batch Status Picklist Values
    @AuraEnabled 
    public static Map<String, String> getBatchStatus(){
        Map<String, String> options = new Map<String, String>();
        //get Account Industry Field Describe
        Schema.DescribeFieldResult fieldResult = Inventory_Transaction_Master__c.Batch_Status__c.getDescribe();
        //get Account Industry Picklist Values
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            //Put Picklist Value & Label in Map
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }
    
    @AuraEnabled 
    public static Map<String, String> getMainettiMap(){
        getSalesMasterData mainettiMap = new getSalesMasterData();
        return mainettiMap.getManitteCompanyPicklistMap();
    }
    
    @AuraEnabled
    public static List<Inventory_Transaction_Master__c> getDateandTypeRecords(date fromDate, date toDate, string recordStatus, string batchStatus, string mainettiCmp){
        string searchQuery = 'select Id, Batch_No__c, Batch_Status__c, File_Uploaded_By__c, Record_Type__c,Azure_File_Link__c,Mainetti_Company__c from Inventory_Transaction_Master__c';
        if(!String.isBlank(string.valueOf(fromDate)) || !String.isBlank(string.valueOf(toDate))||!String.isBlank(recordStatus)||!String.isBlank(batchStatus)||!String.isBlank(mainettiCmp)){
            searchQuery += ' where ';
        }
        
        boolean dateFieldFrmPresent = false;
        boolean dateFieldToPresent = false;
        boolean recordStatusPresent = false;
        boolean batchStatusPresent = false;
        if(!String.isBlank(string.valueOf(fromDate)) || !String.isBlank(string.valueOf(toDate))){
            if(!String.isBlank(string.valueOf(fromDate)) && !String.isBlank(string.valueOf(toDate))){
                searchQuery += ' DAY_ONLY(CreatedDate) >=:fromDate AND DAY_ONLY(CreatedDate) <=:toDate';       
                dateFieldFrmPresent = true; 
                dateFieldToPresent = true;
            }
            if(!String.isBlank(string.valueOf(fromDate)) && String.isBlank(string.valueOf(toDate))){
                searchQuery += ' DAY_ONLY(CreatedDate) >=:fromDate';
                dateFieldFrmPresent = true;
            }
            if(String.isBlank(string.valueOf(fromDate)) && !String.isBlank(string.valueOf(toDate))){
                searchQuery += ' DAY_ONLY(CreatedDate) >=:toDate';
                dateFieldToPresent = true;
            }            
        }
        if(!String.isBlank(recordStatus)){
            if(dateFieldFrmPresent==true || dateFieldToPresent==true){
            	searchQuery += ' AND Record_Type__c=:recordStatus';
            }else{
                searchQuery += ' Record_Type__c=:recordStatus';
            }
            recordStatusPresent = true;
        }
        if(!String.isBlank(batchStatus)){
            if(dateFieldFrmPresent==true || dateFieldToPresent==true || recordStatusPresent==true ){
                if(batchStatus == '1 - Migration Success'){
                    batchStatus = '8 - Migration Success';
                    searchQuery += ' AND Batch_Status__c=:batchStatus';
                }
                else{
                    batchStatus = '8 - Migration Success';
                    searchQuery += ' AND Batch_Status__c!=:batchStatus';
                }            	
            }else{                
                if(batchStatus == '1 - Migration Success'){
                    batchStatus = '8 - Migration Success';
                    searchQuery += ' Batch_Status__c=:batchStatus';
                }
                else{
                    batchStatus = '8 - Migration Success';
                    searchQuery += ' Batch_Status__c!=:batchStatus';
                } 
            }
            batchStatusPresent = true;
        }
        if(!String.isBlank(mainettiCmp)){
            //system.debug('querymainettiCmp:'+mainettiCmp);
            if(dateFieldFrmPresent==true || dateFieldToPresent==true || recordStatusPresent==true || batchStatusPresent==true){
            	searchQuery += ' AND Mainetti_Company__c=:mainettiCmp';
            }else{
                searchQuery += ' Mainetti_Company__c=:mainettiCmp';
            }
        }
        searchQuery += ' order by CreatedDate';
        //system.debug('query:'+searchQuery);
        List<Inventory_Transaction_Master__c> fetchdata= Database.query(searchQuery);
	    //system.debug('fetchdata:'+fetchdata.size());        
        return fetchdata;
    }
    
    
    //Get data of Inventory_Transaction_Master__c object.
    @AuraEnabled
    public static List<Inventory_Transaction_Master__c> getData(){
        List<Inventory_Transaction_Master__c> fetchdata=[select Id, Batch_No__c, Batch_Status__c, File_Uploaded_By__c, Record_Type__c,Azure_File_Link__c,Mainetti_Company__c,Total_Row_Count__c,Uploaded_Total_Stock_In_Qty__c from Inventory_Transaction_Master__c order by CreatedDate desc];
        return fetchdata;
    }
    
   ///////////////////////////////////////////////////////////////////////////////////////////////  
    //Get error details of Sales_Transaction_Stage__c.
    @AuraEnabled
    public static List<Sales_Transaction_Stage__c> getSalesErrorData(string batchid){
        /*List<Sales_Transaction_Stage__c> fetchErrordata=[Select Country__c,Country_FB__c,Country_NF__c,ExRate_to_EUR_FB__c,ExRate_to_EUR_NF__c,ExRate_to_USD_FB__c,ExRate_to_USD_NF__c,
                                                         	Local_Currency__c,Local_Currency_FB__c,Local_Currency_NF__c,Mainetti_Company__c,MC_NF__c,Manitte_Company_FB__c,Month__c,Month_FB__c,Month_NF__c,Record_Status__c,Remarks__c,
                                                         Retailer_Code__c,Retailer_Code_FB__c,Retailer_Code_NF__c,Row_No__c,Sales_Local__c,Sales_Local_FB__c,SL_NF__c,Sales_Model__c,Sales_Model_FB__c,SM_NF__c,Source__c,Source_FB__c,Source_NF__c,
                                                         	Unit_Sold__c,Unit_Sold_FB__c,US_NF__c,UOM__c,UOM_FB__c,UOM_NF__c,Week__c,Week_FB__c,Week_NF__c,Year__c,Year_FB__c,Year_NF__c,Upload_Batch_No__c
                                                         from Sales_Transaction_Stage__c where  Upload_Batch_No__c=:batchid];
                                                            
        //system.debug('fetchErrordata::'+fetchErrordata.size());*/
        List<Sales_Transaction_Stage__c> fetchErrordata;
        return fetchErrordata;
    }
    
    public static List<Sales_Transaction_Stage__c> getSalesSuccessData(string batchid){
        /*List<Sales_Transaction_Stage__c> fetchSuccessdata=[Select Country__c,Country_FB__c,Country_NF__c,ExRate_to_EUR_FB__c,ExRate_to_EUR_NF__c,ExRate_to_USD_FB__c,ExRate_to_USD_NF__c,
                                                         	Local_Currency__c,Local_Currency_FB__c,Local_Currency_NF__c,Mainetti_Company__c,MC_NF__c,Manitte_Company_FB__c,Month__c,Month_FB__c,Month_NF__c,Record_Status__c,Remarks__c,
                                                         Retailer_Code__c,Retailer_Code_FB__c,Retailer_Code_NF__c,Row_No__c,Sales_Local__c,Sales_Local_FB__c,SL_NF__c,Sales_Model__c,Sales_Model_FB__c,SM_NF__c,Source__c,Source_FB__c,Source_NF__c,
                                                         	Unit_Sold__c,Unit_Sold_FB__c,US_NF__c,UOM__c,UOM_FB__c,UOM_NF__c,Week__c,Week_FB__c,Week_NF__c,Year__c,Year_FB__c,Year_NF__c,Upload_Batch_No__c
                                                         from Sales_Transaction_Stage__c where  Upload_Batch_No__c=:batchid and Record_Status__c ='2 - Data Validation Successful']; 
        //ExRate_to_EUR__c,ExRate_to_USD__c
        //system.debug('fetchErrordata::'+fetchErrordata.size());*/
        List<Sales_Transaction_Stage__c> fetchSuccessdata;
        return fetchSuccessdata;
    }
    
    @AuraEnabled
    public static boolean createDocument(string csv, string batchNo,String fileName) { 
        
        boolean createStatus = new getMasterData().createDocument(batchNo,csv,fileName);
        system.debug('createDocumentcreateStatus::'+createStatus);
        return createStatus;
    }
    
    @AuraEnabled
    public static String parseSales(string jsonin, string batchNo, string recordType, string company) {  
        system.debug('inside parseSales');
        string returnBatchId = '';
        Inventory_Transaction_Master__c updateBatchStatus = new Inventory_Transaction_Master__c();
        boolean recordStatus = true;                
        if(!string.isBlank(batchNo)){
            List<Sales_Transaction_Stage__c> fetchErrordata=[Select Id,Mainetti_Company__c from Sales_Transaction_Stage__c where Upload_Batch_No__c=:batchNo];
              updateBatchStatus =[Select Id, Mainetti_Company__c from Inventory_Transaction_Master__c where Id=:batchNo];
            if(fetchErrordata.size() > 0)
            {                
                try{
                    delete fetchErrordata;
                    boolean status=insertSalesStage(jsonin,batchNo);
                    if(!status){           
                        recordStatus = false;                        
                    }
                }catch(Exception e){   
                    recordStatus = false;
                    system.debug('Error in parse: deleting stage records:'+e.getMessage());
                }                
            }            
        }else{              
            if(recordStatus){
                try{
                    Inventory_Transaction_Master__c Transactions = new Inventory_Transaction_Master__c();
                    Transactions.File_Uploaded_By__c = userInfo.getFirstName() + ','+ userInfo.getLastName();
                    Transactions.Record_Type__c = recordType;
                    Transactions.Mainetti_Company__c = company;
                    insert Transactions;
                    boolean status=insertSalesStage(jsonin,Transactions.Id);
                    if(!status){           
                        recordStatus = false;                        
                    }
                    updateBatchStatus.Id=Transactions.Id;
                }catch(DMLException e){   
                    recordStatus = false;
                    system.debug('Error in parse : during batch creation:'+e.getMessage());
                }
            }            
        }
        if(recordStatus){
            try{
                returnBatchId = updateBatchStatus.Id;
                updateBatchStatus.Batch_Status__c='2 - Data Validation In Progress';  
                updateBatchStatus.Mainetti_Company__c = company;
                update updateBatchStatus;
                boolean validateStatus = new processSalesData().validateUploadRows(updateBatchStatus);
                //system.debug('validateStatus::::'+validateStatus);
                if(!validateStatus){
                    updateBatchStatus.Batch_Status__c='3 - Error In Data Validation';   
                    update updateBatchStatus;
                    List<Sales_Transaction_Stage__c> transferRecords =  getSalesErrorData(updateBatchStatus.Id);
                    //failure records are there,data validation validation failure.
                    if(transferRecords.size() > 0){
                        recordStatus = false;              
                    }
                }/*else{
                    recordStatus = false; 
                } */   
            }catch(DMLException e){   
                recordStatus = false;
                system.debug('Error in parse: during data validation:'+e.getMessage());
            }
        }   
        if(!recordStatus){
            returnBatchId = '';
        }
        return returnBatchId;
    }
    
        //insert stage records into MaterialPricing_Transaction_Stage__c
        public static boolean insertSalesStage(string jsonin, string batchNo){
        system.debug('inside insertSalesStage');
        boolean insertStatus = true;
        List<Sales_Transaction_Stage__c> deserializedSales = (List<Sales_Transaction_Stage__c>)JSON.deserialize(jsonin, List<Sales_Transaction_Stage__c>.class);
        List<Sales_Transaction_Stage__c> transbatchid = new  List<Sales_Transaction_Stage__c>();
        double rowNo = 1;
        double firstRowCount = 1;
        if(deserializedSales.size() >0){
        double inputFileRowCount = deserializedSales.size();
        /*for(Sales_Transaction_Stage__c trans: deserializedSales){
            //if(firstRowCount != 1 ){
            if((inputFileRowCount)== rowNo){
                if(string.isBlank(trans.Retailer_Code__c) && string.isBlank(trans.Mainetti_Company__c) && string.isBlank(trans.Sales_Model__c) && string.isBlank(trans.Country__c) && string.isBlank(trans.Unit_Sold__c) && string.isBlank(trans.Sales_Local__c) && string.isBlank(trans.Local_Currency__c) && string.isBlank(trans.Source__c) && string.isBlank(trans.UOM__c) && string.isBlank(trans.Year__c) && string.isBlank(trans.Month__c) && string.isBlank(trans.Week__c))
                //&& string.isBlank(trans.ExRate_to_EUR__c) && string.isBlank(trans.ExRate_to_USD__c)
                {}else{
                    trans.Row_No__c =rowNo;
                    trans.Upload_Batch_No__c = batchNo;
                    transbatchid.add(trans);
                    rowNo++;
                }               
            }else{             
                trans.Row_No__c =rowNo;
                trans.Upload_Batch_No__c = batchNo;
                transbatchid.add(trans);
                rowNo++;                
            //}
            //firstRowCount++;
             }
        }*/
        }
        try{
            if(transbatchid.size()>0){                
                insert transbatchid;
            }else {
                insertStatus = false;
            }
        }catch(DMLException e){   
            system.debug('Error in insertSalesStage: during DataUploadSales'+e.getMessage());
            insertStatus = false;
        }
        return insertStatus;      
    }
    
        public boolean insertDataUploadSales(Inventory_Transaction_Master__c updateBatchStatus){
        system.debug('inside datauploadsales');
        boolean insertStatus = true;
        getSalesMasterData masterData = new getSalesMasterData();
        processSalesData processsalesData = new processSalesData();
        map<string,Id> retailerCodeWithId = masterData.getRetailerCodeIdMap();        
        map<string,Id> mainettiCompanyWithId = masterData.getManitteCompanyIdMap();       
        List<Sales_Transaction_Stage__c> transferRecords =  getSalesSuccessData(updateBatchStatus.Id);
        List<Data_Upload_Sales__c> insertRecord = new List<Data_Upload_Sales__c>();
        if(transferRecords.size() > 0){
            //Map<string,string> invTransOrderToCompMap = masterData.getListOfTransManitteCompany(updateBatchStatus.Id);
            //Map<string,Map<string,string>> modelPriceMap = masterData.getRTSModelMap(updateBatchStatus);
            //Map<string,string> rtsPriceMap = modelPriceMap.get('Price');            
            updateBatchStatus.Batch_Status__c = '7 - Migration In Progress';
            update updateBatchStatus;
            
            for(Sales_Transaction_Stage__c trans: transferRecords){
                Data_Upload_Sales__c invTransMast = new Data_Upload_Sales__c();
                invTransMast.Upload_Batch_No__c = trans.Upload_Batch_No__c;
                invTransMast.Record_Type__c = updateBatchStatus.Record_Type__c;
                invTransMast.Retailer_Code__c = retailerCodeWithId.get(trans.Retailer_Code__c.toLowerCase());
                invTransMast.Mainetti_Company__c = mainettiCompanyWithId.get(trans.Mainetti_Company__c.toLowerCase());
                invTransMast.Country__c = trans.Country__c;
                //invTransMast.Sales_Model__c = trans.Sales_Model__c;
                invTransMast.Source__c = trans.Source__c ;
                //invTransMast.Unit_Sold__c = trans.Unit_Sold__c;
                invTransMast.Sales_Local__c = trans.Sales_Local__c;
                invTransMast.Local_Currency__c = trans.Local_Currency__c;
                //invTransMast.ExRate_to_EUR__c = trans.ExRate_to_EUR__c;
                //invTransMast.ExRate_to_USD__c = trans.ExRate_to_USD__c;
                invTransMast.UOM__c = trans.UOM__c;
                invTransMast.Year__c = trans.Year__c;
                invTransMast.Month__c = trans.Month__c;
                invTransMast.Week__c = trans.Week__c;              
                insertRecord.add(invTransMast);
            }
            if(insertRecord.size()>0){
                try{
                    insert insertRecord;
                    delete transferRecords;
                }catch(DMLException e){   
                    insertStatus = false;
                    system.debug('Error in insertDataUploadSales: during DataUploadSales'+e.getMessage());
                }
            }            
        }
        return insertStatus;
    }
    
    public  void insertTestToData(String batchId){
        Inventory_Transaction_Master__c invTransMaster = [Select Id, Batch_No__c, Batch_Status__c,Record_Type__c  from Inventory_Transaction_Master__c where Id =:batchId];
        if(invTransMaster != null){
            boolean status  = new uploadInventry().insertDataUploadTransaction(invTransMaster);
        }
    }

}