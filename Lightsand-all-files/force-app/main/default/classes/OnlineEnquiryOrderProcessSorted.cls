public class OnlineEnquiryOrderProcessSorted {
    
    @InvocableMethod(label='Fill test data' description='Fill test data')
    public static void fillData (List<string> names) {
        /*Id accId = OnlineEnquiryOrderProcessSorted.createAccount();
            //System.assert(accId != null);
            System.debug('accId: '+accId);
            Id retailerId=OnlineEnquiryOrderProcessSorted.createRetailerCode(accId);
            System.debug('retailerId: '+retailerId);
            //List<Product__c> pList=DecathlonOrderProcessorTest.createProducts();
            Id productId=OnlineEnquiryOrderProcessSorted.createProduct();
            System.debug('productId: '+productId);
            Id priceSpecBookId =OnlineEnquiryOrderProcessSorted.createPriceBook(accId);
            System.debug('priceSpecBookId: '+priceSpecBookId);
            Id priceBookProductId=OnlineEnquiryOrderProcessSorted.createPriceBookProduct(accId, productId, priceSpecBookId, retailerId);
            System.debug('priceBookProductId: '+priceBookProductId);
            Id currencyId=OnlineEnquiryOrderProcessSorted.createPriceBookProductCurrency(priceBookProductId);
            System.debug('currencyId: '+currencyId);
            
            Id partnerId=OnlineEnquiryOrderProcessSorted.createPartner();
            System.debug('partnerId: '+partnerId);*/
            //System.assertEquals(true, result,'Creates account and retailer');
            System.debug('Created test data');
        List<String> orderToCompany = new List<String>();
        //orderToCompany.add(partner.Default_Order_to_Company__c);  
        orderToCompany.add('Hong Kong - Mainetti (HK) Ltd');  
        list <String> productList = new List<String>();
        //productList.add(bod.Model_Id__c);
        productList.add('2442595');
        
        Id PriceBookRecordTypeId = Schema.SObjectType.Price_Specification_Book__c.getRecordTypeInfosByName().get('Price Book').getRecordTypeId();
        List<Price_Specification_Book_Product__c> modelIdList = OnlineEnquiryOrderProcessSorted.getModelsList(productList, orderToCompany, PriceBookRecordTypeId);
        System.debug('PriceBookRecordTypeId: '+PriceBookRecordTypeId); 
        System.debug('modelIdList: '+modelIdList);            
        
    }
    
    public static List<Price_Specification_Book_Product__c> getModelsList(list <String> prodList, List<String> orderToCompany, Id PriceBookRecordTypeId){
        List<Price_Specification_Book_Product__c> modelIdList=[SELECT Id, name, Order_to_Company__c, CurrencyIsoCode, Customer_Ref_Model__c, Price_Specification_Book__r.name, 
                                                               (select id, CurrencyIsoCode, Price_100_pcs__c from Price_Product_by_Currency__r ) FROM Price_Specification_Book_Product__c 
                                                               where Price_Specification_Book__r.Book_Status__c='Active' and Price_Specification_Book__r.RecordTypeId= :PriceBookRecordTypeId
                                                               and Product_Status__c='Active' and Price_Specification_Book__r.Account__r.name='DECATHLON' and 
                                                               Customer_Ref_Model__c = :prodList and Order_to_Company__c = :orderToCompany];
        
        return modelIdList;
    }
    
    public static Id createPriceBookProduct(Id accId, Id productId, Id priceSpecBookId, Id retailerId) {
        Id PBookProductId=null;
        try{
            Id PriceBookProductRecordTypeId = Schema.SObjectType.Price_Specification_Book_Product__c.getRecordTypeInfosByName().get('Price Book Product').getRecordTypeId();
            
            Price_Specification_Book_Product__c priceSpecBookProduct1=new Price_Specification_Book_Product__c();
            priceSpecBookProduct1.Name='2442595';
            priceSpecBookProduct1.Product_Unique_ID__c=productId;
            //priceSpecBookProduct1.Price_Book_Product__c=productId;
            priceSpecBookProduct1.Account__c=accId;
            priceSpecBookProduct1.Price_Specification_Book__c=priceSpecBookId;
            //priceSpecBookProduct1.Product_Status__c='Active';
            //priceSpecBookProduct1.Price_Book_Status__c='Active';
            priceSpecBookProduct1.Active__c=true;
            priceSpecBookProduct1.Customer_Ref_Model__c='';
            priceSpecBookProduct1.RecordTypeId=PriceBookProductRecordTypeId;
            priceSpecBookProduct1.Country__c='Hong Kong';
            priceSpecBookProduct1.Price_100pcs__c= 0.00;
            //priceSpecBookProduct1.Price_1000pcs__c= 605.10;
            priceSpecBookProduct1.Freight_Terms__c='Ex-Factory';
            priceSpecBookProduct1.Material__c='PS';
            priceSpecBookProduct1.Source__c='Virgin';
            //priceSpecBookProduct1.Product_Size__c='29CM';
            priceSpecBookProduct1.Special_Features__c='Ref Pack/ Item code: 2443156';
            priceSpecBookProduct1.Description__c='P13HANGUP-BOTTOM TRACKSUIT BABY';
            priceSpecBookProduct1.Order_to_Company__c='Hong Kong - Mainetti (HK) Ltd';
            priceSpecBookProduct1.Local_SKU__c='120698';
            priceSpecBookProduct1.Retailer_Code__c=retailerId;
            
            
            insert priceSpecBookProduct1;
            PBookProductId=priceSpecBookProduct1.Id;
        }catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
        }
        return PBookProductId;
    }
    
    public static Id createPriceBookProductCurrency(Id productId) {
        Id PBookProductCurrencyId=null;
        try{
            Price_Product_by_Currency__c priceProductByCurr=new Price_Product_by_Currency__c();
            priceProductByCurr.Price_Book_Product__c=productId;
            priceProductByCurr.Price_100_pcs__c= 60.510000;
            //priceProductByCurr.Price_1000_pcs__c= 605.1000;
            priceProductByCurr.CurrencyIsoCode='CNY';
            insert priceProductByCurr;
            PBookProductCurrencyId=priceProductByCurr.Id;
        }catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
        }
        return PBookProductCurrencyId;
    }
    
    public static Id createPriceBook(Id accId) {
        Id PBookId=null;
        try{
            Id PriceBookRecordTypeId = Schema.SObjectType.Price_Specification_Book__c.getRecordTypeInfosByName().get('Price Book').getRecordTypeId();
            
            Price_Specification_Book__c priceBook=new Price_Specification_Book__c();
            priceBook.Name='DECATHLON TEST Pricebook';
            priceBook.Account__c=accId;
            priceBook.Price_Book_Category__c='Account Global';
            priceBook.Market_Segment__c='EU';
            priceBook.Mainetti_Company__c='Mainetti India';
            priceBook.Book_Status__c='Active';
            priceBook.RecordTypeId=PriceBookRecordTypeId;
            insert priceBook;
            PBookId=priceBook.id;
        }catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
        }
        return PBookId;
    }
    
    public static Id createAccount() {
        Id accId=null;
        try{
            Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Retailer').getRecordTypeId();
            Account account=new Account();
            account.Name='DECATHLON';
            account.RecordTypeId=accountRecordTypeId;
            account.Account_Status__c='Active';
            account.Market_Segment__c='EU';
            insert account;
            accId=account.id;
        }catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
        }
        return accId;
    }
    
    public static Id createRetailerCode (Id accId) {
        Id retailerId=null;
        try{
            //Create Retailer and associate with account            
            Retailer_Code__c retaileCode=new Retailer_Code__c();
            retaileCode.Name='Decathlon Test';
            retaileCode.Account__c=accId;
            retaileCode.Market_Segment__c='EU';
            retaileCode.Country__c='France';
            retaileCode.JDE_LOB__c='DEC';
            retaileCode.Online_Enquiry__c=true;
            retaileCode.Full_Box_Order__c=true;
            insert retaileCode;
            retailerId=retaileCode.id;
            System.debug('Successfully created account and retailer: ');
        }catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
        }
        
        return retailerId;
        
    }
    
    public static Id createPartner() {
        Id partnerId=null;
        try{
            Id partnerRecordTypeId = Schema.SObjectType.Partner__c.getRecordTypeInfosByName().get('Mainetti Company').getRecordTypeId();
            //System.debug('partnerRecordTypeId: ' + partnerRecordTypeId);
            
            Partner__c partner=new Partner__c();
            partner.Name='Mainetti Ltd TEST';
            partner.Partner_Status__c='Active';
            partner.Type_of_Operation__c='Mainetti Company';
            partner.RecordTypeId=partnerRecordTypeId;
            partner.Decathlon_Code__c='9562799';
            partner.Default_Currency__c='CNY - China Yuan Renminbi';
            partner.Default_Order_to_Company__c='Hong Kong - Mainetti (HK) Ltd';
            insert partner;
            partnerId=partner.Id;
        }catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
        }
        return partnerId;
    }
    
    public static Id createProduct() {
        Id productId=null;
        try{
            
            Product__c product1=new Product__c();
            product1.Name='DCL327';
            product1.Consolidated_Style__c='DCL327';
            product1.Style__c='DCL3';
            product1.Product_Type__c='HANGERS';
            product1.Product_Family__c='INTIMATE';
            product1.Orderable__c=true;
            product1.Status__c='Active';
            product1.Material__c='PLASTIC';
            product1.Hook__c='PLASTIC';
            product1.Size_Length_e_g_17_43cm__c='27CM';
            product1.Mainetti_Model__c='DCL327';
            
            insert product1;
            productId=product1.id;
            System.debug('Successfully created product: '+product1);
        }catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
        }
        return productId;
    }
}