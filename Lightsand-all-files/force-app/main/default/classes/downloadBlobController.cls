public class downloadBlobController {
     public Design_Drawing_File_Details__c desigLogForm {get;set;}
	public String currentRecordId {get;set;}
    
    public downloadBlobController(ApexPages.StandardController sc) {
        currentRecordId  = String.valueOf(ApexPages.CurrentPage().getparameters().get('blobetag'));
        desigLogForm = [select id ,Design_Drawing_Image_Link__c,Drawing_File_Type__c,Drawing_File_Name__c,File_Full_Path__c,Design_Version__c,Design_Log_Form__c from Design_Drawing_File_Details__c where blogEtag__c =: currentRecordId ];
     
     }
    
     //returns storage key, storage name and container
    @RemoteAction
    public static downloadBlobController.azureWrapper storageDetails(){
    	Azure_File_Blob_Storage_Detail__c detail = Azure_File_Blob_Storage_Detail__c.getInstance();
    	return new downloadBlobController.azureWrapper(detail.StorageKey__c, detail.StorageName__c,detail.DesignDrawingContainer__c);
    }
    
    public class azureWrapper {
    
    	String storageKey;
    	String storageName;
    	String containerName;
    	String timestamp;
        String folderName;
    	String fileName;
    	String fileType;
    	String fileLength;
    	String signature;
    	
    	public azureWrapper(String sk, String sn, String cn) {
    		this.storageKey = sk;
    		this.storageName = sn;  
            this.containerName = cn;  
        }
    }


}