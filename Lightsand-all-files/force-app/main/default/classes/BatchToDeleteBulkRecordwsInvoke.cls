public class BatchToDeleteBulkRecordwsInvoke {
    
    public static void processOrder (String recName) {
        Database.executeBatch(new BatchToDeleteBulkRecordsForTesting(recName),10);
    }

}