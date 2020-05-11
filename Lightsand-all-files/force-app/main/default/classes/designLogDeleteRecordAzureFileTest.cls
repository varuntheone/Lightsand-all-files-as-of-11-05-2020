@IsTest(SeeAllData = true)
public class designLogDeleteRecordAzureFileTest {
 @IsTest(SeeAllData=true) 
    public static void initilizeDownloadRecords() {
        designLogDeleteRecordAzureFileController.azureWrapper aw = designLogDeleteRecordAzureFileController.storageDetails();
        
        Design_Drawing_File_Details__c desigLogForm =new Design_Drawing_File_Details__c();
        desigLogForm.blogEtag__c  ='X1234567890';
       insert desigLogForm;
        
    
         Test.startTest();          
              PageReference pageRef = new ApexPages.StandardController(desigLogForm).view();
              Test.setCurrentPage(pageRef);          
             
              ApexPages.currentPage().getParameters().put('Id',String.valueOf(desigLogForm.Id));
              ApexPages.StandardController stdController =   new ApexPages.StandardController(desigLogForm);      
         	  designLogDeleteRecordAzureFileController designController = new designLogDeleteRecordAzureFileController(stdController); 
        
              SObject parent = stdController.getRecord();
               desigLogForm = [select Id ,File_Full_Path__c,Design_Log_Form__c,Design_Request_Form__c from Design_Drawing_File_Details__c where  Id =:parent.Id ];
                
        Test.stopTest();        
     }
}