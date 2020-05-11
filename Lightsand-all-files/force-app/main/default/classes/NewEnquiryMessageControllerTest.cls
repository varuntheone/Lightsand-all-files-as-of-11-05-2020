@IsTest public class NewEnquiryMessageControllerTest{
    
    @IsTest(SeeAllData=true) public static void testNewEnquiryMessageControllerTest() {
        system.currentPageReference().getParameters().put('OnlineEnquiryNo', 'a0f90000004zy0T');
        NewEnquiryMessageController messageCont = new NewEnquiryMessageController();
        messageCont.enquiryNo = 'Enq No';
        messageCont = new NewEnquiryMessageController();
    }

}