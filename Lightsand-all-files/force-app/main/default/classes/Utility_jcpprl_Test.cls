@IsTest public class Utility_jcpprl_Test {
 @IsTest(SeeAllData = true) public static void testUtilityTest() {
  Online_Enquiry__c enq = [select Enquiry_Date__c from Online_Enquiry__c limit 1];
  Utility_jcpprl.getFinalPDFContent(enq.id);
  Utility_jcpprl.getEnqConfirmPDFContent(enq.id);

  Utility_jcpprl.getFormattedDate(enq.Enquiry_Date__c);
  enq = [select Enquiry_Date__c from Online_Enquiry__c limit 1];
  enq.Enquiry_Date__c = null;
  enq.Bill_to_Company__c = null;
  enq.Bill_to_Address1__c = null;
  enq.Bill_to_Address2__c = null;
  enq.Bill_to_Contact__c = null;
  enq.Bill_to_State__c = null;
  enq.Bill_to_Country__c = null;
  enq.Bill_to_Email__c = null;
  enq.Bill_to_Fax__c = '9663266726';
  enq.Bill_to_Postcode__c = null;
  enq.Bill_to_Tel__c = '9663266726';
  enq.Ship_to_Address1__c = null;
  enq.Ship_to_Address2__c = null;
  enq.Ship_to_Company__c = null;
  enq.Ship_to_Contact__c = null;
  enq.Ship_to_Country__c = null;
  enq.Ship_to_Email__c = null;
  enq.Ship_to_Fax__c = '9663266726';
  enq.Ship_to_Tel__c = null;
  enq.Ship_to_Postcode__c = null;
  enq.Ship_to_State__c = null;
  enq.Ship_to_Tel__c = '9663266726';
  update enq;
  Utility_jcpprl.getFinalPDFContent(enq.Id);
  Online_Detail__c det = new Online_Detail__c();
  det.TransactionID__c = enq.Id;
  det.Retailer_Push_Qty__c = 123;
  insert det;
  Utility_jcpprl.getFinalPDFContent(enq.Id);
 }
}