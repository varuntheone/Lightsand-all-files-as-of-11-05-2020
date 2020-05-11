@IsTest public class UtilityTest{
    @IsTest(SeeAllData=true) public static void testUtilityTest() {
        Online_Enquiry__c enq = [select Enquiry_Date__c from Online_Enquiry__c limit 1];
        Utility.getFinalPDFContent(enq.id);
        Utility.getEnquiryPdfContent(enq.id);
        Utility.getQuotationPdf(enq.id);
        
        Utility.getFormattedDate(enq.Enquiry_Date__c);
        enq = [select Enquiry_Date__c from Online_Enquiry__c limit 1];
        //enq.RecordTypeId = '012p00000008H4V'; //sandbox
        enq.RecordTypeId = '0120o0000014ZVZ'; //production
        enq.Enquiry_Date__c = null;
        enq.Bill_to_Company__c = null;
        enq.Bill_to_Address1__c = null;
        enq.Bill_to_Address2__c = null;
        enq.Bill_to_Contact__c = null;
        enq.Bill_to_State__c = null;
        enq.Bill_to_Country__c = null;
        enq.Bill_to_Email__c = null;
        enq.Bill_to_Fax__c= '9663266726';
        enq.Bill_to_Postcode__c = null;
        enq.Bill_to_Tel__c='9663266726';
        enq.Ship_to_Address1__c=null;
        enq.Ship_to_Address2__c=null;
        enq.Ship_to_Company__c=null;
        enq.Ship_to_Contact__c=null;
        enq.Ship_to_Country__c=null;
        enq.Ship_to_Email__c=null;
        enq.Ship_to_Fax__c='9663266726';
        enq.Ship_to_Tel__c = null;
        enq.Ship_to_Postcode__c=null;
        enq.Ship_to_State__c=null;
        enq.Ship_to_Tel__c='9663266726';
        update enq;
        Utility.getFinalPDFContent(enq.Id);
        Online_Detail__c det = new Online_Detail__c();
        det.TransactionID__c = enq.Id;
        det.Retailer_Push_Qty__c = 123;
        insert det;
        Utility.getFinalPDFContent(enq.Id);
    }
}