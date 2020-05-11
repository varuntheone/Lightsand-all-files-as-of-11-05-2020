public class designLogDeleteRecordAzureFileController {
public Design_Drawing_File_Details__c desigLogForm {get;set;}
	 public SObject parent;
    
    public designLogDeleteRecordAzureFileController(ApexPages.StandardController sc) {
        parent  = sc.getRecord();
        desigLogForm = [select Id ,File_Full_Path__c,Design_Log_Form__c,Design_Request_Form__c from Design_Drawing_File_Details__c where  Id =:parent.Id ];
     
     }
     //returns storage key, storage name and container
    @RemoteAction
    public static designLogDeleteRecordAzureFileController.azureWrapper storageDetails(){
    	Azure_File_Blob_Storage_Detail__c detail = Azure_File_Blob_Storage_Detail__c.getInstance();
    	return new designLogDeleteRecordAzureFileController.azureWrapper(detail.StorageKey__c, detail.StorageName__c,detail.DesignDrawingContainer__c);
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