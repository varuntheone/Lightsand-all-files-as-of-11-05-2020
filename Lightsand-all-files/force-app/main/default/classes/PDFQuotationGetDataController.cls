public class PDFQuotationGetDataController {

 public String manufacturerCode {
  get;
  set;
 }
 public List < String > args = new String[] {
  '0',
  'number',
  '###,###,##0.00'
 };
 public Online_Enquiry__c onlineEnqForPDF {
  get;
  set;
 }
 public String totalProdDetails {
  get;
  set;
 }
 public List < DetailDisplay > detailsList {
  get;
  set;
 }

 public String totalTax {
  get;
  set;
 }
 public String totalAdminCharges {
  get;
  set;
 }
 public String totalFreightCharges {
  get;
  set;
 }
 public String taxPercentage {
  get;
  set;
 }
 public String total {
  get;
  set;
 }
 public String finalTotal {
  get;
  set;
 }
 public String lCurrency {
  get;
  set;
 }
 public boolean isTotal {
  get;
  set;
 }
 public String retailerCodeName {
  get;
  set;
 }
 public String exportTerm {
  get;
  set;
 }
 public String paymentTerm {
  get;
  set;
 }
 public String salesPerson {
  get;
  set;
 }
 public String salesPersonEmail {
  get;
  set;
 }
 public String salesPersonContactNumber {
  get;
  set;
 }
 public String division {
  get;
  set;
 }
 public String label {
  get;
  set;
 }
 public String season {
  get;
  set;
 }
 public String seasonYear {
  get;
  set;
 }
 public String manufaturerCode {
  get;
  set;
 }
 public String supplierCode {
  get;
  set;
 }
 Public Date expectedShipDate {
  get;
  set;
 }

 Public Date newPromisedDeliveryDate {
  get;
  set;
 }
 
 Public String newPromisedDeliveryDateRemark {
  get;
  set;
 }
 
 public Partner__c partner {
  get;
  set;
 }

 public String partnerAddress {
  get;
  set;
 }

 public String salesRepRemarks {
  get;
  set;
 }
 public String customerComment {
  get;
  set;
 }
 public String mmgPONumber {
  get;
  set;
 }

 public Boolean showTax {
  get;
  set;
 }
 public Boolean showFreightCharges {
  get;
  set;
 }
 public Boolean showAdminsCharges {
  get;
  set;
 }
 public Boolean showRemarks {
  get;
  set;
 }
 public Boolean showCustomerComment {
  get;
  set;
 }
 public Boolean showMmgPONumber {
  get;
  set;
 }

 public String quoteVersionNumber {
  get;
  set;
 }
 public Date Today {
  get {
   return Date.today();
  }
 }

 public Boolean isProdImageToBeDisplayed {
  get;
  set;
 }
 
 public Boolean showPromisedDate {
  get;
  set;
 }
 
 
 public Integer colspanCount {
  get;
  set;
 }

 public List < Online_Enquiry_Charges__c > onlineEnqChargesList {
  get;
  set;
 }
 public List < EnquiryCharges > enquiryChargesList {
  get;
  set;
 }
    
    public String customerServicePersonName {
        get;
        set;
    }
    public String customerServicePersonEmail {
        get;
        set;
    }
    public String customerServicePersonNumber {
        get;
        set;
    }
    
     public boolean showCustomerServicePersonDetails {
        get;
        set;
    }

 public PDFQuotationGetDataController() {
  System.debug('##Inside Constructor');
  totalProdDetails = '';
  showPromisedDate=false;
  showCustomerServicePersonDetails=false;
  
  String onlineEnquiryId = ApexPages.currentPage().getparameters().get('id');
  quoteVersionNumber = ApexPages.currentPage().getparameters().get('quoteVersion');
  System.debug('##onlineEnquiryId:' + onlineEnquiryId + 'quoteVersionNumber:' + quoteVersionNumber);
  try {
   if (!String.isEmpty(onlineEnquiryId) && onlineEnquiryId.length() > 0) {
    try {
     onlineEnqForPDF = [select Id, Division__c, Label__c, Season__c, Season_Year__c, Manufacturer_Code__c, Supplier_Code__c, MMG_PO_Number1__c, Name, Enquiry_Date__c, Sales_Representative__c, Mainetti_Company__c, Bill_to_Company__c, Bill_to_Address1__c, Bill_to_Address2__c, Bill_to_Contact__c, Bill_to_State__c, Bill_to_Country__c, Bill_to_Email__c, Bill_to_Fax__c, Bill_to_Postcode__c, Bill_to_Tel__c, Ship_to_Address1__c, Ship_to_Address2__c, Ship_to_Company__c, Ship_to_Contact__c, Ship_to_Country__c, Ship_to_Email__c, Ship_to_Fax__c, Ship_to_Postcode__c, Ship_to_State__c, Ship_to_Tel__c, Order_Country__c, Order_Customer_Name__c, OwnerId, Expected_Ship_Date__c, Customer_Comments__c, Retailer_Code__c, Preferred_Currency__c, Tax__c, Freight_Charges__c, Admin_Charges__c, Export_Term__c, Sales_Rep_Remark__c, Partner_Id__c, Payment_Term__c, Account_Manager__c, Account_Manager_Email_Address__c, Account_Manager_Contact_Number__c, Retailer_Image__c, Retailer_Code__r.Display_Image_In_Document__c,Customer_PO_No__c ,New_Promised_Delivery_Date__c,New_Promised_Date_Remark__c,Customer_Service_Name__c,Customer_Service_Email_Address__c,Customer_Service_Contact_Number__c from Online_Enquiry__c where Id = : onlineEnquiryId];
    } catch (System.Exception onlineEnqForPDFQueryEx) {
     System.debug('##onlineEnqForPDFQuery:' + onlineEnqForPDFQueryEx.getStackTraceString());
    }
    System.debug('onlineEnqForPDF' + onlineEnqForPDF);
    //System.debug('onlineEnqForPDF'+onlineEnqForPDF.Bill_to_Company__c);

    // added for conditionally image display
    isProdImageToBeDisplayed = onlineEnqForPDF.Retailer_Code__r.Display_Image_In_Document__c;
    if (isProdImageToBeDisplayed) {
     colspanCount = 9;
    } else {
     colspanCount = 8;
    }

    //List < Online_Detail__c > onlineProdDetailList = [select Model__c, Color__c, Product_Description__c, Product_Type__c, Product_Family__c, Qty__c, Retailer_Code__c, Model_Remark__c, USD_Price_100__c, Sales_Value_In_Local_Currency__c, USD_TO_PREFER_CURRENCY__c, Quoted_Currency_Price_100__c, Sales_Value_In_Quoted_Currency__c, Product_Image_ID__c from Online_Detail__c where TransactionID__c = : onlineEnquiryId];
    List < Online_Detail__c > onlineProdDetailList = [select Model__c, Color__c, Product_Description__c, Product_Type__c, Product_Family__c, Qty__c, Retailer_Code__c, Model_Remark__c, USD_Price_100__c, Sales_Value_In_Local_Currency__c, USD_TO_PREFER_CURRENCY__c, Quoted_Currency_Price_100__c, Sales_Value_In_Quoted_Currency__c, Product_Image_ID__c from Online_Detail__c where TransactionID__c = : onlineEnquiryId and Online_Details_Status__c!='Cancel']; 
    if (onlineProdDetailList != null && onlineProdDetailList.size() > 0) {
     detailsList = new List < DetailDisplay > ();
    }

    //Company Address Query
    try {
     partner = [select Office_Address__c from Partner__c where Id = : onlineEnqForPDF.Partner_Id__c];
     partnerAddress = ', ' + partner.Office_Address__c;
    } catch (Exception partnerQueryEx) {
     System.debug('##partnerQueryEx:' + partnerQueryEx.getStackTraceString());
    }

    //Query Online Enquiry Charges
    try {
     onlineEnqChargesList = [Select Id, Misc_Charges__c, Description__c, Amount__c, Include_Tax__c, Tax__c, Online_Enquiry_ID__c, Requested_Currency__c From Online_Enquiry_Charges__c where Online_Enquiry_ID__c = : onlineEnquiryId];
    } catch (Exception chargesQueryEx) {
     System.debug('##chargesQueryEx:' + chargesQueryEx.getStackTraceString());
    }

    Decimal enquiryChargesSum = 0.0;
    Decimal taxPerValue = 0.0;
    Decimal enquiryChargeTotalTax = 0.0;
    
    
    if(onlineEnqChargesList==null || onlineEnqChargesList.size()==0){
        taxPerValue = onlineEnqForPDF.Tax__c;   
    }
    
    enquiryChargesList = new List < EnquiryCharges > ();
    for (Online_Enquiry_Charges__c eachEnquiryCharges: onlineEnqChargesList) {
     EnquiryCharges enquiryCharges = new EnquiryCharges();
     enquiryCharges.miscCharges = eachEnquiryCharges.Misc_Charges__c;
     enquiryCharges.description = eachEnquiryCharges.Description__c;
     taxPerValue = eachEnquiryCharges.Tax__c;
     if (eachEnquiryCharges.Include_Tax__c && eachEnquiryCharges.Tax__c > 0) {
      //enquiryCharges.afterTax = eachEnquiryCharges.Amount__c + (eachEnquiryCharges.Amount__c * eachEnquiryCharges.Tax__c) / 100;
      enquiryCharges.afterTax = eachEnquiryCharges.Amount__c;
      enquiryChargeTotalTax = enquiryChargeTotalTax + (eachEnquiryCharges.Amount__c * eachEnquiryCharges.Tax__c) / 100;
     } else {
      enquiryCharges.afterTax = eachEnquiryCharges.Amount__c;
     }
     
     enquiryCharges.afterTax = enquiryCharges.afterTax.setScale(2, RoundingMode.CEILING);
     enquiryChargesSum = enquiryChargesSum + enquiryCharges.afterTax;
     enquiryChargesList.add(enquiryCharges);
    }
    enquiryChargesSum = enquiryChargesSum.setScale(2, RoundingMode.CEILING);

        
    
    // to avoid data patching
    if (String.isEmpty(onlineEnqForPDF.Preferred_Currency__c) || String.isBlank(onlineEnqForPDF.Preferred_Currency__c)) {
     lCurrency = 'USD';
    } else {
     lCurrency = onlineEnqForPDF.Preferred_Currency__c.substring(0, 3);
    }

    Decimal totalSum = 0.0;
    for (Online_Detail__c eachProdDetail: onlineProdDetailList) {
     isTotal = true;
     try {
      DetailDisplay detailDisp = new DetailDisplay();
      detailDisp.model = [select Name from Price_Specification_Book_Product__c where Id = : eachProdDetail.Model__c].Name;
      detailDisp.color = eachProdDetail.Color__c;
      detailDisp.descreption = eachProdDetail.Product_Description__c;
      detailDisp.productType = eachProdDetail.Product_Type__c;
      detailDisp.productFamily = eachProdDetail.Product_Family__c;
      detailDisp.qty = String.valueOf(eachProdDetail.Qty__c);
      detailDisp.retailerCodeName = [select Name from Retailer_Code__c where Id = : eachProdDetail.Retailer_Code__c].Name;
      retailerCodeName = detailDisp.retailerCodeName;
      detailDisp.modelRemark = eachProdDetail.Model_Remark__c;
      detailDisp.productImage = eachProdDetail.Product_Image_ID__c;
      detailDisp.price100pcs = string.valueOf(eachProdDetail.Quoted_Currency_Price_100__c.setScale(2, RoundingMode.CEILING));
      detailDisp.price100pcs = thousandSeparator(Decimal.valueof(detailDisp.price100pcs));
      detailDisp.localCurrency = lCurrency;
      totalSum = totalSum + eachProdDetail.Sales_Value_In_Quoted_Currency__c;
      detailDisp.salesValueInLocalCurrency = String.valueOf(eachProdDetail.Sales_Value_In_Quoted_Currency__c.setScale(2, RoundingMode.CEILING));
      detailDisp.salesValueInLocalCurrency = thousandSeparator(Decimal.valueof(detailDisp.salesValueInLocalCurrency));
      detailsList.add(detailDisp);
     } catch (System.Exception e) {
      System.debug('##List:' + e.getStackTraceString());
     }
    }

    //lCurrency = onlineEnqForPDF.Preferred_Currency__c.substring(0,3);
    exportTerm = onlineEnqForPDF.Export_Term__c;
    salesRepRemarks = onlineEnqForPDF.Sales_Rep_Remark__c;
    salesRepRemarks = lineBreaks(salesRepRemarks);
    paymentTerm = onlineEnqForPDF.Payment_Term__c;
    salesPerson = onlineEnqForPDF.Account_Manager__c;
    salesPersonEmail = onlineEnqForPDF.Account_Manager_Email_Address__c;
    salesPersonContactNumber = onlineEnqForPDF.Account_Manager_Contact_Number__c;
    division = onlineEnqForPDF.Division__c;
    label = onlineEnqForPDF.Label__c;
    season = onlineEnqForPDF.Season__c;
    seasonYear = onlineEnqForPDF.Season_Year__c;
    manufaturerCode = onlineEnqForPDF.Manufacturer_Code__c;
    supplierCode = onlineEnqForPDF.Supplier_Code__c;
    expectedShipDate = onlineEnqForPDF.Expected_Ship_Date__c;
    customerComment = onlineEnqForPDF.Customer_Comments__c;
    customerComment = lineBreaks(customerComment);
    mmgPONumber = onlineEnqForPDF.MMG_PO_Number1__c;
       
       customerServicePersonName=onlineEnqForPDF.Customer_Service_Name__c;
       if(customerServicePersonName!=null && String.isNotBlank(customerServicePersonName.trim()) && String.isNotEmpty(customerServicePersonName.trim())){
           showCustomerServicePersonDetails =true;
       }
       
       customerServicePersonEmail=onlineEnqForPDF.Customer_Service_Email_Address__c;
       customerServicePersonNumber=onlineEnqForPDF.Customer_Service_Contact_Number__c;
    
    // added by pawan 17/NOV/2016 - START
    newPromisedDeliveryDate = onlineEnqForPDF.New_Promised_Delivery_Date__c;
    newPromisedDeliveryDateRemark = lineBreaks(onlineEnqForPDF.New_Promised_Date_Remark__c);
    if(newPromisedDeliveryDate!=expectedShipDate){
        showPromisedDate=true;
    }
    // added by pawan 17/NOV/2016 - END

    Decimal totalTaxDecimal = 0.0;
    if (enquiryChargeTotalTax>0 || totalSum > 0) {
     //totalTax = string.valueOf(((totalSum*onlineEnqForPDF.Tax__c)/100).setScale(6,RoundingMode.CEILING));
     try {
      system.debug('enquiryChargeTotalTax:'+enquiryChargeTotalTax);  
      totalTax = string.valueOf(((enquiryChargeTotalTax + ((totalSum * taxPerValue) / 100)).setScale(2, RoundingMode.CEILING)));
      totalTax = thousandSeparator(Decimal.valueof(totalTax));
      totalTaxDecimal = ((enquiryChargeTotalTax + ((totalSum * taxPerValue) / 100)).setScale(2, RoundingMode.CEILING));
     } catch (System.Exception e) {
      System.debug('##totalTax:' + e.getStackTraceString());
      totalTax = string.valueOf(0);
     }
    } else {
     totalTax = string.valueOf(((((totalSum * taxPerValue) / 100)).setScale(2, RoundingMode.CEILING)));
     totalTax = thousandSeparator(Decimal.valueof(totalTax));
     totalTaxDecimal = ((((totalSum * taxPerValue) / 100)).setScale(2, RoundingMode.CEILING));
     //totalTax = string.valueOf(0);
    }

    try {
     //total = string.valueOf(totalSum);
     //total = string.valueOf((enquiryChargesSum + totalSum).setScale(2, RoundingMode.CEILING));
     total = string.valueOf((enquiryChargesSum + totalSum).setScale(2, RoundingMode.CEILING));
     total = thousandSeparator(Decimal.valueof(total));
    } catch (System.Exception e) {
     System.debug('##total:' + e.getStackTraceString());
     total = string.valueOf(0);
    }

    try {
     //taxPercentage = string.valueOf(onlineEnqForPDF.Tax__c);
     taxPercentage = string.valueOf(taxPerValue.setScale(2, RoundingMode.CEILING));
    } catch (System.Exception e) {
     System.debug('##taxPercentage:' + e.getStackTraceString());
     taxPercentage = string.valueOf(0);
    }

    try {
     //finalTotal = string.valueOf((enquiryChargesSum + totalSum + ((totalSum * taxPerValue) / 100)));
     finalTotal = string.valueOf((totalTaxDecimal+ enquiryChargesSum + totalSum));
     finalTotal = thousandSeparator(Decimal.valueof(finalTotal));
    } catch (System.Exception e) {
     System.debug('##finalTotal:' + e.getStackTraceString());
     finalTotal = string.valueOf(0);
    }

    try {
     if (taxPerValue > 0) {
      showTax = true;
     } else {
      showTax = false;
     }
    } catch (System.Exception e) {
     System.debug('##showTax:' + e.getStackTraceString());
     showTax = false;
    }

    try {
     if (String.isEmpty(onlineEnqForPDF.Sales_Rep_Remark__c) || String.isBlank(onlineEnqForPDF.Sales_Rep_Remark__c)) {
      showRemarks = false;
     } else {
      showRemarks = true;
     }
    } catch (System.Exception e) {
     System.debug('##showRemarks:' + e.getStackTraceString());
     showRemarks = false;
    }
    // yy-20160721
    try {
     if (String.isEmpty(onlineEnqForPDF.MMG_PO_Number1__c) || String.isBlank(onlineEnqForPDF.MMG_PO_Number1__c)) {
      showMmgPONumber = false;
     } else {
      showMmgPONumber = true;
     }
    } catch (System.Exception e) {
     System.debug('##showMmgPONumber:' + e.getStackTraceString());
     showMmgPONumber = false;
    }

    // yy-20160721
    try {
     if (String.isEmpty(onlineEnqForPDF.Customer_Comments__c) || String.isBlank(onlineEnqForPDF.Customer_Comments__c)) {
      showCustomerComment = false;
     } else {
      showCustomerComment = true;
     }
    } catch (System.Exception e) {
     System.debug('##showCustomerComment:' + e.getStackTraceString());
     showCustomerComment = false;
    }


   }
  } catch (System.Exception e) {
   System.debug('##GlobalEx:' + e.getStackTraceString());
  }
 }

 public string lineBreaks(string inText) {
  if (inText == null)
   return '';
  else
   return inText.replaceAll('<', '(').replaceAll('>', ')').replaceAll('\n', '<br/>');
 }

 public String thousandSeparator(Decimal numbers) {
  return String.format(numbers.format(), args);
 }
}