/*
* Author:        Naveen Guleria
* Company:       TECHKASETTI
* Description:   Unit Test for DecathlonOrderProcessor
* History
* <Date>          <Naveen Guleria>   <Unit Test for DecathlonOrderProcessor>
*/
@IsTest (SeeAllData = false) 
public class DecathlonOrderProcessorTest {
    
    @TestSetup
    static void setupTestData()
    {
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        
        System.runAs (thisUser)
        {
            Test.startTest();
            Id accId = DecathlonOrderProcessorTest.createAccount();
            //System.assert(accId != null);
            System.debug('accId: '+accId);
            Id retailerId=DecathlonOrderProcessorTest.createRetailerCode(accId);
            System.debug('retailerId: '+retailerId);
            //List<Product__c> pList=DecathlonOrderProcessorTest.createProducts();
            Id productId=DecathlonOrderProcessorTest.createProduct();
            System.debug('productId: '+productId);
            Id priceSpecBookId =DecathlonOrderProcessorTest.createPriceBook(accId);
            System.debug('priceSpecBookId: '+priceSpecBookId);
            Id priceBookProductId=DecathlonOrderProcessorTest.createPriceBookProduct(accId, productId, priceSpecBookId, retailerId);
            System.debug('priceBookProductId: '+priceBookProductId);
            Id currencyId=DecathlonOrderProcessorTest.createPriceBookProductCurrency(priceBookProductId);
            System.debug('currencyId: '+currencyId);
            
            Id partnerId=DecathlonOrderProcessorTest.createPartner();
            System.debug('partnerId: '+partnerId);
            //System.assertEquals(true, result,'Creates account and retailer');
            System.debug('Created test data');
            Test.stopTest();
            
        }
    }
    
    @IsTest(SeeAllData = false) 
    public static void testForValidOnlineEnquiryAdd() {  
        // Perform test
        Test.startTest();
        String docId='TEST-001-TEST';
        String supplierCNUF='9562799';
        String customerCNUF='6005599';
        String ModelId='2442595';
        String actionCode='Add';
        Id baseOrderId=DecathlonOrderProcessorTest.createBaseOrder(docId, supplierCNUF, customerCNUF, ModelId, actionCode);
        System.debug('baseOrderId: '+baseOrderId);
        /*
        Base_Order__c baseOrder=new Base_Order__c();
        baseOrder.id=baseOrderId;
        baseOrder.Start_Process__c=true;
        update baseOrder;*/   
        List<string> inputParams=new List<string>();
        inputParams.add(baseOrderId+'');
        DecathlonOrderProcessor.processOrder(inputParams);
        Test.stopTest();
        System.debug('update order: '+baseOrderId);
        
    }
    
    @IsTest(SeeAllData = false) 
    public static void testForValidOnlineEnquiryValidate() {  
        // Perform test
        Test.startTest();
        String docId='TEST-001-TEST';
        String supplierCNUF='9562799';
        String customerCNUF='6005599';
        String ModelId='2442595';
        String actionCode='Validated';
        Id baseOrderId=DecathlonOrderProcessorTest.createBaseOrder(docId, supplierCNUF, customerCNUF, ModelId, actionCode);
        System.debug('baseOrderId: '+baseOrderId);
        /*
        Base_Order__c baseOrder=new Base_Order__c();
        baseOrder.id=baseOrderId;
        baseOrder.Start_Process__c=true;
        update baseOrder;*/   
        List<string> inputParams=new List<string>();
        inputParams.add(baseOrderId+'');
        DecathlonOrderProcessor.processOrder(inputParams);
        Test.stopTest();
        System.debug('update order: '+baseOrderId);
        
    }
    
     @IsTest(SeeAllData = false) 
    public static void testForValidOnlineEnquiryDelete() {      
        // Perform test
        Test.startTest();
        String docId='TEST-004-TEST';
        String supplierCNUF='9562799';
        String customerCNUF='6005599';
        String ModelId='2442595';
        String actionCode='Delete';
        Id baseOrderId=DecathlonOrderProcessorTest.createBaseOrder(docId, supplierCNUF, customerCNUF, ModelId, actionCode);
        System.debug('baseOrderId: '+baseOrderId);
        /*
        Base_Order__c baseOrder=new Base_Order__c();
        baseOrder.id=baseOrderId;
        baseOrder.Start_Process__c=true;
        update baseOrder;*/   
        List<string> inputParams=new List<string>();
        inputParams.add(baseOrderId+'');
        DecathlonOrderProcessor.processOrder(inputParams);      
        Test.stopTest();
        System.debug('update order: '+baseOrderId);
        
    }

    
    @IsTest(SeeAllData = false) 
    public static void testForMissingSupplier() {    
        // Perform test
        Test.startTest();
        String docId='TEST-005-TEST';
        String supplierCNUF='123456789';
        String customerCNUF='6005599';
        String ModelId='2442595';
        String actionCode='Add';
        Id baseOrderId=DecathlonOrderProcessorTest.createBaseOrder(docId, supplierCNUF, customerCNUF, ModelId, actionCode);
        System.debug('baseOrderId: '+baseOrderId);
        /*
        Base_Order__c baseOrder=new Base_Order__c();
        baseOrder.id=baseOrderId;
        baseOrder.Start_Process__c=true;
        update baseOrder;*/   
        List<string> inputParams=new List<string>();
        inputParams.add(baseOrderId+'');
        DecathlonOrderProcessor.processOrder(inputParams);   
        Test.stopTest();
        System.debug('update order: '+baseOrderId);
        
    }
    
