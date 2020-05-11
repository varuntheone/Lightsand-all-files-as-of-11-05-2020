/*
* Author:        Naveen Guleria
* Modification:  Varun (Phase 2 - EMEA Flow)
* Company:       TECHKASETTI
* Description:   Class for processing Decathlon Orderr from baser order table
* History
* <Date>         <Naveen Guleria>   <Class for processing Decathlon Orderr from baser order table>
* <Date>		 17-March-2020  <Varun> <Class for processing Decathlon Orderr from baser order table including EMEA flow>
*/
public class DecathlonOrderProcessor {
    
    @InvocableMethod(label='Decathlon XML Order Process' description='Decathlon XML Order Process')
    public static void processOrder (List<string> inputParams) {
        System.debug('GOT inputParams' +inputParams.size()+ inputParams);
        Boolean enableEmail=true;
        System.debug('Email notification status: ' + enableEmail);
        List<Base_Order__c> BaseOrList=DecathlonOrderProcessor.getBaseOrderdDetails(inputParams);
        if(BaseOrList.size() > 0)
        {
            List<String> sCNUF = new List <String>();
            List<String> cCNUF = new List <String>();
            List<String> externalIds = new List <String>();
            Map<string, String> parentDocIDMap = new Map<String, String>();
            List<Partner__c> supplierCNUFList = new List <Partner__c>();
            List<Customer_Information__c> customerCNUFList = new List <Customer_Information__c >();
            MAP <String, String> customerCNUFMap = new  MAP <String, String>();
            MAP <String, String> supplierCNUFMap = new  MAP <String, String>();
            Map<String, String> failedBaseOrderMap = new Map<String, String>();
            Map<String, String> FinalParentMap = new Map<String, String>();
            Map<String, Base_Order__c> FinalBaseOrderMap = new Map<String, Base_Order__c>();
            Map<String, String>  docIdwithOrderCompanyMap = new  MAP <String, String>();
            Map <Id, Id> duplicateBaseOrderIDMap = new Map<Id,Id>();
            Map<String, String> currencyMap = new Map<String, String>();
            Map<String, String> existingRecordsMap = new Map<String, String>();
            Map<String, String> sendPDFMap = new Map<String, String>();
            List<String> orderToCompany = new List<String>();
            List<Base_Order__c> finalBaseOrderList = new List< Base_Order__c>(); 
            List <Customer_Information__c> newCustList = new List<Customer_Information__c>();
            List<Online_Enquiry__c> finalUpdateParentList = new List<Online_Enquiry__c>();
            List<Online_Detail__c> finalChildInsertList = new List<Online_Detail__c>();            
            Map<String, DateTime> handoverDatTimeMap=new Map<String, DateTime>();
            Map<String, String> childCurrencyPickListMap = new Map<String, String>();
            Map<String, String> childParentMap = new Map<String, String>();
            Map<String, String> ModelIdMap = new Map<String, String>();
            Map <Id,List<Price_Product_by_Currency__c>> priceProductMap = new Map<Id,List<Price_Product_by_Currency__c>>();
            
            Map<String, String> newModelIdMap = getNewModelsList(); //Change 28-04-2020.
            system.debug('newModelIdMap:'+newModelIdMap);
            
            String basOrderId='';
            Boolean customerPresent=false;
            String supFactName='';
            for (Base_Order__c bo : BaseOrList)
            {
                System.debug('GOT BaseOrList' +BaseOrList.size()+ BaseOrList);
                basOrderId=bo.Id;
                if(bo.SupplierParty_CNUF__c!=null && bo.SupplierParty_CNUF__c.length()>0){
                    sCNUF.add(bo.SupplierParty_CNUF__c.trim());
                }
                
                if(bo.CustomerParty_CNUF__c!=null && bo.CustomerParty_CNUF__c.length()>0){
                    cCNUF.add(bo.CustomerParty_CNUF__c.trim());
                    customerPresent=true;
                }else{
                    customerPresent=false;
                }
                externalIds.add(bo.Document_ID__c);
                parentDocIDMap.put(bo.Id, bo.Document_ID__c); 
                
                supFactName = bo.SupplierParty_Name__c;
            }
            System.debug('Customer STATUS for baseorder: ' +basOrderId+' CUSTOMER PRESENT: '+customerPresent);
            System.debug('GOT sCNUF ' +sCNUF.size()+ sCNUF);
            System.debug('GOT cCNUF ' +cCNUF.size()+ cCNUF);
            
            if(sCNUF!=null && sCNUF.size()>0){
                
                system.debug('sCNUF:'+sCNUF);
                RankToOrder_EMEA_Flow__c customData = RankToOrder_EMEA_Flow__c.getInstance();
                string emeaCNUF = customData.EMEA_CNUF__c;  
                string emeaSupFactName = 'Mainetti EMEA';
                for (String suplCNUF : sCNUF){
                    if(emeaCNUF.equalsIgnoreCase(suplCNUF) && emeaSupFactName.equalsIgnoreCase(supFactName)){   
                        
                        List <Base_Order_Detail__c> baseOrdDetailLst =DecathlonOrderProcessor.getBaseOrderdLineItemsDetails(inputParams);
                        for(Base_Order_Detail__c baseDetail: baseOrdDetailLst){
                            String bOrdDetModel = newModelIdMap.get(baseDetail.Model_Id__c); //Change 28-04-2020.
                            String bOrdDetQty = baseDetail.PurchaseOrderLine_Quantity__c;
                            system.debug('bOrdDetModel:'+bOrdDetModel);
                            system.debug('bOrdDetQty:'+bOrdDetQty);
                            String ordToCmp = stockQuantityValidation(bOrdDetModel, bOrdDetQty);
                            system.debug('ordToCmp:'+ordToCmp);
                            List<String> sCNUFbyOrdToCmp = new List <String>();
                            sCNUFbyOrdToCmp = DecathlonOrderProcessor.getSupplierCNUFbyOrdToCmp(ordToCmp);
                            system.debug('sCNUFbyOrdToCmp:'+sCNUFbyOrdToCmp);
                            for(String suppCNUF: sCNUFbyOrdToCmp){
                                for(Base_Order__c baseOrderObj : BaseOrList){
                                    if(emeaCNUF.equalsIgnoreCase(baseOrderObj.SupplierParty_CNUF__c))
                                        baseOrderObj.SupplierParty_CNUF__c = suppCNUF;
                                }
                            }
                            supplierCNUFList=DecathlonOrderProcessor.getSupplierCNUFList(sCNUFbyOrdToCmp);
                        }
                    } else {
                        supplierCNUFList=DecathlonOrderProcessor.getSupplierCNUFList(sCNUF);
                    }
                }               
                //supplierCNUFList=DecathlonOrderProcessor.getSupplierCNUFList(sCNUF);
            }
            
            if(supplierCNUFList!=null && supplierCNUFList.size()> 0 && customerPresent){
                System.debug('CUSTOMER and supplier are NON EMPTY');
                for(Partner__c partner: supplierCNUFList)
                {
                    supplierCNUFMap.put(partner.Decathlon_Code__c+'',partner.Id+'#'+partner.Default_Order_to_Company__c);
                    orderToCompany.add(partner.Default_Order_to_Company__c);                  
                }
                
                customerCNUFMap=DecathlonOrderProcessor.getCustomerCNUFList(cCNUF);
                
                for(Base_Order__c baseOrderObj : BaseOrList)
                {
                    system.debug('supplierCNUFMap:'+supplierCNUFMap);
                    system.debug('baseOrderObj.SupplierParty_CNUF__c:'+baseOrderObj.SupplierParty_CNUF__c);
                    if(supplierCNUFMap.containsKey(baseOrderObj.SupplierParty_CNUF__c)){
                        
                        docIdwithOrderCompanyMap.put(baseOrderObj.Document_ID__c, supplierCNUFMap.get(baseOrderObj.SupplierParty_CNUF__c).substringAfter('#'));
                        
                        if(BaseOrList.size() > customerCNUFMap.size())
                        {
                            if(!customerCNUFMap.containsKey(baseOrderObj.CustomerParty_CNUF__c))
                            {
                                Customer_Information__c customerInformation = DecathlonOrderProcessor.customerInfoFieldAssignment(baseOrderObj);
                                
                                // Add to list
                                newCustList.add(customerInformation);
                            }
                            FinalBaseOrderMap.put(baseOrderObj.Document_ID__c,baseOrderObj);
                            FinalParentMap.put(baseOrderObj.Document_ID__c,baseOrderObj.Document_ID__c);
                        }
                        else{
                            FinalBaseOrderMap.put(baseOrderObj.Document_ID__c,baseOrderObj);
                            FinalParentMap.put(baseOrderObj.Document_ID__c,baseOrderObj.Document_ID__c);
                        }
                        
                    }
                    else{
                        //Mark order failed in the base table
                        failedBaseOrderMap.put(baseOrderObj.Document_ID__c,baseOrderObj.Document_ID__c);
                        if(!duplicateBaseOrderIDMap.containsKey(baseOrderObj.Id))
                        {
                            duplicateBaseOrderIDMap.put(baseOrderObj.Id,baseOrderObj.Id);
                            Base_Order__c boc = new Base_Order__c();
                            boc.id = baseOrderObj.Id;
                            boc.Failure_Reason__c = 'Supplier CNUF is Missing';
                            boc.Processing_Status__c ='Failed';
                            boc.Start_Process__c = false;
                            finalBaseOrderList.add(boc);
                        } 
                        //Send email
                        if(enableEmail){
                            System.debug('Sending Supplier CNUF missing email...');
                            DecathlonOrderProcessor.sendEmail(basOrderId, true, false, false); 
                            System.debug('Sending Supplier CNUF missing email sent.');
                        }
                    }
                }
                
                //Fire child query
                
                List <Base_Order_Detail__c> bDtailList =DecathlonOrderProcessor.getBaseOrderdLineItemsDetails(inputParams);
                list <String> productList = new List<String>();
                Boolean isModelMissing=false;
                if(bDtailList.size() > 0)
                {
                    for (Base_Order_Detail__c bod: bDtailList)
                    {
                        productList.add(bod.Model_Id__c);
                        if(!childCurrencyPickListMap.containsKey(bod.Base_Order__c))
                        {
                            childCurrencyPickListMap.put(bod.Base_Order__c, bod.PurchaseOrderLine_Amount_CurrencyID__c);
                            handoverDatTimeMap.put(bod.Base_Order__c,bod.PurchaseOrderLine_HandoverDateTime__c);
                        }
                        childParentMap.put(bod.Id , bod.Base_Order__c);
                    }
                    Id PriceBookRecordTypeId = DecathlonOrderProcessor.getPriceBookRecordTypeId();
                    system.debug('productList:'+productList);
                    system.debug('PriceBookRecordTypeId:'+PriceBookRecordTypeId);
                    system.debug('orderToCompanyList:'+orderToCompany);
                    List<Price_Specification_Book_Product__c> modelIdList = DecathlonOrderProcessor.getModelsList(productList, orderToCompany, PriceBookRecordTypeId);
                    
                    system.debug('modelIdList.size():'+modelIdList.size());
                    if(modelIdList.size() >0)
                    {
                        for(Price_Specification_Book_Product__c product : modelIdList)
                        {
                            ModelIdMap.put(product.Customer_Ref_Model__c+'#'+product.Order_to_Company__c, product.Id+'');
                            priceProductMap.put(product.Id,product.Price_Product_by_Currency__r);
                        }
                    }
                    
                    //Validate for model exists or not
                    for (Base_Order_Detail__c baseOrder: bDtailList)
                    {
                        String docId = parentDocIDMap.get(childParentMap.get(baseOrder.Id));
                        System.debug('docId:'+docId);
                        if(!failedBaseOrderMap.containsKey(docId)){
                            System.debug('ModelIdMap:'+ModelIdMap);
                            System.debug('MODEL MAP STR...'+baseOrder.Model_Id__c+'#'+docIdwithOrderCompanyMap.get(docId));
                            if(!ModelIdMap.containsKey(baseOrder.Model_Id__c+'#'+docIdwithOrderCompanyMap.get(docId)))
                            {
                                System.debug('Model missing');
                                //Mark base order failed
                                if(!failedBaseOrderMap.containsKey(docId)){
                                    failedBaseOrderMap.put(docId,docId);
                                    if(FinalParentMap.containsKey(docId)){
                                        FinalParentMap.remove(docId);
                                        FinalBaseOrderMap.remove(docId);
                                    }
                                }
                                
                                if(!duplicateBaseOrderIDMap.containsKey(baseOrder.Base_Order__c))
                                {
                                    duplicateBaseOrderIDMap.put(baseOrder.Base_Order__c,baseOrder.Base_Order__c);
                                    isModelMissing=true;
                                    Base_Order__c boc = new Base_Order__c();
                                    boc.id = baseOrder.Base_Order__c;
                                    boc.Failure_Reason__c = 'Model ID is Missing';
                                    boc.Processing_Status__c ='Failed';
                                    boc.Start_Process__c = false;
                                    finalBaseOrderList.add(boc);
                                } 
                            }   
                            else{
                                System.debug('Model present');
                            }
                        }
                    } 
                }
                
                if(isModelMissing){
                    //Send email
                    if(enableEmail){
                        System.debug('Sending model missing email...');
                        DecathlonOrderProcessor.sendEmail(basOrderId, false, false, true); 
                        System.debug('Sending model missing email sent.');
                    }
                }
                
                if(FinalBaseOrderMap!=null && FinalBaseOrderMap.size()>0){
                    System.debug('ADDING RECORDS####################################');    
                    Id retailerID= DecathlonOrderProcessor.getDecathlonRetailerCode();
                    //currencyMap = DecathlonOrderProcessor.getCurrencyPicklistMap();
                    
                    Schema.DescribeFieldResult fieldResult = Online_Enquiry__c.Preferred_Currency__c.getDescribe();
                    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                    System.debug('ple#### '+ple);
                    
                    for( Schema.PicklistEntry pickListVal : ple){
                        currencyMap.put(pickListVal.getLabel().substring(0,3), pickListVal.getLabel());
                    } 
                    String docId='';
                    List<String> existingOE=new List<String>();
                    List<Online_Detail__c> existingChildList=new List<Online_Detail__c>();
                    //Query existing Online Enquiry
                    List<Online_Enquiry__c> existingOnlineEnqueryList = DecathlonOrderProcessor.isOrderRecordExisting(externalIds);
                    if(existingOnlineEnqueryList.size() > 0)
                    {
                        for(Online_Enquiry__c oe : existingOnlineEnqueryList)
                        {
                            existingRecordsMap.put(oe.Customer_PO_No__c, oe.Id);
                            existingOE.add(oe.Id);
                        }
                        //Query existing childs
                        existingChildList= DecathlonOrderProcessor.getExistingChildToBeUpdateList(existingOE);
                    }
                    
                     String supCNUF = '';
                    for(Base_Order__c finalBaseOrder: FinalBaseOrderMap.values()){
                        Online_Enquiry__c onlineEnquiryObj = DecathlonOrderProcessor.onlineEnquiryFieldAssignment(finalBaseOrder, handoverDatTimeMap, customerCNUFMap, supplierCNUFMap, retailerID, childCurrencyPickListMap, currencyMap, existingRecordsMap, bDtailList, newModelIdMap);
                        system.debug('onlineEnquiryObj:'+onlineEnquiryObj);
                        supCNUF = onlineEnquiryObj.SupplierParty_CNUF__c; //EMEA Change purpose.
                        
                        
                        if(onlineEnquiryObj.Enquiry_Status__c.equals('New')){
                            sendPDFMap.put(finalBaseOrder.Document_ID__c,finalBaseOrder.Document_ID__c);
                        }
                        
                        docId = finalBaseOrder.Document_ID__c;
                        finalUpdateParentList.add(onlineEnquiryObj);
                        //Update base order to successs
                        Base_Order__c boc = new Base_Order__c();
                        boc.id = finalBaseOrder.Id;
                        boc.Processing_Status__c ='Success';
                        boc.Failure_Reason__c = '';
                        boc.Start_Process__c = false;
                        finalBaseOrderList.add(boc);
                        
                    }
                    try {
                        
                        if(newCustList!=null && newCustList.size()>0){
                            
                            //Insert Customer
                            Database.SaveResult[] srList = Database.insert(newCustList, false);
                            for (Database.SaveResult sr : srList) {
                                if (sr.isSuccess()) {
                                    // Operation was successful, so get the ID of the record that was processed
                                    System.debug('Successfully inserted Customer Information. Customer Information ID: ' + sr.getId());
                                }
                                else {
                                    // Operation failed, so get all errors                
                                    for(Database.Error err : sr.getErrors()) {
                                        System.debug('The following error has occurred.');                    
                                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                        System.debug('Customer Information fields that affected this error: ' + err.getFields());
                                    }
                                }
                            }
                        }
                        
                        //Upsert parent
                        Database.UpsertResult[] srListParent = Database.upsert(finalUpdateParentList, false);
                        for (Database.UpsertResult sr : srListParent) {
                            if (sr.isSuccess()) {
                                // Operation was successful, so get the ID of the record that was processed
                                System.debug('Successfully inserted Online Enquery. Online Enquery ID: ' + sr.getId());
                            }
                            else {
                                // Operation failed, so get all errors                
                                for(Database.Error err : sr.getErrors()) {
                                    System.debug('The following error has occurred.');                    
                                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                    System.debug('Online Enquery fields that affected this error: ' + err.getFields());
                                }
                            }
                        }
                        
                        Map<String, String> finalInsertedParentMap = new Map<String, String>();
                        for(Online_Enquiry__c onlineEnquiryInserted : finalUpdateParentList)
                        {
                            finalInsertedParentMap.put(onlineEnquiryInserted.Customer_PO_No__c, onlineEnquiryInserted.Id);
                        }
                        System.debug('Check for existing childs'+existingChildList.size());
                        //Check for existing childs
                        if(existingChildList!=null && existingChildList.size()>0){
                            //add to all child list
                            System.debug('existingChildList...'+existingChildList.size()+existingChildList);
                            for(Online_Detail__c existingOnlineDetail: existingChildList){
                                finalChildInsertList.add(existingOnlineDetail);
                            }
                        }
                         System.debug('bDtailList:::'+bDtailList.size());
                        for (Base_Order_Detail__c finalbaseOrder: bDtailList)
                        { 
                            Online_Detail__c onlineDetailObj = DecathlonOrderProcessor.onlineDetailFieldAssignment(finalbaseOrder, ModelIdMap, docIdwithOrderCompanyMap, priceProductMap, docId, finalInsertedParentMap, supCNUF, supFactName);
                            finalChildInsertList.add(onlineDetailObj);
                        }
                           System.debug('finalChildInsertList:::'+finalChildInsertList.size());
                        if(finalChildInsertList!=null && finalChildInsertList.size()>0){
                            
                            System.debug('existingChildList...'+existingChildList.size()+existingChildList);
                            //Upsert child
                            Database.UpsertResult[] srListChaild = Database.upsert(finalChildInsertList, false);
                            for (Database.UpsertResult sr : srListChaild) {
                                if (sr.isSuccess()) {
                                    // Operation was successful, so get the ID of the record that was processed
                                    System.debug('Successfully inserted Online Details. Online Details ID: ' + sr.getId());
                                    
                                }
                                else {
                                    // Operation failed, so get all errors                
                                    for(Database.Error err : sr.getErrors()) {
                                        System.debug('The following error has occurred.');                    
                                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                        System.debug('Online Details fields that affected this error: ' + err.getFields());
                                    }
                                }
                            }
                        }
                         System.debug('BEFORE UPSERT finalBaseOrderList:::'+finalChildInsertList.size());
                        //Upsert Baseorder
                        upsert finalBaseOrderList;
                        
                        //send notification and create pdf for online enquiry status=New
                        if(sendPDFMap.size() > 0)
                        {
                            System.debug('sendPDFMap...'+sendPDFMap.size()+sendPDFMap);
                            for(String key : sendPDFMap.KeySet())
                            {
                                //Utility.getEnquiryPdfContent(finalInsertedParentMap.get(sendPDFMap.get(key)));  
                                DecathlonOrderProcessor.generatePdf(finalInsertedParentMap.get(sendPDFMap.get(key)));
                            }
                        }
                    } catch(Exception e) {
                        System.debug('An exception occurred: ' + e.getMessage());
                        Base_Order__c boc = new Base_Order__c();
                        boc.id = basOrderId;
                        boc.Processing_Status__c ='Failed';
                        boc.Failure_Reason__c = e.getMessage();
                        boc.Start_Process__c = false;
                        upsert boc;
                    }
                    
                    
                    System.debug('docIdwithOrderCompanyMap...'+docIdwithOrderCompanyMap.size()+docIdwithOrderCompanyMap);
                    System.debug('ModelIdMap...'+ModelIdMap.size()+ModelIdMap);
                    System.debug('supplierCNUFMap...'+supplierCNUFMap.size()+supplierCNUFMap);
                    System.debug('customerCNUFMap...'+customerCNUFMap.size()+customerCNUFMap);
                    System.debug('FinalBaseOrderMap...'+FinalBaseOrderMap.size()+FinalBaseOrderMap);
                    System.debug('failedBaseOrderMap...'+failedBaseOrderMap.size()+failedBaseOrderMap);
                    System.debug('finalBaseOrderList...'+finalBaseOrderList.size()+finalBaseOrderList);
                    System.debug('FinalParentMap...'+FinalParentMap.size()+FinalParentMap);            
                    System.debug('finalUpdateParentList###...'+finalUpdateParentList.size()+finalUpdateParentList);
                    System.debug('finalChildInsertList###...'+finalChildInsertList.size()+finalChildInsertList);
                    
                    
                }else{
                    System.debug('No records inserted into online enquiry');
                    //Upsert Baseorder
                    upsert finalBaseOrderList;
                }
                
                
                
                
            }else{
                //Mark order failed in the base table
                
                Base_Order__c boc = new Base_Order__c();
                boc.id = basOrderId;
                if(!customerPresent){  
                    System.debug('Customer Missing...');
                    boc.Failure_Reason__c = 'Customer CNUF is EMPTY';
                }
                else{
                    System.debug('Supplier Missing...');
                    boc.Failure_Reason__c = 'Supplier CNUF is Missing';
                }
                boc.Processing_Status__c ='Failed';
                boc.Start_Process__c = false;
                finalBaseOrderList.add(boc);
                upsert finalBaseOrderList;
                //Send email
                if(enableEmail){   
                    if(!customerPresent){
                        System.debug('Sending Customer CNUF missing email...');
                        DecathlonOrderProcessor.sendEmail(basOrderId, false, true, false);
                        System.debug('Sending Customer CNUF missing email sent.');
                    }else{
                        System.debug('Sending Supplier CNUF missing email...');
                        DecathlonOrderProcessor.sendEmail(basOrderId, true, false, false);
                        System.debug('Sending Supplier CNUF missing email sent.');
                    }    
                }
            }
            
            System.debug('1. Number of Queries used in this Apex code so far: ' + Limits.getQueries());
            System.debug('2. Number of DML rows in this Apex code so far: ' + Limits.getDmlRows());
            System.debug('3. Number of DML statements used so far: ' +  Limits.getDmlStatements());    
            System.debug('4. Amount of CPU time (in ms) used so far: ' + Limits.getCpuTime());
            
        }
    }
    
