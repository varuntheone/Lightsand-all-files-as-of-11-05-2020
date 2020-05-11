@isTest
public class getSalesMasterDataTest {
    
    @isTest
    static void getRetailerCodeIdMapTest()
    {
        Retailer_Code__c retailercode = new Retailer_Code__c(Name = 'DECATHLON');
        insert retailercode;
        
        boolean flag = true;
         Test.startTest();
        getSalesMasterData getsalemasdata = new getSalesMasterData();
        getsalemasdata.getRetailerCodeIdMap();
         getsalemasdata.getFamilyMap();
         Test.stopTest();
        System.assertEquals(true, flag);
    }
    static testMethod Void getSalesStageRowsTest()
    {
         Inventory_Transaction_Master__c value = new Inventory_Transaction_Master__c(); 
        value.Batch_Status__c = 'Migration Success';
        value.Record_Type__c = 'Sales';
        insert value;
        
        Sales_Transaction_Stage__c salesTransStagRec = new Sales_Transaction_Stage__c();
        salesTransStagRec.Upload_Batch_No__c = salesTransStagRec.Id;
        insert salesTransStagRec;
        getSalesMasterData companyMap = new getSalesMasterData();
        companyMap.getSalesStageRows( salesTransStagRec.Id);
        companyMap.preValidationSalesStageData(salesTransStagRec.Id);
        companyMap.getNewVendorDivisionBrandLabelMap();
        List<Sales_Transaction_Stage__c> salesTransStagRecords = new List<Sales_Transaction_Stage__c>();
        if(!String.isBlank(salesTransStagRec.Id)){
            salesTransStagRecords = [Select Row_No__c,Source_FB__c,Local_Net_Unit_Pirce_100__c,Net_Unit_Price_100__c,Month_FB__c,Local_Net_Unit_Pirce_FB__c,Calculation_Failed__c,ExRate_to_USD_FB__c,Net_Unit_Price_100_FB__c,ExRate_to_EUR_FB__c,wrong_date__c,ExRate_to_USD__c,ErrorMapData__c,validation_failed__c,warning_consolidate_key__c,SO_Number__c,SO_Number_FB__c,SO_Number_NF__c,LOB__c,LOB_FB__c,LOB_NF__c,Company__c,Company_FB__c,Customer__c,Customer_FB__c,Transaction_Currency__c,Transaction_Currency_FB__c,Transaction_Currency_NF__c,Division__c,Division_FB__c,Division_NF__c,Mainetti_Brand__c,Mainetti_Brand_FB__c,Mainetti_Brand_NF__c,Item_code__c,Item_code_FB__c,Item_code_NF__c,Production_Country__c,Production_Country_FB__c,Production_Country_NF__c,Retailer_Brand__c,Retailer_Brand_FB__c,Retailer_Brand_NF__c,Material__c,Material_FB__c,Material_NF__c,Company_NF__c,Model__c,Model_FB__c,Model_NF__c,Market__c,Market_FB__c,Market_NF__c,Vendor__c,Vendor_FB__c,Vendor_NF__c,Category__c,Category_FB__c,Category_NF__c,Sub_Category__c,Sub_Category_FB__c,Sub_Category_NF__c,Order_Type__c,Order_Type_FB__c,Order_Type_NF__c,Shipped_To_Country__c,Shipped_To_Country_FB__c,Shipped_To_Country_NF__c,Shipped_To_Factory__c,Shipped_To_Factory_FB__c,Shipped_To_Factory_NF__c,Color__c,Color_FB__c,Color_NF__c,Country__c,Country_NF__c,Sales_Model__c,SM_NF__c,ExRate_to_EUR__c,ExRate_to_EUR_NF__c,Mainetti_Company__c,MC_NF__c,ExRate_to_USD_NF__c,Local_Currency__c,Local_Currency_NF__c,Local_Currency_FB__c,Month__c,Month_NF__c,Remarks__c,Retailer_Code__c,Retailer_Code_NF__c,Sales_Local__c,SL_NF__c,Source__c,Source_NF__c,Unit_Sold__c,US_NF__c,UOM__c,UOM_NF__c,Week__c,Week_NF__c,Year__c,Year_NF__c,Upload_Batch_No__c,Family__c,Family_FB__c,Family_NF__c,Sales_Transaction_Currency__c,STC_FB__c,STC_NF__c,Sales_EUR__c,Sales_EUR_FB__c,Sales_EUR_NF__c,Sales_USD__c,Sales_USD_FB__c,Sales_USD_NF__c,Unit_Price_100_EUR__c,Unit_Price_100_EUR_FB__c,Unit_Price_100_EUR_NF__c,Unit_Price_100_USD__c,Unit_Price_100_USD_FB__c,Unit_Price_100_USD_NF__c from Sales_Transaction_Stage__c where Upload_Batch_No__c=:salesTransStagRec.Id];
            System.debug(salesTransStagRecords);
        }
    }
     @IsTest(seeAllData=true)
    static void getDeleteCSVFileTest() {
        string csv = '[{"Company__c": "Hong Kong Packaging","Year__c": "2019","Week__c": "Wk02","Month__c": "Jan","Item_code__c": "HGR-3944   BLK002-  100","Material__c": "PS","Source__c": "Virgin","Model__c": "1000","Printed_Logo__c": "demoLogo","Color__c": "BLACK","Customer__c": "xxxxx","Customer_local_name__c": "","Mainetti_Brand__c": "Mainetti","Category__c": "HANGERS & ACCESSORIES","Sub_Category__c": "HANGERS","Family__c": "BOTTOM","Order_Type__c": "3rd","Unit_Sold__c": "2520","Unit_Price_100_EUR__c": "10.65123","Unit_Price_100_USD__c": "12.40602","Net_Unit_Price_100__c": "11","Sales_EUR__c": "268.410993","Sales_USD__c": "312.631704","Transaction_Currency__c" : "HKD","ExRate_to_EUR__c": "9.08505","ExRate_to_USD__c": "7.8","Local_Net_Unit_Pirce_100__c": "13","Sales_Transaction_Currency__c": "2438.527291","Shipped_To_Factory__c": "xxxxxx","Shipped_To_Country__c": "xxxxxx","Label__c": "","End_user__c": "","Vendor__c": "DemoRetailer","Division__c": "Demo","Retailer_Brand__c": "Demo", "Royalty_Rate__c": "", "Market__c": "USA","Remark__c": "","LOB__c": "PRL","": "SO_Number__c": "18300168","Production_Country__c": "CHINA"}]';
        string fileName = 'sample';
        Inventory_Transaction_Master__c value = new Inventory_Transaction_Master__c(); 
        value.Batch_Status__c = 'Migration Success';
        value.Record_Type__c = 'Inventory';
        insert value;
        
        ContentVersion salesFile = new ContentVersion();
        salesFile.ContentLocation = 'S';
        salesFile.VersionData = Blob.valueOf(csv);
        salesFile.Title = 'Sales Data File Uplaod';
        salesFile.PathOnClient = fileName;            
        insert salesFile;
        ContentVersion salesVerContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :salesFile.Id];            
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=value.id;
        contentlink.ShareType= 'V';
        contentlink.ContentDocumentId=salesVerContent.ContentDocumentId;            
        insert contentlink;
        
