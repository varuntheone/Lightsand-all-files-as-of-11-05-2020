public class inventoryFileDownloadController {
 public Inventory_Transaction_Master__c invTransMast {get;set;}
	 public SObject parent;
    
    public inventoryFileDownloadController(ApexPages.StandardController sc) {
        parent  = sc.getRecord();
        invTransMast = [select Id ,upload_file_name__c from Inventory_Transaction_Master__c where  Id =:parent.Id ];
     
     }
     //returns storage key, storage name and container
    @RemoteAction
    public static inventoryFileDownloadController.azureWrapper storageDetails(){
    	inventory_azure_storage_details__c	 detail = inventory_azure_storage_details__c.getInstance();
    	return new inventoryFileDownloadController.azureWrapper(detail.storageKey__c, detail.storageName__c,detail.containerName__c);
    }
    
    public class azureWrapper {
    
    	String storageKey;
    	String storageName;
    	String containerName;    	
    	
    	public azureWrapper(String sk, String sn, String cn) {
    		this.storageKey = sk;
    		this.storageName = sn;  
            this.containerName = cn;  
        }
    }
}