    @future(callout=true)
    public static void generatePdf(String recId){
        System.debug('Calling FUTURE PDF generator for ' + recId);
        Utility.getEnquiryPdfContent(recId); 
    }
    
    public static void sendEmail(String baseOrderId, Boolean supplierCNUFMissing, Boolean customerCNUFMIssing, Boolean modelIdMissing){
        
        List<String> emailIds= DecathlonOrderProcessor.getNotificationEmailList();
        //List<String> emailIds= new List<String>();
        //emailIds.add('varun.kumar.a@techkasetti.com');
        if(emailIds!=null && emailIds.size()>0){
            System.debug('Notification EMail Ids '+ emailIds.size()+' ' + emailIds);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(emailIds);
            mail.setBccSender(false);
            mail.setSubject('DECATHLON BATCH: Processing for Online Enquiry order failed for base order ID: '+baseOrderId);
            String body = '';
            if(supplierCNUFMissing){
                body = 'Hi <b> Admin</b><p>Processing for Online Enquiry order failed for base order ID: '+baseOrderId+ '<br/><br/><b>Supplier SCNUF is missing</b><br/><br/>Thanks</p>';
            }
            
            if(customerCNUFMIssing){
                body = 'Hi <b> Admin</b><p>Processing for Online Enquiry order failed for base order ID: '+baseOrderId+ '<br/><br/><b>Customer CNUF is empty</b><br/><br/>Thanks</p>';
            }
            
            if(modelIdMissing){
                body = 'Hi <b> Admin</b><p>Processing for Online Enquiry order failed for base order ID: '+baseOrderId+ '<br/><br/><b>Model ID is missing</b><br/><br/>Thanks</p>';
            }
            
            mail.setHtmlBody(body);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }else{
            System.debug('No Notification EMail Ids found' + emailIds.size()+' '+emailIds);
        }
        
    }
    
