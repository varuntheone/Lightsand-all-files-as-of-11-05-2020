public class salesAdminAccessClass {
    @AuraEnabled
    public static List<Sales_Transaction_Stage__c> getRetailerData(string batchid){
        AggregateResult[]  vendor =[Select Vendor__c vendor from Sales_Transaction_Stage__c where Upload_Batch_No__c=:batchid
                                                        and Retailer_Check__c = True GROUP BY Vendor__c ];
        List<Sales_Transaction_Stage__c> fetchdata = new List<Sales_Transaction_Stage__c>();
        for(AggregateResult vend:vendor){
            Sales_Transaction_Stage__c transStage = new Sales_Transaction_Stage__c();
            transStage.Vendor__c = String.valueOf(vend.get('vendor'));
            fetchdata.add(transStage);
        }
        system.debug('retailers:'+fetchdata);
        return fetchdata;
    }
    
    @AuraEnabled
    public static List<Sales_Transaction_Stage__c> getModelData(string batchid){
        
        AggregateResult[]  model =[Select Model__c model from Sales_Transaction_Stage__c where Upload_Batch_No__c=:batchid
                                                        and Model_Check__c = True GROUP BY Model__c ];
        List<Sales_Transaction_Stage__c> fetchdata = new List<Sales_Transaction_Stage__c>();
        for(AggregateResult vend:model){
            Sales_Transaction_Stage__c transStage = new Sales_Transaction_Stage__c();
            transStage.Model__c = String.valueOf(vend.get('model'));
            fetchdata.add(transStage);
        }
        system.debug('models:'+fetchdata);
        return fetchdata;
    }
    
    @AuraEnabled
    public static boolean recStatusUpsertForInventory(string batchid){
        boolean status = true;
        string userEmail = UserInfo.getUserEmail();
       /* List<Sales_Transaction_Stage__c> fetchData = [Select Record_Status__c from Sales_Transaction_Stage__c where Upload_Batch_No__c=:BatchId];
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
    @AuraEnabled
    public static boolean recUpdateFOrInvFailure(string batchid){
        boolean status = true;
        Inventory_Transaction_Master__c updateCheckbox = new Inventory_Transaction_Master__c();
        updateCheckbox.Id = batchid;
        updateCheckbox.Failure_Notification__c = true;
        updateCheckbox.Batch_Status__c = '2 - Data Validation In Progress';
        updateCheckbox.Reprocessing__c = false;
        try {
            update updateCheckbox;
        } catch (DMLException e) {
            status = false;
        }
        return status; 
    }

}