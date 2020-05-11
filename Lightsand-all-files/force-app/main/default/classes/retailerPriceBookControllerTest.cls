@IsTest(SeeAllData = true)
public class retailerPriceBookControllerTest {
 @IsTest(SeeAllData=true) 
    public static void initilizeDownloadRecords() {
        retailerPriceBookController.azureWrapper aw = retailerPriceBookController.storageDetails();
        
         Contact cont = [SELECT name from contact where AccountId IN (Select Id from Account where name ='Community Account') LIMIT 1];         
         
        Retailer_Code__c retailercode = new Retailer_Code__c(Name = 'DECATHLON',Online_Enquiry__c=True);
        insert retailercode;
        
         
        Contact_Related_Retailer__c contRelatedRetail =new Contact_Related_Retailer__c();
        contRelatedRetail.Contact__c = cont.Id;
        //contRelatedRetail.ContactID__c = cont.Id;        
        contRelatedRetail.retailer_code__c = retailercode.Id;         
        insert contRelatedRetail;  
        
         Contact_Related_Retailer__c contRelatedRetailQuery = [SELECT Name from Contact_Related_Retailer__c where Id =: contRelatedRetail.Id]; 
         Test.startTest();          
              PageReference pageRef = new ApexPages.StandardController(contRelatedRetail).view();
              Test.setCurrentPage(pageRef);          
               System.debug('contRelatedRetail.Name###'+contRelatedRetail.Name);
              ApexPages.currentPage().getParameters().put('retailerName',String.valueOf(contRelatedRetailQuery.Name));        
        
              String retailerName = String.valueOf(ApexPages.currentPage().getParameters().get('retailerName'));
               System.debug('#####retailerName'+retailerName);
              contRelatedRetail = [SELECT Contact__r.FirstName,Retailer_Code__r.Name FROM Contact_Related_Retailer__c WHERE Name=:retailerName LIMIT 1 ];
              ApexPages.StandardController stdController =   new ApexPages.StandardController(contRelatedRetail);      
         	  retailerPriceBookController designController = new retailerPriceBookController(stdController);   
        Test.stopTest();        
     }
}