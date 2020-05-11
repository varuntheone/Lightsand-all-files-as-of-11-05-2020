@IsTest
public class inventoryFileDownloadControllerTest {
    
    @IsTest
    public static void initilizeRecords() {
        Inventory_Transaction_Master__c invTransMast  = new Inventory_Transaction_Master__c(upload_file_name__c = 'a1Np000000Ih54DEAR/Ainoheader.csv');
        insert invTransMast;
        ApexPages.StandardController sc = new ApexPages.StandardController(invTransMast);
        inventoryFileDownloadController inv = new inventoryFileDownloadController(sc);
        inventoryFileDownloadController.azureWrapper aw = inventoryFileDownloadController.storageDetails();
    }
    
    
}