    @IsTest(SeeAllData = false) 
    public static void testForBlankSupplier() {    
        // Perform test
        Test.startTest();
        String docId='TEST-006-TEST';
        String supplierCNUF='';
        String customerCNUF='6005599';
        String ModelId='2442595';
        String actionCode='Add';
        Id baseOrderId=DecathlonOrderProcessorTest.createBaseOrder(docId, supplierCNUF, customerCNUF, ModelId, actionCode);
        System.debug('baseOrderId: '+baseOrderId);
        /*
        Base_Order__c baseOrder=new Base_Order__c();
        baseOrder.id=baseOrderId;
        baseOrder.Start_Process__c=true;
        update baseOrder;*/   
        List<string> inputParams=new List<string>();
        inputParams.add(baseOrderId+'');
        DecathlonOrderProcessor.processOrder(inputParams);
        Test.stopTest();
        System.debug('update order: '+baseOrderId);
        
    }
    
    @IsTest(SeeAllData = false) 
    public static void testForBlankCustomer() {    
        // Perform test
        Test.startTest();
        String docId='TEST-007-TEST';
        String supplierCNUF='9562799';
        String customerCNUF='';
        String ModelId='2442595';
        String actionCode='Add';
        Id baseOrderId=DecathlonOrderProcessorTest.createBaseOrder(docId, supplierCNUF, customerCNUF, ModelId, actionCode);
        System.debug('baseOrderId: '+baseOrderId);
       /*
        Base_Order__c baseOrder=new Base_Order__c();
        baseOrder.id=baseOrderId;
        baseOrder.Start_Process__c=true;
        update baseOrder;*/   
        List<string> inputParams=new List<string>();
        inputParams.add(baseOrderId+'');
        DecathlonOrderProcessor.processOrder(inputParams);
        Test.stopTest();
        System.debug('update order: '+baseOrderId);
        
    }
    
