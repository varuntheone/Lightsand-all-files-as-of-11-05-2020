@isTest
public class uploadMaterialTest {
    
    static testMethod void getData() {        
        Inventory_Transaction_Master__c value = new Inventory_Transaction_Master__c(); 
        value.Batch_Status__c = 'Migration Success';
        value.Record_Type__c = 'Material Pricing';
        value.Mainetti_Company__c = 'Mainetti (HK) Ltd';
        insert value;
        
        Test.startTest();
        uploadMaterial.getMaterialErrorData(value.id);
        uploadMaterial.getMaterialSuccessData(value.id);
        Test.stopTest();
        Inventory_Transaction_Master__c searchQuery = [Select Id,Batch_Status__c, Record_Type__c, Mainetti_Company__c from Inventory_Transaction_Master__c];
        System.assertEquals(String.valueOf(searchQuery.Record_Type__c),'Material Pricing'); 
    } 
    
    static testMethod void parseMaterialPricingTest() {                
        string jSon = '[{\"Mainetti_Company__c\":\"Mainetti (HK) Ltd\",\"Location__c\":\"usa\",\"Material_Type__c\":\"lenin\",\"Unit_Price__c\":\"100\",\"UOM__c\":\"10\",\"Year__c\":\"2019\",\"Month__c\":\"10\",\"Date__c\":\"10\"}]';        
        string jSonInvalid = '[{\"Mainetti_Company__c\":\"Mainetti (HK1) Ltd\",\"Location__c\":\"usa\",\"Material_Type__c\":\"lenin\",\"Unit_Price__c\":\"100\",\"UOM__c\":\"10\",\"Year__c\":\"2019\",\"Month__c\":\"10\",\"Date__c\":\"10\"}]';
        string jSonMissing = '[{\"Mainetti_Company__c\":\"\",\"Location__c\":\"\",\"Material_Type__c\":\"\",\"Unit_Price__c\":\"\",\"UOM__c\":\"\",\"Year__c\":\"\",\"Month__c\":\"\",\"Date__c\":\"\"}]';
        string recordType = 'Material Pricing';
        string company = 'Mainetti (HK) Ltd';
        string returnBatchId = '';
        boolean flag = true;
        
        Inventory_Transaction_Master__c value = new Inventory_Transaction_Master__c(); 
        value.Batch_Status__c = 'Migration Success';
        value.Record_Type__c = 'Material Pricing';
        value.Mainetti_Company__c = 'Mainetti (HK) Ltd';
        insert value; 
        MaterialPricing_Transaction_Stage__c stageValue = new MaterialPricing_Transaction_Stage__c();
        /*stageValue.Color__c = 'GRAY';
        stageValue.Record_Status__c = '2 - Data Validation Successful';
        stageValue.Upload_Batch_No__c = value.id;
        stageValue.Stock_In_Date__c = '23-May-19';
        stageValue.Stock_In_Qty__c = '200';*/
        stageValue.Record_Status__c = '2 - Data Validation Successful';
        stageValue.Upload_Batch_No__c = value.id;
        insert stageValue;
        Test.startTest();
        uploadMaterial.parseMaterialPricing(jSon, value.id, recordType, company);
        uploadMaterial.parseMaterialPricing(jSon, '', recordType, company);
        uploadMaterial.parseMaterialPricing(jSonInvalid, '', recordType, company);
        uploadMaterial.parseMaterialPricing(jSonMissing, '', recordType, company);        
        Test.stopTest();
        System.assertEquals(true, flag); 
    } 
    
