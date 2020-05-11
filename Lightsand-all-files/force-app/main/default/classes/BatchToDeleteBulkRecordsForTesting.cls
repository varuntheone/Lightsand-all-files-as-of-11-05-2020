global class BatchToDeleteBulkRecordsForTesting implements Database.Batchable<sObject> {
    
    String recName;
    String query = 'SELECT Id FROM CSV_File_Data__c where name =:recName';
	
	public BatchToDeleteBulkRecordsForTesting(string recName) {
        this.recName = recName;        
    }
    
    global Database.querylocator start(Database.BatchableContext BC){        
        return Database.getQueryLocator(query);            
    }
    
    global void execute(Database.BatchableContext BC, List<CSV_File_Data__c> csvRecordsTodelete){
        system.debug('csvRecordsTodeleteSize:'+csvRecordsTodelete.size());
    }
    
    global void finish(Database.BatchableContext BC){ 
        
    }

}