    public static List<String> getNotificationEmailList(){
        List<String> emailIds=new List<String>();
        List<Decathlon_Email_List__mdt> lst=[SELECT Email__c FROM Decathlon_Email_List__mdt];
        if(lst!=null && lst.size()>0){
            for(Decathlon_Email_List__mdt eachRec:lst){
                emailIds.add(eachRec.Email__c);
            }
        }
        return emailIds;        
    }
    
    /*
public static Boolean validateModel (List<string> inputParams) {
return false;
}

public static Boolean validateSupplierCNUF (List<string> inputParams) {
return false;
}*/
    
    public static Online_Detail__c onlineDetailFieldAssignment(Base_Order_Detail__c bod, Map<String, String> ModelIdMap, Map<String, String>  docIdwithOrderCompanyMap, Map <Id,List<Price_Product_by_Currency__c>> priceProductMap, String docId, Map<String, String> finalInsertedParentMap, String supCNUF, String supFactName){
       System.debug('#################INSIDE onlineDetailFieldAssignment  Base_Order_Detail__c:: '+bod);
         System.debug('################# onlineDetailFieldAssignment  ModelIdMap:: '+ModelIdMap);
          System.debug('################# onlineDetailFieldAssignment  docIdwithOrderCompanyMap:: '+docIdwithOrderCompanyMap);
         System.debug('################# onlineDetailFieldAssignment  priceProductMap:: '+priceProductMap);
          System.debug('################# onlineDetailFieldAssignment  docId:: '+docId);
        System.debug('################# onlineDetailFieldAssignment  finalInsertedParentMap:: '+finalInsertedParentMap);
        Online_Detail__c onlineDetailObj = new Online_Detail__c();
        onlineDetailObj.Online_Details_Status__c = 'New'; 
        onlineDetailObj.TransactionID__c=  finalInsertedParentMap.get(docId); 
         System.debug('################# onlineDetailFieldAssignment  bod.PurchaseOrderLine_LineNumber__c:: '+bod.PurchaseOrderLine_LineNumber__c);
        onlineDetailObj.Retailer_Detail_Line_Number__c=Integer.valueof(bod.PurchaseOrderLine_LineNumber__c.trim());
         System.debug('################# onlineDetailFieldAssignment  bod.Model_Remark__c:: '+bod.Model_Remark__c);
        //added on 11-12-2019
		onlineDetailObj.Model_Remark__c = bod.Model_Remark__c;
        //end
        onlineDetailObj.Qty__c=Integer.valueof(bod.PurchaseOrderLine_Quantity__c.trim());
        //Added new mapping as per new requirement as on April 2 2019
        onlineDetailObj.Retailer_Push_Qty__c=Integer.valueof(bod.PurchaseOrderLine_Quantity__c.trim());
        System.debug('################ INSIDE -------1');    
        List<Price_Product_by_Currency__c> prodCurencyList = priceProductMap.get(ModelIdMap.get(bod.Model_Id__c+'#'+docIdwithOrderCompanyMap.get(docId)));
        
        if(prodCurencyList.size() > 0)
        {
            for(Price_Product_by_Currency__c prodC : prodCurencyList)
            {
                if(prodC.CurrencyIsoCode == bod.PurchaseOrderLine_Amount_CurrencyID__c)
                {
                    onlineDetailObj.Quoted_Currency_Price_100__c=prodC.Price_100_pcs__c;
                }
            }
        }
        System.debug('################ INSIDE -------2'); 
        // 
        onlineDetailObj.Unit_Price_from_xml__c=Double.valueOf(bod.PurchaseOrderLine_Amount__c.trim());
        onlineDetailObj.Expected_Shipped_Date_from_xml__c=bod.PurchaseOrderLine_HandoverDateTime__c;
        onlineDetailObj.UOM__c=bod.PurchaseOrderLine_unitCode__c;
        onlineDetailObj.UOM_Convertion__c=Integer.valueof(bod.PurchaseOrderLine_PerQuantity__c.trim());
        onlineDetailObj.Model__c=ModelIdMap.get(bod.Model_Id__c+'#'+docIdwithOrderCompanyMap.get(docId)) ;  
        onlineDetailObj.Customer_Transport_Type__c=bod.Transport_Type__c;
        //added new mapping for model remark 16-May-2019 Tony
        onlineDetailObj.Model_Remark__c=bod.Model_Remark__c;
        
        /* Modification for EMEA flow starts*/            
        RankToOrder_EMEA_Flow__c customData = RankToOrder_EMEA_Flow__c.getInstance();
        string emeaCNUFItaly = customData.EMEA_CNUF__c; // i.e 12501 for Italy.
        string emeaCNUFNetherlands = '99998'; //Change 24-04-2020.
        string emeaCNUFMorocco = 'P4333';
        string emeaSupFactName = 'Mainetti EMEA';
        system.debug('supCNUF:'+supCNUF); 
        system.debug('supFactName:'+supFactName);
        
        if((emeaCNUFItaly.equalsIgnoreCase(supCNUF) && emeaSupFactName.equalsIgnoreCase(supFactName))
           || (emeaCNUFNetherlands.equalsIgnoreCase(supCNUF) && emeaSupFactName.equalsIgnoreCase(supFactName)) 
           || (emeaCNUFMorocco.equalsIgnoreCase(supCNUF) && emeaSupFactName.equalsIgnoreCase(supFactName))){
            onlineDetailObj.EMEA_flow__c = true;
            onlineDetailObj.EMEA_Order_Date__c = date.today();               
        }
        /* Modification for EMEA flow end*/
        
        return onlineDetailObj;
    }
    
