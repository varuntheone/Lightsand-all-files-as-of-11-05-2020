/*
* Author:        K.V.VINOD KUMAR
* Company:       TECHKASETTI
* Description:   Class for processing Bess & Less CSV Order from baser CSV_File_Data__c Object
* History
* <Date>          <28-02-2020>   <Class for processing Bess and Less Order from CSV_File_Data__c>
*/
public class BessNLessCSVOrderProcessor {
    
    @InvocableMethod(label='Bess & Less CSV Order Process' description='Bess & Less CSV Order Process')
    public static void processOrder (List<string> inputParams) {
        System.debug('START OF THE BESS AND LESS ORDER PROCESSOR inputParams' +inputParams.size()+ inputParams);
        
        //system.debug('getStatus(inputParams):'+getStatus(inputParams));
        if(getStatus(inputParams)){
            
            List<CSV_File_Data__c> totalOrderRecords =  getOrderNumberRecords(inputParams);
            
            if(totalOrderRecords <> null){   
                Boolean isDataValid= true;
                Boolean isSizerCodeNull = false; 
                List<String> errorRemarks = new List <String>();
                //for (CSV_File_Data__c csvDataRow : csvFileDataList)
                for (CSV_File_Data__c csvDataRow : totalOrderRecords) {
                    //List<String> recId = new List <String>();
                    //recId.add(csvDataRow.Id);
                    //if(isDataValid && getStatus(recId)){
                    boolean createPo = false;
                    if(isDataValid){
                        
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
                            Retailer_Related_Data__c[] customerInfo = getSupplier(csvDataRow.Column_03__c);
                            if(customerInfo.size() > 0){   
                                retailerName = customerInfo[0].Retailer_Code__r.Name;
                                purchaseOrder.Supplier_from_Cus_Inf__c=customerInfo[0].Customer_Information__c;
                                purchaseOrder.Supplier_Code__c = csvDataRow.Column_03__c;
                            }else{
                                purchaseOrder.Supplier_Code__c = csvDataRow.Column_03__c;
                                //csvFileDataObjForFailureRow.IsDataValid__c = false;
                                // errorRemarks.add('Supplier Number is Not Valid ::: '+csvDataRow.Column_03__c);
                                //isDataValid=false;
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
                            
                            /*Associate_Product__c[] productInfo = getHangerModel(csvDataRow.Column_04__c);                            
                            if(productInfo.size() > 0){  
                                purchaseOrderLineItem.Product_CSV__c = productInfo[0].Product__r.Name +' - '+csvDataRow.Column_15__c;
                                purchaseOrderLineItem.Customer_Ref_Model__c = productInfo[0].Product__r.Name +' - '+csvDataRow.Column_15__c;
                                //size code
                                if(String.isBlank(csvDataRow.Column_15__c)){
                                    csvFileDataObjForFailureRow.IsDataValid__c = false;
                                    errorRemarks.add('Sizer Code is Null  ');
                                    //commented by on 26-03-2020
                                    isDataValid=false;                                   
                                }else{
                                    purchaseOrderLineItem.Size__c = csvDataRow.Column_15__c;                                    
                                }                      
                            }else{
                                System.debug('#### ASSOCIATED MODEL NOT FOUND'+csvDataRow.Column_04__c);
                                csvFileDataObjForFailureRow.IsDataValid__c = false;
                                errorRemarks.add('Hanger Model is Not Valid ::: '+csvDataRow.Column_04__c);
                                isDataValid=false;
                                //Sizer Code // added on 27-03-2020
                                if(String.isBlank(csvDataRow.Column_15__c)){
                                    System.debug('#### ASSOCIATED MODEL NOT FOUND AND SIZER CODE IS NULL'+csvDataRow.Column_04__c);
                                    errorRemarks.add('Associated Model Not Found and Sizer Code is Null  ');
                                    isSizerCodeNull = true;
                                } 
                            }  */                 
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
                            Retailer_Code__c[] retailerInfo = getRetailerId(retailerName);
                            if(retailerInfo.size() > 0)
                                purchaseOrder.Retailer_Code1__c = retailerInfo[0].Id;
                            
                            Customer_Information__c[] customerInfo = getCustomerInfoId(retailerName);
                            if(customerInfo.size() > 0)
                                purchaseOrder.Retailer_Code_Cus__c = customerInfo[0].Id;
                            
                            Contact_Related_Retailer__c[] contactInfo = getRetailerContactId( retailerName);
                            if(contactInfo.size() > 0)
                                purchaseOrder.Retailer_Contact__c =contactInfo[0].Contact__c;              
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
                                update csvFileDataObjForFailureRow;        
                                //delete po order and update all records as invalid.
                                if(String.isNotBlank(csvDataRow.Column_01__c)){
                                    system.debug('INSIDE isDataValid before calling THE METHOD updateFailedRecords'+csvDataRow.Column_01__c+'::::Sizer Code'+csvDataRow.Column_15__c);
                                    updateFailedRecords(csvDataRow.Column_01__c,csvDataRow.Column_14__c); //CHange 26-03-2020
                                }     
                            }else{
                                if(createPo){
                                    System.debug('#### Inside Else !isDataValid && !isSizerCodeNull before checking PO Exists'+csvDataRow.Column_04__c+'::::Sizer Code'+csvDataRow.Column_15__c);
                                    //Checking whether an PO Exits
                                    PurchaseOrder__c[] exitPO = checkingPOExitsBasedOnOrderNumber(csvDataRow.Column_01__c,csvDataRow.Column_14__c);
                                    //System.debug('csvDataRow.Column_01__c:'+csvDataRow.Column_01__c);
                                    //System.debug('csvDataRow.Column_14__c:'+csvDataRow.Column_14__c);
                                    //System.debug('exitPO:'+exitPO);
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
                                updateFailedRecords(csvDataRow.Column_01__c,csvDataRow.Column_14__c);//Change 26-03-2020
                            }     
                            //System.debug('Exception During the processing of the Order Number:::'+inputParams+'::::Error Msg'+ex.getMessage());
                        }
                    } else {
                        //delete po order and update all records as invalid.
                        if(String.isNotBlank(csvDataRow.Column_01__c)){
                            
                            system.debug('INSIDE else before calling THE METHOD updateFailedRecords'+csvDataRow.Column_04__c);
                            updateFailedRecords(csvDataRow.Column_01__c,csvDataRow.Column_14__c);//Change 26-03-2020
                        }                        
                    }
                }             
            } else {                
                for (String csvRow : inputParams) {
                    CSV_File_Data__c csvFileDataObjForFailureRow = new CSV_File_Data__c();
                    csvFileDataObjForFailureRow.Id=csvRow;
                    csvFileDataObjForFailureRow.IsDataValid__c = false;
                    //errorRemarks.add('Order Number is Null ');                
                    //String errorRemarkWithSeparator = String.join(errorRemarks, separator);
                    String errorRemarkWithSeparator = 'Order Number is Null ';
                    csvFileDataObjForFailureRow.Record_Error_Remarks__c = errorRemarkWithSeparator;
                    csvFileDataObjForFailureRow.Processing_Status__c = 'Failed';
                    update csvFileDataObjForFailureRow; 
                }
                
            }
        }
    }
    //Getting the CSV File Row Details
    public static List<CSV_File_Data__c> getCSVFileOrderdDetails (List<string> inputParams) {
        List<CSV_File_Data__c> csvFileOrderList=[SELECT Id,Column_01__c,Column_02__c,Column_03__c,Column_04__c,Column_05__c,Column_06__c,Column_07__c,Column_08__c,Column_09__c,Column_10__c,Column_11__c,Column_12__c,Column_13__c,Column_14__c,Column_15__c,Column_16__c,Column_17__c,Column_18__c,Column_19__c,Column_20__c FROM CSV_File_Data__c WHERE Id IN: inputParams]; 
        
        return csvFileOrderList;
    } 
    //Gettign the customer Info from the supplier code
    public static Retailer_Related_Data__c[] getSupplier(String supplierNumber) {
        
        Retailer_Related_Data__c[] customerInfo =[SELECT Customer_Information__c,Retailer_Code__r.Name  FROM Retailer_Related_Data__c
                                                  WHERE Supplier_Code__c =:supplierNumber AND Status__c = 'Active' LIMIT 1]; 
        
        return customerInfo;
    } 
    
