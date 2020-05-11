public class SubmitPageExtension {
 
    public String onlineEnqId {get; set;}
    public SubmitPageExtension(ApexPages.StandardSetController controller) {
    
       onlineEnqId = ApexPages.currentPage().getparameters().get('id');
       System.debug('######onlineEnqId :'+onlineEnqId);
       
    }
    
    public PageReference init(){
        if(onlineEnqId != null && onlineEnqId.length() > 0){
            Utility.getEnquiryPdfContent(onlineEnqId);
        }
        
        PageReference newocp = new PageReference('/CustomerPortal/'+ onlineEnqId);
        newocp.setRedirect(true);
        return newocp;
        
    }
}