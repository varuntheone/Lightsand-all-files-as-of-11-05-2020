public class ConvertPOtoOEControllerV1 {

    public List < WrappperVendorPODetail > wrapVPDList {
        get;
        set;
    }
    public List < Vendor_PO_Details__c > selectedVPDs {
        get;
        set;
    }

    public Map < ID, List < Vendor_PO_Details__c > > vpohVPDMap {
        set;
        get;
    }
    public String retailerCodeId {
        get;
        set;
    }
    public boolean isError {
        get;
        set;
    }
    
    public String orderToCompany {
        get;
        set;
    }
    
    public List<Ship_Bill_Address__c> billToAddress{
        get;
        set;
    }
    
    public List<Ship_Bill_Address__c> shipToAddress{
        get;
        set;
    }
    
    public String shipToCountry{
    get;
    set;
    }
    
    public String defaultProdImageId {
        get{
            List<Attachment> attachmentList;
            if(defaultProdImageId==null){
                attachmentList = [Select Id from attachment where Name IN ('NoImageAvailable.jpg') AND Parent.Type='Product__c' limit 1];
                if(attachmentList!=null && !attachmentList.isEmpty()){
                    return attachmentList.get(0).Id;
                }
            }
            return defaultProdImageId;
        }
        set;
    }
    
    public Map < ID, Vendor_PO_Header__c > vendorPoHeaderMap {get;set;}
    public List<Online_Enquiry__c> todaysOnlineEnquiryList{get;set;}
    
    public ConvertPOtoOEControllerV1() {

        //-- Default Address
        billToAddress = [Select Id,Address_1__c,Address_2__c,Factory_Name__c,State__c,Postcode__c,Country__c,Contact__c,
        Tel_No__c,Fax_No__c,Email_Address__c from Ship_Bill_Address__c where RecordType.DeveloperName='Bill_To' order by LastModifiedDate DESC Limit 1];
        
        shipToAddress = [Select Id,Address_1__c,Address_2__c,Factory_Name__c,State__c,Postcode__c,Country__c,Contact__c,
        Tel_No__c,Fax_No__c,Email_Address__c from Ship_Bill_Address__c where RecordType.DeveloperName='Ship_To' order by LastModifiedDate DESC Limit 1];
        if(shipToAddress!=null && !shipToAddress.isEmpty()){
            shipToCountry = shipToAddress.get(0).Country__c;
        }
        System.debug('shipToCountry:' + shipToCountry);
        //-- get retailer code from parameter
        retailerCodeId = apexpages.currentpage().getparameters().get('RetailerCodeId');

        //-- select retailer mandatory parameter
        if (RetailerCodeId == null || String.isEmpty(RetailerCodeId)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Selected RetailerCodeId is missing in url as parameter.Please contact Mainetti support for the same.'));
            isError = true;
        }

        todaysOnlineEnquiryList = [SELECT Id, Name,Retailer_Code__c, Enquiry_Status__c,Order_Country__c,Enquiry_Date__c,Ship_to_Country__c,CreatedDate FROM Online_Enquiry__c WHERE CreatedDate = TODAY Order By CreatedDate DESC];
        
        if (wrapVPDList == null) {
            wrapVPDList = new List < WrappperVendorPODetail > ();
            List < User > userList = [Select Id, ContactId,Order_to_Company__c from User where Id =: UserInfo.getUserId()];
            //List < User > userList = [Select Id, ContactId,Order_to_Company__c from User where Id = '005p0000001EsVY'];
            if (userList != null && !userList.isEmpty() && String.isNotEmpty(userList.get(0).ContactId)) {
                orderToCompany = userList.get(0).Order_to_Company__c;
                List < Contact_Related_Retailer__c > contactRelRetailer = [Select Id, Customer_Name__c, Customer_Name__r.National_Vendor_ID__c,  Retailer_Code__c, Retailer_Code__r.Online_Order_convert_from_PO__c from Contact_Related_Retailer__c where Contact__c =: userList.get(0).ContactID AND Retailer_Code__c =: retailerCodeId
                    AND Customer_Name__r.Source__c = 'Brazil Portal'
                ];
                //Retailer_Code__r.Name = 'LOJAS RENNER'
                if (contactRelRetailer != null && !contactRelRetailer.isEmpty()) {
                    System.debug('National_Vendor_ID__c:' + contactRelRetailer.get(0).Customer_Name__r.National_Vendor_ID__c);
                    System.debug('Online_Order_convert_from_PO__c:' + contactRelRetailer.get(0).Retailer_Code__r.Online_Order_convert_from_PO__c);
                    if (contactRelRetailer.get(0).Retailer_Code__r.Online_Order_convert_from_PO__c) {
                        //--    
                        if (contactRelRetailer != null && !contactRelRetailer.isEmpty()) {
                            //String userNationalVendorID = contactRelRetailer.get(0).Customer_Name__r.National_Vendor_ID__c;
                            String userFactoryID = contactRelRetailer.get(0).Customer_Name__r.National_Vendor_ID__c;
                            retailerCodeId = contactRelRetailer.get(0).Retailer_Code__c;
                            vendorPoHeaderMap = new Map < ID, Vendor_PO_Header__c > ([Select Id, Name,Ship_to_Country__c from Vendor_PO_Header__c where Factory_ID__c =: userFactoryID]);
                            vpohVPDMap = new Map < ID, List < Vendor_PO_Details__c > > ();
                            for (Vendor_PO_Details__c eachPOD: [select Id, Name, Vendor_PO_ID__c,Vendor_PO_ID__r.Name,Vendor_PO_ID__r.Ship_to_Country__c, Vendor_PO_ID__r.PO_Date__c, Quantity__c,Vendor_PO_ID__r.Factory_Name__c, Retail_Price__c, Product_Code__c, Color_Code__c, Color_Description__c, Size_Code__c, Size_Description__c, Style_Description__c from Vendor_PO_Details__c where Vendor_PO_ID__c IN: vendorPoHeaderMap.keySet() AND Is_Converted__c = FALSE AND Status__c NOT IN ('Delete','Cancel') order By Vendor_PO_ID__r.PO_Date__c DESC]) {
                                wrapVPDList.add(new WrappperVendorPODetail(eachPOD));

                                //-- map to create online enquiry
                                if (vpohVPDMap.containsKey(eachPOD.Vendor_PO_ID__c)) {
                                    (vpohVPDMap.get(eachPOD.Vendor_PO_ID__c)).add(eachPOD);
                                } else {
                                    vpohVPDMap.put(eachPOD.Vendor_PO_ID__c, new List < Vendor_PO_Details__c > {
                                        eachPOD
                                    });
                                }
                            }
                        }
                    } else {
                        // 
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'you do not have sufficient access to Online Order convert from PO. Please contact Mainetti support for the same.'));
                        isError = true;
                    }
                } else {
                    // factory id mapping does not exist.
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Factory_ID__c is not mapped with your National_Vendor_ID__c. Please contact Mainetti support for the same.'));
                    isError = true;
                }
            }
        }
    }

    public void processSelected() {
        selectedVPDs = new List < Vendor_PO_Details__c > ();

        for (WrappperVendorPODetail eachVPD: wrapVPDList) {
            if (eachVPD.isSelected == true) {
                selectedVPDs.add(eachVPD.vPoDetail);
            }
        }
    }

    public PageReference convertSelectVPDtoOE() {
    
        Savepoint sp = Database.setSavepoint();
        List<WrappperVendorPODetail> unselectedSelectedVPDs = new List<WrappperVendorPODetail>(); 
        try{
        Set < String > selectedVPHIds = new Set < String > ();
        Set < String > selectedVPDIds = new Set < String > ();
        Set < String > productCodeList = new Set < String > ();
        Set < String > shipToCountryList = new Set < String > ();
        
        for (WrappperVendorPODetail eachVPD: wrapVPDList) {
            if (eachVPD.isSelected == true) {
                selectedVPHIds.add(eachVPD.vPoDetail.Vendor_PO_ID__c);
                selectedVPDIds.add(eachVPD.vPoDetail.ID);
                if(String.isNotEmpty(eachVPD.vPoDetail.Product_Code__c))
                productCodeList.add(eachVPD.vPoDetail.Product_Code__c);
                
                if(shipToCountry!=null 
                && String.isNotEmpty(shipToCountry))
                {
                    shipToCountryList.add(shipToCountry);
                }
                //shipToCountryList.add(eachVPD.vPoDetail.Vendor_PO_ID__r.Ship_to_Country__c);
            }else{
                if(!unselectedSelectedVPDs.contains(eachVPD))
                unselectedSelectedVPDs.add(eachVPD);
            }
        }

        if(selectedVPDIds!=null && !selectedVPDIds.isEmpty()){
        List < RecordType > oeRecordTypeList = [SELECT Id FROM RecordType WHERE IsActive = TRUE AND sObjectType = 'Online_Enquiry__c'
            AND DeveloperName = 'Standard_Order'
        ];
        String standardOrderRecordTypeID;
        if (oeRecordTypeList != null && !oeRecordTypeList.isEmpty()) {
            standardOrderRecordTypeID = oeRecordTypeList.get(0).Id;
        }

        
        //-- create online enquiry
        List < Online_Enquiry__c > onlineEnquiryList = new List < Online_Enquiry__c > ();
        for (String eachPoHeaderId: vpohVPDMap.keyset()) {
            if (selectedVPHIds.contains(eachPoHeaderId)) {
                Online_Enquiry__c onlineEnqury = new Online_Enquiry__c();
                onlineEnqury.RecordTypeId = standardOrderRecordTypeID;
                onlineEnqury.Retailer_Code_Hidden__c = retailerCodeId;
                onlineEnqury.Retailer_Code__c = retailerCodeId;
                onlineEnqury.Vendor_PO_Header__c = eachPoHeaderId;
                onlineEnqury.Order_Country__c = orderToCompany;
                setBillToAddress(onlineEnqury);
                setShipToAddress(onlineEnqury);
                onlineEnquiryList.add(onlineEnqury);
                }
                
        }
        insert onlineEnquiryList;

        Map < String, Id > poHeaderIdOnlineEnqIdMap = new Map < String, Id > ();
        for (Online_Enquiry__c eachOE: onlineEnquiryList) {
            poHeaderIdOnlineEnqIdMap.put(eachOE.Vendor_PO_Header__c, eachOE.Id);
        }
        
        //-- query all price books
        String errorList='';
        //Map<String> prodcutIdList = new Set<String>();
        Map<String,String> productIdMap = new Map<String,String>(); 
        Map<String,String> priceBookProdImageIdMap = new Map<String,String>(); 
        System.debug('productCodeList:'+productCodeList+':retailerCodeId:'+retailerCodeId+':shipToCountryList:'+shipToCountryList+':orderToCompany:'+orderToCompany);
        List<Price_Specification_Book_Product__c> priceSpecificationBookProdList = [Select Id,Name,Country__c,Customer_Ref_Model__c,Product_Unique_ID__c from Price_Specification_Book_Product__c where Customer_Ref_Model__c IN:productCodeList AND 
        Price_Specification_Book__r.Book_Status__c='Active' and 
                         Price_Specification_Book__r.RecordTypeId='01290000000RyBQ' and
                         Product_Status__c='Active' and 
                         Retailer_Code__c = :retailerCodeId and
                         (Country__c IN :shipToCountryList or
                         Order_to_Company__c = :orderToCompany)];
            System.debug('priceSpecificationBookProdList:' + priceSpecificationBookProdList);
        Map<String,String> productCodeProductIdMap = new Map<String,String>();      
        if(priceSpecificationBookProdList!=null && !priceSpecificationBookProdList.isEmpty()){
            for(Price_Specification_Book_Product__c eachPriceBook : priceSpecificationBookProdList){
                productCodeProductIdMap.put(eachPriceBook.Customer_Ref_Model__c+'###'+eachPriceBook.Country__c+'###'+orderToCompany,eachPriceBook.ID);
                productIdMap.Put(eachPriceBook.Product_Unique_ID__c,eachPriceBook.Customer_Ref_Model__c+'###'+eachPriceBook.Country__c+'###'+orderToCompany);
            }
        }       
        System.debug('productCodeProductIdMap:' + productCodeProductIdMap);
        // query product image
        for(List<Attachment> productList : [Select Id,Name,ParentId from Attachment where ParentId IN:productIdMap.keyset() order by CreatedDate DESC])
        {
            for(Attachment eachAttachment : productList){
                if(productIdMap.containsKey(eachAttachment.ParentId) 
                && !priceBookProdImageIdMap.containsKey(productIdMap.get(eachAttachment.ParentId))){
                    priceBookProdImageIdMap.put(productIdMap.get(eachAttachment.ParentId),eachAttachment.Id);
                }
            }
        }
        
        
        //-- create online details
        List < Online_Detail__c > onlineDetailList = new List < Online_Detail__c > ();
        for (List < Vendor_PO_Details__c > poDetailList: vpohVPDMap.values()) {
            for (Vendor_PO_Details__c eacPoDetail: poDetailList) {
                if (selectedVPDIds.contains(eacPoDetail.ID)) {
                    Online_Detail__c newOnlineDetail = new Online_Detail__c();
                    newOnlineDetail.Qty__c = eacPoDetail.Quantity__c;
                    //newOnlineDetail.Product_Image_ID__c = '00Pp0000008xbz8';
                    /*
                    if(priceBookProdImageIdMap.containsKey(eacPoDetail.Product_Code__c+'###'+eacPoDetail.Vendor_PO_ID__r.Ship_to_Country__c+'###'+orderToCompany)){
                        newOnlineDetail.Product_Image_ID__c = priceBookProdImageIdMap.get(eacPoDetail.Product_Code__c+'###'+eacPoDetail.Vendor_PO_ID__r.Ship_to_Country__c+'###'+orderToCompany);
                    }*/
                    if(priceBookProdImageIdMap.containsKey(eacPoDetail.Product_Code__c+'###'+shipToCountry+'###'+orderToCompany)){
                        newOnlineDetail.Product_Image_ID__c = priceBookProdImageIdMap.get(eacPoDetail.Product_Code__c+'###'+shipToCountry+'###'+orderToCompany);
                    }
                    else{
                        //newOnlineDetail.Product_Image_ID__c = '00Pp0000008xbz8';
                        newOnlineDetail.Product_Image_ID__c = defaultProdImageId;
                        
                    }
                    if(String.isNotEmpty(eacPoDetail.Product_Code__c)){
                        //newOnlineDetail.Model__c = [Select Id,Name from Price_Specification_Book_Product__c where Customer_Ref_Model__c=:eacPoDetail.Product_Code__c limit 1].Id;
                        //if(productCodeProductIdMap.containsKey(eacPoDetail.Product_Code__c+'###'+eacPoDetail.Vendor_PO_ID__r.Ship_to_Country__c+'###'+orderToCompany)){
                      if(productCodeProductIdMap.containsKey(eacPoDetail.Product_Code__c+'###'+shipToCountry+'###'+orderToCompany)){
                            //newOnlineDetail.Model__c = productCodeProductIdMap.get(eacPoDetail.Product_Code__c+'###'+eacPoDetail.Vendor_PO_ID__r.Ship_to_Country__c+'###'+orderToCompany);
                            newOnlineDetail.Model__c = productCodeProductIdMap.get(eacPoDetail.Product_Code__c+'###'+shipToCountry+'###'+orderToCompany);
                        }else{
                            if(errorList!=null && String.isNotEmpty(errorList)){
                                errorList = errorList + ',' +eacPoDetail.Name;
                            }else{
                                errorList = eacPoDetail.Name;
                            }
                        }
                    }else{
                        if(errorList!=null && String.isNotEmpty(errorList)){
                                errorList = errorList + ',' +eacPoDetail.Name;
                            }else{
                                errorList = eacPoDetail.Name;
                            }
                    }
                    
                    
                    newOnlineDetail.TransactionID__c = poHeaderIdOnlineEnqIdMap.get(eacPoDetail.Vendor_PO_ID__c);
                    onlineDetailList.add(newOnlineDetail);
                }
            }
        }
        
        if(errorList!=null && String.isNotEmpty(errorList) && String.isNotBlank(errorList))
        {
            // show error to user
            Database.rollback(sp);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Product Code is missing/not mapped for these Vendor PO Details[ '
            +errorList+' ]. Please contact Mainetti Support for the same.'));
            if(!unselectedSelectedVPDs.isEmpty()){
                unselectedSelectedVPDs.clear();
            }
            return null;
        }
        
        insert onlineDetailList;
        
        // update VPD checkbox
        List<Vendor_PO_Details__c> updateVPDList = new List<Vendor_PO_Details__c>();
        for(String eachVPDId :selectedVPDIds){
            Vendor_PO_Details__c updateVPD = new Vendor_PO_Details__c();
            updateVPD.Id = eachVPDId;
            updateVPD.Is_Converted__c=TRUE;
            updateVPDList.add(updateVPD);
        }
        update updateVPDList;
        
        todaysOnlineEnquiryList = [SELECT Id, Name,Retailer_Code__c, Enquiry_Status__c,Order_Country__c,Enquiry_Date__c,Ship_to_Country__c,CreatedDate FROM Online_Enquiry__c WHERE CreatedDate = TODAY Order By CreatedDate DESC];
        }else{
            // show error to user
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Please select at least one row for conversion'));
            return null;
        }
        }catch(Exception convertEx){
            // Roll back to the previous state
            Database.rollback(sp);
            
            // show error to user
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error while convertion PO to'+ 
            'Online Enquiry:'+convertEx.getMessage()));
            return null;
        }

            
        wrapVPDList = unselectedSelectedVPDs;   
        
        // show error to user
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Selected rows converted to Online Enquiry successfully.'+
        'Please see the created online enquiry at the bottom of the page.'));
        PageReference convertOrderVF = new PageReference('/apex/ConvertPOtoOEVF?RetailerCodeId='+retailerCodeId);
        //convertOrderVF.setRedirect(true);
        return convertOrderVF;
    }

    public PageReference goToOE() {
        return new PageReference('/a0f/o');
    }
    
    public PageReference cancel() {
        return new PageReference('/a0f/o');
    }
    
    public class WrappperVendorPODetail {
        public Vendor_PO_Details__c vPoDetail {
            get;
            set;
        }
        public Boolean isSelected {
            get;
            set;
        }

        public WrappperVendorPODetail(Vendor_PO_Details__c vPoDetail) {
            this.vPoDetail = vPoDetail;
            this.isSelected = false;
        }
    }
    
    private Online_Enquiry__c setBillToAddress(Online_Enquiry__c onlineEnqury){
        if(billToAddress!=null && !billToAddress.isEmpty()){
            Ship_Bill_Address__c billToAddr = billToAddress.get(0);
            if(billToAddr!=null){
                onlineEnqury.Bill_To__c = billToAddr.Id;
                if(billToAddr.Address_1__c!=null 
                && String.isNotEmpty(billToAddr.Address_1__c)){
                    onlineEnqury.Bill_to_Address1__c = billToAddr.Address_1__c;
                }
                if(billToAddr.Address_2__c!=null 
                && String.isNotEmpty(billToAddr.Address_2__c)){
                onlineEnqury.Bill_to_Address2__c = billToAddr.Address_2__c;
                }

                if(billToAddr.Factory_Name__c!=null 
                && String.isNotEmpty(billToAddr.Factory_Name__c)){
                onlineEnqury.Bill_to_Company__c = billToAddr.Factory_Name__c;
                }
                if(billToAddr.Contact__c!=null 
                && String.isNotEmpty(billToAddr.Contact__c)){
                onlineEnqury.Bill_to_Contact__c = billToAddr.Contact__c;
                }

                if(billToAddr.Country__c!=null 
                && String.isNotEmpty(billToAddr.Country__c)){

                onlineEnqury.Bill_to_Country__c = billToAddr.Country__c;
                }
                if(billToAddr.Email_Address__c!=null 
                && String.isNotEmpty(billToAddr.Email_Address__c)){
                onlineEnqury.Bill_to_Email__c = billToAddr.Email_Address__c;
                }

                if(billToAddr.Fax_No__c!=null 
                && String.isNotEmpty(billToAddr.Fax_No__c)){
                onlineEnqury.Bill_to_Fax__c = billToAddr.Fax_No__c;
                }

                if(billToAddr.Postcode__c!=null 
                && String.isNotEmpty(billToAddr.Postcode__c)){
                onlineEnqury.Bill_to_Postcode__c = billToAddr.Postcode__c;
                }

                if(billToAddr.State__c!=null 
                && String.isNotEmpty(billToAddr.State__c)){
                onlineEnqury.Bill_to_State__c = billToAddr.State__c;
                }

                if(billToAddr.Tel_No__c!=null 
                && String.isNotEmpty(billToAddr.Tel_No__c)){
                onlineEnqury.Bill_to_Tel__c = billToAddr.Tel_No__c;
                }
            }
        }

        return onlineEnqury;
        }
        
        
        private Online_Enquiry__c setShipToAddress(Online_Enquiry__c onlineEnqury){
        if(shipToAddress!=null && !shipToAddress.isEmpty()){
                    Ship_Bill_Address__c shipToAddr = shipToAddress.get(0);
                    if(shipToAddr!=null){
                        onlineEnqury.Ship_To__c = shipToAddr.Id;
                        if(shipToAddr.Address_1__c!=null 
                        && String.isNotEmpty(shipToAddr.Address_1__c)){
                            onlineEnqury.Ship_to_Address1__c = shipToAddr.Address_1__c;
                        }
                                                if(shipToAddr.Address_2__c!=null 
                        && String.isNotEmpty(shipToAddr.Address_2__c)){
                        onlineEnqury.Ship_to_Address2__c = shipToAddr.Address_2__c;
                        }
                        
                                                if(shipToAddr.Factory_Name__c!=null 
                        && String.isNotEmpty(shipToAddr.Factory_Name__c)){
                        onlineEnqury.Ship_to_Company__c = shipToAddr.Factory_Name__c;
                        }
                                                if(shipToAddr.Contact__c!=null 
                        && String.isNotEmpty(shipToAddr.Contact__c)){
                        onlineEnqury.Ship_to_Contact__c = shipToAddr.Contact__c;
                        }
                        
                                                if(shipToAddr.Country__c!=null 
                        && String.isNotEmpty(shipToAddr.Country__c)){
                        
                        onlineEnqury.Ship_to_Country__c = shipToAddr.Country__c;
                        }
                                                if(shipToAddr.Email_Address__c!=null 
                        && String.isNotEmpty(shipToAddr.Email_Address__c)){
                        onlineEnqury.Ship_to_Email__c = shipToAddr.Email_Address__c;
                        }
                        
                                                if(shipToAddr.Fax_No__c!=null 
                        && String.isNotEmpty(shipToAddr.Fax_No__c)){
                        onlineEnqury.Ship_to_Fax__c = shipToAddr.Fax_No__c;
                        }
                        
                                                if(shipToAddr.Postcode__c!=null 
                        && String.isNotEmpty(shipToAddr.Postcode__c)){
                        onlineEnqury.Ship_to_Postcode__c = shipToAddr.Postcode__c;
                        }
                        
                                                if(shipToAddr.State__c!=null 
                        && String.isNotEmpty(shipToAddr.State__c)){
                        onlineEnqury.Ship_to_State__c = shipToAddr.State__c;
                        }
                        
                                                if(shipToAddr.Tel_No__c!=null 
                        && String.isNotEmpty(shipToAddr.Tel_No__c)){
                        onlineEnqury.Ship_to_Tel__c = shipToAddr.Tel_No__c;
                        }
                    }
                }

        return onlineEnqury;
        }
}