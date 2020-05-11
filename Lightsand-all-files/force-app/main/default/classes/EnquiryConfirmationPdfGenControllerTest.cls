@IsTest public class EnquiryConfirmationPdfGenControllerTest {

 @IsTest(SeeAllData = true) public static void testEnquiryConfirmationPdfGenControllerTest() {
  //String enquiryId = 'a0fN0000003v7Iw'; //sandbox
  //String enquiryIdWithoutOnlineDetails = 'a0fN0000003q3Jj'; //sandbox
  String enquiryId = 'a0f9000000IS7Dp'; //Production
  String enquiryIdWithoutOnlineDetails = 'a0f9000000IS2qb'; //Production
  system.currentPageReference().getParameters().put('id', enquiryId);
  system.currentPageReference().getParameters().put('quoteVersion', '1');
  EnquiryConfirmationPdfGenController dataCont = new EnquiryConfirmationPdfGenController();
  dataCont.lineBreaks(null);
  dataCont.lineBreaks('Testing');

  system.currentPageReference().getParameters().put('id', '');
  system.currentPageReference().getParameters().put('quoteVersion', '1');
  EnquiryConfirmationPdfGenController dataCont1 = new EnquiryConfirmationPdfGenController();
  dataCont1.lineBreaks(null);
  dataCont1.lineBreaks('Testing');

  system.currentPageReference().getParameters().put('id', enquiryIdWithoutOnlineDetails);
  system.currentPageReference().getParameters().put('quoteVersion', '1');
  EnquiryConfirmationPdfGenController dataCont2 = new EnquiryConfirmationPdfGenController();
  dataCont2.lineBreaks(null);
  dataCont2.lineBreaks('Testing');
  
  system.currentPageReference().getParameters().put('id', 'xyz');
  system.currentPageReference().getParameters().put('quoteVersion', '1');
  EnquiryConfirmationPdfGenController dataCont3 = new EnquiryConfirmationPdfGenController();
  dataCont3.lineBreaks(null);
  dataCont3.lineBreaks('Testing');
 }
}