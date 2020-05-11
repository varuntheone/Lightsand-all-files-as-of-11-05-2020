public class ConvertPOtoOEController {

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
    public String retailerCodeName {
        get;
        set;
    }
    public boolean isError {
        get;
        set;
    }

    public boolean isNoSelected {
        get;
        set;
    }

    public boolean isNoOnlineEnquiry {
        get;
        set;
    }
    public String orderToCompany {
        get;
        set;
    }

    public List < Ship_Bill_Address__c > billToAddress {
        get;
        set;
    }

    public List < Ship_Bill_Address__c > shipToAddress {
        get;
        set;
    }

    public String shipToCountry {
        get;
        set;
    }

    public boolean isEnableScroll {
        get;
        set;
    }

    public boolean isEnableScrollForOE {
        get;
        set;
    }

    public boolean isEnableScrollForOD {
        get;
        set;
    }

    // -- get default attachment ID
    public String defaultProdImageId {
        get {
            if (defaultProdImageId == null) {
                List < Attachment > attachmentList = [Select Id from attachment where Name IN('NoImageAvailable.jpg') AND Parent.Type = 'Product__c'
                    limit 1
                ];
                if (attachmentList != null && !attachmentList.isEmpty()) {
                    defaultProdImageId = attachmentList.get(0).Id;
                }
            }
            return defaultProdImageId;
        }
        set;
    }

    public String retailerImageId {
        get {
            if (retailerImageId == null) {
                List < Attachment > attachmentList = [select Id from Attachment where 
                parentId =:this.retailerCodeId order By LastModifiedDate DESC limit 1];
                if (attachmentList != null && !attachmentList.isEmpty()) {
                    retailerImageId = attachmentList.get(0).Id;
                }
            }
            return retailerImageId;
        }
        set;
    }
    
    public Map < ID, Vendor_PO_Header__c > vendorPoHeaderMap {
        get;
        set;
    }
    
    public List < Online_Enquiry__c > todaysOnlineEnquiryList {
        get{
            todaysOnlineEnquiryList = [SELECT Id, Name, Retailer_Code__c, Enquiry_Status__c, Order_Country__c, Enquiry_Date__c, 
            Ship_to_Country__c, CreatedDate FROM Online_Enquiry__c 
            WHERE CreatedDate = TODAY Order By CreatedDate DESC];

            if (!todaysOnlineEnquiryList.isEmpty()) {
                isNoOnlineEnquiry = FALSE;
            }
            return todaysOnlineEnquiryList;
        }
        set;
    }
    
    //-- record type ID for standard Order
    public String standardOrderRecordTypeID {
        get {
            if (standardOrderRecordTypeID == null) {
                List < RecordType > oeRecordTypeList = [SELECT Id FROM RecordType WHERE IsActive = TRUE 
                AND sObjectType = 'Online_Enquiry__c' AND DeveloperName = 'Standard_Order' ];
                if (oeRecordTypeList != null && !oeRecordTypeList.isEmpty()) {
                    standardOrderRecordTypeID = oeRecordTypeList.get(0).Id;
                }
            }
            return standardOrderRecordTypeID;
        }
        set;
    }
    
    public static final INTEGER MAXHEIGHTFOROE = 5;
    public static final INTEGER MAXHEIGHTFOROD = 20;

    /*
     * Constructor
     */
    public ConvertPOtoOEController() {
    
        selectedVPDs = new List < Vendor_PO_Details__c > ();
        
        //-- all helper variables.
        isNoSelected = TRUE;
        isNoOnlineEnquiry = TRUE;
        isEnableScrollForOE = FALSE;
        isEnableScrollForOD = FALSE;
        
        //-- Default Address
        billToAddress = [Select Id, Address_1__c, Address_2__c, Factory_Name__c, State__c, Postcode__c, Country__c, Contact__c,
            Tel_No__c, Fax_No__c, Email_Address__c from Ship_Bill_Address__c where RecordType.DeveloperName = 'Bill_To'
            order by LastModifiedDate DESC Limit 1
        ];

        shipToAddress = [Select Id, Address_1__c, Address_2__c, Factory_Name__c, State__c, Postcode__c, Country__c, Contact__c,
            Tel_No__c, Fax_No__c, Email_Address__c from Ship_Bill_Address__c where RecordType.DeveloperName = 'Ship_To'
            order by LastModifiedDate DESC Limit 1
        ];
        if (shipToAddress != null && !shipToAddress.isEmpty()) {
            shipToCountry = shipToAddress.get(0).Country__c;
        }
        System.debug(LoggingLevel.INFO,'shipToCountry:' + shipToCountry);
        //--END
        
        //-- get retailer code from parameter
        retailerCodeId = apexpages.currentpage().getparameters().get('RetailerCodeId');

        //-- select retailer mandatory parameter
        if (RetailerCodeId == null || String.isEmpty(RetailerCodeId)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Selected RetailerCodeId is missing in url '
            +'as parameter.Please contact Mainetti support for the same.'));
            isError = true;
        }

        //-- get all on-line enquiry created today.
        todaysOnlineEnquiryList = this.todaysOnlineEnquiryList;
        //--END
        
        //-- collect all POH and VPD    
        if (wrapVPDList == null) {
        
            wrapVPDList = new List < WrappperVendorPODetail > ();
            
            List < User > userList = [Select Id, ContactId, Order_to_Company__c from User where Id =: UserInfo.getUserId()];
            //List < User > userList = [Select Id, ContactId,Order_to_Company__c from User where Id = '005p0000001EsVY'];
            
            //-- user must have contact associated i.e. PORTAL USER
            if (userList != null && !userList.isEmpty() && String.isNotEmpty(userList.get(0).ContactId)) {
            
                //-- get contact related retailer
                orderToCompany = userList.get(0).Order_to_Company__c;
                List < Contact_Related_Retailer__c > contactRelRetailer = [Select Id, Customer_Name__c, Customer_Name__r.National_Vendor_ID__c, 
                Retailer_Code__c, Retailer_Code__r.Online_Order_convert_from_PO__c,Retailer_Code__r.Name from Contact_Related_Retailer__c 
                where Contact__c =: userList.get(0).ContactID AND Retailer_Code__c =: retailerCodeId
                    AND Customer_Name__r.Source__c = 'Brazil Portal'
                ];
                //Retailer_Code__r.Name = 'LOJAS RENNER'
                //--END
                
                //--get all PO available for conversion
                if (contactRelRetailer != null && !contactRelRetailer.isEmpty()) {
                    
                    //--just debug info
                    System.debug(LoggingLevel.INFO,'National_Vendor_ID__c:' 
                    + contactRelRetailer.get(0).Customer_Name__r.National_Vendor_ID__c);
                    System.debug(LoggingLevel.INFO,'Online_Order_convert_from_PO__c:' 
                    + contactRelRetailer.get(0).Retailer_Code__r.Online_Order_convert_from_PO__c);
                    
                    //-- have convert access
                    if (contactRelRetailer.get(0).Retailer_Code__r.Online_Order_convert_from_PO__c) {
                         
                            //-- available PO to convert for log in user
                            String userFactoryID = contactRelRetailer.get(0).Customer_Name__r.National_Vendor_ID__c;
                            retailerCodeName = contactRelRetailer.get(0).Retailer_Code__r.Name;
                            
                            //retailerCodeId = contactRelRetailer.get(0).Retailer_Code__c;
                            vendorPoHeaderMap = new Map < ID, Vendor_PO_Header__c > ([Select Id, Name, PO_Date__c, Factory_Name__c, 
                            PO_Number__c, Ship_to_Country__c from Vendor_PO_Header__c where 
                            Factory_ID__c =: userFactoryID order by PO_Date__c DESC]);
                            //--END
                            
                            //--query all PO details for corresponding PO Header
                            vpohVPDMap = new Map < ID, List < Vendor_PO_Details__c > > ();
                            for (Vendor_PO_Details__c eachPOD: [select Id, Name, Vendor_PO_ID__c, Vendor_PO_ID__r.Name, Vendor_PO_ID__r.Ship_to_Country__c, 
                            Vendor_PO_ID__r.PO_Number__c, Vendor_PO_ID__r.PO_Date__c, Quantity__c, Vendor_PO_ID__r.Factory_Name__c, Retail_Price__c, 
                            Product_Code__c, Color_Code__c, Color_Description__c, Size_Code__c, Size_Description__c, Style_Description__c, 
                            Delivery_Date__c from Vendor_PO_Details__c where Vendor_PO_ID__c IN: vendorPoHeaderMap.keySet() AND Is_Converted__c = FALSE 
                            AND Status__c NOT IN('Delete', 'Cancel') order By Vendor_PO_ID__r.PO_Date__c DESC]) {

                                //-- map to create on-line enquiry
                                if (vpohVPDMap.containsKey(eachPOD.Vendor_PO_ID__c)) {
                                    (vpohVPDMap.get(eachPOD.Vendor_PO_ID__c)).add(eachPOD);
                                } else {
                                    vpohVPDMap.put(eachPOD.Vendor_PO_ID__c, new List < Vendor_PO_Details__c > {
                                        eachPOD
                                    });
                                }
                                
                            }
                            //--END
                            
                            //-- collect PO Header ID
                            for (String eachPoHeadeId: vpohVPDMap.keySet()) {
                                wrapVPDList.add(new WrappperVendorPODetail(
                                    vendorPoHeaderMap.get(eachPoHeadeId),
                                    vpohVPDMap.get(eachPoHeadeId)));
                            }

                            if (vendorPoHeaderMap != null && vendorPoHeaderMap.size() > MAXHEIGHTFOROE) {
                                isEnableScrollForOE = TRUE;
                            }
                            //--END

                    } else {
                        // flash error message
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'you do not have sufficient access to Online Order'+
                        'convert from PO. Please contact Mainetti support for the same.'));
                        isError = true;
                    }
                } else {
                    // factory id mapping does not exist.
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Factory_ID__c is not mapped with your '
                    +'National_Vendor_ID__c. Please contact Mainetti support for the same.'));
                    isError = true;
                }
                
            }//--end:user
            
        }//--end:wrapVPDList
        
    }//END:ConvertPOtoOEController

    /*
     * This gets called when you select PO.
     */
    public void processSelected() {
    
        //-- helper variables
        isNoSelected = TRUE;
        isError = FALSE;
        isEnableScrollForOD = FALSE;
        
        if (!selectedVPDs.isEmpty()) {
            selectedVPDs.clear();
        }
        
        //filter selected one
        for (WrappperVendorPODetail eachVPD: wrapVPDList) {
            if (eachVPD.isSelected == true) {
            
                isNoSelected = FALSE;
            
                if (eachVPD != null && eachVPD.vPoDetail != null) {
                    selectedVPDs.addAll(eachVPD.vPoDetail);
                }
            }
        }
        //--END
        
        // enable scroll
        if (selectedVPDs.size() > MAXHEIGHTFOROD) {
            isEnableScrollForOD = TRUE;
        }
        
    }//--END:processSelected

    /*
     * This gets called when click on 'Convert To Online Enquiry'.
     */
    public PageReference convertSelectVPDtoOE() {

        //-- create save point
        Savepoint sp = Database.setSavepoint();
        
        List < WrappperVendorPODetail > unselectedSelectedVPDs = new List < WrappperVendorPODetail > ();
        try {
        
            //-- get all selected PO Header->PO Details
            Set < String > selectedVPHIds = new Set < String > ();
            Set < String > selectedVPDIds = new Set < String > ();
            Set < String > productCodeList = new Set < String > ();
            Set < String > shipToCountryList = new Set < String > ();

            for (WrappperVendorPODetail eachVPD: wrapVPDList) {
            
                if (eachVPD.isSelected == true) {
                    for (Vendor_PO_Details__c eachPoDetail: eachVPD.vPoDetail) {
                        selectedVPHIds.add(eachPoDetail.Vendor_PO_ID__c);
                        selectedVPDIds.add(eachPoDetail.ID);
                        if (String.isNotEmpty(eachPoDetail.Product_Code__c)) {
                            productCodeList.add(eachPoDetail.Product_Code__c);
                        }
                    }
                    
                    if (shipToCountry != null &&
                        String.isNotEmpty(shipToCountry)) {
                        shipToCountryList.add(shipToCountry);
                    }
                    
                } else {
                
                    if (!unselectedSelectedVPDs.contains(eachVPD)){
                        unselectedSelectedVPDs.add(eachVPD);
                    }
                }
                
            }
            //-- END
            
            if (selectedVPDIds != null && !selectedVPDIds.isEmpty()) {
                //-- create on-line enquiry
                List < Online_Enquiry__c > onlineEnquiryList = new List < Online_Enquiry__c > ();
                for (String eachPoHeaderId: vpohVPDMap.keyset()) {
                    if (selectedVPHIds.contains(eachPoHeaderId)) {
                        Online_Enquiry__c onlineEnqury = new Online_Enquiry__c();
                        onlineEnqury.RecordTypeId = standardOrderRecordTypeID;
                        onlineEnqury.Customer_PO_No__c = vendorPoHeaderMap.get(eachPoHeaderId).PO_Number__c;
                        if(String.isNotEmpty(retailerImageId)){
                            onlineEnqury.Retailer_Image_ID__c = retailerImageId;
                        }
                        onlineEnqury.Retailer_Code_Hidden__c = retailerCodeName;
                        onlineEnqury.Retailer_Code__c = retailerCodeId;
                        onlineEnqury.Vendor_PO_Header__c = eachPoHeaderId;
                        onlineEnqury.Order_Country__c = orderToCompany;
                        setBillToAddress(onlineEnqury);
                        setShipToAddress(onlineEnqury);
                        onlineEnquiryList.add(onlineEnqury);
                    }
                }
                
                if(onlineEnquiryList!=null && !onlineEnquiryList.isEmpty()){
                    insert onlineEnquiryList;
                }
            
                Map < String, Id > poHeaderIdOnlineEnqIdMap = new Map < String, Id > ();
                for (Online_Enquiry__c eachOE: onlineEnquiryList) {
                    poHeaderIdOnlineEnqIdMap.put(eachOE.Vendor_PO_Header__c, eachOE.Id);
                }
                //--END

                //-- query all price books
                String errorList = '';
                System.debug(LoggingLevel.INFO,'productCodeList:' + productCodeList + 'retailerCodeName:'
                +retailerCodeName+':retailerCodeId:' + retailerCodeId + ':shipToCountryList:' 
                + shipToCountryList + ':orderToCompany:' + orderToCompany);
                
                //--filtering product to get Sales force Product ID based on Brazil Product Code.
                List < Price_Specification_Book_Product__c > priceSpecificationBookProdList = [Select Id, Name, Country__c, Customer_Ref_Model__c, 
                Product_Unique_ID__c from Price_Specification_Book_Product__c where Customer_Ref_Model__c IN: productCodeList AND
                    Price_Specification_Book__r.Book_Status__c = 'Active'
                    and
                    Price_Specification_Book__r.RecordTypeId = '01290000000RyBQ'
                    and
                    Product_Status__c = 'Active'
                    and
                    Retailer_Code__c =: retailerCodeId and(Country__c IN: shipToCountryList or Order_to_Company__c =: orderToCompany)
                ];
                System.debug(LoggingLevel.INFO,'priceSpecificationBookProdList:' + priceSpecificationBookProdList);
                //--END
                
                //-- create MAP for Product Code->Product ID
                Map < String, String > productIdMap = new Map < String, String > ();
                Map < String, String > productCodeProductIdMap = new Map < String, String > ();
                if (priceSpecificationBookProdList != null && !priceSpecificationBookProdList.isEmpty()) {
                    for (Price_Specification_Book_Product__c eachPriceBook: priceSpecificationBookProdList) {
                        productCodeProductIdMap.put(eachPriceBook.Customer_Ref_Model__c + '###' + eachPriceBook.Country__c + 
                        '###' + orderToCompany, eachPriceBook.ID);
                        productIdMap.Put(eachPriceBook.Product_Unique_ID__c, eachPriceBook.Customer_Ref_Model__c + 
                        '###' + eachPriceBook.Country__c + '###' + orderToCompany);
                    }
                }
                System.debug(LoggingLevel.INFO,'productCodeProductIdMap:' + productCodeProductIdMap);
                //--END
                
                // query product image
                Map < String, String > priceBookProdImageIdMap = new Map < String, String > ();
                for (List < Attachment > productList: [Select Id, Name, ParentId from Attachment where 
                ParentId IN: productIdMap.keyset() order by CreatedDate DESC]) {
                    for (Attachment eachAttachment: productList) {
                        if (productIdMap.containsKey(eachAttachment.ParentId) &&
                            !priceBookProdImageIdMap.containsKey(productIdMap.get(eachAttachment.ParentId))) {
                            priceBookProdImageIdMap.put(productIdMap.get(eachAttachment.ParentId), eachAttachment.Id);
                        }
                    }
                }
                System.debug(LoggingLevel.INFO,'priceBookProdImageIdMap:' + priceBookProdImageIdMap);
                //--END

                //-- create on-line details
                List < Online_Detail__c > onlineDetailList = new List < Online_Detail__c > ();
                for (List < Vendor_PO_Details__c > poDetailList: vpohVPDMap.values()) {
                    for (Vendor_PO_Details__c eacPoDetail: poDetailList) {
                        if (selectedVPDIds.contains(eacPoDetail.ID)) {
                            Online_Detail__c newOnlineDetail = new Online_Detail__c();
                            newOnlineDetail.Qty__c = eacPoDetail.Quantity__c;
                            if (priceBookProdImageIdMap.containsKey(eacPoDetail.Product_Code__c + '###' + shipToCountry + 
                            '###' + orderToCompany)) {
                                newOnlineDetail.Product_Image_ID__c = priceBookProdImageIdMap.get(eacPoDetail.Product_Code__c + 
                                '###' + shipToCountry + '###' + orderToCompany);
                            } else {
                                //newOnlineDetail.Product_Image_ID__c = '00Pp0000008xbz8';
                                newOnlineDetail.Product_Image_ID__c = defaultProdImageId;
                            }
                            
                            if (String.isNotEmpty(eacPoDetail.Product_Code__c)) {
                                if (productCodeProductIdMap.containsKey(eacPoDetail.Product_Code__c + '###' + shipToCountry + 
                                '###' + orderToCompany)) {
                                    newOnlineDetail.Model__c = productCodeProductIdMap.get(eacPoDetail.Product_Code__c + '###' + shipToCountry +
                                    '###' + orderToCompany);
                                } else {
                                    if (errorList != null && String.isNotEmpty(errorList)) {
                                        errorList = errorList + ',' + eacPoDetail.Name;
                                    } else {
                                        errorList = eacPoDetail.Name;
                                    }
                                }
                            } else {
                                if (errorList != null && String.isNotEmpty(errorList)) {
                                    errorList = errorList + ',' + eacPoDetail.Name;
                                } else {
                                    errorList = eacPoDetail.Name;
                                }
                            }
                            
                            //-- set On-line Enquiry ID
                            newOnlineDetail.TransactionID__c = poHeaderIdOnlineEnqIdMap.get(eacPoDetail.Vendor_PO_ID__c);
                            onlineDetailList.add(newOnlineDetail);
                        }
                    }
                }
                //--END:create on-line details
                
                //-- flash error if any
                if (errorList != null && String.isNotEmpty(errorList) && String.isNotBlank(errorList)) {
                    //Database.rollback(sp);
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Product Code is missing/not mapped'+
                    'for these Vendor PO Details[ ' +   errorList + ' ]. Please contact Mainetti Support for the same.'));
                    if (!unselectedSelectedVPDs.isEmpty()) {
                        unselectedSelectedVPDs.clear();
                    }
                    return null;
                }
                //--END
                
                //--insert on-line details
                if(onlineDetailList!=null && !onlineDetailList.isEmpty()){
                    insert onlineDetailList;
                }

                // update VPD check box
                List < Vendor_PO_Details__c > updateVPDList = new List < Vendor_PO_Details__c > ();
                for (String eachVPDId: selectedVPDIds) {
                    Vendor_PO_Details__c updateVPD = new Vendor_PO_Details__c();
                    updateVPD.Id = eachVPDId;
                    updateVPD.Is_Converted__c = TRUE;
                    updateVPDList.add(updateVPD);
                }
                if(updateVPDList!=null && !updateVPDList.isEmpty()){
                    update updateVPDList;
                }
                //--END
                
            } else {
            
                // show error to user
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 
                'Please select at least one row for conversion'));
                return null;
                
            }
            
        } catch (Exception convertEx) {
            // Roll back to the previous state
            Database.rollback(sp);

            // show error to user
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error while convertion PO to' +
                'Online Enquiry:' + convertEx.getMessage()));
            return null;
        }

        //--re-assign the original with unselected values
        wrapVPDList = unselectedSelectedVPDs;
        
        //-- refresh on-line enquiry list
        todaysOnlineEnquiryList = this.todaysOnlineEnquiryList;
        
        //--show info to user
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Selected rows converted to Online Enquiry successfully.' +
            'Please see the created online enquiry at the bottom of the page.'));
        PageReference convertOrderVF = new PageReference('/apex/ConvertPOtoOEVF?RetailerCodeId=' + retailerCodeId);
        return convertOrderVF;
        
    }//--END:convertSelectVPDtoOE

    public PageReference cancel() {
        return new PageReference('/a0f/o');
    }

    //-- wrapper class
    public class WrappperVendorPODetail {
        public Vendor_PO_Header__c vPoHeader {
            get;
            set;
        }
        public List < Vendor_PO_Details__c > vPoDetail {
            get;
            set;
        }

        public Boolean isSelected {
            get;
            set;
        }
        
        public WrappperVendorPODetail(Vendor_PO_Header__c vPoHeader, List < Vendor_PO_Details__c > vPoDetail) {
            this.vPoHeader = vPoHeader;
            this.vPoDetail = vPoDetail;
            this.isSelected = false;
        }
    }
    //-- END:WrappperVendorPODetail
    
    //-- set fields of Bill TO.
    private Online_Enquiry__c setBillToAddress(Online_Enquiry__c onlineEnqury) {
        if (billToAddress != null && !billToAddress.isEmpty()) {
            Ship_Bill_Address__c billToAddr = billToAddress.get(0);
            if (billToAddr != null) {
                onlineEnqury.Bill_To__c = billToAddr.Id;
                if (billToAddr.Address_1__c != null &&
                    String.isNotEmpty(billToAddr.Address_1__c)) {
                    onlineEnqury.Bill_to_Address1__c = billToAddr.Address_1__c;
                }
                if (billToAddr.Address_2__c != null &&
                    String.isNotEmpty(billToAddr.Address_2__c)) {
                    onlineEnqury.Bill_to_Address2__c = billToAddr.Address_2__c;
                }

                if (billToAddr.Factory_Name__c != null &&
                    String.isNotEmpty(billToAddr.Factory_Name__c)) {
                    onlineEnqury.Bill_to_Company__c = billToAddr.Factory_Name__c;
                }
                if (billToAddr.Contact__c != null &&
                    String.isNotEmpty(billToAddr.Contact__c)) {
                    onlineEnqury.Bill_to_Contact__c = billToAddr.Contact__c;
                }

                if (billToAddr.Country__c != null &&
                    String.isNotEmpty(billToAddr.Country__c)) {

                    onlineEnqury.Bill_to_Country__c = billToAddr.Country__c;
                }
                if (billToAddr.Email_Address__c != null &&
                    String.isNotEmpty(billToAddr.Email_Address__c)) {
                    onlineEnqury.Bill_to_Email__c = billToAddr.Email_Address__c;
                }

                if (billToAddr.Fax_No__c != null &&
                    String.isNotEmpty(billToAddr.Fax_No__c)) {
                    onlineEnqury.Bill_to_Fax__c = billToAddr.Fax_No__c;
                }

                if (billToAddr.Postcode__c != null &&
                    String.isNotEmpty(billToAddr.Postcode__c)) {
                    onlineEnqury.Bill_to_Postcode__c = billToAddr.Postcode__c;
                }

                if (billToAddr.State__c != null &&
                    String.isNotEmpty(billToAddr.State__c)) {
                    onlineEnqury.Bill_to_State__c = billToAddr.State__c;
                }

                if (billToAddr.Tel_No__c != null &&
                    String.isNotEmpty(billToAddr.Tel_No__c)) {
                    onlineEnqury.Bill_to_Tel__c = billToAddr.Tel_No__c;
                }
            }
        }

        return onlineEnqury;
        
    }//END:setBillToAddress

    //-- set fields of SHIP TO
    private Online_Enquiry__c setShipToAddress(Online_Enquiry__c onlineEnqury) {
        if (shipToAddress != null && !shipToAddress.isEmpty()) {
            Ship_Bill_Address__c shipToAddr = shipToAddress.get(0);
            if (shipToAddr != null) {
                onlineEnqury.Ship_To__c = shipToAddr.Id;
                if (shipToAddr.Address_1__c != null &&
                    String.isNotEmpty(shipToAddr.Address_1__c)) {
                    onlineEnqury.Ship_to_Address1__c = shipToAddr.Address_1__c;
                }
                if (shipToAddr.Address_2__c != null &&
                    String.isNotEmpty(shipToAddr.Address_2__c)) {
                    onlineEnqury.Ship_to_Address2__c = shipToAddr.Address_2__c;
                }

                if (shipToAddr.Factory_Name__c != null &&
                    String.isNotEmpty(shipToAddr.Factory_Name__c)) {
                    onlineEnqury.Ship_to_Company__c = shipToAddr.Factory_Name__c;
                }
                if (shipToAddr.Contact__c != null &&
                    String.isNotEmpty(shipToAddr.Contact__c)) {
                    onlineEnqury.Ship_to_Contact__c = shipToAddr.Contact__c;
                }

                if (shipToAddr.Country__c != null &&
                    String.isNotEmpty(shipToAddr.Country__c)) {

                    onlineEnqury.Ship_to_Country__c = shipToAddr.Country__c;
                }
                if (shipToAddr.Email_Address__c != null &&
                    String.isNotEmpty(shipToAddr.Email_Address__c)) {
                    onlineEnqury.Ship_to_Email__c = shipToAddr.Email_Address__c;
                }

                if (shipToAddr.Fax_No__c != null &&
                    String.isNotEmpty(shipToAddr.Fax_No__c)) {
                    onlineEnqury.Ship_to_Fax__c = shipToAddr.Fax_No__c;
                }

                if (shipToAddr.Postcode__c != null &&
                    String.isNotEmpty(shipToAddr.Postcode__c)) {
                    onlineEnqury.Ship_to_Postcode__c = shipToAddr.Postcode__c;
                }

                if (shipToAddr.State__c != null &&
                    String.isNotEmpty(shipToAddr.State__c)) {
                    onlineEnqury.Ship_to_State__c = shipToAddr.State__c;
                }

                if (shipToAddr.Tel_No__c != null &&
                    String.isNotEmpty(shipToAddr.Tel_No__c)) {
                    onlineEnqury.Ship_to_Tel__c = shipToAddr.Tel_No__c;
                }
            }
        }

        return onlineEnqury;
        
    }//END:setShipToAddress
    
}// END:ConvertPOtoOEController