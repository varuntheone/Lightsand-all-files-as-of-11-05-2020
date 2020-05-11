global class recStatusUpsertForInventoryBulk implements Database.Batchable<sObject> , Database.Stateful {
    
    String query = 'SELECT Id,Record_Status__c from Sales_Transaction_Stage__c where Upload_Batch_No__c=:batchId ';    
    global String batchId;  
     private String userEmail;
    public recStatusUpsertForInventoryBulk(String batchId,String userEmail) {
        this.batchId = batchId; 
         this.userEmail = userEmail;
        
    }      
    global Database.querylocator start(Database.BatchableContext BC){
        System.debug('::::::::::::::: INSIDE THE START METHOD OF SALES UPLOAD BATCH recStatusUpsertForInventoryBulkPROCESSING :::::::::::::::::::::');
        return Database.getQueryLocator(query);            
    }    
    global void execute(Database.BatchableContext BC, List<Sales_Transaction_Stage__c> updateStage){
        System.debug('::::::::::::::: INSIDE THE EXECUTE METHOD OF SALES UPLOAD BATCH PROCESSING :::::::::::::::::::::');
        List<Sales_Transaction_Stage__c> salesTransStagUpdate = new List<Sales_Transaction_Stage__c>();
        for( Sales_Transaction_Stage__c stage : updateStage ){
            stage.Record_Status__c = '2 - Data Validation Successful';
            salesTransStagUpdate.add(stage);
        }
       
        if(salesTransStagUpdate != null && salesTransStagUpdate.size() > 0){
            try{            
                // Getting the total record count of the salesrecord for pagination
                Integer totalRecCountForUpdate = salesTransStagUpdate.size();
                System.debug('#### totalRecCountForUpdate '+totalRecCountForUpdate);
                Integer maxSizeForUpdate = 9000;
                if(totalRecCountForUpdate > maxSizeForUpdate){
                    for(Integer i = 0 ; i < (totalRecCountForUpdate / maxSizeForUpdate)+1 ; i++){
                        List<Sales_Transaction_Stage__c> salesTemp = new  List<Sales_Transaction_Stage__c>();
                        for(Integer j=(i*maxSizeForUpdate);(j<(i*maxSizeForUpdate)+maxSizeForUpdate) && j<totalRecCountForUpdate ; j++){
                            salesTemp.add(salesTransStagUpdate.get(j));
                        }
                        System.debug('#### salesTemp '+salesTemp.size());
                        update salesTemp;
                    }                    
                }else{
                    System.debug('#### ELSE salesTransStagUpdate ');
                    update salesTransStagUpdate;
                }
               
            }catch(DMLException e){                
                system.debug('Error in processSalesData: during DataUploadTransaction'+e.getMessage());            
            }
    }
    }
    global void finish(Database.BatchableContext BC){  
        Database.executeBatch(new salesSuccessData(batchId,userEmail),2000);
        //CALL INVENTORYFILE PUPLOAD CONTROLLER getUploadSales
        // Object reordCountObj = inventoryAzureFileUploadController.getUploadDetails(batchId);
        // system.debug('reordCountObj:'+reordCountObj);
        // string recCount = '';
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {userEmail};
            mail.setToAddresses(toAddresses);
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Batch Process Completed');
        mail.setPlainTextBody('Batch Process has completed');
        //Put the total records etc.. in the email body.
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
}