    public static Online_Enquiry__c onlineEnquiryFieldAssignment(Base_Order__c bo, Map<String, DateTime> handoverDatTimeMap, MAP <String, String> customerCNUFMap, MAP <String, String> supplierCNUFMap, Id retailerID, Map<String, String> childCurrencyPickListMap, Map<String, String> currencyMap, Map<String, String> existingRecordsMap,List <Base_Order_Detail__c> bDtailList, Map<String, String> newModelIdMap){
        system.debug('## Inside onlineEnquiryFieldAssignment ##');
        Online_Enquiry__c onlineEnquiryObj = new Online_Enquiry__c();
        String actionCode = bo.Action_Code__c;
        onlineEnquiryObj.D_LogicalID__c=bo.Logical_ID__c;
        onlineEnquiryObj.D_ComponentID__c=bo.Component_ID__c;
        onlineEnquiryObj.Retailer_PO_Creation_Date__c=bo.Creation_Date_Time__c;
        onlineEnquiryObj.Is_Decathlon_Xml_Order_Rec__c=true;
        //onlineEnquiryObj.Expected_Ship_Date__c=bo.
        if(actionCode.equals('Add') || actionCode.equals('Modified')){
            Id decathlonOrderLockedRecordTypeId = Schema.SObjectType.Online_Enquiry__c.getRecordTypeInfosByName().get('Decathlon Order Locked').getRecordTypeId();
            onlineEnquiryObj.Enquiry_Status__c='Pending' ;    
            //onlineEnquiryObj.RecordTypeId='012p00000008H4a'; // Record Type = Decathlon Order Locked
            onlineEnquiryObj.RecordTypeId=decathlonOrderLockedRecordTypeId;
            DateTime handOverDateTimeValue =handoverDatTimeMap.get(bo.Id);
            onlineEnquiryObj.Expected_Ship_Date__c=date.newinstance(handOverDateTimeValue.year(), handOverDateTimeValue.month(), handOverDateTimeValue.day());
            
        } else if(actionCode.equals('Validated'))
        {
            Id decathlonOrderRecordTypeId = Schema.SObjectType.Online_Enquiry__c.getRecordTypeInfosByName().get('Decathlon Order').getRecordTypeId();
            onlineEnquiryObj.Enquiry_Status__c='New';
            //onlineEnquiryObj.RecordTypeId='012p00000008H4V'; // Record Type = Decathlon Order 
            onlineEnquiryObj.RecordTypeId=decathlonOrderRecordTypeId;
            //sendPDFMap.put(bo.Document_ID__c,bo.Document_ID__c);
            DateTime handOverDateTimeValue =handoverDatTimeMap.get(bo.Id);
            onlineEnquiryObj.Expected_Ship_Date__c=date.newinstance(handOverDateTimeValue.year(), handOverDateTimeValue.month(), handOverDateTimeValue.day());
            
            
        } else if(actionCode.equals('Delete'))
        {
            Id decathlonOrderLockedRecordTypeId = Schema.SObjectType.Online_Enquiry__c.getRecordTypeInfosByName().get('Decathlon Order Locked').getRecordTypeId();
            onlineEnquiryObj.Enquiry_Status__c='CANCELLED';
            onlineEnquiryObj.Cancellation_Remark__c=bo.Note__c;
            //onlineEnquiryObj.RecordTypeId='012p00000008H4a'; // Record Type = Decathlon Order Locked
            onlineEnquiryObj.RecordTypeId=decathlonOrderLockedRecordTypeId;
            //deletedChildMap.put(bo.Document_ID__c,bo.Document_ID__c);
        }
        
        if(actionCode.equals('Add') || actionCode.equals('Validated') || actionCode.equals('Modified')){
            onlineEnquiryObj.Customer_Comments__c=bo.Note__c;
        }
        onlineEnquiryobj.Retailer_Code__c=retailerID;
        onlineEnquiryobj.Retailer_Code_Hidden__c='DECATHLON';
        onlineEnquiryObj.Customer_PO_No__c=bo.Document_ID__c;
        //Added for the new field on 11-12-2019
        onlineEnquiryObj.MMG_PO_Number1__c=bo.Document_Customer_Order_Id__c;
        //End
        onlineEnquiryObj.D_CustomerPartyTypeNumber__c=bo.CustomerParty_PartyTypeNumber__c;
        onlineEnquiryObj.D_CustomerPartyNumber__c=bo.CustomerParty_PartyNumber__c;
        onlineEnquiryObj.D_CustomerPartyTypeSubNumber__c=bo.CustomerParty_PartySubNumber__c; 
        
        if(customerCNUFMap.containsKey(bo.CustomerParty_CNUF__c))
        {
            onlineEnquiryObj.Customer_Information__c=customerCNUFMap.get(bo.CustomerParty_CNUF__c);
            onlineEnquiryObj.Manufacturer_Code__c=bo.CustomerParty_CNUF__c;
        }
        
        onlineEnquiryObj.Factory_Name__c=bo.CustomerParty_Name__c;
        onlineEnquiryObj.Bill_to_Company__c=bo.CustomerParty_Name__c;
        onlineEnquiryObj.Bill_to_Address1__c=bo.CustomerParty_BillTo_Address1__c;
        onlineEnquiryObj.Bill_to_Address2__c=bo.CustomerParty_BillTo_Address2__c;
        onlineEnquiryObj.Bill_to_Address3__c=bo.CustomerParty_BillTo_Address3__c;
        onlineEnquiryObj.Bill_to_Address4__c=bo.CustomerParty_BillTo_Address4__c;
        onlineEnquiryObj.Bill_to_State__c=bo.CustomerParty_BillTo_CityName__c;
        onlineEnquiryObj.Bill_to_Country__c=bo.CustomerParty_BillTo_Country_Code__c;
        onlineEnquiryObj.Bill_to_Postcode__c=bo.CustomerParty_BillTo_Postal_Code__c;
        onlineEnquiryObj.Bill_to_Email__c=bo.CustomerParty_BillTo_Email__c;
        onlineEnquiryObj.Bill_to_Tel__c=bo.CustomerParty_BillTo_Telephone__c;
        onlineEnquiryObj.Ship_to_Address1__c=bo.CustomerParty_ShipTo_Address1__c;
        onlineEnquiryObj.Ship_to_Address2__c=bo.CustomerParty_ShipTo_Address2__c;
        onlineEnquiryObj.Ship_To_Address3__c=bo.CustomerParty_ShipTo_Address3__c;
        onlineEnquiryObj.Ship_To_Address4__c=bo.CustomerParty_ShipTo_Address4__c;
        onlineEnquiryObj.Ship_to_State__c=bo.CustomerParty_ShipTo_CityName__c;
        onlineEnquiryObj.Ship_to_Country__c=bo.CustomerParty_ShipTo_Country_Code__c;
        onlineEnquiryObj.Ship_to_Postcode__c=bo.CustomerParty_ShipTo_Postal_Code__c;
        onlineEnquiryObj.Ship_to_Email__c=bo.CustomerParty_ShipTo_Email__c;
        onlineEnquiryObj.Ship_to_Tel__c=bo.CustomerParty_ShipTo_Telephone__c;
        onlineEnquiryObj.D_SupplierPartyTypeNumber__c=bo.SupplierParty_PartyTypeNumber__c;
        onlineEnquiryObj.D_SupplierPartyNumber__c=bo.SupplierParty_PartyNumber__c;
        onlineEnquiryObj.D_SupplierPartySubNumber__c=bo.SupplierParty_PartySubNumber__c;
        onlineEnquiryObj.Export_Term__c='Ex - Work';
        onlineEnquiryObj.SupplierParty_CNUF__c = bo.SupplierParty_CNUF__c; //EMEA Change purpose.
        
        if(supplierCNUFMap.containsKey(bo.SupplierParty_CNUF__c))
        {
            onlineEnquiryObj.D_SupplierPartyCNUF__c= bo.SupplierParty_CNUF__c;
            //Tony add Code
             List<Partner__c> PartnerLookup= [Select Id,Standard_Terms_Condition__c,Local_ERP_Company_Code__c  from Partner__c where Decathlon_Code__c=:bo.SupplierParty_CNUF__c limit 1];
        if(PartnerLookup!=null && PartnerLookup.size()>0 && !PartnerLookup.isEmpty()){
            onlineEnquiryObj.Partner_Id__c = PartnerLookup.get(0).Id;
            onlineEnquiryObj.Sales_Rep_Remark__c = PartnerLookup.get(0).Standard_Terms_Condition__c;
        }
        
            //Tony End Code
            //onlineEnquiryObj.Order_Country__c = supplierCNUFMap.get(bo.SupplierParty_CNUF__c).substringAfter('#'); 
            
                 
            /* Modification for EMEA flow starts*/
            system.debug('supCNUF:'+bo.SupplierParty_CNUF__c);
            RankToOrder_EMEA_Flow__c customData = RankToOrder_EMEA_Flow__c.getInstance();
            string emeaCNUF = customData.EMEA_CNUF__c;
            string emeaSupFactName = 'Mainetti EMEA';
            if(emeaCNUF.equalsIgnoreCase(bo.SupplierParty_CNUF__c) && emeaSupFactName.equalsIgnoreCase(bo.SupplierParty_Name__c)){ //Change 27-04-2020.
                 
                for(Base_Order_Detail__c baseOrdDetail : bDtailList){
                    //String bOrdDetModel =  baseOrdDetail.Model_Description__c;
                    String bOrdDetModel =  newModelIdMap.get(baseOrdDetail.Model_Id__c); //Change 28-04-2020.;
                    String bOrdDetQty = baseOrdDetail.PurchaseOrderLine_Quantity__c;
                    system.debug('bOrdDetModel:'+bOrdDetModel);
                    system.debug('bOrdDetQty:'+bOrdDetQty);
                    if(String.isNotBlank(bOrdDetModel)){
                        //TODO 
                        onlineEnquiryObj.Order_Country__c = stockQuantityValidation(bOrdDetModel,bOrdDetQty);
                    }
                }
                
            } else{
                onlineEnquiryObj.Order_Country__c = supplierCNUFMap.get(bo.SupplierParty_CNUF__c).substringAfter('#');
            }
                
        }
        onlineEnquiryObj.D_SupplierPartyFactoryName__c=bo.SupplierParty_Name__c;
        onlineEnquiryObj.Enquiry_Date__c=date.newinstance(bo.Order_Date_Time__c.year(), bo.Order_Date_Time__c.month(), bo.Order_Date_Time__c.day());
        //Get actual currency from 3 chars for matching - take currency of first child and set to parent\
        //
        //
        //012p00000008H4a
        
        if(childCurrencyPickListMap.containsKey(bo.Id))
        {
            if(currencyMap.containsKey(childCurrencyPickListMap.get(bo.Id)))
                onlineEnquiryObj.Preferred_Currency__c= (currencyMap.get(childCurrencyPickListMap.get(bo.Id)));  
            //childCurrencyPickListMap
        }                  
        
        if(existingRecordsMap.containsKey(bo.Document_ID__c))
        {
            onlineEnquiryObj.id = existingRecordsMap.get(bo.Document_ID__c);
            
        }
        
        return onlineEnquiryObj;
    }
    