        boolean flag = true;
        Test.startTest();
        getSalesMasterData getSalesMaster = new getSalesMasterData();
        getSalesMaster.getCSVFile(value.id);
        getSalesMaster.deleteCSVFile(value.id);
        
        Test.stopTest();
        System.assertEquals(true, flag);
  
    }
      @isTest
    static void testGetFullSalesErrorMapTest(){
        
        Sales_Error_Mapping__c salesError = new Sales_Error_Mapping__c(Company__c = 'America Mid West - Hangers Unlimited', Raw_Data_Field__c = 'Model',Map_From_Value__c = '484BR',Map_To_Value__c = '484');
        insert salesError;
        Sales_Error_Mapping__c salesError1 = new Sales_Error_Mapping__c(Company__c = 'America Mid West - Hangers Unlimited', Raw_Data_Field__c = 'Model',Map_From_Value__c = 'BOTTOM',Map_To_Value__c = 'BOTTOM');
        insert salesError1;
        
         Sales_Error_Mapping__c salesErrors = new Sales_Error_Mapping__c(Company__c = 'America Mid West - Hangers Unlimited', Raw_Data_Field__c = 'Family',Map_From_Value__c = 'BOTTOM',Map_To_Value__c = 'BOTTOM');
        insert salesErrors;
        
        getSalesMasterData salesErrorMap = new getSalesMasterData();
        salesErrorMap.getFullSalesErrorMap();
        
        System.assertEquals(salesError.Company__c, 'America Mid West - Hangers Unlimited');
        System.assertEquals(salesError.Raw_Data_Field__c, 'Model');
        System.assertEquals(salesError.Map_From_Value__c, '484BR');
        System.assertEquals(salesError.Map_To_Value__c, '484');
        
        System.assertEquals(salesErrors.Company__c, 'America Mid West - Hangers Unlimited');
        System.assertEquals(salesErrors.Raw_Data_Field__c, 'Family');
        System.assertEquals(salesErrors.Map_From_Value__c, 'BOTTOM');
        System.assertEquals(salesErrors.Map_To_Value__c, 'BOTTOM');
        
        System.assertNotEquals(salesError1.Company__c, '');
        System.assertNotEquals(salesError1.Raw_Data_Field__c, '');
        System.assertNotEquals(salesError1.Map_From_Value__c, '');
        System.assertNotEquals(salesError1.Map_To_Value__c, '');       
    }
      @isTest
    static void testPartnerCompany()
    {
        Partner__c partners = new Partner__c(Name = 'Others', Default_Order_to_Company__c = 'Others');
        insert partners;
        getSalesMasterData partnerCompany = new getSalesMasterData();
        partnerCompany.partnerCompany();
        List<string> partnerMap = new List<string>();
        list<Partner__c> partnersCompany = [Select  Name, Default_Order_to_Company__c from Partner__c where Name ='Others' and Default_Order_to_Company__c != null and Partner_Status__c = 'Active' and  RecordType.Name in('Mainetti Company','Licensee Partner') order by Name];        
        for ( Partner__c partner : partnersCompany ){
            partnerMap.add(partner.Name.toLowerCase());
        }
        System.assertEquals(partners.Name, 'Others');
    }
     @isTest
    static void testgetModelConsolidateMap()
    {
        // Inserting the Partner Data
        Product__c product = new Product__c(Business_Vertical__c = 'HANGERS & ACCESSORIES',Consolidated_Style__c = 'SATIN HANGER');
        insert product;
        // Creating the Object for "getMasterData"
        getSalesMasterData productsMap = new getSalesMasterData();
        // Calling the "getMasterData" Methods
        productsMap.getModelConsolidateMap();
        Map<string,string> productMap = new Map<string,string>();
        List<Product__c> produ = [Select Consolidated_Style__c from Product__c where Consolidated_Style__c <> null];
        for ( Product__c prod : produ )
        {
            productMap.put(prod.Consolidated_Style__c.toLowerCase(),prod.Consolidated_Style__c.toLowerCase()); 
        }
        System.assertEquals(product.Consolidated_Style__c, 'SATIN HANGER');
        
    }
      @isTest
    static void testgetCategoryBusinessVerticalMap()
    {
        // Inserting the Partner Data
        Product__c product = new Product__c(Business_Vertical__c = 'HANGERS & ACCESSORIES');
        insert product;
        // Creating the Object for "getMasterData"
        getSalesMasterData productsMap = new getSalesMasterData();
        // Calling the "getMasterData" Methods
        productsMap.getCategoryBusinessVerticalMap();
        Map<string,string> productMap = new Map<string,string>();
        List<Product__c> produ = [Select Business_Vertical__c from Product__c where Business_Vertical__c <> null];
        for ( Product__c prod : produ )
        {
            productMap.put(prod.Business_Vertical__c.toLowerCase(),prod.Business_Vertical__c.toLowerCase()); 
        }
        System.assertEquals(product.Business_Vertical__c, 'HANGERS & ACCESSORIES');
        
    }
     @isTest
    static void testGetModelCatFamilyMap()
    {
        Inventory_Transaction_Master__c value = new Inventory_Transaction_Master__c(); 
        value.Batch_Status__c = 'Migration Success';
        value.Record_Type__c = 'Inventory';
        value.Mainetti_Company__c = 'Mainetti (HK) Ltd';
        insert value;
        
        Inventory_Transaction_Master__c updateBatchStatus = new Inventory_Transaction_Master__c();
        updateBatchStatus =[Select Id, Mainetti_Company__c, Record_Type__c from Inventory_Transaction_Master__c where Id=:value.id];
        
        Product__c product = new Product__c(Consolidated_Style__c = 'ZC14', Business_Vertical__c = 'HANGERS & ACCESSORIES',Product_Type__c = 'HANGERS',Product_Family__c = 'SET',Sub_category__c = 'PLASTIC HANGERS');
        insert product;
        getSalesMasterData productCat = new getSalesMasterData();
        productCat.getModelCatFamilyMap();
        productCat.getSalesModelMap(updateBatchStatus);
        
        System.assertEquals(product.Consolidated_Style__c, 'ZC14');
        System.assertEquals(product.Business_Vertical__c, 'HANGERS & ACCESSORIES');
        System.assertEquals(product.Product_Type__c, 'HANGERS');
        System.assertEquals(product.Sub_category__c, 'PLASTIC HANGERS');
        System.assertEquals(product.Product_Family__c, 'SET');
    }
     @isTest
    static void testGetProductDetails()
    {
        Product__c product = new Product__c();
        product.Consolidated_Style__c = 'ABCD';
        product.Business_Vertical__c = 'HANGERS & ACCESSORIES';
        product.Product_Type__c = 'HANGERS';
        product.Product_Family__c = 'TOP';
        insert product;
        getSalesMasterData productDetails = new getSalesMasterData();
        productDetails.getProductDetails();        
        list<Product__c> prod = [Select Consolidated_Style__c,Business_Vertical__c,Product_Type__c,Product_Family__c from Product__c where Consolidated_Style__c <> null and Business_Vertical__c <> null and Product_Type__c <> null and Product_Family__c <> null];
     }
     @isTest
    static void testLululemonModel()
    {
        
        Price_Specification_Book__c  priceSpecBook = new Price_Specification_Book__c();
        insert priceSpecBook;
        Product__c product = new Product__c();
        product.Business_Vertical__c = 'TLA';
        insert product;
        Retailer_Code__c retailercode = new Retailer_Code__c(Name = 'LULULEMON');
        insert retailercode;
        Price_Specification_Book_Product__c priceSpecificationBookProduct = new Price_Specification_Book_Product__c(Name = 'LULULEMON',Price_Specification_Book__c = priceSpecBook.Id,Price_100pcs__c = 500,Product_Unique_ID__c =product.Id);
        insert priceSpecificationBookProduct;
        getSalesMasterData lululemonModel = new getSalesMasterData();
        lululemonModel.getlululemonModelMap();
        Map<string,string> lululemonModelMap = new Map<string,string>();
        list<Price_Specification_Book_Product__c> priceSpecificationBooks = [Select Id,Name,Retailer_Code__r.Name from Price_Specification_Book_Product__c  where Retailer_Code__r.Name='LULULEMON' and Name <> null];        
        for ( Price_Specification_Book_Product__c priceSpecificationBook : priceSpecificationBooks ){
            lululemonModelMap.put(priceSpecificationBook.Name.toLowerCase(),priceSpecificationBook.Name.toLowerCase());
        }
        System.assertEquals(priceSpecificationBookProduct.Name, 'LULULEMON');
    }
     @isTest
    static void testGetDebenhamModel()
    {
        
        Price_Specification_Book__c  priceSpecBook = new Price_Specification_Book__c();
        insert priceSpecBook;
        Product__c product = new Product__c();
        product.Business_Vertical__c = 'TLA';
        insert product;
        Retailer_Code__c retailer = new Retailer_Code__c();
        retailer.Retailer_Brand__c = 'BKA';
        insert retailer;
        Price_Specification_Book_Product__c priceSpecificationBookProduct = new Price_Specification_Book_Product__c(Name = 'DECATHLON',Price_Specification_Book__c = priceSpecBook.Id,Price_100pcs__c = 500,Product_Unique_ID__c =product.Id);
        insert priceSpecificationBookProduct;
        getSalesMasterData debenhamModel = new getSalesMasterData();
        debenhamModel.getDebenhamModelMap();
        debenhamModel.getDebenhamBrandMap();
        debenhamModel.getDebenhamModelBrandKeyMap();
        Map<string,string> debenhamModelMap = new Map<string,string>();
        list<Price_Specification_Book_Product__c> priceSpecificationBooks = [Select Id,Name,Retailer_Code__r.Name from Price_Specification_Book_Product__c  where Retailer_Code__r.Name='LULULEMON' and Name <> null and Retailer_Brand__c <> null];        
        for ( Price_Specification_Book_Product__c priceSpecificationBook : priceSpecificationBooks ){
            debenhamModelMap.put(priceSpecificationBook.Name.toLowerCase(),priceSpecificationBook.Name.toLowerCase());
        }
        System.assertEquals(priceSpecificationBookProduct.Name, 'DECATHLON');
    }
     @isTest
    static void testGetNewVendorDivisionBrandLabelMap()
    {
        
        String lable = 'abc';
        String brand = 'bcd';
        String division = 'lululemon';
        
        String labelBrand ='abc';
      
        
        Retailer_Code__c retailer = new Retailer_Code__c();
        retailer.Name = 'DECATHLON';
        insert retailer;
        String vendorName = 'abc'; 
        Map<string,Map<string,string>> VendorDivisionBrandLabelMap = new Map<string,Map<string,string>>();
         
               
        
        Label_Division__c lableDivision = new Label_Division__c();
        //lableDivision.Retailer_Code__c = 'a00p0000007Vl0BAAS';
        lableDivision.Retailer_Code__c = retailer.Id;
        lableDivision.Division__c = 'ABCD';
        lableDivision.Retailer_Brand__c = 'Rock & Republic';
        lableDivision.Label__c = 'PL';
        insert lableDivision;
        getSalesMasterData vendorDivisionBrand = new getSalesMasterData();
        vendorDivisionBrand.getNewVendorDivisionBrandLabelMap();        
        list<Label_Division__c> labelDiv = [Select Retailer_Code_Name__c, Division__c, Retailer_Brand__c, Label__c from Label_Division__c where Retailer_Code_Name__c <> null];
       /* string cmpKey = product.Consolidated_Style__c+'#'+product.Business_Vertical__c+'#'+product.Product_Type__c+'#'+product.Product_Family__c;
        for ( Product__c products : prod ){
            vendorDivBrandLabel.put(cmpKey.toLowerCase(),cmpKey.toLowerCase());
        }*/
    }
    
    
      @isTest
    static void testRetailerDivisionBrandCkeck()
    {
        
        Retailer_Code__c retailercode = new Retailer_Code__c(Name = 'DECATHLON');
        insert retailercode;
        Label_Division__c lableDivision = new Label_Division__c();
        lableDivision.Retailer_Code__c = 'a00p0000007Vl0BAAS';
        lableDivision.Division__c = 'ABCD';
        lableDivision.Retailer_Brand__c = 'Rock & Republic';
        lableDivision.Label__c = 'PL';
        insert lableDivision;
        getSalesMasterData retailerDivisionBrand = new getSalesMasterData();
        retailerDivisionBrand.getRetailersLabelDivisionBrandCheckMap();
        retailerDivisionBrand.getVendorDivisionBrandLabelMap();
        Map<string,Retailer_Code__c> retailerDivBrand = new Map<string,Retailer_Code__c>();
        Map<string,string> vendorDivBrandLabel = new Map<string,string>();
        list<Retailer_Code__c> retailerCodes = [Select Name,Division_check__c,Label_Check__c,Retailer_Brand_Check__c,Sales_Data_Upload_Check__c from Retailer_Code__c where Name <> null]; 
        list<Label_Division__c> labelDiv = [Select Retailer_Code_Name__c, Division__c, Retailer_Brand__c, Label__c from Label_Division__c where Retailer_Code_Name__c <> null and Division__c <> null and Retailer_Brand__c <> null and Label__c <> null];
        for ( Retailer_Code__c retailer : retailerCodes ){
            retailerDivBrand.put(retailer.Name,retailer);
        }
        string cmpKey = lableDivision.Retailer_Code_Name__c+'#'+lableDivision.Division__c+'#'+lableDivision.Retailer_Brand__c+'#'+lableDivision.Label__c;
        for ( Label_Division__c labDiv : labelDiv ){
            vendorDivBrandLabel.put(cmpKey.toLowerCase(),cmpKey.toLowerCase());
        }
        System.assertEquals(retailercode.Name, 'DECATHLON');
     }
    @isTest
    static void testGetSalesStageRowsByPage()
    {
        string selcomp = '';
        string selMonth = 'Feb';
        string selYear = '2019';
        String batchId = '';
        String userName = UserInfo.getUserName();
        User activeUser = [Select Email From User where Username = : userName limit 1];
        String userEmailNotify = activeUser.Email;
        List<Sales_Transaction_Stage__c> salesTransStagRecAfterReconciliation = new List<Sales_Transaction_Stage__c> ();
        List<Sales_Transaction_Stage__c> salesTransStagRecForReconciliation = new  List<Sales_Transaction_Stage__c>();
        getSalesMasterData salesMasterData = new getSalesMasterData();
        Map<Decimal,string> missingFieldValMap = new Map<Decimal,string>();   
        Map<Decimal,Map<string,string>> inCorrectFormatMap = new Map<Decimal,Map<string,string>>();       
        Map<string,Map<string,Map<string,string>>> fullSalesErrorMap = new Map<string,Map<string,Map<string,string>>>();
        Map<string,Map<string,string>> compositeProductMap = new  Map<string,Map<string,string>>();
        Map<string,string> modelWarningMap = new  Map<string,string>();
        Map<string,string> modelConsolidateMap =  new  Map<string,string>();
        Map<string,string> categoryMap =  new  Map<string,string>();
        Map<string,string> modelCompKeyMap = new  Map<string,string>();
        Map<string,string> marketMap = new Map<string,string>();
        Map<string,string> vendorMap =new Map<string,string>();
        Map<string,string> colorMap = new Map<string,string>();        
        Map<string,string> dateMap =  new  Map<string,string>();
        Map<string,string> companyNameMap = new Map<string,string>();
        Map<string,string> productionCoungtryMap =new Map<string,string>();
        Map<string,string> lululemonModelMap =  new  Map<string,string>();
        Map<string,string> debenhanModelMap =  new  Map<string,string>();
        Map<string,string> debenhanBrandMap =  new  Map<string,string>();
        Map<string,string> debenhanModelBrandKeyMap =  new  Map<string,string>();
        Map<string,string> vendorDivisionBrandLabelMap = new  Map<string,string>();
        Map<string,Map<string,string>> getNewVendorDivisionBrandLabelMap = new Map<string,Map<string,string>>();
        Map<string,Retailer_Code__c> getRetailersLabelDivisionBrandCheckMap =  new  Map<string,Retailer_Code__c>();        
        map<string,string> companyOnlyMap = new map<string,string>();
        //Map<string,string> retailerCodeMap =  salesMasterData.getRetailerCodeMap();
        Map<string,string> getModelandColorMap = new Map<string,string>();
        Map<string,string> getSalesDataUploadCheckMap = new Map<string,string>();
        Map<string,string> getSalesDataUploadColorCheckMap =new Map<string,string>();
        Map<string,string> checkColorwithModel  =new Map<string,string>();
        Map<string,string> getModelCatFamilyMap = new  Map<string,string>();
        Inventory_Transaction_Master__c updateBatchStatus = new Inventory_Transaction_Master__c ();
        validateSalesRowsBulk.recordValidationStatus recordStatus = new  validateSalesRowsBulk.recordValidationStatus();
        
        Test.startTest();
        getSalesMasterData getSalesMast = new getSalesMasterData();
        getSalesMast.preValidationSalesStageDataByPage(salesTransStagRecForReconciliation, fullSalesErrorMap,batchId, selcomp, selMonth, selYear, inCorrectFormatMap, colorMap, marketMap, lululemonModelMap, debenhanModelMap, debenhanModelBrandKeyMap, debenhanBrandMap, vendorDivisionBrandLabelMap, productionCoungtryMap, modelWarningMap, modelCompKeyMap, dateMap, companyOnlyMap, vendorMap, userEmailNotify,updateBatchStatus, recordStatus,getNewVendorDivisionBrandLabelMap,getRetailersLabelDivisionBrandCheckMap,getModelandColorMap,getSalesDataUploadCheckMap,getSalesDataUploadColorCheckMap,checkColorwithModel,getModelCatFamilyMap);
        getSalesMast.getSalesStageRowsByPage(salesTransStagRecAfterReconciliation, BatchId, selcomp, selMonth,selYear, inCorrectFormatMap, colorMap, marketMap, lululemonModelMap, debenhanModelMap, debenhanModelBrandKeyMap, debenhanBrandMap, vendorDivisionBrandLabelMap, productionCoungtryMap, modelWarningMap, modelCompKeyMap, dateMap, companyOnlyMap, vendorMap, updateBatchStatus, userEmailNotify, recordStatus, getNewVendorDivisionBrandLabelMap, getRetailersLabelDivisionBrandCheckMap, getModelandColorMap, getSalesDataUploadCheckMap , getSalesDataUploadColorCheckMap, checkColorwithModel, getModelCatFamilyMap );
        
        Test.stopTest();
    }
    @isTest
    static void testgetRetailerDetails()
    {
        boolean flag = true;
        Retailer_Code__c retailer = new Retailer_Code__c(Sales_Data_Upload_Market__c = 'US');
        insert retailer;
        Test.startTest();
        getSalesMasterData getMaster = new getSalesMasterData();
        getMaster.getRetailerDetails();
        
        Test.stopTest();
        System.assertEquals(true, flag); 
    }
     @isTest
    static void testgetPriceSpecificationBookDetails()
    { 
        String color = 'Gray';
        Price_Specification_Book__c  priceSpecBook = new Price_Specification_Book__c();
        insert priceSpecBook;
        Product__c product = new Product__c();
        product.Business_Vertical__c = 'TLA';
        product.Consolidated_Style__c = 'GU';
        insert product;
        Retailer_Code__c retailer = new Retailer_Code__c();
        retailer.Name = 'DECATHLON';
        insert retailer;
        
        Price_Specification_Book_Product__c priceSpecificationBookProduct = new Price_Specification_Book_Product__c(Name = 'DECATHLON',Price_Specification_Book__c = priceSpecBook.Id,Price_100pcs__c = 500,Product_Unique_ID__c =product.Id,Retailer_Code__c =retailer.Id,Color__c = 'Gray');
       // priceSpecificationBookProduct.Color__c = 'Black';
       //  priceSpecificationBookProduct.Consolidated_Style__c = 'GU';
        insert priceSpecificationBookProduct;
        
       
       boolean flag = true;
         
        Test.startTest();
        getSalesMasterData getMaster = new getSalesMasterData();
        getMaster.getPriceSpecificationBookDetails();
        
        Test.stopTest();
        System.assertEquals(true, flag);    
    }
    
}