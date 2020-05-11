public class SubmitEnquiryPdfToSalesEx {
public String onlineEnqId {get; set;}
  public SubmitEnquiryPdfToSalesEx() {
    onlineEnqId = ApexPages.currentPage().getparameters().get('id');
    System.debug('######onlineEnqId :'+onlineEnqId);
  }

  public PageReference init() {
    if(onlineEnqId != null && onlineEnqId.length() > 0){
            Utility.getEnquiryPdfContent(onlineEnqId);
        }
        Online_Enquiry__c onlineEnquiry = [select Id from Online_Enquiry__c where Id=:onlineEnqId];
        return new ApexPages.StandardController(onlineEnquiry).view();
  }
}