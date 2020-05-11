trigger Attachment_Complaint on Attachment (after insert)
{ Id pId; for(Attachment att: Trigger.new){ pId=att.ParentId; } 
 List <Complaint__c> c=[select Id  from Complaint__c where Id=:pId]; //assuming one record is fetched. 
 c[0].Attachment_Check__c= true; update c[0]; }