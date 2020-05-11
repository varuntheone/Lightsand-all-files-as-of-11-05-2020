public class OnlineEnquiryCancellationExtension{
	private ApexPages.StandardController stdCtrl;
    public Online_Enquiry__c onlineEnquiryOrder {get; set;}
    private String enquiryId {get; set;}
    public OnlineEnquiryCancellationExtension(ApexPages.StandardController controller){
        enquiryId = ApexPages.currentPage().getparameters().get('id');
        onlineEnquiryOrder=[SELECT Id,flagOnCreate__c,Name,Cancellation_Remark__c,Cancellation_Request_Checkbox__c 
                            FROM Online_Enquiry__c WHERE ID=:enquiryId];
    }
    
    public PageReference Save(){
        onlineEnquiryOrder.Cancellation_Request_Checkbox__c=true;
        update(onlineEnquiryOrder);
    	return new PageReference('/MainettiOnline/'+enquiryId);
    }
    public PageReference Cancel(){
        return new PageReference('/MainettiOnline/'+enquiryId);
    }
    public PageReference updateCreateFlag(){
        onlineEnquiryOrder.flagOnCreate__c=false;
        update(onlineEnquiryOrder);
        return null;
    }
}