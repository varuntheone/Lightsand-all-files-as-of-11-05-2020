@IsTest public class OnlineEnquiryOrderFormExtensionTest{
    @IsTest(SeeAllData=true) public static void testOnlineEnquiryOrderFormExtensionTest() {
       User portalUser = [select id, Order_to_Company__c, Buyer_Code__c from User where Id='00590000002Gt6B'];
        System.runAs(portalUser){ 
            Online_Enquiry__c onlineEnq = new Online_Enquiry__c();
            //enq.Bill_To__c = 'a0jN0000002EAeB';
            //enq.Ship_To__c = 'a0jN0000002Egk4';
            onlineEnq = [select Bill_To__c, Ship_To__c from Online_Enquiry__c where Id='a0f900000050AvE'];
            ApexPages.StandardController stdController = new ApexPages.StandardController(onlineEnq);
            OnlineEnquiryOrderFormExtension extension = new OnlineEnquiryOrderFormExtension(stdController);
            extension.loggedInUser = portalUser;
            Online_Enquiry__c enq = new Online_Enquiry__c();
            enq.TempRetailerCodeId__c = 'a0090000003DMBR';
            enq.Retailer_Code2__c = 'JC PENNEY';
            //enq.Bill_To__c = 'a0jN0000002EAeB';
            //enq.Ship_To__c = 'a0jN0000002Egk4';
            //extension.onlineEnquiryOrderDetails = new Online_Enquiry__c(TempRetailerCodeId__c='a00N000000310vP', Retailer_Code2__c='JC PENNEY');
           // enq = [select Bill_To__c, Ship_To__c from Online_Enquiry__c where Id='a0gN0000000pYVC'];
            extension.onlineEnquiryOrderDetails = enq;
            extension.PopulateBillTo();
            extension.PopulateShipTo();
            extension.Save();
            extension.getmyimageurl();
            
            List<Contact_Related_Retailer__c> retailerCodes = [select Name, Retailer_Code__c, Retailer_Name__c, Contact__c from Contact_Related_Retailer__c where Contact__c='0039000000u0z7Z' order by CreatedDate desc];
            extension.checkIfJCPPresent(retailerCodes); 
            //extension.
            //extension.b
            onlineEnq = [select Bill_To__c, Ship_To__c from Online_Enquiry__c where Id='a0f900000050AvE'];
            onlineEnq.Enquiry_Date__c = null;
        //onlineEnq.Sales_Representative__c = '';
        //onlineEnq.Mainetti_Company__c = 'test';
        onlineEnq.Bill_to_Company__c = null;
        onlineEnq.Bill_to_Address1__c = null;
        onlineEnq.Bill_to_Address2__c = null;
        onlineEnq.Bill_to_Contact__c = null;
        onlineEnq.Bill_to_State__c = null;
        onlineEnq.Bill_to_Country__c = null;
        onlineEnq.Bill_to_Email__c = null;
        onlineEnq.Bill_to_Fax__c= '9663266726';
        onlineEnq.Bill_to_Postcode__c = null;
        onlineEnq.Bill_to_Tel__c='9663266726';
        onlineEnq.Ship_to_Address1__c=null;
        onlineEnq.Ship_to_Address2__c=null;
        onlineEnq.Ship_to_Company__c=null;
        onlineEnq.Ship_to_Contact__c=null;
        onlineEnq.Ship_to_Country__c=null;
        onlineEnq.Ship_to_Email__c=null;
        onlineEnq.Ship_to_Fax__c='9663266726';
        onlineEnq.Ship_to_Tel__c = null;
        onlineEnq.Ship_to_Postcode__c=null;
        onlineEnq.Ship_to_State__c=null;
        onlineEnq.Ship_to_Tel__c='9663266726';
        update onlineEnq;
            stdController = new ApexPages.StandardController(onlineEnq);
            OnlineEnquiryOrderFormExtension extension1 = new OnlineEnquiryOrderFormExtension(stdController);
           extension1.PopulateBillTo();
           extension1.PopulateShipTo();
        }
    }
}