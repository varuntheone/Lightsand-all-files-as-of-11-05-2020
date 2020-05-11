public class OnLineEnquiryOrderProcess {
    
    @InvocableMethod(label='On Line Enquiry Order Process' description='On Line Enquiry Order Process')
    public static List<String> OnLineEnquiryOrderProcess (List<string> inputParams) {
        System.debug('inputParams..'+inputParams);
       // Map<string, String> duplicateParentDocIDMap = new Map<String, String>();
        Boolean actionFlag = false;
        List<String> pdfList=new List<String>();
        for(Integer i =0 ; i < 2 ; i++)
        {
            List<Base_Order__c> BaseOrList = new List< Base_Order__c>(); 
            //List<Base_Order__c> BaseOrListTemp = new List< Base_Order__c>(); 
            // 1 Base Order List Query to process 
            
            if(i ==0)
            {
                actionFlag = true;
                System.debug('Inside Add IF');
                BaseOrList = [SELECT Id, Name, Logical_ID__c, Order_Date_Time__c,Component_ID__c, Task_ID__c, Creation_Date_Time__c, Action_Code__c, Document_ID__c, Note__c, Note_Priority_Level__c, XML_File_Name__c, Processing_Status__c, CustomerParty_PartyTypeNumber__c, CustomerParty_PartyNumber__c, CustomerParty_PartySubNumber__c, CustomerParty_CNUF__c, CustomerParty_Name__c, CustomerParty_BillTo_CityName__c, CustomerParty_BillTo_Country_Code__c, CustomerParty_BillTo_Postal_Code__c, CustomerParty_BillTo_Email__c, CustomerParty_BillTo_Telephone__c, CustomerParty_ShipTo_Address1__c, CustomerParty_ShipTo_Address2__c, CustomerParty_ShipTo_Address3__c, CustomerParty_ShipTo_Address4__c, CustomerParty_ShipTo_CityName__c, CustomerParty_ShipTo_Country_Code__c, CustomerParty_ShipTo_Postal_Code__c, CustomerParty_ShipTo_Email__c, CustomerParty_ShipTo_Telephone__c, SupplierParty_PartyTypeNumber__c, SupplierParty_PartyNumber__c, SupplierParty_PartySubNumber__c, SupplierParty_CNUF__c, SupplierParty_Name__c, SupplierParty_OrderDateTime__c, Start_Process__c, TechnicalParty_PartyTypeNumber__c, TechnicalParty_PartyNumber__c, TechnicalParty_PartySubNumber__c, CustomerParty_BillTo_Address1__c, CustomerParty_BillTo_Address2__c, CustomerParty_BillTo_Address3__c, CustomerParty_BillTo_Address4__c FROM Base_Order__c WHERE   Action_Code__c  = 'ADD'  AND Id= : inputParams]; 
            }else
            {
                actionFlag = false;
                System.debug('Inside Else');
                //BaseOrList = [SELECT Id, Name, Logical_ID__c, Order_Date_Time__c,Component_ID__c, Task_ID__c, Creation_Date_Time__c, Action_Code__c, Document_ID__c, Note__c, Note_Priority_Level__c, XML_File_Name__c, Processing_Status__c, CustomerParty_PartyTypeNumber__c, CustomerParty_PartyNumber__c, CustomerParty_PartySubNumber__c, CustomerParty_CNUF__c, CustomerParty_Name__c, CustomerParty_BillTo_CityName__c, CustomerParty_BillTo_Country_Code__c, CustomerParty_BillTo_Postal_Code__c, CustomerParty_BillTo_Email__c, CustomerParty_BillTo_Telephone__c, CustomerParty_ShipTo_Address1__c, CustomerParty_ShipTo_Address2__c, CustomerParty_ShipTo_Address3__c, CustomerParty_ShipTo_Address4__c, CustomerParty_ShipTo_CityName__c, CustomerParty_ShipTo_Country_Code__c, CustomerParty_ShipTo_Postal_Code__c, CustomerParty_ShipTo_Email__c, CustomerParty_ShipTo_Telephone__c, SupplierParty_PartyTypeNumber__c, SupplierParty_PartyNumber__c, SupplierParty_PartySubNumber__c, SupplierParty_CNUF__c, SupplierParty_Name__c, SupplierParty_OrderDateTime__c, Start_Process__c, TechnicalParty_PartyTypeNumber__c, TechnicalParty_PartyNumber__c, TechnicalParty_PartySubNumber__c, CustomerParty_BillTo_Address1__c, CustomerParty_BillTo_Address2__c, CustomerParty_BillTo_Address3__c, CustomerParty_BillTo_Address4__c FROM Base_Order__c WHERE    Action_Code__c  != 'ADD'  AND Id= : inputParams];              
            	//Added order by
                BaseOrList = [SELECT Id, Name, Logical_ID__c, Order_Date_Time__c,Component_ID__c, Task_ID__c, Creation_Date_Time__c, Action_Code__c, Document_ID__c, Note__c, Note_Priority_Level__c, XML_File_Name__c, Processing_Status__c, CustomerParty_PartyTypeNumber__c, CustomerParty_PartyNumber__c, CustomerParty_PartySubNumber__c, CustomerParty_CNUF__c, CustomerParty_Name__c, CustomerParty_BillTo_CityName__c, CustomerParty_BillTo_Country_Code__c, CustomerParty_BillTo_Postal_Code__c, CustomerParty_BillTo_Email__c, CustomerParty_BillTo_Telephone__c, CustomerParty_ShipTo_Address1__c, CustomerParty_ShipTo_Address2__c, CustomerParty_ShipTo_Address3__c, CustomerParty_ShipTo_Address4__c, CustomerParty_ShipTo_CityName__c, CustomerParty_ShipTo_Country_Code__c, CustomerParty_ShipTo_Postal_Code__c, CustomerParty_ShipTo_Email__c, CustomerParty_ShipTo_Telephone__c, SupplierParty_PartyTypeNumber__c, SupplierParty_PartyNumber__c, SupplierParty_PartySubNumber__c, SupplierParty_CNUF__c, SupplierParty_Name__c, SupplierParty_OrderDateTime__c, Start_Process__c, TechnicalParty_PartyTypeNumber__c, TechnicalParty_PartyNumber__c, TechnicalParty_PartySubNumber__c, CustomerParty_BillTo_Address1__c, CustomerParty_BillTo_Address2__c, CustomerParty_BillTo_Address3__c, CustomerParty_BillTo_Address4__c FROM Base_Order__c WHERE    Action_Code__c  != 'ADD'  AND Id= : inputParams order by Creation_Date_Time__c]; 
                //filer base oreder list for duplicates
                /*
                System.debug('BASE order list BEFORE ####### '+BaseOrList.size()+BaseOrList);
                IF(BaseOrList.size() > 0)
                {
                    for(Base_Order__c baseOrderTemp:BaseOrList){
                        IF(!duplicateParentDocIDMap.containsKey(baseOrderTemp.Document_ID__c)){
                            duplicateParentDocIDMap.put(baseOrderTemp.Document_ID__c, baseOrderTemp.Id);  
                            BaseOrListTemp.add(baseOrderTemp);
                        }
     
                    }
                    System.debug('duplicateParentDocIDMap### '+duplicateParentDocIDMap.size()+duplicateParentDocIDMap);
                    BaseOrList = BaseOrListTemp;
                    System.debug('Unique Base order list'+BaseOrList.size()+BaseOrList);
                    
                }*/
            
            }
            System.debug('BaseOrList...'+BaseOrList);
            List <Online_Enquiry__c> onlineEnquery = New List<Online_Enquiry__c>();
            List<String> externalIds = new List <String>();
            List<String> sCNUF = new List <String>();
            List<String> cCNUF = new List <String>();
            List<String> ValidateList = new List <String>();
            List<String> deleteList = new List <String>();
            List<Partner__c> SfsupCNUF = new List <Partner__c>();
            Map<String, String> FinalParentMap = new Map<String, String>();
            Map<String, String> FaieldParentMap = new Map<String, String>();
            Map<string, String> parentDocIDMap = new Map<String, String>();
            List<Base_Order__c> faildBaseOrList = new List< Base_Order__c>(); 
            List<Customer_Information__c> SfcustCNUF = new List <Customer_Information__c >();
            IF(BaseOrList.size() > 0)
            {
                // 2 Query to get Decathlon Retailer Id           
                Retailer_Code__c retailerCode  = [select id from Retailer_Code__c where name='DECATHLON'];
                Id retailerID ; 
                if(retailerCode != null)
                {
                    retailerID =  retailerCode.Id;
                    System.debug('retailerID...'+retailerID);
                }
                
                // 3 currency picklist             
                Schema.DescribeFieldResult fieldResult = Online_Enquiry__c.Preferred_Currency__c.getDescribe();
                List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                Map<String, String> currencyMap = new Map<String, String>();
                for( Schema.PicklistEntry pickListVal : ple){
                    
                    currencyMap.put(pickListVal.getLabel().substring(0,3), pickListVal.getLabel());
                }   
                
                // for getting Price Book recordtype Id 
                
                Id PriceBookRecordTypeId = Schema.SObjectType.Price_Specification_Book__c.getRecordTypeInfosByName().get('Price Book').getRecordTypeId();
                
                System.debug('currencyMap...'+currencyMap);
                for (Base_Order__c bo : BaseOrList)
                {
                    
                    sCNUF.add(bo.SupplierParty_CNUF__c.trim());
                    cCNUF.add(bo.CustomerParty_CNUF__c.trim());
                    externalIds.add(bo.Document_ID__c);
                    
                    parentDocIDMap.put(bo.Id, bo.Document_ID__c);                
                    
                }
                System.debug('externalIds..'+externalIds);
                // 4 On Line Enquery Query for checking records are new or existing 
                onlineEnquery = [SELECT Id, Customer_PO_No__c FROM Online_Enquiry__c WHERE Customer_PO_No__c= : externalIds];
                System.debug('onlineEnquery...'+onlineEnquery.size());
                Map<String, String> existingRecordsMap = new Map<String, String>();
                List<String> orderToCompany = new List<String>();
                if(onlineEnquery.size() > 0)
                {
                    for(Online_Enquiry__c oe : onlineEnquery)
                    {
                        existingRecordsMap.put(oe.Customer_PO_No__c, oe.Id);
                    }
                }
                
                // 5 Query Supplier CNUF to get ID and Decathlon code
                SfsupCNUF = [Select Id, Decathlon_Code__c, Default_Order_to_Company__c  from Partner__c 
                             where RecordType.Name IN ('Mainetti Company', 'Licensee Partner') 
                             and Decathlon_Code__c= : sCNUF];
                
                // 6 Query customer CNUF to get ID and Decathlon code
                SfcustCNUF = [Select Id, Customer_Decathlon_Code__c from Customer_Information__c where 
                              Customer_Decathlon_Code__c = : cCNUF ];
                
                MAP <String, String> sCNUFMap = new  MAP <String, String>();
                Map<String, String>  docIdwithOrderCompanyMap = new  MAP <String, String>();
                if(SfsupCNUF.size() >0 )
                {
                    for(Partner__c partner: SfsupCNUF)
                    {
                        sCNUFMap.put(partner.Decathlon_Code__c+'',partner.Id+'#'+partner.Default_Order_to_Company__c);
                        orderToCompany.add(partner.Default_Order_to_Company__c);
                        //docIdwithOrderCompanyMap.put();
                        
                    }
                    System.debug('sCNUFMap...'+sCNUFMap);
                }
                MAP <String, String> custCNUFMap = new  MAP <String, String>();
                if(SfcustCNUF.size() >0 )
                {
                    for(Customer_Information__c custInfo: SfcustCNUF)
                    {
                        custCNUFMap.put(custInfo.Customer_Decathlon_Code__c,custInfo.Id);
                    }
                    System.debug('custCNUFMap...'+custCNUFMap);
                }
                
                List <Customer_Information__c> newCustList = new List<Customer_Information__c>();
                System.debug(' comparison for Customer CNUF.  BaseOrList.'+BaseOrList.size());
                System.debug(' comparison for Customer CNUF.  SfcustCNUF.'+SfcustCNUF.size());
                if(BaseOrList.size() > SfcustCNUF.size())
                {
                    // comparison for Customer CNUF
                    // 
                    System.debug('Inside Customer Inserstion...');
                    for(Base_Order__c bo1 : BaseOrList)
                    {
                        
                        if(!custCNUFMap.containsKey(bo1.CustomerParty_CNUF__c))
                        {
                            Customer_Information__c customerInformation=new Customer_Information__c();
                            customerInformation.Name=bo1.CustomerParty_Name__c;
                            customerInformation.Preferred_Currency__c= '';
                            customerInformation.Bill_to_Company__c=bo1.CustomerParty_Name__c;
                            customerInformation.Bill_to_Address1__c=bo1.CustomerParty_BillTo_Address1__c;
                            customerInformation.Bill_to_Address2__c=bo1.CustomerParty_BillTo_Address2__c;
                            customerInformation.Bill_to_Address3__c=bo1.CustomerParty_BillTo_Address3__c;
                            customerInformation.Bill_to_Address4__c=bo1.CustomerParty_BillTo_Address4__c;
                            customerInformation.Bill_to_Country__c=bo1.CustomerParty_BillTo_CityName__c;
                            customerInformation.Bill_to_State__c=bo1.CustomerParty_BillTo_Country_Code__c;
                            customerInformation.Bill_to_Postcode__c=bo1.CustomerParty_BillTo_Postal_Code__c;
                            customerInformation.Bill_to_Email__c=bo1.CustomerParty_BillTo_Email__c;
                            customerInformation.Bill_to_Tel__c=bo1.CustomerParty_BillTo_Telephone__c;
                            customerInformation.Ship_to_Company__c=bo1.CustomerParty_Name__c;
                            customerInformation.Ship_to_Address1__c=bo1.CustomerParty_ShipTo_Address1__c;
                            customerInformation.Ship_to_Address2__c=bo1.CustomerParty_ShipTo_Address2__c;
                            customerInformation.Ship_to_Address3__c=bo1.CustomerParty_ShipTo_Address3__c;
                            customerInformation.Ship_to_Address4__c=bo1.CustomerParty_ShipTo_Address4__c;
                            customerInformation.Ship_to_Country__c=bo1.CustomerParty_ShipTo_CityName__c;
                            customerInformation.Ship_to_State__c=bo1.CustomerParty_ShipTo_Country_Code__c;
                            customerInformation.Ship_to_Postcode__c=bo1.CustomerParty_ShipTo_Postal_Code__c;
                            customerInformation.Ship_to_Email__c=bo1.CustomerParty_ShipTo_Email__c;
                            customerInformation.Ship_to_Tel__c=bo1.CustomerParty_ShipTo_Telephone__c;
                            customerInformation.Customer_Decathlon_Code__c=bo1.CustomerParty_CNUF__c;
                            
                            newCustList.add(customerInformation);
                            // create new customer record
                        }
                        
                        // checking  Supplear CNUF
                        if(sCNUFMap.containsKey(bo1.SupplierParty_CNUF__c))
                        {
                            FinalParentMap.put(bo1.Document_ID__c,bo1.Document_ID__c);
                        }else
                        {
                            
                            FaieldParentMap.put(bo1.Document_ID__c,bo1.Document_ID__c);
                            Base_Order__c boc = new Base_Order__c();
                            boc.id = bo1.Id;
                            boc.Failure_Reason__c = 'Supplier CNUF is Missing';
                            boc.Processing_Status__c ='Failed';
                            boc.Start_Process__c = false;
                            faildBaseOrList.add(boc);
                        }
                        
                        
                    }
                    // 1 DML Customer Information Insertion
                    //  insert newCustList;
                    
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
                    
                    
                }else
                {
                    for(Base_Order__c bo1 : BaseOrList)
                    {
                        if(sCNUFMap.containsKey(bo1.SupplierParty_CNUF__c))
                        {
                            FinalParentMap.put(bo1.Document_ID__c,bo1.Document_ID__c);
                        }else
                        {
                            FaieldParentMap.put(bo1.Document_ID__c,bo1.Document_ID__c);
                            Base_Order__c boc = new Base_Order__c();
                            boc.id = bo1.Id;
                            boc.Failure_Reason__c = 'Supplear CNUF is Missing';
                            boc.Processing_Status__c ='Failed';
                            boc.Start_Process__c = false;
                            faildBaseOrList.add(boc);
                        }
                    }
                }
                
                // 7 Child query from Base child table
                Map<String, DateTime> handoverDatTimeMap=new Map<String, DateTime>();
                List <Base_Order_Detail__c> bDtailList = [SELECT Id, Name, PurchaseOrderLine_LineNumber__c, Model_Id__c, PurchaseOrderLine_Quantity__c, PurchaseOrderLine_Amount_CurrencyID__c, PurchaseOrderLine_Amount__c, PurchaseOrderLine_unitCode__c, PurchaseOrderLine_PerQuantity__c, PurchaseOrderLine_HandoverDateTime__c,Base_Order__c FROM Base_Order_Detail__c WHERE Base_Order__c = :inputParams];
                System.debug('bDtailList...'+bDtailList);
                list <String> prodList = new List<String>();
                Map<String, String> childPickListMap = new Map<String, String>();
                Map<String, String> childParentMap = new Map<String, String>();
                if(bDtailList.size() > 0)
                {
                    for (Base_Order_Detail__c bod: bDtailList)
                    {
                        prodList.add(bod.Model_Id__c);
                        
                        if(!childPickListMap.containsKey(bod.Base_Order__c))
                        {
                            childPickListMap.put(bod.Base_Order__c, bod.PurchaseOrderLine_Amount_CurrencyID__c);
                            handoverDatTimeMap.put(bod.Base_Order__c,bod.PurchaseOrderLine_HandoverDateTime__c);
                        }
                        
                        childParentMap.put(bod.Id , bod.Base_Order__c);
                        
                    }
                }
                
                List<Price_Specification_Book_Product__c> modelIdList = new List<Price_Specification_Book_Product__c>();
                System.debug('modelIdList...'+modelIdList);
                Map<String, String> ModelIdMap = new Map<String, String>();
                Map <Id,List<Price_Product_by_Currency__c>> priceProductMap = new Map<Id,List<Price_Product_by_Currency__c>>();
                if(prodList.size() > 0)
                {
                    // 8 Product query 
                    //  modelIdList =[SELECT Customer_Ref_Model__c,Id from Price_Specification_Book_Product__c WHERE  Customer_Ref_Model__c= : prodList  AND Price_Specification_Book__c='a01p0000008pun1'];
                    modelIdList = [SELECT Id, name, Order_to_Company__c, CurrencyIsoCode, Customer_Ref_Model__c, Price_Specification_Book__r.name, 
                                   (select id, CurrencyIsoCode, Price_100_pcs__c from Price_Product_by_Currency__r ) FROM Price_Specification_Book_Product__c 
                                   where Price_Specification_Book__r.Book_Status__c='Active' and Price_Specification_Book__r.RecordTypeId= :PriceBookRecordTypeId
                                   and Product_Status__c='Active' and Price_Specification_Book__r.Account__r.name='DECATHLON' and 
                                   Customer_Ref_Model__c = :prodList and Order_to_Company__c = :orderToCompany];
                    
                    
                    System.debug('modelIdList....'+modelIdList);
                    
                    if(modelIdList.size() >0)
                    {
                        for(Price_Specification_Book_Product__c product : modelIdList)
                        {
                            ModelIdMap.put(product.Customer_Ref_Model__c+'#'+product.Order_to_Company__c, product.Id+'');
                            priceProductMap.put(product.Id,product.Price_Product_by_Currency__r);
                        }
                    }
                    
                    System.debug('ModelIdMap...'+ModelIdMap);
                }
                
                // Insertain of Parent and Child
                List<Online_Enquiry__c> finalInsertParentList = new List<Online_Enquiry__c>();
                List<Online_Enquiry__c> finalUpdateParentList = new List<Online_Enquiry__c>();
                Map<String, String> deletedChildMap = new Map<String, String>();
                List<Online_Enquiry__c> updateParentAsCancel = new List<Online_Enquiry__c>();
                Map<String, String> sendPDFMap = new Map<String, String>();
                for(Base_Order__c bo : BaseOrList)
                {
                    if(FinalParentMap.containsKey(bo.Document_ID__c))
                    {
                        // preparing parent insertion
                        // 
                        docIdwithOrderCompanyMap.put(bo.Document_ID__c, sCNUFMap.get(bo.SupplierParty_CNUF__c).substringAfter('#'));
                        Online_Enquiry__c onlineEnquiryObj = new Online_Enquiry__c();
                        String actionCode = bo.Action_Code__c;
                        onlineEnquiryObj.D_LogicalID__c=bo.Logical_ID__c;
                        onlineEnquiryObj.D_ComponentID__c=bo.Component_ID__c;
                        onlineEnquiryObj.Retailer_PO_Creation_Date__c=bo.Creation_Date_Time__c;
                        //onlineEnquiryObj.Expected_Ship_Date__c=bo.
                        if(actionCode.equals('Add') || actionCode.equals('Modified')){
                            onlineEnquiryObj.Enquiry_Status__c='Pending' ;    
                            onlineEnquiryObj.RecordTypeId='012p00000008H4a'; // Record Type = Decathlon Order Locked
                            DateTime handOverDateTimeValue =handoverDatTimeMap.get(bo.Id);
                            onlineEnquiryObj.Expected_Ship_Date__c=date.newinstance(handOverDateTimeValue.year(), handOverDateTimeValue.month(), handOverDateTimeValue.day());
                            
                        } else if(actionCode.equals('Validated'))
                        {
                            onlineEnquiryObj.Enquiry_Status__c='New';
                            onlineEnquiryObj.RecordTypeId='012p00000008H4V'; // Record Type = Decathlon Order 
                            sendPDFMap.put(bo.Document_ID__c,bo.Document_ID__c);
                            DateTime handOverDateTimeValue =handoverDatTimeMap.get(bo.Id);
                            onlineEnquiryObj.Expected_Ship_Date__c=date.newinstance(handOverDateTimeValue.year(), handOverDateTimeValue.month(), handOverDateTimeValue.day());
                            
                            
                        } else if(actionCode.equals('Delete'))
                        {
                            onlineEnquiryObj.Enquiry_Status__c='CANCELLED';
                            onlineEnquiryObj.Cancellation_Remark__c=bo.Note__c;
                            onlineEnquiryObj.RecordTypeId='012p00000008H4a'; // Record Type = Decathlon Order Locked
                            deletedChildMap.put(bo.Document_ID__c,bo.Document_ID__c);
                        }
                        
                        if(actionCode.equals('Add') || actionCode.equals('Validated') || actionCode.equals('Modified')){
                            onlineEnquiryObj.Customer_Comments__c=bo.Note__c;
                        }
                        onlineEnquiryobj.Retailer_Code__c=retailerID;
                        onlineEnquiryobj.Retailer_Code_Hidden__c='DECATHLON';
                        onlineEnquiryObj.Customer_PO_No__c=bo.Document_ID__c;
                        onlineEnquiryObj.D_CustomerPartyTypeNumber__c=bo.CustomerParty_PartyTypeNumber__c;
                        onlineEnquiryObj.D_CustomerPartyNumber__c=bo.CustomerParty_PartyNumber__c;
                        onlineEnquiryObj.D_CustomerPartyTypeSubNumber__c=bo.CustomerParty_PartySubNumber__c; 
                        
                        if(custCNUFMap.containsKey(bo.CustomerParty_CNUF__c))
                        {
                            onlineEnquiryObj.Customer_Information__c=custCNUFMap.get(bo.CustomerParty_CNUF__c);
                            onlineEnquiryObj.Manufacturer_Code__c=bo.CustomerParty_CNUF__c;
                        }
                        //.;
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
                        
                        if(sCNUFMap.containsKey(bo.SupplierParty_CNUF__c))
                        {
                            onlineEnquiryObj.D_SupplierPartyCNUF__c= bo.SupplierParty_CNUF__c;
                            onlineEnquiryObj.Order_Country__c = sCNUFMap.get(bo.SupplierParty_CNUF__c).substringAfter('#');
                        }
                        onlineEnquiryObj.D_SupplierPartyFactoryName__c=bo.SupplierParty_Name__c;
                        onlineEnquiryObj.Enquiry_Date__c=date.newinstance(bo.Order_Date_Time__c.year(), bo.Order_Date_Time__c.month(), bo.Order_Date_Time__c.day());
                        //Get actual currency from 3 chars for matching - take currency of first child and set to parent\
                        //
                        //
                        //012p00000008H4a
                        
                        if(childPickListMap.containsKey(bo.Id))
                        {
                            if(currencyMap.containsKey(childPickListMap.get(bo.Id)))
                                onlineEnquiryObj.Preferred_Currency__c= (currencyMap.get(childPickListMap.get(bo.Id)));  
                            
                        }                  
                        
                        if(existingRecordsMap.containsKey(bo.Document_ID__c))
                        {
                            onlineEnquiryObj.id = existingRecordsMap.get(bo.Document_ID__c);
                            
                        }
                        finalUpdateParentList.add(onlineEnquiryObj);
                        System.debug('finalUpdateParentList...'+finalUpdateParentList);
                    }else
                    {
                        if(!actionFlag)
                        {
                            System.debug('updateParentAsCancel...12');
                            if(existingRecordsMap.containsKey(bo.Document_ID__c))
                            {
                                System.debug('updateParentAsCancel...123');
                                Online_Enquiry__c onlineEnqueryLocal = new Online_Enquiry__c();
                                //String docId = parentDocIDMap.get(childParentMap.get(bod.Id));
                                onlineEnqueryLocal.Id = existingRecordsMap.get(bo.Document_ID__c);
                                onlineEnqueryLocal.Enquiry_Status__c='CANCELLED';
                                onlineEnqueryLocal.RecordTypeId='012p00000008H4a'; // Record Type = Decathlon Order Locked
                                updateParentAsCancel.add(onlineEnqueryLocal);
                                // onlineEnquiryObj.id = existingRecordsMap.get(bo.Document_ID__c);
                                System.debug('updateParentAsCancel...1234');
                            }
                            
                            
                        }
                        
                        
                    }
                    
                    
                }
                // 2 DML Parents Insertion
                // upsert finalUpdateParentList;
                Map <Id, Id> duplicateIDMap = new Map<Id,Id>();
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
                
                System.debug('finalInsertParentList ...'+finalUpdateParentList);
                System.debug('FaieldParentMap...'+FaieldParentMap);
                Map<String, String> finalMap = new Map<String, String>();
                for(Online_Enquiry__c oe : finalUpdateParentList)
                {
                    finalMap.put(oe.Customer_PO_No__c, oe.Id);
                }
                
                // child records process
                Map<String, String> deleteParentMap = new map<String, String>();
                List<Online_Enquiry__c> deleteParentList = new List<Online_Enquiry__c>();
                List<Online_Detail__c> finalChildInsertList = new List<Online_Detail__c>();
                
                if(bDtailList.size() > 0)
                {
                    
                    for (Base_Order_Detail__c bod: bDtailList)
                    {
                        System.debug('bod....'+bod.Model_Id__c);
                        System.debug('bod....'+ModelIdMap.get(bod.Model_Id__c));
                        String docId = parentDocIDMap.get(childParentMap.get(bod.Id));
                        if(!FaieldParentMap.containsKey(docId))
                        {
                            if(ModelIdMap.containsKey(bod.Model_Id__c+'#'+docIdwithOrderCompanyMap.get(docId)))
                            {
                                System.debug('bod.123...'+bod);
                                
                                //Set parent
                                if(childParentMap.containsKey(bod.Id))
                                {
                                    System.debug('bod.123.4..'+bod);
                                    if(parentDocIDMap.containsKey(childParentMap.get(bod.Id)))
                                    {
                                        Online_Detail__c onlineDetailObj = new Online_Detail__c();
                                        onlineDetailObj.Retailer_Detail_Line_Number__c=Integer.valueof(bod.PurchaseOrderLine_LineNumber__c.trim());
                                        onlineDetailObj.Qty__c=Integer.valueof(bod.PurchaseOrderLine_Quantity__c.trim());
                                        
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
                                        // 
                                        onlineDetailObj.Unit_Price_from_xml__c=Double.valueOf(bod.PurchaseOrderLine_Amount__c.trim());
                                        onlineDetailObj.Expected_Shipped_Date_from_xml__c=bod.PurchaseOrderLine_HandoverDateTime__c;
                                        onlineDetailObj.UOM__c=bod.PurchaseOrderLine_unitCode__c;
                                        onlineDetailObj.UOM_Convertion__c=Integer.valueof(bod.PurchaseOrderLine_PerQuantity__c.trim());
                                        onlineDetailObj.Model__c=ModelIdMap.get(bod.Model_Id__c+'#'+docIdwithOrderCompanyMap.get(docId)) ;    //ModelIdMap.get(bod.Model_Id__c);
                                        onlineDetailObj.Online_Details_Status__c = 'New';
                                        System.debug('bod.123 4 5...'+bod);
                                        
                                        
                                        System.debug('docId...'+docId);
                                        System.debug('TransactionID__c...'+finalMap.get(docId));
                                        onlineDetailObj.TransactionID__c=  finalMap.get(docId); 
                                        if(!deletedChildMap.containsKey(parentDocIDMap.get(childParentMap.get(bod.Id))))
                                        {
                                            finalChildInsertList.add(onlineDetailObj);
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                                
                                // onlineDetailObj.TransactionID__c=;
                            }else
                            {
                                // model id is not avilable in sf and parent to be deleted
                                // 
                               if(actionFlag)
                                {
                                    
                                   
                                    FaieldParentMap.put(finalMap.get(docId), finalMap.get(docId));
                                    Online_Enquiry__c deleteOnlie = new Online_Enquiry__c();
                                    deleteOnlie.id=finalMap.get(docId);
                                    if(!deleteParentMap.containsKey(finalMap.get(docId)))
                                    {
                                        deleteParentMap.put(finalMap.get(docId), finalMap.get(docId));
                                        deleteParentList.add(deleteOnlie);
                                    }
                                    
                                    if(!duplicateIDMap.containsKey(bod.Base_Order__c))
                                    {
                                        duplicateIDMap.put(bod.Base_Order__c,bod.Base_Order__c);
                                        Base_Order__c boc = new Base_Order__c();
                                        boc.id = bod.Base_Order__c;
                                        boc.Failure_Reason__c = 'Model ID is missing '; //+ModelIdMap.get(bod.Model_Id__c+'#'+docIdwithOrderCompanyMap.get(docId));
                                        boc.Processing_Status__c ='Failed';
                                        boc.Start_Process__c = false;
                                        faildBaseOrList.add(boc);
                                    }
                                    //deleteParentMap.put(finalMap.get(parentDocIDMap.get(childParentMap.get(bod.Id))),parentDocIDMap.get(childParentMap.get(bod.Id)));
                                }else
                                {
                                    // update parent with  Cancel
                                    Online_Enquiry__c onlineEnqueryLocal = new Online_Enquiry__c();
                                    //String docId = parentDocIDMap.get(childParentMap.get(bod.Id));
                                    onlineEnqueryLocal.Id = finalMap.get(docId);
                                    onlineEnqueryLocal.Enquiry_Status__c='CANCELLED';
                                    onlineEnqueryLocal.RecordTypeId='012p00000008H4a'; // Record Type = Decathlon Order Locked
                                    updateParentAsCancel.add(onlineEnqueryLocal);
                                    
                                }
                            }
                            
                        }
                        
                        // close
                    }
                }
                // to change the Cancel parent child status to cancel
                System.debug('out side for loop for Success');
                
                for(Base_Order__c boc :BaseOrList)
                {
                    System.debug('In side for loop for Success');
                    if(!FaieldParentMap.containsKey(boc.Document_ID__c))
                    {
                        System.debug('Inside If for Success');
                        if(!duplicateIDMap.containsKey(boc.Id))
                        {
                            duplicateIDMap.put(boc.Id,boc.Id);
                            Base_Order__c bocFailed = new Base_Order__c();
                            bocFailed.id = boc.Id;
                            bocFailed.Processing_Status__c ='Success';
                            bocFailed.Start_Process__c = false;
                            faildBaseOrList.add(bocFailed);
                            
                        }
                        
                    }
                }
                System.debug('faildBaseOrList...'+faildBaseOrList);
                System.debug('updateParentAsCancel...'+updateParentAsCancel);
                //Update parent as cancel if modelid or scnuf does not exist
                upsert updateParentAsCancel;
                upsert faildBaseOrList;
                
                // List<Online_Enquiry__c> parentDelete = new List<Online_Enquiry__c>;
                
                if(onlineEnquery.size() > 0)
                {
                    List<Online_Detail__c> existingChildList = [SELECT Id FROM Online_Detail__c WHERE TransactionID__c IN : onlineEnquery AND Online_Details_Status__c = 'New'];
                    
                    if(existingChildList.size() >0 )
                    {
                        for(Online_Detail__c od : existingChildList)
                        {
                            od.Online_Details_Status__c = 'Cancel';
                            finalChildInsertList.add(od);
                        }
                    }
                }
                
                // 3 DML upsert child records
                // 
                System.debug('finalChildInsertList Size..'+finalChildInsertList.size());
                system.debug('bDtailList.size()...'+bDtailList.size());
                // upsert finalChildInsertList;
                
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
                
                // 4 update base order record status 
                // 
                // 
                if( actionFlag && deleteParentList.size() > 0)
                {
                    delete deleteParentList;
                }
                
                
                // calling  send PDF Email method for New Status Records
                // 
                
                if(sendPDFMap.size() > 0)
                {
                    for(String key : sendPDFMap.KeySet())
                    {
                        Utility.getEnquiryPdfContent(finalMap.get(sendPDFMap.get(key)));
                        pdfList.add(finalMap.get(sendPDFMap.get(key)));
                    }
                    
                    
                }
               
                System.debug('1. Number of Queries used in this Apex code so far: ' + Limits.getQueries());
                System.debug('2. Number of DML rows in this Apex code so far: ' + Limits.getDmlRows());
                System.debug('3. Number of DML statements used so far: ' +  Limits.getDmlStatements());    
                System.debug('4. Amount of CPU time (in ms) used so far: ' + Limits.getCpuTime());
            }
            
        }
        return pdfList;
    }
    
}