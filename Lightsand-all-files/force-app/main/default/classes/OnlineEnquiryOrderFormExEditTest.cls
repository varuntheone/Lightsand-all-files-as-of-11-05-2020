@IsTest public class OnlineEnquiryOrderFormExEditTest {
 @IsTest(SeeAllData = true) public static void testOnlineEnquiryOrderFormExtensionTest() {
   //User portalUser = [select id, Order_to_Company__c, Buyer_Code__c from User where Id = '005N0000000yZwL'];
   // System.runAs(portalUser) {
   Online_Enquiry__c onlineEnq = [select Id, Label__c, JCP_Sub_division5__c, JCP_Sub_division2__c, RecordTypeId, JCP_Sub_division4__c,
    JCP_Sub_division1__c, JCP_Sub_division3__c, Customer_PO_No__c, Season__c, Division__c, Season_Year__c, MMG_PO_Number__c, Bill_To__c, Ship_To__c,
    Retailer_Image_ID__c, Retailer_Code_Hidden__c, Enquiry_Status__c, Name, Enquiry_Date__c, Sales_Representative__c, Mainetti_Company__c,
    Bill_to_Company__c, Bill_to_Address1__c, Bill_to_Address2__c, Bill_to_Contact__c, Bill_to_State__c, Bill_to_Country__c, Bill_to_Email__c,
    Bill_to_Fax__c, Bill_to_Postcode__c, Bill_to_Tel__c, Ship_to_Address1__c, Ship_to_Address2__c, Ship_to_Company__c, Ship_to_Contact__c,
    Ship_to_Country__c, Ship_to_Email__c, Ship_to_Fax__c, Ship_to_Postcode__c, Ship_to_State__c, Ship_to_Tel__c, Order_Country__c, Order_Customer_Name__c,
    OwnerId, Expected_Ship_Date__c, Customer_Comments__c, Retailer_Code__c, Preferred_Currency__c, Tax__c, Freight_Charges__c,
    Admin_Charges__c, Export_Term__c, Sales_Rep_Remark__c, Partner_Id__c, Payment_Term__c, Account_Manager__c,
    Account_Manager_Email_Address__c, Account_Manager_Contact_Number__c, Supplier_Code__c, Manufacturer_Code__c,
    TempRetailerCodeId__c, Retailer_Image__c, Retailer_Code__r.Name from Online_Enquiry__c limit 1
   ];

   PageReference ref = new PageReference('/apex/OnlineEnquiryOrderFormEdit?id=' + onlineEnq.id);
   Test.setCurrentPage(ref);
   OnlineEnquiryOrderFormExEdit extensionsd = new OnlineEnquiryOrderFormExEdit(null);
   extensionsd.save();
   extensionsd.PopulateBillTo();
   extensionsd.PopulateShipTo();
   extensionsd.Save();
   extensionsd.getmyimageurl();
   //extensionsd.enableMMGPOField();

   ApexPages.StandardController stdController = new ApexPages.StandardController(onlineEnq);
   OnlineEnquiryOrderFormExEdit extension = new OnlineEnquiryOrderFormExEdit(stdController);

   onlineEnq.Division__c = 'LDP';
   extension.userLocale = 'en_US';
   extension.onlineEnquiryOrderDetails = onlineEnq;
   extension.PopulateBillTo();
   extension.PopulateShipTo();
   extension.Save();
   extension.getmyimageurl();
   //extension.enableAllSections();
   extension.enableMMGPOField();

   //onlineEnq = [select Id, Bill_To__c, Ship_To__c from Online_Enquiry__c where Id = 'a0fN0000003uAgT']; //Sandbox
   onlineEnq = [select Id, Bill_To__c, Ship_To__c from Online_Enquiry__c where Id = 'a0f900000059MJ8']; //Production
   onlineEnq.Bill_To__c = null;
   onlineEnq.Ship_To__c = null;
   update onlineEnq;
   stdController = new ApexPages.StandardController(onlineEnq);
   OnlineEnquiryOrderFormExEdit extension1 = new OnlineEnquiryOrderFormExEdit(stdController);
   extension1.onlineEnquiryOrderDetails = onlineEnq;
   extension1.PopulateBillTo();
   extension1.PopulateShipTo();
  }
  //}
}