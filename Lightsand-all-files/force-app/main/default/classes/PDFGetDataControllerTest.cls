@IsTest public class PDFGetDataControllerTest {

 @IsTest(SeeAllData = true) public static void testPDFGetDataControllerTest() {
  //String enquiryId = 'a0fN0000003v7Iw'; //sandbox
  //String enquiryIdWithoutOnlineDetails = 'a0fN0000003q3Jj'; //sandbox
  String enquiryId = 'a0f9000000IS7Dp'; //Production
  String enquiryIdWithoutOnlineDetails = 'a0f9000000IS2qb'; //Production
  system.currentPageReference().getParameters().put('id', enquiryId);
  PDFGetDataController dataCont = new PDFGetDataController();
  String fromattedData = dataCont.thousandSeparator(Decimal.valueof(100000));
  System.debug('fromattedData:' + fromattedData);

  system.currentPageReference().getParameters().put('id', '');
  PDFGetDataController dataCont1 = new PDFGetDataController();
  String fromattedData1 = dataCont1.thousandSeparator(Decimal.valueof(100000));
  System.debug('fromattedData:' + fromattedData1);

  system.currentPageReference().getParameters().put('id', enquiryIdWithoutOnlineDetails);
  PDFGetDataController dataCont2 = new PDFGetDataController();
  String fromattedData2 = dataCont2.thousandSeparator(Decimal.valueof(100000));
  System.debug('fromattedData:' + fromattedData2);

  system.currentPageReference().getParameters().put('id', 'xyz');
  PDFGetDataController dataCont3 = new PDFGetDataController();
  String fromattedData3 = dataCont3.thousandSeparator(Decimal.valueof(100000));
  System.debug('fromattedData:' + fromattedData3);

 }
}