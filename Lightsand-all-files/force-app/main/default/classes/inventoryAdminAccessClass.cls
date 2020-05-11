public class inventoryAdminAccessClass {
    
    @AuraEnabled
    public static List<Inventory_Transaction_Stage__c> getRetailerData(string batchid){
        List<Inventory_Transaction_Stage__c> fetchdata=[Select Retailer_Code__c from Inventory_Transaction_Stage__c where Upload_Batch_No__c=:batchid
                                                        and Retailer_Check__c = True];
        system.debug('retailers:'+fetchdata);
        return fetchdata;
    }
    
    @AuraEnabled
    public static List<Inventory_Transaction_Stage__c> getModelData(string batchid){
        List<Inventory_Transaction_Stage__c> fetchdata=[Select Inventory_Model__c from Inventory_Transaction_Stage__c where Upload_Batch_No__c=:batchid
                                                        and Model_Check__c = True];
        system.debug('models:'+fetchdata);
        return fetchdata;
    }
    
    @AuraEnabled
    public static boolean recStatusUpsertForInventory(string batchid){
        boolean status = true;
        List<Inventory_Transaction_Stage__c> fetchData = [Select Record_Status__c from Inventory_Transaction_Stage__c where Upload_Batch_No__c=:BatchId];
        List<Inventory_Transaction_Stage__c> updateStage = new List<Inventory_Transaction_Stage__c>();
        for(Inventory_Transaction_Stage__c newStg :fetchData)
        {
            newStg.Record_Status__c = '2 - Data Validation Successful';
            updateStage.add(newStg);
        }
        try{
            upsert updateStage;
        }
        catch(DMLException e){
            status = false;
        }
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