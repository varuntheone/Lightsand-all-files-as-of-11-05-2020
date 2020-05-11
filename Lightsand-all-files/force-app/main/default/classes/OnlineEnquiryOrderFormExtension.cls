public class OnlineEnquiryOrderFormExtension{
    private ApexPages.StandardController stdCtrl;
    public Online_Enquiry__c onlineEnquiryOrderDetails {get; set;}
    Ship_Bill_Address__c billToAddress {get; set;}
    Ship_Bill_Address__c shipToAddress {get; set;}
    private String contactId {get; set;}
    public List<Contact_Related_Retailer__c> retailerCodes {get; set;}
    public User loggedInUser = null;
    //Added new Code on 24-Aug 2015 Start
    public Boolean disableSectionsBeforeRetailerCodeSelect{get; set;}
    public Boolean disableSectionsForBuyerAndInvoice{get; set;}
    //public String beforeValue{get; set;}
    public Boolean enableJCPDivision{get; set;}
    public Boolean enablePRLDivision{get; set;}
    public Boolean enableMacyDivision{get; set;}
    public Boolean enableGeorgeDivision{get; set;}
    public Boolean enableGUDivision{get; set;}
    public Boolean enableGBGDivision{get; set;}
    public Boolean enableHKMDivision{get; set;}
    public Boolean enableMMGPO{get; set;}
    private static transient Map<String, Id> recordTypeIds;
    private static transient Map<String, Schema.SObjectType> gd;
    
    // Added By Pawan
    public String retailerCodeRowIdForImage;

    // added by pawan
    public Exchange_Rate__c localCurExRate {get;set;}   

    // added by pawan
    public String manufactureCodeList {get;set;}

    // added by pawan
    public String supplierCodeList {get;set;}   
    
    //
    public Decimal usdToLocalCurrency {get;set;}

public string userLocale {get;set;}


    //Added new Code on 24-Aug 2015 End
    public OnlineEnquiryOrderFormExtension(ApexPages.StandardController controller){
        onlineEnquiryOrderDetails = (Online_Enquiry__c)controller.getRecord();
        onlineEnquiryOrderDetails.Enquiry_Status__c='New';
        onlineEnquiryOrderDetails.Enquiry_Date__c=Date.Today();
        //onlineEnquiryOrderDetails.Quotation_Status__c='NA';
        stdCtrl = controller;
        
        System.debug('##User Id---->'+UserInfo.getUserId());
        System.debug('##User Name---->'+UserInfo.getUserName());
        System.debug('##User Name---->'+UserInfo.getLocale());
        userLocale = UserInfo.getLocale();
        
        loggedInUser = [select Name, ContactId, Order_to_Company__c, Buyer_Code__c,Preferred_Currency__c,Supplier_Code__c,Manufacturer_Code__c from User where Id=:UserInfo.getUserId()];
        System.debug('Logged In User-->'+loggedInUser);
        onlineEnquiryOrderDetails.Order_Country__c = loggedInUser.Order_to_Company__c;
        
        // commented by pawan - 22/OCT/2016
        //onlineEnquiryOrderDetails.Supplier_Code__c = loggedInUser.Supplier_Code__c;
        //onlineEnquiryOrderDetails.Manufacturer_Code__c = loggedInUser.Manufacturer_Code__c;
        
        // Added by Pawan : Why not defaulting like 'order to company'
        onlineEnquiryOrderDetails.Preferred_Currency__c = loggedInUser.Preferred_Currency__c;
        
        contactId = loggedInUser.ContactId;
        System.debug('##contactId--->'+contactId);
        
        if(contactId!=null && contactId.length()>0){
            retailerCodes = [select Name, Retailer_Code__c, Retailer_Name__c, Contact__c,Retailer_Code_ID__c from Contact_Related_Retailer__c where Contact__c=:contactId order by CreatedDate desc];
            //Added new Code on 24-Aug 2015 Start
            boolean isPRLPresent = checkIfPRLPresent(retailerCodes);
            //Added new Code on 24-Aug 2015 End
            boolean isJcpPresent = checkIfJCPPresent(retailerCodes);
            System.debug('##isJcpPresent--->'+isJcpPresent);
            System.debug('##retailerCodes--->'+retailerCodes);
            
            // added by pawan
            boolean isMacyPresent = checkIfMacyPresent(retailerCodes);
            
            //Added new Code on 24-Aug 2015 Start
            //Commented for 24 Aug changes
            //if(!isJcpPresent && retailerCodes!=null && retailerCodes.size()>0){
            if(!isJcpPresent && !isPRLPresent && !isMacyPresent && retailerCodes!=null && retailerCodes.size()>0){    
                //Added new Code on 24-Aug 2015 End    
                Contact_Related_Retailer__c eachContRetCode = retailerCodes.get(0);
                onlineEnquiryOrderDetails.Retailer_Code2__c = eachContRetCode.Retailer_Name__c;
                onlineEnquiryOrderDetails.TempRetailerCodeId__c = eachContRetCode.Retailer_Code__c;
                
                // Added by Pawan
                retailerCodeRowIdForImage = eachContRetCode.Retailer_Code_ID__c;
                System.debug('##retailerCodeRowIdForImage--->'+retailerCodeRowIdForImage);  
                //Added new Code on 24-Aug 2015 Start
                /*beforeValue = onlineEnquiryOrderDetails.TempRetailerCodeId__c;
                System.debug('#Before Val in constructor:'+beforeValue);*/
                //Added new Code on 24-Aug 2015 End
            }
        }
        //Added new Code on 24-Aug 2015 Start
        disableSectionsBeforeRetailerCodeSelect = false;
        if(onlineEnquiryOrderDetails.Order_Country__c == 'China - Suzhou Mainetti Plastic Products Ltd'){
            disableSectionsForBuyerAndInvoice= true;
        }else{
            disableSectionsForBuyerAndInvoice= false;
        }
       
        enableJCPDivision = false;
        enablePRLDivision = false;
        enableMacyDivision = false;
        enableGUDivision = false; //added by tony 27-Sep-2019
        enableGeorgeDivision = false; //added by tony 10-Dec-2018
        enableGBGDivision = false; //added by tony 31-Jan-2019
        enableHKMDivision = false; //added by tony 28-Mar-2019
        //Added new Code on 24-Aug 2015 End
        
        
    }
    
    public PageReference Save(){
        System.debug('###Save Called---->'+onlineEnquiryOrderDetails);
        if(onlineEnquiryOrderDetails!=null){
            System.debug('###Before Insertion Id--->'+onlineEnquiryOrderDetails.Id);
            onlineEnquiryOrderDetails.flagOnCreate__c=true;
            //Populating Retailer Code start
            System.debug('####TempRetailerCodeId__c--->'+onlineEnquiryOrderDetails.TempRetailerCodeId__c);
            System.debug('####TempRetailerCodeId__c Length--->'+onlineEnquiryOrderDetails.TempRetailerCodeId__c.length());
            System.debug('####Retailer_Code__c--->'+onlineEnquiryOrderDetails.Retailer_Code__c);
            if(onlineEnquiryOrderDetails.Retailer_Code2__c==null || onlineEnquiryOrderDetails.Retailer_Code2__c.length()==0){
                System.debug('####Retailer_Code2__c--->'+onlineEnquiryOrderDetails.Retailer_Code2__c);
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Retailer Code: You must select a value'));
                return null;
            }
            if(onlineEnquiryOrderDetails.TempRetailerCodeId__c==null || onlineEnquiryOrderDetails.TempRetailerCodeId__c.length()==0){
                System.debug('####TempRetailerCodeId__c--->'+onlineEnquiryOrderDetails.TempRetailerCodeId__c);
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Retailer Code: You must select a value'));
                return null;
            }
 

            
            //if(onlineEnquiryOrderDetails.Retailer_Code2__c.startsWith('MACY')){ 
                /*
                if(onlineEnquiryOrderDetails.Manufacturer_Code__c==null || onlineEnquiryOrderDetails.Manufacturer_Code__c.length()==0){
                    System.debug('####Manufacturer_Code__c--->'+onlineEnquiryOrderDetails.Manufacturer_Code__c);
                   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Manufacturer Code: You must select a value'));
                    return null;
                }*/

                /*
                if(onlineEnquiryOrderDetails.Manufacturer_Code__c!=null && !onlineEnquiryOrderDetails.Manufacturer_Code__c.isNumeric()){
                    System.debug('####Manufacturer_Code__c--->'+onlineEnquiryOrderDetails.Manufacturer_Code__c);
                   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Manufacturer Code: Accept 5 numbers only code'));
                    return null;
                }*/
                
                /*
                if(onlineEnquiryOrderDetails.Supplier_Code__c==null || onlineEnquiryOrderDetails.Supplier_Code__c.length()==0){
                    System.debug('####Supplier_Code__c--->'+onlineEnquiryOrderDetails.Supplier_Code__c);
                   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Supplier Code: You must select a value'));
                    return null;
                }*/
                
                /*
                if(onlineEnquiryOrderDetails.Supplier_Code__c!=null && !onlineEnquiryOrderDetails.Supplier_Code__c.isNumeric()){
                    System.debug('####Supplier_Code__c--->'+onlineEnquiryOrderDetails.Supplier_Code__c);
                   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Supplier Code: Accept 5 numbers only code.'));
                    return null;
                }*/
            //}
            
            if(onlineEnquiryOrderDetails.TempRetailerCodeId__c!=null && onlineEnquiryOrderDetails.TempRetailerCodeId__c.length()>0){
                 onlineEnquiryOrderDetails.Retailer_Code__c = onlineEnquiryOrderDetails.TempRetailerCodeId__c;
            }
            //Populating Retailer Code end
            //Populating Order to Company and Buyer Code from User Info Start
           //if(loggedInUser!=null && loggedInUser.Order_to_Company__c!=null && loggedInUser.Order_to_Company__c.length()>0 /*&& loggedInUser.Buyer_Code__c!=null && loggedInUser.Buyer_Code__c.length()>0*/ ){
             //   onlineEnquiryOrderDetails.Order_Country__c = loggedInUser.Order_to_Company__c;
                //onlineEnquiryOrderDetails.Buyer_Code1__c = loggedInUser.Buyer_Code__c;
            //}
            System.debug('##Order To Company--->'+onlineEnquiryOrderDetails.Order_Country__c);
            
            // just remove the placeholder
            //String mmgPoNumber = onlineEnquiryOrderDetails.MMG_PO_Number__c;
            if(onlineEnquiryOrderDetails.MMG_PO_Number1__c!=null && onlineEnquiryOrderDetails.MMG_PO_Number1__c.length()>0){
                List<String> mmgPoNumbersArr = string.valueof(onlineEnquiryOrderDetails.MMG_PO_Number1__c).split(',\\s*');
                if(mmgPoNumbersArr!=null && mmgPoNumbersArr.size()==3 && mmgPoNumbersArr.get(0).equalsIgnoreCase('PO9873423') && mmgPoNumbersArr.get(1).equalsIgnoreCase('PO9834923') && mmgPoNumbersArr.get(2).equalsIgnoreCase('PO9879238')){
                        onlineEnquiryOrderDetails.MMG_PO_Number1__c = null;
                }
            }
            
            //Populating Order to Company and Buyer Code from User Info End
            insert(onlineEnquiryOrderDetails);
            
            // Added by Pawan
            loggedInUser.Preferred_Currency__c = onlineEnquiryOrderDetails.Preferred_Currency__c;
            update(loggedInUser);
            
            // query Exchange_Rate_c
            /*
            String currentMonth = DateTime.Now().format('MMMMM').substring(0,3);
            String currentYear = String.valueOf(Date.Today().Year());
            try{
            localCurExRate = [select ExRate_to_USD__c from Exchange_Rate__c where Local_Currency__c=:onlineEnquiryOrderDetails.Preferred_Currency__c AND Active__c=True AND Month__c = :currentMonth AND Year__c = :currentYear order by CreatedDate desc Limit 1];
            
            usdToLocalCurrency = 1 / localCurExRate.ExRate_to_USD__c;
            usdToLocalCurrency = usdToLocalCurrency.setScale(4,RoundingMode.CEILING);
            }catch(Exception exRateQueryEx){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Exchange Rate is not defined for the ['+ onlineEnquiryOrderDetails.Preferred_Currency__c+'] currency.'));
                usdToLocalCurrency=null;
            }*/
            
            System.debug('###After Insertion Id--->'+onlineEnquiryOrderDetails.Id);
            System.debug('####After flagOnCreate__c--->'+onlineEnquiryOrderDetails.flagOnCreate__c);
        }
        //return new PageReference('/apex/NewProductSelectionPage'+'?'+'OnlineEnquiryId='+onlineEnquiryOrderDetails.Id+'&UsdToLocalCurValue='+usdToLocalCurrency);
        
        //String productSelURL = 'NewProductSelectionPage';
        /*if(onlineEnquiryOrderDetails.Retailer_Code2__c.startsWith('JC') || onlineEnquiryOrderDetails.Retailer_Code2__c.startsWith('PRL')){
            productSelURL = 'NewProductSelectionPage_jcpprl';
        }*/
        return new PageReference('/apex/NewProductSelectionPage'+'?'+'OnlineEnquiryId='+onlineEnquiryOrderDetails.Id);
        //return new PageReference('/apex/'+productSelURL+'?'+'OnlineEnquiryId='+onlineEnquiryOrderDetails.Id);
     }
    
    public void PopulateBillTo(){
        System.debug('##PopulateBillToClicked--->'+onlineEnquiryOrderDetails.Bill_To__c);
        if(onlineEnquiryOrderDetails.Bill_To__c!=null){
        Ship_Bill_Address__c billToAddress = [select Factory_Name__c, Address_1__c, Address_2__c, City__c, State__c, Postcode__c, Country__c, Bill_Ship_Status__c, Contact__c, Tel_No__c, Fax_No__c, Email_Address__c from Ship_Bill_Address__c where Id=:onlineEnquiryOrderDetails.Bill_To__c];
        System.debug('##FactoryName---->'+billToAddress.Factory_Name__c);
        onlineEnquiryOrderDetails.Bill_to_Company__c = billToAddress.Factory_Name__c;
        onlineEnquiryOrderDetails.Bill_to_Address1__c = billToAddress.Address_1__c;
        onlineEnquiryOrderDetails.Bill_to_Address2__c = billToAddress.Address_2__c;
        onlineEnquiryOrderDetails.Bill_to_State__c = billToAddress.State__c;
        onlineEnquiryOrderDetails.Bill_to_Postcode__c = billToAddress.Postcode__c;
        onlineEnquiryOrderDetails.Bill_to_Country__c = billToAddress.Country__c;
        onlineEnquiryOrderDetails.Bill_to_Contact__c = billToAddress.Contact__c;
        onlineEnquiryOrderDetails.Bill_to_Tel__c = billToAddress.Tel_No__c;
        onlineEnquiryOrderDetails.Bill_to_Fax__c = billToAddress.Fax_No__c;
        onlineEnquiryOrderDetails.Bill_to_Email__c = billToAddress.Email_Address__c;
        }else{
        onlineEnquiryOrderDetails.Bill_to_Company__c = '';
        onlineEnquiryOrderDetails.Bill_to_Address1__c = '';
        onlineEnquiryOrderDetails.Bill_to_Address2__c = '';
        onlineEnquiryOrderDetails.Bill_to_State__c = '';
        onlineEnquiryOrderDetails.Bill_to_Postcode__c = '';
        onlineEnquiryOrderDetails.Bill_to_Country__c = '';
        onlineEnquiryOrderDetails.Bill_to_Contact__c = '';
        onlineEnquiryOrderDetails.Bill_to_Tel__c = '';
        onlineEnquiryOrderDetails.Bill_to_Fax__c = '';
        onlineEnquiryOrderDetails.Bill_to_Email__c = '';
        }
    }
    
    public void PopulateShipTo(){
        System.debug('##PopulateShipToClicked--->'+onlineEnquiryOrderDetails.Ship_To__c);
        if(onlineEnquiryOrderDetails.Ship_To__c!=null){
        Ship_Bill_Address__c shipToAddress = [select Factory_Name__c, Address_1__c, Address_2__c, City__c, State__c, Postcode__c, Country__c, Bill_Ship_Status__c, Contact__c, Tel_No__c, Fax_No__c, Email_Address__c from Ship_Bill_Address__c where Id=:onlineEnquiryOrderDetails.Ship_To__c];
        System.debug('##FactoryName---->'+shipToAddress.Factory_Name__c);
        onlineEnquiryOrderDetails.Ship_to_Company__c = shipToAddress.Factory_Name__c;
        onlineEnquiryOrderDetails.Ship_to_Address1__c = shipToAddress.Address_1__c;
        onlineEnquiryOrderDetails.Ship_to_Address2__c = shipToAddress.Address_2__c;
        onlineEnquiryOrderDetails.Ship_to_State__c = shipToAddress.State__c;
        onlineEnquiryOrderDetails.Ship_to_Postcode__c = shipToAddress.Postcode__c;
        onlineEnquiryOrderDetails.Ship_to_Country__c = shipToAddress.Country__c;
        onlineEnquiryOrderDetails.Ship_to_Contact__c = shipToAddress.Contact__c;
        onlineEnquiryOrderDetails.Ship_to_Tel__c = shipToAddress.Tel_No__c;
        onlineEnquiryOrderDetails.Ship_to_Fax__c = shipToAddress.Fax_No__c;
        onlineEnquiryOrderDetails.Ship_to_Email__c = shipToAddress.Email_Address__c;
        }else{
        onlineEnquiryOrderDetails.Ship_to_Company__c = '';
        onlineEnquiryOrderDetails.Ship_to_Address1__c = '';
        onlineEnquiryOrderDetails.Ship_to_Address2__c = '';
        onlineEnquiryOrderDetails.Ship_to_State__c = '';
        onlineEnquiryOrderDetails.Ship_to_Postcode__c = '';
        onlineEnquiryOrderDetails.Ship_to_Country__c = '';
        onlineEnquiryOrderDetails.Ship_to_Contact__c = '';
        onlineEnquiryOrderDetails.Ship_to_Tel__c = '';
        onlineEnquiryOrderDetails.Ship_to_Fax__c = '';
        onlineEnquiryOrderDetails.Ship_to_Email__c = '';
        }
    }
    
    public String getmyimageurl(){
        String imageId = '';
        
        /*
        String documentName = 'JC Penney';
        System.debug('#RecordType:'+onlineEnquiryOrderDetails.RecordtypeId);
        if(onlineEnquiryOrderDetails.RecordtypeId==getRecordTypeIdByName('Online_Enquiry__c','PRL Order')){
            documentName = 'Polo Ralph Lauren';
        }else if(onlineEnquiryOrderDetails.RecordtypeId==getRecordTypeIdByName('Online_Enquiry__c','JCP Order')){
            documentName = 'JC Penney';
        }
        Document doc = [select Id, Name from Document where Name=:documentName LIMIT 1];
        if(doc!=null){
            imageId = doc.Id;
        }*/
        //return '/servlet/servlet.FileDownload?file=' + imageId+' &oid='+UserInfo.getOrganizationId();
        
        // Added By Pawan
        /*
        User loggedInUser1 = [select Name, ContactId, Order_to_Company__c, Buyer_Code__c from User where Id=:UserInfo.getUserId()];
        System.debug('Logged In User-->'+loggedInUser1);
        String contactId1 = loggedInUser1.ContactId;
        System.debug('##contactId1--->'+contactId1);
                
        List<Contact_Related_Retailer__c> retailerCodes1 = [select Retailer_Code_ID__c from Contact_Related_Retailer__c where Contact__c=:contactId1 order by CreatedDate desc];
        Contact_Related_Retailer__c eachContRetCode = retailerCodes1.get(0);
        String retailerCodeRowIdForImage1 = eachContRetCode.Retailer_Code_ID__c;
        System.debug('##retailerCodeRowIdForImage1--->'+retailerCodeRowIdForImage1);
        */

        String fileId = '';
        List<Attachment> attachedFiles = [select Id from Attachment where parentId =:onlineEnquiryOrderDetails.TempRetailerCodeId__c order By LastModifiedDate DESC limit 1];
        if( attachedFiles != null && attachedFiles.size() > 0 ) {
            fileId = attachedFiles[0].Id;
        }
        onlineEnquiryOrderDetails.Retailer_Image_ID__c=fileId;
        return '/servlet/servlet.FileDownload?file=' + fileId;
        // Added By Pawan -END
    }
    
    public boolean checkIfJCPPresent(List<Contact_Related_Retailer__c> queriedRetailerCodes){
        boolean jcpPresent = false;
        if(queriedRetailerCodes!=null){
            for(Contact_Related_Retailer__c eachContRetCode : queriedRetailerCodes){
               // System.debug('###eachContRetCode.Name--->'+eachContRetCode.Name);
               //Added new Code on 24-Aug 2015 Start
               //Commented for 24 Aug changes
                //if(eachContRetCode.Retailer_Name__c.contains('JC PENNEY')){
                if(eachContRetCode.Retailer_Name__c.startsWith('JC')){    
               //Added new Code on 24-Aug 2015 End     
                    onlineEnquiryOrderDetails.Retailer_Code2__c = eachContRetCode.Retailer_Name__c;
                    onlineEnquiryOrderDetails.TempRetailerCodeId__c = eachContRetCode.Retailer_Code__c;
                    //Added new Code on 24-Aug 2015 Start
                    /*beforeValue = onlineEnquiryOrderDetails.TempRetailerCodeId__c;
                    System.debug('#Before Val in constructor:'+beforeValue);*/
                    //Added new Code on 24-Aug 2015 End
                    jcpPresent = true;
                    break;
                }
            }
        }
        return jcpPresent;
    }
    
    public boolean checkIfMacyPresent(List<Contact_Related_Retailer__c> queriedRetailerCodes){
        boolean macyPresent = false;
        if(queriedRetailerCodes!=null){
            for(Contact_Related_Retailer__c eachContRetCode : queriedRetailerCodes){
               // System.debug('###eachContRetCode.Name--->'+eachContRetCode.Name);
               //Added new Code on 24-Aug 2015 Start
               //Commented for 24 Aug changes
                //if(eachContRetCode.Retailer_Name__c.contains('JC PENNEY')){
                if(eachContRetCode.Retailer_Name__c.startsWith('Macy')){    
               //Added new Code on 24-Aug 2015 End     
                    onlineEnquiryOrderDetails.Retailer_Code2__c = eachContRetCode.Retailer_Name__c;
                    onlineEnquiryOrderDetails.TempRetailerCodeId__c = eachContRetCode.Retailer_Code__c;
                    //Added new Code on 24-Aug 2015 Start
                    /*beforeValue = onlineEnquiryOrderDetails.TempRetailerCodeId__c;
                    System.debug('#Before Val in constructor:'+beforeValue);*/
                    //Added new Code on 24-Aug 2015 End
                    macyPresent = true;
                    break;
                }
            }
        }
        return macyPresent;
    }
    
    //Added new Code on 24-Aug 2015 Start
    public boolean checkIfPRLPresent(List<Contact_Related_Retailer__c> queriedRetailerCodes){
        boolean prlPresent = false;
        if(queriedRetailerCodes!=null){
            for(Contact_Related_Retailer__c eachContRetCode : queriedRetailerCodes){
               // System.debug('###eachContRetCode.Name--->'+eachContRetCode.Name);
               //Added new Code on 24-Aug 2015 Start
               //Commented for 24 Aug changes
                //if(eachContRetCode.Retailer_Name__c.contains('JC PENNEY')){
                //if(eachContRetCode.Retailer_Name__c.startsWith('PRL')){    
                if(!eachContRetCode.Retailer_Name__c.startsWith('JCP')){    
                    //Added new Code on 24-Aug 2015 End     
                    onlineEnquiryOrderDetails.Retailer_Code2__c = eachContRetCode.Retailer_Name__c;
                    onlineEnquiryOrderDetails.TempRetailerCodeId__c = eachContRetCode.Retailer_Code__c;
                    //Added new Code on 24-Aug 2015 Start
                    /*beforeValue = onlineEnquiryOrderDetails.TempRetailerCodeId__c;
                    System.debug('#Before Val in constructor:'+beforeValue);*/
                    //Added new Code on 24-Aug 2015 End
                    prlPresent = true;
                    break;
                }
            }
        }
        return prlPresent;
    }
    public PageReference enableAllSections(){
        System.debug('#Enabling all sections render:'+onlineEnquiryOrderDetails.Retailer_Code2__c);
        System.debug('#Temp Enabling all sections render:'+onlineEnquiryOrderDetails.TempRetailerCodeId__c);
        /*System.debug('#BeforeVal:'+beforeValue);
        //if(!disableSectionsBeforeRetailerCodeSelect ){
        if(!disableSectionsBeforeRetailerCodeSelect && beforeValue!=null && beforeValue!='' && onlineEnquiryOrderDetails.TempRetailerCodeId__c!=beforeValue){
            disableSectionsBeforeRetailerCodeSelect = true;
        }*/
        if(!disableSectionsBeforeRetailerCodeSelect){
        
            disableSectionsBeforeRetailerCodeSelect = true;
            
            
            System.debug('#Res:'+onlineEnquiryOrderDetails.Retailer_Code2__c.contains('JC PENNY'));
            if(onlineEnquiryOrderDetails.Retailer_Code2__c.startsWith('JC')){
                enableJCPDivision = true;
                //onlineEnquiryOrderDetails.RecordType.Name='JCP Order';
                //onlineEnquiryOrderDetails.RecordTypeId = '01290000000TNpV';
                onlineEnquiryOrderDetails.RecordTypeId = getRecordTypeIdByName('Online_Enquiry__c','JCP Order');
                onlineEnquiryOrderDetails.Retailer_Code_Hidden__c = onlineEnquiryOrderDetails.Retailer_Code2__c;    
            }else if(onlineEnquiryOrderDetails.Retailer_Code2__c.startsWith('PRL')){
            //}else if(!onlineEnquiryOrderDetails.Retailer_Code2__c.startsWith('JCP')){
                enablePRLDivision = true;
                //onlineEnquiryOrderDetails.RecordType.Name='PRL Order';
                //onlineEnquiryOrderDetails.RecordTypeId = '012N0000000DHzq';
                onlineEnquiryOrderDetails.RecordTypeId = getRecordTypeIdByName('Online_Enquiry__c','PRL Order');
                if(onlineEnquiryOrderDetails.Retailer_Code2__c.equals('PRL LAUREN DRESS')){
                    onlineEnquiryOrderDetails.Retailer_Code_Hidden__c = 'PRL LAUREN DRESS';
                }else if(onlineEnquiryOrderDetails.Retailer_Code2__c.equals('PRL RTW')){
                    onlineEnquiryOrderDetails.Retailer_Code_Hidden__c = 'PRL RTW';
                }
                /*else if(onlineEnquiryOrderDetails.Retailer_Code2__c.equals('MACY\'S')){
                    onlineEnquiryOrderDetails.Retailer_Code_Hidden__c = 'MACY\'S';
                }*/
            }else if(onlineEnquiryOrderDetails.Retailer_Code2__c.startsWith('MACY')){
                enableMacyDivision = true;
                onlineEnquiryOrderDetails.RecordTypeId = getRecordTypeIdByName('Online_Enquiry__c','Macy Order');
                onlineEnquiryOrderDetails.Retailer_Code_Hidden__c = 'MACY\'S';
//                  onlineEnquiryOrderDetails.Retailer_Code_Hidden__c = 'Macy\'s';
            }else if(onlineEnquiryOrderDetails.Retailer_Code2__c.startsWith('GEORGE CLOTHING/ASDA')){
            // added by Tony 10-Dec-2018
                enableGeorgeDivision= true;
                enablePRLDivision = true;
                onlineEnquiryOrderDetails.RecordTypeId = getRecordTypeIdByName('Online_Enquiry__c','Standard Order');
                onlineEnquiryOrderDetails.Retailer_Code_Hidden__c = onlineEnquiryOrderDetails.Retailer_Code2__c; 
               // END
            
            }else if(onlineEnquiryOrderDetails.Retailer_Code2__c.startsWith('GU')){
            // added by Tony 27-Sep-2019
                enableGUDivision= true;
                enablePRLDivision = true;
                onlineEnquiryOrderDetails.RecordTypeId = getRecordTypeIdByName('Online_Enquiry__c','Standard Order');
                onlineEnquiryOrderDetails.Retailer_Code_Hidden__c = onlineEnquiryOrderDetails.Retailer_Code2__c; 
               // END
            
            }else if(onlineEnquiryOrderDetails.Retailer_Code2__c.startsWith('HUNKEMOLLER')){
            // added by Tony 28-Mar-2019
                enableHKMDivision= true;
                enablePRLDivision = true;
                onlineEnquiryOrderDetails.RecordTypeId = getRecordTypeIdByName('Online_Enquiry__c','Standard Order');
                onlineEnquiryOrderDetails.Retailer_Code_Hidden__c = onlineEnquiryOrderDetails.Retailer_Code2__c; 
               // END
            }else if(onlineEnquiryOrderDetails.Retailer_Code2__c.startsWith('GLOBAL BRANDS GROUP')){
            // added by Tony 31-Jan-2019
                enableGBGDivision= true;
                enablePRLDivision = true;
                onlineEnquiryOrderDetails.RecordTypeId = getRecordTypeIdByName('Online_Enquiry__c','Standard Order');
                onlineEnquiryOrderDetails.Retailer_Code_Hidden__c = onlineEnquiryOrderDetails.Retailer_Code2__c; 
               // END
            }else if(onlineEnquiryOrderDetails.Retailer_Code2__c.startsWith('CENTRIC BRANDS')){
            // added by Tony 31-Jan-2019
                enableGBGDivision= true;
                enablePRLDivision = true;
                onlineEnquiryOrderDetails.RecordTypeId = getRecordTypeIdByName('Online_Enquiry__c','Standard Order');
                onlineEnquiryOrderDetails.Retailer_Code_Hidden__c = onlineEnquiryOrderDetails.Retailer_Code2__c; 
               // END
            }else{
                // added By Pawan 15_APR_2015
                enablePRLDivision = true;
                //onlineEnquiryOrderDetails.RecordTypeId = getRecordTypeIdByName('Online_Enquiry__c','PRL Order');
                onlineEnquiryOrderDetails.RecordTypeId = getRecordTypeIdByName('Online_Enquiry__c','Standard Order');
                onlineEnquiryOrderDetails.Retailer_Code_Hidden__c = onlineEnquiryOrderDetails.Retailer_Code2__c;    
                //END
            }
        }
        
        
        // query Related Data -START BY PAWAN - 22/OCT/2016
        List<Retailer_Related_Data__c> relatedRetailerList = [select Manufacturer_Factory_Code__c, Supplier_Code__c from Retailer_Related_Data__c where ContactID__c=:contactId AND Retailer_Code__c=:onlineEnquiryOrderDetails.TempRetailerCodeId__c];
        
        System.Debug('relatedRetailerList:'+relatedRetailerList);
        
        for(Retailer_Related_Data__c eachRelatedRetailerData : relatedRetailerList){
            if(!String.isBlank(eachRelatedRetailerData.Manufacturer_Factory_Code__c)){
                if(manufactureCodeList!=null && manufactureCodeList.length()>0){
                    manufactureCodeList = manufactureCodeList+ ','+eachRelatedRetailerData.Manufacturer_Factory_Code__c;
                }else{
                    manufactureCodeList = eachRelatedRetailerData.Manufacturer_Factory_Code__c;
                }
            }
            
            if(!String.isBlank(eachRelatedRetailerData.Supplier_Code__c)){
                if(supplierCodeList!=null && supplierCodeList.length()>0){
                    supplierCodeList = supplierCodeList+','+eachRelatedRetailerData.Supplier_Code__c;
                }else{
                    supplierCodeList = eachRelatedRetailerData.Supplier_Code__c;
                }
            }
        }
        
        onlineEnquiryOrderDetails.Supplier_Code__c = supplierCodeList;
        onlineEnquiryOrderDetails.Manufacturer_Code__c = manufactureCodeList;
        // END - 22/OCT/2016
        
        return null;
    }
    public static Id getRecordTypeIdByName(String objectType, String recordType){
        
        if(recordTypeIds == null)
        {
            recordTypeIds = new Map<String, Id>();
        }
        
        String sKey = objectType + '|' + recordType;
        if(recordTypeIds.get(sKey) == null)
        {
            Schema.DescribeSobjectResult objDesc = describeSObject(objectType);
            System.assert(objDesc != null, 'Invalid objectType ' + objectType);         
            Map<String, Schema.RecordTypeInfo> rtInfos = objDesc.getRecordTypeInfosByName(); 
            for(String rtName: rtInfos.keySet())
            {
                RecordTypeInfo rt = rtInfos.get(rtName);
                if(rt != null)
                {
                    String sKey2 = objectType + '|' + rtName;
                    recordTypeIds.put(sKey2, rt.getRecordTypeId());                 
                }
            }
        }
        
        return recordTypeIds.get(sKey);
    }
    private static Schema.DescribeSObjectResult describeSObject(String objectType)
    {
        Schema.SObjectType ot = getObjectType(objectType);
        if(ot == null) return null;
        return ot.getDescribe();
    }
    private static Schema.SObjectType getObjectType(String objectType)
    {
        if(gd == null)
            gd = Schema.getGlobalDescribe();
        Schema.SObjectType ot = gd.get(objectType);
        return ot;      
    }
    //Added new Code on 24-Aug 2015 End
    
    public void enableMMGPOField(){
        if(onlineEnquiryOrderDetails.Division__c.equals('LDP')){
            enableMMGPO = true;
        }else{
            enableMMGPO = true;
        }
    }
    
    public void PopulateBuyerTo(){
        System.debug('##PopulateBuyerClicked--->'+onlineEnquiryOrderDetails.Buyer__c);
        if(onlineEnquiryOrderDetails.Buyer__c!=null){
            Ship_Bill_Address__c buyerddress = [select Factory_Name__c, Address_1__c, Address_2__c, City__c, State__c, Postcode__c, Country__c, Bill_Ship_Status__c, Contact__c, Tel_No__c, Fax_No__c, Email_Address__c from Ship_Bill_Address__c where Id=:onlineEnquiryOrderDetails.Buyer__c];
            System.debug('##FactoryName---->'+buyerddress.Factory_Name__c);
            onlineEnquiryOrderDetails.Buyer_Company__c = buyerddress.Factory_Name__c;   
            
            onlineEnquiryOrderDetails.Buyer_Address1__c = buyerddress.Address_1__c;
            onlineEnquiryOrderDetails.Buyer_Address2__c = buyerddress.Address_2__c;
            onlineEnquiryOrderDetails.Buyer_State__c = buyerddress.State__c;
            onlineEnquiryOrderDetails.Buyer_Postcode__c = buyerddress.Postcode__c;
            onlineEnquiryOrderDetails.Buyer_Country__c = buyerddress.Country__c;
            onlineEnquiryOrderDetails.Buyer_Contact__c = buyerddress.Contact__c;
            onlineEnquiryOrderDetails.Buyer_Tel__c = buyerddress.Tel_No__c;
            onlineEnquiryOrderDetails.Buyer_Fax__c = buyerddress.Fax_No__c;
            onlineEnquiryOrderDetails.Buyer_Email__c = buyerddress.Email_Address__c;
            
        }else{
            onlineEnquiryOrderDetails.Buyer_Company__c = '';   
            onlineEnquiryOrderDetails.Buyer_Address1__c = '';
            onlineEnquiryOrderDetails.Buyer_Address2__c = '';
            onlineEnquiryOrderDetails.Buyer_State__c = '';
            onlineEnquiryOrderDetails.Buyer_Postcode__c = '';
            onlineEnquiryOrderDetails.Buyer_Country__c = '';
            onlineEnquiryOrderDetails.Buyer_Contact__c = '';
            onlineEnquiryOrderDetails.Buyer_Tel__c = '';
            onlineEnquiryOrderDetails.Buyer_Fax__c = '';
            onlineEnquiryOrderDetails.Buyer_Email__c = '';
        }
    }
    
    public void PopulateInvoiceTo(){
        System.debug('##PopulateInvoiceClicked--->'+onlineEnquiryOrderDetails.Invoice_To__c);
        if(onlineEnquiryOrderDetails.Invoice_To__c!=null){
            Ship_Bill_Address__c buyerddress = [select Factory_Name__c, Address_1__c, Address_2__c, City__c, State__c, Postcode__c, Country__c, Bill_Ship_Status__c, Contact__c, Tel_No__c, Fax_No__c, Email_Address__c from Ship_Bill_Address__c where Id=:onlineEnquiryOrderDetails.Invoice_To__c];
            System.debug('##FactoryName---->'+buyerddress.Factory_Name__c);
            onlineEnquiryOrderDetails.Invoice_To_Company__c = buyerddress.Factory_Name__c;   
            
            onlineEnquiryOrderDetails.Invoice_To_Address1__c = buyerddress.Address_1__c;
            onlineEnquiryOrderDetails.Invoice_To_Address2__c = buyerddress.Address_2__c;
            onlineEnquiryOrderDetails.Invoice_To_State__c = buyerddress.State__c;
            onlineEnquiryOrderDetails.Invoice_To_Postcode__c = buyerddress.Postcode__c;
            onlineEnquiryOrderDetails.Invoice_To_Country__c = buyerddress.Country__c;
            onlineEnquiryOrderDetails.Invoice_To_Contact__c = buyerddress.Contact__c;
            onlineEnquiryOrderDetails.Invoice_To_Tel__c = buyerddress.Tel_No__c;
            onlineEnquiryOrderDetails.Invoice_To_Fax__c = buyerddress.Fax_No__c;
            onlineEnquiryOrderDetails.Invoice_To_Email__c = buyerddress.Email_Address__c;
        }else{
            onlineEnquiryOrderDetails.Invoice_To_Company__c = '';
            onlineEnquiryOrderDetails.Invoice_To_Address1__c = '';
            onlineEnquiryOrderDetails.Invoice_To_Address2__c = '';
            onlineEnquiryOrderDetails.Invoice_To_State__c = '';
            onlineEnquiryOrderDetails.Invoice_To_Postcode__c = '';
            onlineEnquiryOrderDetails.Invoice_To_Country__c ='';
            onlineEnquiryOrderDetails.Invoice_To_Contact__c = '';
            onlineEnquiryOrderDetails.Invoice_To_Tel__c = '';
            onlineEnquiryOrderDetails.Invoice_To_Fax__c = '';
            onlineEnquiryOrderDetails.Invoice_To_Email__c = '';
        }
    }
    
    public void handleAddressVisibility(){
        
       
        if(onlineEnquiryOrderDetails.Order_Country__c == 'China - Suzhou Mainetti Plastic Products Ltd'){
            disableSectionsForBuyerAndInvoice= true;
        }else{
            disableSectionsForBuyerAndInvoice= false;
            
             onlineEnquiryOrderDetails.Buyer__c = null;   
            onlineEnquiryOrderDetails.Buyer_Company__c = '';   
            onlineEnquiryOrderDetails.Buyer_Address1__c = '';
            onlineEnquiryOrderDetails.Buyer_Address2__c = '';
            onlineEnquiryOrderDetails.Buyer_State__c = '';
            onlineEnquiryOrderDetails.Buyer_Postcode__c = '';
            onlineEnquiryOrderDetails.Buyer_Country__c = '';
            onlineEnquiryOrderDetails.Buyer_Contact__c = '';
            onlineEnquiryOrderDetails.Buyer_Tel__c = '';
            onlineEnquiryOrderDetails.Buyer_Fax__c = '';
            onlineEnquiryOrderDetails.Buyer_Email__c = '';
            
            
            onlineEnquiryOrderDetails.Invoice_To__c = null;
            onlineEnquiryOrderDetails.Invoice_To_Company__c = '';
            onlineEnquiryOrderDetails.Invoice_To_Address1__c = '';
            onlineEnquiryOrderDetails.Invoice_To_Address2__c = '';
            onlineEnquiryOrderDetails.Invoice_To_State__c = '';
            onlineEnquiryOrderDetails.Invoice_To_Postcode__c = '';
            onlineEnquiryOrderDetails.Invoice_To_Country__c ='';
            onlineEnquiryOrderDetails.Invoice_To_Contact__c = '';
            onlineEnquiryOrderDetails.Invoice_To_Tel__c = '';
            onlineEnquiryOrderDetails.Invoice_To_Fax__c = '';
            onlineEnquiryOrderDetails.Invoice_To_Email__c = '';
        }
        
    }
}