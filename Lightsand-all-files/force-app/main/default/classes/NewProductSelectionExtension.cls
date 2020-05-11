public class NewProductSelectionExtension{
    public Online_Detail__c onlineDetail {get; set;}
    public Online_Enquiry__c onlineEnq {get; set;}
    private String retailerCode {get; set;}
    private String onlineEnquiryId {get; set;}
    public List<Online_Detail__c> onlineDetailsToInsertOrUpdate {get; set;}
    public List<Price_Specification_Book_Product__c> priceBookProducts {get; set;}
    public String selectedId {get; set;}
    public String removeId{get; set;}
    /* Added new variables for search criteria, Model and Product Type search. 01.05.2014 - Start*/
    public String modelName {get; set;}
    public String productType {get; set;}
    public String productCategory {get; set;}
    public String productFamily {get; set;}
    public String productColor {get; set;}
    public String productPrint {get; set;}
    public List<SelectOption> productPrints {get; set;}
    public List<String> prints = new List<String>();
    public List<String> dummyList {get; set;}
    /* Added new variables for search criteria, Model and Product Type search. 01.05.2014 - End*/
    public String errorMessage = 'Please enter Quantity value for all the products before saving.';
    public boolean isQtyEmpty = false;
    public String submitErrorMsg = 'There are no records to Submit, please select atleast one product';
     //Create a map between the Record Type Name and Id for easy retrieval
    Map<String,String> detailRecordTypes = new Map<String,String>{};
    
    //For Pagination - START
    public Integer totalRecords;
    public Integer numOfRecTodisp = 10;
    public Integer tempNumOfRecdisp = 10;
    public Integer totalPagCnt;
    public Integer page;
    public Boolean disablePrevious {get; set;}
    public Boolean disableNext {get; set;}
    public Integer startIndex = 0;
    //For Pagination - END
    //public String Qty {get; set;}
    
    
    public Map<String, Price_Specification_Book_Product__c> priceBookProductsMap {get; set;}
    public Map<String, Price_Specification_Book_Product__c> onlineDetailsToInsertOrUpdateMap {get; set;}
    public Map<String, Price_Specification_Book_Product__c> allPriceBookProductsMap {get; set;}
    
    public Map<String, Online_Detail__c> dummyOnlineDetailMap {get; set;}
    
    // added by pawan - START
    public Map<String,String> productTypeMap {get; set;}
    public Map<String,String> productCategoryMap {get; set;}
    public Map<String,String> productFamilyMap {get; set;}
    public Map<String,String> productColorMap {get; set;}
    public Map<String,String> productSizerPrintMap {get; set;}
    //END
            
    //Added new code for 25 Sep Changes - Start
    //public Boolean renderModelRemark{get; set;}
    public Boolean renderStyleName{get; set;}
    //Added new code for 25 Sep Changes - End
    
    // Added by pawan
    public String usdToLocalCurMultiplier {get;set;}
    
    public Decimal tax {get; set;}
    
    public Decimal adminCharges {get; set;}
    
    public Decimal freightCharges {get; set;}
    
    public String remarksByRep {get; set;}
    
    public boolean isAddProduct {get; set;}
    
    public boolean isAddRemarks {get; set;}
    
    public boolean isAddOtherCharges {get; set;}

    public boolean isInternalUser{get;set;}

    public boolean isAddSalesPersonInfo {get; set;}
   
    public string currencyCode{get;set;}
    
    public string requestedCurrency{get;set;}
    
    public Decimal exchangeRate{get;set;}
    
    public List<String> productUniqIdList {get; set;}
    
    public Map<String,List<Attachment>> productIdAttachMap {get; set;}
    public Map<String,Id> productModelUniqIdMap  {get; set;}
    public Boolean isProdImageToBeDisplayed{get;set;}
    
    public List<Online_Enquiry_Charges__c> onlineEnqChargesList {get;set;}
    public String enquiryChargesRowId{get; set;}
    public Map<Id,Online_Enquiry_Charges__c> onlineEnqChargesIdMap {get; set;}
    public Double overallTax {get; set;}
    public Double taxPercentage{get; set;}
    public boolean isFullBoxEnabled{get; set;}
    public boolean isReqCurrencyNGlobalCurrencySame{get; set;}
    public boolean isShowPriceinOrder{get; set;}
    public String billToAddressId{get; set;}
    
    public NewProductSelectionExtension(ApexPages.StandardSetController controller){
        usdToLocalCurMultiplier='0';
        isAddProduct = false;
        isAddRemarks = false;
        isAddOtherCharges = false;
        isAddSalesPersonInfo = false;
        System.debug('Start Constructor--------->');
        List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Online_Detail__c' and isActive=true];
        for(RecordType rt: rtypes){
            detailRecordTypes.put(rt.Name,rt.Id);
        }
        onlineDetail = (Online_Detail__c)controller.getRecord();
        onlineEnquiryId = ApexPages.currentPage().getparameters().get('OnlineEnquiryId');
        isInternalUser = ApexPages.currentPage().getUrl().contains('NewProductSelectionPage_InternalUsers');

        // usd to local currency value
        // usdToLocalCurMultiplier = ApexPages.currentPage().getparameters().get('UsdToLocalCurValue');
        
        //To display selected Items
        onlineDetailsToInsertOrUpdateMap = new Map<String, Price_Specification_Book_Product__c>();
        dummyOnlineDetailMap = new Map<String, Online_Detail__c>();
        
        onlineEnq = [select ERP_End_User__c,Retailer_Code__c, Ship_to_Country__c,Order_Country__c, RecordType.DeveloperName,Tax__c,Freight_Charges__c,Admin_Charges__c,Preferred_Currency__c,Sales_Rep_Remark__c,Partner_Id__c,Main_Contact_Id__c,Account_Manager__c,Account_Manager_Contact_Number__c,Account_Manager_Email_Address__c,Customer_Service_Email_Address__c,Customer_Service_Contact_Number__c,Customer_Service_Name__c,Customer_Service_Local_Code__c,Account_Manager_Local_Code__c,Payment_Term__c,Retailer_Code__r.Display_Image_In_Document__c,Retailer_Code__r.Full_Box_Order__c,Retailer_Code__r.Show_Price_in_Order__c,Bill_To__c,Export_Term__c,Retailer_Code_Hidden__c,Order_Division__c from Online_Enquiry__c where Id=:onlineEnquiryId];
        
        System.debug('Retailer_Code_Hidden__c:'+onlineEnq.Retailer_Code_Hidden__c);
        System.debug('Order_Country__c:'+onlineEnq.Order_Country__c);
        /*
        List<Bill_to_ERP_Link__c>  billToRPLink= [Select Id,Local_ERP_Payment_Term__c from Bill_to_ERP_Link__c where Mainetti_Company__c=: onlineEnq.Partner_Id__c AND Parent_Bill_To__c=:onlineEnq.Bill_To__c 
         CreatedDate DESC];
        
        if(billToRPLink!=null && billToRPLink.size()>0 && !billToRPLink.isEmpty()){
            String billToPaymentTerms = billToRPLink.get(0).Local_ERP_Payment_Term__c;
            if(!String.isBlank(billToPaymentTerms) && !String.isEmpty(billToPaymentTerms)){
                onlineEnq.Payment_Term__c = billToPaymentTerms;
            }
        }*/
        
        // added for conditionally image display
        isProdImageToBeDisplayed = onlineEnq.Retailer_Code__r.Display_Image_In_Document__c;
        
        // is full box enabled
        isFullBoxEnabled = onlineEnq.Retailer_Code__r.Full_Box_Order__c;
        
        // is show price enabled
        isShowPriceinOrder = onlineEnq.Retailer_Code__r.Show_Price_in_Order__c;
        

        billToAddressId = onlineEnq.Bill_To__c;
        
        tax = onlineEnq.Tax__c;
        adminCharges=onlineEnq.Admin_Charges__c;
        freightCharges=onlineEnq.Freight_Charges__c;
        remarksByRep = lineBreaks(onlineEnq.Sales_Rep_Remark__c);
        
        // to avoid data patching
        if(String.isEmpty(onlineEnq.Preferred_Currency__c) || String.isBlank(onlineEnq.Preferred_Currency__c)){
            requestedCurrency = 'USD';
        }else{
            requestedCurrency = onlineEnq.Preferred_Currency__c.substring(0,3);
        }
        
        // query Exchange_Rate_c
        String currentMonth = DateTime.Now().format('MMMMM').substring(0,3);
        String currentYear = String.valueOf(Date.Today().Year());
        if(!requestedCurrency.equals('USD')){
            try{
                Exchange_Rate__c localCurExRate = [select ExRate_to_USD__c from Exchange_Rate__c where Local_Currency__c=:onlineEnq.Preferred_Currency__c AND Active__c=True AND Month__c = :currentMonth AND Year__c = :currentYear order by CreatedDate desc Limit 1];
            
                Decimal usdToLocalCurrency = 1 / localCurExRate.ExRate_to_USD__c;
                usdToLocalCurMultiplier = string.valueOf(usdToLocalCurrency.setScale(6,RoundingMode.CEILING));
                exchangeRate = usdToLocalCurrency.setScale(6,RoundingMode.CEILING);
            }catch(Exception exRateQueryEx){
                // how to show this conditionally only for INTERNAL CS and Only one time.
                if(isInternalUser){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No valid exchange rate found. Please manually key in the exchange rate or ask System admin to add in one for you.'));
                    exchangeRate = 0;
                }
            }
        }else{
            // default value for USD
            exchangeRate = 1.000000;
            usdToLocalCurMultiplier = string.valueOf(exchangeRate.setScale(6,RoundingMode.CEILING));
        }
        //}
        
        // when customer place order exchange rate should not be applied.
        if(isInternalUser){
            usdToLocalCurMultiplier = string.valueOf(exchangeRate.setScale(6,RoundingMode.CEILING));
        }else{
            usdToLocalCurMultiplier = '0';
            exchangeRate=0.000000;
        }
        
        //Added new code for 25 Sep Changes - Start
        String recordTypeName = onlineEnq.RecordType.DeveloperName;
        if(recordTypeName!=null && recordTypeName.length()>0){
            if(recordTypeName.startsWith('PRL')){
           //     renderModelRemark = false;
                  renderStyleName = True;
            }else{
            //    renderModelRemark = true;
                  renderStyleName = false;
           }
       }
        // Added new code for 25 Sep Changes - End
        // User Logged In Currency
        //Price_100pcs__c,CurrencyIsoCode=: requestedCurrency and 
    
        if(requestedCurrency!=null && requestedCurrency.length()>0){
        priceBookProducts = [select Price_100pcs__c,Id,Local_SKU__c, Name, Product_Unique_ID__c,CurrencyIsoCode, BOX_QTY__c,
                         Customer_Ref_Model__c,Description__c,
                         Product_Unique_ID__r.Product_Description__c,
                         Product_Unique_ID__r.Product_Family__c,
                         Product_Unique_ID__r.Product_Type__c,
                         Product_Unique_ID__r.Name,
                         Color__c, Account__c,  
                         Freight_Terms__c, Retailer_Code__c,Retailer_Code__r.Name, Product_Status__c, 
                         Price_Specification_Book__r.Book_Status__c, 
                         Price_Specification_Book__r.RecordTypeId, Country__c,Product_Category__c,Sizer_Print__c,
                         Lead_Time__c, Display_Order__c ,
             (Select Price_100_pcs__c,ExRate_USD_to_Local__c From Price_Product_by_Currency__r where CurrencyIsoCode=:requestedCurrency LIMIT 1)             
                         from Price_Specification_Book_Product__c
                         where Price_Specification_Book__r.Book_Status__c='Active' and 
                         Price_Specification_Book__r.RecordTypeId='01290000000RyBQ' and
                         Product_Status__c='Active' and Active__c=true and               
                         Retailer_Code__c = :onlineEnq.Retailer_Code__c and
                         (
                        //Country__c= :onlineEnq.Ship_to_Country__c or
                         Order_to_Company__c= :onlineEnq.Order_Country__c) and               
                         (RetailerBrand__c =:onlineEnq.ERP_End_User__c or
                         RetailerBrand__c = '')
                         ORDER BY Product_Unique_ID__r.Product_Type__c ASC, Display_Order__c ASC, Customer_Ref_Model__c ASC,  Color__c DESC, Product_Unique_ID__r.Product_Description__c ASC NULLS LAST
                        //                         ORDER BY Display_Order__c ASC,Customer_Ref_Model__c ASC,  Color__c DESC, Product_Unique_ID__r.Product_Description__c ASC  NULLS LAST
                        ];
            //CurrencyIsoCode=: requestedCurrency and
            
            System.debug('priceBookProducts '+priceBookProducts);
            
            System.debug('priceBookProducts:With Logged In User Currency :'+requestedCurrency+':SIZE:'+priceBookProducts.size());
        }
        isReqCurrencyNGlobalCurrencySame = true;
        
        // Default currency
       /** if(priceBookProducts==null || priceBookProducts.size()==0 || priceBookProducts.isEmpty()){
                isReqCurrencyNGlobalCurrencySame = false;
                priceBookProducts = [select Id, Name, Product_Unique_ID__c,CurrencyIsoCode, BOX_QTY__c,
                                 Customer_Ref_Model__c,Description__c,
                                 Product_Unique_ID__r.Product_Description__c,
                                 Product_Unique_ID__r.Product_Family__c,
                                 Product_Unique_ID__r.Product_Type__c,
                                 Product_Unique_ID__r.Name,
                                 Color__c, Account__c, Price_100pcs__c, 
                                 Freight_Terms__c, Retailer_Code__c,Retailer_Code__r.Name, Product_Status__c, 
                                 Price_Specification_Book__r.Book_Status__c, 
                                 Price_Specification_Book__r.RecordTypeId, Country__c,Product_Category__c,Sizer_Print__c 
                                 from Price_Specification_Book_Product__c
                                 where Price_Specification_Book__r.Book_Status__c='Active' and 
                                 Price_Specification_Book__r.RecordTypeId='01290000000RyBQ' and
                                 Product_Status__c='Active' and Active__c=true and 
                                 Retailer_Code__c = :onlineEnq.Retailer_Code__c and
                                 (Country__c= :onlineEnq.Ship_to_Country__c or
                                 Order_to_Company__c= :onlineEnq.Order_Country__c)
                                 ORDER BY Customer_Ref_Model__c ASC, Color__c DESC, Product_Unique_ID__r.Product_Description__c ASC  NULLS LAST
                                ];
            System.debug('priceBookProducts:With Default Currency :'+priceBookProducts.size());                 
        }**/
        
        
        productTypeMap = new Map<String, String>();
        productCategoryMap = new Map<String, String>();
        productFamilyMap = new Map<String, String>();
        productColorMap = new Map<String, String>();
        productSizerPrintMap = new Map<String, String>();
        productUniqIdList = new List<String>();
        productIdAttachMap = new Map<String, List<Attachment>>();
        productModelUniqIdMap = new Map<String,Id>();
        //END
        
        if(priceBookProducts != null && priceBookProducts.size() > 0){
            for (Price_Specification_Book_Product__c eachProduct : priceBookProducts) {
                if(eachProduct.Product_Unique_ID__r.Product_Type__c!=null && eachProduct.Product_Unique_ID__r.Product_Type__c.length()>0){
                productTypeMap.put(eachProduct.Product_Unique_ID__r.Product_Type__c, eachProduct.Product_Unique_ID__r.Product_Type__c);
                }
                if(eachProduct.Product_Category__c!=null && eachProduct.Product_Category__c.length()>0){
                productCategoryMap.put(eachProduct.Product_Category__c, eachProduct.Product_Category__c);
                }
                
                if(eachProduct.Product_Unique_ID__r.Product_Family__c!=null && eachProduct.Product_Unique_ID__r.Product_Family__c.length()>0){
                productFamilyMap.put(eachProduct.Product_Unique_ID__r.Product_Family__c, eachProduct.Product_Unique_ID__r.Product_Family__c);
                }
                
                if(eachProduct.Color__c!=null && eachProduct.Color__c.length()>0){
                productColorMap.put(eachProduct.Color__c, eachProduct.Color__c);
                }
                if(eachProduct.Sizer_Print__c!=null && eachProduct.Sizer_Print__c.length()>0){
                    productSizerPrintMap.put(eachProduct.Sizer_Print__c, eachProduct.Sizer_Print__c);
                }
                
                /*
                if(eachProduct.Product_Unique_ID__r.Name!=null){
                    productUniqIdList.add(eachProduct.Product_Unique_ID__r.Name);
                }*/
                
                if(eachProduct.Product_Unique_ID__r.Name!=null){
                    productModelUniqIdMap.put(eachProduct.Product_Unique_ID__r.Name,eachProduct.Product_Unique_ID__c);
                }
                
                if(eachProduct.Product_Unique_ID__c!=null){
                    productUniqIdList.add(eachProduct.Product_Unique_ID__c);
                }
            }
        }

        System.debug('productModelUniqIdMap:'+productModelUniqIdMap);        
        System.Debug('productUniqIdList:'+productUniqIdList);
        
        // Query Product Image
        Product__c[] productList = [Select Id, (Select Id from attachments order by CreatedDate desc) from Product__c where Id IN :productUniqIdList];
//      Product__c[] productList = [Select Id, (Select Id from attachments order by CreatedDate desc) from Product__c where NAME IN :productUniqIdList];
        //Product__c[] productList = [Select Id, (Select Id from attachments order by CreatedDate desc) from Product__c where NAME IN ('a03N0000001yTxL')];
        
        // query default image
        Attachment defaultImageAttachment = [Select Id from attachment where Name IN ('NoImageAvailable.jpg') AND Parent.Type='Product__c'];
        
        Attachment dummyAttachment = new Attachment();
        //dummyAttachment.id='00PN00000042LJo';
        //dummyAttachment.id='00PN00000042T8f';
        dummyAttachment.id=defaultImageAttachment.id;
        
        
        for (Product__c result : productList) {
           if(result.Attachments!=null && result.Attachments.size()>0){
               productIdAttachMap.put(result.id,result.Attachments);        
           }else{
               productIdAttachMap.put(result.id,new List<Attachment>{dummyAttachment});
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Image is not avaialble for some of the products so we are displaying NO IMAGE AVAILABLE as a defult one.'));
           }
        }
        System.Debug('productIdAttachMap:'+productIdAttachMap);

        //Added new code for 25 Sep Changes - Start
        //LIST<Online_Detail__c> existingProdList = [select Id, Model__c, Qty__c, Model_Remark__c, Reuse_Virgin__c, USD_Price_100__c, Freight_Term__c, Shipped_Qty__c, Shipped_Date__c from Online_Detail__c where TransactionID__c=:onlineEnquiryId];
        LIST<Online_Detail__c> existingProdList = [select Id,Local_SKU1__c, Model__c, Qty__c, Model_Remark__c, Style_Name_or_Number__c, Reuse_Virgin__c, USD_Price_100__c, Freight_Term__c, Shipped_Qty__c, Shipped_Date__c,USD_TO_PREFER_CURRENCY__c,Quoted_Currency_Price_100__c,Sales_Value_In_Quoted_Currency__c,Product_Image_ID__c,TempModel__c,Temp_Lead_Time__c,ExRate_USD_to_Local__c from Online_Detail__c where TransactionID__c=:onlineEnquiryId and Online_Details_Status__c='New'];
        //Added new code for 25 Sep Changes - End
        System.debug('existingProd---------->'+existingProdList);
        
        if(priceBookProducts != null && priceBookProducts.size() > 0){
            disablePrevious = true;
            totalRecords = priceBookProducts.size();
            System.debug('totalRecords--------->'+totalRecords);
            if(totalRecords <= numOfRecTodisp){
                disableNext = true;
                numOfRecTodisp = totalRecords;
            }
            
            priceBookProductsMap = new Map<String, Price_Specification_Book_Product__c>();
            allPriceBookProductsMap = new Map<String, Price_Specification_Book_Product__c>();
            
             for(Integer i = startIndex; i < numOfRecTodisp; i++){
           
                Price_Specification_Book_Product__c eachProduct = priceBookProducts.get(i);
                
                
                    
                    if(eachProduct.Price_Product_by_Currency__r!=null && eachProduct.Price_Product_by_Currency__r.size()>0){
                        eachProduct.Price_100pcs__c=eachProduct.Price_Product_by_Currency__r[0].Price_100_pcs__c;
                        //added by Tony 20200107 GU PriceBook Product
                        System.debug('ID :: PRICE '+eachProduct.Id+'----'+eachProduct.Price_Product_by_Currency__r[0].Price_100_pcs__c);
                    }else{
                        eachProduct.Price_100pcs__c=0.00;
                        System.debug('ID :: NO PRICE '+eachProduct.Id);
                    }
                
                priceBookProductsMap.put(eachProduct.Id, eachProduct);
        
        
        
            }
            
            for(Integer i = startIndex; i < priceBookProducts.size(); i++){
                Price_Specification_Book_Product__c eachProduct = priceBookProducts.get(i);
                allPriceBookProductsMap.put(eachProduct.Id, eachProduct);
                // add iso currency code
                currencyCode = eachProduct.CurrencyIsoCode;
                System.debug('eachProduct.Name:BOX_QTY__c:Id::'+eachProduct.Name+'::'+eachProduct.BOX_QTY__c+'::'+eachProduct.id);
                // 
                //prints.add(eachProduct.Sizer_Print__c);
            }
             
            if(existingProdList != null && existingProdList.size() > 0){
                System.debug('List is Not Empty--------->'+existingProdList.size());
                for(Online_Detail__c eachExistingProd :existingProdList){
                     //System.debug('priceBookProductsMap contains key--------->'+eachExistingProd.Model__c);
                     System.debug('priceBookProductsMap contains key--------->'+priceBookProductsMap.containsKey(eachExistingProd.Model__c));
                     //usdToLocalCurMultiplier = string.valueOf(eachExistingProd.USD_TO_PREFER_CURRENCY__c);
                     if(isInternalUser && isReqCurrencyNGlobalCurrencySame){
                        if(eachExistingProd.USD_TO_PREFER_CURRENCY__c==null){
                            eachExistingProd.USD_TO_PREFER_CURRENCY__c = 1.000000;
                        } 
                     }
             
                     // assign latest attachment image  
                     if(eachExistingProd.Product_Image_ID__c==null){
                        //eachExistingProd.Product_Image_ID__c = '00PN00000042LJo';
                        //eachExistingProd.Product_Image_ID__c = productIdAttachMap.get(productModelUniqIdMap.get(eachExistingProd.Model__c))[0].id;
                        eachExistingProd.Product_Image_ID__c = productIdAttachMap.get(productModelUniqIdMap.get(eachExistingProd.TempModel__c))[0].id;
                        System.debug('TempModel__c:'+productIdAttachMap.get(productModelUniqIdMap.get(eachExistingProd.TempModel__c))[0].id);
                     }
                     
                    //System.debug('ProdMap---->'+priceBookProductsMap);
                    if(allPriceBookProductsMap.containsKey(eachExistingProd.Model__c)){
                        
                        System.debug('priceBookProductsMap contains key--------->'+eachExistingProd.Model__c);
                        //Adding to Selected List(Above List)
                        onlineDetailsToInsertOrUpdateMap.put(eachExistingProd.Model__c,  allPriceBookProductsMap.get(eachExistingProd.Model__c));
                        
                        //Adding dummyOnlineDetail to dummyOnlineDetailMap to get Quantity and Model Remark Values
                        Online_Detail__c dummyOnlineDetail = new Online_Detail__c();
                        if(eachExistingProd.Shipped_Date__c==null){
                            eachExistingProd.Shipped_Date__c = Date.today();
                        }
                        
                        //if(eachExistingProd.Product_Image_ID__c==null){
                        //    eachExistingProd.Product_Image_ID__c = '00PN00000042LJo';
                        //}
                        
                        dummyOnlineDetailMap.put(eachExistingProd.Model__c, eachExistingProd);
                        
                        System.debug('removed--->'+priceBookProductsMap.get(eachExistingProd.Model__c));
                        //Removing from Select List(Below List)
                        priceBookProductsMap.remove(eachExistingProd.Model__c);
                    }
                }
                System.debug('All Done------------->');               
            }

           
           //onlineEnqChargesList = new List<Online_Enquiry_Charges__c>();
           onlineEnqChargesList = [Select Id,Misc_Charges__c, Description__c, Amount__c,Include_Tax__c, Tax__c,Online_Enquiry_ID__c,Requested_Currency__c  From Online_Enquiry_Charges__c where Online_Enquiry_ID__c=:onlineEnquiryId];
           onlineEnqChargesIdMap = new Map<Id,Online_Enquiry_Charges__c>(onlineEnqChargesList);
           if(onlineEnqChargesList!=null && onlineEnqChargesList.size()>0){
            overallTax = onlineEnqChargesList.get(0).Tax__c;
           }
           if(onlineEnqChargesList==null || onlineEnqChargesList.size()==0){
            overallTax = onlineEnq.Tax__c;
           }
           
           /* 
            totalRecords = totalRecords - tempNumOfRecdisp;
            System.debug('After subtract totalRecords--------->'+totalRecords);
            
            startIndex = startIndex + numOfRecTodisp;
            
            if(totalRecords > tempNumOfRecdisp){
                tempNumOfRecdisp += tempNumOfRecdisp;
            } else if(totalRecords > 0){
                tempNumOfRecdisp += totalRecords;
            }
            
            System.debug('Start--------->'+startIndex+'End----------->'+tempNumOfRecdisp);
            */
            /*priceBookProductsMap = new Map<String, Price_Specification_Book_Product__c>();
            for(Price_Specification_Book_Product__c eachProduct : priceBookProducts){
                priceBookProductsMap.put(eachProduct.Id, eachProduct);
            }*/
            System.debug('All Done Again------------->');
        }
        System.debug('End Constructor--------->');
    }
    
    public void Next() { //user clicked next button
        System.debug('Inside Next....-------------------------->');
        System.debug('Start--------->'+startIndex+'End----------->'+tempNumOfRecdisp);
        
        //Enable Previous button
        disablePrevious = false;
       
        totalRecords = totalRecords - numOfRecTodisp;
        
       //System.debug('totalRecords--------->'+totalRecords);
        
        if(totalRecords > numOfRecTodisp){
            startIndex = startIndex + numOfRecTodisp;
            tempNumOfRecdisp += numOfRecTodisp;
        } else if(totalRecords > 0){
            startIndex = startIndex + numOfRecTodisp;
            tempNumOfRecdisp += totalRecords;
        }
        if(totalRecords <= 9){
            disableNext = true;   
        }
       
        priceBookProductsMap = new Map<String, Price_Specification_Book_Product__c>();
        
        for(Integer i = startIndex; i < tempNumOfRecdisp; i++){
            Price_Specification_Book_Product__c eachProduct = priceBookProducts.get(i);
            if(!onlineDetailsToInsertOrUpdateMap.containsKey(eachProduct.Id)){
                priceBookProductsMap.put(eachProduct.Id, eachProduct);      
            }
        }

        System.debug('Start --------->'+startIndex+'End ----------->'+ tempNumOfRecdisp);
        
      
   }
    
    public void Previous() { //user clicked Previous button
        System.debug('Inside Previous....-------------------------->');
        System.debug('Start--------->'+startIndex+'End----------->'+tempNumOfRecdisp);
        
        //Enable Next button
        disableNext = false;
        
        tempNumOfRecdisp = startIndex;
        startIndex -= 10; 
        totalRecords += 10; 
        
        if(startIndex <=0){
            disablePrevious = true;
        }
        
        priceBookProductsMap = new Map<String, Price_Specification_Book_Product__c>();
        
        for(Integer i = startIndex; i < tempNumOfRecdisp; i++){
            Price_Specification_Book_Product__c eachProduct = priceBookProducts.get(i);
            if(!onlineDetailsToInsertOrUpdateMap.containsKey(eachProduct.Id)){
                priceBookProductsMap.put(eachProduct.Id, eachProduct);      
            }
        }
        
        System.debug('totalRecords--------->'+totalRecords);
      
        System.debug('Start --------->'+startIndex+'End ----------->'+ tempNumOfRecdisp);
        
   }

    public void selectedItem(){
    isAddProduct = false;
        System.debug('##SelectedItem--->'+selectedId);
       /* Online_Detail__c newOnlineDet = new Online_Detail__c();
        newOnlineDet.Color__c = 'Yellow';
        newOnlineDet.USD_Price_100__c = 100;
        newOnlineDet.Qty__c = 10;
        newOnlineDet.Model_Remark__c = 'Very Bad';
        onlineDetailsToInsertOrUpdate = new List<Online_Detail__c>();
        onlineDetailsToInsertOrUpdate.add(newOnlineDet);*/
        if(priceBookProductsMap != null && priceBookProductsMap.size() > 0 && priceBookProductsMap.containsKey(selectedId)){
           // Price_Specification_Book_Product__c product = priceBookProductsMap.get(selectedId);
            //Online_Detail__c newOnlineDet = getDetail(priceBookProductsMap.get(selectedId));
            //onlineDetailsToInsertOrUpdate.add(newOnlineDet);
            
            //onlineDetailsToInsertOrUpdateMap.put(selectedId, getDetail(priceBookProductsMap.get(selectedId))); 
            
            //Adding Selected Item to Selected Product List(Above List)
            System.debug('Before Adding Selected Item : onlineDetailsToInsertOrUpdateMap----->'+onlineDetailsToInsertOrUpdateMap);
            onlineDetailsToInsertOrUpdateMap.put(selectedId, priceBookProductsMap.get(selectedId));
            System.debug('After Adding Selected Item : onlineDetailsToInsertOrUpdateMap----->'+onlineDetailsToInsertOrUpdateMap);
           
            //Adding dummyOnlineDetail to dummyOnlineDetailMap to get Quantity and Model Remark Values
            Online_Detail__c dummyOnlineDetail = new Online_Detail__c();
            dummyOnlineDetail.Shipped_Date__c = Date.today();
             
      
      if(priceBookProductsMap.get(selectedId).Price_Product_by_Currency__r!=null
      && priceBookProductsMap.get(selectedId).Price_Product_by_Currency__r.size()>0){
      
      //dummyOnlineDetail.USD_Price_100__c=priceBookProductsMap.get(selectedId).Price_100pcs__c;    
      dummyOnlineDetail.USD_Price_100__c=priceBookProductsMap.get(selectedId).Price_Product_by_Currency__r[0].Price_100_pcs__c;          
      //added by Tony 20200107 GU
      dummyOnlineDetail.ExRate_USD_to_Local__c=priceBookProductsMap.get(selectedId).Price_Product_by_Currency__r[0].ExRate_USD_to_Local__c;          

      }else{
      dummyOnlineDetail.USD_Price_100__c=0.00;
      //added by tony 20200107 GU
      dummyOnlineDetail.ExRate_USD_to_Local__c=0.00;
      }

      
      
            
            dummyOnlineDetail.Local_SKU1__c=priceBookProductsMap.get(selectedId).Local_SKU__c;
            dummyOnlineDetail.Temp_Lead_Time__c=priceBookProductsMap.get(selectedId).Lead_Time__c;
            
            // Added by pawan - 6_NOV_2016
            String priceBookProductCurCode = priceBookProductsMap.get(selectedId).CurrencyIsoCode;
            System.debug('priceBookProductCurCode:'+priceBookProductsMap.get(selectedId).CurrencyIsoCode);
            System.debug('priceBookProductCurCode.equals(requestedCurrency):'+priceBookProductCurCode.equals(requestedCurrency));
            //if(priceBookProductCurCode.equals(requestedCurrency)){
                //dummyOnlineDetail.Quoted_Currency_Price_100__c = priceBookProductsMap.get(selectedId).Price_100pcs__c;
        
            if(priceBookProductsMap.get(selectedId).Price_Product_by_Currency__r!=null && priceBookProductsMap.get(selectedId).Price_Product_by_Currency__r.size()>0){
                dummyOnlineDetail.Quoted_Currency_Price_100__c = priceBookProductsMap.get(selectedId).Price_Product_by_Currency__r[0].Price_100_pcs__c;
                //Added By Tony 20200108 GU
                dummyOnlineDetail.ExRate_USD_to_Local__c= priceBookProductsMap.get(selectedId).Price_Product_by_Currency__r[0].ExRate_USD_to_Local__c;
            
            }else{
             dummyOnlineDetail.Quoted_Currency_Price_100__c=0.00;
             //added by tony 20200107 GU
             dummyOnlineDetail.ExRate_USD_to_Local__c=0;
            }
            
        dummyOnlineDetail.USD_TO_PREFER_CURRENCY__c = 1.000000;
            //}
            // END - 6_NOV_2016
            

            // added by pawan 21 AUG
            //dummyOnlineDetail.Product_Image_ID__c = productIdAttachMap.get(selectedId)[0].Id;            
            System.debug('selectedId:'+selectedId);
            dummyOnlineDetail.Product_Image_ID__c = productIdAttachMap.get(priceBookProductsMap.get(selectedId).Product_Unique_ID__c)[0].id;            
            //productIdAttachMap.get(eachExistingProd.Product_Unique_ID__c)[0].get(0).id;
            System.debug('dummyOnlineDetail.Product_Image_ID__c :'+dummyOnlineDetail.Product_Image_ID__c );
            
            
            
            // by pawan
            //dummyOnlineDetail.Style_Name_or_Number__c=priceBookProductsMap.get(selectedId).Style_Name_or_Number__c;
            //dummyOnlineDetail.Quoted_Currency_Price_100__c = 0;
            
            // Added by pawan
            // local currency multiplier factor
            if(Decimal.valueof(usdToLocalCurMultiplier)>0){
                dummyOnlineDetail.USD_TO_PREFER_CURRENCY__c = Decimal.valueOf(usdToLocalCurMultiplier);
            }
            dummyOnlineDetailMap.put(selectedId, dummyOnlineDetail);
            System.debug('dummyOnlineDetailMap.get(selectedId).Product_Image_ID__c :'+dummyOnlineDetailMap.get(selectedId).Product_Image_ID__c);
            //Removing from Selete Product List(Below List)
            priceBookProductsMap.remove(selectedId);
        }
    }
    
    public void removeItem(){
        try{
        System.debug('##RemovedItem--->'+removeId);
        if(onlineDetailsToInsertOrUpdateMap != null && onlineDetailsToInsertOrUpdateMap.size() > 0 && onlineDetailsToInsertOrUpdateMap.containsKey(removeId)){
            
            
            //Adding Removed Item to Select Product List(Below List)
            System.debug('Before Adding removed Item : priceBookProductsMap----->'+priceBookProductsMap);
            priceBookProductsMap.put(removeId, onlineDetailsToInsertOrUpdateMap.get(removeId));
            System.debug('After Adding removed Item : priceBookProductsMap----->'+priceBookProductsMap);
            
            //Removing from dummyOnlineDetailMap
            dummyOnlineDetailMap.remove(removeId);
            
            //Removing from Selected Product List(Above List)
            onlineDetailsToInsertOrUpdateMap.remove(removeId);
            
        }
        
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getmessage()));
        }
        
    }
    
    public Online_Detail__c getDetailRemoved(Price_Specification_Book_Product__c product){
        Online_Detail__c newOnlineDet = new Online_Detail__c();
        newOnlineDet.Color__c = product.Color__c;
        newOnlineDet.USD_Price_100__c = product.Price_100pcs__c;
        //added by tony 20200107 GH
         //newOnlineDet.ExRate_USD_to_Local__c = product.ExRate_USD_to_Local__c;
        //newOnlineDet.Qty__c = product;
        //newOnlineDet.Model_Remark__c = 'Very Bad';
        newOnlineDet.Model__c = product.Id;
        newOnlineDet.TempModel__c = product.Name;
        newOnlineDet.TempModelId__c = product.Id;
        // added by pawan
        //newOnlineDet.Quoted_Currency_Price_100__c = product.Quoted_Currency_Price_100__c;
        //newOnlineDet.Product_Description__c = product.Product_Unique_ID__r.Product_Description__c;
        //newOnlineDet.Product_Family__c = product.Product_Unique_ID__r.Product_Family__c;
        //newOnlineDet.Product_Type__c = product.Product_Unique_ID__r.Product_Type__c;
        //newOnlineDet.Model__c=product.Id;
        //newOnlineDet.Name = product.Name;
        
        onlineDetailsToInsertOrUpdate = new List<Online_Detail__c>();
        //onlineDetailsToInsertOrUpdate.add(newOnlineDet);
        return newOnlineDet;
    }
    
    public PageReference Save(){
         isQtyEmpty = false;
        if(onlineDetailsToInsertOrUpdateMap!=null && onlineDetailsToInsertOrUpdateMap.size()>0) {

            System.debug('Product Save Called---->'+onlineDetailsToInsertOrUpdateMap.size());
            
            LIST<Id> prodIdList = new LIST<ID>();
            
            
            
            for(Price_Specification_Book_Product__c eachProdSpec : onlineDetailsToInsertOrUpdateMap.values()){
                if(dummyOnlineDetailMap!=null && dummyOnlineDetailMap.size()>0) {
                    Decimal qtyMandTest = (dummyOnlineDetailMap.get(eachProdSpec.Id).Qty__c) == null ? 0 : dummyOnlineDetailMap.get(eachProdSpec.Id).Qty__c ;
                    if(qtyMandTest==null || qtyMandTest<1){
                        isQtyEmpty = true;
                        break;
                    }
                }
            }
            if(!isQtyEmpty){  
            for(Price_Specification_Book_Product__c eachProdSpec : onlineDetailsToInsertOrUpdateMap.values()){
                
                prodIdList.add(eachProdSpec.Id);
                System.debug('eachProdSpec.Id=====>'+eachProdSpec.Id);
                System.debug('onlineEnquiryId=====>'+onlineEnquiryId);
                Boolean isNew = false;
                Online_Detail__c eachProduct = null;
                //LIST<Price_Product_by_Currency__c> OldProdNewPriceList = null;
                try{
                    eachProduct = [select Id from Online_Detail__c where Model__c=:eachProdSpec.Id and TransactionID__c=:onlineEnquiryId and Online_Details_Status__c='New' LIMIT 1];    
                   //OldProdNewPriceList = [Select Price_100_pcs__c From Price_Product_by_Currency__c where CurrencyIsoCode=:requestedCurrency AND Price_Book_Product__c=:eachProdSpec.Id LIMIT 1];
                  
                }catch(Exception e){
                   eachProduct = new Online_Detail__c();
                   isNew = true;
                }
                    
               
                eachProduct.Color__c = eachProdSpec.Color__c;
                eachProduct.Model__c = eachProdSpec.Id;
                eachProduct.TempModel__c = eachProdSpec.Name;
                eachProduct.TempModelId__c = eachProdSpec.Id;
                if(isNew){
                    eachProduct.TransactionID__c = onlineEnquiryId;    
                }
                
                
                if(dummyOnlineDetailMap!=null && dummyOnlineDetailMap.size()>0) {
                    eachProduct.Qty__c = (dummyOnlineDetailMap.get(eachProdSpec.Id).Qty__c) == null ? 0 : dummyOnlineDetailMap.get(eachProdSpec.Id).Qty__c ;
                    eachProduct.Model_Remark__c = dummyOnlineDetailMap.get(eachProdSpec.Id).Model_Remark__c;
                    eachProduct.Reuse_Virgin__c = dummyOnlineDetailMap.get(eachProdSpec.Id).Reuse_Virgin__c;
                    eachProduct.USD_Price_100__c= dummyOnlineDetailMap.get(eachProdSpec.Id).USD_Price_100__c;                
                    eachProduct.Shipped_Qty__c = dummyOnlineDetailMap.get(eachProdSpec.Id).Shipped_Qty__c;
                    eachProduct.Shipped_Date__c = dummyOnlineDetailMap.get(eachProdSpec.Id).Shipped_Date__c;
                    eachProduct.Temp_Lead_Time__c= dummyOnlineDetailMap.get(eachProdSpec.Id).Temp_Lead_Time__c;
                    eachProduct.Local_SKU1__c=(dummyOnlineDetailMap.get(eachProdSpec.Id).Local_SKU1__c) == null ? '' : dummyOnlineDetailMap.get(eachProdSpec.Id).Local_SKU1__c ;
                    
                    eachProduct.Product_Image_ID__c = dummyOnlineDetailMap.get(eachProdSpec.Id).Product_Image_ID__c;
                    
                    // added by pawan
                    if(isInternalUser || isReqCurrencyNGlobalCurrencySame){
                    //if(isReqCurrencyNGlobalCurrencySame){
                        //added by Tony 20200107 GU
                        eachProduct.ExRate_USD_to_Local__c= dummyOnlineDetailMap.get(eachProdSpec.Id).ExRate_USD_to_Local__c;
                        eachProduct.Quoted_Currency_Price_100__c = dummyOnlineDetailMap.get(eachProdSpec.Id).Quoted_Currency_Price_100__c;
                        //eachProduct.USD_TO_PREFER_CURRENCY__c = dummyOnlineDetailMap.get(eachProdSpec.Id).USD_TO_PREFER_CURRENCY__c;
                        //eachProduct.Product_Image_ID__c = dummyOnlineDetailMap.get(eachProdSpec.Id).Product_Image_ID__c;
                    }
            
                    //Added new code for 25 Sep Changes - Start
                     //Added new code for 25 Sep Changes - Start
                    String recordTypeName = onlineEnq.RecordType.DeveloperName;
                    if(recordTypeName!=null && recordTypeName.length()>0){
                        if(recordTypeName.startsWith('PRL')){
                            eachProduct.Style_Name_or_Number__c = dummyOnlineDetailMap.get(eachProdSpec.Id).Style_Name_or_Number__c;
                        }
                    }
                    //eachProduct.Style_Name_or_Number__c = dummyOnlineDetailMap.get(eachProdSpec.Id).Style_Name_or_Number__c;
                    //Added new code for 25 Sep Changes - End
                    
                    // Added by Pawan
                    if(isInternalUser){
                        eachProduct.USD_TO_PREFER_CURRENCY__c = dummyOnlineDetailMap.get(eachProdSpec.Id).USD_TO_PREFER_CURRENCY__c;
                    }
                    //usd to local currency factor
                    //END
                }
                
                //-- code added to change  Quoted_Currency_Price_100__c asper new changed Currency if any
                /**if(OldProdNewPriceList!=null && OldProdNewPriceList.size()>0){
                   eachProduct.Quoted_Currency_Price_100__c = OldProdNewPriceList.get(0).Price_100_pcs__c;
                }else{
                    eachProduct.Quoted_Currency_Price_100__c = 0.0;
                }**/
                
                System.debug('## Before eachProduct:'+eachProduct);
                System.debug('## Before eachProduct Id:'+eachProduct.Id);
                upsert (eachProduct);
                
                System.debug('#####Before onlineDetail--->'+eachProduct.RecordTypeId);
                eachProduct.RecordTypeId=detailRecordTypes.get('Open Order');
                upsert(eachProduct);
                System.debug('#####After onlineDetail--->'+eachProduct.RecordTypeId);
                System.debug('##eachProduct:'+eachProduct);
                System.debug('##eachProduct Id:'+eachProduct.Id);
                
                //upsert(onlineEnq); 
            }
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage));
                //throw new Exception(errorMessage);
                return null;
            }
            if(prodIdList != null && prodIdList.size() > 0){
                LIST<Online_Detail__c> removedProdList = [select Id from Online_Detail__c where Model__c not in : prodIdList and TransactionID__c=:onlineEnquiryId];
                System.debug('removedProd'+removedProdList);
                delete(removedProdList);
            }
            
            // first make all section hidden
            isAddRemarks = false;
            isAddOtherCharges = false;
        
            // update online enquiry
            if(overallTax!=null){
                onlineEnq.Tax__c=overallTax;
            }
            if(onlineEnq.Tax__c==null)
            onlineEnq.Tax__c=0.0;
            if(onlineEnq.Admin_Charges__c==null)
            onlineEnq.Admin_Charges__c=0.0;
            if(onlineEnq.Freight_Charges__c==null)
            onlineEnq.Freight_Charges__c=0.0;
            update(onlineEnq);
        }
        
        // set tax%
        for(Online_Enquiry_Charges__c eachCharges : onlineEnqChargesList){
                eachCharges.Tax__c = overallTax;
        }
        upsert(onlineEnqChargesList);
        
        // return to same page
        if(isInternalUser){
            PageReference nextPage = new PageReference('/apex/NewProductSelectionPage_InternalUsers'+'?'+'OnlineEnquiryId='+onlineEnquiryId);
            nextPage.setRedirect(true);
            return nextPage;
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'All the modifications have been saved successfully.'));
            return null;
        }

    }
    
    public PageReference Submit(){
        if(onlineDetailsToInsertOrUpdateMap!=null && onlineDetailsToInsertOrUpdateMap.size()>0){
            this.Save();
             if(!isQtyEmpty){
                //PDF Generation Start
                System.debug('Generating Enquiry PDF - START');
                try{
                    if(onlineEnq.Order_Division__c!='PP')
                    {
                    //Utility.getEnquiryPdfContent(onlineEnquiryId);
                    PageReference nextPage = new PageReference('/apex/SubmitEnquiryPdfToSales'+'?'+'id='+onlineEnquiryId);                  
                    nextPage.setRedirect(true);
                    return nextPage;
                    }
                    else
                    {
                    //Utility.getEnquiryPdfContent(onlineEnquiryId);
                    PageReference nextPage = new PageReference('/apex/ConfirmationPage'+'?'+'id='+onlineEnquiryId);
                    //PageReference nextPage = new PageReference('/apex/SubmitPageCustomers?id='+onlineEnquiryId);                  
                    nextPage.setRedirect(true);
                    return nextPage;
                    }                 
                }catch(Exception e){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getmessage()));
                }
                System.debug('Generating Enquiry PDF - END');
                //return new ApexPages.StandardController(onlineEnq).view();
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage));
            }
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, submitErrorMsg));
        }
        
        return null;
    }    
       
    public PageReference Cancel(){
    
        //return new PageReference('/MainettiOnline/'+onlineEnquiryId);
        update(onlineEnq);
        return new ApexPages.StandardController(onlineEnq).view();
        
    }
    
    /* Added new variables for search criteria, Model and Product Type search. 01.05.2014 - Start*/
    public void Search(){
        System.debug('##Inside Search Method');
        numOfRecTodisp = 10;
        tempNumOfRecdisp = 10;
        if(disableNext==null || disableNext){
            disableNext = false;
        }        
        startIndex = 0;
        String priceSpecBookProdQuery = getPriceSpecBookProdQuery();
        
        //-- added IF And Else Condition :  by Sharan 30 MARCH 2016 - START
        if(priceSpecBookProdQuery!=null && String.isNotBlank(priceSpecBookProdQuery) && String.isNotEmpty(priceSpecBookProdQuery)){
            
            priceBookProducts = Database.query(priceSpecBookProdQuery);
            if(priceBookProducts != null && priceBookProducts.size() > 0){
                disablePrevious = true;
                totalRecords = priceBookProducts.size();
                System.debug('totalRecords--------->'+totalRecords);
                System.debug('numOfRecTodisp------->'+numOfRecTodisp);
                System.debug('disableNext----------->'+disableNext);
                System.debug('startIndex------------>'+startIndex);
                if(totalRecords <= numOfRecTodisp){
                    disableNext = true;
                    numOfRecTodisp = totalRecords;
                }
                
                priceBookProductsMap = new Map<String, Price_Specification_Book_Product__c>();
                
                for(Integer i = startIndex; i < numOfRecTodisp; i++){
                    Price_Specification_Book_Product__c eachProduct = priceBookProducts.get(i);
                    priceBookProductsMap.put(eachProduct.Id, eachProduct);
                    System.debug('Search:eachProduct.Name:BOX_QTY__c:Id::'+eachProduct.Name+'::'+eachProduct.BOX_QTY__c+'::'+eachProduct.id);
                }
                System.debug('Before priceBookProductsMap---->'+priceBookProductsMap);
                System.debug('Before priceBookProductsMap Size---->'+priceBookProductsMap.size());
                LIST<Online_Detail__c> existingProdList = [select Id, Model__c, USD_TO_PREFER_CURRENCY__c ,Sales_Value_In_Quoted_Currency__c,Quoted_Currency_Price_100__c,Qty__c, Model_Remark__c, Reuse_Virgin__c, USD_Price_100__c, Freight_Term__c, Shipped_Qty__c, Shipped_Date__c,Product_Image_ID__c,ExRate_USD_to_Local__c from Online_Detail__c where TransactionID__c=:onlineEnquiryId];
                if(existingProdList != null && existingProdList.size() > 0){
                    System.debug('List is Not Empty--------->'+existingProdList.size());
                    for(Online_Detail__c eachExistingProd :existingProdList){
                        //System.debug('priceBookProductsMap contains key--------->'+eachExistingProd.Model__c);
                        System.debug('priceBookProductsMap contains key--------->'+priceBookProductsMap.containsKey(eachExistingProd.Model__c));
                        //System.debug('ProdMap---->'+priceBookProductsMap);
                        if(priceBookProductsMap.containsKey(eachExistingProd.Model__c)){
                            
                            System.debug('priceBookProductsMap contains key--------->'+eachExistingProd.Model__c);
                            //Adding to Selected List(Above List)
                            onlineDetailsToInsertOrUpdateMap.put(eachExistingProd.Model__c,  priceBookProductsMap.get(eachExistingProd.Model__c));
                            
                            //Adding dummyOnlineDetail to dummyOnlineDetailMap to get Quantity and Model Remark Values
                            Online_Detail__c dummyOnlineDetail = new Online_Detail__c();
                            if(eachExistingProd.Shipped_Date__c==null){
                                eachExistingProd.Shipped_Date__c = Date.today();
                            }
                            dummyOnlineDetailMap.put(eachExistingProd.Model__c, eachExistingProd);
                            
                            
                            System.debug('removed--->'+priceBookProductsMap.get(eachExistingProd.Model__c));
                            //Removing from Select List(Below List)
                            priceBookProductsMap.remove(eachExistingProd.Model__c);
                        }
                    }
                    System.debug('priceBookProductsMap---->'+priceBookProductsMap);
                    System.debug('priceBookProductsMap Size---->'+priceBookProductsMap.size());
                    System.debug('All Done------------->');               
                }            
                
                
                
                System.debug('All Done Again------------->');
            }else{
                priceBookProductsMap = new Map<String, Price_Specification_Book_Product__c>();
            }
            
        }else{
            priceBookProductsMap = new Map<String, Price_Specification_Book_Product__c>();            
        }
        
        
        System.debug('LastpriceBookProductsMap---->'+priceBookProductsMap);
        System.debug('LastpriceBookProductsMap Size---->'+priceBookProductsMap.size());
    } 
    public String getPriceSpecBookProdQuery(){
        String queryBuilt = '';
        
        //-- added IF Condition and included requestedCurrency into query filter :  by Sharan 30 MARCH 2016 - START
        if(requestedCurrency!=null && requestedCurrency.length()>0){
            //Edit By Tony +ExRate_USD_to_Local__c 20200108
              String queryFirstPart = 'select Id,Local_SKU__c, Name, BOX_QTY__c,Product_Unique_ID__c,CurrencyIsoCode, Customer_Ref_Model__c, Product_Unique_ID__r.Product_Description__c,Description__c, Product_Unique_ID__r.Product_Family__c, Product_Unique_ID__r.Product_Type__c, Color__c, Account__c,  Freight_Terms__c, Retailer_Code__c,Retailer_Code__r.Name, Product_Status__c,  Price_Specification_Book__r.Book_Status__c,  Price_Specification_Book__r.RecordTypeId, Country__c,Product_Category__c,Sizer_Print__c,Lead_Time__c, (Select Price_100_pcs__c,ExRate_USD_to_Local__c From Price_Product_by_Currency__r where CurrencyIsoCode=:requestedCurrency LIMIT 1) from Price_Specification_Book_Product__c where Price_Specification_Book__r.Book_Status__c=\'Active\' and  Price_Specification_Book__r.RecordTypeId=\'01290000000RyBQ\' and Retailer_Code__c =\''+onlineEnq.Retailer_Code__c+'\' and Product_Status__c=\'Active\' and Active__c=true and (RetailerBrand__c = \''+onlineEnq.ERP_End_User__c+'\''+'or RetailerBrand__c = \'\') and (Order_to_Company__c=\''+onlineEnq.Order_Country__c+'\')';
            //Edited by Tony 20190918
            //  String queryFirstPart = 'select Id,Local_SKU__c, Name, BOX_QTY__c,Product_Unique_ID__c,CurrencyIsoCode, Customer_Ref_Model__c, Product_Unique_ID__r.Product_Description__c,Description__c, Product_Unique_ID__r.Product_Family__c, Product_Unique_ID__r.Product_Type__c, Color__c, Account__c,  Freight_Terms__c, Retailer_Code__c,Retailer_Code__r.Name, Product_Status__c,  Price_Specification_Book__r.Book_Status__c,  Price_Specification_Book__r.RecordTypeId, Country__c,Product_Category__c,Sizer_Print__c,Lead_Time__c, (Select Price_100_pcs__c From Price_Product_by_Currency__r where CurrencyIsoCode=:requestedCurrency LIMIT 1) from Price_Specification_Book_Product__c where Price_Specification_Book__r.Book_Status__c=\'Active\' and  Price_Specification_Book__r.RecordTypeId=\'01290000000RyBQ\' and Retailer_Code__c =\''+onlineEnq.Retailer_Code__c+'\' and Product_Status__c=\'Active\' and Active__c=true and (RetailerBrand__c = \''+onlineEnq.ERP_End_User__c+'\''+'or RetailerBrand__c = \'\') and (Country__c= \''+onlineEnq.Ship_to_Country__c+'\''+'or Order_to_Company__c=\''+onlineEnq.Order_Country__c+'\')';
            
            String queryLastPart = ' ORDER BY Display_Order__c ASC, Customer_Ref_Model__c ASC, Color__c DESC, Product_Unique_ID__r.Product_Description__c ASC  NULLS LAST';
            if(modelName!=null && modelName.length()>0){
                queryFirstPart = queryFirstPart+' and Name LIKE \'%'+modelName+'%\'';
            }
            if(productType!=null && productType.length()>0 && !productType.contains('--None--')){
                queryFirstPart = queryFirstPart+' and Product_Unique_ID__r.Product_Type__c LIKE \'%'+productType+'%\'';
            }
            
            // added by pawan 16 MAY 2016 - START
            if(productCategory!=null && productCategory.length()>0 && !productCategory.contains('--None--')){
                queryFirstPart = queryFirstPart+' and Product_Category__c LIKE \'%'+productCategory+'%\'';
            }
            if(productFamily!=null && productFamily.length()>0 && !productFamily.contains('--None--')){
                queryFirstPart = queryFirstPart+' and Product_Unique_ID__r.Product_Family__c LIKE \'%'+productFamily+'%\'';
            }
            if(productColor!=null && productColor.length()>0 && !productColor.contains('--None--')){
                queryFirstPart = queryFirstPart+' and Color__c LIKE \'%'+productColor+'%\'';
            }
            if(productPrint!=null && productPrint.length()>0 && !productPrint.contains('--None--')){
                queryFirstPart = queryFirstPart+' and Sizer_Print__c LIKE \'%'+productPrint+'%\'';
            }
            // added by pawan 16 MAY 2016 - START
            // revised by tony 21-feb 2019 - RETAILERBRAND
            queryBuilt = queryFirstPart + queryLastPart;
        }
        
        
        return queryBuilt;
    }
    public void Clear(){
        modelName = '';
        productType = '';
        this.Search();
    }
    /* Added new variables for search criteria, Model and Product Type search. 01.05.2014 - End*/
    
    public PageReference Add(){
        this.save();
        //return new PageReference('/apex/AddOtherCharges'+'?'+'OnlineEnquiryId='+onlineEnquiryId+'&UsdToLocalCurValue='+usdToLocalCurMultiplier+'&isAddRemarks=false');
        return new PageReference('/apex/AddOtherCharges'+'?'+'OnlineEnquiryId='+onlineEnquiryId+'&isAddRemarks=false');
    }
    
    public PageReference Remark(){
        this.save();
        return new PageReference('/apex/AddOtherCharges'+'?'+'OnlineEnquiryId='+onlineEnquiryId+'&isAddRemarks=true');
        //return new PageReference('/apex/AddOtherCharges'+'?'+'OnlineEnquiryId='+onlineEnquiryId+'&UsdToLocalCurValue='+usdToLocalCurMultiplier+'&isAddRemarks=true');
    }
    
    public void AddProduct(){
        isAddProduct = true;
    }
    
    public void AddRemarks(){
        isAddRemarks = true;
    }
    
    public void AddOtherCharges(){
        isAddOtherCharges = true;
    }
    
    public void AddSalesPersonInfo(){
        isAddSalesPersonInfo = true;
    }
    
    public PageReference PreviewQuotePdf(){
        this.save();
        PageReference pg = new PageReference('/apex/QutotationGenerationPdfTemplate'+'?'+'id='+onlineEnquiryId);
        pg.setRedirect(true);
        return pg;  
    }
    
    public PageReference goToBillToRecord(){
        this.save();
        PageReference blltoPg = new PageReference('/'+billToAddressId);
        blltoPg.setRedirect(true);
        return blltoPg;  
    }
    
        private string lineBreaks(string inText)
        {
           if (inText == null)
               return '';
           else
               return inText.replaceAll('<','(').replaceAll('>',')').replaceAll('\n','<br/>');
        }
        
    public List<SelectOption> getCountries(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =
        Price_Specification_Book_Product__c.Country__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('--None--','--None--'));
        for( Schema.PicklistEntry f : ple)
        {
          options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }   
    
    /*
    public List<SelectOption> getProductTypes1(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =
        Product__c.Product_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('--None--','--None--'));
        for( Schema.PicklistEntry f : ple)
        {
          options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    } */  
    
    public List<SelectOption> getProductTypes(){
        List<SelectOption> options = new List<SelectOption>();
        //Schema.DescribeFieldResult fieldResult =  Product__c.Product_Type__c.getDescribe();
        //List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('--None--','--None--'));
        set<String> keys = productTypeMap.keySet();
        for (String k:keys) {
            //system.debug(k +' : '+ productTypeMap.get(k));
            options.add(new SelectOption(k, productTypeMap.get(k)));
        }
        return options;
    }
    
    /*
    public List<SelectOption> getProductCategories1(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =
        Price_Specification_Book_Product__c.Product_Category__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('--None--','--None--'));
        for( Schema.PicklistEntry f : ple)
        {
          options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    } */  
    
    public List<SelectOption> getProductCategories(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--','--None--'));
        set<String> keys = productCategoryMap.keySet();
        for (String k: keys) {
            //system.debug(k +' : '+ productTypeMap.get(k));
            options.add(new SelectOption(k, productCategoryMap.get(k)));
        }
        return options;
    }
    
    /*
    public List<SelectOption> getProductFamilies1(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =
        Product__c.Product_Family__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('--None--','--None--'));
        for( Schema.PicklistEntry f : ple)
        {
          options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }*/
    
    public List<SelectOption> getProductFamilies(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--','--None--'));
        set<String> keys = productFamilyMap.keySet();
        for (String k:keys) {
            //system.debug(k +' : '+ productTypeMap.get(k));
            options.add(new SelectOption(k, productFamilyMap.get(k)));
        }
        return options;
    }
    
    /*
    public List<SelectOption> getProductColors1(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =
        Price_Specification_Book_Product__c.Color__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('--None--','--None--'));
        for( Schema.PicklistEntry f : ple)
        {
          options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }*/
    
    public List<SelectOption> getProductColors(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--','--None--'));
        set<String> keys = productColorMap.keySet();
        for (String k:keys) {
            //system.debug(k +' : '+ productTypeMap.get(k));
            options.add(new SelectOption(k, productColorMap.get(k)));
        }
        return options;
    }
    
    public List<SelectOption> getProductSizePrint(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--','--None--'));
        set<String> keys = productSizerPrintMap.keySet();
        for (String k:keys) {
            //system.debug(k +' : '+ productTypeMap.get(k));
            options.add(new SelectOption(k, productSizerPrintMap.get(k)));
        }
        return options;
    }
    
    public void populateMainContactDetails(){
        System.debug('##populateMainContactDetailsClicked--->'+onlineEnq.Main_Contact_Id__c);
        if(onlineEnq.Main_Contact_Id__c!=null){
            Main_Contact__c mainContactDetails = [select First_Name__c, Last_Name__c, Email_Address__c, Contact_Number__c,Local_ERP_Sales_Person_Code__c from Main_Contact__c where Id=:onlineEnq.Main_Contact_Id__c];
            onlineEnq.Account_Manager__c = mainContactDetails.First_Name__c + ' ' + mainContactDetails.Last_Name__c;
            onlineEnq.Account_Manager_Contact_Number__c = mainContactDetails.Contact_Number__c;
            onlineEnq.Account_Manager_Email_Address__c = mainContactDetails.Email_Address__c;
            onlineEnq.Account_Manager_Local_Code__c= mainContactDetails.Local_ERP_Sales_Person_Code__c;
        }else{
            onlineEnq.Account_Manager__c = '';
            onlineEnq.Account_Manager_Contact_Number__c = '';
            onlineEnq.Account_Manager_Email_Address__c = '';
            onlineEnq.Account_Manager_Local_Code__c= '';
        }
    }
 
 public void populateMainContactCSDetails(){
        System.debug('##populateMainContactDetailsClicked--->'+onlineEnq.Main_Contact_Id__c);
        if(onlineEnq.Main_Contact_Id__c!=null){
            Main_Contact__c mainContactDetails = [select First_Name__c, Last_Name__c, Email_Address__c, Contact_Number__c,Local_ERP_Sales_Person_Code__c from Main_Contact__c where Id=:onlineEnq.Main_Contact_Id__c];
            onlineEnq.Customer_Service_Name__c = mainContactDetails.First_Name__c + ' ' + mainContactDetails.Last_Name__c;
            onlineEnq.Customer_Service_Contact_Number__c = mainContactDetails.Contact_Number__c;
            onlineEnq.Customer_Service_Email_Address__c = mainContactDetails.Email_Address__c;
            onlineEnq.Customer_Service_Local_Code__c= mainContactDetails.Local_ERP_Sales_Person_Code__c;
        }else{
            onlineEnq.Customer_Service_Name__c = '';
            onlineEnq.Customer_Service_Contact_Number__c = '';
            onlineEnq.Customer_Service_Email_Address__c = '';
            onlineEnq.Customer_Service_Local_Code__c= '';
        }
    }
    
   
    public void populatePartnerTermsNConditions(){
        System.debug('##PartnerDetailsClicked--->'+onlineEnq.Partner_Id__c);
        if(onlineEnq.Partner_Id__c!=null){
            Partner__c partnerDetails = [select Standard_Terms_Condition__c from Partner__c where Id=:onlineEnq.Partner_Id__c];
            onlineEnq.Sales_Rep_Remark__c = partnerDetails.Standard_Terms_Condition__c;
            
            List<Bill_to_ERP_Link__c>  billToRPLink= [Select Id,Local_ERP_Payment_Term__c,Local_ERP_Payment_Code__c,Local_ERP_customer_code__c from Bill_to_ERP_Link__c where Mainetti_Company__c=: onlineEnq.Partner_Id__c AND Parent_Bill_To__c=:onlineEnq.Bill_To__c Order By CreatedDate DESC];
            
            if(billToRPLink!=null && billToRPLink.size()>0 && !billToRPLink.isEmpty()){
                String paymentCode = billToRPLink.get(0).Local_ERP_Payment_Code__c;
                String customerCode = billToRPLink.get(0).Local_ERP_customer_code__c;
                if(!String.isBlank(paymentCode) && !String.isEmpty(paymentCode) && !String.isBlank(customerCode) && !String.isEmpty(customerCode)){
                    onlineEnq.Payment_Term__c = billToRPLink.get(0).Local_ERP_Payment_Code__c;
                }else{
                    onlineEnq.Payment_Term__c='';
                }
            }else{
                onlineEnq.Payment_Term__c='';
            }
            
            /*
            if(billToRPLink!=null && billToRPLink.size()>0 && !billToRPLink.isEmpty()){
            String billToPaymentTerms = billToRPLink.get(0).Local_ERP_Payment_Term__c;
                if(!String.isBlank(billToPaymentTerms) && !String.isEmpty(billToPaymentTerms)){
                    onlineEnq.Payment_Term__c = billToPaymentTerms;
                }
            }*/
        }else{
            onlineEnq.Sales_Rep_Remark__c = '';
        }
    }
    
    public void addRow(){
        Online_Enquiry_Charges__c onlineEnqCharges = new Online_Enquiry_Charges__c();
        onlineEnqCharges.Online_Enquiry_ID__c = onlineEnquiryId;
        onlineEnqCharges.Requested_Currency__c = onlineEnq.Preferred_Currency__c;
        onlineEnqCharges.Tax__c = taxPercentage;
        System.debug('taxPercentage:'+taxPercentage);
        if(taxPercentage>0){
            onlineEnqCharges.Include_Tax__c = true;
        }else{
            onlineEnqCharges.Include_Tax__c = false;
        }
        
        insert(onlineEnqCharges);
        
        onlineEnqChargesList.add(onlineEnqCharges);
        onlineEnqChargesIdMap = new Map<Id,Online_Enquiry_Charges__c>(onlineEnqChargesList);
    }
    
    public void deleteEnquiryChargesById(){
        Online_Enquiry_Charges__c onlineEnqCharges = new Online_Enquiry_Charges__c(Id=enquiryChargesRowId);
        delete(onlineEnqCharges);
        
        // remove form Map
        onlineEnqChargesIdMap.remove(enquiryChargesRowId);
        onlineEnqChargesList = onlineEnqChargesIdMap.values();
    }

    public PageReference checkShipDate(){
        this.save();
        return new PageReference('/apex/CheckShipDate?OnlineEnquiryId='+onlineEnquiryId);
    }   
    
    
}