    @IsTest(SeeAllData = false) 
    public static void testForMissingModel() {    
        // Perform test
        Test.startTest();
        String docId='TEST-008-TEST';
        String supplierCNUF='9562799';
        String customerCNUF='6005599';
        String ModelId='2442595999';
        String actionCode='Add';
        Id baseOrderId=DecathlonOrderProcessorTest.createBaseOrder(docId, supplierCNUF, customerCNUF, ModelId, actionCode);
        System.debug('baseOrderId: '+baseOrderId);
        /*
        Base_Order__c baseOrder=new Base_Order__c();
        baseOrder.id=baseOrderId;
        baseOrder.Start_Process__c=true;
        update baseOrder;*/   
        List<string> inputParams=new List<string>();
        inputParams.add(baseOrderId+'');
        DecathlonOrderProcessor.processOrder(inputParams);
        Test.stopTest();
        System.debug('update order: '+baseOrderId);
        
    }

    
    public static Id createBaseOrder(String docId, String supplierCNUF, String customerCNUF, String ModelId, String actionCode) {
        Id baseOrderId=null;
        try{
            
            Base_Order__c baseOrder=new Base_Order__c();
            baseOrder.Logical_ID__c='rang2_asia';
            baseOrder.Task_ID__c='create component order (NR)';
            baseOrder.Creation_Date_Time__c=Date.newInstance(2019, 2, 17);
            baseOrder.Action_Code__c=actionCode;
            baseOrder.Document_ID__c=docId;
            baseOrder.Note__c='Test Comments';
            baseOrder.Note_Priority_Level__c='Normal';
            baseOrder.Processing_Status__c='Draft';
            baseOrder.TechnicalParty_PartyTypeNumber__c='2';
            baseOrder.TechnicalParty_PartyNumber__c='2403';
            baseOrder.TechnicalParty_PartySubNumber__c='2403';
            baseOrder.SupplierParty_PartyTypeNumber__c='2';
            baseOrder.SupplierParty_PartySubNumber__c='26733';
            baseOrder.SupplierParty_PartyNumber__c='26733';
            baseOrder.Order_Date_Time__c=Date.newInstance(2019, 2, 17);
            baseOrder.SupplierParty_Name__c='SUZHOU MAINETTI PLASTIC PRODUC';
            baseOrder.SupplierParty_CNUF__c=supplierCNUF;
            baseOrder.CustomerParty_PartyTypeNumber__c='2';
            baseOrder.CustomerParty_PartyNumber__c='36703';
            baseOrder.CustomerParty_PartySubNumber__c='36703';
            baseOrder.CustomerParty_Name__c='HUAIAN CHISAGE INDUSTRIAL';
            baseOrder.CustomerParty_CNUF__c=customerCNUF;
            baseOrder.CustomerParty_BillTo_Address1__c='淮安中哲实业有限公司';
            baseOrder.CustomerParty_BillTo_Address2__c='江苏省淮安市经济开发区南马厂乡王高路28号';
            baseOrder.CustomerParty_BillTo_Address3__c='-';
            baseOrder.CustomerParty_BillTo_Address4__c='-';
            baseOrder.CustomerParty_BillTo_CityName__c='HUAIAN';
            baseOrder.CustomerParty_BillTo_Country_Code__c='CN';
            baseOrder.CustomerParty_BillTo_Postal_Code__c='22305';
            baseOrder.CustomerParty_BillTo_Email__c='amy@chisage.com';
            baseOrder.CustomerParty_BillTo_Telephone__c='+86 (0)517 8990 6572';
            baseOrder.CustomerParty_ShipTo_Address1__c='何 莹';
            baseOrder.CustomerParty_ShipTo_Address2__c='江苏省淮安市经济开发区王高路28号';
            baseOrder.CustomerParty_ShipTo_Address3__c='-';
            baseOrder.CustomerParty_ShipTo_Address4__c='-';
            baseOrder.CustomerParty_ShipTo_CityName__c='&amp;#27743;&amp;#33487;&amp;#28142;&amp;#23433;';
            baseOrder.CustomerParty_ShipTo_Postal_Code__c='223200';
            baseOrder.CustomerParty_ShipTo_Country_Code__c='CN';
            baseOrder.CustomerParty_ShipTo_Email__c='H-hy@chisage.com';
            baseOrder.CustomerParty_ShipTo_Telephone__c='15952309792';
            baseOrder.Handover_Date_Time__c=Date.newInstance(2019, 2, 17);
            insert baseOrder;
            
            baseOrderId=baseOrder.Id;

            Base_Order_Detail__c orderDetail1=new Base_Order_Detail__c();
            orderDetail1.Base_Order__c=baseOrder.Id;
            orderDetail1.Model_Id__c=ModelId;
            orderDetail1.Item_ID__c=ModelId;
            orderDetail1.Item_Description__c='HANGUP BOTTOM JUNIOR 18cm PACK STANDARD DCB418';
            orderDetail1.Dsm_ID__c='9810005098';
            orderDetail1.Dsm_Description__c='P13HANGUP-BOTTOM JUNIOR';
            orderDetail1.Industrial_Process__c='Woven';
            orderDetail1.Transport_Type__c='AIR';
            orderDetail1.Specification_Type__c='Characteristic';
            orderDetail1.Scheme_Agency_ID__c='0460000500001';
            orderDetail1.Scheme_Agency_Name__c='TRACE';
            orderDetail1.Agency_Item_ID__c=ModelId;
            orderDetail1.Model_Description__c='DCB418';
            orderDetail1.PurchaseOrderLine_LineNumber__c='1';
            orderDetail1.PurchaseOrderLine_Quantity__c='110';
            orderDetail1.PurchaseOrderLine_PerQuantity__c='1';
            orderDetail1.PurchaseOrderLine_unitCode__c='pcs';
            orderDetail1.PurchaseOrderLine_Amount__c='0.6048';
            orderDetail1.PurchaseOrderLine_Amount_CurrencyID__c='CNY';
            orderDetail1.PurchaseOrderLine_HandoverDateTime__c=Date.newInstance(2019, 2, 17);
            insert orderDetail1;
        }catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
        }  
        return baseOrderId;
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
            priceSpecBookProduct1.Customer_Ref_Model__c='2442595';
            priceSpecBookProduct1.RecordTypeId=PriceBookProductRecordTypeId;
            priceSpecBookProduct1.Country__c='Hong Kong';
            priceSpecBookProduct1.Price_100pcs__c= 0.00;
           // priceSpecBookProduct1.Price_1000pcs__c= 605.10;
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
            retaileCode.Name='DECATHLON';
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
           //partner.Default_Currency__c='CNY - China Yuan Renminbi';
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
    
    public static List<Product__c> createProducts() {
        
        List<Product__c> pList=new List<Product__c>();
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
            
            pList.add(product1);
            
            Product__c product2=new Product__c();
            product2.Name='DCTB238';
            product2.Consolidated_Style__c='DCTB238';
            product2.Style__c='DCTB2';
            product2.Product_Type__c='HANGERS';
            product2.Product_Family__c='TOP';
            product2.Orderable__c=true;
            product2.Status__c='Active';
            product2.Material__c='PLASTIC';
            product2.Hook__c='PLASTIC';
            product2.Size_Length_e_g_17_43cm__c='38CM';
            product2.Mainetti_Model__c='DCTB238';
            
            pList.add(product2);
            
            insert pList;
            System.debug('Successfully created products: '+pList.size());
        }catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
        }
        return pList;
    }
    
    
    
}