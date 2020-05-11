public class PDFFilePreviewController {
    
    public ID contentVersionID {set;get;}
    
    public ContentVersion contVersionObj {
        get {
            if (contVersionObj == null) {
                contVersionObj = [Select Id,ContentDocumentId,versiondata,contentbodyId,FileType  from ContentVersion where Id= :contentVersionID];
            }
            return contVersionObj;
        }
        private set;
    }
    public String pdfData {
        get {            
            return EncodingUtil.Base64Encode(contVersionObj.versiondata);
        }
        private set;
    }
    
     public PDFFilePreviewController() {
        
        contentVersionID = ApexPages.currentPage().getparameters().get('id');

    }
    

}