    //Getting the Hanger Model when the Associate Product is linked or checked to create an record or not
    public static boolean canCreatePOWhenSizerNull(String modelNumber) {
        System.debug('########## INSIDE canCreatePOWhenSizerNull:::'+modelNumber);
         Boolean canCreatePO = false;
        Price_Specification_Book_Product__c[] priceSpecBookProd =[SELECT Id,Associated_Product__c FROM Price_Specification_Book_Product__c WHERE Name =:modelNumber AND Active__c=true AND Retailer_Code__c IN (select Id from Retailer_code__c Where Name= 'BEST & LESS') LIMIT 1]; 
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
        Price_Specification_Book_Product__c[] priceSpecProd= [SELECT Id FROM Price_Specification_Book_Product__c  WHERE  Name =:modelNumber AND Active__c=true AND Retailer_Code__c IN (select Id from Retailer_code__c Where Name= 'BEST & LESS') AND Associated_Product__c =true];
        //Price_Specification_Book_Product__c[] productInfo =[SELECT Name FROM Price_Specification_Book_Product__c WHERE Name =:modelNumber AND Sizer_Print__c=:printerSize LIMIT 1]; 
        if(priceSpecProd.size()>0)
            productInfo =[SELECT Product__r.Name FROM Associate_Product__c WHERE Price_Specification_Book_Product__c=:priceSpecProd[0].Id]; 
         
        return productInfo;
    } 
    //Getting the retailer Id based on the retailer Name
    public static Retailer_Code__c[] getRetailerId(String retailerName) {
        
        Retailer_Code__c[] retailerInfo =[SELECT Id,Name FROM Retailer_Code__c WHERE  NAME =:retailerName LIMIT 1]; 
        
        return retailerInfo;
    } 
    //Getting the customer Information from the retailer Name(Company Name)
    public static Customer_Information__c[] getCustomerInfoId(String companyName) {
        
        Customer_Information__c[] customerInfo =[SELECT Id FROM Customer_Information__c WHERE  NAME =:companyName LIMIT 1]; 
        
        return customerInfo;
    }   
    //Getting the contact / user based on the retailer Name
    public static Contact_Related_Retailer__c[] getRetailerContactId(String retailerName) {
        //System.debug('########## getRetailerContactId::::retailerName::: '+retailerName);
        Contact_Related_Retailer__c[] contactInfo =[SELECT Contact__c FROM Contact_Related_Retailer__c WHERE  Retailer_Name__c =:retailerName LIMIT 1];         
        return contactInfo;
    }   
    
