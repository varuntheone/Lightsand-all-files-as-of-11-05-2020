global class salesSuccessData implements Database.Batchable<sObject> ,Database.AllowsCallouts, Database.Stateful {
    
    String fetchSuccessdata='SELECT unit_sold_warning__c,Gross_Sales_USD__c,Gross_Sales_USD_FB__c,Gross_Sales_USD_NF__c,Freight_Charge_USD__c,Freight_Charge_USD_FB__c,Freight_Charge_USD_NF__c,selected_ui_values__c,Row_No__c,Week_FB__c,Year_FB__c,Source_FB__c,Month_FB__c,Unit_Sold_FB__c,Local_Net_Unit_Pirce_FB__c,Net_Unit_Price_100_FB__c,ExRate_to_USD_FB__c,ExRate_to_EUR_FB__c,Calculation_Failed__c,Remark__c,Label__c,End_user__c,Royalty_Rate__c,Printed_Logo__c,Customer_local_name__c,Net_Unit_Price_100__c,Local_Net_Unit_Pirce_100__c,ExRate_to_USD__c,ErrorMapData__c,validation_failed__c,warning_consolidate_key__c,SO_Number__c,SO_Number_FB__c,SO_Number_NF__c,LOB__c,LOB_FB__c,LOB_NF__c,Company__c,Company_FB__c,Customer__c,Customer_FB__c,Transaction_Currency__c,Transaction_Currency_FB__c,Transaction_Currency_NF__c, Division__c,Division_FB__c,Division_NF__c,Mainetti_Brand__c,Mainetti_Brand_FB__c,Mainetti_Brand_NF__c,Item_code__c,Item_code_FB__c,Item_code_NF__c, Production_Country__c,Production_Country_FB__c,Production_Country_NF__c,Retailer_Brand__c,Retailer_Brand_FB__c,Retailer_Brand_NF__c, Material__c,Material_FB__c,Material_NF__c,Company_NF__c,Model__c,Model_FB__c,Model_NF__c,Market__c,Market_FB__c,Market_NF__c,Vendor__c,Vendor_FB__c,Vendor_NF__c, Category__c,Category_FB__c,Category_NF__c,Sub_Category__c,Sub_Category_FB__c,Sub_Category_NF__c,Order_Type__c,Order_Type_FB__c,Order_Type_NF__c, Shipped_To_Country__c,Shipped_To_Country_FB__c,Shipped_To_Country_NF__c,Shipped_To_Factory__c,Shipped_To_Factory_FB__c,Shipped_To_Factory_NF__c, Color__c,Color_FB__c,Color_NF__c,Country__c,Country_NF__c,ExRate_to_EUR__c,ExRate_to_EUR_NF__c, ExRate_to_USD_NF__c,Local_Currency__c,Local_Currency_NF__c,Local_Currency_FB__c,Month__c,Month_NF__c,Remarks__c,Retailer_Code__c,Retailer_Code_NF__c, Sales_Local__c,SL_NF__c,Source__c,Source_NF__c,Unit_Sold__c,US_NF__c,UOM__c,UOM_NF__c,Week__c,Week_NF__c,Year__c,Year_NF__c,Upload_Batch_No__c, Family__c,Family_FB__c,Family_NF__c,Sales_Transaction_Currency__c,STC_FB__c,STC_NF__c,Sales_EUR__c,Sales_EUR_FB__c,Sales_EUR_NF__c,Sales_USD__c,Sales_USD_FB__c,Sales_USD_NF__c,Unit_Price_100_EUR__c,Unit_Price_100_EUR_FB__c,Unit_Price_100_EUR_NF__c,wrong_date__c, Unit_Price_100_USD__c,Unit_Price_100_USD_FB__c,Unit_Price_100_USD_NF__c,Label_FB__c FROM Sales_Transaction_Stage__c WHERE Upload_Batch_No__c=:batchId and Record_Status__c =\'2 - Data Validation Successful\'';
    String email;
    global String batchId;
    global String userEmail;
    global Boolean insertStatus;    
    global boolean uploadStatus;
    public salesSuccessData( String batchId,String userEmail) {
        this.batchId = batchId;
        system.debug('batchId:'+batchId);
        this.userEmail = userEmail;    
        system.debug('userEmail:'+userEmail);
    }    
    global Database.querylocator start(Database.BatchableContext BC){
        
        this.uploadStatus =  createCSVFileAndUploadToAzure(batchId);        
        this.insertStatus = true;
        
        System.debug('####### START SALES SUCCESS DATA::::FILE UPLOAD STATUS '+uploadStatus);
        //Moved from execute Method       
        if(uploadStatus) {
            Inventory_Transaction_Master__c updateBatchStatus = new Inventory_Transaction_Master__c();
            updateBatchStatus.Id = batchId;
            updateBatchStatus.Batch_Status__c = '7 - Migration In Progress';
            update updateBatchStatus;
        }
        return Database.getQueryLocator(fetchSuccessdata);        
    }
    
    global void execute(Database.BatchableContext BC, List<Sales_Transaction_Stage__c> transferRecords){     
        
        getSalesMasterData masterData = new getSalesMasterData();
        processSalesData processsalesData = new processSalesData();    
        List<Data_Upload_Sales__c> insertRecord = new List<Data_Upload_Sales__c>();
        
        if(transferRecords.size() > 0){   
            
            for(Sales_Transaction_Stage__c trans: transferRecords){
                Data_Upload_Sales__c salesTransMast = new Data_Upload_Sales__c();
                salesTransMast.Upload_Batch_No__c = trans.Upload_Batch_No__c;
                salesTransMast.Sales_Data_Company__c = trans.Company__c;
                salesTransMast.Year__c = trans.Year__c;
                salesTransMast.Week__c = trans.Week__c;
                salesTransMast.Month__c = trans.Month__c;
                salesTransMast.Item_Code__c = trans.Item_Code__c;
                salesTransMast.Material__c = trans.Material__c;
                salesTransMast.Source__c = trans.Source__c;
                salesTransMast.Model__c = trans.Model__c;
                salesTransMast.Printed_Logo__c = trans.Printed_Logo__c;
                salesTransMast.Color__c = trans.Color__c;
                salesTransMast.Customer__c = trans.Customer__c;
                salesTransMast.Customer_Local_Name__c = trans.Customer_Local_Name__c;
                salesTransMast.Mainetti_Brand__c = trans.Mainetti_Brand__c;
                salesTransMast.Category__c = trans.Category__c;
                salesTransMast.Sub_Category__c = trans.Sub_Category__c;
                salesTransMast.Family__c = trans.Family__c;
                salesTransMast.Order_Type__c = trans.Order_Type__c;
                salesTransMast.Unit_Sold__c = decimal.valueOf(trans.Unit_Sold__c.replaceAll(',',''));
                salesTransMast.Unit_Price_100_EUR__c = decimal.valueOf(trans.Unit_Price_100_EUR__c);
                salesTransMast.Unit_Price_100_USD__c = decimal.valueOf(trans.Unit_Price_100_USD__c);
                salesTransMast.Net_Unit_Price_100__c = trans.Net_Unit_Price_100__c;
                salesTransMast.Sales_EUR__c = decimal.valueOf(trans.Sales_EUR__c);
                salesTransMast.Sales_USD__c = decimal.valueOf(trans.Sales_USD__c);
                salesTransMast.Transaction_Currency__c = trans.Transaction_Currency__c;
                salesTransMast.ExRate_to_EUR__c = decimal.valueOf(trans.ExRate_to_EUR__c);
                salesTransMast.ExRate_to_USD__c = decimal.valueOf(trans.ExRate_to_USD__c);
                salesTransMast.Local_Net_Unit_Pirce_100__c = decimal.valueOf(trans.Local_Net_Unit_Pirce_100__c.replaceAll('-','0'));
                salesTransMast.Sales_Transaction_Currency__c = decimal.valueOf(trans.Sales_Transaction_Currency__c.replaceAll(',',''));
                salesTransMast.Shipped_To_Factory__c = trans.Shipped_To_Factory__c; 
                salesTransMast.Shipped_To_Country__c = trans.Shipped_To_Country__c;
                salesTransMast.Label__c = trans.Label__c;
                salesTransMast.End_User__c = trans.End_User__c;
                salesTransMast.Vendor__c = trans.Vendor__c;
                salesTransMast.Division__c = trans.Division__c;
                salesTransMast.Retailer_Brand__c = trans.Retailer_Brand__c;
                salesTransMast.Royalty_Rate__c = trans.Royalty_Rate__c;
                salesTransMast.Market__c = trans.Market__c;
                salesTransMast.Remark__c = trans.Remark__c;
                salesTransMast.LOB__c = trans.LOB__c;
                salesTransMast.SO_Number__c = trans.SO_Number__c;
                salesTransMast.Production_Country__c = trans.Production_Country__c;
                salesTransMast.Gross_Sales_USD__c = decimal.valueOf(trans.Gross_Sales_USD__c);
                salesTransMast.Freight_Charge_USD__c = decimal.valueOf(trans.Freight_Charge_USD__c);
                if(trans.Unit_Sold__c != '0' && trans.Sales_EUR__c != '0' && trans.Sales_USD__c != '0'){
                    insertRecord.add(salesTransMast);
                }
            }
            if(insertRecord.size()>0){
                try{
                    if(uploadStatus) {
                        //insert insertRecord;
                        new uploadInventry().splitInsertRecordListForUpload(insertRecord);
                        //delete transferRecords;
                        new uploadInventry().splitListForDelete(transferRecords);
                        system.debug('After Deleting Stage:::'+transferRecords.size());
                    }
                }catch(DMLException e){   
                    insertStatus = false;
                    system.debug('Error in insertDataUploadSales: during DataUploadSales'+e.getMessage());
                }
            }            
        }
        
    }
    global void finish(Database.BatchableContext BC){
        Inventory_Transaction_Master__c updateBatchStatus = new Inventory_Transaction_Master__c();
        updateBatchStatus.Id = batchId;
        updateBatchStatus.Batch_Process__c='Completed';
        if(insertStatus && uploadStatus){
            String recCount = getUploadDetails(batchId);
            updateBatchStatus.Total_Row_Count__c = Integer.valueOf(recCount);
            updateBatchStatus.Batch_Status__c = '8 - Migration Success';
        }else{
            updateBatchStatus.Batch_Status__c = '9 - Migration Fail';
        }        
        update updateBatchStatus;
        
        Inventory_Transaction_Master__c query = [SELECT Batch_No__c FROM Inventory_Transaction_Master__c WHERE Id =: batchId ];
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {userEmail};
            mail.setToAddresses(toAddresses);
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Sales Batch Process Completed , Ref Batch No :'+query.Batch_No__c);
        mail.setPlainTextBody('Hello,\n\n Your Sales File Upload process has been completed,\n Please proceed to the application and go to the File Upload Screen & Check the upload Status for next steps.. \n\n Warm Regards \n Admin');
        //Put the total records etc.. in the email body.
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });       
    }
    global boolean createCSVFileAndUploadToAzure(String batchId){
        System.debug('batchId:'+batchId);
        boolean fileCreationNUploadToAzure = true;
        getMasterData getMastData = new getMasterData();
        ContentVersion conVer =  getMastData.getCSVFile(batchId);
        System.debug('conVer:'+conVer);
        
        string fileContent = EncodingUtil.base64Encode(conVer.VersionData);
        
        System.debug('fileContent:'+fileContent);
        String fileName = conVer.PathOnClient;
        System.debug('fileName:'+fileName);
        String contentType = 'text/plain';
        boolean fileUploadStatus= true;
        //Calling the Azure file upload
        if(String.isNotBlank(fileContent))
            fileUploadStatus = uploadToAzure(fileName, fileContent,  contentType);        
        
        /************************************update the Azure URL **************************************/
        if(fileUploadStatus){
            Inventory_Transaction_Master__c transMast = new Inventory_Transaction_Master__c();
            String  inventoryFileLink = '/apex/inventoryFileDownload?Id='+batchId;               
            transMast.Id = batchId;
            transMast.upload_file_name__c = fileName;
            transMast.Azure_File_Link__c = inventoryFileLink;
            transMast.Batch_Status__c = '6 - Azure File Upload Successful';
            try{
                update transMast;
                boolean delStatus =  getMastData.deleteCSVFile(batchId);
            }catch(DMLException ex){
                fileCreationNUploadToAzure = false;
                System.debug('DML Exception during the 6 - Azure File Upload Successful'+ex.getMessage());
            }            
        }else{
            fileCreationNUploadToAzure = false;
        }        
        return fileCreationNUploadToAzure;
    }
    
    global static boolean uploadToAzure(String fileName, String fileContent, String contentType) {
        Boolean uploadStatus = true;
        system.debug('fileName>> '+fileName+'contentType>>> '+contentType);        
        inventory_azure_storage_details__c	 detail = inventory_azure_storage_details__c.getInstance();
        String storageKey = detail.storageKey__c;
        String storageName = detail.storageName__c;
        String containerName = detail.containerName__c;
        
        String signature;
        String encodedtimestamp;
        String encodedfileName;
        String encodedfileLength;
        String fileLengthafter;
        //String data = EncodingUtil.base64Encode(Blob.valueOf(fileContent));
        Blob myBlob = EncodingUtil.base64Decode(fileContent);
        System.debug('fileContent:'+fileContent);
        system.debug('myBlob>> '+myBlob);
        Integer size = myBlob.size();
        system.debug('size>> '+size);
        
        DateTime timestamp = Datetime.now().addMinutes(-5);
        encodedtimestamp = timestamp.formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
        encodedfileName = EncodingUtil.urlEncode(fileName, 'UTF-8');
        //encodedfileName = fileName;
        
        fileLengthafter = String.valueof(size);  
        string canonHeaders = 'x-ms-blob-type:BlockBlob\nx-ms-date:'+encodedtimestamp+'\nx-ms-version:2015-12-11\n';
        string canonRes = '/'+storageName+'/'+containerName+'/'+encodedfileName;
        string stringToSign = 'PUT\n\n\n'+fileLengthafter+'\n\n'+contentType+'\n\n\n\n\n\n\n'+canonHeaders+canonRes;
        system.debug('stringToSign>> '+stringToSign);        
        //Sign the request
        Blob temp = EncodingUtil.base64Decode(storageKey);
        Blob hmac = Crypto.generateMac('HmacSHA256', Blob.valueOf(stringToSign), temp);
        signature = EncodingUtil.base64Encode(hmac);
        system.debug('signature>> '+signature);
        boolean response = false;        
        
        HttpRequest req = new HttpRequest();        
        req.setMethod('PUT');
        req.setHeader('x-ms-blob-type', 'BlockBlob');
        req.setHeader('x-ms-date', encodedtimestamp);
        string authHeader = 'SharedKey '+storageName+':'+signature;
        system.debug('authHeader>>> '+authHeader);
        req.setHeader('Authorization', authHeader);
        req.setHeader('x-ms-version', '2015-12-11');
        req.setHeader('Content-Length', fileLengthafter);
        req.setHeader('Content-Type', contentType);
        req.setEndpoint('https://'+storageName+'.blob.core.windows.net/'+containerName+'/'+encodedfileName);
        req.setBodyAsBlob(myBlob);
        
        Http http = new Http();
        String s;
        try
        {
            HTTPResponse res = http.send(req);
            
            system.debug('response into string'+res.toString());
            system.debug('status>>> '+res.getStatus());
            system.debug('status code>>> '+res.getStatusCode());
            system.debug('status body>>> '+res.getBody());
            
            if(res.getStatusCode() == 201){
                System.debug('###### FILE SUCCESSFULLY UPLOADED TO AZURE');
                Boolean flag;
            }
        }
        catch (system.CalloutException ce){
            system.debug('##### Exceptionce During CalloutException'+ce.getMessage());
            uploadStatus = false;
        }
        return uploadStatus;
    }
    public String getUploadDetails(String batchId){
        String recCount='';    
        AggregateResult[] groupedResults = [select  Count(Id) recCount from Data_Upload_Sales__c where Upload_Batch_No__c=:batchId];
        for (AggregateResult ar : groupedResults)  {
            recCount = String.valueOf(ar.get('recCount'));
        }      
        return recCount;
    }    
}