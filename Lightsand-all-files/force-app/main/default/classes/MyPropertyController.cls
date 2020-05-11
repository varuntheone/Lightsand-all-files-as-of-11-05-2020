public with sharing class MyPropertyController {
@AuraEnabled		
     public static List<Price_Specification_Book_Product__c> findProperties (Id recordId, Decimal priceRange) {
         List<Price_Specification_Book_Product__c> property = [SELECT Price_100pcs__c FROM Price_Specification_Book_Product__c WHERE Id=:recordId];
         Decimal propertyPrice = property[0].Price_100pcs__c;
         List<Price_Specification_Book_Product__c> similarProperties = getSimilarProperties(recordId, priceRange, propertyPrice);
         return similarProperties;
     }
	    
     private static List<Price_Specification_Book_Product__c> getSimilarProperties (Id recordId, Decimal priceRange, Decimal price ) {
         Decimal range;
         if (priceRange == null) {
             range = 10;
         } else {
             range = priceRange;
         }
         return [
             SELECT Id, Name, Material__c, Order_to_Company__c, Description__c, Country__c, Price_Book_Status__c,Price_100pcs__c,Product_Image__c
             FROM Price_Specification_Book_Product__c WHERE Id != :recordId AND Price_100pcs__c > :price - range AND Price_100pcs__c < :price + range
         ];
     }
 }