@IsTest(SeeAllData = true)
public class designLogControllerTest {
		 @IsTest(SeeAllData=true) 
    public static void designLogRecords() {
        designLogController.azureWrapper aw = designLogController.storageDetails();
        
       Design_Request_Form__c desigReqForm = new Design_Request_Form__c();
        desigReqForm.Design_Status__c = 'New_Design_Accepted_and_In_Progress';
        insert desigReqForm;          
        
        Id designId = desigReqForm.Id;    
        
        Design_Log_Form__c designLogForm =new Design_Log_Form__c();
         designLogForm.Project_Status__c = 'Shelved';   
		designLogForm.Project_ID__c = desigReqForm.Id;
        insert designLogForm;
        
    
         Test.startTest();          
              PageReference pageRef = new ApexPages.StandardController(designLogForm).view();
              Test.setCurrentPage(pageRef);          
             
              ApexPages.currentPage().getParameters().put('Id',String.valueOf(designLogForm.Id));
              ApexPages.StandardController stdController =   new ApexPages.StandardController(designLogForm);      
         	  designLogController designController = new designLogController(stdController); 
        
              
        Test.stopTest();        
     }
}