    public static Customer_Information__c customerInfoFieldAssignment (Base_Order__c baseOrder) {
        Customer_Information__c customerInformation=new Customer_Information__c();
        customerInformation.Name=baseOrder.CustomerParty_Name__c;
        customerInformation.Preferred_Currency__c= '';
        customerInformation.Bill_to_Company__c=baseOrder.CustomerParty_Name__c;
        customerInformation.Bill_to_Address1__c=baseOrder.CustomerParty_BillTo_Address1__c;
        customerInformation.Bill_to_Address2__c=baseOrder.CustomerParty_BillTo_Address2__c;
        customerInformation.Bill_to_Address3__c=baseOrder.CustomerParty_BillTo_Address3__c;
        customerInformation.Bill_to_Address4__c=baseOrder.CustomerParty_BillTo_Address4__c;
        customerInformation.Bill_to_Country__c=baseOrder.CustomerParty_BillTo_CityName__c;
        customerInformation.Bill_to_State__c=baseOrder.CustomerParty_BillTo_Country_Code__c;
        customerInformation.Bill_to_Postcode__c=baseOrder.CustomerParty_BillTo_Postal_Code__c;
        customerInformation.Bill_to_Email__c=baseOrder.CustomerParty_BillTo_Email__c;
        customerInformation.Bill_to_Tel__c=baseOrder.CustomerParty_BillTo_Telephone__c;
        customerInformation.Ship_to_Company__c=baseOrder.CustomerParty_Name__c;
        customerInformation.Ship_to_Address1__c=baseOrder.CustomerParty_ShipTo_Address1__c;
        customerInformation.Ship_to_Address2__c=baseOrder.CustomerParty_ShipTo_Address2__c;
        customerInformation.Ship_to_Address3__c=baseOrder.CustomerParty_ShipTo_Address3__c;
        customerInformation.Ship_to_Address4__c=baseOrder.CustomerParty_ShipTo_Address4__c;
        customerInformation.Ship_to_Country__c=baseOrder.CustomerParty_ShipTo_CityName__c;
        customerInformation.Ship_to_State__c=baseOrder.CustomerParty_ShipTo_Country_Code__c;
        customerInformation.Ship_to_Postcode__c=baseOrder.CustomerParty_ShipTo_Postal_Code__c;
        customerInformation.Ship_to_Email__c=baseOrder.CustomerParty_ShipTo_Email__c;
        customerInformation.Ship_to_Tel__c=baseOrder.CustomerParty_ShipTo_Telephone__c;
        customerInformation.Customer_Decathlon_Code__c=baseOrder.CustomerParty_CNUF__c;
        return customerInformation;
    }    
    
