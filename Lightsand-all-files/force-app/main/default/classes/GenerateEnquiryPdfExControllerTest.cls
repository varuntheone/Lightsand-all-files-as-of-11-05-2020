@IsTest public class GenerateEnquiryPdfExControllerTest {

 @IsTest(SeeAllData = true) public static void testGenerateEnquiryPdfExControllerTest() {
  //String enquiryId = 'a0fN0000003v7Iw'; //sandbox
  //String enquiryIdWithoutOnlineDetails = 'a0fN0000003q3Jj'; //sandbox
  String enquiryId = 'a0f9000000IS7Dp'; //Production
  String enquiryIdWithoutOnlineDetails = 'a0f9000000IS2qb'; //Production
  system.currentPageReference().getParameters().put('id', enquiryId);
  GenerateEnquiryPdfExController dataCont = new GenerateEnquiryPdfExController();

  system.currentPageReference().getParameters().put('id', '');
  GenerateEnquiryPdfExController dataCont1 = new GenerateEnquiryPdfExController();

  system.currentPageReference().getParameters().put('id', enquiryIdWithoutOnlineDetails);
  GenerateEnquiryPdfExController dataCont2 = new GenerateEnquiryPdfExController();
  
   system.currentPageReference().getParameters().put('id', 'xyz');
  GenerateEnquiryPdfExController dataCont3 = new GenerateEnquiryPdfExController();
 }
}