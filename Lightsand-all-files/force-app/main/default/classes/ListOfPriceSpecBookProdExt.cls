public class ListOfPriceSpecBookProdExt{
   public Price_Specification_Book_Product__c product {get; set;}
    public List<Price_Specification_Book_Product__c> searchResList {get; set;}
    public String retailerCode {get; set;}
    public String country {get; set;}
    public ListOfPriceSpecBookProdExt(ApexPages.StandardController controller){
        product = (Price_Specification_Book_Product__c)controller.getRecord();
        retailerCode = ApexPages.currentPage().getparameters().get('retailercode');
        country = ApexPages.currentPage().getparameters().get('country');
        System.debug('###retailerCode--->'+retailerCode);
        System.debug('###country--->'+country);
        searchResList = [select Id, Name, Product_Unique_ID__c, 
                         Customer_Ref_Model__c,
                         Product_Unique_ID__r.Product_Description__c,
                         Product_Unique_ID__r.Product_Family__c,
						 Product_Unique_ID__r.Product_Type__c,
                         Color__c, Account__c, Price_100pcs__c, 
                         Freight_Terms__c, Retailer_Code__c,Retailer_Code__r.Name, Product_Status__c, 
                         Price_Specification_Book__r.Book_Status__c, 
                         Price_Specification_Book__r.RecordTypeId, Country__c 
                         from Price_Specification_Book_Product__c
                         where Price_Specification_Book__r.Book_Status__c='Active' and 
                         Price_Specification_Book__r.RecordTypeId='01290000000RyBQ' and
                         Retailer_Code__c = :retailerCode and
                         Product_Status__c='Active' and
                         Country__c= :country
                         ORDER BY Customer_Ref_Model__c ASC, Color__c DESC, Product_Unique_ID__r.Product_Description__c ASC  NULLS LAST
                        ];
        System.debug('##searchResList--->'+searchResList);
    }
}