    //Getting the PO Id based on the order Number
    public static PurchaseOrder__c[] checkingPOExitsBasedOnOrderNumber(String OrderNumber,String versionNumber) {
        //system.debug('OrderNumber:'+OrderNumber);
        //system.debug('versionNumber:'+versionNumber);
        PurchaseOrder__c[] purchaseOrder =[SELECT Id FROM PurchaseOrder__c WHERE  Order_Number__c =:OrderNumber AND Revise_Version_Number__c=:Integer.ValueOf(versionNumber) LIMIT 1];        
        
        return purchaseOrder;
        
    }    
    //Getting the Exiting Purchase Order Item based on the Purchase Order and Model
    public static Purchase_Order_LineItem__c[] checkingPOItemModelExitsBasedOnPOModel(String purchaseOrderId,String ModelName) {
        //System.debug('checkingPOItemModelExitsBasedOnPOModel::::::     String purchaseOrderId,String ModelName:::'+purchaseOrderId+'::::'+ ModelName);
        Purchase_Order_LineItem__c[] purchaseOrderItem =[SELECT Id,Quantity__c FROM Purchase_Order_LineItem__c WHERE Purchase_Order__c=:purchaseOrderId  AND Product_CSV__c =:ModelName LIMIT 1];        
        //system.debug('purchaseOrderItem:'+purchaseOrderItem);
        return purchaseOrderItem;
    }    
    
    public static boolean getStatus (List<string> inputParams) {
         
        boolean isDraft =false;
        List<CSV_File_Data__c> getRecordStatus = [Select Processing_Status__c From CSV_File_Data__c where id IN:inputParams];
        if(getRecordStatus.size() >0){
            for(CSV_File_Data__c recStatus : getRecordStatus){
                String processStatus = recStatus.Processing_Status__c;
                if(processStatus.equalsIgnoreCase('Draft')){
                    isDraft = true;
                }
            }
        }
        system.debug('getStatus::::::'+inputParams+':::isDraft::::'+isDraft);
        return isDraft;
    }
    
