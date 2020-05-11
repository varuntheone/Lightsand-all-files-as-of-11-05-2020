public class FileImageThumnailVFComponentContoroller {
    
    public List<ContentVersion> contentversionList {set;get;}
    
    public String opportunityItemId {set;get;}
    public String componentType {set;get;}
    
    public FileImageThumnailVFComponentContoroller() {
        
    }
    
     public pagereference getFiles() {
        
       
        List<ContentDocumentLink> ContentDocumentLinkList =  [Select Id,contentDocumentId from ContentDocumentLink where LinkedEntityId = :opportunityItemId];
        
        List<String> contentDocumentIdList = new   List<String> ();
        
        for(ContentDocumentLink eachContentDocumentLink : ContentDocumentLinkList){
            contentDocumentIdList.add(eachContentDocumentLink.contentDocumentId);
        }
        
        if(contentDocumentIdList!=null && contentDocumentIdList.size()>0){ 
            
            if(String.isNotEmpty(componentType) && componentType.equalsIgnoreCase('Quotation')){
                contentversionList = [Select Id,ContentDocumentId,contentbodyId,FileType  from ContentVersion where ContentDocumentId IN :contentDocumentIdList AND description IN ('Sales Quote','Supplier Quote')];
            }else{
                contentversionList = [Select Id,ContentDocumentId,contentbodyId,FileType  from ContentVersion where ContentDocumentId IN :contentDocumentIdList AND description =:componentType];
            }           
        }
        
         
         return null;
    }
    
    
    
}