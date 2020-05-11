@IsTest public class EnquirySearchTest{

    @IsTest(SeeAllData=true) public static void testEnquirySearchTest() {
        String onlineEnquiryId = 'a0f900000050AvE';
        String onlineDetailId = 'a0g9000000CzqAQ';
        String onlineEnquiryWithoutDetail = 'a0f900000059LL5';
        Online_Enquiry__c onlineEnquiryTemp = new Online_Enquiry__c();
        ApexPages.StandardController stdController = new ApexPages.StandardController(onlineEnquiryTemp);
        EnquirySearchFrontControllerPagination enqSer = new EnquirySearchFrontControllerPagination(stdController);
        
        enqSer.onlineEnquiry = [select Name, Enquiry_Date__c, Ship_to_Country__c, Customer_PO_No__c, Order_Country__c, Expected_Ship_Date__c, Enquiry_Status__c from Online_Enquiry__c where Id=:onlineEnquiryId];
        enqSer.onlineDetail = [Select Model__c, Color__c, Product_Type__c, Product_Family__c, Product_Description__c, Qty__c, Model_Remark__c, TempModel__c from Online_Detail__c where Id=:onlineDetailId];
        enqSer.Search();
        onlineEnquiryTemp = [Select Id, Name, Enquiry_Date__c, Ship_to_Country__c, Customer_PO_No__c, Order_Country__c, Expected_Ship_Date__c, Enquiry_Status__c, Mainetti_Company__c, Sales_Representative__c, Retailer_Code__c, Bill_to_Company__c, Bill_to_Address1__c, Bill_to_Address2__c, Bill_to_State__c, Bill_to_Postcode__c, Bill_to_Country__c, Ship_to_Company__c, Ship_to_Address1__c, Ship_to_Address2__c, Ship_to_State__c, Ship_to_Postcode__c, Retailer_Code1__c, (Select Model__c, Color__c, Product_Type__c, Product_Family__c, Product_Description__c, Qty__c, Model_Remark__c, TempModel__c from Transaction_Detail__r) from Online_Enquiry__c WHERE Id=:onlineEnquiryId];
         LIST<Online_Enquiry__c> onlineEnquiriesResultList = new List<Online_Enquiry__c>();
        	onlineEnquiriesResultList.add(onlineEnquiryTemp);
        enqSer.buildSearchResult(onlineEnquiriesResultList);
        enqSer.checkOnlineDetailQueryPresent();
        enqSer.getCounter();
        enqSer.getDisableNext();
        enqSer.End();
        enqSer.getPageNumber();
        enqSer.setErrorForFieldName(true);
        enqSer.getErrorForFieldName();
        enqSer.setErrorForFieldName(false);
        enqSer.getList_size();
        enqSer.Beginning();
        enqSer.Next();
        enqSer.Previous();
        
        enqSer.getDisablePrevious();
        enqSer.getTotal_size();
        enqSer.getTotalPages();
        onlineEnquiryTemp = [Select Id, Name, Enquiry_Date__c, Ship_to_Country__c, Customer_PO_No__c, Order_Country__c, Expected_Ship_Date__c, Enquiry_Status__c, Mainetti_Company__c, Sales_Representative__c, Retailer_Code__c, Bill_to_Company__c, Bill_to_Address1__c, Bill_to_Address2__c, Bill_to_State__c, Bill_to_Postcode__c, Bill_to_Country__c, Ship_to_Company__c, Ship_to_Address1__c, Ship_to_Address2__c, Ship_to_State__c, Ship_to_Postcode__c, Retailer_Code1__c, (Select Model__c, Color__c, Product_Type__c, Product_Family__c, Product_Description__c, Qty__c, Model_Remark__c, TempModel__c from Transaction_Detail__r) from Online_Enquiry__c WHERE Id=:onlineEnquiryWithoutDetail];
        onlineEnquiriesResultList = new List<Online_Enquiry__c>();
       	onlineEnquiriesResultList.add(onlineEnquiryTemp);
         enqSer.buildSearchResult(onlineEnquiriesResultList);
    }
}