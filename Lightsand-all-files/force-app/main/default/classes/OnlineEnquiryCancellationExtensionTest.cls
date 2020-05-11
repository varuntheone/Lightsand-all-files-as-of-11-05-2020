@IsTest public class OnlineEnquiryCancellationExtensionTest {
 @IsTest(SeeAllData = true) public static void testNewProductSelectionExtensionTest() {
  //String onlineEnqId = 'a0fN0000003uJQz'; // sandbox
  String onlineEnqId = 'a0f9000000IS7Dp';// production
  Online_Enquiry__c onlineEnquiry = new Online_Enquiry__c();
  system.currentPageReference().getParameters().put('id', onlineEnqId);
  ApexPages.StandardController stdController = new ApexPages.StandardController(onlineEnquiry);
  OnlineEnquiryCancellationExtension ext = new OnlineEnquiryCancellationExtension(stdController);
  ext.Save();
  ext.Cancel();
  ext.updateCreateFlag();
 }
}