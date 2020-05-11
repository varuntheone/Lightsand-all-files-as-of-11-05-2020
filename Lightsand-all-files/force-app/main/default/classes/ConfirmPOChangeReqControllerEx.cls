public class ConfirmPOChangeReqControllerEx {
    public String onlineEnqId {get; set;}

    public ConfirmPOChangeReqControllerEx(ApexPages.StandardController controller) {

       onlineEnqId = ApexPages.currentPage().getparameters().get('id');
       System.debug('######onlineEnqId :'+onlineEnqId);
       
    }

   public PageReference init(){
        if(onlineEnqId != null && onlineEnqId.length() > 0){
            //Utility.getFinalPDFContent(onlineEnqId);
        }
        Online_Enquiry__c onlineEnquiry = [select Id,Enquiry_Status__c from Online_Enquiry__c where Id=:onlineEnqId];
        onlineEnquiry.Enquiry_Status__c='PO Changed Received';
        update(onlineEnquiry); 
        return new ApexPages.StandardController(onlineEnquiry).view();
        
    }
}