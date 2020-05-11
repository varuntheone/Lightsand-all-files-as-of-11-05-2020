@isTest
public class getMasterDataTest {
    @isTest
    static void testGetManitteCompanyMap()
    {
        // Inserting the Partner Data
        Partner__c partner = new Partner__c(Name = 'Mainetti (HK) Ltd', Default_Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd');
        insert partner;
        // Creating the Object for "getMasterData"
        getMasterData companyMap = new getMasterData();
        // Calling the "getMasterData" Methods
        companyMap.getManitteCompanyMap();
        companyMap.getManitteCompanyPicklistMap();
        companyMap.getManitteOrgCompanyMap();
        companyMap.getManitteCompanyIdMap();
        Map<string,string> mainettiCompanyMap = new Map<string,string>();
        map<string,Id> manitteIdMap = new map<string,Id>();
        List<Partner__c> partners = [Select  Name, Default_Order_to_Company__c from Partner__c where Default_Order_to_Company__c != null and Partner_Status__c = 'Active' and  RecordType.Name in('Mainetti Company','Licensee Partner')];
        for ( Partner__c ptn : partners )
        {
            mainettiCompanyMap.put(ptn.Name.toLowerCase(),ptn.Default_Order_to_Company__c); 
            manitteIdMap.put(ptn.Name,ptn.Id);
        }
        System.assertEquals(partner.Name, 'Mainetti (HK) Ltd');
        System.assertEquals(partner.Default_Order_to_Company__c, 'Hong Kong - Mainetti (HK) Ltd');
        
    }
    @isTest
    static void testGetRetailerCodeMap()
    {
        Retailer_Code__c retailercode = new Retailer_Code__c(Name = 'DECATHLON');
        insert retailercode;
        getMasterData companyMap = new getMasterData();
        companyMap.getRetailerCodeMap();
        companyMap.getRetailerCodeIdMap();
        Map<string,string> retailerCodeMap = new Map<string,string>();
        Map<string,Id> retailerCodeIdMap = new Map<string,Id>();          
        list<Retailer_Code__c> retailerCodes = [Select Id,Name from Retailer_Code__c];        
        for ( Retailer_Code__c retail : retailerCodes ){
            retailerCodeMap.put(retail.Name.toLowerCase(),retail.Name.toLowerCase());
            retailerCodeIdMap.put(retail.Name,retail.Id);
        }
        System.assertEquals(retailercode.Name, 'DECATHLON');
        //System.assertEquals(retailercode.Name, 'GU');
    }
    @isTest
    static void testGetInventoryStagRows()
    {
        Inventory_Transaction_Stage__c invTransStagRec = new Inventory_Transaction_Stage__c();
        invTransStagRec.Upload_Batch_No__c = invTransStagRec.Id;
        insert invTransStagRec;
        getMasterData companyMap = new getMasterData();
        companyMap.getInventoryStagRows( invTransStagRec.Id);
        List<Inventory_Transaction_Stage__c> invTransStagRecords = new List<Inventory_Transaction_Stage__c>();
        if(!String.isBlank(invTransStagRec.Id)){
            invTransStagRecords = [Select Row_No__c,Color__c,Color_NF__c,Inventory_Model__c,Inventory_Model_NF__c,Name,Local_System_SKU__c,Mainetti_Company__c,MC_NF__c,Price_Book_Spec_NF__c,Record_Status__c,Remarks__c,Retailer_Code__c,Retailer_Code_NF__c,Sizer_Print__c,Sizer_Print_NF__c,Source__c,Stock_In_Date__c,Stock_In_Qty__c,Upload_Batch_No__c,Warehouse__c,Warehouse_NF__c from Inventory_Transaction_Stage__c where Upload_Batch_No__c=:invTransStagRec.Id];
            System.debug(invTransStagRecords);
        }
    } 
    @IsTest(seeAllData=true)
    static void getDeleteCSVFileTest() {
        string csv = '[{"Retailer_Code__c": "GU","Mainetti_Company__c": "Mainetti (HK) Ltd","Inventory_Model__c": "TNGU139","Warehouse__c": "LongHua Factory","Color__c": "GRAY","Sizer_Print__c": "","Local_System_SKU__c": "157946","Source__c": "Virgin","Stock_In_Date__c": "23-May-19","Stock_In_Qty__c": "200",}]';
        string fileName = 'sample';
        Inventory_Transaction_Master__c value = new Inventory_Transaction_Master__c(); 
        value.Batch_Status__c = 'Migration Success';
        value.Record_Type__c = 'Inventory';
        value.Mainetti_Company__c = 'Mainetti (HK) Ltd';
        insert value;
        
        ContentVersion invenotryFile = new ContentVersion();
        invenotryFile.ContentLocation = 'S';
        invenotryFile.VersionData = Blob.valueOf(csv);
        invenotryFile.Title = 'Inventory Data File Uplaod';
        invenotryFile.PathOnClient = fileName;            
        insert invenotryFile;   
        
        ContentVersion inventoryVerContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :invenotryFile.Id];            
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=value.id;
        contentlink.ShareType= 'V';
        contentlink.ContentDocumentId=inventoryVerContent.ContentDocumentId;            
        insert contentlink;
        
        boolean flag = true;
        Test.startTest();
        getMasterData getMaster = new getMasterData();
        getMaster.getCSVFile(value.id);
        getMaster.deleteCSVFile(value.id);
        
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    @isTest
    static  void getPickListMapTest() {     
        
        boolean flag = true;
        Test.startTest();
        Inventory_Transaction_Master__c inventoryTransMaster = new Inventory_Transaction_Master__c ();
        getMasterData getMaster = new getMasterData();
        getMaster.getPickListMap('Price_Specification_Book_Product__c','Color__c');
        Test.stopTest();
        System.assertEquals(true, flag); 
    }
    
    @IsTest(seeAllData=true)
    static void createDocumentTest() {        
        string csv = '[{"Retailer_Code__c": "GU","Mainetti_Company__c": "Mainetti (HK) Ltd","Inventory_Model__c": "TNGU139","Warehouse__c": "LongHua Factory","Color__c": "GRAY","Sizer_Print__c": "","Local_System_SKU__c": "157946","Source__c": "Virgin","Stock_In_Date__c": "23-May-19","Stock_In_Qty__c": "200",}]';
        string fileName = 'sample';
        Inventory_Transaction_Master__c value = new Inventory_Transaction_Master__c(); 
        value.Batch_Status__c = 'Migration Success';
        value.Record_Type__c = 'Inventory';
        value.Mainetti_Company__c = 'Mainetti (HK) Ltd';
        insert value;
        
        string returnBatchId = '';
        boolean flag = true;
        Test.startTest();
        getMasterData getMaster = new getMasterData();
        getMaster.createDocument(value.id,csv,fileName);
        Test.stopTest();
        System.assertEquals(true, flag); 
    }
    @isTest
    static void testGetRTSModelMap()
    {
        Inventory_Transaction_Master__c value = new Inventory_Transaction_Master__c(); 
        value.Batch_Status__c = 'Migration Success';
        value.Record_Type__c = 'Inventory';
        value.Mainetti_Company__c = 'Mainetti (HK) Ltd';
        insert value;
        Inventory_Transaction_Stage__c stageValue = new Inventory_Transaction_Stage__c();
        stageValue.Color__c = 'GRAY';
        stageValue.Retailer_Code__c = 'GU';
        stageValue.Record_Status__c = '2 - Data Validation Successful';
        stageValue.Upload_Batch_No__c = value.id;
        stageValue.Stock_In_Date__c = '23-May-19';
        stageValue.Stock_In_Qty__c = '200';
        insert stageValue;
        string returnBatchId = '';
        //Partner__c partner = new Partner__c(Name = 'Mainetti (HK) Ltd', Default_Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd');
        //insert partner;
        Price_Specification_Book__c  priceSpecBook = new Price_Specification_Book__c();
        //priceSpecBook.Name = 'Decathlon Global Price 2016-11';
        //priceSpecBook.Mainetti_Company__c = 'Mainetti Hong Kong';
        //priceSpecBook.Book_Status__c = 'Active';
        insert priceSpecBook;
        Product__c product = new Product__c();
        product.Business_Vertical__c = 'TLA';
        //product.Name = 'EAS001';
        insert product;
        
        Price_Specification_Book_Product__c priceBookSpecProd = new Price_Specification_Book_Product__c(Color__c = 'GRAY',Price_Specification_Book__c = priceSpecBook.Id,Price_100pcs__c = 500,Product_Unique_ID__c =product.Id);
        insert priceBookSpecProd;
        Partner__c  partner = new Partner__c (Name = 'Mainetti (HK) Ltd',Default_Order_to_Company__c  = 'Hong Kong - Mainetti (HK) Ltd',Partner_Status__c = 'Active');
        insert partner;
        Test.startTest();
        getMasterData companyMap = new getMasterData();
        companyMap.getManitteCompanyMap();
        //Price_Specification_Book__c  priceSpecBook = new Price_Specification_Book__c();
        //nsert priceSpecBook;
        //Price_Specification_Book_Product__c priceBookSpecProd = new Price_Specification_Book_Product__c(Color__c = 'GRAY',Price_Specification_Book__c = priceSpecBook.Id);
        //insert priceBookSpecProd;
        Inventory_Transaction_Master__c updateBatchStatus = new Inventory_Transaction_Master__c();
        updateBatchStatus =[Select Id, Mainetti_Company__c, Record_Type__c from Inventory_Transaction_Master__c where Id=:value.id];
        System.debug('updateBatchStatus:::'+updateBatchStatus);
        //getMasterData companyMap = new getMasterData();
        companyMap.getRTSModelMap(updateBatchStatus);
        Test.stopTest();
        System.assertEquals(returnBatchId,'');  
    }
    @isTest
    static void testGetSizePrintMap()
    {
        Inventory_Transaction_Master__c value = new Inventory_Transaction_Master__c(); 
        value.Batch_Status__c = 'Migration Success';
        value.Record_Type__c = 'Inventory';
        value.Mainetti_Company__c = 'Mainetti (HK) Ltd';
        insert value;
        string returnBatchId = '';
        Test.startTest();
        Price_Specification_Book__c  priceSpecBook = new Price_Specification_Book__c();
        insert priceSpecBook;
        Product__c product = new Product__c();
        product.Business_Vertical__c = 'TLA';
        //product.Name = 'EAS001';
        insert product;
        
        Price_Specification_Book_Product__c priceBookSpecProd = new Price_Specification_Book_Product__c(Color__c = 'GRAY',Price_Specification_Book__c = priceSpecBook.Id,Price_100pcs__c = 500,Product_Unique_ID__c =product.Id);
        insert priceBookSpecProd;
        Inventory_Transaction_Master__c updateBatchStatus = new Inventory_Transaction_Master__c();
        updateBatchStatus =[Select Id, Mainetti_Company__c, Record_Type__c from Inventory_Transaction_Master__c where Id=:value.id];
        getMasterData companyMap = new getMasterData();
        companyMap.getSizePrintMap(updateBatchStatus);
        Test.stopTest();
        System.assertEquals(returnBatchId,'');  

    }
    @isTest
    static void testGetColorPrintMap()
    {
        Inventory_Transaction_Master__c value = new Inventory_Transaction_Master__c(); 
        value.Batch_Status__c = 'Migration Success';
        value.Record_Type__c = 'Inventory';
        value.Mainetti_Company__c = 'Mainetti (HK) Ltd';
        insert value;
        string returnBatchId = '';
        Test.startTest();
        Price_Specification_Book__c  priceSpecBook = new Price_Specification_Book__c();
        insert priceSpecBook;
        Product__c product = new Product__c();
        product.Business_Vertical__c = 'TLA';
        //product.Name = 'EAS001';
        insert product;
        
        Price_Specification_Book_Product__c priceBookSpecProd = new Price_Specification_Book_Product__c(Color__c = 'GRAY',Price_Specification_Book__c = priceSpecBook.Id,Price_100pcs__c = 500,Product_Unique_ID__c =product.Id);
        insert priceBookSpecProd;
        Inventory_Transaction_Master__c updateBatchStatus = new Inventory_Transaction_Master__c();
        updateBatchStatus =[Select Id, Mainetti_Company__c, Record_Type__c from Inventory_Transaction_Master__c where Id=:value.id];
        getMasterData companyMap = new getMasterData();
        companyMap.getPickListColorMap(updateBatchStatus);
        Test.stopTest();
        System.assertEquals(returnBatchId,'');  

    }
 /*@IsTest(seeAllData=true)
    static void getDeleteCSVFileTest1() {
        Inventory_Transaction_Master__c itm = new Inventory_Transaction_Master__c(); 
        itm.Batch_Status__c = 'Migration Success';
        itm.Record_Type__c = 'Inventory';
        itm.Mainetti_Company__c = 'Mainetti (HK) Ltd';
        insert itm;
        
        ContentDocument cd = new ContentDocument();
        
    } */
}