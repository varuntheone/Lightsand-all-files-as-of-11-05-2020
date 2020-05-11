global class deleteTheRecordsBasedonId implements Database.Batchable<sObject> , Database.Stateful
{
    String query = 'SELECT Id FROM Sales_Transaction_Stage__c WHERE Upload_Batch_No__c=:batchId';
    private String batchId;
    public deleteTheRecordsBasedonId(String batchId) {
        System.debug('########## START OF REUPLOAD DELETE CONSTRUCTOR BATCH ID'+batchId);
        this.batchId = batchId;
    }
    global Database.querylocator start(Database.BatchableContext BC){
        boolean delStatus =  new getMasterData().deleteCSVFile(batchId);
        return Database.getQueryLocator(query);        
    }    
    global void execute(Database.BatchableContext BC, List<Sales_Transaction_Stage__c> salesTransStage)
     {    try{
            delete salesTransStage;
        }catch(DMLException ex){
            System.debug('Exception during bulk delete '+ex.getMessage());
        }
    }    
    global void finish(Database.BatchableContext BC)
    {
        Inventory_Transaction_Master__c Transactions = new Inventory_Transaction_Master__c();           
        Transactions.Id = batchId;                   
        try{
            delete Transactions;            
        }catch(DMLException e){             
            system.debug('Error in deleteTheRecordsBasedonId: during Delete Master Record'+e.getMessage());
        }
        system.debug('######## Complete the Deletion of Master Record');       
    }
}