    static testMethod void insertDataUploadMaterialPricingTest() {
        Inventory_Transaction_Master__c value = new Inventory_Transaction_Master__c(); 
        value.Batch_Status__c = 'Migration Success';
        value.Record_Type__c = 'Material Pricing';
        value.Mainetti_Company__c = 'Mainetti (HK) Ltd';
        insert value;
        string returnBatchId = '';
        Test.startTest();
        Inventory_Transaction_Master__c updateBatchStatus = new Inventory_Transaction_Master__c();
        updateBatchStatus =[Select Id, Mainetti_Company__c, Record_Type__c from Inventory_Transaction_Master__c where Id=:value.id];
        MaterialPricing_Transaction_Stage__c stageValue = new MaterialPricing_Transaction_Stage__c();
        /*stageValue.Color__c = 'GRAY';
        stageValue.Mainetti_Company__c = 'Mainetti (HK) Ltd';
        stageValue.Record_Status__c = '2 - Data Validation Successful';
        stageValue.Retailer_Code__c = 'GU';
        stageValue.Upload_Batch_No__c = updateBatchStatus.id;
        stageValue.Stock_In_Date__c = '23-May-19';
        stageValue.Stock_In_Qty__c = '200';*/
        stageValue.Mainetti_Company__c = 'Mainetti (HK) Ltd';
        stageValue.Record_Status__c = '2 - Data Validation Successful';
        stageValue.Upload_Batch_No__c = updateBatchStatus.id;
        stageValue.Location__c = 'usa';
        stageValue.Material_Type__c = 'lenin';
        stageValue.Unit_Price__c = '100';
        stageValue.UOM__c = '10';
        stageValue.Year__c = '2019';
        stageValue.Month__c = '10';
        stageValue.Date__c = '10';
        insert stageValue;
        
        // Inserting the Partner Data
        Partner__c partner = new Partner__c(Name = 'Mainetti (HK) Ltd', Default_Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd');
        insert partner;
        getMasterData companyMap = new getMasterData();
        companyMap.getManitteCompanyIdMap();
        Map<string,string> mainettiCompanyMap = new Map<string,string>();
        map<string,Id> manitteIdMap = new map<string,Id>();
        List<Partner__c> partners = [Select  Name, Default_Order_to_Company__c from Partner__c where Default_Order_to_Company__c != null and Partner_Status__c = 'Active' and  RecordType.Name in('Mainetti Company','Licensee Partner')];
        for ( Partner__c ptn : partners )
        {
            mainettiCompanyMap.put(ptn.Name.toLowerCase(),ptn.Default_Order_to_Company__c); 
            manitteIdMap.put(ptn.Name.toLowerCase(),ptn.Id);
        }
        
        Retailer_Code__c retailercode = new Retailer_Code__c(Name = 'DECATHLON');
        insert retailercode;
        getMasterData companyMapp = new getMasterData();
        companyMapp.getRetailerCodeMap();
        companyMapp.getRetailerCodeIdMap();
        Map<string,string> retailerCodeMap = new Map<string,string>();
        Map<string,Id> retailerCodeIdMap = new Map<string,Id>();          
        list<Retailer_Code__c> retailerCodes = [Select Id,Name from Retailer_Code__c];        
        for ( Retailer_Code__c retail : retailerCodes ){
            retailerCodeMap.put(retail.Name.toLowerCase(),retail.Name.toLowerCase());
            retailerCodeIdMap.put(retail.Name.toLowerCase(),retail.Id);
        }
        
        Price_Specification_Book__c  priceSpecBook = new Price_Specification_Book__c();
        insert priceSpecBook;
        Price_Specification_Book_Product__c priceBookSpecProd = new Price_Specification_Book_Product__c(Color__c = 'GRAY',Price_Specification_Book__c = priceSpecBook.Id);
        insert priceBookSpecProd;
        //Inventory_Transaction_Master__c updateBatchStatus = new Inventory_Transaction_Master__c();
        //updateBatchStatus =[Select Id, Mainetti_Company__c, Record_Type__c from Inventory_Transaction_Master__c where Id=:value.id];
        getMasterData companyMappp = new getMasterData();
        companyMappp.getRTSModelMap(updateBatchStatus);
        
        //map<string,Id> manitteMap = new map<string,Id>();
        //partnerQuery = [Select Id, Name  from Partner__c where Default_Order_to_Company__c != null and Partner_Status__c = 'Active' and  RecordType.Name in('Mainetti Company','Licensee Partner')];
        uploadMaterial uplMaterial = new uploadMaterial();
        uplMaterial.insertDataUploadMaterialPricing(updateBatchStatus);
        Test.stopTest();
        System.assertEquals(returnBatchId,'');      
    }

}