public class uploadMaterial {
    
    //Get error details of MaterialPricing_Transaction_Stage__c.
    @AuraEnabled
    public static List<MaterialPricing_Transaction_Stage__c> getMaterialErrorData(string batchid){
        List<MaterialPricing_Transaction_Stage__c> fetchErrordata=[Select Name,Mainetti_Company__c,MC_NF__c,Manitte_Company_FB__c,Location__c,Location_FB__c,Location_NF__c,Material_Type__c,Material_Type_FB__c,Material_Type_NF__c,Unit_Price__c,UP_FB__c,UP_NF__c,UOM__c,UOM_FB__c,UOM_NF__c,Year__c,Year_FB__c,Year_NF__c,Month__c,Month_FB__c,Month_NF__c,Date__c,Date_FB__c,Date_NF__c,Record_Status__c,Remarks__c,Row_No__c,Upload_Batch_No__c from MaterialPricing_Transaction_Stage__c where
                                                             Upload_Batch_No__c=:batchid];
        //system.debug('fetchErrordata::'+fetchErrordata.size());
        return fetchErrordata;
    }
    
    public static List<MaterialPricing_Transaction_Stage__c> getMaterialSuccessData(string batchid){
        List<MaterialPricing_Transaction_Stage__c> fetchErrordata=[Select Name,Mainetti_Company__c,MC_NF__c,Manitte_Company_FB__c,Location__c,Location_FB__c,Location_NF__c,Material_Type__c,Material_Type_FB__c,Material_Type_NF__c,Unit_Price__c,UP_FB__c,UP_NF__c,UOM__c,UOM_FB__c,UOM_NF__c,Year__c,Year_FB__c,Year_NF__c,Month__c,Month_FB__c,Month_NF__c,Date__c,Date_FB__c,Date_NF__c,Record_Status__c,Remarks__c,Row_No__c,Upload_Batch_No__c from MaterialPricing_Transaction_Stage__c where
                                                             Upload_Batch_No__c=:batchid and Record_Status__c ='2 - Data Validation Successful'];
        //system.debug('fetchErrordata::'+fetchErrordata.size());
        return fetchErrordata;
    }
    
    @AuraEnabled
    public static String parseMaterialPricing(string jsonin, string batchNo, string recordType, string company) {  
        system.debug('inside parseMaterialPricing');
        string returnBatchId = '';
        Inventory_Transaction_Master__c updateBatchStatus = new Inventory_Transaction_Master__c();
        boolean recordStatus = true;                
        if(!string.isBlank(batchNo)){
            List<MaterialPricing_Transaction_Stage__c> fetchErrordata=[Select Id,Mainetti_Company__c from MaterialPricing_Transaction_Stage__c where Upload_Batch_No__c=:batchNo];
              updateBatchStatus =[Select Id, Mainetti_Company__c from Inventory_Transaction_Master__c where Id=:batchNo];
            if(fetchErrordata.size() > 0)
            {                
                try{
                    delete fetchErrordata;
                    boolean status=insertMaterialStage(jsonin,batchNo);
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
                    boolean status=insertMaterialStage(jsonin,Transactions.Id);
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
                boolean validateStatus = new processMaterialData().validateUploadRows(updateBatchStatus);
                //system.debug('validateStatus::::'+validateStatus);
                if(!validateStatus){
                    updateBatchStatus.Batch_Status__c='3 - Error In Data Validation';   
                    update updateBatchStatus;
                    List<MaterialPricing_Transaction_Stage__c> transferRecords =  getMaterialErrorData(updateBatchStatus.Id);
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
        public static boolean insertMaterialStage(string jsonin, string batchNo){
        system.debug('inside insertMaterialStage');
        boolean insertStatus = true;
        List<MaterialPricing_Transaction_Stage__c> deserializedInventory = (List<MaterialPricing_Transaction_Stage__c>)JSON.deserialize(jsonin, List<MaterialPricing_Transaction_Stage__c>.class);
        List<MaterialPricing_Transaction_Stage__c> transbatchid = new  List<MaterialPricing_Transaction_Stage__c>();
        double rowNo = 1;
        double firstRowCount = 1;
        if(deserializedInventory.size() >0){
        double inputFileRowCount = deserializedInventory.size();
        for(MaterialPricing_Transaction_Stage__c trans: deserializedInventory){
            //if(firstRowCount != 1 ){
            if((inputFileRowCount)== rowNo){
                if(string.isBlank(trans.Mainetti_Company__c) && string.isBlank(trans.Location__c) && string.isBlank(trans.Material_Type__c) && string.isBlank(trans.Unit_Price__c) && string.isBlank(trans.UOM__c) && string.isBlank(trans.Year__c) && string.isBlank(trans.Month__c) && string.isBlank(trans.Date__c))
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
    
        public boolean insertDataUploadMaterialPricing(Inventory_Transaction_Master__c updateBatchStatus){
        system.debug('inside dataupload');
        boolean insertStatus = true;
        getMasterData masterData = new getMasterData();
        processInventoryData processInvData = new processInventoryData();
        map<string,Id> retailerCodeWithId = masterData.getRetailerCodeIdMap();        
        map<string,Id> mainettiCompanyWithId = masterData.getManitteCompanyIdMap();       
        List<MaterialPricing_Transaction_Stage__c> transferRecords =  getMaterialSuccessData(updateBatchStatus.Id);
        List<Data_Upload_Material_Pricing__c> insertRecord = new List<Data_Upload_Material_Pricing__c>();
        if(transferRecords.size() > 0){
            //Map<string,string> invTransOrderToCompMap = masterData.getListOfTransManitteCompany(updateBatchStatus.Id);
            Map<string,Map<string,string>> modelPriceMap = masterData.getRTSModelMap(updateBatchStatus);
            Map<string,string> rtsPriceMap = modelPriceMap.get('Price');            
            updateBatchStatus.Batch_Status__c = '7 - Migration In Progress';
            update updateBatchStatus;
            
            for(MaterialPricing_Transaction_Stage__c trans: transferRecords){
                Data_Upload_Material_Pricing__c invTransMast = new Data_Upload_Material_Pricing__c();
                invTransMast.Upload_Batch_No__c = trans.Upload_Batch_No__c;
                invTransMast.Record_Type__c = updateBatchStatus.Record_Type__c;
                invTransMast.Mainetti_Company__c = mainettiCompanyWithId.get(trans.Mainetti_Company__c.toLowerCase());
                invTransMast.Location__c = trans.Location__c;
                invTransMast.Material_Type__c = trans.Material_Type__c;
                invTransMast.Unit_Price__c = trans.Unit_Price__c;
                invTransMast.UOM__c = trans.UOM__c;
                invTransMast.Year__c = trans.Year__c;
                invTransMast.Month__c = trans.Month__c;
                invTransMast.Date__c = trans.Date__c;              
                insertRecord.add(invTransMast);
            }
            if(insertRecord.size()>0){
                try{
                    insert insertRecord;
                    delete transferRecords;
                }catch(DMLException e){   
                    insertStatus = false;
                    system.debug('Error in insertDataUploadMaterialPricing: during DataUploadTransaction'+e.getMessage());
                }
            }            
        }
        return insertStatus;
    }

}