    public static List<CSV_File_Data__c> getOrderNumberRecords(List<string> inputParams) {
        
        List<CSV_File_Data__c> csvFileOrdernumber =[SELECT Column_01__c,Column_14__c  FROM CSV_File_Data__c WHERE Id IN: inputParams];
        //system.debug('CSV OrderNumber:'+csvFileOrdernumber[0].Column_01__c);
        List<CSV_File_Data__c> csvFileOrderList = new List<CSV_File_Data__c>();
        List<CSV_File_Data__c> csvFileOrderSplitList; // = new List<CSV_File_Data__c>();
        
        if(csvFileOrdernumber.size() > 0){
            String orderNumber = csvFileOrdernumber[0].Column_01__c;
            String versionNumber = csvFileOrdernumber[0].Column_14__c;
            // System.debug('orderNumber:'+orderNumber);
            if(String.isNotBlank(orderNumber)){
                
                List<CSV_File_Data__c> checkForFailRecords =[SELECT Id FROM CSV_File_Data__c WHERE Column_01__c =:orderNumber AND Column_14__c =:versionNumber AND Processing_Status__c='Failed'];
                // System.debug('checkForFailRecords:'+checkForFailRecords);
                if(checkForFailRecords.size() == 0){
                    csvFileOrderList=[SELECT Id,Column_01__c,Column_02__c,Column_03__c,Column_04__c,Column_05__c,Column_06__c,
                                      Column_07__c,Column_08__c,Column_09__c,Column_10__c,Column_11__c,Column_12__c,Column_13__c,
                                      Column_14__c,Column_15__c,Column_16__c,Column_17__c,Column_18__c,Column_19__c,Column_20__c
                                      FROM CSV_File_Data__c WHERE Column_01__c =:orderNumber AND Column_14__c =:versionNumber AND Processing_Status__c='Draft'];
                    
                    Integer totalRecCountForProcess = csvFileOrderList.size();
                    system.debug('totalRecCountForProcess:'+totalRecCountForProcess);
                    Integer maxSizeForProcess = 10;  //Change 24-03-2020
                    if(totalRecCountForProcess > 0){
                        for (Integer i = 0; i < (totalRecCountForProcess / maxSizeForProcess) + 1; i++) {                            
                            if(i == 0){
                                csvFileOrderSplitList = new List<CSV_File_Data__c>();
                                for (Integer j = (i * maxSizeForProcess); (j < (i * maxSizeForProcess) + maxSizeForProcess) && j < totalRecCountForProcess; j++) {
                                    csvFileOrderSplitList.add(csvFileOrderList.get(j));
                                }
                            }
                        }
                    }
                }else{
                    List<CSV_File_Data__c> markForFailRecords =[SELECT Id,Purchase_Order__c FROM CSV_File_Data__c WHERE Column_01__c =:orderNumber AND Column_14__c =:versionNumber];
                    String purchaseOderId = '';
                    
                    if(markForFailRecords.size() > 0){
                        List<CSV_File_Data__c> csvFileFailList = new List<CSV_File_Data__c>();
                        for(CSV_File_Data__c recStatus : markForFailRecords){
                            CSV_File_Data__c updateFail = new CSV_File_Data__c();
                            String purchaseOder = updateFail.Purchase_Order__c;
                            if(String.isNotBlank(purchaseOder)){    
                                purchaseOderId = updateFail.Purchase_Order__c;
                            }                            
                            updateFail.Id = recStatus.Id;
                            updateFail.Processing_Status__c = 'Failed';
                            updateFail.Start_Process__c = true;
                            csvFileFailList.add(updateFail);                            
                        }
                        try{
                            update csvFileFailList; 
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
        //system.debug('csvFileOrderSplitListSize:'+csvFileOrderSplitList.size());
        return csvFileOrderSplitList;        
    }
    
    /*
* Delete po order and update all records as invalid.
* @Modified Varun
* */
    public static void updateFailedRecords(string orderNumber, String versionNumber) {
        system.debug('INSIDE THE METHOD updateFailedRecords'+orderNumber);
        List<CSV_File_Data__c> getRecords =[SELECT Id,Purchase_Order__c  FROM CSV_File_Data__c WHERE Column_01__c =:orderNumber AND Column_14__c =:versionNumber];
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
                updateObject.Processing_Status__c = 'Failed';
                updateObject.Start_Process__c = true;
                updateList.add(updateObject);
            }
        }
        try{
            update updateList;
            if(String.isNotBlank(purchaseOderId)){
                //system.debug('DELETE PURCHASE ORDER ID'+purchaseOderId);
                delete[select Id from PurchaseOrder__c where id=:purchaseOderId];
            }
        }catch(DMLException ex){
            System.debug('Exception During Updating failed records::::Error Msg'+ex.getMessage());
        }        
    }    
}