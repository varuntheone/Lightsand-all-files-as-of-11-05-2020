public class OnlineEnquiryOrderFormExEdit {
 public Online_Enquiry__c onlineEnquiryOrderDetails {
  get;
  set;
 }
 Ship_Bill_Address__c billToAddress {
  get;
  set;
 }
 Ship_Bill_Address__c shipToAddress {
  get;
  set;
 }
 public User loggedInUser = null;
 public Boolean enableJCPDivision {
  get;
  set;
 }
 public Boolean enablePRLDivision {
  get;
  set;
 }
 public Boolean enableMacyDivision {
  get;
  set;
 }
 public Boolean enableMMGPO {
  get;
  set;
 }
 public Boolean enableGUDivision {
  get;
  set;
 }

 public String mmgPoValue {
  get {
  system.debug('MMGValue:'+ onlineEnquiryOrderDetails.MMG_PO_Number1__c);
    if(onlineEnquiryOrderDetails.MMG_PO_Number1__c!=null && onlineEnquiryOrderDetails.MMG_PO_Number1__c.length()>0){
        /*
        List<String> mmgPoNumbersArr = (removeLineBreaks(onlineEnquiryOrderDetails.MMG_PO_Number__c)).split(',');
        String finalMMgValue = '';
            if(mmgPoNumbersArr!=null && mmgPoNumbersArr.size()>1){
                for(Integer i=0;i<mmgPoNumbersArr.size();i++){
                    if(i==0){
                        finalMMgValue = mmgPoNumbersArr.get(i);
                    }else{
                        finalMMgValue = finalMMgValue + ',\n'+ mmgPoNumbersArr.get(i);
                    }
                }
                // before retruning remove spaces
                //return finalMMgValue.replaceAll('(\\s+)', '');
                */
                return removeLineBreaks(onlineEnquiryOrderDetails.MMG_PO_Number1__c);
            }
            
            /*else{
                return onlineEnquiryOrderDetails.MMG_PO_Number__c;
            }*/
    return onlineEnquiryOrderDetails.MMG_PO_Number1__c;
  }
 }
 
 public string userLocale {get;set;}
 
 public OnlineEnquiryOrderFormExEdit(ApexPages.StandardController controller) {
        System.debug('##User Name---->'+UserInfo.getLocale());
        userLocale = UserInfo.getLocale();  
        
  String onlineEnquiryId = ApexPages.currentPage().getparameters().get('id');

  onlineEnquiryOrderDetails = [select Id, Label__c ,JCP_Sub_division5__c 
,JCP_Sub_division2__c ,RecordTypeId,JCP_Sub_division4__c ,JCP_Sub_division1__c ,JCP_Sub_division3__c 
,Customer_PO_No__c ,Season__c,Division__c, Season_Year__c ,MMG_PO_Number1__c, Bill_To__c, Ship_To__c, Retailer_Image_ID__c, Retailer_Code_Hidden__c, Enquiry_Status__c, Name, Enquiry_Date__c, Sales_Representative__c, Mainetti_Company__c, Bill_to_Company__c, Bill_to_Address1__c, Bill_to_Address2__c, Bill_to_Contact__c, Bill_to_State__c, Bill_to_Country__c, Bill_to_Email__c, Bill_to_Fax__c, Bill_to_Postcode__c, Bill_to_Tel__c, Ship_to_Address1__c, Ship_to_Address2__c, Ship_to_Company__c, Ship_to_Contact__c, Ship_to_Country__c, Ship_to_Email__c, Ship_to_Fax__c, Ship_to_Postcode__c, Ship_to_State__c, Ship_to_Tel__c, Order_Country__c, Order_Customer_Name__c, OwnerId, Expected_Ship_Date__c, Customer_Comments__c, Retailer_Code__c, Preferred_Currency__c, Tax__c, Freight_Charges__c, Admin_Charges__c, Export_Term__c, Sales_Rep_Remark__c, Partner_Id__c, Payment_Term__c, Account_Manager__c, Account_Manager_Email_Address__c, Account_Manager_Contact_Number__c, Supplier_Code__c, Manufacturer_Code__c, TempRetailerCodeId__c, Retailer_Image__c,Retailer_Code__r.Name from Online_Enquiry__c where Id = : onlineEnquiryId];

/*
  if (onlineEnquiryOrderDetails.Retailer_Code_Hidden__c != null && onlineEnquiryOrderDetails.Retailer_Code_Hidden__c.startswith('JC')) {
   enableJCPDivision = true;
  }*/

  /*
  if (onlineEnquiryOrderDetails!=null && onlineEnquiryOrderDetails.RecordTypeId != null && onlineEnquiryOrderDetails.RecordTypeId=='01290000000TNpVAAW') {
   enableJCPDivision = true;
  }*/
  
  if(onlineEnquiryOrderDetails.Retailer_Code__r.Name != null && onlineEnquiryOrderDetails.Retailer_Code__r.Name.startswith('JC')) {
   enableJCPDivision = true;
  }
    /*
  if (onlineEnquiryOrderDetails.Retailer_Code_Hidden__c != null && onlineEnquiryOrderDetails.Retailer_Code_Hidden__c.startswith('PRL')) {
   enablePRLDivision = true;
  }*/

  /*
  if (onlineEnquiryOrderDetails!=null && onlineEnquiryOrderDetails.RecordTypeId != null && onlineEnquiryOrderDetails.RecordTypeId=='012N0000000DHzqIAG') {
   enablePRLDivision = true;
  }*/
  
  if (onlineEnquiryOrderDetails.Retailer_Code__r.Name != null && onlineEnquiryOrderDetails.Retailer_Code__r.Name.startswith('PRL')) {
   enablePRLDivision = true;
  }
  if (onlineEnquiryOrderDetails.Retailer_Code__r.Name != null && onlineEnquiryOrderDetails.Retailer_Code__r.Name.startswith('GU')) {
   enableGUDivision = true;
  }
  /*
  if (onlineEnquiryOrderDetails.Retailer_Code_Hidden__c != null && onlineEnquiryOrderDetails.Retailer_Code_Hidden__c.startswith('Macy')) {
   enableMacyDivision = true;
  }*/
  
  /*
  if (onlineEnquiryOrderDetails!=null && onlineEnquiryOrderDetails.RecordTypeId != null && onlineEnquiryOrderDetails.RecordTypeId=='012N00000000jt2IAA') {
   enableMacyDivision = true;
  }*/
  
  if (onlineEnquiryOrderDetails.Retailer_Code__r.Name != null && onlineEnquiryOrderDetails.Retailer_Code__r.Name.startswith('MACY')) {
   enableMacyDivision = true;
  }else {
      if (onlineEnquiryOrderDetails!=null && onlineEnquiryOrderDetails.Retailer_Code__r.Name != null && !onlineEnquiryOrderDetails.Retailer_Code__r.Name.startswith('JC') && !onlineEnquiryOrderDetails.Retailer_Code__r.Name.startswith('PRL') && !onlineEnquiryOrderDetails.Retailer_Code__r.Name.startswith('MACY')) {
       enablePRLDivision = true;
      }
  }
  
  // enable MMG PO
  // Disable by Pawan as per YY CR - Dated 22_JUNE_2016
  /*
  if(onlineEnquiryOrderDetails.Division__c!=null && !onlineEnquiryOrderDetails.Division__c.equalsIgnoreCase('LDP')) { 
    enableMMGPO = true;
  }*/
  enableMMGPO = true;
  
  /*
  if (onlineEnquiryOrderDetails!=null && onlineEnquiryOrderDetails.RecordTypeId != null && onlineEnquiryOrderDetails.RecordTypeId!='01290000000TNpVAAW' && onlineEnquiryOrderDetails.RecordTypeId!='012N0000000DHzqIAG' && onlineEnquiryOrderDetails.RecordTypeId!='012N00000000jt2IAA') {
   enablePRLDivision = true;
  }*/
  
  /*
  if (onlineEnquiryOrderDetails!=null && onlineEnquiryOrderDetails.Retailer_Code__r.Name != null && !onlineEnquiryOrderDetails.Retailer_Code__r.Name.startswith('JC') && !onlineEnquiryOrderDetails.Retailer_Code__r.Name.startswith('PRL') && !onlineEnquiryOrderDetails.Retailer_Code__r.Name.startswith('Macy')) {
   enablePRLDivision = true;
  }*/
  
  //onlineEnquiryOrderDetails.Retailer_Image__c ='&nbsp;';
 }

 public PageReference Save() {
  if (onlineEnquiryOrderDetails != null) {

    // just remove the placeholder
    //String mmgPoNumber = onlineEnquiryOrderDetails.MMG_PO_Number__c;
    if(onlineEnquiryOrderDetails.MMG_PO_Number1__c!=null && onlineEnquiryOrderDetails.MMG_PO_Number1__c.length()>0){
        List<String> mmgPoNumbersArr = string.valueof(onlineEnquiryOrderDetails.MMG_PO_Number1__c).split(',\\s*');
        if(mmgPoNumbersArr!=null && mmgPoNumbersArr.size()==3 && mmgPoNumbersArr.get(0).equalsIgnoreCase('PO9873423') && mmgPoNumbersArr.get(1).equalsIgnoreCase('PO9834923') && mmgPoNumbersArr.get(2).equalsIgnoreCase('PO9879238')){
                onlineEnquiryOrderDetails.MMG_PO_Number1__c = null;
        }
    }
    
    // enable MMG PO
    // disabled by pawan - 27_JUNE_2016
    /*
  if(onlineEnquiryOrderDetails.Division__c!=null && onlineEnquiryOrderDetails.Division__c.equalsIgnoreCase('LDP')) { 
    onlineEnquiryOrderDetails.MMG_PO_Number1__c = null;
  }*/
  
   update(onlineEnquiryOrderDetails);

   // Added by Pawan
   //loggedInUser.Preferred_Currency__c = onlineEnquiryOrderDetails.Preferred_Currency__c;
   //update(loggedInUser);
  }

  return new PageReference('/apex/NewProductSelectionPage' + '?' + 'OnlineEnquiryId=' + onlineEnquiryOrderDetails.Id);
 }

 public void PopulateBillTo() {
  System.debug('##PopulateBillToClicked--->' + onlineEnquiryOrderDetails.Bill_To__c);
  if (onlineEnquiryOrderDetails.Bill_To__c != null) {
   Ship_Bill_Address__c billToAddress = [select Factory_Name__c, Address_1__c, Address_2__c, City__c, State__c, Postcode__c, Country__c, Bill_Ship_Status__c, Contact__c, Tel_No__c, Fax_No__c, Email_Address__c from Ship_Bill_Address__c where Id = : onlineEnquiryOrderDetails.Bill_To__c];
   System.debug('##FactoryName---->' + billToAddress.Factory_Name__c);
   onlineEnquiryOrderDetails.Bill_to_Company__c = billToAddress.Factory_Name__c;
   onlineEnquiryOrderDetails.Bill_to_Address1__c = billToAddress.Address_1__c;
   onlineEnquiryOrderDetails.Bill_to_Address2__c = billToAddress.Address_2__c;
   onlineEnquiryOrderDetails.Bill_to_State__c = billToAddress.State__c;
   onlineEnquiryOrderDetails.Bill_to_Postcode__c = billToAddress.Postcode__c;
   onlineEnquiryOrderDetails.Bill_to_Country__c = billToAddress.Country__c;
   onlineEnquiryOrderDetails.Bill_to_Contact__c = billToAddress.Contact__c;
   onlineEnquiryOrderDetails.Bill_to_Tel__c = billToAddress.Tel_No__c;
   onlineEnquiryOrderDetails.Bill_to_Fax__c = billToAddress.Fax_No__c;
   onlineEnquiryOrderDetails.Bill_to_Email__c = billToAddress.Email_Address__c;
  } else {
   onlineEnquiryOrderDetails.Bill_to_Company__c = '';
   onlineEnquiryOrderDetails.Bill_to_Address1__c = '';
   onlineEnquiryOrderDetails.Bill_to_Address2__c = '';
   onlineEnquiryOrderDetails.Bill_to_State__c = '';
   onlineEnquiryOrderDetails.Bill_to_Postcode__c = '';
   onlineEnquiryOrderDetails.Bill_to_Country__c = '';
   onlineEnquiryOrderDetails.Bill_to_Contact__c = '';
   onlineEnquiryOrderDetails.Bill_to_Tel__c = '';
   onlineEnquiryOrderDetails.Bill_to_Fax__c = '';
   onlineEnquiryOrderDetails.Bill_to_Email__c = '';
  }
 }

 public void PopulateShipTo() {
  System.debug('##PopulateShipToClicked--->' + onlineEnquiryOrderDetails.Ship_To__c);
  if (onlineEnquiryOrderDetails.Ship_To__c != null) {
   Ship_Bill_Address__c shipToAddress = [select Factory_Name__c, Address_1__c, Address_2__c, City__c, State__c, Postcode__c, Country__c, Bill_Ship_Status__c, Contact__c, Tel_No__c, Fax_No__c, Email_Address__c from Ship_Bill_Address__c where Id = : onlineEnquiryOrderDetails.Ship_To__c];
   System.debug('##FactoryName---->' + shipToAddress.Factory_Name__c);
   onlineEnquiryOrderDetails.Ship_to_Company__c = shipToAddress.Factory_Name__c;
   onlineEnquiryOrderDetails.Ship_to_Address1__c = shipToAddress.Address_1__c;
   onlineEnquiryOrderDetails.Ship_to_Address2__c = shipToAddress.Address_2__c;
   onlineEnquiryOrderDetails.Ship_to_State__c = shipToAddress.State__c;
   onlineEnquiryOrderDetails.Ship_to_Postcode__c = shipToAddress.Postcode__c;
   onlineEnquiryOrderDetails.Ship_to_Country__c = shipToAddress.Country__c;
   onlineEnquiryOrderDetails.Ship_to_Contact__c = shipToAddress.Contact__c;
   onlineEnquiryOrderDetails.Ship_to_Tel__c = shipToAddress.Tel_No__c;
   onlineEnquiryOrderDetails.Ship_to_Fax__c = shipToAddress.Fax_No__c;
   onlineEnquiryOrderDetails.Ship_to_Email__c = shipToAddress.Email_Address__c;
  } else {
   onlineEnquiryOrderDetails.Ship_to_Company__c = '';
   onlineEnquiryOrderDetails.Ship_to_Address1__c = '';
   onlineEnquiryOrderDetails.Ship_to_Address2__c = '';
   onlineEnquiryOrderDetails.Ship_to_State__c = '';
   onlineEnquiryOrderDetails.Ship_to_Postcode__c = '';
   onlineEnquiryOrderDetails.Ship_to_Country__c = '';
   onlineEnquiryOrderDetails.Ship_to_Contact__c = '';
   onlineEnquiryOrderDetails.Ship_to_Tel__c = '';
   onlineEnquiryOrderDetails.Ship_to_Fax__c = '';
   onlineEnquiryOrderDetails.Ship_to_Email__c = '';
  }
 }

 public String getmyimageurl() {
  return '/servlet/servlet.FileDownload?file=' + onlineEnquiryOrderDetails.Retailer_Image_ID__c;
 }

 public void enableMMGPOField() {
  if (onlineEnquiryOrderDetails.Division__c.equals('LDP')) {
   enableMMGPO = true;
  } else {
   enableMMGPO = true;
  }
 }
 
private string removeLineBreaks(string inText)
{
   if (inText == null)
       return '';
   else
       return inText.replaceAll('\r\n','');
}
}