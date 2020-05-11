public with sharing class ProductConfiguratorQuotation{
 public String selectedSubSectionName {
  get;
  set;
 }

 public String selectedSubSectionName1 {
  get;
  set;
 }

 public String selectedSubSectionName2 {
  get;
  set;
 }

 public String selectedSubSectionName3 {
  get;
  set;
 }


 public String prodconfigId {
  get;
  set;
 }



 public ProductConfiguratorQuotation(ApexPages.StandardController stdController) {
  prodconfigId = apexpages.currentpage().getparameters().get('id');
 }

 public PageReference upload() {
 
 if(selectedSubSectionName1 !=null)
 {
 Polybag_Costing__c updatecheckbox ;
 updatecheckbox = [Select Id,Quotation_Sent__c,Quotationflag__c,Local_SKU__c from Polybag_Costing__c where Id= :selectedSubSectionName1 ]  ;
  updatecheckbox.Quotation_Sent__c = true;
  updatecheckbox.Quotationflag__c = true;
  update updatecheckbox;
  }
   if(selectedSubSectionName2 !=null)
 {
 Polybag_Costing__c updatecheckbox ;
 updatecheckbox = [Select Id,Quotation_Sent__c,Quotationflag__c,Local_SKU__c from Polybag_Costing__c where Id= :selectedSubSectionName2 ]  ;
  updatecheckbox.Quotation_Sent__c = true;
  updatecheckbox.Quotationflag__c = true;
  update updatecheckbox;
  }
   if(selectedSubSectionName3 !=null)
 {
 Polybag_Costing__c updatecheckbox ;
 updatecheckbox = [Select Id,Quotation_Sent__c,Quotationflag__c,Local_SKU__c from Polybag_Costing__c where Id= :selectedSubSectionName3 ]  ;
  updatecheckbox.Quotation_Sent__c = true;
  updatecheckbox.Quotationflag__c = true;
  update updatecheckbox;
  }
 // return  window.location.href = '/apex/SubmitPageCustomers?id=' + prodconfigId ; 
 //return new PageReference(ApexPages.currentPage().getParameters().get('url'));
 UtilityProductConfig.getFinalPDFContent(prodconfigId );
 Product_Configurator__c prodconfig = [select Id from Product_Configurator__c where Id=:prodconfigId];
        return new ApexPages.StandardController(prodconfig).view();

 }

 public List < SelectOption > getSubsectionList() {
  List < SelectOption > countryOptions = new List < SelectOption > ();
  selectedSubSectionName ='--None--';
  countryOptions.add(new SelectOption('', selectedSubSectionName ));
  
  for (Polybag_Costing__c eachFileUploadRow: [Select Id,Name,Version__c, Suggested_selling_price_1000_bags__c from Polybag_Costing__c where Product_Configurator_ID__c = :prodconfigId order by Version__c DESC]) {   
   //selectedSubSectionName = eachFileUploadRow.Version__c + ' (CNY ' + eachFileUploadRow.Suggested_selling_price_1000_bags__c +')';
   countryOptions.add(new SelectOption(eachFileUploadRow.Id, eachFileUploadRow.Version__c + ' (CNY ' + eachFileUploadRow.Suggested_selling_price_1000_bags__c +')'));
 
   
  }
  return countryOptions;
 }
}