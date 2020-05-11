public class NewEnquiryMessageController{
    public String enquiryNo {get; set;}
    public String message {get; set;}
    public NewEnquiryMessageController(){
        enquiryNo = ApexPages.currentPage().getparameters().get('OnlineEnquiryNo');
        if(enquiryNo!=null && enquiryNo.length()>0){
            message = 'Your new Enquiry ID : '+enquiryNo+' was created successfully.';
        }
    }
}