public class SubmitPageExtensionInternalUsers {
    public String onlineEnqId {get; set;}

    public SubmitPageExtensionInternalUsers(ApexPages.StandardController controller) {

       onlineEnqId = ApexPages.currentPage().getparameters().get('id');
       System.debug('######onlineEnqId :'+onlineEnqId);
       
    }

 
    public SubmitPageExtensionInternalUsers(ApexPages.StandardSetController controller) {
    
       onlineEnqId = ApexPages.currentPage().getparameters().get('id');
       System.debug('######onlineEnqId :'+onlineEnqId);
       
    }
    
    public PageReference init(){
        if(onlineEnqId != null && onlineEnqId.length() > 0){
            Utility.getFinalPDFContent(onlineEnqId);
        }
        Online_Enquiry__c onlineEnquiry = [select Id from Online_Enquiry__c where Id=:onlineEnqId];
        return new ApexPages.StandardController(onlineEnquiry).view();
        
    }
    
    public PageReference generateRevisedPO(){
        if(onlineEnqId != null && onlineEnqId.length() > 0){
            Utility.getRevisedFinalPDFContent(onlineEnqId);
        }
        Online_Enquiry__c onlineEnquiry = [select Id from Online_Enquiry__c where Id=:onlineEnqId];
        return new ApexPages.StandardController(onlineEnquiry).view();
        
    }
}