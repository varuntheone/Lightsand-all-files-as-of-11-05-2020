public class SubmitQuoteExtensionInternalUsers {
 
    public String onlineEnqId {get; set;}
    public SubmitQuoteExtensionInternalUsers(ApexPages.StandardSetController controller) {
    
       onlineEnqId = ApexPages.currentPage().getparameters().get('id');
       System.debug('######onlineEnqId :'+onlineEnqId);
       
    }
    
    public PageReference init(){
        if(onlineEnqId != null && onlineEnqId.length() > 0){
            //Utility.getFinalPDFContent(onlineEnqId);
            Utility.getQuotationPdf(onlineEnqId);
        }
        Online_Enquiry__c onlineEnquiry = [select Id from Online_Enquiry__c where Id=:onlineEnqId];
        return new ApexPages.StandardController(onlineEnquiry).view();
        
    }
}