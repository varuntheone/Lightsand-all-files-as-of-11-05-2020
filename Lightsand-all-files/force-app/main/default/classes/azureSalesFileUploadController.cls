public class azureSalesFileUploadController {
    
    public Inventory_Transaction_Master__c invTransMast {get;set;}
    public SObject parent;    
    public azureSalesFileUploadController(ApexPages.StandardController sc) {
        parent  = sc.getRecord(); 
        invTransMast = [select Id,Record_Type__c  from Inventory_Transaction_Master__c where  Id =:parent.Id ];        
    }    
    //returns storage key, storage name and container
    @RemoteAction
    public static azureSalesFileUploadController.azureWrapper storageDetails(){                
        inventory_azure_storage_details__c	 detail = inventory_azure_storage_details__c.getInstance();
        return new azureSalesFileUploadController.azureWrapper(detail.storageKey__c, detail.storageName__c,detail.containerName__c);
    }
    @RemoteAction
    public static boolean deleteCSVFile(String batchId){
        getMasterData getMastData = new getMasterData();
        boolean delStatus =  getMastData.deleteCSVFile(batchId);
        return delStatus;
    }
    
    @RemoteAction
    public static azureSalesFileUploadController.csvWrapper getCsvFileContent(String batchId){
        getMasterData getMastData = new getMasterData();
        ContentVersion conVer =  getMastData.getCSVFile(batchId);
        string fileContent = EncodingUtil.base64Encode(conVer.VersionData);
        //system.debug('conVer:'+conVer.VersionData.toString());
        return new azureSalesFileUploadController.csvWrapper(conVer.Title,conVer.PathOnClient,fileContent);
    }
    
    @RemoteAction
    public static boolean transferTransctionDataToDataUploadMaster(String batchId){
        //system.debug('DataUploadMasterbatchId'+batchId);
        boolean transferStatus = true;
        Inventory_Transaction_Master__c invTransMaster = [Select Id, Mainetti_Company__c,Batch_No__c, Batch_Status__c,Record_Type__c  from Inventory_Transaction_Master__c where Id =:batchId];
        if(invTransMaster != null){
            boolean migrationStatus = true;
            if(invTransMaster.Record_Type__c == 'Inventory'){
                 migrationStatus = new uploadInventry().insertDataUploadTransaction(invTransMaster);
            }           
            else if(invTransMaster.Record_Type__c == 'Sales'){
                 migrationStatus = new uploadInventry().insertDataUploadSales(invTransMaster);
            }
            
            Inventory_Transaction_Master__c invTransMast = new Inventory_Transaction_Master__c();            
            invTransMast.Id = batchId;            
            if(migrationStatus){
                invTransMast.Batch_Status__c = '8 - Migration Success';                   
            } else{
                invTransMast.Batch_Status__c = '9 - Migration Fail';                
            }
            try{
                update invTransMast;
            }catch(DMLException e){   
                transferStatus = false;
                system.debug('Error in transferTransctionDataToDataUploadMaster: during DataUploadTransaction'+e.getMessage());
            }            
        }else{
            transferStatus = false;
        }
        return transferStatus;
    }    
    @RemoteAction
    //This method updates the total no of rows processed and the sum of all the stock in qty.
    public static azureSalesFileUploadController.dataDetailsWrapper getUploadDetails(String batchId){
        boolean sales = false;
        boolean inventory = false;
        String recCount='';
        String stockQty = '';
        string recType = '';
        Inventory_Transaction_Master__c recordType = [select Record_Type__c from Inventory_Transaction_Master__c where id=:batchId];
        
        if(recordType!= null){
            recType = recordType.Record_Type__c;
            if(recType == 'Inventory'){
                inventory = true;
            }else if(recType == 'Sales'){
                sales = true;
            }
        }
        if(inventory){
            AggregateResult[] groupedResults = [select  Count(Id) recCount, SUM(Stock_In_Qty__c) stockQty from Data_Upload_Transaction__c where Upload_Batch_No__c=:batchId  GROUP BY Upload_Batch_No__c];

            for (AggregateResult ar : groupedResults)  {
                recCount = String.valueOf(ar.get('recCount'));
                stockQty  = String.valueOf( ar.get('stockQty'));
            }        
            if(String.isNotBlank(recCount) && String.isNotBlank(stockQty)){
                try{
                    Inventory_Transaction_Master__c updateBatchStatus = new Inventory_Transaction_Master__c();
                    updateBatchStatus.id = batchId;
                    updateBatchStatus.Total_Row_Count__c = Integer.valueOf(recCount);
                    updateBatchStatus.Uploaded_Total_Stock_In_Qty__c = integer.valueOf(stockQty);
                    update updateBatchStatus;
                }catch(DMLException ex){
                    System.debug('Exception during the update of RecCount and Stock Qty'+ex.getMessage());
                }
            }
        }
        if(sales){
            AggregateResult[] groupedResults = [select  Count(Id) recCount from Data_Upload_Sales__c where Upload_Batch_No__c=:batchId];
            for (AggregateResult ar : groupedResults)  {
                recCount = String.valueOf(ar.get('recCount'));
            }        
            if(String.isNotBlank(recCount)){
                try{
                    Inventory_Transaction_Master__c updateBatchStatus = new Inventory_Transaction_Master__c();
                    updateBatchStatus.id = batchId;
                    updateBatchStatus.Total_Row_Count__c = Integer.valueOf(recCount);
                    update updateBatchStatus;
                }catch(DMLException ex){
                    System.debug('Exception during the update of RecCount during Sales'+ex.getMessage());
                }
            }
        }
        return new azureSalesFileUploadController.dataDetailsWrapper(recCount, stockQty, recType);        
    }
    public class dataDetailsWrapper {
        String recCount;
        String stockQty;
        String recType;
        public dataDetailsWrapper(String rc, String sq, String rt) {
            this.recCount = rc;
            this.stockQty = sq;  
            this.recType = rt;
        }
    }    
    public class azureWrapper {
        
        String storageKey;
        String storageName;
        String containerName;
        
        public azureWrapper(String sk, String sn, String cn) {
            this.storageKey = sk;
            this.storageName = sn;  
            this.containerName = cn;  
        }
    }    
    public class csvWrapper {
        
        String csvTitle;
        String fileName;
        String csvFileContent;
        
        public csvWrapper(String ct, String fn, String fc) {
            this.csvTitle = ct;
            this.fileName = fn;  
            this.csvFileContent = fc;  
        }
    }    
}