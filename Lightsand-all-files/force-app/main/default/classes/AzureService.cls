/*This upload mechanism uses the Storage Key directly for the upload, Signature version- 2015-12-11*/
global with sharing class AzureService { 
    
    //returns storage key, storage name and container
    @RemoteAction
    public static AzureService.azureWrapper storageDetails(){
    	Azure_File_Blob_Storage_Dev__c detail = Azure_File_Blob_Storage_Dev__c.getInstance();
    	return new AzureService.azureWrapper(detail.StorageKey__c, detail.StorageName__c, detail.Container__c);
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