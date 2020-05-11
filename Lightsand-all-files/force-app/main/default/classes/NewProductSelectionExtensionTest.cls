@IsTest public class NewProductSelectionExtensionTest {
 @IsTest(SeeAllData = true) public static void testNewProductSelectionExtensionTest() {
  //String enquiryId = 'a0fN0000003q3Jj';
  Online_Enquiry__c onlineEnquiry = [select id, Retailer_Code__c from Online_Enquiry__c order by LastModifiedDate desc limit 1];
  String enquiryId = onlineEnquiry.id;
  System.debug('enquiryId :'+enquiryId);
  //String retailerCode = 'a00N000000CZszO';
  String retailerCode = onlineEnquiry.Retailer_Code__c;
  //String productId = 'a03N0000006TaNW';
  String productId = [select id from Product__c limit 1].id;
  String modelName = '2214';

  String productType = 'HANGERS';
  Online_Detail__c detail = new Online_Detail__c();
  List < Online_Detail__c > detList = new List < Online_Detail__c > ();
  //detList.add(detail);

  PageReference pageRef = Page.NewProductSelectionPage;
  pageRef.getParameters().put('OnlineEnquiryId', enquiryId);
  Test.setCurrentPageReference(pageRef);

  ApexPages.StandardSetController stdController = new ApexPages.StandardSetController(detList);
  system.currentPageReference().getParameters().put('OnlineEnquiryId', enquiryId);
  NewProductSelectionExtension prodSelExt = new NewProductSelectionExtension(stdController);
  prodSelExt.selectedId = productId;
  prodSelExt.Submit();
  prodSelExt.selectedItem();
  prodSelExt.Submit();
  System.debug('##**selected Map:' + prodSelExt.onlineDetailsToInsertOrUpdateMap);
  prodSelExt.removeId = productId;
  prodSelExt.removeItem();
  prodSelExt.Cancel();
  prodSelExt.Next();
  prodSelExt.Previous();
  prodSelExt.removeItem();
  prodSelExt.Save();
  prodSelExt.selectedItem();
  prodSelExt.Submit();
  prodSelExt.totalRecords = 2;
  prodSelExt.Next();
  Price_Specification_Book_Product__c prod = [select Id, Name, Product_Unique_ID__c,
   Customer_Ref_Model__c,
   Product_Unique_ID__r.Product_Description__c,
   Product_Unique_ID__r.Product_Family__c,
   Product_Unique_ID__r.Product_Type__c,
   Color__c, Account__c, Price_100pcs__c,
   Freight_Terms__c, Retailer_Code__c, Retailer_Code__r.Name, Product_Status__c,
   Price_Specification_Book__r.Book_Status__c,
   Price_Specification_Book__r.RecordTypeId, Country__c
   from Price_Specification_Book_Product__c
   where Price_Specification_Book__r.Book_Status__c = 'Active'
   and
   //Price_Specification_Book__r.RecordTypeId = '01290000000RyBQ' //sandbox
   Price_Specification_Book__r.RecordTypeId = '01290000000RyBQ' //Production
   and
   Product_Status__c = 'Active'
   ORDER BY Customer_Ref_Model__c ASC, Color__c DESC, Product_Unique_ID__r.Product_Description__c ASC NULLS LAST LIMIT 1
  ];
  //prodSelExt.getDetail(prod);

  System.debug(prodSelExt.priceBookProductsMap);
  prodSelExt.Search();
  prodSelExt.Clear();
  prodSelExt.modelName = modelName;
  prodSelExt.productType = productType;
  prodSelExt.Search();
  prodSelExt.modelName = modelName + 'dfsd';
  prodSelExt.productType = productType + 'dsfsd';
  prodSelExt.Search();
  prodSelExt.onlineDetailsToInsertOrUpdateMap = null;
  prodSelExt.Submit();
  //prodSelExt.onlineEnq.Partner_Id__c = 'a05N0000005we0K';//sandbox
  prodSelExt.onlineEnq.Partner_Id__c = 'a05900000020YC6';//production
  prodSelExt.populatePartnerTermsNConditions();
  prodSelExt.onlineEnq.Partner_Id__c = null;
  prodSelExt.populatePartnerTermsNConditions();
  //prodSelExt.onlineEnq.Main_Contact_Id__c = 'a0zN0000001PCI7';//sandbox
  prodSelExt.onlineEnq.Main_Contact_Id__c = 'a0p900000092YJo';//production
  prodSelExt.populateMainContactDetails();
  prodSelExt.onlineEnq.Main_Contact_Id__c = null;
  prodSelExt.populateMainContactDetails();
  prodSelExt.Add();
  prodSelExt.AddRemarks();
  prodSelExt.AddProduct();
  prodSelExt.PreviewQuotePdf();
  prodSelExt.AddOtherCharges();
  prodSelExt.AddSalesPersonInfo();
  prodSelExt.getCountries();
  prodSelExt.getProductCategories();
  prodSelExt.getProductFamilies();
  prodSelExt.getProductColors();
  prodSelExt.getProductSizePrint();
  
  prodSelExt.addRow();
  prodSelExt.enquiryChargesRowId = prodSelExt.onlineEnqChargesList.get(0).Id;
  prodSelExt.deleteEnquiryChargesById();
 }
}