public class uploadSalespersonDesignFileController {
   // getter and setter required to access and update record field from page.
   // public Design_Request_Form__c desigLogForm {get;set;}
	public String currentRecordId {get;set;}
    
    public uploadSalespersonDesignFileController(ApexPages.StandardController sc) {
         currentRecordId  = ApexPages.CurrentPage().getparameters().get('Id');		               
     }  
      //returns storage key, storage name and container
    @RemoteAction
    public static uploadSalespersonDesignFileController.azureWrapper storageDetails(){
    	Azure_File_Blob_Storage_Detail__c detail = Azure_File_Blob_Storage_Detail__c.getInstance();
    	return new uploadSalespersonDesignFileController.azureWrapper(detail.StorageKey__c, detail.StorageName__c,detail.DesignDrawingContainer__c);
    }
     public class azureWrapper{    
    	String storageKey;
    	String storageName;
    	String containerName;
    	String timestamp;
        String folderName;
    	String fileName;
    	String fileType;
    	String fileLength;
    	String signature;
    	
    	public azureWrapper(String sk, String sn,String cn){
    		this.storageKey = sk;
    		this.storageName = sn;
            this.containerName = cn;
    	}
    }
}