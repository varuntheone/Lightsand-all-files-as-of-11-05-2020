@IsTest public class PDFQuotationGetDataControllerTest {

 @IsTest(SeeAllData = true) public static void testPDFQuotationGetDataControllerTest() {
  //String enquiryId = 'a0fN0000003v7Iw'; //sandbox
  //String enquiryIdWithoutOnlineDetails = 'a0fN0000003q3Jj'; //sandbox
  String enquiryId = 'a0f9000000IS7Dp'; //Production
  String enquiryIdWithoutOnlineDetails = 'a0f9000000IS2qb'; //Production
  system.currentPageReference().getParameters().put('id', enquiryId);
  system.currentPageReference().getParameters().put('quoteVersion', '1');
  PDFQuotationGetDataController dataCont = new PDFQuotationGetDataController();
  dataCont.lineBreaks('LineBreaksTest');
  dataCont.lineBreaks(null);
  dataCont.thousandSeparator(Decimal.valueof(100000));

  system.currentPageReference().getParameters().put('id', '');
  system.currentPageReference().getParameters().put('quoteVersion', '1');
  PDFQuotationGetDataController dataCont1 = new PDFQuotationGetDataController();
  dataCont1.lineBreaks('LineBreaksTest');
  dataCont1.lineBreaks(null);
  dataCont1.thousandSeparator(Decimal.valueof(100000));

  system.currentPageReference().getParameters().put('id', 'xyz');
  system.currentPageReference().getParameters().put('quoteVersion', '1');
  PDFQuotationGetDataController dataCont2 = new PDFQuotationGetDataController();
  dataCont2.lineBreaks('LineBreaksTest');
  dataCont2.lineBreaks(null);
  dataCont2.thousandSeparator(Decimal.valueof(100000));

  system.currentPageReference().getParameters().put('id', enquiryIdWithoutOnlineDetails);
  system.currentPageReference().getParameters().put('quoteVersion', '1');
  PDFQuotationGetDataController dataCont3 = new PDFQuotationGetDataController();
  dataCont3.lineBreaks('LineBreaksTest');
  dataCont3.lineBreaks(null);
  dataCont3.thousandSeparator(Decimal.valueof(100000));
 }
}