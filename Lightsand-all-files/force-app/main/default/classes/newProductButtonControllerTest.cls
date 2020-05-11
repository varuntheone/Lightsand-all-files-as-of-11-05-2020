@IsTest(SeeAllData = true)
public class newProductButtonControllerTest {
 @IsTest(SeeAllData=true) 
    public static void initilizNewDesignRecords() {
       
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
         	  newProductButtonController designController = new newProductButtonController(stdController); 
        
              SObject parent = stdController.getRecord();
               
        		designLogForm =[select Project_Status__c from Design_Log_Form__c where Id =:parent.Id];	
             System.assertNotEquals(designLogForm.Project_Status__c, 'Complete');
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Design Project Status has to be Complete, to create a New Product'));
        Test.stopTest();        
     }
}