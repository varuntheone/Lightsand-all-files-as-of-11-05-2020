public class retailerPriceBookController {
    public Contact_Related_Retailer__c  retailerRelatedData {get;set;}
    public String retailerName {get;set;}
    public String folderPath {get;set;}
    
    public retailerPriceBookController(ApexPages.StandardController sc) {
        retailerName  = String.valueOf(ApexPages.CurrentPage().getparameters().get('retailerName'));
        //retailerName ='CRL0000758';
        retailerRelatedData = [SELECT Contact__r.FirstName,Retailer_Code__r.Name FROM Contact_Related_Retailer__c WHERE Name=:retailerName ];
        folderPath = retailerRelatedData.Retailer_Code__r.Name;
        System.debug('####folderPath'+folderPath);
     }

     @RemoteAction
    public static retailerPriceBookController.azureWrapper storageDetails(){
    	Azure_File_Blob_Storage_Dev__c detail = Azure_File_Blob_Storage_Dev__c.getInstance();
    	return new retailerPriceBookController.azureWrapper(detail.StorageKey__c, detail.StorageName__c, detail.Container__c);
    }
    
    public class azureWrapper{
    
    	String storageKey;
    	String storageName;
    	String containerName;
    	String timestamp;
    	String fileName;
    	String fileType;
    	String fileLength;
    	String signature;
    	
    	public azureWrapper(String sk, String sn, String cn){
    		this.storageKey = sk;
    		this.storageName = sn;
    		this.containerName = cn;
    	}
    }
}