    public static List<Base_Order__c> getBaseOrderdDetails (List<string> inputParams) {
        
        List<Base_Order__c> baseOrderList=[SELECT Id, Name, Logical_ID__c, Order_Date_Time__c,Component_ID__c, Task_ID__c, Creation_Date_Time__c, Action_Code__c, Document_ID__c, Note__c, Note_Priority_Level__c, XML_File_Name__c, Processing_Status__c, CustomerParty_PartyTypeNumber__c, CustomerParty_PartyNumber__c, CustomerParty_PartySubNumber__c, CustomerParty_CNUF__c, CustomerParty_Name__c, CustomerParty_BillTo_CityName__c, CustomerParty_BillTo_Country_Code__c, CustomerParty_BillTo_Postal_Code__c, CustomerParty_BillTo_Email__c, CustomerParty_BillTo_Telephone__c, CustomerParty_ShipTo_Address1__c, CustomerParty_ShipTo_Address2__c, CustomerParty_ShipTo_Address3__c, CustomerParty_ShipTo_Address4__c, CustomerParty_ShipTo_CityName__c, CustomerParty_ShipTo_Country_Code__c, CustomerParty_ShipTo_Postal_Code__c, CustomerParty_ShipTo_Email__c, CustomerParty_ShipTo_Telephone__c, SupplierParty_PartyTypeNumber__c, SupplierParty_PartyNumber__c, SupplierParty_PartySubNumber__c, SupplierParty_CNUF__c, SupplierParty_Name__c, SupplierParty_OrderDateTime__c, Start_Process__c, TechnicalParty_PartyTypeNumber__c, TechnicalParty_PartyNumber__c, TechnicalParty_PartySubNumber__c, CustomerParty_BillTo_Address1__c, CustomerParty_BillTo_Address2__c, CustomerParty_BillTo_Address3__c, CustomerParty_BillTo_Address4__c,Document_Customer_Order_Id__c FROM Base_Order__c WHERE Id= : inputParams]; 
        
        return baseOrderList;
    } 
    
    public static List<Base_Order_Detail__c> getBaseOrderdLineItemsDetails (List<string> inputParams) {
        List <Base_Order_Detail__c> bDtailList = [SELECT Id, Name, Model_Description__c, PurchaseOrderLine_LineNumber__c, Model_Id__c, Model_Remark__c,PurchaseOrderLine_Quantity__c, PurchaseOrderLine_Amount_CurrencyID__c, PurchaseOrderLine_Amount__c, PurchaseOrderLine_unitCode__c, PurchaseOrderLine_PerQuantity__c, PurchaseOrderLine_HandoverDateTime__c,Base_Order__c,Transport_Type__c FROM Base_Order_Detail__c WHERE Base_Order__c = :inputParams];
        return bDtailList;
    }
    
    public static List<Price_Specification_Book_Product__c> getModelsList(list <String> prodList, List<String> orderToCompany, Id PriceBookRecordTypeId){
        List<Price_Specification_Book_Product__c> modelIdList=[SELECT Id, name, Order_to_Company__c, CurrencyIsoCode, Customer_Ref_Model__c, Price_Specification_Book__r.name, 
                                                               (select id, CurrencyIsoCode, Price_100_pcs__c from Price_Product_by_Currency__r ) FROM Price_Specification_Book_Product__c 
                                                               where Price_Specification_Book__r.Book_Status__c='Active' and Price_Specification_Book__r.RecordTypeId= :PriceBookRecordTypeId
                                                               and Product_Status__c='Active' and Price_Specification_Book__r.Account__r.name='DECATHLON' and 
                                                               Customer_Ref_Model__c = :prodList and Order_to_Company__c = :orderToCompany];
        return modelIdList;
    }
    
    public static Map<String, String> getNewModelsList(){        
        Map<String, String> newModelIdMap = new Map<String, String>();
        Id PriceBookRecordTypeId = DecathlonOrderProcessor.getPriceBookRecordTypeId();
        List<Price_Specification_Book_Product__c> modelIdList=[SELECT Id, name, Customer_Ref_Model__c FROM Price_Specification_Book_Product__c 
                                                               where Price_Specification_Book__r.Book_Status__c='Active' and Price_Specification_Book__r.RecordTypeId= :PriceBookRecordTypeId
                                                               and Product_Status__c='Active' and Price_Specification_Book__r.Account__r.name='DECATHLON'
                                                              and name <> null and Customer_Ref_Model__c <> null];
        
        system.debug('modelIdList.size():'+modelIdList.size());
        if(modelIdList.size() >0)
        {
            for(Price_Specification_Book_Product__c product : modelIdList)
            {
                newModelIdMap.put(product.Customer_Ref_Model__c, product.name);
            }
        }
        //system.debug('newModelIdMap:'+newModelIdMap);
        return newModelIdMap;
    }
    
    public static List<Online_Detail__c>  getExistingChildToBeUpdateList(List<String> onlineEnquery){
        List<Online_Detail__c> finalChildUpdateList = new List<Online_Detail__c>();
        List<Online_Detail__c> existingChildList = [SELECT Id FROM Online_Detail__c WHERE TransactionID__c IN : onlineEnquery AND Online_Details_Status__c = 'New'];
        
        if(existingChildList.size() >0 )
        {
            for(Online_Detail__c od : existingChildList)
            {
                od.Online_Details_Status__c = 'Cancel';
                finalChildUpdateList.add(od);
            }
        }
        
        return finalChildUpdateList;
    }
    
    public static Id getDecathlonRetailerCode(){
        Retailer_Code__c retailerCode  = [select id from Retailer_Code__c where name='DECATHLON'];
        Id retailerID ; 
        if(retailerCode != null)
        {
            retailerID =  retailerCode.Id;  
        }
        return retailerID;
    }
    
    public static Id getPriceBookRecordTypeId(){
        Id PriceBookRecordTypeId = Schema.SObjectType.Price_Specification_Book__c.getRecordTypeInfosByName().get('Price Book').getRecordTypeId();
        return PriceBookRecordTypeId;
    }
    
    public static List <Online_Enquiry__c> isOrderRecordExisting(List<String> externalIds){      
        List <Online_Enquiry__c> onlineEnquery = [SELECT Id, Customer_PO_No__c FROM Online_Enquiry__c WHERE Customer_PO_No__c= : externalIds];
        return onlineEnquery;
    }
    /*
public static Map<String, String> getCurrencyPicklistMap(){
Map<String, String> currencyMap1=new Map<String, String>();
Schema.DescribeFieldResult fieldResult = Online_Enquiry__c.Preferred_Currency__c.getDescribe();
List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

for( Schema.PicklistEntry pickListVal : ple){
currencyMap1.put(pickListVal.getLabel().substring(0,3), pickListVal.getLabel());
} 
return currencyMap1;
}*/
    
    public static List<Partner__c> getSupplierCNUFList(List<String> sCNUF){
        List<Partner__c> supplierCNUFList=new List<Partner__c>();
        System.debug('GOT sCNUF' +sCNUF.size()+ sCNUF);
        if(sCNUF!=null && sCNUF.size()>0){
            supplierCNUFList = [Select Id, Decathlon_Code__c, Default_Order_to_Company__c  from Partner__c 
                                where RecordType.Name IN ('Mainetti Company', 'Licensee Partner') 
                                and Decathlon_Code__c= : sCNUF];
        }
        System.debug('GOT supplierCNUFList ' +supplierCNUFList.size()+ supplierCNUFList);
        return supplierCNUFList;
    }
    
    public static List<String> getSupplierCNUFbyOrdToCmp(String ordToCmp){
        List<Partner__c> supplierCNUFList=new List<Partner__c>();
        List<String> supCNUFList=new List<String>();
        if(String.isNotBlank(ordToCmp)){
            supplierCNUFList = [Select Decathlon_Code__c from Partner__c 
                                where RecordType.Name IN ('Mainetti Company', 'Licensee Partner') 
                                and Default_Order_to_Company__c= : ordToCmp];
            
            if(supplierCNUFList!=null && supplierCNUFList.size()>0){
                for(Partner__c supCNUF : supplierCNUFList){
                    supCNUFList.add(supCNUF.Decathlon_Code__c);
                }
            }
        }
        System.debug('GOT supplierCNUFListByOrdToCmp ' +supCNUFList.size()+ supCNUFList);
        return supCNUFList;
    }
    
    
    public static MAP <String, String> getCustomerCNUFList(List<String> cCNUF){
        MAP <String, String> custCNUFMap = new  MAP <String, String>();
        if(cCNUF!=null && cCNUF.size()>0){
            List<Customer_Information__c> customerCNUFList = [Select Id, Customer_Decathlon_Code__c from Customer_Information__c where 
                                                              Customer_Decathlon_Code__c = : cCNUF ];
            if(customerCNUFList.size() >0 )
            {
                for(Customer_Information__c custInfo: customerCNUFList)
                {
                    custCNUFMap.put(custInfo.Customer_Decathlon_Code__c,custInfo.Id);
                }
            }
        }
        
        
        return custCNUFMap;
    }
    
