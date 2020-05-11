@IsTest(SeeAllData = true)
public class uploadSalespersonDesignFileTest {
		 @IsTest(SeeAllData=true) 
    public static void initilizeUploadRecords() {
        uploadSalespersonDesignFileController.azureWrapper aw = uploadSalespersonDesignFileController.storageDetails();
        //Design_Request_Form__c desigLogForm {get;set;}
        Design_Request_Form__c desigLogForm = new Design_Request_Form__c();
          insert desigLogForm;          
        
        Id designId = desigLogForm.Id;          
          
         Test.startTest();          
              PageReference pageRef = new ApexPages.StandardController(desigLogForm).view();
              Test.setCurrentPage(pageRef);          
             
              ApexPages.currentPage().getParameters().put('id', designId);             
              ApexPages.StandardController stdController =   new ApexPages.StandardController(desigLogForm);      
         	  uploadSalespersonDesignFileController designController = new uploadSalespersonDesignFileController(stdController);   
        Test.stopTest();        
     }
}