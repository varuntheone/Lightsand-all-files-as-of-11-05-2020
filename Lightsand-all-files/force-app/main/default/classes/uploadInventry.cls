public class uploadInventry {
    
    @AuraEnabled
    public static Integer dataSubmitted(string companyArray, string selmonth, string selyear)
    {
        List<string> companyList = companyArray.split(',');
        Set<String> companyName = new Set<String>();
        for (string valFormt : companyList){
            if(string.isNotBlank(valFormt)){
                companyName.add(valFormt);
                system.debug('companyList'+companyList);
                system.debug('companyName'+companyName);
            }
        }   
        List<Data_Upload_Sales__c> fetchData = [select Sales_Data_Company__c,Month__c,Year__c from  Data_Upload_Sales__c where Sales_Data_Company__c IN:companyName and Month__c =: selmonth and Year__c =: selyear LIMIT 1 ];
        system.debug('fetchData'+fetchData);
        Integer fetchdataSize = fetchData.size();
        system.debug('fetchdataSize'+fetchdataSize);
        return fetchdataSize;        
    }
    
    //get Inventory Transcation Master Record Status Picklist Values
    @AuraEnabled 
    public static Map<String, String> getRecordStatus(){
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Inventory_Transaction_Master__c.Record_Type__c.getDescribe();
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
        Schema.DescribeFieldResult fieldResult = Inventory_Transaction_Master__c.Batch_Status__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            //Put Picklist Value & Label in Map
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }
    
    @AuraEnabled 
    public static Map<String, String> getMainettiMap(){
        getMasterData mainettiMap = new getMasterData();
        return mainettiMap.getManitteCompanyPicklistMap();
    }    
    @AuraEnabled
    public static List<Inventory_Transaction_Master__c> getDateandTypeRecords(date fromDate, date toDate, string recordStatus, string batchStatus, string mainettiCmp){
        string searchQuery = 'select Id, Batch_No__c, Batch_Status__c, File_Uploaded_By__c, Record_Type__c,Azure_File_Link__c,Mainetti_Company__c,Total_Row_Count__c,Uploaded_Total_Stock_In_Qty__c,company_week__c,Batch_Process__c,CreatedDate from Inventory_Transaction_Master__c';
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
            if(dateFieldFrmPresent==true || dateFieldToPresent==true || recordStatusPresent==true || batchStatusPresent==true){
                searchQuery += ' AND Mainetti_Company__c=:mainettiCmp';
            }else{
                searchQuery += ' Mainetti_Company__c=:mainettiCmp';
            }
        }
        searchQuery += ' order by CreatedDate';
        List<Inventory_Transaction_Master__c> fetchdata= Database.query(searchQuery);     
        return fetchdata;
    }
    
    @AuraEnabled
    public static List<Inventory_Transaction_Master__c> getSalesSearchRecords(date fromDate, date toDate, string recordStatus, string batchStatus, string batchNo){
        string searchQuery = 'select Id, Batch_No__c, Batch_Status__c, File_Uploaded_By__c, Record_Type__c,Azure_File_Link__c,Mainetti_Company__c,Total_Row_Count__c,Uploaded_Total_Stock_In_Qty__c,company_week__c,Batch_Process__c,CreatedDate from Inventory_Transaction_Master__c';
        if(!String.isBlank(string.valueOf(fromDate)) || !String.isBlank(string.valueOf(toDate))||!String.isBlank(recordStatus)||!String.isBlank(batchStatus)||!String.isBlank(batchNo)){
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
        if(!String.isBlank(batchNo)){
            if(dateFieldFrmPresent==true || dateFieldToPresent==true || recordStatusPresent==true || batchStatusPresent==true){
                searchQuery += ' AND Batch_No__c=:batchNo';
            }else{
                searchQuery += ' Batch_No__c=:batchNo';
            }
        }
        searchQuery += ' order by CreatedDate';
        List<Inventory_Transaction_Master__c> fetchdata= Database.query(searchQuery);      
        return fetchdata;
    }
    
    @AuraEnabled
    public static List<Inventory_Transaction_Master__c> getCompanyWeekData(string batchid){
        List<Inventory_Transaction_Master__c> companyWeekData=[Select company_week__c from Inventory_Transaction_Master__c where Id=:batchid];
        return companyWeekData;
    } 
    
    //Get data of Inventory_Transaction_Master__c object.
    @AuraEnabled
    public static List<Inventory_Transaction_Master__c> getData(){
        string searchQuery = 'select Id, Reprocessing__c,Batch_No__c, Batch_Status__c, File_Uploaded_By__c, Record_Type__c,Azure_File_Link__c,Mainetti_Company__c,Total_Row_Count__c,Uploaded_Total_Stock_In_Qty__c,company_week__c,Batch_Process__c,CreatedDate,Sales_Company__c,Sales_Month__c,Sales_Year__c from Inventory_Transaction_Master__c'; 
        string appName = 'InventoryUpload';
        System.debug('appName:'+appName);
        if(String.isNotBlank(appName)){
            if(appName.equals('SalesUpload')){
                string itsSales = 'Sales';
                searchQuery += ' where Record_Type__c =: itsSales';
            }else if(appName.equals('InventoryUpload')){
                string itsInventory = 'Inventory';
                searchQuery += ' where Record_Type__c =: itsInventory';
            }
            searchQuery += ' order by CreatedDate desc LIMIT 25';
        }
        List<Inventory_Transaction_Master__c> fetchdata= Database.query(searchQuery);
        return fetchdata;
    }  
    
    @AuraEnabled
    public static List<Inventory_Transaction_Master__c> getSalesData(){
        string searchQuery = 'select Id, Batch_No__c, Reprocessing__c,Batch_Status__c, File_Uploaded_By__c, Record_Type__c,Azure_File_Link__c,Mainetti_Company__c,Total_Row_Count__c,Uploaded_Total_Stock_In_Qty__c,company_week__c,Sales_Company__c,Sales_Month__c,Sales_Market__c,Batch_Process__c,CreatedDate from Inventory_Transaction_Master__c'; 
        string appName = 'SalesUpload';
        System.debug('appName:'+appName);
        if(String.isNotBlank(appName)){
            if(appName.equals('SalesUpload')){
                string itsSales = 'Sales';
                searchQuery += ' where Record_Type__c =: itsSales';
            }else if(appName.equals('InventoryUpload')){
                string itsInventory = 'Inventory';
                searchQuery += ' where Record_Type__c =: itsInventory';
            }
            searchQuery += ' order by CreatedDate desc LIMIT 25';
        }
        List<Inventory_Transaction_Master__c> fetchdata= Database.query(searchQuery);
        return fetchdata;
    }  
    
    @AuraEnabled
    public static List<integer> getPreviousYear() {
        List<integer> prevYear = new List<integer>();
        Integer currentYear = System.Today().year();
        prevYear.add(currentYear);
        prevYear.add(currentYear-1);
        return prevYear;        
    }    
    //Get error details of Inventory_Transaction_Stage__c.
    @AuraEnabled
    public static List<Inventory_Transaction_Stage__c> getErrorData(string batchid){
        List<Inventory_Transaction_Stage__c> fetchErrordata=[Select Warehouse__c,Warehouse_FB__c,Warehouse_NF__c,Color__c,Color_FB__c,Color_NF__c,Inventory_Model__c,Inventory_Model_FB__c,Inventory_Model_NF__c,Name,Local_System_SKU__c,Mainetti_Company__c,MC_NF__c,Manitte_Company_FB__c,Price_Book_Spec_NF__c,
                                                             Record_Status__c,Remarks__c,Retailer_Code__c,Retailer_Code_FB__c,Retailer_Code_NF__c,Row_No__c,Sizer_Print__c,Sizer_Print_NF__c,Source__c,Source_FB__c,Stock_In_Date__c,Stock_In_Date_FB__c,Stock_In_Qty__c,Stock_In_Qty_FB__c,Upload_Batch_No__c,Source_NF__c from Inventory_Transaction_Stage__c where
                                                             Upload_Batch_No__c=:batchid];
        return fetchErrordata;
    }
    
    public static List<Inventory_Transaction_Stage__c> getSuccessData(string batchid){
        List<Inventory_Transaction_Stage__c> fetchSuccessdata=[Select Warehouse__c,Warehouse_FB__c,Warehouse_NF__c,Color__c,Color_FB__c,Color_NF__c,Inventory_Model__c,Inventory_Model_FB__c,Inventory_Model_NF__c,Name,Local_System_SKU__c,Mainetti_Company__c,MC_NF__c,Manitte_Company_FB__c,Price_Book_Spec_NF__c,
                                                               Record_Status__c,Remarks__c,Retailer_Code__c,Retailer_Code_FB__c,Retailer_Code_NF__c,Row_No__c,Sizer_Print__c,Sizer_Print_NF__c,Source__c,Source_FB__c,Stock_In_Date__c,Stock_In_Date_FB__c,Stock_In_Qty__c,Stock_In_Qty_FB__c,Upload_Batch_No__c,Source_NF__c from Inventory_Transaction_Stage__c where
                                                               Upload_Batch_No__c=:batchid and Record_Status__c ='2 - Data Validation Successful'];
        return fetchSuccessdata;
    }    
    @AuraEnabled
    public static boolean createDocument(string csv, string batchNo,String fileName) { 
        boolean createStatus = new getMasterData().createDocument(batchNo,csv,fileName);
        return createStatus;
    }    
    //Inserting records into both the objects.
    @AuraEnabled
    public static String parseInventory(string jsonin, string batchNo, string recordType, string company) {  
        string returnBatchId = '';
        Inventory_Transaction_Master__c updateBatchStatus = new Inventory_Transaction_Master__c();
        boolean recordStatus = true;                
        if(!string.isBlank(batchNo)){
            List<Inventory_Transaction_Stage__c> fetchErrordata=[Select Id,Mainetti_Company__c from Inventory_Transaction_Stage__c where Upload_Batch_No__c=:batchNo];
            updateBatchStatus =[Select Id, Mainetti_Company__c from Inventory_Transaction_Master__c where Id=:batchNo];
            if(fetchErrordata.size() > 0)
            {                
                try{
                    delete fetchErrordata;
                    boolean status=insertInventoryStage(jsonin,batchNo);
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
                    boolean status=insertInventoryStage(jsonin,Transactions.Id);
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
                boolean validateStatus = new processInventoryData().validateUploadRows(updateBatchStatus);
                if(!validateStatus){
                    updateBatchStatus.Batch_Status__c='3 - Error In Data Validation';   
                    update updateBatchStatus;
                    List<Inventory_Transaction_Stage__c> transferRecords =  getErrorData(updateBatchStatus.Id);
                    //failure records are there,data validation failure.
                    if(transferRecords.size() > 0){
                        recordStatus = false;              
                    }
                } 
            }catch(DMLException e){   
                recordStatus = false;
                system.debug('Error in parse: during data validation:'+e.getMessage());
            }
        }   
        if(!recordStatus){
            returnBatchId = returnBatchId+'#PWWWW';
        }
        return returnBatchId;
    }	
    public boolean insertDataUploadTransaction(Inventory_Transaction_Master__c updateBatchStatus){
        
        boolean insertStatus = true;
        getMasterData masterData = new getMasterData();
        processInventoryData processInvData = new processInventoryData();
        map<string,Id> retailerCodeWithId = masterData.getRetailerCodeIdMap();        
        map<string,Id> mainettiCompanyWithId = masterData.getManitteCompanyIdMap();       
        List<Inventory_Transaction_Stage__c> transferRecords =  getSuccessData(updateBatchStatus.Id);
        List<Data_Upload_Transaction__c> insertRecord = new List<Data_Upload_Transaction__c>();
        if(transferRecords.size() > 0){
            Map<string,Map<string,string>> modelPriceMap = masterData.getRTSModelMap(updateBatchStatus);
            Map<string,string> rtsPriceMap = modelPriceMap.get('Price');            
            updateBatchStatus.Batch_Status__c = '7 - Migration In Progress';
            update updateBatchStatus;
            
            for(Inventory_Transaction_Stage__c trans: transferRecords){
                Data_Upload_Transaction__c invTransMast = new Data_Upload_Transaction__c();
                invTransMast.Upload_Batch_No__c = trans.Upload_Batch_No__c;
                invTransMast.Record_Type__c = updateBatchStatus.Record_Type__c;                
                invTransMast.Retailer_Code__c = retailerCodeWithId.get(trans.Retailer_Code__c.toLowerCase());
                invTransMast.Mainetti_Company__c = mainettiCompanyWithId.get(trans.Mainetti_Company__c.toLowerCase());
                string pricbookspec = '';
                if(trans.Retailer_Code__c == 'LOJAS RENNER'){
                    pricbookspec = trans.Inventory_Model__c+'#'+trans.Retailer_Code__c+'#'+trans.Mainetti_Company__c+'#'+trans.Color__c+'#'+trans.Sizer_Print__c;
                }else{
                    pricbookspec =  trans.Inventory_Model__c+'#'+trans.Retailer_Code__c+'#'+trans.Mainetti_Company__c+'#'+trans.Color__c;
                }               
                String inventoryModal =  rtsPriceMap.get(pricbookspec.toLowerCase()); 
                invTransMast.Inventory_Model__c = inventoryModal;
                invTransMast.Warehouse__c = trans.Warehouse__c;
                invTransMast.Color__c = trans.Color__c;
                invTransMast.Sizer_Print__c = trans.Sizer_Print__c;
                invTransMast.Local_System_SKU__c = trans.Local_System_SKU__c;
                invTransMast.Source__c = trans.Source__c;
                invTransMast.Stock_In_Date__c =processInvData.parseLongDate(trans.Stock_In_Date__c);
                invTransMast.Stock_In_Qty__c = Decimal.valueOf(trans.Stock_In_Qty__c);                
                insertRecord.add(invTransMast);
            }
            if(insertRecord.size()>0){
                try{
                    insert insertRecord;
                    delete transferRecords;
                }catch(DMLException e){   
                    insertStatus = false;
                    system.debug('Error in insertDataUploadTransaction: during DataUploadTransaction'+e.getMessage());
                }
            }            
        }
        return insertStatus;
    }
    
    public static boolean insertInventoryStage(string jsonin, string batchNo){
        boolean insertStatus = true;
        List<Inventory_Transaction_Stage__c> deserializedInventory = (List<Inventory_Transaction_Stage__c>)JSON.deserialize(jsonin, List<Inventory_Transaction_Stage__c>.class);
        List<Inventory_Transaction_Stage__c> transbatchid = new  List<Inventory_Transaction_Stage__c>();
        double rowNo = 1;
        double firstRowCount = 1;
        
        if(deserializedInventory.size() >0){
            double inputFileRowCount = deserializedInventory.size();
            for(Inventory_Transaction_Stage__c trans: deserializedInventory){                
                if((inputFileRowCount)== rowNo){
                    if(string.isBlank(trans.Retailer_Code__c) && string.isBlank(trans.Mainetti_Company__c) && string.isBlank(trans.Inventory_Model__c) && string.isBlank(trans.Color__c) && string.isBlank(trans.Sizer_Print__c) && string.isBlank(trans.Warehouse__c) && string.isBlank(trans.Local_System_SKU__c) && string.isBlank(trans.Source__c) && string.isBlank(trans.Stock_In_Date__c) && string.isBlank(trans.Stock_In_Qty__c))
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
                }
            }
        }
        try{
            if(transbatchid.size()>0){                
                insert transbatchid;
            }else {
                insertStatus = false;
            }
        }catch(DMLException e){   
            system.debug('Error in insertInventoryStage: during DataUploadTransaction'+e.getMessage());
            insertStatus = false;
        }
        return insertStatus;      
    }
    public class applicationException extends Exception {}
    
    /*public static void deleteDataUploadTransaction(){
list<Inventory_Transaction_Master__c>results = [select Id from Inventory_Transaction_Master__c];
delete results;
}*/
    public  void insertTestToData(String batchId){
        Inventory_Transaction_Master__c invTransMaster = [Select Id, Batch_No__c, Batch_Status__c,Record_Type__c  from Inventory_Transaction_Master__c where Id =:batchId];
        if(invTransMaster != null){
            boolean status  = new uploadInventry().insertDataUploadTransaction(invTransMaster);
        }
    }   
    
    public static Integer getSalesRecordCount(string batchid){
        
        AggregateResult[] fetchErrordata=[Select Count(Id) recordCount from Sales_Transaction_Stage__c where Transaction_Master_Id__c=:BatchId];
        Integer recCount = 0;
        if(!fetchErrordata.isEmpty()){
            for (AggregateResult salesErrCnt : fetchErrordata){
                recCount = Integer.valueOf(salesErrCnt.get('recordCount'));
            }
        }
        return recCount;
    }
    //Get error details of Sales_Transaction_Stage__c.
    @AuraEnabled
    public static List<Sales_Transaction_Stage__c> getSalesErrorData(string batchid){
        System.debug('getSalesErrorData::::'+batchid);
        List <Sales_Transaction_Stage__c> fetchFamily= new List<Sales_Transaction_Stage__c>();
        Map<string,string> familyMap = new Map<string,string>(); 
        List<Sales_Transaction_Stage__c> fetchErrordata=[Select unit_sold_warning__c,Gross_Sales_USD__c,Gross_Sales_USD_FB__c,Gross_Sales_USD_NF__c,Freight_Charge_USD__c,Freight_Charge_USD_FB__c,Freight_Charge_USD_NF__c,selected_ui_values__c,Row_No__c,Week_FB__c,Year_FB__c,Source_FB__c,Month_FB__c,Unit_Sold_FB__c,Local_Net_Unit_Pirce_FB__c,Net_Unit_Price_100_FB__c,ExRate_to_USD_FB__c,ExRate_to_EUR_FB__c,Calculation_Failed__c,Label__c,Remark__c,Royalty_Rate__c,End_user__c,Printed_Logo__c,Customer_local_name__c,Net_Unit_Price_100__c,Local_Net_Unit_Pirce_100__c,ExRate_to_USD__c,ErrorMapData__c,validation_failed__c,warning_consolidate_key__c,SO_Number__c,SO_Number_FB__c,SO_Number_NF__c,LOB__c,LOB_FB__c,LOB_NF__c,
                                                         Company__c,Company_FB__c,Customer__c,Customer_FB__c,Transaction_Currency__c,Transaction_Currency_FB__c,Transaction_Currency_NF__c,
                                                         Division__c,Division_FB__c,Division_NF__c,Mainetti_Brand__c,Mainetti_Brand_FB__c,Mainetti_Brand_NF__c,Item_code__c,Item_code_FB__c,Item_code_NF__c,
                                                         Production_Country__c,Production_Country_FB__c,Production_Country_NF__c,Retailer_Brand__c,Retailer_Brand_FB__c,Retailer_Brand_NF__c,
                                                         Material__c,Material_FB__c,Material_NF__c,Company_NF__c,Model__c,Model_FB__c,Model_NF__c,Market__c,Market_FB__c,Market_NF__c,Vendor__c,Vendor_FB__c,Vendor_NF__c,
                                                         Category__c,Category_FB__c,Category_NF__c,Sub_Category__c,Sub_Category_FB__c,Sub_Category_NF__c,Order_Type__c,Order_Type_FB__c,Order_Type_NF__c,
                                                         Shipped_To_Country__c,Shipped_To_Country_FB__c,Shipped_To_Country_NF__c,Shipped_To_Factory__c,Shipped_To_Factory_FB__c,Shipped_To_Factory_NF__c,
                                                         Color__c,Color_FB__c,Color_NF__c,ExRate_to_EUR__c,ExRate_to_EUR_NF__c,ExRate_to_USD_NF__c,Local_Currency__c,Local_Currency_NF__c,Local_Currency_FB__c,Month__c,Month_NF__c,Remarks__c,Retailer_Code__c,Retailer_Code_NF__c,
                                                         Sales_Local__c,SL_NF__c,Source__c,Source_NF__c,Unit_Sold__c,US_NF__c,UOM__c,UOM_NF__c,Week__c,Week_NF__c,Year__c,Year_NF__c,Upload_Batch_No__c,
                                                         Family__c,Family_FB__c,Family_NF__c,Sales_Transaction_Currency__c,STC_FB__c,STC_NF__c,Sales_EUR__c,Sales_EUR_FB__c,Sales_EUR_NF__c,
                                                         Sales_USD__c,Sales_USD_FB__c,Sales_USD_NF__c,Unit_Price_100_EUR__c,Unit_Price_100_EUR_FB__c,Unit_Price_100_EUR_NF__c,wrong_date__c,
                                                         Unit_Price_100_USD__c,Unit_Price_100_USD_FB__c,Unit_Price_100_USD_NF__c,Label_FB__c from Sales_Transaction_Stage__c where Transaction_Master_Id__c=:BatchId];
        
        
        Integer fetchErrordataSize = fetchErrordata.size();
        system.debug('fetchErrordataSize:::'+fetchErrordataSize);
        return fetchErrordata;
    }
    
    @AuraEnabled
    public static boolean recStatusUpsertForSales(string batchid){
        boolean status = true;
        /*List<Sales_Transaction_Stage__c> fetchData = [Select Record_Status__c from Sales_Transaction_Stage__c where Transaction_Master_Id__c=:BatchId];
        List<Sales_Transaction_Stage__c> updateStage = new List<Sales_Transaction_Stage__c>();
        for(Sales_Transaction_Stage__c newStg :fetchData)
        {
            newStg.Record_Status__c = '2 - Data Validation Successful';
            updateStage.add(newStg);
        }
        try{
            upsert updateStage;
        }
        catch(DMLException e){
            status = false;
        }*/
        Inventory_Transaction_Master__c updateMasterCompany = new Inventory_Transaction_Master__c();
        updateMasterCompany.company_week__c = '';
        updateMasterCompany.Batch_Status__c='4 - Data Validation Successful';   
        updateMasterCompany.Id = batchId;
        update updateMasterCompany;
         
        //Inventory_Transaction_Master__c query = [select Sales_Month__c,Sales_Year__c,Sales_Company__c from Inventory_Transaction_Master__c where Id =: batchId ];
        string userEmail = UserInfo.getUserEmail();
        Database.executeBatch(new salesSuccessData(batchId,userEmail),2000);
        //validataeBulkBatchApex(batchId,query.Sales_Month__c,query.Sales_Year__c,query.Sales_Company__c,userEmail);   
        return status;        
    }    
    //Get success details of Sales_Transaction_Stage__c.
    @AuraEnabled
    public static List<Sales_Transaction_Stage__c> getSalesSuccessData(string batchid,Integer pageNumber,Integer recordToFetch){
        Integer offSet = ((pageNumber - 1) * recordToFetch); 
        List<Sales_Transaction_Stage__c> fetchSuccessdata=[Select unit_sold_warning__c,Gross_Sales_USD__c,Gross_Sales_USD_FB__c,Gross_Sales_USD_NF__c,Freight_Charge_USD__c,Freight_Charge_USD_FB__c,Freight_Charge_USD_NF__c,selected_ui_values__c,Row_No__c,Week_FB__c,Year_FB__c,Source_FB__c,Month_FB__c,Unit_Sold_FB__c,Local_Net_Unit_Pirce_FB__c,Net_Unit_Price_100_FB__c,ExRate_to_USD_FB__c,ExRate_to_EUR_FB__c,Calculation_Failed__c,Remark__c,Label__c,End_user__c,Royalty_Rate__c,Printed_Logo__c,Customer_local_name__c,Net_Unit_Price_100__c,Local_Net_Unit_Pirce_100__c,ExRate_to_USD__c,ErrorMapData__c,validation_failed__c,warning_consolidate_key__c,SO_Number__c,SO_Number_FB__c,SO_Number_NF__c,LOB__c,LOB_FB__c,LOB_NF__c,
                                                           Company__c,Company_FB__c,Customer__c,Customer_FB__c,Transaction_Currency__c,Transaction_Currency_FB__c,Transaction_Currency_NF__c,
                                                           Division__c,Division_FB__c,Division_NF__c,Mainetti_Brand__c,Mainetti_Brand_FB__c,Mainetti_Brand_NF__c,Item_code__c,Item_code_FB__c,Item_code_NF__c,
                                                           Production_Country__c,Production_Country_FB__c,Production_Country_NF__c,Retailer_Brand__c,Retailer_Brand_FB__c,Retailer_Brand_NF__c,
                                                           Material__c,Material_FB__c,Material_NF__c,Company_NF__c,Model__c,Model_FB__c,Model_NF__c,Market__c,Market_FB__c,Market_NF__c,Vendor__c,Vendor_FB__c,Vendor_NF__c,
                                                           Category__c,Category_FB__c,Category_NF__c,Sub_Category__c,Sub_Category_FB__c,Sub_Category_NF__c,Order_Type__c,Order_Type_FB__c,Order_Type_NF__c,
                                                           Shipped_To_Country__c,Shipped_To_Country_FB__c,Shipped_To_Country_NF__c,Shipped_To_Factory__c,Shipped_To_Factory_FB__c,Shipped_To_Factory_NF__c,
                                          
                                                           Color__c,Color_FB__c,Color_NF__c,Country__c,Country_NF__c,ExRate_to_EUR__c,ExRate_to_EUR_NF__c,
                                                           ExRate_to_USD_NF__c,Local_Currency__c,Local_Currency_NF__c,Local_Currency_FB__c,Month__c,Month_NF__c,Remarks__c,Retailer_Code__c,Retailer_Code_NF__c,
                                                           Sales_Local__c,SL_NF__c,Source__c,Source_NF__c,Unit_Sold__c,US_NF__c,UOM__c,UOM_NF__c,Week__c,Week_NF__c,Year__c,Year_NF__c,Upload_Batch_No__c,
                                                           Family__c,Family_FB__c,Family_NF__c,Sales_Transaction_Currency__c,STC_FB__c,STC_NF__c,Sales_EUR__c,Sales_EUR_FB__c,Sales_EUR_NF__c,
                                                           Sales_USD__c,Sales_USD_FB__c,Sales_USD_NF__c,Unit_Price_100_EUR__c,Unit_Price_100_EUR_FB__c,Unit_Price_100_EUR_NF__c,wrong_date__c,
                                                           Unit_Price_100_USD__c,Unit_Price_100_USD_FB__c,Unit_Price_100_USD_NF__c,Label_FB__c from Sales_Transaction_Stage__c where Upload_Batch_No__c=:BatchId and Record_Status__c ='2 - Data Validation Successful' LIMIT :recordToFetch  OFFSET :offSet ];
        Integer fetchSuccessdataSize = fetchSuccessdata.size();
        system.debug('fetchSuccessdataSize:::'+fetchSuccessdataSize);
        
        return fetchSuccessdata;
    }
    
   /* @AuraEnabled
    public static String parseSales(string jsonin, string batchNo, string recordType, string selMonth, string selYear, string selcomp, String postBulkInsert) {
        system.debug('############parseSales::::postBulkInsert'+postBulkInsert);
        string returnBatchId = '';
        Inventory_Transaction_Master__c updateBatchStatus = new Inventory_Transaction_Master__c();
        boolean recordStatus = true;   
        boolean proceedStatus = false;
        boolean isInsertRequired = boolean.valueOf(postBulkInsert);
        
        if(!string.isBlank(batchNo) ){
            Integer totalRecordCount =  uploadInventry.getSalesRecordCount(updateBatchStatus.Id);
            //List<Sales_Transaction_Stage__c> fetchErrordata=[Select Id,Mainetti_Company__c from Sales_Transaction_Stage__c where Upload_Batch_No__c=:batchNo];
            updateBatchStatus =[Select Id, Mainetti_Company__c from Inventory_Transaction_Master__c where Id=:batchNo];
            if(totalRecordCount > 0)
            { 
                system.debug('############parseSales::::isInsertRequired'+isInsertRequired);
                if(!isInsertRequired) {
                    system.debug('############parseSales::::isInsertRequired'+isInsertRequired);
                    try{
                        List<Sales_Transaction_Stage__c> fetchErrordata=[Select Id,Mainetti_Company__c from Sales_Transaction_Stage__c where Upload_Batch_No__c=:batchNo];
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
            }            
        }else{              
            if(recordStatus){
                try{
                    system.debug('#######Rlse#####parseSales ::recordStatus::'+recordStatus);
                    Inventory_Transaction_Master__c Transactions = new Inventory_Transaction_Master__c();
                    Transactions.File_Uploaded_By__c = userInfo.getFirstName() + ','+ userInfo.getLastName();
                    Transactions.Record_Type__c = recordType;
                    system.debug('ParseSales selcomp::'+selcomp);
                    Transactions.Sales_Company__c = selcomp;
                    Transactions.Sales_Month__c = selMonth;
                    Transactions.Sales_Year__c = selYear;
                    system.debug('ParseSales Transactions.Sales_Company__c::'+Transactions.Sales_Company__c);
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
                update updateBatchStatus;
                
                boolean validateStatus = new processSalesData().validateUploadRowsRegular(updateBatchStatus,selMonth,selYear,selcomp);
                System.debug('validateStatus:::'+validateStatus);
                if(!validateStatus){
                    updateBatchStatus.Batch_Status__c='3 - Error In Data Validation';   
                    update updateBatchStatus;
                    recordStatus = false;
                    System.debug('validateStatus::updateBatchStatus.Id:'+updateBatchStatus.Id);
                    //commented Vinod due to performance for bulk processing
                    //List<Sales_Transaction_Stage__c> transferRecords =  getSalesErrorData(updateBatchStatus.Id);
                    Integer transferRecords = getSalesRecordCount(updateBatchStatus.Id);
                    //failure records are there,data validation validation failure.
                    //if(transferRecords.size() > 0){
                    if(transferRecords > 0){
                        proceedStatus = true;                        
                    }
                }   
            }catch(DMLException e){   
                recordStatus = false;
                system.debug('Error in parse: during data validation:'+e.getMessage());
            }
        }   
        if(!recordStatus && !proceedStatus){
            returnBatchId = '';
        }else if(!recordStatus && proceedStatus){
            returnBatchId = returnBatchId+'#PWW';
        }
        return returnBatchId;
    }    */
    
    //insert stage records into Sales_Transaction_Stage__c
    public static boolean insertSalesStageChunk(string jsonin, string batchNo){        
        boolean insertStatus = true;
        double rowNo;
        system.debug('###########Inside insertSalesStageChunk::batchNo:::'+batchNo);
        system.debug('###########Inside insertSalesStageChunk::jsonin:::'+jsonin);
        List<Sales_Transaction_Stage__c> deserializedSales = (List<Sales_Transaction_Stage__c>) System.JSON.deserialize(jsonin, List<Sales_Transaction_Stage__c>.class);
        
        system.debug('###########Inside insertSalesStageChunk::deserializedSales:::'+deserializedSales);
        List<Sales_Transaction_Stage__c> transbatchid = new  List<Sales_Transaction_Stage__c>();
        
        Integer totalCount = [SELECT  COUNT() FROM Sales_Transaction_Stage__c where Upload_Batch_No__c =: batchNo];
        system.debug('totalCount of Records Before Insert:::'+totalCount);
        if(totalCount == 0){
            rowNo = 1; 
        }else{
            rowNo = totalCount; 
        }
        system.debug('rowNo::::'+rowNo);
        
        double firstRowCount = 1;
        double count = 1;
        //Integer mapCount = 1;
        system.debug('###########deserializedSales.size():'+deserializedSales.size());
        if(deserializedSales.size() >0){
            double inputFileRowCount = deserializedSales.size();
            for(Sales_Transaction_Stage__c trans: deserializedSales){
                if(count <=2){
                    system.debug('###########trans):'+trans);
                }
                if((inputFileRowCount)== rowNo){
                    if(count == 9999)
                    {
                        
                    }
                    if( string.isBlank(trans.Company__c) && string.isBlank(trans.Year__c) && string.isBlank(trans.Month__c) 
                       && string.isBlank(trans.Week__c) && string.isBlank(trans.Item_code__c) && string.isBlank(trans.Material__c)
                       && string.isBlank(trans.Source__c) && string.isBlank(trans.Model__c) && string.isBlank(trans.Printed_Logo__c) 
                       && string.isBlank(trans.Color__c) && string.isBlank(trans.Customer__c) && string.isBlank(trans.Customer_local_name__c)
                       && string.isBlank(trans.Mainetti_Brand__c) && string.isBlank(trans.Category__c) 
                       && string.isBlank(trans.Sub_Category__c) && string.isBlank(trans.Family__c) && string.isBlank(trans.Order_Type__c)
                       && string.isBlank(trans.Unit_Sold__c) && string.isBlank(trans.Unit_Price_100_EUR__c) && string.isBlank(trans.Unit_Price_100_USD__c)
                       && string.isBlank(trans.Net_Unit_Price_100__c) && string.isBlank(trans.Sales_EUR__c) && string.isBlank(trans.Sales_USD__c) 
                       && string.isBlank(trans.Transaction_Currency__c) && string.isBlank(trans.ExRate_to_EUR__c) && string.isBlank(trans.ExRate_to_USD__c) 
                       && string.isBlank(trans.Local_Net_Unit_Pirce_100__c) && string.isBlank(trans.Sales_Transaction_Currency__c)
                       && string.isBlank(trans.Shipped_To_Factory__c) && string.isBlank(trans.Shipped_To_Country__c)
                       && string.isBlank(trans.Label__c) && string.isBlank(trans.End_user__c) && string.isBlank(trans.Vendor__c) 
                       && string.isBlank(trans.Division__c) && string.isBlank(trans.Retailer_Brand__c) && string.isBlank(trans.Royalty_Rate__c)
                       && string.isBlank(trans.Market__c) && string.isBlank(trans.Production_Country__c) && string.isBlank(trans.Remark__c) 
                       && string.isBlank(trans.Remarks__c)  && string.isBlank(trans.LOB__c)  && string.isBlank(trans.SO_Number__c)
                       && string.isBlank(trans.Gross_Sales_USD__c) && string.isBlank(trans.Freight_Charge_USD__c))
                    {}else{
                        trans.Row_No__c =rowNo;
                        trans.Upload_Batch_No__c = batchNo;
                        trans.Transaction_Master_Id__c = batchNo;
                        transbatchid.add(trans);
                        rowNo++;
                    }               
                }else{ 
                    trans.Row_No__c =rowNo;
                    trans.Upload_Batch_No__c = batchNo;
                    trans.Transaction_Master_Id__c = batchNo;
                    transbatchid.add(trans);
                    rowNo++;                
                }
            }
        }
        try{
            system.debug('### INSERT SALES BULK transbatchid.size()'+transbatchid.size());
            if(transbatchid.size()>0){                
                insert transbatchid;
            }else {
                insertStatus = false;
            }
        }catch(DMLException e){   
            system.debug('Error in insertSalesStageChunk: during DataUploadSales'+e.getMessage());
            insertStatus = false;
        }
        system.debug('######insertStatus'+insertStatus);
        return insertStatus;      
    }
    //insert stage records into Sales_Transaction_Stage__c

    
    public boolean insertDataUploadSales(Inventory_Transaction_Master__c updateBatchStatus){
        boolean insertStatus = true;
        getSalesMasterData masterData = new getSalesMasterData();
        processSalesData processsalesData = new processSalesData();      
        
        /*Integer totalRecordCount =  uploadInventry.getSalesRecordCount(updateBatchStatus.Id);
System.debug('totalRecordCount::::'+totalRecordCount);
Integer recordToFetch = 9900;
Integer totalPages = Integer.valueOf(Math.ceil(totalRecordCount/ recordToFetch ));
System.debug('totalPages::::'+totalPages);
if(totalPages==0){
totalPages = 1;
}*/
        double totalRecordCount =  double.valueOf(uploadInventry.getSalesRecordCount(updateBatchStatus.Id));
        System.debug('totalRecordCount::::'+totalRecordCount);
        double pageRecordToFetch = 9900;
        double totalPageCount = Math.ceil(totalRecordCount/ pageRecordToFetch );        
        if(totalPageCount==0){
            totalPageCount = 1;
        }
        System.debug('###totalPageCount::::'+totalPageCount);
        Integer totalPages = Integer.valueOf(totalPageCount);
        Integer recordToFetch = Integer.valueOf(pageRecordToFetch);
        List<Sales_Transaction_Stage__c> transferRecords = new List<Sales_Transaction_Stage__c>();
        for(Integer pageNumber=1;pageNumber<=totalPages;pageNumber++){
            List<Sales_Transaction_Stage__c> subListTransferRecords =  getSalesSuccessData(updateBatchStatus.Id,pageNumber,recordToFetch);
            transferRecords.addAll(subListTransferRecords);
        }
        
        
        system.debug('Before Deleting Stage:::'+transferRecords.size());
        List<Data_Upload_Sales__c> insertRecord = new List<Data_Upload_Sales__c>();
        if(transferRecords.size() > 0){            
            updateBatchStatus.Batch_Status__c = '7 - Migration In Progress';
            update updateBatchStatus;
            for(Sales_Transaction_Stage__c trans: transferRecords){
                Data_Upload_Sales__c salesTransMast = new Data_Upload_Sales__c();
                salesTransMast.Upload_Batch_No__c = trans.Upload_Batch_No__c;
                salesTransMast.Sales_Data_Company__c = trans.Company__c;
                salesTransMast.Year__c = trans.Year__c;
                salesTransMast.Week__c = trans.Week__c;
                salesTransMast.Month__c = trans.Month__c;
                salesTransMast.Item_Code__c = trans.Item_Code__c;
                salesTransMast.Material__c = trans.Material__c;
                salesTransMast.Source__c = trans.Source__c;
                salesTransMast.Model__c = trans.Model__c;
                salesTransMast.Printed_Logo__c = trans.Printed_Logo__c;
                salesTransMast.Color__c = trans.Color__c;
                salesTransMast.Customer__c = trans.Customer__c;
                salesTransMast.Customer_Local_Name__c = trans.Customer_Local_Name__c;
                salesTransMast.Mainetti_Brand__c = trans.Mainetti_Brand__c;
                salesTransMast.Category__c = trans.Category__c;
                salesTransMast.Sub_Category__c = trans.Sub_Category__c;
                salesTransMast.Family__c = trans.Family__c;
                salesTransMast.Order_Type__c = trans.Order_Type__c;
                salesTransMast.Unit_Sold__c = decimal.valueOf(trans.Unit_Sold__c.replaceAll(',',''));
                salesTransMast.Unit_Price_100_EUR__c = decimal.valueOf(trans.Unit_Price_100_EUR__c);
                salesTransMast.Unit_Price_100_USD__c = decimal.valueOf(trans.Unit_Price_100_USD__c);
                salesTransMast.Net_Unit_Price_100__c = trans.Net_Unit_Price_100__c;
                salesTransMast.Sales_EUR__c = decimal.valueOf(trans.Sales_EUR__c);
                salesTransMast.Sales_USD__c = decimal.valueOf(trans.Sales_USD__c);
                salesTransMast.Transaction_Currency__c = trans.Transaction_Currency__c;
                salesTransMast.ExRate_to_EUR__c = decimal.valueOf(trans.ExRate_to_EUR__c);
                salesTransMast.ExRate_to_USD__c = decimal.valueOf(trans.ExRate_to_USD__c);
                salesTransMast.Local_Net_Unit_Pirce_100__c = decimal.valueOf(trans.Local_Net_Unit_Pirce_100__c.replaceAll('-','0'));
                salesTransMast.Sales_Transaction_Currency__c = decimal.valueOf(trans.Sales_Transaction_Currency__c.replaceAll(',',''));
                salesTransMast.Shipped_To_Factory__c = trans.Shipped_To_Factory__c; 
                salesTransMast.Shipped_To_Country__c = trans.Shipped_To_Country__c;
                salesTransMast.Label__c = trans.Label__c;
                salesTransMast.End_User__c = trans.End_User__c;
                salesTransMast.Vendor__c = trans.Vendor__c;
                salesTransMast.Division__c = trans.Division__c;
                salesTransMast.Retailer_Brand__c = trans.Retailer_Brand__c;
                salesTransMast.Royalty_Rate__c = trans.Royalty_Rate__c;
                salesTransMast.Market__c = trans.Market__c;
                salesTransMast.Remark__c = trans.Remark__c;
                salesTransMast.LOB__c = trans.LOB__c;
                salesTransMast.SO_Number__c = trans.SO_Number__c;
                salesTransMast.Production_Country__c = trans.Production_Country__c;
                salesTransMast.Gross_Sales_USD__c = decimal.valueOf(trans.Gross_Sales_USD__c);
                salesTransMast.Freight_Charge_USD__c = decimal.valueOf(trans.Freight_Charge_USD__c);
                if(trans.Unit_Sold__c != '0' && trans.Sales_EUR__c != '0' && trans.Sales_USD__c != '0'){
                    insertRecord.add(salesTransMast);
                }
            }
            if(insertRecord.size()>0){
                try{
                    //insert insertRecord;
                    splitInsertRecordListForUpload(insertRecord);
                    //delete transferRecords;
                    splitListForDelete(transferRecords);
                    system.debug('After Deleting Stage:::'+transferRecords.size());
                }catch(DMLException e){   
                    insertStatus = false;
                    system.debug('Error in insertDataUploadSales: during DataUploadSales'+e.getMessage());
                }
            }            
        }
        return insertStatus;
    }
    public void splitInsertRecordListForUpload(List<Data_Upload_Sales__c> insertRecord){        
        Integer totalRecCountForUpdate = insertRecord.size();
        Integer maxSizeForUpdate = 9900;
        if(totalRecCountForUpdate > maxSizeForUpdate){
            for(Integer i = 0 ; i < (totalRecCountForUpdate / maxSizeForUpdate)+1 ; i++){
                List<Data_Upload_Sales__c> uploadTemp = new  List<Data_Upload_Sales__c>();
                for(Integer j=(i*maxSizeForUpdate);(j<(i*maxSizeForUpdate)+maxSizeForUpdate) && j<totalRecCountForUpdate ; j++){
                    uploadTemp.add(insertRecord.get(j));
                }
                insert uploadTemp;
            }
        }else{
            insert insertRecord;
        }
    }
    public void splitListForDelete(List<Sales_Transaction_Stage__c> transferRecords){        
        Integer totalRecCountForUpdate = transferRecords.size();
        Integer maxSizeForUpdate = 9900;
        if(totalRecCountForUpdate > maxSizeForUpdate){
            for(Integer i = 0 ; i < (totalRecCountForUpdate / maxSizeForUpdate)+1 ; i++){
                List<Sales_Transaction_Stage__c> demandTemp = new  List<Sales_Transaction_Stage__c>();
                for(Integer j=(i*maxSizeForUpdate);(j<(i*maxSizeForUpdate)+maxSizeForUpdate) && j<totalRecCountForUpdate ; j++){
                    demandTemp.add(transferRecords.get(j));
                }
                delete demandTemp;
            }
        }else{
            delete transferRecords;
        }
    }
    @AuraEnabled
    public static boolean saveRecord(string recordType, string newValue,string oldValue,String batchId,String recordId,String errMap, String pickListToRemove,String companyName)
    {
        boolean saveStatus = new processSalesData().updateTransStagNInsertErrorMapValues(recordType,oldValue,newValue,batchId,companyName,errMap,pickListToRemove);     
        return saveStatus;
    }
    
    @AuraEnabled
    public static String proceedSalesData(string batchid){
        string returnString = 'false';
        /*List<Sales_Transaction_Stage__c> fetchWarningdata = new List<Sales_Transaction_Stage__c>();
fetchWarningdata=[Select Id from Sales_Transaction_Stage__c where Transaction_Master_Id__c=:BatchId and Source_FB__c = false and Month_FB__c = false and ErrorMapData__c = null and (warning_consolidate_key__c = true OR unit_sold_warning__c = true) and SO_Number_FB__c = false and SO_Number_NF__c= false and LOB_FB__c= false and LOB_NF__c= false and
Company_FB__c= false and Customer_FB__c= false and Calculation_Failed__c= false and Transaction_Currency_FB__c= false and Transaction_Currency_NF__c= false and selected_ui_values__c = false and Freight_Charge_USD_FB__c = false and Freight_Charge_USD_NF__c = false and Gross_Sales_USD_FB__c = false and Gross_Sales_USD_NF__c = false and
Division_FB__c= false and Division_NF__c= false and Mainetti_Brand_FB__c= false and Mainetti_Brand_NF__c= false and Item_code_FB__c= false and Item_code_NF__c= false and 
Production_Country_FB__c= false and Production_Country_NF__c= false and Retailer_Brand_FB__c= false and Retailer_Brand_NF__c= false and
Material_FB__c= false and Material_NF__c= false and Company_NF__c= false and Model_FB__c= false and Model_NF__c= false and Market_FB__c= false and Market_NF__c= false and Vendor_FB__c= false and Vendor_NF__c= false and
Category_FB__c= false and Category_NF__c= false and Sub_Category_FB__c= false and Sub_Category_NF__c= false and Order_Type_FB__c= false and Order_Type_NF__c= false and
Shipped_To_Country_FB__c= false and Shipped_To_Country_NF__c= false and Shipped_To_Factory_FB__c= false and Shipped_To_Factory_NF__c= false and
Color_FB__c= false and Color_NF__c= false and Country_NF__c= false and SM_NF__c= false and ExRate_to_EUR_NF__c= false and
ExRate_to_USD_NF__c= false and Local_Currency_NF__c= false and Local_Currency_FB__c= false and Month_NF__c= false and Retailer_Code_NF__c= false and
SL_NF__c= false and Source_NF__c= false and US_NF__c= false and UOM_NF__c= false and Week_NF__c= false and Year_NF__c= false and
Family_FB__c= false and Family_NF__c= false and STC_FB__c= false and STC_NF__c= false and Sales_EUR_FB__c= false and Sales_EUR_NF__c= false and
Sales_USD_FB__c= false and Sales_USD_NF__c= false and Unit_Price_100_EUR_FB__c= false and Unit_Price_100_EUR_NF__c= false and wrong_date__c= false and
Unit_Price_100_USD_FB__c= false and Unit_Price_100_USD_NF__c= false and Net_Unit_Price_100_FB__c = false and Local_Net_Unit_Pirce_FB__c = false and Local_Net_Unit_Pirce_NF__c = false and Unit_Sold_FB__c = false and Year_FB__c = false and Week_FB__c = false and Label_FB__c = false];*/
        
        AggregateResult[] fetchWarningdata=[Select count(Id) recordCount from Sales_Transaction_Stage__c where Transaction_Master_Id__c=:BatchId and Source_FB__c = false and Month_FB__c = false and ErrorMapData__c = null and (warning_consolidate_key__c = true OR unit_sold_warning__c = true) and SO_Number_FB__c = false and SO_Number_NF__c= false and LOB_FB__c= false and LOB_NF__c= false and
                                            Company_FB__c= false and Customer_FB__c= false and Calculation_Failed__c= false and Transaction_Currency_FB__c= false and Transaction_Currency_NF__c= false and selected_ui_values__c = false and Freight_Charge_USD_FB__c = false and Freight_Charge_USD_NF__c = false and Gross_Sales_USD_FB__c = false and Gross_Sales_USD_NF__c = false and
                                            Division_FB__c= false and Division_NF__c= false and Mainetti_Brand_FB__c= false and Mainetti_Brand_NF__c= false and Item_code_FB__c= false and Item_code_NF__c= false and 
                                            Production_Country_FB__c= false and Production_Country_NF__c= false and Retailer_Brand_FB__c= false and Retailer_Brand_NF__c= false and
                                            Material_FB__c= false and Material_NF__c= false and Company_NF__c= false and Model_FB__c= false and Model_NF__c= false and Market_FB__c= false and Market_NF__c= false and Vendor_FB__c= false and Vendor_NF__c= false and
                                            Category_FB__c= false and Category_NF__c= false and Sub_Category_FB__c= false and Sub_Category_NF__c= false and Order_Type_FB__c= false and Order_Type_NF__c= false and
                                            Shipped_To_Country_FB__c= false and Shipped_To_Country_NF__c= false and Shipped_To_Factory_FB__c= false and Shipped_To_Factory_NF__c= false and
                                            Color_FB__c= false and Color_NF__c= false and Country_NF__c= false and SM_NF__c= false and ExRate_to_EUR_NF__c= false and
                                            ExRate_to_USD_NF__c= false and Local_Currency_NF__c= false and Local_Currency_FB__c= false and Month_NF__c= false and Retailer_Code_NF__c= false and
                                            SL_NF__c= false and Source_NF__c= false and US_NF__c= false and UOM_NF__c= false and Week_NF__c= false and Year_NF__c= false and
                                            Family_FB__c= false and Family_NF__c= false and STC_FB__c= false and STC_NF__c= false and Sales_EUR_FB__c= false and Sales_EUR_NF__c= false and
                                            Sales_USD_FB__c= false and Sales_USD_NF__c= false and Unit_Price_100_EUR_FB__c= false and Unit_Price_100_EUR_NF__c= false and wrong_date__c= false and
                                            Unit_Price_100_USD_FB__c= false and Unit_Price_100_USD_NF__c= false and Net_Unit_Price_100_FB__c = false and Local_Net_Unit_Pirce_FB__c = false and Local_Net_Unit_Pirce_NF__c = false and Unit_Sold_FB__c = false and Year_FB__c = false and Week_FB__c = false and Label_FB__c = false  ];
        
        
        Integer warningRecCount = 0;
        if(!fetchWarningdata.isEmpty()){
            for (AggregateResult salesWarCnt : fetchWarningdata){
                warningRecCount = Integer.valueOf(salesWarCnt.get('recordCount'));
            }
        }
        boolean isCleanData = false;
        
        //commented Vinod due to performance for bulk processing
        //List<Sales_Transaction_Stage__c> cleanData = isDataClean(batchid);
        //integer cleanDataSize = cleanData.size();
        
        Integer cleanDataSize =  isDataCleanRecordCount(batchid);
        
        //commented Vinod due to performance for bulk processing
        //List<Sales_Transaction_Stage__c> fullRecords = getSalesErrorData(batchid);
        //integer fullRecordsSize = fullRecords.size();
        Integer fullRecordsSize = getSalesRecordCount(batchid);
        //If clean data and full record size is same then there are no errors.
        if(cleanDataSize == fullRecordsSize){
            isCleanData = true;
        }
        //Commented by Vinod
        //integer warningSize = fetchWarningdata.size();
        integer warningSize = warningRecCount;
        if(warningSize > 0){
            returnString = 'true';
        }
        List<Inventory_Transaction_Master__c> fetchCompanyweekData =[select company_week__c from Inventory_Transaction_Master__c where Id=:batchid];
        String companyValue = fetchCompanyweekData[0].company_week__c;
        if(String.isNotBlank(companyValue)){
            returnString += '#'+'true';
        }else{
            returnString += '#'+'false';
        }
        if(!isCleanData){
            system.debug('insideIsCleanData');
            returnString = 'false'+'#'+'false';
        }
        if(cleanDataSize == 0 && fullRecordsSize == 0 && warningSize == 0 && isCleanData && returnString == 'false#false'){
            returnString = '$';
        }
        System.debug('########### INSIDE proceedSalesData ReturnString:::::::'+returnString);
        return returnString;
    }
    @AuraEnabled   
    public static List<Sales_Transaction_Stage__c> isDataClean(string batchid){
        List<Sales_Transaction_Stage__c> fetchErrordata = new List<Sales_Transaction_Stage__c>();
        fetchErrordata=[Select Id from Sales_Transaction_Stage__c where Transaction_Master_Id__c=:BatchId and Source_FB__c = false and Month_FB__c = false and ErrorMapData__c = null and SO_Number_FB__c = false and SO_Number_NF__c= false and LOB_FB__c= false and LOB_NF__c= false and
                        Company_FB__c= false and Customer_FB__c= false and Calculation_Failed__c= false and Transaction_Currency_FB__c= false and Transaction_Currency_NF__c= false and selected_ui_values__c = false and Freight_Charge_USD_FB__c = false and Freight_Charge_USD_NF__c = false and Gross_Sales_USD_FB__c = false and Gross_Sales_USD_NF__c = false and
                        Division_FB__c= false and Division_NF__c= false and Mainetti_Brand_FB__c= false and Mainetti_Brand_NF__c= false and Item_code_FB__c= false and Item_code_NF__c= false and
                        Production_Country_FB__c= false and Production_Country_NF__c= false and Retailer_Brand_FB__c= false and Retailer_Brand_NF__c= false and
                        Material_FB__c= false and Material_NF__c= false and Company_NF__c= false and Model_FB__c= false and Model_NF__c= false and Market_FB__c= false and Market_NF__c= false and Vendor_FB__c= false and Vendor_NF__c= false and
                        Category_FB__c= false and Category_NF__c= false and Sub_Category_FB__c= false and Sub_Category_NF__c= false and Order_Type_FB__c= false and Order_Type_NF__c= false and
                        Shipped_To_Country_FB__c= false and Shipped_To_Country_NF__c= false and Shipped_To_Factory_FB__c= false and Shipped_To_Factory_NF__c= false and
                        Color_FB__c= false and Color_NF__c= false and Country_NF__c= false and SM_NF__c= false and ExRate_to_EUR_NF__c= false and
                        ExRate_to_USD_NF__c= false and Local_Currency_NF__c= false and Local_Currency_FB__c= false and Month_NF__c= false and Retailer_Code_NF__c= false and
                        SL_NF__c= false and Source_NF__c= false and US_NF__c= false and UOM_NF__c= false and Week_NF__c= false and Year_NF__c= false and
                        Family_FB__c= false and Family_NF__c= false and STC_FB__c= false and STC_NF__c= false and Sales_EUR_FB__c= false and Sales_EUR_NF__c= false and
                        Sales_USD_FB__c= false and Sales_USD_NF__c= false and Unit_Price_100_EUR_FB__c= false and Unit_Price_100_EUR_NF__c= false and wrong_date__c= false and
                        Unit_Price_100_USD_FB__c= false and Unit_Price_100_USD_NF__c= false and Net_Unit_Price_100_FB__c = false and Local_Net_Unit_Pirce_FB__c = false and Local_Net_Unit_Pirce_NF__c = false and Unit_Sold_FB__c = false and Year_FB__c = false and Week_FB__c = false and Label_FB__c = false];
        return fetchErrordata;
    }
    public static Integer isDataCleanRecordCount(string batchid){
        
        AggregateResult[] fetchErrordata =[Select count(Id) recordCount from Sales_Transaction_Stage__c where Transaction_Master_Id__c=:BatchId and Source_FB__c = false and Month_FB__c = false and ErrorMapData__c = null and SO_Number_FB__c = false and SO_Number_NF__c= false and LOB_FB__c= false and LOB_NF__c= false and
                                           Company_FB__c= false and Customer_FB__c= false and Calculation_Failed__c= false and Transaction_Currency_FB__c= false and Transaction_Currency_NF__c= false and selected_ui_values__c = false and Freight_Charge_USD_FB__c = false and Freight_Charge_USD_NF__c = false and Gross_Sales_USD_FB__c = false and Gross_Sales_USD_NF__c = false and
                                           Division_FB__c= false and Division_NF__c= false and Mainetti_Brand_FB__c= false and Mainetti_Brand_NF__c= false and Item_code_FB__c= false and Item_code_NF__c= false and
                                           Production_Country_FB__c= false and Production_Country_NF__c= false and Retailer_Brand_FB__c= false and Retailer_Brand_NF__c= false and
                                           Material_FB__c= false and Material_NF__c= false and Company_NF__c= false and Model_FB__c= false and Model_NF__c= false and Market_FB__c= false and Market_NF__c= false and Vendor_FB__c= false and Vendor_NF__c= false and
                                           Category_FB__c= false and Category_NF__c= false and Sub_Category_FB__c= false and Sub_Category_NF__c= false and Order_Type_FB__c= false and Order_Type_NF__c= false and
                                           Shipped_To_Country_FB__c= false and Shipped_To_Country_NF__c= false and Shipped_To_Factory_FB__c= false and Shipped_To_Factory_NF__c= false and
                                           Color_FB__c= false and Color_NF__c= false and Country_NF__c= false and SM_NF__c= false and ExRate_to_EUR_NF__c= false and
                                           ExRate_to_USD_NF__c= false and Local_Currency_NF__c= false and Local_Currency_FB__c= false and Month_NF__c= false and Retailer_Code_NF__c= false and
                                           SL_NF__c= false and Source_NF__c= false and US_NF__c= false and UOM_NF__c= false and Week_NF__c= false and Year_NF__c= false and
                                           Family_FB__c= false and Family_NF__c= false and STC_FB__c= false and STC_NF__c= false and Sales_EUR_FB__c= false and Sales_EUR_NF__c= false and
                                           Sales_USD_FB__c= false and Sales_USD_NF__c= false and Unit_Price_100_EUR_FB__c= false and Unit_Price_100_EUR_NF__c= false and wrong_date__c= false and
                                           Unit_Price_100_USD_FB__c= false and Unit_Price_100_USD_NF__c= false and Net_Unit_Price_100_FB__c = false and Local_Net_Unit_Pirce_FB__c = false and Local_Net_Unit_Pirce_NF__c = false and Unit_Sold_FB__c = false and Year_FB__c = false and Week_FB__c = false and Label_FB__c = false];
        
        Integer recCount = 0;
        if(!fetchErrordata.isEmpty()){
            for (AggregateResult salesErrCnt : fetchErrordata){
                recCount = Integer.valueOf(salesErrCnt.get('recordCount'));
            }
        }
        return recCount;        
    }
    
    @AuraEnabled   
    public static List<Inventory_Transaction_Master__c> isCompanyMissingWeek(string batchid){
        List<Inventory_Transaction_Master__c> fetchData = new List<Inventory_Transaction_Master__c>();
        fetchData = [Select Id from Inventory_Transaction_Master__c where Id=:batchid and company_week__c <> null];
        return fetchData;
    }
    
    @AuraEnabled   
    public static List<Sales_Transaction_Stage__c> isDataCleanForProceed(string batchid){
        List<Sales_Transaction_Stage__c> fetchErrordata = new List<Sales_Transaction_Stage__c>();
        fetchErrordata=[Select Id from Sales_Transaction_Stage__c where Transaction_Master_Id__c=:BatchId and (unit_sold_warning__c = true OR warning_consolidate_key__c  = true OR Source_FB__c = true OR Month_FB__c = true OR ErrorMapData__c <> null OR SO_Number_FB__c = true OR SO_Number_NF__c= true OR LOB_FB__c= true OR LOB_NF__c= true OR
                                                                                                               Company_FB__c= true OR Customer_FB__c= true OR Calculation_Failed__c= true OR Transaction_Currency_FB__c= true OR Transaction_Currency_NF__c= true OR selected_ui_values__c = true OR Freight_Charge_USD_FB__c = true OR Freight_Charge_USD_NF__c = true OR Gross_Sales_USD_FB__c = true OR Gross_Sales_USD_NF__c = true OR
                                                                                                               Division_FB__c= true OR Division_NF__c= true OR Mainetti_Brand_FB__c= true OR Mainetti_Brand_NF__c= true OR Item_code_FB__c= true OR Item_code_NF__c= true OR
                                                                                                               Production_Country_FB__c= true OR Production_Country_NF__c= true OR Retailer_Brand_FB__c= true OR Retailer_Brand_NF__c= true OR
                                                                                                               Material_FB__c= true OR Material_NF__c= true OR Company_NF__c= true OR Model_FB__c= true OR Model_NF__c= true OR Market_FB__c= true OR Market_NF__c= true OR Vendor_FB__c= true OR Vendor_NF__c= true OR
                                                                                                               Category_FB__c= true OR Category_NF__c= true OR Sub_Category_FB__c= true OR Sub_Category_NF__c= true OR Order_Type_FB__c= true OR Order_Type_NF__c= true OR
                                                                                                               Shipped_To_Country_FB__c= true OR Shipped_To_Country_NF__c= true OR Shipped_To_Factory_FB__c= true OR Shipped_To_Factory_NF__c= true OR
                                                                                                               Color_FB__c= true OR Color_NF__c= true OR Country_NF__c= true OR SM_NF__c= true OR ExRate_to_EUR_NF__c= true OR
                                                                                                               ExRate_to_USD_NF__c= true OR Local_Currency_NF__c= true OR Local_Currency_FB__c= true OR Month_NF__c= true OR Retailer_Code_NF__c= true OR
                                                                                                               SL_NF__c= true OR Source_NF__c= true OR US_NF__c= true OR UOM_NF__c= true OR Week_NF__c= true OR Year_NF__c= true OR
                                                                                                               Family_FB__c= true OR Family_NF__c= true OR STC_FB__c= true OR STC_NF__c= true OR Sales_EUR_FB__c= true OR Sales_EUR_NF__c= true OR
                                                                                                               Sales_USD_FB__c= true OR Sales_USD_NF__c= true OR Unit_Price_100_EUR_FB__c= true OR Unit_Price_100_EUR_NF__c= true OR wrong_date__c= true OR
                                                                                                               Unit_Price_100_USD_FB__c= true OR Unit_Price_100_USD_NF__c= true OR Net_Unit_Price_100_FB__c = true OR Local_Net_Unit_Pirce_FB__c = true OR Local_Net_Unit_Pirce_NF__c = true OR Unit_Sold_FB__c = true OR Year_FB__c = true OR Week_FB__c = true OR Label_FB__c = true)];
        return fetchErrordata;
    }
    
    @AuraEnabled
    public static integer callingCustomSettings(){
        Sales_Transaction__c customData = Sales_Transaction__c.getInstance();
        integer dateValue = integer.valueOf(customData.date__c);
        system.debug('valueIs:'+dateValue);
        return dateValue;
    }
    
    // Custom Lookup for Family
    @AuraEnabled
    public static List < Sales_Error_Mapping__c > fetchLookupErrorMapList(String mapToValue,String mapFromValue, string rawDataField,string company) {
        system.debug('#####################fetchLookupErrorMapList:::mapToValue::'+mapToValue+'::mapFromValue::'+mapFromValue+'::rawDataField:::'+rawDataField+'::company::'+company);
        String searchKey = '%' + mapToValue + '%';
        List < Sales_Error_Mapping__c > lstOfErrorMapto = [Select Map_From_Value__c, Map_To_Value__c from Sales_Error_Mapping__c where Raw_Data_Field__c =:rawDataField and Company__c=:company and Map_From_Value__c=:mapFromValue and Map_To_Value__c like : searchKey];
        system.debug('#####################fetchLookupErrorMapList:'+lstOfErrorMapto.size());
        return lstOfErrorMapto;
    }
    
    @AuraEnabled 
    public static map<string,string> getsalesCompanyList()
    {
        //system.debug('Starting Point');        
        Map<string,string> salesCompMap = new Map<string,string>();        
        list<Sales_Report_Company__c> retailerCode = [Select Company__c from Sales_Report_Company__c ORDER BY Company__c ASC];        
        for ( Sales_Report_Company__c salesRepoComp : retailerCode ){
            salesCompMap.put(salesRepoComp.Company__c,salesRepoComp.Company__c);
        }
        // system.debug('Ending Point');
        return salesCompMap;
    }
    
    @AuraEnabled
    public static String errordataSubmitted(string companyArray, string selmonth, string selyear)
    {
        List<string> companyList = companyArray.split(',');
        Set<String> companyName = new Set<String>();
        for (string valFormt : companyList){
            if(string.isNotBlank(valFormt)){
                companyName.add(valFormt);
            }
        }   
        system.debug('companyArray::'+companyArray+'selmonth::'+selmonth+'selyear::'+selyear+'companyName::'+companyName);
        List<Inventory_Transaction_Master__c> fetchData = [select Sales_Company__c,Sales_Month__c,Sales_Year__c,Batch_Status__c from  Inventory_Transaction_Master__c where Sales_Company__c =:companyArray and Sales_Month__c =: selmonth and Sales_Year__c =: selyear LIMIT 1 ];
        system.debug('fetchData'+fetchData);
        String batchStatus = '';
        for (Inventory_Transaction_Master__c transMast : fetchData){
            batchStatus = transMast.Batch_Status__c;
        }   
        Integer fetchdataSize = fetchData.size();
        system.debug('fetchdataSize:::'+fetchdataSize);
        return batchStatus;        
    }
    
  /*  @AuraEnabled (cacheable=true)
    public static salesTranscationStageDataTableWrapper getSalesTranscationData(Integer pageNumber, Integer pageSize, string batchId,Integer totalRecords) {
        salesTranscationStageDataTableWrapper salesTrans =  new salesTranscationStageDataTableWrapper();
        Integer totalRecordCount;
        if(pageNumber == 1)
        {
            System.debug('######## INSIDE getSalesTranscationData Page Count ====1 ');
            totalRecordCount = [SELECT COUNT() FROM Sales_Transaction_Stage__c where Upload_Batch_No__c=:batchId];   
            List<Inventory_Transaction_Master__c>isCompanyMissingWeek=  isCompanyMissingWeek(batchId); 
            System.debug('######## INSIDE getSalesTranscationData isCompanyMissingWeek'+isCompanyMissingWeek);
            if(isCompanyMissingWeek.isEmpty())
            {
                List<Sales_Transaction_Stage__c> isDataCleanForProceed =  isDataCleanForProceed(batchId);
                if(isDataCleanForProceed.isEmpty()) {
                    salesTrans.isProceed = true;
                    
                }else{
                    salesTrans.isProceed = false;
                }
            }else{
                salesTrans.isProceed = false;
            }            
            System.debug('######## INSIDE getSalesTranscationData salesTrans.isProceed'+salesTrans.isProceed);
        }else{
            totalRecordCount =totalRecords;        }
        Integer offset = (pageNumber - 1) * pageSize;
        system.debug('offset:::'+offset);
        Integer recordEnd = pageSize * pageNumber;
        Integer recTotalCount = 0;
        
        //Instance of Contact DataTable Wrapper Class
        
        salesTrans.pageSize = pageSize;
        salesTrans.pageNumber = pageNumber;
        salesTrans.recordStart = offset + 1;
        salesTrans.recordEnd = totalRecordCount >= recordEnd ? recordEnd : totalRecordCount;
        salesTrans.totalRecords = totalRecordCount;
        salesTrans.salesTransStageList = [Select unit_sold_warning__c,Gross_Sales_USD__c,Gross_Sales_USD_FB__c,Gross_Sales_USD_NF__c,Freight_Charge_USD__c,Freight_Charge_USD_FB__c,Freight_Charge_USD_NF__c,selected_ui_values__c,Row_No__c,Week_FB__c,Year_FB__c,Source_FB__c,Month_FB__c,Unit_Sold_FB__c,Local_Net_Unit_Pirce_FB__c,Net_Unit_Price_100_FB__c,ExRate_to_USD_FB__c,ExRate_to_EUR_FB__c,Calculation_Failed__c,Remark__c,Label__c,Royalty_Rate__c,End_user__c,Printed_Logo__c,Customer_local_name__c,Net_Unit_Price_100__c,Local_Net_Unit_Pirce_100__c,ExRate_to_USD__c,ErrorMapData__c,validation_failed__c,warning_consolidate_key__c,SO_Number__c,SO_Number_FB__c,SO_Number_NF__c,LOB__c,LOB_FB__c,LOB_NF__c,
                                          Company__c,Company_FB__c,Customer__c,Customer_FB__c,Transaction_Currency__c,Transaction_Currency_FB__c,Transaction_Currency_NF__c,
                                          Division__c,Division_FB__c,Division_NF__c,Mainetti_Brand__c,Mainetti_Brand_FB__c,Mainetti_Brand_NF__c,Item_code__c,Item_code_FB__c,Item_code_NF__c,
                                          Production_Country__c,Production_Country_FB__c,Production_Country_NF__c,Retailer_Brand__c,Retailer_Brand_FB__c,Retailer_Brand_NF__c,
                                          Material__c,Material_FB__c,Material_NF__c,Company_NF__c,Model__c,Model_FB__c,Model_NF__c,Market__c,Market_FB__c,Market_NF__c,Vendor__c,Vendor_FB__c,Vendor_NF__c,
                                          Category__c,Category_FB__c,Category_NF__c,Sub_Category__c,Sub_Category_FB__c,Sub_Category_NF__c,Order_Type__c,Order_Type_FB__c,Order_Type_NF__c,
                                          Shipped_To_Country__c,Shipped_To_Country_FB__c,Shipped_To_Country_NF__c,Shipped_To_Factory__c,Shipped_To_Factory_FB__c,Shipped_To_Factory_NF__c,
                                          Color__c,Color_FB__c,Color_NF__c,ExRate_to_EUR__c,ExRate_to_EUR_NF__c,
                                          ExRate_to_USD_NF__c,Local_Currency__c,Local_Currency_NF__c,Local_Currency_FB__c,Month__c,Month_NF__c,Remarks__c,Retailer_Code__c,Retailer_Code_NF__c,
                                          Sales_Local__c,SL_NF__c,Source__c,Source_NF__c,Unit_Sold__c,US_NF__c,UOM__c,UOM_NF__c,Week__c,Week_NF__c,Year__c,Year_NF__c,Upload_Batch_No__c,
                                          Family__c,Family_FB__c,Family_NF__c,Sales_Transaction_Currency__c,STC_FB__c,STC_NF__c,Sales_EUR__c,Sales_EUR_FB__c,Sales_EUR_NF__c,
                                          Sales_USD__c,Sales_USD_FB__c,Sales_USD_NF__c,Unit_Price_100_EUR__c,Unit_Price_100_EUR_FB__c,Unit_Price_100_EUR_NF__c,wrong_date__c,
                                          Unit_Price_100_USD__c,Unit_Price_100_USD_FB__c,Unit_Price_100_USD_NF__c,Label_FB__c from Sales_Transaction_Stage__c where Upload_Batch_No__c=:batchId LIMIT :pageSize OFFSET :offset];
        return salesTrans;
    }
    
    //Wrapper Class For Contact DataTable  
    public class salesTranscationStageDataTableWrapper {
        @AuraEnabled
        public Integer pageSize {get;set;}
        @AuraEnabled
        public Integer pageNumber {get;set;}
        @AuraEnabled
        public Integer totalRecords {get;set;}
        @AuraEnabled
        public Integer recordStart {get;set;}
        @AuraEnabled
        public Integer recordEnd {get;set;}
        @AuraEnabled
        public List<Sales_Transaction_Stage__c> salesTransStageList {get;set;}
        @AuraEnabled
        public boolean isProceed {get;set;}
        
    }*/
    
    @AuraEnabled
    public static String insertBulkSales(string jsonin, string batchNo,string recordType, string selMonth, string selYear, string selcomp,string isreupload,String chunkCount,String fileName) {
        System.debug('###### START insertBulkSales :::: chunkCount::::'+chunkCount);
        boolean isReUploadLocal = Boolean.valueOf(isreupload);
         
        System.debug('##############isReUploadLocal:::::'+isReUploadLocal);
        if(isReUploadLocal){
            // delete[select Id from Sales_Transaction_Stage__c where Upload_Batch_No__c=:batchNo];
            System.debug('#################### INSIDE ISREUPLOAD');
            Database.executeBatch(new deleteTheRecordsBasedonId(batchNo),2000);
            //Making the batch No null cos to regenerate a transaction as delete is also
            //deleting all the newly inserted records
            batchNo = '';
        }
        boolean insertStatus =true;        
        String returnBatchId;
        
        if(String.isBlank(batchNo)) {
            Inventory_Transaction_Master__c Transactions = new Inventory_Transaction_Master__c();
            Transactions.File_Uploaded_By__c = userInfo.getFirstName() + ','+ userInfo.getLastName();
            Transactions.Record_Type__c = recordType;
            Transactions.Sales_Company__c = selcomp;
            Transactions.Sales_Month__c = selMonth;
            Transactions.Sales_Year__c = selYear;    
            Transactions.upload_file_name__c = EncodingUtil.urlEncode(fileName, 'UTF-8');
            try{
                insert Transactions;
                batchNo = Transactions.Id;
            }catch(DMLException e){   
                insertStatus = false;
                system.debug('Error in insertDataUploadSales: during DataUploadSales'+e.getMessage());
            }
        }
        boolean status = false;
        if(insertStatus){
            System.debug('####Inside insertSalesStageChunk :::batchNo:::'+batchNo+':::chunkCount::::'+chunkCount);
            if(jsonin!= null){
                status=insertSalesStageChunk(jsonin,batchNo);
            }            
        }        
        if(status){
            returnBatchId = batchNo;
        }else{
            returnBatchId ='';
        }        
        return returnBatchId;
    }
    @AuraEnabled
    public static String generateIdForFileUpload(string recordType, string selMonth, string selYear, string selcomp) {
        System.debug('###### START generateIdForFileUpload');
     
        String batchId;        
            Inventory_Transaction_Master__c Transactions = new Inventory_Transaction_Master__c();
            Transactions.File_Uploaded_By__c = userInfo.getFirstName() + ','+ userInfo.getLastName();
            Transactions.Record_Type__c = recordType;
            Transactions.Sales_Company__c = selcomp;
            Transactions.Sales_Month__c = selMonth;
            Transactions.Sales_Year__c = selYear;    
            //Transactions.upload_file_name__c = EncodingUtil.urlEncode(fileName, 'UTF-8');
            try{
                insert Transactions;
                batchId = Transactions.Id;
            }catch(DMLException e){   
                  system.debug('Error in generateIdForFileUpload: during DataUploadSales'+e.getMessage());
            }
          return batchId;
    }
    public static boolean validataeBulkBatchApex(String batchNo,String selMonth,String selYear,String selcomp,String userEmail){
        
        boolean validateBulkStatus = true;
        validateSalesRowsBulk validateBulk = new validateSalesRowsBulk(batchNo,selMonth,selYear,selcomp,userEmail);
        Database.executeBatch(validateBulk,2000);		 
        // system.debug('batchprocessid:::'+batchprocessid);
        return validateBulkStatus;
    } 
    @AuraEnabled
    public static String parseSalesChunk(string jsonin, string batchNo, string recordType, string selMonth, string selYear, string selcomp, String postBulkInsert) {
        system.debug('############parseSalesChunk::::postBulkInsert'+postBulkInsert);
        string returnBatchId = '';
        Inventory_Transaction_Master__c updateBatchStatus = new Inventory_Transaction_Master__c();
        boolean recordStatus = true;   
        boolean proceedStatus = false;
        boolean isInsertRequired = boolean.valueOf(postBulkInsert);
          if(recordStatus){
            returnBatchId = batchNo;
            
            updateBatchStatus.Id = batchNo;               
            updateBatchStatus.Batch_Status__c='2 - Data Validation In Progress';
            update updateBatchStatus;
            string userEmail = UserInfo.getUserEmail();
            // calling the validateSalesRowsBulk Batch Apex
            validataeBulkBatchApex(batchNo,selMonth,selYear,selcomp,userEmail);
                
        }   
        return returnBatchId;
    }      
    
    @AuraEnabled
    public static boolean recStatusUpsertForInventory(string batchid){
        boolean status = true;
        string userEmail = UserInfo.getUserEmail();
         recStatusUpsertForInventoryBulk validateBulk = new recStatusUpsertForInventoryBulk(batchId,userEmail);
        Database.executeBatch(validateBulk,2000);	
        return status;        
    }  
    
    @AuraEnabled
    public static boolean recUpdateFOrInvSuccess(string batchid){
        boolean status = true;
        Inventory_Transaction_Master__c updateCheckbox = new Inventory_Transaction_Master__c();
        updateCheckbox.Id = batchid;
        updateCheckbox.Success_Notification__c = true;
        updateCheckbox.Reprocessing__c = false;
        try {
            update updateCheckbox;
        } catch (DMLException e) {
            status = false;
        }
        return status; 
    }
    /***************Delete the Batch Process records which have become defunct due to some exception****/
    @AuraEnabled
    public static boolean deleteDefunctBatchRecord(String batchId){
        boolean status = true;
        System.debug('#############INSIDE THE DELETE DEFUNCT BATCH METHOD#########'+batchId);
        Database.executeBatch(new deleteTheRecordsBasedonId(batchId),2000);
        return status;
    }
    @AuraEnabled
    public static List<Inventory_Transaction_Master__c> getAutoPopulateMasterValues(String batchId){
        system.debug('batchId:'+batchId);
        List<Inventory_Transaction_Master__c> masterData= [Select Sales_Company__c,Sales_Month__c,Sales_Year__c from Inventory_Transaction_Master__c where id =:batchId ];
        return masterData;
    }
}