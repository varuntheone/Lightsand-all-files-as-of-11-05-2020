global class BestAndLessBulkOrderProcess implements Database.Batchable<sObject>, Database.Stateful {
    
    String query = 'SELECT Id,Column_01__c,Column_14__c,Column_06__c  FROM CSV_File_Data__c WHERE Id IN: inputParams ORDER BY Column_01__c,Column_14__c,Column_06__c';
    private List<string> inputParams;
    public BestAndLessBulkOrderProcess(List<string> inputParams) {
        this.inputParams = inputParams;        
    }    
    
    global Database.querylocator start(Database.BatchableContext BC){        
        System.debug('::::::::::::::: INSIDE THE START METHOD OF BEST AND LESS BULK ORDER PROCESSING :::::::::::::::::::::');         
        return Database.getQueryLocator(query);            
    }
    
    global void execute(Database.BatchableContext BC, List<CSV_File_Data__c> csvFileOrdernumber){
        System.debug('::::::::::::::: INSIDE THE EXECUTE METHOD OF BestAndLessBulkOrderProcess BATCH PROCESSING :::::::::::::::::::::');
        Map<string,Retailer_Related_Data__c> supplierData = getSupplier();
        Map<string,Retailer_Code__c> retailerId =  getRetailerId();
        Map<string,Customer_Information__c> customerInfo =  getCustomerInfoId(); 
        Map<string,Contact_Related_Retailer__c> contactInfo =  getRetailerContactId();
        
        
        List<CSV_File_Data__c> totalOrderRecords =  getOrderNumberRecords(csvFileOrdernumber);
        system.debug('totalOrderRecords:::totalOrderRecords.size()'+totalOrderRecords.size());
        if(totalOrderRecords.size() > 0){   
            Boolean isDataValid= true;
            Boolean isSizerCodeNull = false; 
            List<String> errorRemarks = new List <String>();
            //for (CSV_File_Data__c csvDataRow : csvFileDataList)
            for (CSV_File_Data__c csvDataRow : totalOrderRecords) {
                
                System.debug('csvDataRow'+csvDataRow.Id);
                
                boolean createPo = false;
                //if(isDataValid){ //Changed by varun on 09-04-2020.
                    
                    System.debug('#### HANGER MODEL'+csvDataRow.Column_04__c);
                    PurchaseOrder__c purchaseOrder = new PurchaseOrder__c(); 
                    Purchase_Order_LineItem__c purchaseOrderLineItem = new Purchase_Order_LineItem__c();
                    CSV_File_Data__c csvFileDataObjForFailureRow = new CSV_File_Data__c();
                    String retailerName;
                    //Order Number
                    if(String.isBlank(csvDataRow.Column_01__c)){
                        csvFileDataObjForFailureRow.IsDataValid__c = false;
                        errorRemarks.add('Order Number is Null ');
                        isDataValid=false;
                    }else{
                        purchaseOrder.Order_Number__c = csvDataRow.Column_01__c;                                        
                    } 
                    //System.debug('#### Order_Number__c'+csvDataRow.Column_01__c+':::isDataValid::'+isDataValid);
                    //Suppplier Name
                    purchaseOrder.Supplier_Name__c = csvDataRow.Column_02__c;
                    
                    //Supplier Number
                    if(String.isBlank(csvDataRow.Column_03__c)){
                        csvFileDataObjForFailureRow.IsDataValid__c = false;
                        errorRemarks.add('Supplier Number is Null ');
                        isDataValid=false;
                    }else{
                        Retailer_Related_Data__c retailerRelatedData = supplierData.get(csvDataRow.Column_03__c);
                        if(retailerRelatedData != null){   
                            retailerName = retailerRelatedData.Retailer_Code__r.Name;
                            purchaseOrder.Supplier_from_Cus_Inf__c=retailerRelatedData.Customer_Information__c;
                            purchaseOrder.Supplier_Code__c = csvDataRow.Column_03__c;
                        }else{
                            purchaseOrder.Supplier_Code__c = csvDataRow.Column_03__c;
                            
                        }                   
                    }
                    //System.debug('#### Order_Number__c'+csvDataRow.Column_01__c+':::isDataValid::'+isDataValid);
                    //CSV Date
                    purchaseOrder.File_Input_Date__c = csvDataRow.Column_07__c;
                    
                    //Ex-Factory Date
                    purchaseOrder.Due_Date__c = csvDataRow.Column_06__c;
                    purchaseOrderLineItem.Due_Date_TXT__c= csvDataRow.Column_06__c;
                    
                    //Hanger Model
                    if(String.isBlank(csvDataRow.Column_04__c)){
                        csvFileDataObjForFailureRow.IsDataValid__c = false;
                        errorRemarks.add('Hanger Model is Null  ');
                        isDataValid=false;
                    }else{
                        
                        //size code
                        if(String.isNotBlank(csvDataRow.Column_15__c)){
                            Associate_Product__c[] productInfo = getHangerModel(csvDataRow.Column_04__c);                                
                            if(productInfo.size() > 0){  
                                purchaseOrderLineItem.Product_CSV__c = productInfo[0].Product__r.Name +' - '+csvDataRow.Column_15__c;
                                purchaseOrderLineItem.Customer_Ref_Model__c = productInfo[0].Product__r.Name +' - '+csvDataRow.Column_15__c;                                    
                                purchaseOrderLineItem.Size__c = csvDataRow.Column_15__c;      
                                createPo = true;
                            }else{
                                csvFileDataObjForFailureRow.IsDataValid__c = false;
                                errorRemarks.add('Associated Model Not Found ');
                                isDataValid=false;                              
                            }                                               
                        }else{
                            System.debug('########## ELSE SIZE CODE NULL BEFORE CALLING canCreatePOWhenSizerNull::::'+csvDataRow.Column_04__c);
                            //size code
                            createPo = canCreatePOWhenSizerNull(csvDataRow.Column_04__c);
                            if(createPo){
                                errorRemarks.add('Associated Model Not Found and Sizer Code is Null  ');
                                isSizerCodeNull = true;    
                            }else{ 
                                csvFileDataObjForFailureRow.IsDataValid__c = false;
                                errorRemarks.add('Sizer Code is Null  ');
                                //commented by on 26-03-2020
                                isDataValid=false;                                   
                            }
                        }                                                 
                        
                    }
                    //System.debug('#### Hanger Model csvDataRow.Column_06__c'+csvDataRow.Column_04__c+'csvDataRow.Column_15__c::'+csvDataRow.Column_15__c+':::isDataValid::'+isDataValid);
                    //Quantity
                    if(String.isBlank(csvDataRow.Column_05__c)){
                        csvFileDataObjForFailureRow.IsDataValid__c = false;
                        errorRemarks.add('Order Quantity is Null ');
                        isDataValid=false;
                    }else{
                        String isQtyNumberic = csvDataRow.Column_05__c;
                        //system.debug('isQtyNumberic:'+isQtyNumberic);
                        if(isQtyNumberic.isNumeric()){
                            purchaseOrderLineItem.Quantity__c = csvDataRow.Column_05__c;
                            purchaseOrderLineItem.Supply_Quantity__c = csvDataRow.Column_05__c;
                        }else{
                            csvFileDataObjForFailureRow.IsDataValid__c = false;
                            errorRemarks.add('Order Quantity Value is NOT Numeric -:'+csvDataRow.Column_05__c);
                            isDataValid=false;
                        }
                        
                    } 
                    //System.debug('#### Quantity__c'+csvDataRow.Column_05__c+':::isDataValid::'+isDataValid);
                    
                    purchaseOrderLineItem.Country_Of_Origin_Text__c = csvDataRow.Column_08__c;
                    purchaseOrderLineItem.Dept__c = csvDataRow.Column_09__c;
                    purchaseOrderLineItem.Style_No__c =  csvDataRow.Column_10__c;
                    purchaseOrderLineItem.Size_Chart__c = csvDataRow.Column_11__c;
                    purchaseOrderLineItem.STYLE_DESC__c = csvDataRow.Column_12__c;
                    purchaseOrderLineItem.Retailer_Status__c = csvDataRow.Column_13__c;
                    purchaseOrderLineItem.Revise_Version_Number__c = Integer.ValueOf(csvDataRow.Column_14__c);
                    purchaseOrderLineItem.DEPT_DESC__c =  csvDataRow.Column_16__c;
                    
                    //Added on 02-04-2020
                    purchaseOrder.PO_Status__c= csvDataRow.Column_13__c;
                    
                    //added on 24-03-2020
                    purchaseOrder.Revise_Version_Number__c = Integer.ValueOf(csvDataRow.Column_14__c);
                    if(String.isBlank(retailerName)){
                        retailerName = 'BEST & LESS';
                    }                    
                    //system.debug('retailerName:'+retailerName);
                    if(String.isNotBlank(retailerName)){
                        Retailer_Code__c retailerInfo = retailerId.get(retailerName);
                        if(retailerInfo != null)
                            purchaseOrder.Retailer_Code1__c = retailerInfo.Id;
                        
                        Customer_Information__c customerInfoRec = customerInfo.get(retailerName);
                        if(customerInfoRec != null)
                            purchaseOrder.Retailer_Code_Cus__c = customerInfoRec.Id;
                        
                        Contact_Related_Retailer__c contactRelInfo = contactInfo.get(retailerName);
                        if(contactRelInfo != null)
                            purchaseOrder.Retailer_Contact__c =contactRelInfo.Contact__c;              
                    }        
                    purchaseOrder.Status__c = 'Open';    
                    purchaseOrderLineItem.Status__c = 'Open'; 
                    purchaseOrderLineItem.Colour__c = 'Please select';
                    
                    try{
                        csvFileDataObjForFailureRow.Id=csvDataRow.Id;                           
                        //boolean insideIsSizerCodeNullNisDataValid = false;
                        //Added on 26-03-2020, In case where the Sizer code is Null
                        if(isSizerCodeNull && isDataValid){
                            System.debug('##### isSizerCodeNull && isDataValid');
                            String separator = '\n';
                            csvFileDataObjForFailureRow.Processing_Status__c = 'Failed';
                            //System.debug('##### Sizer code is Null errorRemarks List'+errorRemarks);
                            String errorRemarkWithSeparator = String.join(errorRemarks, separator);
                            //System.debug('##### Sizer code is Null errorRemarkWithSeparator'+errorRemarkWithSeparator);
                            csvFileDataObjForFailureRow.Record_Error_Remarks__c = errorRemarkWithSeparator;
                            csvFileDataObjForFailureRow.Start_Process__c = true; //New change.
                            //insideIsSizerCodeNullNisDataValid = true;
                            update csvFileDataObjForFailureRow;   
                            //updateFailedRecords(csvDataRow.Column_01__c,csvDataRow.Column_14__c);//Change 30-03-2020
                        }
                        if(!isDataValid && !isSizerCodeNull){
                            System.debug('##### !isSizerCodeNull && !isDataValid');
                            String separator = '\n';
                            csvFileDataObjForFailureRow.Processing_Status__c = 'Failed';
                            //System.debug('##### errorRemarks List'+errorRemarks);
                            String errorRemarkWithSeparator = String.join(errorRemarks, separator);
                            //System.debug('##### errorRemarkWithSeparator'+errorRemarkWithSeparator);
                            csvFileDataObjForFailureRow.Record_Error_Remarks__c = errorRemarkWithSeparator;
                            csvFileDataObjForFailureRow.Start_Process__c = true; //New change.
                            
                            update csvFileDataObjForFailureRow;        
                            //delete po order and update all records as invalid.
                            if(String.isNotBlank(csvDataRow.Column_01__c)){
                                system.debug('INSIDE isDataValid before calling THE METHOD updateFailedRecords'+csvDataRow.Column_01__c+'::::Sizer Code'+csvDataRow.Column_15__c);
                                updateFailedRecords(csvDataRow.Column_01__c,csvDataRow.Column_14__c,errorRemarkWithSeparator,csvDataRow.Column_06__c); //CHange 26-03-2020
                            }     
                        }else{
                            List<CSV_File_Data__c> checkForFailRecords = checkFailedRecords(csvDataRow.Column_01__c,csvDataRow.Column_14__c,csvDataRow.Column_06__c);
                            if(checkForFailRecords.size() > 0) //New change by Varun on 10-04-2020.
                                createPo = false;
                            
                            if(createPo){
                                System.debug('#### Inside Else !isDataValid && !isSizerCodeNull before checking PO Exists'+csvDataRow.Column_04__c+'::::Sizer Code'+csvDataRow.Column_15__c);
                                //Checking whether an PO Exits
                                PurchaseOrder__c[] exitPO = checkingPOExitsBasedOnOrderNumber(csvDataRow.Column_01__c,csvDataRow.Column_14__c,csvDataRow.Column_06__c);
                                
                                String purchaseOrderIdForModel;
                                if(exitPO.size() > 0){
                                    purchaseOrderIdForModel = exitPO[0].Id;
                                    purchaseOrderLineItem.Purchase_Order__c = exitPO[0].Id;
                                    csvFileDataObjForFailureRow.Purchase_Order__c = exitPO[0].Id;
                                    System.debug('Purchase Order Does Already Exists');
                                }else{
                                    insert purchaseOrder;
                                    purchaseOrderIdForModel= purchaseOrder.Id;
                                    purchaseOrderLineItem.Purchase_Order__c = purchaseOrder.Id;
                                    csvFileDataObjForFailureRow.Purchase_Order__c = purchaseOrder.Id;
                                    System.debug('Purchase Order Does NOT Exists');
                                }                   
                                
                                //checking whether the Purchase Order Item has been created for the Model if not create else Update with along with new qty.
                                Purchase_Order_LineItem__c[] existingModelPurchaseOrderItem = checkingPOItemModelExitsBasedOnPOModel(purchaseOrderIdForModel,csvDataRow.Column_04__c);
                                //System.debug('purchaseOrderIdForModel::'+purchaseOrderIdForModel);
                                
                                //System.debug('existingModelPurchaseOrderItem.size():::'+existingModelPurchaseOrderItem.size());
                                if(existingModelPurchaseOrderItem.size()>0){
                                    System.debug('INSIDE PURCHASE ORDER ITEM EXISTS ALREADY');
                                    Purchase_Order_LineItem__c updateModelPurchaseOrderItem = new Purchase_Order_LineItem__c();
                                    updateModelPurchaseOrderItem = existingModelPurchaseOrderItem[0];
                                    Integer existingQty = Integer.ValueOf(updateModelPurchaseOrderItem.Quantity__c);
                                    Integer newItemQty = Integer.ValueOf(purchaseOrderLineItem.Quantity__c);
                                    Integer updatedQty = (existingQty+newItemQty);
                                    updateModelPurchaseOrderItem.Quantity__c = String.ValueOf(updatedQty);
                                    updateModelPurchaseOrderItem.Supply_Quantity__c = String.ValueOf(updatedQty);
                                    update updateModelPurchaseOrderItem;
                                    //When Sizer code is Null not create line item
                                    if(!isSizerCodeNull){
                                        insert purchaseOrderLineItem;
                                    }
                                }else{
                                    //When Sizer code is Null not create line item
                                    if(!isSizerCodeNull){
                                        System.debug('#####  isSizerCodeNull Not Null'+csvDataRow.Column_04__c+'::::Sizer Code'+csvDataRow.Column_15__c);
                                        insert purchaseOrderLineItem;
                                    }else{
                                        System.debug('##### Else isSizerCodeNull Null'+csvDataRow.Column_04__c+'::::Sizer Code'+csvDataRow.Column_15__c);
                                        //csvFileDataObjForFailureRow.UnCheckedLinked__c = true;
                                    }
                                    Purchase_Order_LineItem__c newModelPurchaseOrderItem = new Purchase_Order_LineItem__c();
                                    newModelPurchaseOrderItem = purchaseOrderLineItem.clone(false,false,false,false);
                                    newModelPurchaseOrderItem.Product_CSV__c = csvDataRow.Column_04__c;
                                    newModelPurchaseOrderItem.Customer_Ref_Model__c = csvDataRow.Column_04__c;
                                    newModelPurchaseOrderItem.Colour__c = 'BLACK';
                                    insert newModelPurchaseOrderItem;
                                }
                                
                                if(isSizerCodeNull){
                                    String separator = '\n';
                                    String errorRemarkWithSeparator = String.join(errorRemarks, separator);                               
                                    csvFileDataObjForFailureRow.Record_Error_Remarks__c = errorRemarkWithSeparator;
                                }                              
                                csvFileDataObjForFailureRow.Processing_Status__c = 'Success';
                                csvFileDataObjForFailureRow.Start_Process__c = true; //New change.
                                update csvFileDataObjForFailureRow;
                            } else {
                                csvFileDataObjForFailureRow.Processing_Status__c = 'Success';
                                csvFileDataObjForFailureRow.Start_Process__c = true; //New change by Varun on 10-04-2020.
                                update csvFileDataObjForFailureRow;
                            }
                            errorRemarks.clear();
                            isDataValid = true;
                            isSizerCodeNull = false; 
                        }
                    }catch(DMLException ex){
                        csvFileDataObjForFailureRow.Processing_Status__c = 'Failed';
                        //added vinod 23-03-2020
                        csvFileDataObjForFailureRow.Start_Process__c = true;
                        //end added vinod 23-03-2020
                        csvFileDataObjForFailureRow.Record_Error_Remarks__c = ex.getMessage();
                        update csvFileDataObjForFailureRow;
                        
                        //delete po order and update all records as invalid.
                        if(String.isNotBlank(csvDataRow.Column_01__c)){
                            system.debug('INSIDE DMLException before calling THE METHOD updateFailedRecords'+csvDataRow.Column_04__c);
                            updateFailedRecords(csvDataRow.Column_01__c,csvDataRow.Column_14__c,ex.getMessage(),csvDataRow.Column_06__c);//Change 26-03-2020
                        }     
                        //System.debug('Exception During the processing of the Order Number:::'+inputParams+'::::Error Msg'+ex.getMessage());
                    }
                /*} else {
                    //delete po order and update all records as invalid.
                    if(String.isNotBlank(csvDataRow.Column_01__c)){
                         String separator = '\n';
                         String errorRemarkWithSeparator = String.join(errorRemarks, separator);
                        system.debug('INSIDE else before calling THE METHOD updateFailedRecords'+csvDataRow.Column_04__c);
                        updateFailedRecords(csvDataRow.Column_01__c,csvDataRow.Column_14__c,errorRemarkWithSeparator);//Change 26-03-2020
                    }      
                    errorRemarks.clear();
                    isDataValid = true;
                    isSizerCodeNull = false; 
                }*/ //Changed by varun on 09-04-2020.
                errorRemarks.clear(); 
                isDataValid = true;
                isSizerCodeNull = false;
            }             
        } 
    }
    global void finish(Database.BatchableContext BC){ 
        System.debug('::::::::::::::: INSIDE THE FINISH METHOD OF BestAndLessBulkOrderProcess BATCH PROCESSING :::::::::::::::::::::');
    }
    
    //Gettign the customer Info from the supplier code
    public static Map<string,Retailer_Related_Data__c> getSupplier() {
        
        Map<string,Retailer_Related_Data__c> retailerRelatedDataMap = new Map<string,Retailer_Related_Data__c>();
        
        Retailer_Related_Data__c[] customerInfo =[SELECT Customer_Information__c,Retailer_Code__r.Name,Supplier_Code__c  FROM Retailer_Related_Data__c WHERE Status__c = 'Active']; 
        for (Retailer_Related_Data__c retailerRelatedData : customerInfo) {
            if(!retailerRelatedDataMap.containsKey(retailerRelatedData.Supplier_Code__c)){ 
                retailerRelatedDataMap.put(retailerRelatedData.Supplier_Code__c,retailerRelatedData);
            }
        }
        
        return retailerRelatedDataMap;
    } 
    
    //Getting the Hanger Model when the Associate Product is linked or checked to create an record or not
    public static boolean canCreatePOWhenSizerNull(String modelNumber) {
        System.debug('########## INSIDE canCreatePOWhenSizerNull:::'+modelNumber);
        Boolean canCreatePO = false;
        Price_Specification_Book_Product__c[] priceSpecBookProd =[SELECT Id,Associated_Product__c FROM Price_Specification_Book_Product__c WHERE Customer_Ref_Model__c =:modelNumber AND Active__c=true AND Retailer_Code__c IN (select Id from Retailer_code__c Where Name= 'BEST & LESS') LIMIT 1]; 
        System.debug(':::::::priceSpecBookProd.size():::'+priceSpecBookProd.size());
        if(priceSpecBookProd.size()> 0){
            System.debug(':::::::priceSpecBookProd[0].Associated_Product__c:::::'+priceSpecBookProd[0].Associated_Product__c);
            if(!priceSpecBookProd[0].Associated_Product__c){
                Associate_Product__c[] productInfo =[SELECT Product__r.Name FROM Associate_Product__c WHERE Price_Specification_Book_Product__c =: priceSpecBookProd[0].Id]; 
                System.debug(':::::::productInfo Size'+productInfo.size());
                if(productInfo.size() == 0)
                    canCreatePO = true;
            }            
        }
        System.debug('########## INSIDE canCreatePOWhenSizerNull:::canCreatePO:::'+canCreatePO);
        return canCreatePO;
    } 
    //Getting the Hanger Model
    public static Associate_Product__c[] getHangerModel(String modelNumber) {
        List<Associate_Product__c> productInfo = new List<Associate_Product__c>();
        Price_Specification_Book_Product__c[] priceSpecProd= [SELECT Id FROM Price_Specification_Book_Product__c  WHERE  Customer_Ref_Model__c =:modelNumber AND Active__c=true AND Retailer_Code__c IN (select Id from Retailer_code__c Where Name= 'BEST & LESS') AND Associated_Product__c =true];
        
        if(priceSpecProd.size()>0)
            productInfo =[SELECT Product__r.Name FROM Associate_Product__c WHERE Price_Specification_Book_Product__c=:priceSpecProd[0].Id]; 
        
        return productInfo;
    } 
    //Getting the retailer Id based on the retailer Name
    /*public static Retailer_Code__c[] getRetailerId(String retailerName) {

Retailer_Code__c[] retailerInfo =[SELECT Id,Name FROM Retailer_Code__c WHERE  NAME =:retailerName LIMIT 1]; 

return retailerInfo;
} */
    
    public static Map<string,Retailer_Code__c> getRetailerId() {
        
        Map<string,Retailer_Code__c> retailerInfoMap = new Map<string,Retailer_Code__c>();
        Retailer_Code__c[] retailerInfo =[SELECT Id,Name FROM Retailer_Code__c];         
        for (Retailer_Code__c retailer : retailerInfo) {
            if(!retailerInfoMap.containsKey(retailer.Name)){ 
                retailerInfoMap.put(retailer.Name,retailer);
            }
        }
        
        return retailerInfoMap;
    } 
    
    
    //Getting the customer Information from the retailer Name(Company Name)
    /* public static Customer_Information__c[] getCustomerInfoId(String companyName) {

Customer_Information__c[] customerInfo =[SELECT Id FROM Customer_Information__c WHERE  NAME =:companyName LIMIT 1]; 

return customerInfo;
}   */
    
    public static Map<string,Customer_Information__c> getCustomerInfoId() {
        
        Map<string,Customer_Information__c> customerInfoMap = new Map<string,Customer_Information__c>();
        Customer_Information__c[] customerInfo =[SELECT Id,Name FROM Customer_Information__c];        
        for (Customer_Information__c custInfo : customerInfo) {
            if(!customerInfoMap.containsKey(custInfo.Name)){ 
                customerInfoMap.put(custInfo.Name,custInfo);
            }
        }        
        return customerInfoMap;
    } 
    
    //Getting the contact / user based on the retailer Name
    /*public static Contact_Related_Retailer__c[] getRetailerContactId(String retailerName) {
//System.debug('########## getRetailerContactId::::retailerName::: '+retailerName);
Contact_Related_Retailer__c[] contactInfo =[SELECT Contact__c FROM Contact_Related_Retailer__c WHERE  Retailer_Name__c =:retailerName LIMIT 1];         
return contactInfo;
}  */ 
    
    public static Map<string,Contact_Related_Retailer__c> getRetailerContactId() {
        
        Map<string,Contact_Related_Retailer__c> contactInfoMap = new Map<string,Contact_Related_Retailer__c>();
        Contact_Related_Retailer__c[] contactInfo =[SELECT Contact__c,Retailer_Name__c FROM Contact_Related_Retailer__c];    
        for (Contact_Related_Retailer__c contInfo : contactInfo) {
            if(!contactInfoMap.containsKey(contInfo.Retailer_Name__c)){ 
                contactInfoMap.put(contInfo.Retailer_Name__c,contInfo);
            }
        }        
        return contactInfoMap;
    } 
    //Getting the PO Id based on the order Number
    public static PurchaseOrder__c[] checkingPOExitsBasedOnOrderNumber(String OrderNumber,String versionNumber, String exFactoryDate) {
        //system.debug('OrderNumber:'+OrderNumber);
        //system.debug('versionNumber:'+versionNumber);
        PurchaseOrder__c[] purchaseOrder =[SELECT Id FROM PurchaseOrder__c WHERE  Order_Number__c =:OrderNumber AND Revise_Version_Number__c=:Integer.ValueOf(versionNumber)
                                           AND Due_Date__c =:exFactoryDate LIMIT 1];        
        
        return purchaseOrder;
        
    }    
    //Getting the Exiting Purchase Order Item based on the Purchase Order and Model
    public static Purchase_Order_LineItem__c[] checkingPOItemModelExitsBasedOnPOModel(String purchaseOrderId,String ModelName) {
        //System.debug('checkingPOItemModelExitsBasedOnPOModel::::::     String purchaseOrderId,String ModelName:::'+purchaseOrderId+'::::'+ ModelName);
        Purchase_Order_LineItem__c[] purchaseOrderItem =[SELECT Id,Quantity__c FROM Purchase_Order_LineItem__c WHERE Purchase_Order__c=:purchaseOrderId  AND Product_CSV__c =:ModelName LIMIT 1];        
        //system.debug('purchaseOrderItem:'+purchaseOrderItem);
        return purchaseOrderItem;
    }    
    
    public static List<CSV_File_Data__c> getOrderNumberRecords(List<CSV_File_Data__c> csvFileOrdernumber) {        
        
        List<CSV_File_Data__c> csvFileOrderSplitList = new List<CSV_File_Data__c>();
        system.debug('getOrderNumberRecords:::csvFileOrdernumber.size()'+csvFileOrdernumber.size());
        if(csvFileOrdernumber.size() > 0){
            List<CSV_File_Data__c> csvFileDataObjForFailureList = new List<CSV_File_Data__c>();
            Map<string,string> orderVersionMap = new Map<string,string>();
            MAP<ID,ID>  orderNumberID = new MAP<ID,ID>(); 
            for (CSV_File_Data__c csvDataRow : csvFileOrdernumber) {
                String orderNumber = csvDataRow.Column_01__c;
                String versionNumber = csvDataRow.Column_14__c;
                String exFactDate = csvDataRow.Column_06__c;
                if(String.isNotBlank(orderNumber)){
                    //String orderKey = orderNumber+'#'+versionNumber;
                    String orderKey = orderNumber+'#'+versionNumber+'#'+exFactDate; //change by Varun on 10-04-2020.
                    System.debug('####orderKey:::'+orderKey);
                    if(!orderVersionMap.containsKey(orderKey)){ 
                        orderVersionMap.put(orderKey,orderKey);                        
                    }
                    orderNumberID.put(csvDataRow.Id,csvDataRow.Id);
                }else{
                    CSV_File_Data__c csvFileDataObjForFailureRow = new CSV_File_Data__c();
                    csvFileDataObjForFailureRow.Id=csvDataRow.Id;
                    csvFileDataObjForFailureRow.IsDataValid__c = false;
                    String errorRemarkWithSeparator = 'Order Number is Null ';
                    csvFileDataObjForFailureRow.Record_Error_Remarks__c = errorRemarkWithSeparator;
                    csvFileDataObjForFailureRow.Processing_Status__c = 'Failed';
                    csvFileDataObjForFailureRow.Start_Process__c = true;
                    csvFileDataObjForFailureList.add(csvFileDataObjForFailureRow);
                }
            }
            //updating all the rows which have empty order number
            if(csvFileDataObjForFailureList.size() > 0){
                update csvFileDataObjForFailureList;
            }
            system.debug('orderVersionMap:::orderVersionMap.size()'+orderVersionMap.size());
            if(orderVersionMap.size() > 0){
                for (String orderVersion : orderVersionMap.keySet()){
                    List<CSV_File_Data__c> csvFileOrderList = new List<CSV_File_Data__c>();
                    String[] orderVersionVal     = orderVersion.split('#');
                    
                    String orderNumber = orderVersionVal[0];
                    String versionNumber = orderVersionVal[1];
                    String exFactoryDate = orderVersionVal[2]; //change by Varun on 10-04-2020.
                    SET<ID>  poOrderIds = orderNumberID.keySet();
                    // System.debug('orderNumber:'+orderNumber);
                    if(String.isNotBlank(orderNumber)){
                        
                        List<CSV_File_Data__c> checkForFailRecords =[SELECT Id,Record_Error_Remarks__c FROM CSV_File_Data__c WHERE Column_01__c =:orderNumber
                                                                     AND Column_14__c =:versionNumber AND Column_06__c =:exFactoryDate AND Processing_Status__c='Failed'];
                        // System.debug('checkForFailRecords:'+checkForFailRecords);
                        
                        csvFileOrderList=[SELECT Id,Column_01__c,Column_02__c,Column_03__c,Column_04__c,Column_05__c,Column_06__c,
                                          Column_07__c,Column_08__c,Column_09__c,Column_10__c,Column_11__c,Column_12__c,Column_13__c,
                                          Column_14__c,Column_15__c,Column_16__c,Column_17__c,Column_18__c,Column_19__c,Column_20__c
                                          FROM CSV_File_Data__c WHERE Column_01__c =:orderNumber AND Column_14__c =:versionNumber
                                          AND Column_06__c =:exFactoryDate AND Processing_Status__c='Draft' AND ID IN:poOrderIds];
                        if(csvFileOrderList.size()>0){
                            csvFileOrderSplitList.addAll(csvFileOrderList);
                        } 
                        
                        if(checkForFailRecords.size() == 0){
                            /*csvFileOrderList=[SELECT Id,Column_01__c,Column_02__c,Column_03__c,Column_04__c,Column_05__c,Column_06__c,
                                              Column_07__c,Column_08__c,Column_09__c,Column_10__c,Column_11__c,Column_12__c,Column_13__c,
                                              Column_14__c,Column_15__c,Column_16__c,Column_17__c,Column_18__c,Column_19__c,Column_20__c
                                              FROM CSV_File_Data__c WHERE Column_01__c =:orderNumber AND Column_14__c =:versionNumber AND Processing_Status__c='Draft' AND ID IN:poOrderIds];
                            if(csvFileOrderList.size()>0){
                                csvFileOrderSplitList.addAll(csvFileOrderList);
                            }*/  //Changed by varun on 09-04-2020.                       
                        }else{
                            String errorRemarks = checkForFailRecords[0].Record_Error_Remarks__c;
                            List<CSV_File_Data__c> markForFailRecords =[SELECT Id,Purchase_Order__c FROM CSV_File_Data__c WHERE Column_01__c =:orderNumber
                                                                        AND Column_14__c =:versionNumber AND Column_06__c =:exFactoryDate];
                            String purchaseOderId = '';
                            
                            if(markForFailRecords.size() > 0){
                                List<CSV_File_Data__c> csvFileFailList = new List<CSV_File_Data__c>();
                                for(CSV_File_Data__c recStatus : markForFailRecords){
                                    CSV_File_Data__c updateFail = new CSV_File_Data__c();
                                    //String purchaseOder = updateFail.Purchase_Order__c;
                                    String purchaseOder = recStatus.Purchase_Order__c;
                                    if(String.isNotBlank(purchaseOder)){    
                                        //purchaseOderId = updateFail.Purchase_Order__c;
                                        purchaseOderId = recStatus.Purchase_Order__c;
                                    }                            
                                    updateFail.Id = recStatus.Id;
                                    updateFail.Record_Error_Remarks__c =errorRemarks; 
                                    updateFail.Processing_Status__c = 'Failed';
                                    updateFail.Start_Process__c = true;
                                    csvFileFailList.add(updateFail);                            
                                }
                                try{
                                    //update csvFileFailList; //Changed by varun on 09-04-2020.
                                    if(String.isNotBlank(purchaseOderId)){
                                        // system.debug('INSIDE Bulk fail delete'+purchaseOderId);
                                        delete[select Id from PurchaseOrder__c where id=:purchaseOderId];
                                    }
                                }catch(DMLException ex){
                                    System.debug('Exception During Updating failed records::::Error Msg'+ex.getMessage());
                                }                    
                            }
                        }
                    }
                }
            }
        }
        
        return csvFileOrderSplitList;        
    }
    
    /*
* Delete po order and update all records as invalid.
* @Modified Varun
* */
    public static void updateFailedRecords(string orderNumber, String versionNumber,String errorRemarks, String exFactoryDate) {
        system.debug('INSIDE THE METHOD updateFailedRecords'+orderNumber);
        List<CSV_File_Data__c> getRecords =[SELECT Id,Purchase_Order__c  FROM CSV_File_Data__c WHERE Column_01__c =:orderNumber 
                                            AND Column_14__c =:versionNumber AND Column_06__c =:exFactoryDate];
        List<CSV_File_Data__c> updateList = new List<CSV_File_Data__c>();
        String purchaseOderId = '';
        
        if(getRecords.size() > 0){
            for(CSV_File_Data__c csvRecord : getRecords){
                
                String purchaseOder = csvRecord.Purchase_Order__c;
                if(String.isNotBlank(purchaseOder)){    
                    purchaseOderId = csvRecord.Purchase_Order__c;
                }            
                CSV_File_Data__c updateObject = new CSV_File_Data__c();
                updateObject.Id = csvRecord.Id;
                updateObject.Record_Error_Remarks__c =errorRemarks; 
                updateObject.Processing_Status__c = 'Failed';
                updateObject.Start_Process__c = true;
                updateList.add(updateObject);
            }
        }
        try{
            //update updateList; //Changed by varun on 09-04-2020.
            if(String.isNotBlank(purchaseOderId)){
                //system.debug('DELETE PURCHASE ORDER ID'+purchaseOderId);
                delete[select Id from PurchaseOrder__c where id=:purchaseOderId];
            }
        }catch(DMLException ex){
            System.debug('Exception During Updating failed records::::Error Msg'+ex.getMessage());
        }        
    }

    public static List<CSV_File_Data__c> checkFailedRecords(String orderNumber, String versionNumber, String exFactoryDate) { //New change by Varun on 10-04-2020.
        List<CSV_File_Data__c> checkForFailRecords =[SELECT Id,Record_Error_Remarks__c FROM CSV_File_Data__c WHERE Column_01__c =:orderNumber
                                                     AND Column_14__c =:versionNumber AND Column_06__c =:exFactoryDate AND Processing_Status__c='Failed'];
        
        system.debug('checkForFailRecordsSize:'+checkForFailRecords.size());
        return checkForFailRecords;
    }    
     
}