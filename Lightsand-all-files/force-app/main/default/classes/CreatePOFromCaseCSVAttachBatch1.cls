global class CreatePOFromCaseCSVAttachBatch1 implements Database.Batchable<sObject> {
    global String query='';
    List<ID> caseIdList= new List<ID>();
    global String DELIM_THREE_HASH = '###';
    
    global CreatePOFromCaseCSVAttachBatch1(String query,List<ID> caseIdList){
        this.query = query;
        this.caseIdList=caseIdList;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Attachment> caseCSVAttachList){
    
        String retailerName='';
        DateTime StartTime = DateTime.now();
        Application_Log__c appLog = new Application_Log__c();
        Case updateCase = new Case();
        String poHeaderFailureLog='';
        String poDetailFailureLog='';
        Integer totalPOHeaderSuccess=0;
        Integer totalPOHeaderFailure=0;
        Integer totalPODetailSuccess=0;
        Integer totalPODetailFailure=0;
        String caseId;
        String eachRowError ='';
        boolean isGBGRetailer = false;
        
        String processLog = '################################################\r\n' +
           'Start Date Time: ' + string.valueof(StartTime) + '\r\n';
        
        try{
        
        
        System.debug('Start 1');
        
        List < String[] > allRows = new List < String[] > ();
        if (caseCSVAttachList != null && !caseCSVAttachList.isEmpty()) {
        
        
            System.debug('Start 2'+caseCSVAttachList);
        
            //--expecting only one CSV
            Attachment poAttachment = caseCSVAttachList.get(0);
            String bodyContent = poAttachment.Body.toString();
            ID emailMessageId = poAttachment.ParentId;
            
            EmailMessage emailMessage =  [SELECT ID,ParentId FROM emailMessage where ID =:emailMessageId];
            caseId =emailMessage.ParentId;
            //-- Case Update Object
            updateCase.Id=caseId;
            
            //-- get retailer code from email subject
            List<Case> caseList = [Select Id,Subject from Case where Id=:caseId];
            if(caseList!=null && !caseList.isEmpty()){
                String subject = caseList.get(0).Subject;
                if(String.isNotEmpty(subject)){
                    
                    if(subject.contains('850_SETLOG001')){
                        retailerName='GBG';
                        isGBGRetailer=true;
                    }else if(subject.contains('##')){
                        retailerName = subject.split('##')[1];
                    }
                }
            }
            
            //--parse each line
            String[] totalRowArray = bodyContent.split('\n');
            CsvReader csvFileReader = null;
            if(isGBGRetailer){
                csvFileReader = new CsvReader(poAttachment.Body.toString(),'\t');
            }else{
                csvFileReader = new CsvReader(poAttachment.Body.toString());
            }
            
            for (integer i = 0; i < totalRowArray.size(); i++) {
                String[] eachRow = csvFileReader.readLine();
                
                if(Test.isRunningTest()){
                    allRows.add(eachRow);
                }
                if(i!=0){                    
                    allRows.add(eachRow);
                }
            }
            System.debug('allRows:' + allRows.size());
            // --END
           
        // allRows contains each line of CSV,assuming PO number as unique in POHeader Objects
        Map<String,Vendor_PO_Header__c> vendorPOHeaderMap = new Map<String,Vendor_PO_Header__c>();
        Map<String,List<Vendor_PO_Details__c>> vendorPODetailMap = new Map<String,List<Vendor_PO_Details__c>>();
        Map<String,Vendor_PO_Details__c> barcodePODetailMap = new Map<String,Vendor_PO_Details__c>();
        
        for(String[] eachRow: allRows){
            
            try{
                
            // if PO number does not exist in map
            if(vendorPOHeaderMap!=null && !vendorPOHeaderMap.containsKey(eachRow[1])){
                // put Vendor_PO_Header__c
                Vendor_PO_Header__c vendorPOHeader = new Vendor_PO_Header__c();
                vendorPOHeader.PO_Number__c = eachRow[1];//external system id
                String poDate=eachRow[2];
                if(String.isNotBlank(poDate)){
                    vendorPOHeader.PO_Date__c = Date.newInstance(Integer.valueOf(poDate.substring(0,4)),Integer.valueOf(poDate.substring(4,6)),Integer.valueOf(poDate.substring(6,8)));
                }
                
                vendorPOHeader.Retailer_Code__c = retailerName;
                vendorPOHeader.Company_Code__c = eachRow[3];
                vendorPOHeader.Season_Code__c = eachRow[4];
                vendorPOHeader.Factory_Name__c = eachRow[5];
                vendorPOHeader.Factory_Address1__c = eachRow[6];
                vendorPOHeader.Factory_Address2__c = eachRow[7];
                vendorPOHeader.Factory_City__c = eachRow[8];
                vendorPOHeader.Factory_State__c = eachRow[9];
                vendorPOHeader.Factory_Zip__c = eachRow[10];
                vendorPOHeader.Factory_Country__c = eachRow[11];
                vendorPOHeader.Vendor_Name__c = eachRow[12];
                vendorPOHeader.Vendor_Address1__c = eachRow[13];
                vendorPOHeader.Vendor_Address2__c = eachRow[14];
                vendorPOHeader.Vendor_City__c = eachRow[15];
                vendorPOHeader.Vendor_State__c = eachRow[16];
                vendorPOHeader.Vendor_Zip__c = eachRow[17];
                vendorPOHeader.Vendor_Country__c = eachRow[18];
                vendorPOHeader.Ship_To_Name__c = eachRow[19];
                vendorPOHeader.Ship_To_Address1__c = eachRow[20];
                vendorPOHeader.Ship_To_Address2__c = eachRow[21];
                vendorPOHeader.Ship_to_City__c = eachRow[22];
                vendorPOHeader.Ship_to_State__c = eachRow[23];
                vendorPOHeader.Ship_to_Zip__c = eachRow[24];
                vendorPOHeader.Ship_to_Country__c = eachRow[25];
                vendorPOHeader.Retail_Customer_Number__c = eachRow[37];
                vendorPOHeader.Brand_Description__c = eachRow[38];
                vendorPOHeaderMap.put(eachRow[1],vendorPOHeader);
             }
            // put Vendor_PO_Details__c
            Vendor_PO_Details__c vendorPODetails = new Vendor_PO_Details__c();
            vendorPODetails.UC_BarCode__c = eachRow[31]; //external system id
            vendorPODetails.Cancel_Indicator__c = eachRow[0];
            vendorPODetails.Line_Number__c = Integer.valueof(eachRow[26]);
            vendorPODetails.Quantity__c = Integer.valueof(eachRow[27]);
            vendorPODetails.UOM__c = eachRow[28];
            vendorPODetails.Color_Code__c = eachRow[29];
            vendorPODetails.Color_Description__c = eachRow[30];
            vendorPODetails.Size_Code__c = eachRow[32];
            vendorPODetails.Size_Description__c = eachRow[33];
            String retailPrice = eachRow[34];
            if(String.isNotBlank(retailPrice)){
                vendorPODetails.Retail_Price__c = Decimal.valueof(retailPrice);    
            }            
            vendorPODetails.Style_Description__c = eachRow[35];
            String deliveryDate=eachRow[39];
            if(String.isNotBlank(deliveryDate)){
               vendorPODetails.Delivery_Date__c = Date.newInstance(Integer.valueOf(deliveryDate.substring(0,4)),Integer.valueOf(deliveryDate.substring(4,6)),Integer.valueOf(deliveryDate.substring(6,8)));
            }
            
            //String poNumberBarcodeAsKey = vendorPOHeader.PO_Number__c+DELIM_THREE_HASH+vendorPODetails.UC_BarCode__c;
            if(barcodePODetailMap!=null && String.isNotEmpty(vendorPODetails.UC_BarCode__c)){
                barcodePODetailMap.put(eachRow[1]+DELIM_THREE_HASH+vendorPODetails.UC_BarCode__c,vendorPODetails);
            }else{
                eachRowError = eachRowError+'PO Detail:UC_BarCode__c: is empty or/null.'+ '\r\n';
            }
            
            /*
            if(vendorPODetailMap!=null && vendorPODetailMap.containsKey(eachRow[1])){
                vendorPODetailMap.get(eachRow[1]).add(vendorPODetails);
            }else{
                List<Vendor_PO_Details__c> poDetailList = new List<Vendor_PO_Details__c>();
                poDetailList.add(vendorPODetails);
                vendorPODetailMap.put(eachRow[1],poDetailList);
            }
            */
            
             }catch(Exception execep){
                System.debug('Execpetion while processing each row : '+execep);
                eachRowError = eachRowError+ execep + '\r\n';
            }
            
        }
        
        //--UPSERT Vendor_PO_Header__c
        Map<String,Id> poNumberPoIdMap = new Map<String,Id>();
        List<Vendor_PO_Header__c> vendorPOHeaderList;
        if(vendorPOHeaderMap!=null){
            vendorPOHeaderList = vendorPOHeaderMap.values();
        }
        
        if(vendorPOHeaderList!=null && !vendorPOHeaderList.isEmpty()){
            
        Database.UpsertResult[] results = Database.upsert(vendorPOHeaderMap.values(),Vendor_PO_Header__c.Fields.PO_Number__c,false);
            for(Integer index = 0; index < results.size(); index++) { 
                Database.UpsertResult sr = results[index];
                if (sr.isSuccess()) {
                    totalPOHeaderSuccess++;
                    if(sr.isCreated()) {
                        System.debug(vendorPOHeaderList[index].PO_Number__c +' was created');
                    } else {
                        System.debug(vendorPOHeaderList[index].PO_Number__c +' was updated');
                    }
                    poNumberPoIdMap.put(vendorPOHeaderList[index].PO_Number__c,sr.getID());
                }
                else {
                    totalPOHeaderFailure++;
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        poHeaderFailureLog+='error has occurred.' + err.getStatusCode() + ': ' + err.getMessage()+'\r\n';
                        poHeaderFailureLog+='fields that affected this error: ' + err.getFields()+'\r\n';
                        
                    }
                }
            }
        }
        //-- END:Vendor_PO_Header__c:UPSERT
        
        //--UPSERT Based on bar-code FOR Vendor_PO_Details__c
        /*
        List<Vendor_PO_Details__c> vendorPODetailsList = new  List<Vendor_PO_Details__c>();
        if(vendorPODetailMap!=null){
            for (String key : vendorPODetailMap.keySet()){
                for(Vendor_PO_Details__c eachPoDetail : vendorPODetailMap.get(key)){
                    if(poNumberPoIdMap!=null && poNumberPoIdMap.containsKey(key)){
                        eachPoDetail.Vendor_PO_ID__c=poNumberPoIdMap.get(key);
                    }
                    vendorPODetailsList.add(eachPoDetail);
                }
            }
        }*/
        
        List<Vendor_PO_Details__c> vendorPODetailsList = new  List<Vendor_PO_Details__c>();
        if(barcodePODetailMap!=null){
            for (String key : barcodePODetailMap.keySet()){
                if(String.isNotEmpty(key) && key.contains(DELIM_THREE_HASH)){
                    Vendor_PO_Details__c eachPoDetail = barcodePODetailMap.get(key);
                    if(poNumberPoIdMap!=null && poNumberPoIdMap.containsKey(key.split(DELIM_THREE_HASH)[0])){
                        eachPoDetail.Vendor_PO_ID__c=poNumberPoIdMap.get(key.split(DELIM_THREE_HASH)[0]);
                        eachPoDetail.PO_Number_Bar_Code__c=key;
                        vendorPODetailsList.add(eachPoDetail);
                    }
                }
            }
        }
        
        if(vendorPODetailsList!=null && !vendorPODetailsList.isEmpty()){
        Database.UpsertResult[] results = Database.upsert(vendorPODetailsList,Vendor_PO_Details__c.Fields.PO_Number_Bar_Code__c,false);
            for(Integer index = 0; index < results.size(); index++) { 
                Database.UpsertResult sr = results[index];
                if (sr.isSuccess()) {
                    totalPODetailSuccess++;
                    if(sr.isCreated()) {
                        System.debug(vendorPODetailsList[index].PO_Number_Bar_Code__c +' was created');
                    } else {
                        System.debug(vendorPODetailsList[index].PO_Number_Bar_Code__c +' was updated');
                    }
                }
                else {
                    totalPODetailFailure++;
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        poDetailFailureLog+='error has occurred.' + err.getStatusCode() + ': ' + err.getMessage()+'\r\n';
                        poDetailFailureLog+='fields that affected this error: ' + err.getFields()+'\r\n';
                    }
                }
            }
        }
        //-- END:Vendor_PO_Details__c:UPSERT   

              if((vendorPODetailsList==null || vendorPODetailsList.isEmpty()) && (vendorPOHeaderList==null || vendorPOHeaderList.isEmpty())){
                appLog.status__c='Failure';
                updateCase.Batch_Status__c='Failure';
              }
                       
            else if(totalPOHeaderFailure > 0 || totalPODetailFailure > 0){
                appLog.status__c='Partial Success';
                updateCase.Batch_Status__c='Partial Success';
            }else{
                appLog.status__c='Success';
                updateCase.Batch_Status__c='Success';
            }            
            
           processLog = processLog +'Total Rows : ' + allRows.size() + '\r\n' +
           'Total PO Header Records : ' + vendorPOHeaderList.size() + '\r\n' +
           'Total PO Header Records Processed Successfully : ' + totalPOHeaderSuccess + '\r\n' +
           'Total PO Header Records Failed : ' + totalPOHeaderFailure + '\r\n' +
           'Total PO Detail Records : ' + vendorPODetailsList.size() + '\r\n' +
           'Total PO Detail Records Processed Successfully : ' + totalPODetailSuccess + '\r\n' +
           'Total PO Detail Records Failed : ' + totalPODetailFailure + '\r\n';
                
            if(String.isNotBlank(eachRowError)){
               processLog = processLog+'PO Row Processing Error : ' +eachRowError+ '\r\n';
            }
                
            if(String.isNotBlank(poHeaderFailureLog)){
               processLog = processLog+'PO Header Failure Logs : ' + poHeaderFailureLog + '\r\n';
            }
            if(String.isNotBlank(poDetailFailureLog)){
               processLog = processLog+'PO Detail Failure Logs : ' + poDetailFailureLog + '\r\n';
            }
                
           processLog=processLog+'################################################\r\n';
            
            }
            
        }catch(exception e){            
            
            appLog.status__c='Failure';
            processLog='Error Occured while Processing the records : '+e.getCause();
            
        }finally{
        
        
            System.debug('Start 3');
            
            
            try{
                if (caseCSVAttachList != null && !caseCSVAttachList.isEmpty()) {
                    //-- Update Case
                    update updateCase;
                }
            }catch(Exception exe){
                System.debug('Error Occured while updating Case '+exe.getMessage());  
            }
                        
            try{        
                                
                //-- Create Application Log
                processLog = processLog+'End Date Time: ' + string.valueof(DateTime.Now()) + '\r\n';            
                appLog.type__c='Job';
                appLog.Name='CreatePOFromCaseCSVAttachBatch';
                appLog.description__c =processLog;
                appLog.case__c=caseId ;
                insert appLog;
                
            }catch(Exception exe){
                System.debug('Error Occured while updating Application Log '+exe.getMessage());                
            }            
        }
    }
    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }    
}