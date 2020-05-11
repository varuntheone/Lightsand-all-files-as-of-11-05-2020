global class CreatePOFromCaseCSVAttachBatchScheduler implements Schedulable {
   global void execute(SchedulableContext ctx) {
       
           List<ID> caseIdList = new List<ID>();
           List<Case> caseList = [Select Id From Case where Batch_Status__c='Not Started' AND Origin='PO Email'];
       
       	   if(caseList!=null && caseList.size() > 0){
           		
                for(Case eachCase : caseList){
              		caseIdList.add(eachCase.ID);           
       	   		}
               
                String query ='Select Id, Name, Body, BodyLength,ParentId from Attachment where ParentId IN (SELECT Id from EmailMessage where ParentId IN :caseIdList)';
                System.Debug('query:'+query);
                CreatePOFromCaseCSVAttachBatch processCaseCSVBatch = new CreatePOFromCaseCSVAttachBatch(query,caseIdList); 
                Database.executeBatch(processCaseCSVBatch,1);           
           }        
   }   
}