    	/*
	 * The below method will do EMEA Assignment Validation for the stock.
     * */
    public static String stockQuantityValidation(String model, String orderQuantity){
        System.debug('## Inside stockQuantityValidation ##');
        
        RankToOrder_EMEA_Flow__c customData = RankToOrder_EMEA_Flow__c.getInstance(); // Get values from custom settings.
        String italyOrdToCmp = customData.First_Priority_OrdToCmp__c;
        String netherlandsOrdToCmp = customData.Second_Priority_OrdToCmp__c;
        String moroccoOrdToCmp = customData.Third_Priority_OrdToCmp__c;
        
        String oderToCompany = moroccoOrdToCmp.substringAfter('#'); //Morocco as default.
        Double sumOfQtyItalyForCurWeek = checkItalyOrderQuantityForCurrWeek(model);
        Double availQuantityItalyForCurWeek = checkItalyForAvailableStockQuantityForCurrWeek(model);
        system.debug('sumOfQtyItalyForCurWeek:'+sumOfQtyItalyForCurWeek);
        system.debug('availQuantityItalyForCurWeek:'+availQuantityItalyForCurWeek);
        
        Double ordQty = Double.valueOf(orderQuantity);
        
        if(availQuantityItalyForCurWeek != null){
            //Current week for Italy.
            if(availQuantityItalyForCurWeek >= sumOfQtyItalyForCurWeek + ordQty){
                oderToCompany = italyOrdToCmp.substringAfter('#');
            } else {				
                Double sumOfQtyNetherlandsForCurWeek = checkNetherlandsOrderQuantityForCurrWeek(model);
                Double availQuantityNetherlandsForCurWeek = checkNetherlandsForAvailableStockQuantityForCurrWeek(model);
                system.debug('sumOfQtyNetherlandsForCurWeek:'+sumOfQtyNetherlandsForCurWeek);
                system.debug('availQuantityNetherlandsForCurWeek:'+availQuantityNetherlandsForCurWeek);
                if(availQuantityNetherlandsForCurWeek != null){
                    //Current week for Netherlands.
                    if(availQuantityNetherlandsForCurWeek >= sumOfQtyNetherlandsForCurWeek + ordQty){
                        oderToCompany = netherlandsOrdToCmp.substringAfter('#');
                    }
                } else {
                    //Previous week for Netherlands.
                    Double sumOfQtyNetherlandsForPrevWeek = checkNetherlandsOrderQuantityForPrevWeek(model);
                    Double availQuantityNetherlandsForPrevWeek = checkNetherlandsForAvailableStockQuantityForPrevWeek(model);
                    system.debug('sumOfQtyNetherlandsForPrevWeek:'+sumOfQtyNetherlandsForPrevWeek);
                    system.debug('availQuantityNetherlandsForPrevWeek:'+availQuantityNetherlandsForPrevWeek);
                    if(availQuantityNetherlandsForPrevWeek >= sumOfQtyNetherlandsForPrevWeek + ordQty){
                        oderToCompany = netherlandsOrdToCmp.substringAfter('#');
                    }
                }
            }
        } else {
            //Previous week for Italy.
            Double sumOfQtyItalyForPrevWeek = checkItalyOrderQuantityForPrevWeek(model);
            Double availQuantityItalyForPrevWeek = checkItalyForAvailableStockQuantityForPrevWeek(model);
            system.debug('sumOfQtyItalyForPrevWeek:'+sumOfQtyItalyForPrevWeek);
            system.debug('availQuantityItalyForPrevWeek:'+availQuantityItalyForPrevWeek);
            if(availQuantityItalyForPrevWeek >= sumOfQtyItalyForPrevWeek + ordQty){
                oderToCompany = italyOrdToCmp.substringAfter('#');
            } else {
                Double sumOfQtyNetherlandsForCurWeek = checkNetherlandsOrderQuantityForCurrWeek(model);
                Double availQuantityNetherlandsForCurWeek = checkNetherlandsForAvailableStockQuantityForCurrWeek(model);
                system.debug('sumOfQtyNetherlandsForCurWeek:'+sumOfQtyNetherlandsForCurWeek);
                system.debug('availQuantityNetherlandsForCurWeek:'+availQuantityNetherlandsForCurWeek);
                if(availQuantityNetherlandsForCurWeek != null){
                    //Current week for Netherlands.
                    if(availQuantityNetherlandsForCurWeek >= sumOfQtyNetherlandsForCurWeek + ordQty){
                        oderToCompany = netherlandsOrdToCmp.substringAfter('#');
                    }
                } else {
                    //Previous week for Netherlands.
                    Double sumOfQtyNetherlandsForPrevWeek = checkNetherlandsOrderQuantityForPrevWeek(model);
                    Double availQuantityNetherlandsForPrevWeek = checkNetherlandsForAvailableStockQuantityForPrevWeek(model);
                    system.debug('sumOfQtyNetherlandsForPrevWeek:'+sumOfQtyNetherlandsForPrevWeek);
                    system.debug('availQuantityNetherlandsForPrevWeek:'+availQuantityNetherlandsForPrevWeek);
                    if(availQuantityNetherlandsForPrevWeek >= sumOfQtyNetherlandsForPrevWeek + ordQty){
                        oderToCompany = netherlandsOrdToCmp.substringAfter('#');
                    }
                }
            }
        }
        system.debug('oderToCompany:'+oderToCompany);
        return oderToCompany;
    }

    public static Double checkItalyOrderQuantityForCurrWeek(String model){
        system.debug('## Inside checkItalyOrderQuantityForCurrWeek ##');
		 Date startdate = date.today();
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        system.debug('weekStartDate:'+weekStartDate);
        system.debug('weekEndDate:'+weekEndDate);
        
        Double onDetailQty;
        Double allocatedQty;
        
        AggregateResult[] onlineDetail = [Select sum(Qty__c) qty from Online_Detail__c where Model__r.Name =:model and Country__c='Italy'
                                          and EMEA_Order_Date__c >=:weekStartDate and EMEA_Order_Date__c <=:weekEndDate
                                          and EMEA_flow__c=true ];
        
        system.debug('onlineDetail:'+onlineDetail);
        for (AggregateResult onDetail : onlineDetail){
            onDetailQty = Double.valueOf(onDetail.get('qty'));
            system.debug('onDetail.getQty:'+onDetail.get('qty'));
        }
        

        /*AggregateResult[] invAllocation = [Select Sum(Quantity__c) Quantity  FROM Inventory_Allocation__c 
                                           WHERE ((Inventory_Allocation_Demand__r.Mainetti_Model__r.Name =:model AND Inventory_Allocation_Demand__r.Order_to_Company__c ='Italy - Mainetti SpA')
                                                  OR (Inventory_Allocation_Supply__r.Mainetti_Model__r.Name =:model AND Inventory_Allocation_Supply__r.Mainetti_Company__c = 'Italy - Mainetti SpA'))
                                          AND CreatedDate >=:weekStartDate AND CreatedDate <=:weekEndDate];
        
        for (AggregateResult allocation : invAllocation){
            allocatedQty = Double.valueOf(allocation.get('Quantity'));
        }*/
        
        //Double sumOfQtyItaly = onDetailQty + allocatedQty;
        if(onDetailQty == null){
            onDetailQty = 0;
        }            
        
		Double sumOfQtyItaly = onDetailQty;

		return sumOfQtyItaly;

	 }

