trigger UpdateOnlineDetailWithProductDetails on Online_Detail__c (before insert) {
    for(Online_Detail__c onlineDetail : Trigger.new){
        String priceBookSpecificationProductId = onlineDetail.Model__c;
        system.debug('priceBookSpecificationProductId:'+priceBookSpecificationProductId);
        if(priceBookSpecificationProductId!=null && priceBookSpecificationProductId.length()>0){
            Price_Specification_Book_Product__c product = [Select Name, Retailer_Code__c, Price_100pcs__c, Color__c, Freight_Terms__c, Country__c from Price_Specification_Book_Product__c where Id=:priceBookSpecificationProductId];
            system.debug('product:'+product);
            onlineDetail.Retailer_Code__c = product.Retailer_Code__c;
            onlineDetail.USD_Price_100__c = product.Price_100pcs__c;
            onlineDetail.Color__c = product.Color__c;
            onlineDetail.Freight_Term__c = product.Freight_Terms__c;
            onlineDetail.Country__c = product.Country__c;
            onlineDetail.TempModel__c = product.Name;
            
        }
    }
}