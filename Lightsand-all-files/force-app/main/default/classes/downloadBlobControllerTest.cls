@IsTest(SeeAllData = true)
public class downloadBlobControllerTest {
	 @IsTest(SeeAllData=true) 
    public static void initilizeDownloadRecords() {
        downloadBlobController.azureWrapper aw = downloadBlobController.storageDetails();
        
        Design_Drawing_File_Details__c desigLogForm =new Design_Drawing_File_Details__c();
        desigLogForm.blogEtag__c  ='X1234567890';
        insert desigLogForm;
        
        
        /* desigLogForm.Project_ID__c = desigReqForm.Id;
         insert desigLogForm;          
        System.debug('desigReqForm.Id'+desigReqForm.Id);
        System.debug('Design Status###############'+desigReqForm.Design_Status__c);
        Id designId = desigLogForm.Id;  */        
        
         Test.startTest();          
              PageReference pageRef = new ApexPages.StandardController(desigLogForm).view();
              Test.setCurrentPage(pageRef);          
             
              ApexPages.currentPage().getParameters().put('blobetag',String.valueOf(desigLogForm.blogEtag__c));
        
              String currentRecordId = String.valueOf(ApexPages.currentPage().getParameters().get('blobetag'));
              desigLogForm = [select id ,Design_Drawing_Image_Link__c,Drawing_File_Type__c,Drawing_File_Name__c,File_Full_Path__c,Design_Version__c,Design_Log_Form__c from Design_Drawing_File_Details__c where blogEtag__c =: currentRecordId ];
              ApexPages.StandardController stdController =   new ApexPages.StandardController(desigLogForm);      
         	  downloadBlobController designController = new downloadBlobController(stdController);   
        Test.stopTest();        
     }
}