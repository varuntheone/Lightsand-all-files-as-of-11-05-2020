public class D_CheckShipDateControllerEx {

 public Online_Enquiry__c onlineEnquiry {
  get;
  set;
 }

 public String onlineEnquiryId {
  get;
  set;
 }

 public String usdToLocalCurrency {
  get;
  set;
 }

 transient public Integer LeadTimeByPriceBookProduct {
  get;
  set;
 }
 
 public List < Price_Specification_Book_Product__c > priceBookProducts {
  get;
  set;
 }

 /**
  * This is a constructor.
  */
 public D_CheckShipDateControllerEx(ApexPages.StandardController controller) {
  // getting URL parameters 
  onlineEnquiryId = ApexPages.currentPage().getParameters().get('OnlineEnquiryId');
  usdToLocalCurrency = ApexPages.currentPage().getParameters().get('UsdToLocalCurValue');

  // querying on line enquiry
  onlineEnquiry = [SELECT Id, Enquiry_Date__c, Expected_Ship_Date__c, Promised_Delivery_date__c, New_Promised_Delivery_Date__c, Retailer_Code__c, Ship_to_Country__c, Order_Country__c FROM Online_Enquiry__c
   WHERE Id = : onlineEnquiryId
  ];

  // querying price book product for lead Time.
  priceBookProducts = [select Id, Lead_Time__c from Price_Specification_Book_Product__c
   where Price_Specification_Book__r.Book_Status__c = 'Active'
   and
   Price_Specification_Book__r.RecordTypeId = '01290000000RyBQ'
   and
   Product_Status__c = 'Active'
   and
   Retailer_Code__c = : onlineEnquiry.Retailer_Code__c and(Country__c = : onlineEnquiry.Ship_to_Country__c or Order_to_Company__c = : onlineEnquiry.Order_Country__c)
   ORDER BY Lead_Time__c DESC NULLS LAST Limit 1
  ];

  // calculating Promised_Delivery_date__c by lead time.
  LeadTimeByPriceBookProduct = 0;
  if (priceBookProducts != null && priceBookProducts.size() > 0) {
   Integer leadTime = Integer.ValueOf(priceBookProducts.get(0).Lead_Time__c);
   if (leadTime > 0) {
       LeadTimeByPriceBookProduct = leadTime;
    onlineEnquiry.Promised_Delivery_date__c = onlineEnquiry.Enquiry_Date__c.addDays(leadTime);
   } else {
    onlineEnquiry.Promised_Delivery_date__c = onlineEnquiry.Enquiry_Date__c;
   }
  } else {
   onlineEnquiry.Promised_Delivery_date__c = onlineEnquiry.Enquiry_Date__c;
  }
  
  if(onlineEnquiry.New_Promised_Delivery_Date__c==null){
      onlineEnquiry.New_Promised_Delivery_Date__c = onlineEnquiry.Promised_Delivery_date__c;
  }
 }

 // save action
 public PageReference Save() {
  update onlineEnquiry;
  return new PageReference('/apex/D_NewProductSelectionPage_InternalUsers' + '?' + 'OnlineEnquiryId=' + onlineEnquiryId);
 }

 // cancel action
 public PageReference cancel() {
  return new PageReference('/apex/D_NewProductSelectionPage_InternalUsers' + '?' + 'OnlineEnquiryId=' + onlineEnquiryId);
 }
}