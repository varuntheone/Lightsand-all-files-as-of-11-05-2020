public class SubmitPageExtInternalUsers_jcpprl {
    public String onlineEnqId {get; set;}

    public SubmitPageExtInternalUsers_jcpprl(ApexPages.StandardController controller) {

       onlineEnqId = ApexPages.currentPage().getparameters().get('id');
       System.debug('######onlineEnqId :'+onlineEnqId);
       
    }

 
    public SubmitPageExtInternalUsers_jcpprl(ApexPages.StandardSetController controller) {
    
       onlineEnqId = ApexPages.currentPage().getparameters().get('id');
       System.debug('######onlineEnqId :'+onlineEnqId);
       
    }
    
    public PageReference init(){
        Online_Enquiry__c onlineEnquiry = [select Id,Retailer_Code__r.Name from Online_Enquiry__c where Id=:onlineEnqId];
        if(onlineEnqId != null && onlineEnqId.length() > 0){
            //Utility.getFinalPDFContent(onlineEnqId);
            //Utility_jcpprl.getFinalPDFContent(onlineEnqId);
            if(onlineEnquiry!=null && onlineEnquiry.Retailer_Code__r.Name!=null && (onlineEnquiry.Retailer_Code__r.Name.startswith('JC') || onlineEnquiry.Retailer_Code__r.Name.startswith('PRL'))){
                    Utility_jcpprl.getEnqConfirmPDFContent(onlineEnqId);            
                }else{
                     Utility.getQuotationPdf(onlineEnqId);
            }
        }
        //Online_Enquiry__c onlineEnquiry = [select Id from Online_Enquiry__c where Id=:onlineEnqId];
        return new ApexPages.StandardController(onlineEnquiry).view();
        
    }
}