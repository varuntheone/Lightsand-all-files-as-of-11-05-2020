global class validateSalesRowsBulk implements Database.Batchable<sObject>, Database.Stateful {
    
    String query = 'SELECT unit_sold_warning__c,Gross_Sales_USD__c,Gross_Sales_USD_FB__c,Gross_Sales_USD_NF__c,Freight_Charge_USD__c,Freight_Charge_USD_FB__c,Freight_Charge_USD_NF__c,selected_ui_values__c,Row_No__c,Week_FB__c,Year_FB__c,Source_FB__c,Month_FB__c,Unit_Sold_FB__c,Local_Net_Unit_Pirce_FB__c,Net_Unit_Price_100_FB__c,ExRate_to_USD_FB__c,ExRate_to_EUR_FB__c,Calculation_Failed__c,Remark__c,Label__c,End_user__c,Royalty_Rate__c,Printed_Logo__c,Customer_local_name__c,Net_Unit_Price_100__c,Local_Net_Unit_Pirce_100__c,ExRate_to_USD__c,ErrorMapData__c,validation_failed__c,warning_consolidate_key__c,SO_Number__c,SO_Number_FB__c,SO_Number_NF__c,LOB__c,LOB_FB__c,LOB_NF__c, Company__c,Company_FB__c,Customer__c,Customer_FB__c,Transaction_Currency__c,Transaction_Currency_FB__c,Transaction_Currency_NF__c, Division__c,Division_FB__c,Division_NF__c,Mainetti_Brand__c,Mainetti_Brand_FB__c,Mainetti_Brand_NF__c,Item_code__c,Item_code_FB__c,Item_code_NF__c,Production_Country__c,Production_Country_FB__c,Production_Country_NF__c,Retailer_Brand__c,Retailer_Brand_FB__c,Retailer_Brand_NF__c, Material__c,Material_FB__c,Material_NF__c,Company_NF__c,Model__c,Model_FB__c,Model_NF__c,Market__c,Market_FB__c,Market_NF__c,Vendor__c,Vendor_FB__c,Vendor_NF__c, Category__c,Category_FB__c,Category_NF__c,Sub_Category__c,Sub_Category_FB__c,Sub_Category_NF__c,Order_Type__c,Order_Type_FB__c,Order_Type_NF__c, Shipped_To_Country__c,Shipped_To_Country_FB__c,Shipped_To_Country_NF__c,Shipped_To_Factory__c,Shipped_To_Factory_FB__c,Shipped_To_Factory_NF__c, Color__c,Color_FB__c,Color_NF__c,Country__c,Country_NF__c,ExRate_to_EUR__c,ExRate_to_EUR_NF__c, ExRate_to_USD_NF__c,Local_Currency__c,Local_Currency_NF__c,Local_Currency_FB__c,Month__c,Month_NF__c,Remarks__c,Retailer_Code__c,Retailer_Code_NF__c, Sales_Local__c,SL_NF__c,Source__c,Source_NF__c,Unit_Sold__c,US_NF__c,UOM__c,UOM_NF__c,Week__c,Week_NF__c,Year__c,Year_NF__c,Upload_Batch_No__c,  Family__c,Family_FB__c,Family_NF__c,Sales_Transaction_Currency__c,STC_FB__c,STC_NF__c,Sales_EUR__c,Sales_EUR_FB__c,Sales_EUR_NF__c,  Sales_USD__c,Sales_USD_FB__c,Sales_USD_NF__c,Unit_Price_100_EUR__c,Unit_Price_100_EUR_FB__c,Unit_Price_100_EUR_NF__c,wrong_date__c,  Unit_Price_100_USD__c,Unit_Price_100_USD_FB__c,Unit_Price_100_USD_NF__c,Label_FB__c,Retailer_Check__c,Model_Check__c FROM Sales_Transaction_Stage__c WHERE Upload_Batch_No__c=:batchId ';
    private String selMonth;
    private String selYear;
    private String selcomp;
    private String email;
    private String batchId;
    
    private String userEmail;  
    private String returnBatchId;
    private List<Sales_Transaction_Stage__c> salesTransStageForCSV;
    public validateSalesRowsBulk(String batchId,String selMonth,String selYear,String selcomp,String userEmail) {
        this.batchId = batchId;
        this.selMonth = selMonth;
        this.selYear = selYear;
        this.selcomp = selcomp;
        //this.userEmail = userEmail;
        this.userEmail = 'saimanideepyadav@gmail.com';
    }    
    global class  recordValidationStatus{
        public Boolean validateStatus { get; set; }
        public Boolean updateCheckbox { get; set; }        
    }    
    global Database.querylocator start(Database.BatchableContext BC){        
        System.debug('::::::::::::::: INSIDE THE START METHOD OF SALES UPLOAD BATCH PROCESSING :::::::::::::::::::::');
        Inventory_Transaction_Master__c  updateBatchStatus = new Inventory_Transaction_Master__c();
        updateBatchStatus.Id = batchId;
        updateBatchStatus.Batch_Process__c='In Progress';
        update updateBatchStatus;
        return Database.getQueryLocator(query);            
    }
    
    global void execute(Database.BatchableContext BC, List<Sales_Transaction_Stage__c> salesTransStagRecForReconciliation){
        System.debug('::::::::::::::: INSIDE THE EXECUTE METHOD OF SALES UPLOAD BATCH PROCESSING :::::::::::::::::::::');
        recordValidationStatus recordStatus =  new recordValidationStatus();
        recordStatus.validateStatus = true;
        recordStatus.updateCheckbox= false;
        boolean validateStatus;
        boolean updateCheckbox;
        salesTransStageForCSV = salesTransStagRecForReconciliation;
        
        System.debug('::::::::::::::: INSIDE THE EXECUTE METHOD OF SALES UPLOAD salesTransStageForCSV size'+salesTransStageForCSV.size());
         
        getSalesMasterData salesMasterData = new getSalesMasterData();
        Map<Decimal,string> missingFieldValMap = new Map<Decimal,string>();   
        Map<Decimal,Map<string,string>> inCorrectFormatMap = new Map<Decimal,Map<string,string>>();       
        //**************************Getting the Sales Data for the Reconciliation with Error Map before the Validation ******************/
        // Getting the full error data details for reconciliation from the Error Map Object
        // -----------------------------------------------------------------------------------------------------
        Map<string,Map<string,Map<string,string>>> fullSalesErrorMap = salesMasterData.getFullSalesErrorMap();
        Map<string,Map<string,string>> compositeProductMap = salesMasterData.getProductDetails();
        Map<string,string> modelWarningMap = compositeProductMap.get('SalesModel');
        Map<string,string> modelConsolidateMap = compositeProductMap.get('SalesModel');
        Map<string,string> categoryMap = compositeProductMap.get('CategoryBusinessVertical');
        Map<string,string> subcategoryMap = compositeProductMap.get('SubCategoryMap');
        Map<string,string> modelCompKeyMap = compositeProductMap.get('ModelCompositeKey');
        Map<string,Map<string,string>> compositeRetailerMap = salesMasterData.getRetailerDetails();
        Map<string,string> marketMap = compositeRetailerMap.get('MarketMap');
        Map<string,string> vendorMap = compositeRetailerMap.get('RetailerCodeMap');
        Map<string,string> productionCoungtryMap = compositeRetailerMap.get('GetProductionCountryMap');
         Map<string,string> getSalesDataUploadCheckMap = compositeRetailerMap.get('GetSalesDataUploadCheckMap');
        Map<string,string> getSalesDataUploadColorCheckMap = compositeRetailerMap.get('GetSalesDataUploadColorCheckMap');
        Map<string,Map<string,string>> compositePriceSpecificationBookMap = salesMasterData.getPriceSpecificationBookDetails();
        Map<string,string> colorMap = compositePriceSpecificationBookMap.get('GetPickListColorMap');
        Map<string,string> getModelandColorMap =  compositePriceSpecificationBookMap.get('GetModelandColorMap');
        Map<string,string> checkColorwithModel = compositePriceSpecificationBookMap.get('CheckColorwithModel');
        // Added by Sai 08-05-2020
        // Checking the Category,SubCategory,Family based on Model
        Map<string,string> modelwithCatSubCatFamily = compositePriceSpecificationBookMap.get('ModelwithCatSubCatFamily');
        Map<string,string> dateMap =   processSalesData.getSalesWeekCountNew(selMonth,selYear);
        Map<string,string> companyNameMap = new Map<string,string>();        
        Map<string,string> lululemonModelMap = salesMasterData.getlululemonModelMap();
        Map<string,string> debenhanModelMap = salesMasterData.getDebenhamModelMap();
        Map<string,string> debenhanBrandMap = salesMasterData.getDebenhamBrandMap();
        Map<string,string> debenhanModelBrandKeyMap = salesMasterData.getDebenhamModelBrandKeyMap();
        Map<string,string> vendorDivisionBrandLabelMap = salesMasterData.getVendorDivisionBrandLabelMap();
        Map<string,Map<string,string>> getNewVendorDivisionBrandLabelMap = salesMasterData.getNewVendorDivisionBrandLabelMap();
        Map<string,Retailer_Code__c> getRetailersLabelDivisionBrandCheckMap =  salesMasterData.getRetailersLabelDivisionBrandCheckMap();
                
        map<string,string> companyOnlyMap = processSalesData.getSalesWeekCountWithPartnerCompanyNewCompanyList(selMonth,selYear,selcomp);       
            
        Map<string,string> getModelCatFamilyMap = salesMasterData.getModelCatFamilyMap();
         
        // Making company missing field blank on reupload.
        // ********TODO SAI CHECK IF THIS CODE IS REQUIRED CHECK WITH VARUN ONCE***********
        /*Inventory_Transaction_Master__c updateMasterCompany = new Inventory_Transaction_Master__c();
        updateMasterCompany.company_week__c = '';
        updateMasterCompany.Id = batchId;
        update updateMasterCompany;*/
        
        // getting user email for notifying admin for which user the reprocessing notification to be sent 
        String userName = UserInfo.getUserName();
        User activeUser = [Select Email From User where Username = : userName limit 1];
        String userEmailNotify = activeUser.Email;
        
        // Update Failure Notification for admin on reupload.
        // TODO SAI CHECK IF THIS CODE IS REQUIRED LET ME KNOW THE FUNCTIONALITY AFTER CHECKING WITH VARUN*****************
        /*Inventory_Transaction_Master__c updateFailureCheckbox = new Inventory_Transaction_Master__c();
        updateFailureCheckbox.Id = batchId;
        updateFailureCheckbox.Failure_Notification__c = false;
        updateFailureCheckbox.Reprocessing__c = false;
        update updateFailureCheckbox;*/
        
        System.debug('##### salesTransStagRecForReconciliation:::'+salesTransStagRecForReconciliation.size());
        Inventory_Transaction_Master__c  updateBatchStatus = new Inventory_Transaction_Master__c();
        List<Sales_Transaction_Stage__c> salesTransStagUpdate =  salesMasterData.preValidationSalesStageDataByPage(salesTransStagRecForReconciliation, fullSalesErrorMap,batchId, selcomp, selMonth, selYear, inCorrectFormatMap, colorMap, marketMap, lululemonModelMap, debenhanModelMap, debenhanModelBrandKeyMap, debenhanBrandMap, vendorDivisionBrandLabelMap, productionCoungtryMap, modelWarningMap, modelCompKeyMap, dateMap, companyOnlyMap, vendorMap,updateBatchStatus, recordStatus,getNewVendorDivisionBrandLabelMap,getRetailersLabelDivisionBrandCheckMap,getModelandColorMap,getSalesDataUploadCheckMap,getSalesDataUploadColorCheckMap,checkColorwithModel,getModelCatFamilyMap,categoryMap,subcategoryMap, modelwithCatSubCatFamily);
        
        boolean isUpdateMaster = false;
        
        System.debug('Before Assign ment: Flag::recordStatus.validateStatus:'+recordStatus.validateStatus +':::::recordStatus.updateCheckbox:::'+recordStatus.updateCheckbox);
        
        validateStatus = (Boolean) recordStatus.validateStatus;
        system.debug('validateStatus:::###'+validateStatus);
        updateCheckbox = (Boolean) recordStatus.updateCheckbox;
        System.debug('updateCheckbox: Flag:::'+updateCheckbox +':::::validateStatus:::'+validateStatus);
        if(updateCheckbox){              
            updateBatchStatus.Id = batchId;
           // updateBatchStatus.Reprocessing__c = true;               
            updateBatchStatus.Reprocess_Email_Notify__c = userEmailNotify; 
            isUpdateMaster = true;
        }
        System.debug('#### salesTransStagUpdate '+salesTransStagUpdate.size());
        if(salesTransStagUpdate != null && salesTransStagUpdate.size() > 0){
            try{            
                // Getting the total record count of the salesrecord for pagination
                Integer totalRecCountForUpdate = salesTransStagUpdate.size();
                System.debug('#### totalRecCountForUpdate '+totalRecCountForUpdate);
                Integer maxSizeForUpdate = 9000;
                if(totalRecCountForUpdate > maxSizeForUpdate){
                    for(Integer i = 0 ; i < (totalRecCountForUpdate / maxSizeForUpdate)+1 ; i++){
                        List<Sales_Transaction_Stage__c> salesTemp = new  List<Sales_Transaction_Stage__c>();
                        for(Integer j=(i*maxSizeForUpdate);(j<(i*maxSizeForUpdate)+maxSizeForUpdate) && j<totalRecCountForUpdate ; j++){
                            salesTemp.add(salesTransStagUpdate.get(j));
                        }
                        System.debug('#### salesTemp '+salesTemp.size());
                        update salesTemp;
                    }                    
                }else{
                    System.debug('#### ELSE salesTransStagUpdate ');
                    update salesTransStagUpdate;
                }
                if(updateBatchStatus!= null){
                    if(isUpdateMaster)
                        update updateBatchStatus;
                }
            }catch(DMLException e){    
                validateStatus= false;
                system.debug('Error in processSalesData: during DataUploadTransaction'+e.getMessage());            
            }
        } 
        boolean recordStatuss = true;            
        try{
            system.debug('Before validateStatus:::'+validateStatus);
            
            if(!validateStatus){
                system.debug('After validateStatus:::'+validateStatus+'::batchId::::'+batchId);
                updateBatchStatus.Id = batchId;
                updateBatchStatus.Batch_Status__c='3 - Error In Data Validation';   
                update updateBatchStatus;               
            }
                 system.debug('REQUEST FOR FILE CREATION::batchId:'+batchId);
                boolean appendStatus = appendTheCSVFile(batchId,salesTransStageForCSV);
        }catch(DMLException e){   
            recordStatuss = false;
            system.debug('Error in parse: during data validation:'+e.getMessage());
        }
        
    }
    global void finish(Database.BatchableContext BC){ 
        map<string,string> weekOnlyMap = processSalesData.getSalesWeekList(selMonth,selYear,selcomp);
           System.debug('BATCH FINISH weekOnlyMap::::'+weekOnlyMap);
            if(weekOnlyMap.size()>0){                
                map<string,string> companyOnlyMap = processSalesData.getSalesWeekCountWithPartnerCompanyNewCompanyList(selMonth,selYear,selcomp);
                System.debug('BATCH FINISH companyOnlyMap::::'+companyOnlyMap);
                if(companyOnlyMap.size()>0){    
                    for (String weekName : weekOnlyMap.keySet()){
                        system.debug('SELECT Year__c,Week__c,Month__c,Company__c from Sales_Transaction_Stage__c WHERE Transaction_Master_Id__c='+batchId+' AND Year__c='+selYear+' AND Month__c='+selMonth+'AND Week__c='+weekName+'AND Company__c='+selcomp);
                        Sales_Transaction_Stage__c[] dataRow = [SELECT Year__c,Week__c,Month__c,Company__c from Sales_Transaction_Stage__c WHERE Transaction_Master_Id__c=: batchId AND Year__c=:selYear AND Month__c=:selMonth AND Week__c=:weekName AND Company__c=:selcomp LIMIT 1];
                        
                        if(dataRow.size() > 0){
                            string dateCompanyValue =  dataRow[0].Year__c+'#'+dataRow[0].Week__c+'#'+dataRow[0].Month__c+'#'+dataRow[0].Company__c;                                                
                            System.debug('BATCH FINISH dateCompanyValue::::'+dateCompanyValue);
                            if(companyOnlyMap.containsKey(dateCompanyValue.trim().toLowerCase())){
                                companyOnlyMap.remove(dateCompanyValue.trim().toLowerCase());                    
                            }
                        }
                    }
                    string companyMissingWeek = '';
                    integer count = 1;
                    for (String fieldName : companyOnlyMap.keySet()){
                        companyMissingWeek += count +') '+ companyOnlyMap.get(fieldName)+'\r\n';
                        count++;
                    }
                    
                    if(String.isNotBlank(companyMissingWeek)){       
                        System.debug('BATCH FINISH IS NOT BLANK companyMissingWeek::::'+companyMissingWeek);
                        Inventory_Transaction_Master__c  updateBatchStatus = new Inventory_Transaction_Master__c();
                        updateBatchStatus.company_week__c = companyMissingWeek;
                        updateBatchStatus.Id = batchId;
                        updateBatchStatus.Batch_Status__c='3 - Error In Data Validation';  
                        update updateBatchStatus;
                    }
                }
        }
        
         List<Sales_Transaction_Stage__c> salesAdmin = [ SELECT Id  FROM Sales_Transaction_Stage__c WHERE  Upload_Batch_No__c =: batchId  and (Retailer_Check__c = true or Model_Check__c = true) AND Model_FB__c <> True AND Color_FB__c <> True AND Category_FB__c <> True AND Market_FB__c <> True AND Vendor_FB__c <> True AND Company_FB__c <> True AND Material_FB__c <> True AND Shipped_To_Factory_FB__c <> True AND Shipped_To_Country_FB__c <> True AND Division_FB__c <> True AND Item_code_FB__c <> True AND Mainetti_Brand_FB__c <> True AND Order_Type_FB__c <> True AND Customer_FB__c <> True AND Transaction_Currency_FB__c <> True AND ExRate_to_EUR_FB__C <> True AND ExRate_to_USD_FB__C <> True AND STC_FB__c <> True  AND Sales_USD_FB__c <> True AND Sales_EUR_FB__c <> True AND Unit_Price_100_USD_FB__c <> True    AND Unit_Price_100_EUR_FB__c <> True AND Local_Net_Unit_Pirce_FB__c <> True AND Net_Unit_Price_100_FB__c <> True    AND Month_FB__c <> True AND Source_FB__c <> True AND Unit_Sold_FB__c <> True    AND Week_FB__c <> True AND Year_FB__c <> True AND SO_Number_FB__c <> True  AND LOB_FB__c <> True AND Gross_Sales_USD_FB__c <> True AND Freight_Charge_USD_FB__c <> True AND Production_Country_FB__c <> True AND Label_FB__c <> True AND Retailer_Brand_FB__c <> True  AND Color_NF__c <> True AND Market_NF__c <> True    AND Company_NF__c <> True AND selected_ui_values__c <> True AND SO_Number_NF__c <> True AND LOB_NF__c <> True AND unit_sold_warning__c <> True AND ExRate_to_USD_NF__c <> True    AND ExRate_to_EUR_NF__c <> True AND Calculation_Failed__c <> True AND STC_NF__c <> True AND Retailer_Brand_NF__c <> True AND warning_consolidate_key__c <> True AND Source_NF__c <> True   AND wrong_date__c <> True  AND ( Vendor_NF__c = True OR Model_NF__c  = TRUE )];
       System.debug('salesAdmin:'+salesAdmin);
        if(salesAdmin.size() > 0){
             Inventory_Transaction_Master__c updateReprocessingStatus = new Inventory_Transaction_Master__c();
            updateReprocessingStatus.Id = batchId;
            updateReprocessingStatus.Reprocessing__c = true ;
            update updateReprocessingStatus;
            system.debug('updateReprocessingStatus:::::'+updateReprocessingStatus);
        }
        
        boolean containsWarning = false;
        System.debug('BATCH FINISH :::::: batchId::::'+batchId);
        Inventory_Transaction_Master__c updateBatchStatus = new Inventory_Transaction_Master__c();
        Sales_Transaction_Stage__c market = [SELECT Market__c FROM Sales_Transaction_Stage__c WHERE Upload_Batch_No__c =: batchId LIMIT 1];
        System.debug('market:'+market);
        Inventory_Transaction_Master__c query = [select Batch_No__c,upload_file_name__c,Batch_Status__c from Inventory_Transaction_Master__c where Id =: batchId ];
        System.debug('query:'+query);
                    String recCount = getTotalSalesTransactionRecords(batchId);
			String recCount1 = getTotalSalesTransactionErrorRecords(batchId);
            
        if(market !=null ){
            updateBatchStatus.Total_Row_Count__c = Integer.valueOf(recCount) - Integer.valueOf(recCount1);
            updateBatchStatus.Sales_Market__c = market.Market__c;
        }
        if(query != null){
            String batchStaus = query.Batch_Status__c;
            if(batchStaus.endsWithIgnoreCase('3 - Error In Data Validation')){
                containsWarning = true;
            }
        } 
        if(containsWarning){
            
            //Inventory_Transaction_Master__c  updateBatchStatus = new Inventory_Transaction_Master__c();
            updateBatchStatus.Id = batchId;
            updateBatchStatus.Batch_Process__c='Completed';
            update updateBatchStatus;
            System.debug('########### FINISH METHOD containsWarning true sending email ');
            system.debug('Inside FINISH CONTAINS WARNING Batch_No__c validate:::' +query.Batch_No__c);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {userEmail};
                mail.setToAddresses(toAddresses);
            mail.setSenderDisplayName('Batch Processing');
            mail.setSubject('Sales Batch Process Completed , Ref Batch No :'+query.Batch_No__c);
            mail.setPlainTextBody('Hello,\n\n Your Sales File Upload process has been completed,\n Please proceed to the application and go to the File Upload Screen & Check the upload Status for next steps.. \n\n Warm Regards \n Admin');
            //Put the total records etc.. in the email body.
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
        }else{
            
            
            updateBatchStatus.Id = batchId;
            updateBatchStatus.Batch_Status__c='4 - Data Validation Successful';   
            update updateBatchStatus;   
            
            System.debug('########### Batch File Before Creation of Document  No of Rows###'+ salesTransStageForCSV.size());
      
           System.debug('########### FINISH METHOD VALIDATION bEFORE CALLING salesSuccessData transfer of records ');
                Database.executeBatch(new salesSuccessData(batchId,userEmail),2000);            
            
        }        
    }
    public boolean appendTheCSVFile(String batchId,List<Sales_Transaction_Stage__c> salesTransStageForCSV){
        System.debug('INSIDE appendTheCSVFile############# batchId'+batchId);
        getMasterData getMastData = new getMasterData();
        Inventory_Transaction_Master__c query = [select Batch_No__c,upload_file_name__c,Batch_Status__c from Inventory_Transaction_Master__c where Id =: batchId ];
        ContentVersion conVer =  getMastData.getCSVFile(batchId);
        boolean createStatus = true;
        if(conVer.VersionData != null){
            System.debug('INSIDE appendTheCSVFile############# conVer != null');
            List<String> csvRowValues = generateCSVRow(salesTransStageForCSV);
            if(conVer.VersionData!=null){
                string fileContent = EncodingUtil.base64Encode(conVer.VersionData);
                String csvFile = fileContent + String.join(csvRowValues,'\n');
                if(csvFile != null){
                    boolean delStatus =  getMastData.deleteCSVFile(batchId);
                    if(delStatus){                    
                        String contentType = 'text/plain';
                        String fileName = batchId+'/'+query.upload_file_name__c;            
                        boolean appendStatus = new getMasterData().createDocument(batchId,csvFile,fileName);
                        System.debug('########### Batch File APPENDING Creation ### appendStatus'+appendStatus);
                    }else{
                        System.debug('########### Batch File APPENDING Creation ### CSVFIle Null');
                        createStatus = false;
                    }
                }            
            }
            
        } else{
            System.debug('INSIDE appendTheCSVFile############# conVer != null ELSE');
            String csvColumnHeader;
            List<String> csvRowValues = generateCSVRow(salesTransStageForCSV);
            csvColumnHeader = 'Company,Year,Week,Month,Item code,Material,Source,Model,Printed_Logo,Color,Customer,Customer local name,Mainetti_Brand,Category,Sub-Category,Family,Order_Type,Units Sold,Unit Price / 100(EUR),Unit Price / 100(USD),Net Unit Price/100,Sales EUR,Sales USD,Transaction Currency,Exchange Rate to 1 EUR,Exchange Rate to 1 USD,Local Net Unit Price/100,Sales (Transaction Currency),Shipped To - Factory,Shipped To - Country,Label,End-user,Vendor,Division,Retailer_Brand,Royalty Rate,Market,Remark,LOB,SO_Number,Production Country,Gross Sales (USD),Freight Charge (USD)\n';
            String csvFile = csvColumnHeader + String.join(csvRowValues,'\n');
            String contentType = 'text/plain';
            String fileName = batchId+'/'+query.upload_file_name__c;
            // System.debug('########### Batch File Name Before Creation of Document###'+fileName);
              createStatus = new getMasterData().createDocument(batchId,csvFile,fileName);
            System.debug('########### Batch File Creation with Header Row ### createStatus'+createStatus);
        }   
        return  createStatus ;
    }
   global List<String>  generateCSVRow(List<Sales_Transaction_Stage__c> salesTransStageForCSV){
        List<String> csvRowValues = new List<String>();
        for(Sales_Transaction_Stage__c saleTranStage : salesTransStageForCSV){
            
            String company = saleTranStage.Company__c != null ? saleTranStage.Company__c : '';
            String year = saleTranStage.Year__c != null ? saleTranStage.Year__c : '';
            String week = saleTranStage.Week__c != null ? saleTranStage.Week__c : '';
            String month = saleTranStage.Month__c != null ? saleTranStage.Month__c : '';
            String itemCode = saleTranStage.Item_code__c != null ? saleTranStage.Item_code__c : '';
            String material = saleTranStage.Material__c != null ? saleTranStage.Material__c : '';
            String source = saleTranStage.Source__c != null ? saleTranStage.Source__c : '';
            String model = saleTranStage.Model__c != null ? saleTranStage.Model__c : '';
            String printedLogo = saleTranStage.Printed_Logo__c != null ? saleTranStage.Printed_Logo__c : '';
            String color = saleTranStage.Color__c != null ? saleTranStage.Color__c : '';
            String customer = saleTranStage.Customer__c != null ? saleTranStage.Customer__c : '';
            String customerLocalName = saleTranStage.Customer_local_name__c != null ? saleTranStage.Customer_local_name__c : '';
            String mainettiBrand = saleTranStage.Mainetti_Brand__c != null ? saleTranStage.Mainetti_Brand__c : '';
            String category = saleTranStage.Category__c != null ? saleTranStage.Category__c : '';
            String subCategory = saleTranStage.Sub_Category__c != null ? saleTranStage.Sub_Category__c : '';
            String family = saleTranStage.Family__c != null ? saleTranStage.Family__c : '';
            String orderType = saleTranStage.Order_Type__c != null ? saleTranStage.Order_Type__c : '';
            String unitSold = saleTranStage.Unit_Sold__c != null ? saleTranStage.Unit_Sold__c : '';
            String unitPrice100EUR = saleTranStage.Unit_Price_100_EUR__c != null ? saleTranStage.Unit_Price_100_EUR__c : '';
            String unitPrice100USD = saleTranStage.Unit_Price_100_USD__c != null ? saleTranStage.Unit_Price_100_USD__c : '';
            String netUnitPrice100 = saleTranStage.Net_Unit_Price_100__c != null ? saleTranStage.Net_Unit_Price_100__c : '';
            String salesEUR = saleTranStage.Sales_EUR__c != null ? saleTranStage.Sales_EUR__c : '';
            String salesUSD = saleTranStage.Sales_USD__c != null ? saleTranStage.Sales_USD__c : '';
            String transactionCurrency = saleTranStage.Transaction_Currency__c != null ? saleTranStage.Transaction_Currency__c : '';
            String exRateToEUR = saleTranStage.ExRate_to_EUR__c != null ? saleTranStage.ExRate_to_EUR__c : '';
            String exRateToUSD = saleTranStage.ExRate_to_USD__c != null ? saleTranStage.ExRate_to_USD__c : '';
            String localNetUnitPirce100 = saleTranStage.Local_Net_Unit_Pirce_100__c != null ? saleTranStage.Local_Net_Unit_Pirce_100__c : '';
            String salesTransactionCurrency = saleTranStage.Sales_Transaction_Currency__c != null ? saleTranStage.Sales_Transaction_Currency__c : '';
            String shippedToFactory = saleTranStage.Shipped_To_Factory__c != null ? saleTranStage.Shipped_To_Factory__c : '';
            String shippedToCountry = saleTranStage.Shipped_To_Country__c != null ? saleTranStage.Shipped_To_Country__c : '';
            String label = saleTranStage.Label__c != null ? saleTranStage.Label__c : '';
            String enduser = saleTranStage.End_user__c != null ? saleTranStage.End_user__c : '';
            String vendor = saleTranStage.Vendor__c != null ? saleTranStage.Vendor__c : '';
            String division = saleTranStage.Division__c != null ? saleTranStage.Division__c : '';
            String retailerBrand = saleTranStage.Retailer_Brand__c != null ? saleTranStage.Retailer_Brand__c : '';
            String royaltyRate = saleTranStage.Royalty_Rate__c != null ? saleTranStage.Royalty_Rate__c : '';
            String market = saleTranStage.Market__c != null ? saleTranStage.Market__c : '';
            String remark = saleTranStage.Remark__c != null ? saleTranStage.Remark__c : '';
            String lob = saleTranStage.LOB__c != null ? saleTranStage.LOB__c : '';
            String soNumber = saleTranStage.SO_Number__c != null ? saleTranStage.SO_Number__c : '';
            String productionCountry = saleTranStage.Production_Country__c != null ? saleTranStage.Production_Country__c : '';
            String grossSalesUSD = saleTranStage.Gross_Sales_USD__c != null ? saleTranStage.Gross_Sales_USD__c : '';
            String freightChargeUSD = saleTranStage.Freight_Charge_USD__c != null ? saleTranStage.Freight_Charge_USD__c : '';           
            
            String rowStr = company + ',' + year + ',' + week + ',' + month + ',' + itemCode + ',' + material + ',' + source + ',' + model + ',' + printedLogo + ',' + color + ',' + customer + ',' + customerLocalName + ',' + mainettiBrand + ',' + category + ',' + subCategory + ',' + family + ',' + orderType + ',' + unitSold + ',' +  unitPrice100EUR + ',' + unitPrice100USD + ',' + netUnitPrice100 + ',' + salesEUR + ',' + salesUSD + ',' + transactionCurrency + ',' + exRateToEUR + ',' + exRateToUSD + ',' + localNetUnitPirce100 + ',' + salesTransactionCurrency + ',' + shippedToFactory + ',' + shippedToCountry + ',' + label + ',' + enduser + ',' + vendor  + ',' +  division + ',' + retailerBrand + ',' + market + ',' + remark + ',' + lob + ',' + soNumber + ',' + productionCountry  + ',' + grossSalesUSD + ',' + freightChargeUSD;
            csvRowValues.add(rowStr);
        }
        return csvRowValues;
    }    
    
    public String getTotalSalesTransactionRecords(String batchId){
        String recCount='';    
        AggregateResult[] groupedResults = [select  Count(Id) recCount from Sales_Transaction_Stage__c WHERE Transaction_Master_Id__c=: batchId];
        for (AggregateResult ar : groupedResults)  {
            recCount = String.valueOf(ar.get('recCount'));
        }      
        return recCount;
    } 
    
    	     public String getTotalSalesTransactionErrorRecords(string batchid){
		 String recCount1='';
        AggregateResult[] groupedResults = [select  Count(Id) recCount1 from Sales_Transaction_Stage__c WHERE Transaction_Master_Id__c=: batchId and Record_Status__c = '1 - Error In Data Validation'];
		
        for (AggregateResult ar : groupedResults)  {
            recCount1 = String.valueOf(ar.get('recCount1'));
        }      
        return recCount1;
    }
    
}