	 public static Double checkItalyOrderQuantityForPrevWeek(String model){
         system.debug('## Inside checkItalyOrderQuantityForPrevWeek ##');
		 Date startdate = date.today();
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
        Date weekStartDate = todaydateinstance.adddays(-7).toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();

		Double onDetailQty;
        Double allocatedQty;

		AggregateResult[] onlineDetail = [Select sum(Qty__c) qty from Online_Detail__c where Model__r.Name =:model and Country__c='Italy'
                                          and EMEA_Order_Date__c >=:weekStartDate and EMEA_Order_Date__c <=:weekEndDate
                                          and EMEA_flow__c=true ];
        
        for (AggregateResult onDetail : onlineDetail){
            onDetailQty = Double.valueOf(onDetail.get('qty'));
        }
        

        /*AggregateResult[] invAllocation = [Select Sum(Quantity__c) Quantity  FROM Inventory_Allocation__c 
                                           WHERE ((Inventory_Allocation_Demand__r.Mainetti_Model__r.Name =:model AND Inventory_Allocation_Demand__r.Order_to_Company__c ='Italy - Mainetti SpA')
                                                  OR (Inventory_Allocation_Supply__r.Mainetti_Model__r.Name =:model AND Inventory_Allocation_Supply__r.Mainetti_Company__c = 'Italy - Mainetti SpA'))
                                          AND CreatedDate >=:weekStartDate AND CreatedDate <=:weekEndDate];
        
        for (AggregateResult allocation : invAllocation){
            allocatedQty = Double.valueOf(allocation.get('Quantity'));
        }*/
        
        //Double sumOfQtyItaly = onDetailQty + allocatedQty;
        if(onDetailQty == null){
            onDetailQty = 0;
        }
		Double sumOfQtyItaly = onDetailQty;

		return sumOfQtyItaly;
	 }
    
    /*
     * Below method will get available quantity form Italy.
     * 
     * */
    public static Double checkItalyForAvailableStockQuantityForCurrWeek(String model){ 
        system.debug('## Inside checkItalyForAvailableStockQuantityForCurrWeek ##');
        //String model;
        Date startdate = date.today();
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        Double availQuantity;
        RankToOrder_EMEA_Flow__c customData = RankToOrder_EMEA_Flow__c.getInstance(); // Get values from custom settings.
        String italyMainettiCmp = customData.First_Priority_MainettiCmp__c;
        
        AggregateResult[] inventoryStock = [Select Sum(Stock_In_Qty__c) Quantity  FROM Data_Upload_Transaction__c
                                           WHERE Mainetti_Company__r.Name =:italyMainettiCmp AND Inventory_Model__r.Name =:model
                                           AND Stock_In_Date__c >=:weekStartDate AND Stock_In_Date__c <=:weekEndDate];
        
        for (AggregateResult invStock : inventoryStock){
            availQuantity = Double.valueOf(invStock.get('Quantity'));
        }
        return availQuantity;
    }

	public static Double checkItalyForAvailableStockQuantityForPrevWeek(String model){ 
        system.debug('## Inside checkItalyForAvailableStockQuantityForPrevWeek ##');
        //String model;
        Date startdate = date.today();
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
        Date weekStartDate = todaydateinstance.adddays(-7).toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        Double availQuantity;
        RankToOrder_EMEA_Flow__c customData = RankToOrder_EMEA_Flow__c.getInstance(); // Get values from custom settings.
        String italyMainettiCmp = customData.First_Priority_MainettiCmp__c;
        
        AggregateResult[] inventoryStock = [Select Sum(Stock_In_Qty__c) Quantity  FROM Data_Upload_Transaction__c
                                           WHERE Mainetti_Company__r.Name =:italyMainettiCmp AND Inventory_Model__r.Name =:model
                                           AND Stock_In_Date__c >=:weekStartDate AND Stock_In_Date__c <=:weekEndDate];
        
        for (AggregateResult invStock : inventoryStock){
            availQuantity = Double.valueOf(invStock.get('Quantity'));
        }
        return availQuantity;
    }
    
    public static Double checkNetherlandsOrderQuantityForCurrWeek(String model){
        system.debug('## Inside checkNetherlandsOrderQuantityForCurrWeek ##');
		 Date startdate = date.today();
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        Double onDetailQty;
        Double allocatedQty;
        
        AggregateResult[] onlineDetail = [Select sum(Qty__c) qty from Online_Detail__c where Model__r.Name =:model and Country__c='Netherlands'
                                          and EMEA_Order_Date__c >=:weekStartDate and EMEA_Order_Date__c <=:weekEndDate
                                          and EMEA_flow__c=true ];
        
        for (AggregateResult onDetail : onlineDetail){
            onDetailQty = Double.valueOf(onDetail.get('qty'));
        }
        

        /*AggregateResult[] invAllocation = [Select Sum(Quantity__c) Quantity  FROM Inventory_Allocation__c 
                                           WHERE ((Inventory_Allocation_Demand__r.Mainetti_Model__r.Name =:model AND Inventory_Allocation_Demand__r.Order_to_Company__c ='Netherlands - Mainetti BV')
                                                  OR (Inventory_Allocation_Supply__r.Mainetti_Model__r.Name =:model AND Inventory_Allocation_Supply__r.Mainetti_Company__c = 'Netherlands - Mainetti BV'))
                                          AND CreatedDate >=:weekStartDate AND CreatedDate <=:weekEndDate];
        
        for (AggregateResult allocation : invAllocation){
            allocatedQty = Double.valueOf(allocation.get('Quantity'));
        }*/
        
        //Double sumOfQtyItaly = onDetailQty + allocatedQty;
        if(onDetailQty == null){
            onDetailQty = 0;
        }
        
		Double sumOfQtyItaly = onDetailQty;

		return sumOfQtyItaly;

	 }

	 public static Double checkNetherlandsOrderQuantityForPrevWeek(String model){
         system.debug('## Inside checkNetherlandsOrderQuantityForPrevWeek ##');
		 Date startdate = date.today();
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        Double onDetailQty;
        Double allocatedQty;
        
        AggregateResult[] onlineDetail = [Select sum(Qty__c) qty from Online_Detail__c where Model__r.Name =:model and Country__c='Netherlands'
                                          and EMEA_Order_Date__c >=:weekStartDate and EMEA_Order_Date__c <=:weekEndDate
                                          and EMEA_flow__c=true ];
        
        for (AggregateResult onDetail : onlineDetail){
            onDetailQty = Double.valueOf(onDetail.get('qty'));
        }
        

        /*AggregateResult[] invAllocation = [Select Sum(Quantity__c) Quantity  FROM Inventory_Allocation__c 
                                           WHERE ((Inventory_Allocation_Demand__r.Mainetti_Model__r.Name =:model AND Inventory_Allocation_Demand__r.Order_to_Company__c ='Netherlands - Mainetti BV')
                                                  OR (Inventory_Allocation_Supply__r.Mainetti_Model__r.Name =:model AND Inventory_Allocation_Supply__r.Mainetti_Company__c = 'Netherlands - Mainetti BV'))
                                          AND CreatedDate >=:weekStartDate AND CreatedDate <=:weekEndDate];
        
        for (AggregateResult allocation : invAllocation){
            allocatedQty = Double.valueOf(allocation.get('Quantity'));
        }*/
        
        //Double sumOfQtyItaly = onDetailQty + allocatedQty;
        if(onDetailQty == null){
            onDetailQty = 0;
        }
         
		Double sumOfQtyItaly = onDetailQty;

		return sumOfQtyItaly;
	 }
    
    /*
     * Below method will get available quantity form Netherlands.
     * 
     * */
    public static Double checkNetherlandsForAvailableStockQuantityForCurrWeek(String model){ 
        system.debug('## Inside checkNetherlandsForAvailableStockQuantityForCurrWeek ##');
        //String model;
        Date startdate = date.today();
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        Double availQuantity;
        RankToOrder_EMEA_Flow__c customData = RankToOrder_EMEA_Flow__c.getInstance(); // Get values from custom settings.
        String netherlandsMainettiCmp = customData.Second_Priority_MainettiCmp__c;
        
        AggregateResult[] inventoryStock = [Select Sum(Stock_In_Qty__c) Quantity  FROM Data_Upload_Transaction__c
                                           WHERE Mainetti_Company__r.Name =:netherlandsMainettiCmp AND Inventory_Model__r.Name =:model
                                           AND Stock_In_Date__c >=:weekStartDate AND Stock_In_Date__c <=:weekEndDate];
        
        for (AggregateResult invStock : inventoryStock){
            availQuantity = Double.valueOf(invStock.get('Quantity'));
        }
        return availQuantity;
    }

	public static Double checkNetherlandsForAvailableStockQuantityForPrevWeek(String model){ 
        system.debug('## Inside checkNetherlandsForAvailableStockQuantityForPrevWeek ##');
        //String model;
        Date startdate = date.today();
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
        Date weekStartDate = todaydateinstance.adddays(-7).toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        Double availQuantity;
        RankToOrder_EMEA_Flow__c customData = RankToOrder_EMEA_Flow__c.getInstance(); // Get values from custom settings.
        String netherlandsMainettiCmp = customData.Second_Priority_MainettiCmp__c;
        
        AggregateResult[] inventoryStock = [Select Sum(Stock_In_Qty__c) Quantity  FROM Data_Upload_Transaction__c
                                           WHERE Mainetti_Company__r.Name =:netherlandsMainettiCmp AND Inventory_Model__r.Name =:model
                                           AND Stock_In_Date__c >=:weekStartDate AND Stock_In_Date__c <=:weekEndDate];
        
        for (AggregateResult invStock : inventoryStock){
            availQuantity = Double.valueOf(invStock.get('Quantity'));
        }
        return availQuantity;
    }
    
}