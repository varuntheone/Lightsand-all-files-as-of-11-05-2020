public class StopReminderExtensionInternalUsers {
        public String onlineEnqId {get; set;}
    public StopReminderExtensionInternalUsers(ApexPages.StandardController controller) {
        onlineEnqId = ApexPages.currentPage().getparameters().get('id');
        System.debug('######onlineEnqId :'+onlineEnqId);
    }
    
    public PageReference init(){
        Online_Enquiry__c onlineEnquiry = [select Id from Online_Enquiry__c where Id=:onlineEnqId];
        onlineEnquiry.Quotation_Status__c = 'Quotation Cancel';
        onlineEnquiry.Is_Email_Reminder_Enabled__c=false;
        onlineEnquiry.Enquiry_Status__c = 'CANCELLED';
        update(onlineEnquiry);
        return new ApexPages.StandardController(onlineEnquiry).view();
        
    }
}