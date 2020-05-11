public class getSalesMasterData {
    
 /*   public  map<string,string> getRetailerCodeMap()
    {        
        Map<string,string> retailerCodeMap = new Map<string,string>();        
        list<Retailer_Code__c> retailerCode = [Select Name from Retailer_Code__c];        
        for ( Retailer_Code__c retail : retailerCode ){
            retailerCodeMap.put(retail.Name.toLowerCase(),retail.Name.toLowerCase());
        }
        return retailerCodeMap;
    } */
    public  map<string,Id> getRetailerCodeIdMap()
    {
        list<Retailer_Code__c> retailerCode = new list<Retailer_Code__c>();
        Map<string,Id> retailerCodeMap = new Map<string,Id>();        
        retailerCode = [Select Id, Name from Retailer_Code__c];        
        for ( Retailer_Code__c retail : retailerCode ){
            retailerCodeMap.put(retail.Name.toLowerCase(),retail.Id);
        }
        return retailerCodeMap; 
    }
    public  map<string,string> getFamilyMap()
    {
        Map<string,string> familyMap =  getPickListMap('Product__c','Product_Family__c');		
        return familyMap; 
    }
    public  Map<string,string> getPickListMap(String ObjectName,String fieldName){
        Map<string,string> pickListValMap = new Map<string,string>();
        Schema.SObjectType tarType = Schema.getGlobalDescribe().get(ObjectName); 
        Sobject Object_name = tarType.newSObject();                 
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); 
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); 
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();        
        List<Schema.PicklistEntry> pick_list_values = field_map.get(fieldName).getDescribe().getPickListValues();        
        for (Schema.PicklistEntry a : pick_list_values) { 
            String colorPicklist = a.getValue();
            pickListValMap.put(colorPicklist.toLowerCase(),colorPicklist.toLowerCase());
        }        
        return pickListValMap;
    }
    
    
    public List<Sales_Transaction_Stage__c> getSalesStageRows(String BatchId){
        List<Sales_Transaction_Stage__c> salesTransStagRec = new List<Sales_Transaction_Stage__c>();
        if(!String.isBlank(BatchId)){
            salesTransStagRec = [Select Record_Status__c,Label__c,Printed_Logo__c,unit_sold_warning__c,Gross_Sales_USD__c,Gross_Sales_USD_FB__c,Gross_Sales_USD_NF__c,Freight_Charge_USD__c,Freight_Charge_USD_FB__c,Freight_Charge_USD_NF__c,selected_ui_values__c,Row_No__c,Year_FB__c,Week_FB__c,Source_FB__c,Local_Net_Unit_Pirce_100__c,Net_Unit_Price_100__c,Month_FB__c,Local_Net_Unit_Pirce_FB__c,Calculation_Failed__c,ExRate_to_USD_FB__c,Net_Unit_Price_100_FB__c,ExRate_to_EUR_FB__c,wrong_date__c,ExRate_to_USD__c,ErrorMapData__c,validation_failed__c,warning_consolidate_key__c,SO_Number__c,SO_Number_FB__c,SO_Number_NF__c,LOB__c,LOB_FB__c,LOB_NF__c,Company__c,Company_FB__c,Customer__c,Customer_FB__c,Transaction_Currency__c,Transaction_Currency_FB__c,Transaction_Currency_NF__c,Division__c,Division_FB__c,Division_NF__c,Mainetti_Brand__c,Mainetti_Brand_FB__c,Mainetti_Brand_NF__c,Item_code__c,Item_code_FB__c,Item_code_NF__c,Production_Country__c,Production_Country_FB__c,Production_Country_NF__c,Retailer_Brand__c,Retailer_Brand_FB__c,Retailer_Brand_NF__c,Material__c,Material_FB__c,Material_NF__c,Company_NF__c,Model__c,Model_FB__c,Model_NF__c,Market__c,Market_FB__c,Market_NF__c,Vendor__c,Vendor_FB__c,Vendor_NF__c,Category__c,Category_FB__c,Category_NF__c,Sub_Category__c,Sub_Category_FB__c,Sub_Category_NF__c,Order_Type__c,Order_Type_FB__c,Order_Type_NF__c,Shipped_To_Country__c,Shipped_To_Country_FB__c,Shipped_To_Country_NF__c,Shipped_To_Factory__c,Shipped_To_Factory_FB__c,Shipped_To_Factory_NF__c,Color__c,Color_FB__c,Color_NF__c,Country__c,Country_NF__c,Sales_Model__c,SM_NF__c,ExRate_to_EUR__c,ExRate_to_EUR_NF__c,ExRate_to_USD_NF__c,Local_Currency__c,Local_Currency_NF__c,Local_Currency_FB__c,Month__c,Month_NF__c,Remarks__c,Retailer_Code__c,Retailer_Code_NF__c,Sales_Local__c,SL_NF__c,Source__c,Source_NF__c,Unit_Sold__c,US_NF__c,UOM__c,UOM_NF__c,Week__c,Week_NF__c,Year__c,Year_NF__c,Upload_Batch_No__c,Family__c,Family_FB__c,Family_NF__c,Sales_Transaction_Currency__c,STC_FB__c,STC_NF__c,Sales_EUR__c,Sales_EUR_FB__c,Sales_EUR_NF__c,Sales_USD__c,Sales_USD_FB__c,Sales_USD_NF__c,Unit_Price_100_EUR__c,Unit_Price_100_EUR_FB__c,Unit_Price_100_EUR_NF__c,Unit_Price_100_USD__c,Unit_Price_100_USD_FB__c,Unit_Price_100_USD_NF__c from Sales_Transaction_Stage__c where Upload_Batch_No__c=:BatchId];
        }
        return salesTransStagRec; 
    }
   public List<Sales_Transaction_Stage__c> getSalesStageRowsByPage(List<Sales_Transaction_Stage__c> salesTransStagRecAfterReconciliation,String BatchId, string selcomp,string selMonth,string selYear,Map<Decimal,Map<string,string>>inCorrectFormatMap,Map<string,string>colorMap,Map<string,string> marketMap,Map<string,string>lululemonModelMap,Map<string,string>debenhanModelMap,Map<string,string>debenhanModelBrandKeyMap,Map<string,string>debenhanBrandMap,Map<string,string>vendorDivisionBrandLabelMap,Map<string,string>productionCoungtryMap,Map<string,string>modelWarningMap,Map<string,string>modelCompKeyMap,Map<string,string>dateMap,Map<string,string>companyOnlyMap,Map<string,string>vendorMap,Inventory_Transaction_Master__c updateBatchStatus,validateSalesRowsBulk.recordValidationStatus recordStatus,Map<string,Map<string,string>> getNewVendorDivisionBrandLabelMap,Map<string,Retailer_Code__c> getRetailersLabelDivisionBrandCheckMap,Map<string,string> getModelandColorMap,Map<string,string> getSalesDataUploadCheckMap ,Map<string,string> getSalesDataUploadColorCheckMap,Map<string,string> checkColorwithModel ,Map<string,string> getModelCatFamilyMap,Map<string,string> categoryMap,Map<string,string> subcategoryMap,Map<string,string> modelwithCatSubCatFamily ){
        
        return new processSalesData().processSalesDataChunk(salesTransStagRecAfterReconciliation, selcomp, selMonth, selYear,inCorrectFormatMap, colorMap,  marketMap, lululemonModelMap, debenhanModelMap, debenhanModelBrandKeyMap , debenhanBrandMap, vendorDivisionBrandLabelMap, productionCoungtryMap, modelWarningMap, modelCompKeyMap, dateMap, companyOnlyMap,vendorMap,recordStatus,getNewVendorDivisionBrandLabelMap,getRetailersLabelDivisionBrandCheckMap,getModelandColorMap,getSalesDataUploadCheckMap,getSalesDataUploadColorCheckMap,checkColorwithModel,getModelCatFamilyMap,categoryMap,subcategoryMap,modelwithCatSubCatFamily);          
    }  
    public List<Sales_Transaction_Stage__c> preValidationSalesStageDataByPage(List<Sales_Transaction_Stage__c> salesTransStagRecForReconciliation,Map<string,Map<string,Map<string,string>>> fullSalesErrorMap,String BatchId,string selcomp,string selMonth,string selYear,Map<Decimal,Map<string,string>>inCorrectFormatMap,Map<string,string>colorMap,Map<string,string> marketMap,Map<string,string>lululemonModelMap,Map<string,string>debenhanModelMap,Map<string,string>debenhanModelBrandKeyMap,Map<string,string>debenhanBrandMap,Map<string,string>vendorDivisionBrandLabelMap,Map<string,string>productionCoungtryMap,Map<string,string>modelWarningMap,Map<string,string>modelCompKeyMap,Map<string,string>dateMap,Map<string,string>companyOnlyMap,Map<string,string>vendorMap,Inventory_Transaction_Master__c updateBatchStatus,validateSalesRowsBulk.recordValidationStatus recordStatus,Map<string,Map<string,string>> getNewVendorDivisionBrandLabelMap,Map<string,Retailer_Code__c> getRetailersLabelDivisionBrandCheckMap,Map<string,string> getModelandColorMap,Map<string,string> getSalesDataUploadCheckMap ,Map<string,string> getSalesDataUploadColorCheckMap,Map<string,string> checkColorwithModel ,Map<string,string> getModelCatFamilyMap,Map<string,string> categoryMap,Map<string,string> subcategoryMap,Map<string,string> modelwithCatSubCatFamily){
        System.debug('#### preValidationSalesStageDataByPage## recordStatus.validateStatus ###'+recordStatus.validateStatus); 
        List<Sales_Transaction_Stage__c> reconcilseData =  new processSalesData().reconcileDataWithSalesErrorMapBulk(salesTransStagRecForReconciliation,fullSalesErrorMap);
        
        List<Sales_Transaction_Stage__c> finalUpdateData= getSalesStageRowsByPage(reconcilseData, batchid,  selcomp, selMonth, selYear,inCorrectFormatMap,colorMap, marketMap,lululemonModelMap,debenhanModelMap,debenhanModelBrandKeyMap,debenhanBrandMap,vendorDivisionBrandLabelMap,productionCoungtryMap,modelWarningMap,modelCompKeyMap,dateMap,companyOnlyMap,vendorMap, updateBatchStatus, recordStatus,getNewVendorDivisionBrandLabelMap,getRetailersLabelDivisionBrandCheckMap,getModelandColorMap,getSalesDataUploadCheckMap,getSalesDataUploadColorCheckMap,checkColorwithModel,getModelCatFamilyMap,categoryMap,subcategoryMap, modelwithCatSubCatFamily );
       // List<Sales_Transaction_Stage__c> finalUpdateData = new List<Sales_Transaction_Stage__c> ();
        return finalUpdateData;
    }
    public List<Sales_Transaction_Stage__c> preValidationSalesStageData(string batchid){
        List<Sales_Transaction_Stage__c> fetchSuccessdata=[Select unit_sold_warning__c,Gross_Sales_USD__c,Gross_Sales_USD_FB__c,Gross_Sales_USD_NF__c,Freight_Charge_USD__c,Freight_Charge_USD_FB__c,Freight_Charge_USD_NF__c,selected_ui_values__c,Row_No__c,Week_FB__c,Year_FB__c,Source_FB__c,Month_FB__c,Unit_Sold_FB__c,Local_Net_Unit_Pirce_FB__c,Net_Unit_Price_100_FB__c,ExRate_to_USD_FB__c,ExRate_to_EUR_FB__c,Calculation_Failed__c,Remark__c,Label__c,End_user__c,Royalty_Rate__c,Printed_Logo__c,Customer_local_name__c,Net_Unit_Price_100__c,Local_Net_Unit_Pirce_100__c,ExRate_to_USD__c,ErrorMapData__c,validation_failed__c,warning_consolidate_key__c,SO_Number__c,SO_Number_FB__c,SO_Number_NF__c,LOB__c,LOB_FB__c,LOB_NF__c,
                                                           Company__c,Company_FB__c,Customer__c,Customer_FB__c,Transaction_Currency__c,Transaction_Currency_FB__c,Transaction_Currency_NF__c,
                                                           Division__c,Division_FB__c,Division_NF__c,Mainetti_Brand__c,Mainetti_Brand_FB__c,Mainetti_Brand_NF__c,Item_code__c,Item_code_FB__c,Item_code_NF__c,
                                                           Production_Country__c,Production_Country_FB__c,Production_Country_NF__c,Retailer_Brand__c,Retailer_Brand_FB__c,Retailer_Brand_NF__c,
                                                           Material__c,Material_FB__c,Material_NF__c,Company_NF__c,Model__c,Model_FB__c,Model_NF__c,Market__c,Market_FB__c,Market_NF__c,Vendor__c,Vendor_FB__c,Vendor_NF__c,
                                                           Category__c,Category_FB__c,Category_NF__c,Sub_Category__c,Sub_Category_FB__c,Sub_Category_NF__c,Order_Type__c,Order_Type_FB__c,Order_Type_NF__c,
                                                           Shipped_To_Country__c,Shipped_To_Country_FB__c,Shipped_To_Country_NF__c,Shipped_To_Factory__c,Shipped_To_Factory_FB__c,Shipped_To_Factory_NF__c,
                                                           Color__c,Color_FB__c,Color_NF__c,Country__c,Country_NF__c,ExRate_to_EUR__c,ExRate_to_EUR_NF__c,
                                                           ExRate_to_USD_NF__c,Local_Currency__c,Local_Currency_NF__c,Local_Currency_FB__c,Month__c,Month_NF__c,Remarks__c,Retailer_Code__c,Retailer_Code_NF__c,
                                                           Sales_Local__c,SL_NF__c,Source__c,Source_NF__c,Unit_Sold__c,US_NF__c,UOM__c,UOM_NF__c,Week__c,Week_NF__c,Year__c,Year_NF__c,Upload_Batch_No__c,
                                                           Family__c,Family_FB__c,Family_NF__c,Sales_Transaction_Currency__c,STC_FB__c,STC_NF__c,Sales_EUR__c,Sales_EUR_FB__c,Sales_EUR_NF__c,
                                                           Sales_USD__c,Sales_USD_FB__c,Sales_USD_NF__c,Unit_Price_100_EUR__c,Unit_Price_100_EUR_FB__c,Unit_Price_100_EUR_NF__c,wrong_date__c,
                                                           Unit_Price_100_USD__c,Unit_Price_100_USD_FB__c,Unit_Price_100_USD_NF__c from Sales_Transaction_Stage__c where Upload_Batch_No__c=:BatchId]; 
        
        return fetchSuccessdata;
    }
    /* Reterieveing the file from  the contentverion for upload into Azure */ 
    public  ContentVersion getCSVFile(String batchId){
        ContentVersion contVer;
        ContentDocumentLink contentLink = [SELECT ContentDocumentId from ContentDocumentLink where LinkedEntityId=:batchId LIMIT 1];
        if(contentLink != null){
            contVer = [SELECT Title, VersionData, PathOnClient, FileType FROM ContentVersion WHERE ContentDocumentId = :contentLink.ContentDocumentId
                       AND IsLatest = true];            
        }       
        return contVer;        
    }
    /*Deleting the csv file from the content version once the file has been uploaded into Azure*/
    public boolean deleteCSVFile(String batchId){
        boolean delStatus = true;       
        try{
            list<ContentDocument> contentList = new list<ContentDocument>();
            ContentDocument[] content = [Select Id, Title, FileExtension, CreatedDate From ContentDocument USING SCOPE Everything];
            System.debug('###########content SIZE'+content.size()); 
            Date Today = system.Today();
            for ( ContentDocument cont : content ){ 
                Datetime recCreateDt = cont.CreatedDate;
                Date StartDateParsed = date.newinstance(recCreateDt.year(), recCreateDt.month(), recCreateDt.day());                
                if(cont.Title == 'Inventory Data File Uplaod'){
                    System.debug('###########StartDateParsed'+StartDateParsed+'::::Today'+Today); 
                    if(StartDateParsed < Today){ 
                        System.debug('########Inside True'); 
                        contentList.add(cont);
                    }
                }                   
            }
            System.debug('###########content LIST SIZE'+contentList.size());              
            if(contentList.size()>0){
                delete contentList;
            }
        }catch(DMLException ex){
            delStatus = false;
            System.debug('Error during deleteCSVFile'+EX.getMessage());         
        }       
        return delStatus;        
    }    
    
    public  Map<string,Map<string,Map<string,string>>> getFullSalesErrorMap() {        
        
        Map<string,Map<string,Map<string,string>>> salesErrorMap = new Map<string,Map<string,Map<string,string>>>();        
        list<Sales_Error_Mapping__c> mapData = [Select Company__c,Raw_Data_Field__c, Map_From_Value__c, Map_To_Value__c from Sales_Error_Mapping__c order by Company__c]; 
        // system.debug('mapData:'+mapData);
        for ( Sales_Error_Mapping__c mapVal : mapData ){
            if(String.isNotBlank(mapVal.Company__c)){
                if(salesErrorMap.containsKey(mapVal.Company__c)){
                    Map<string,Map<string,string>> rawDataFieldMap = salesErrorMap.get(mapVal.Company__c);
             //       system.debug('rawDataFieldMap:'+rawDataFieldMap);
                    if(rawDataFieldMap.containsKey(mapVal.Raw_Data_Field__c)){                        
                        Map<string,string> mapFromToValueMap = rawDataFieldMap.get(mapVal.Raw_Data_Field__c);
                        String mapFromValue = mapVal.Map_From_Value__c;
                        mapFromToValueMap.put(mapFromValue.toLowerCase(),mapVal.Map_To_Value__c);
                        rawDataFieldMap.put(mapVal.Raw_Data_Field__c,mapFromToValueMap);
                        salesErrorMap.put(mapVal.Company__c,rawDataFieldMap);
                    }else{                            
                        Map<string,string> mapFromToValueMap = new Map<string,string>();
                        String mapFromValue = mapVal.Map_From_Value__c;
                        mapFromToValueMap.put(mapFromValue.toLowerCase(),mapVal.Map_To_Value__c);
                        rawDataFieldMap.put(mapVal.Raw_Data_Field__c,mapFromToValueMap);
                        salesErrorMap.put(mapVal.Company__c,rawDataFieldMap);
                    }                        
                }else{ 
                    Map<string,Map<string,string>> rawDataFieldMap = new Map<string,Map<string,string>>();
                    Map<string,string> mapFromToValueMap = new Map<string,string>();  
                    String mapFromValue = mapVal.Map_From_Value__c; 
                    mapFromToValueMap.put(mapFromValue.toLowerCase(),mapVal.Map_To_Value__c);
                    rawDataFieldMap.put(mapVal.Raw_Data_Field__c,mapFromToValueMap);
                    salesErrorMap.put(mapVal.Company__c,rawDataFieldMap);
                }
            }      
        }    
        return salesErrorMap;
    } 
    
    
    public   List<string> partnerCompany()
    {
        list<Partner__c> partner = new list<Partner__c>();
        List<string> partnerCompanyList = new List<string>();        
        partner = [Select  Name, Default_Order_to_Company__c from Partner__c where Name ='Others' and Default_Order_to_Company__c != null and Partner_Status__c = 'Active' and  RecordType.Name in('Mainetti Company','Licensee Partner') order by Name]; 
        for ( Partner__c ptn : partner ){
            partnerCompanyList.add(ptn.Name);            
        }             
        return partnerCompanyList;
    }
    
    
    /* public  Map<string,string> getPickListColorMap(){
        Map<string,string> pickListValMap = new Map<string,string>();
        list<Price_Specification_Book_Product__c> priceBookSpecProd = new list<Price_Specification_Book_Product__c>();       
        priceBookSpecProd = [Select Color__c from Price_Specification_Book_Product__c];
        if(priceBookSpecProd.size() > 0)
        {
            for (Price_Specification_Book_Product__c priceBook : priceBookSpecProd) {
                if(String.isNotBlank(priceBook.Color__c)){
                    pickListValMap.put(priceBook.Color__c.toLowerCase(),priceBook.Color__c.toLowerCase());     
                }  
            }
        }         
        return pickListValMap;
    } */
    
    public   map<string,string> getModelConsolidateMap()
    {
        list<Product__c> model = new list<Product__c>();
        Map<string,string> modelConsolidateMap = new Map<string,string>();        
        model = [Select Consolidated_Style__c from Product__c where Consolidated_Style__c <> null]; 
        for ( Product__c mod : model ){ 
            modelConsolidateMap.put(mod.Consolidated_Style__c.toLowerCase(),mod.Consolidated_Style__c.toLowerCase());            
        }             
        return modelConsolidateMap;
    }
    
    // Category
    public   map<string,string> getCategoryBusinessVerticalMap()
    {
        list<Product__c> category = new list<Product__c>();
        Map<string,string> categoryBusinessVerticalMap = new Map<string,string>();        
        category = [Select Business_Vertical__c from Product__c where Business_Vertical__c <> null]; 
        for ( Product__c cat : category ){
            categoryBusinessVerticalMap.put(cat.Business_Vertical__c.toLowerCase(),cat.Business_Vertical__c.toLowerCase());            
        }             
        return categoryBusinessVerticalMap;
    }
    // Model,category,sub-category and family composite key.
    public  Map<string,string> getModelCatFamilyMap(){
        
        Map<string,string> modelCompositeKeyMap = new Map<string,string>();
        list<Product__c> prodModel = new list<Product__c>();
        prodModel = [Select Consolidated_Style__c,Business_Vertical__c,Product_Type__c ,Product_Family__c from Product__c where Consolidated_Style__c <> null and Business_Vertical__c <> null and Product_Type__c  <> null and Product_Family__c <> null];        
        for (Product__c prdMod : prodModel){
            string productModel = prdMod.Consolidated_Style__c;
            string productCatSubFam =  prdMod.Business_Vertical__c+'#'+prdMod.Product_Type__c +'#'+prdMod.Product_Family__c;  
            modelCompositeKeyMap.put(productModel,productCatSubFam);  
           // SYSTEM.DEBUG('modelCompositeKeyMap::'+modelCompositeKeyMap);
        }
        return modelCompositeKeyMap;
    }    
    // model map.
    // 
 /*   public  Map<string,string> getSalesModelMap(Inventory_Transaction_Master__c updateBatchStatus){
        
        Map<string,string> slsModelMap = new Map<string,string>();
        // System.Debug('########Inside Before Query getSalesModelMap');
        
        list<Product__c> prodModel = [Select Consolidated_Style__c from Product__c where Consolidated_Style__c != null]; 
        prodModel = [Select Consolidated_Style__c,Business_Vertical__c,Product_Type__c,Product_Family__c from Product__c where Consolidated_Style__c <> null and Business_Vertical__c <> null and Product_Type__c <> null and Product_Family__c <> null];        
        System.Debug('########Inside After Query getSalesModelMap');
        for (Product__c prdMod : prodModel){  
            if(!slsModelMap.containsKey(prdMod.Consolidated_Style__c.toLowerCase())){
                slsModelMap.put(prdMod.Consolidated_Style__c.toLowerCase(),prdMod.Consolidated_Style__c.toLowerCase()); 
            }
        }  
        // system.debug('SalesModalMap:::'+slsModelMap.size());
        return slsModelMap;
    } */
    /*public   map<string,string> getMarketMap()
{
list<Retailer_Code__c> market = new list<Retailer_Code__c>();
Map<string,string> marketMap = new Map<string,string>();        
market = [Select Sales_Data_Upload_Market__c from Retailer_Code__c where Sales_Data_Market__c <> null]; 
for ( Retailer_Code__c mrk : market ){
marketMap.put(mrk.Sales_Data_Upload_Market__c.toLowerCase(),mrk.Sales_Data_Upload_Market__c.toLowerCase());            
}             
return marketMap;
}*/
    
   /* public  Map<string,string> getMarketMap(){
        Map<string,string> marketMap = new Map<string,string>();
        list<Retailer_Code__c> priceBookSpecProd = new list<Retailer_Code__c>();       
        priceBookSpecProd = [Select Sales_Data_Upload_Market__c from Retailer_Code__c];
        if(priceBookSpecProd.size() > 0)
        {
            for (Retailer_Code__c priceBook : priceBookSpecProd) {
                if(String.isNotBlank(priceBook.Sales_Data_Upload_Market__c)){
                    marketMap.put(priceBook.Sales_Data_Upload_Market__c.toLowerCase(),priceBook.Sales_Data_Upload_Market__c.toLowerCase());     
                }  
            }
        }         
        return marketMap;
    } */
    
    public Map<string,Map<string,string>> getProductDetails(){
        Map<string,Map<string,string>> compositeProductMap = new Map<string,Map<string,string>>();
        Map<string,string> slsModelMap = new Map<string,string>();    
        Map<string,string> categoryBusinessVerticalMap = new Map<string,string>(); 
        Map<string,string> subCategoryMap = new Map<string,string>(); 
        Map<string,string> modelCompositeKeyMap = new Map<string,string>();
        list<Product__c> prodModel = [Select Consolidated_Style__c,Business_Vertical__c,Product_Type__c,Product_Family__c,Sub_category__c from Product__c where Consolidated_Style__c <> null and Business_Vertical__c <> null and Product_Type__c <> null and Product_Family__c <> null and Sub_category__c <> null];        
        
        for (Product__c prdMod : prodModel){  
            if(prdMod.Consolidated_Style__c != null){
               // if(!slsModelMap.containsKey(prdMod.Consolidated_Style__c.toLowerCase())){
                    slsModelMap.put(prdMod.Consolidated_Style__c.toLowerCase(),prdMod.Consolidated_Style__c.toLowerCase()); 
              //  }
            }
            //String Category = prdMod.Business_Vertical__c;
            // if(String.isNotBlank(prdMod.Business_Vertical__c)){
                //    if(prdMod.Business_Vertical__c != null && prdMod.Product_Type__c !=null && prdMod.Product_Family__c != null && prdMod.Sub_category__c!= null){
                        //if(prdMod.Business_Vertical__c !=('Flexible Packaging') || prdMod.Business_Vertical__c !=('LABELS & TICKETS') ||prdMod.Business_Vertical__c !=('TLA') || prdMod.Business_Vertical__c !=('EAS & RFID')|| prdMod.Business_Vertical__c !=('E-COMMERCE')|| prdMod.Business_Vertical__c !=('M-care'))
                        //{
                          String prodBusinessVertical = prdMod.Business_Vertical__c;
           				 if(prodBusinessVertical.equalsIgnoreCase('Hanger Business')){
                            string productModel = prdMod.Consolidated_Style__c;
                            string productCatSubFam =  prdMod.Business_Vertical__c+'#'+prdMod.Product_Type__c+'#'+prdMod.Sub_category__c+'#'+prdMod.Product_Family__c;  
                            modelCompositeKeyMap.put(productModel.trim().toLowerCase(),productCatSubFam.trim());                              
                            
                        }
                  //  }
         //   }
            
            
            if(prdMod.Business_Vertical__c != null){
                categoryBusinessVerticalMap.put(prdMod.Business_Vertical__c.toLowerCase(),prdMod.Business_Vertical__c.toLowerCase());         
            }
            
            if(prdMod.Product_Type__c != null){
                subCategoryMap.put(prdMod.Product_Type__c.toLowerCase(),prdMod.Product_Type__c.toLowerCase());         
            }
            
        }  
        compositeProductMap.put('SalesModel', slsModelMap);
        compositeProductMap.put('ModelCompositeKey', modelCompositeKeyMap);
        compositeProductMap.put('CategoryBusinessVertical', categoryBusinessVerticalMap);
        compositeProductMap.put('SubCategoryMap', subCategoryMap);
        return compositeProductMap;
    }
    
    // production country,retailer code map.
   /* public  Map<string,string> getProductionCountryMap(){
        
        Map<string,string> productionCountMap = new Map<string,string>();
        list<Retailer_Code__c> productionCount = new list<Retailer_Code__c>();
        productionCount = [Select Name,Production_Country__c from Retailer_Code__c where Name <> null];       
        for (Retailer_Code__c prdCount : productionCount){  
            productionCountMap.put(prdCount.Name.toLowerCase(),String.valueOf(prdCount.Production_Country__c));              
        }  
        return productionCountMap;
    }*/
    
    // Lululemon model map.
    public  Map<string,string> getlululemonModelMap(){
        
        Map<string,string> lululemonRetailerMap = new Map<string,string>();
        list<Price_Specification_Book_Product__c> lululemonRetailer = new list<Price_Specification_Book_Product__c>();
        lululemonRetailer = [Select Name,Retailer_Code__r.Name from Price_Specification_Book_Product__c  where Retailer_Code__r.Name='LULULEMON' and Name <> null];       
        for (Price_Specification_Book_Product__c lululemonRet : lululemonRetailer){  
            lululemonRetailerMap.put(lululemonRet.Name.toLowerCase(),lululemonRet.Name.toLowerCase());              
        }  
        return lululemonRetailerMap;
    }
    
    // Debenham model map.
    public  Map<string,string> getDebenhamModelMap(){
        
        Map<string,string> debenhamRetailerMap = new Map<string,string>();
        list<Price_Specification_Book_Product__c> debenhamRetailer = new list<Price_Specification_Book_Product__c>();
        debenhamRetailer = [Select Name,Retailer_Code__r.Name from Price_Specification_Book_Product__c  where Retailer_Code__r.Name='DEBENHAMS' and Name <> null];       
        for (Price_Specification_Book_Product__c debRet : debenhamRetailer){  
            debenhamRetailerMap.put(debRet.Name.toLowerCase(),debRet.Name.toLowerCase());              
        }  
        return debenhamRetailerMap;
    }
    // Debenham brand map.
    public  Map<string,string> getDebenhamBrandMap(){
        
        Map<string,string> debenhamBrandMap = new Map<string,string>();
        list<Price_Specification_Book_Product__c> debenhamBrand = new list<Price_Specification_Book_Product__c>();
        debenhamBrand = [Select Retailer_Brand__c from Price_Specification_Book_Product__c  where Retailer_Code__r.Name='DEBENHAMS' and Retailer_Brand__c <> null];       
        for (Price_Specification_Book_Product__c debBrnd : debenhamBrand){  
            debenhamBrandMap.put(debBrnd.Retailer_Brand__c.toLowerCase(),debBrnd.Retailer_Brand__c.toLowerCase());              
        }  
        return debenhamBrandMap;
    }
    
    // Debenham model and Brand CompositeKey map.
    public  Map<string,string> getDebenhamModelBrandKeyMap(){
        
        Map<string,string> debenhamRetailerMap = new Map<string,string>();
        list<Price_Specification_Book_Product__c> debenhamRetailer = new list<Price_Specification_Book_Product__c>();
        debenhamRetailer = [Select Name,Retailer_Brand__c from Price_Specification_Book_Product__c  where Retailer_Code__r.Name='DEBENHAMS' and Retailer_Brand__c <> null];       
        for (Price_Specification_Book_Product__c debRet : debenhamRetailer){  
            string modelBrandKey =  debRet.Name+'#'+debRet.Retailer_Brand__c;  
            debenhamRetailerMap.put(modelBrandKey.toLowerCase(),modelBrandKey.toLowerCase());              
        }  
        return debenhamRetailerMap;
    }
    // Model & Color Combintion Check Box
    /* public  Map<string,string> getModelandColorMap(){
        
        Map<string,string> ModelandColorMap = new Map<string,string>();
        list<Price_Specification_Book_Product__c> modalColor = new list<Price_Specification_Book_Product__c>();
        modalColor = [Select Retailer_Code__r.Name,Consolidated_Style__c,Color__c from Price_Specification_Book_Product__c where Retailer_Code__r.Name <> null];       
        for (Price_Specification_Book_Product__c modCol : modalColor){  
            string cmpKey =  modCol.Consolidated_Style__c+'#'+modCol.Color__c;  
            ModelandColorMap.put(cmpKey,cmpKey);              
        }  
        return ModelandColorMap;
    } */
    
    // Check the Color for the Model
   /* public  Map<string,string> checkColorwithModel(){
        
        Map<string,string> colorModelMap = new Map<string,string>();
        list<Price_Specification_Book_Product__c> colorModel = new list<Price_Specification_Book_Product__c>();
        colorModel = [Select Retailer_Code__r.Name,Consolidated_Style__c,Color__c from Price_Specification_Book_Product__c where Retailer_Code__r.Name <> null];       
        for (Price_Specification_Book_Product__c colMod : colorModel){     
            colorModelMap.put(colMod.Consolidated_Style__c,colMod.Color__c); 
            system.debug('colorModel:::'+colorModel);
        }  
        return colorModelMap;
    } */
    
    // Vendor, Division, Brand, Label CompositeKey map with Label_Division__c Object.
    public  Map<string,Map<string,string>> getNewVendorDivisionBrandLabelMap(){
        
        Map<string,Map<string,string>> VendorDivisionBrandLabelMap = new Map<string,Map<string,string>>();
        //Map<string,Map<string,List<string>>> VendorDivisionBrandLabelMap = new Map<string,Map<string,List<string>>>();
        list<Label_Division__c> venDivBrndLabel =  [Select Retailer_Code_Name__c, Division__c, Retailer_Brand__c, Label__c from Label_Division__c where Retailer_Code_Name__c <> null];       
        for (Label_Division__c venDivBrandLab : venDivBrndLabel){  
            String vendorName = venDivBrandLab.Retailer_Code_Name__c;
          //   System.debug('vendorName:::'+vendorName);
             // System.debug('VendorDivisionBrandLabelMap:::'+VendorDivisionBrandLabelMap);
            if(VendorDivisionBrandLabelMap.containsKey(vendorName)){
                Map<string,string> labelDivBrand = VendorDivisionBrandLabelMap.get(vendorName);
                
                String lable = venDivBrandLab.Label__c;
                String brand = venDivBrandLab.Retailer_Brand__c;
                String division = venDivBrandLab.Division__c;
                
                String labelBrand = lable+'#'+brand;
                String lableDivision = lable+'#'+division;
                String divisionBrand = division+'#'+brand;
                
                if(!labelDivBrand.containsKey(lableDivision)){
                    labelDivBrand.put(lableDivision, lableDivision);
                }
                if(!labelDivBrand.containsKey(labelBrand)){
                    labelDivBrand.put(labelBrand,labelBrand);
                }
                if(!labelDivBrand.containsKey(divisionBrand)){
                    labelDivBrand.put(divisionBrand,divisionBrand);
                }
                if(!labelDivBrand.containsKey(lable)){
                    labelDivBrand.put(lable,lable);
                }
                if(!labelDivBrand.containsKey(brand)){
                    labelDivBrand.put(brand,brand);
                }
                if(!labelDivBrand.containsKey(division)){
                    labelDivBrand.put(division,division);
                }
                
                VendorDivisionBrandLabelMap.put(vendorName,labelDivBrand);
            }else{
                
                Map<string,string> 	labelDivBrandMap = new Map<string,string>();         
                String lable = venDivBrandLab.Label__c;
                String brand = venDivBrandLab.Retailer_Brand__c;
                String division = venDivBrandLab.Division__c;
                
                String labelBrand = lable+'#'+brand;
                String lableDivision = lable+'#'+division;
                String divisionBrand = division+'#'+brand;
                
                labelDivBrandMap.put(lableDivision, lableDivision);
                labelDivBrandMap.put(labelBrand,labelBrand);
                labelDivBrandMap.put(divisionBrand,divisionBrand);
                labelDivBrandMap.put(lable,lable);
                labelDivBrandMap.put(brand,brand);
                labelDivBrandMap.put(division,division);
                
                
                VendorDivisionBrandLabelMap.put(vendorName,labelDivBrandMap);
            }
            
        }  
        return VendorDivisionBrandLabelMap;
    } 
    
    // Vendor, Division, Brand, Label CompositeKey map with Label_Division__c Object.
    public  Map<string,string> getVendorDivisionBrandLabelMap(){
        
        Map<string,string> VendorDivisionBrandLabelMap = new Map<string,string>();
        list<Label_Division__c> venDivBrndLabel = new list<Label_Division__c>();
        venDivBrndLabel = [Select Retailer_Code_Name__c, Division__c, Retailer_Brand__c, Label__c from Label_Division__c where Retailer_Code_Name__c <> null and Division__c <> null and Retailer_Brand__c <> null and Label__c <> null];       
        for (Label_Division__c venDiv : venDivBrndLabel){  
            string cmpKey =  venDiv.Retailer_Code_Name__c+'#'+venDiv.Division__c+'#'+venDiv.Retailer_Brand__c+'#'+venDiv.Label__c;  
            VendorDivisionBrandLabelMap.put(cmpKey.toLowerCase(),cmpKey.toLowerCase());   
            // System.debug('VendorDivisionBrandLabelMap:'+VendorDivisionBrandLabelMap);
        }  
        return VendorDivisionBrandLabelMap;
    } 
    
    public  Map<string,Retailer_Code__c> getRetailersLabelDivisionBrandCheckMap(){
        
        Map<string,Retailer_Code__c> retailersLabelDivisionBrandCheckMap = new Map<string,Retailer_Code__c>();
        list<Retailer_Code__c> salesDataUpload = [Select Name,Division_check__c,Label_Check__c,Retailer_Brand_Check__c from Retailer_Code__c where Name <> null ];       
        for (Retailer_Code__c salesData : salesDataUpload){             
            retailersLabelDivisionBrandCheckMap.put(salesData.Name,salesData);
            // system.debug('retailersLabelDivisionBrandCheckMap:::'+retailersLabelDivisionBrandCheckMap);
        }  
        return retailersLabelDivisionBrandCheckMap;
    }
    
    // Sales Data Upload Check,retailer code map.
  /*  public  Map<string,string> getSalesDataUploadCheckMap(){
        
        Map<string,string> salesDataUploadCheck = new Map<string,string>();
        list<Retailer_Code__c> salesDataUpload = new list<Retailer_Code__c>();
        salesDataUpload = [Select Name,Sales_Data_Upload_Check__c from Retailer_Code__c where Name <> null];       
        for (Retailer_Code__c salesData : salesDataUpload){  
            salesDataUploadCheck.put(salesData.Name.toLowerCase(),String.valueOf(salesData.Sales_Data_Upload_Check__c));              
        }  
        return salesDataUploadCheck;
    } */
    
    // Sales Data Upload Color Check,retailer code map.
  /*  public  Map<string,string> getSalesDataUploadColorCheckMap(){
        
        Map<string,string> salesDataUploadColorCheck = new Map<string,string>();
        list<Retailer_Code__c> salesDataUploadColor = new list<Retailer_Code__c>();
        salesDataUploadColor = [Select Name,Sales_Data_Upload_Color__c from Retailer_Code__c where Name <> null];       
        for (Retailer_Code__c salesData : salesDataUploadColor){  
            salesDataUploadColorCheck.put(salesData.Name.toLowerCase(),String.valueOf(salesData.Sales_Data_Upload_Color__c));              
        }  
        return salesDataUploadColorCheck;
    } */
    
     public Map<string,Map<string,string>> getRetailerDetails(){
        Map<string,Map<string,string>> compositeRetailerMap = new Map<string,Map<string,string>>();
        Map<string,string> getSalesDataUploadCheckMap = new Map<string,string>();
        Map<string,string> getSalesDataUploadColorCheckMap = new Map<string,string>();
        Map<string,string> retailerCodeMap = new Map<string,string>();
		Map<string,string> getProductionCountryMap = new Map<string,string>();
		Map<string,string> marketMap = new Map<string,string>();
        
        list<Retailer_Code__c> retailerCode = [Select Name,Sales_Data_Upload_Check__c,Sales_Data_Upload_Color__c,Production_Country__c,Sales_Data_Upload_Market__c from Retailer_Code__c where Name <> null];
        for (Retailer_Code__c retailer : retailerCode){
            
            // Checking the Vendor
			if( retailer.Name != null )
            {
                string retailerName = retailer.Name;
                retailerCodeMap.put(retailerName.toLowerCase(),retailerName.toLowerCase());
            }   
	          
            // Checking the SalesDataUploadCheckBox
            if( retailer.Name != null && retailer.Sales_Data_Upload_Check__c != null  )
            {
                string retailerName = retailer.Name;
                string salesDataUploadCheckBox = String.valueOf(retailer.Sales_Data_Upload_Check__c);
                getSalesDataUploadCheckMap.put(retailerName.toLowerCase(),salesDataUploadCheckBox);
            }
			// Checking the Production Country
			if( retailer.Name != null && retailer.Production_Country__c != null  )
            {
                string retailerName = retailer.Name;
                string productionCountryCheckBox = String.valueOf(retailer.Production_Country__c);
                getProductionCountryMap.put(retailerName.toLowerCase(),productionCountryCheckBox);
            }
			// Checking the SalesDataUploadMarket
			if(retailerCode.size() > 0){
			if( retailer.Sales_Data_Upload_Market__c != null)
            {
                string retailerMarket = retailer.Sales_Data_Upload_Market__c;                
                marketMap.put(retailerMarket.toLowerCase(),retailerMarket.toLowerCase());
            }
			}
			// Checking the SalesDataUploadColorCheckBox
            if( retailer.Name != null && retailer.Sales_Data_Upload_Color__c != null  )
            {
                string retailerName = retailer.Name;
                string salesDataUploadColorCheckBox = String.valueOf(retailer.Sales_Data_Upload_Color__c);
                getSalesDataUploadColorCheckMap.put(retailerName.toLowerCase(),salesDataUploadColorCheckBox);
            }
            
        }
		compositeRetailerMap.put('RetailerCodeMap', retailerCodeMap);
        compositeRetailerMap.put('GetSalesDataUploadCheckMap', getSalesDataUploadCheckMap);
        compositeRetailerMap.put('GetSalesDataUploadColorCheckMap', getSalesDataUploadColorCheckMap);
		compositeRetailerMap.put('GetProductionCountryMap', getProductionCountryMap);
		compositeRetailerMap.put('MarketMap', marketMap);
        return compositeRetailerMap;
    }
    
    public Map<string,Map<string,string>> getPriceSpecificationBookDetails(){
        Map<string,Map<string,string>> compositePriceSpecificationBookMap = new Map<string,Map<string,string>>();
        Map<string,string> getPickListColorMap = new Map<string,string>();
        Map<string,string> getModelandColorMap = new Map<string,string>();
        Map<string,string> checkPriceBookModel = new Map<string,string>();
        Map<string,string> modelwithCatSubCatFamily = new Map<string,string>();        
        
        list<Price_Specification_Book_Product__c> psbp = [Select Retailer_Code__r.Name,Consolidated_Style__c,Color__c,Product_Family__c,Product_Sub_Category__c,Business_Vertical__c,ProductCategory__c from Price_Specification_Book_Product__c where Retailer_Code__r.Name <> null and Business_Vertical__c <> null and Product_Sub_Category__c <> null and Product_Family__c <> null and ProductCategory__c <> null ];
         System.debug('psbp:::: size'+psbp.size());
        for (Price_Specification_Book_Product__c priceSpecificationBook : psbp){		
            
            // Checking the Color
            
            if( priceSpecificationBook.Color__c != null)
            {
                string color = priceSpecificationBook.Color__c;                
                getPickListColorMap.put(color.toLowerCase(),color.toLowerCase());
            }         
            
            // Checking the Model
            if( priceSpecificationBook.Consolidated_Style__c != null  )
            {
                // string modelColor =  priceSpecificationBook.Consolidated_Style__c+'#'+priceSpecificationBook.Color__c;
                if(!checkPriceBookModel.containsKey(priceSpecificationBook.Consolidated_Style__c)){
                    checkPriceBookModel.put(priceSpecificationBook.Consolidated_Style__c,priceSpecificationBook.Consolidated_Style__c);
                }
            }            
            // Checking the Model & Color
            if( priceSpecificationBook.Consolidated_Style__c != null && priceSpecificationBook.Color__c != null )
            {
                string modelColor =  priceSpecificationBook.Consolidated_Style__c+'#'+priceSpecificationBook.Color__c;
                getModelandColorMap.put(modelColor,modelColor);
            }
            //String Category = prdMod.Business_Vertical__c;
            if(priceSpecificationBook.Business_Vertical__c != null && priceSpecificationBook.Product_Sub_Category__c !=null && priceSpecificationBook.Product_Family__c != null){
                //if(priceSpecificationBook.Business_Vertical__c !=('Flexible Packaging') || priceSpecificationBook.Business_Vertical__c !=('LABELS & TICKETS') ||priceSpecificationBook.Business_Vertical__c !=('TLA') || priceSpecificationBook.Business_Vertical__c !=('EAS & RFID')|| priceSpecificationBook.Business_Vertical__c !=('E-COMMERCE')|| priceSpecificationBook.Business_Vertical__c !=('M-care') )
                //{
                    string productModel = priceSpecificationBook.Consolidated_Style__c;
                    string productCatSubFam =  priceSpecificationBook.Business_Vertical__c+'#'+priceSpecificationBook.ProductCategory__c+'#'+priceSpecificationBook.Product_Sub_Category__c+'#'+priceSpecificationBook.Product_Family__c;  
                   	modelwithCatSubCatFamily.put(productModel.trim().toLowerCase(),productCatSubFam.trim());                     
                //}
            }            
            
        }
        System.debug('################checkPriceBookModel:::'+checkPriceBookModel);
    	System.debug('################ModelwithCatSubCatFamily:::'+ModelwithCatSubCatFamily);
        compositePriceSpecificationBookMap.put('GetPickListColorMap', getPickListColorMap);
        compositePriceSpecificationBookMap.put('GetModelandColorMap', getModelandColorMap);
        compositePriceSpecificationBookMap.put('CheckColorwithModel', checkPriceBookModel);
        compositePriceSpecificationBookMap.put('ModelwithCatSubCatFamily', modelwithCatSubCatFamily);
        return compositePriceSpecificationBookMap;
    }
}