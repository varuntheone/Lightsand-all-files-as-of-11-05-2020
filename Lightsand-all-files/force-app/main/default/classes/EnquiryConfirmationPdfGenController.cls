public class EnquiryConfirmationPdfGenController{
    public Boolean isProdImageToBeDisplayed{get; set;}
     
    public Online_Enquiry__c onlineEnqForPDF{get; set;}
    public String totalProdDetails {get; set;}
    public List<DetailDisplay> detailsList {get; set;}
    
    public String totalTax{get;set;}    
    public String totalAdminCharges{get;set;}    
    public String totalFreightCharges{get;set;}
    public String taxPercentage{get;set;}
    public String total{get;set;}
    public String finalTotal{get;set;}
    public String lCurrency{get;set;}
    public boolean isTotal{get;set;}
    public String retailerCodeName{get;set;}    
    public String exportTerm{get;set;}  
    public String paymentTerm{get;set;} 
    public String salesPerson{get;set;} 
    public String salesPersonEmail{get;set;}    
    public String salesPersonContactNumber{get;set;}
    public String division{get;set;}
    public String label{get;set;}
    public String season{get;set;}
    public String seasonYear{get;set;}
    public String manufaturerCode{get;set;}
    public String supplierCode{get;set;}
    Public Date expectedShipDate{get;set;}
               
    public Partner__c partner{get; set;}
    
    public String partnerAddress{get;set;}
    
    public String salesRepRemarks{get;set;}

    public Boolean showTax{get;set;}
    public Boolean showFreightCharges{get;set;}
    public Boolean showAdminsCharges{get;set;}
    public Boolean showRemarks{get;set;}
    
    public String quoteVersionNumber{get;set;}
    public Date Today { get { return Date.today(); }}
    
    public EnquiryConfirmationPdfGenController(){
        System.debug('##Inside Constructor');
        totalProdDetails = '';
        String onlineEnquiryId = ApexPages.currentPage().getparameters().get('id');
        quoteVersionNumber = ApexPages.currentPage().getparameters().get('quoteVersion');
        System.debug('##onlineEnquiryId:'+onlineEnquiryId+'quoteVersionNumber:'+quoteVersionNumber);
        try{
        if(!String.isEmpty(onlineEnquiryId) && onlineEnquiryId.length()>0){
                try{
                onlineEnqForPDF = [select Id, Name, Division__c, Label__c, Season__c, Season_Year__c, Manufacturer_Code__c, Supplier_Code__c, Enquiry_Date__c,Sales_Representative__c,Mainetti_Company__c,Bill_to_Company__c,Bill_to_Address1__c,Bill_to_Address2__c,Bill_to_Contact__c,Bill_to_State__c,Bill_to_Country__c,Bill_to_Email__c,Bill_to_Fax__c,Bill_to_Postcode__c,Bill_to_Tel__c,Ship_to_Address1__c,Ship_to_Address2__c,Ship_to_Company__c,Ship_to_Contact__c,Ship_to_Country__c,Ship_to_Email__c,Ship_to_Fax__c,Ship_to_Postcode__c,Ship_to_State__c,Ship_to_Tel__c,Order_Country__c,Order_Customer_Name__c,OwnerId,Expected_Ship_Date__c,Customer_Comments__c,Retailer_Code__c,Preferred_Currency__c,Tax__c,Freight_Charges__c,Admin_Charges__c,Export_Term__c,Sales_Rep_Remark__c,Partner_Id__c,Payment_Term__c,Account_Manager__c,Account_Manager_Email_Address__c,Account_Manager_Contact_Number__c,Retailer_Code__r.Display_Image_In_Document__c from Online_Enquiry__c where Id=:onlineEnquiryId];        
                }catch(System.Exception onlineEnqForPDFQueryEx){
                    System.debug('##onlineEnqForPDFQuery:'+onlineEnqForPDFQueryEx.getStackTraceString());
                }
                
            System.debug('onlineEnqForPDF'+onlineEnqForPDF);
            //System.debug('onlineEnqForPDF'+onlineEnqForPDF.Bill_to_Company__c);

            // added for conditionally image display
            isProdImageToBeDisplayed = onlineEnqForPDF.Retailer_Code__r.Display_Image_In_Document__c;
                
            List<Online_Detail__c> onlineProdDetailList = [select Model__c,Color__c,Product_Description__c,Product_Type__c,Product_Family__c,Qty__c,Retailer_Code__c,Model_Remark__c,USD_Price_100__c,Sales_Value_In_Local_Currency__c,USD_TO_PREFER_CURRENCY__c,Quoted_Currency_Price_100__c,Sales_Value_In_Quoted_Currency__c,Product_Image_ID__c from Online_Detail__c where TransactionID__c=:onlineEnquiryId];
            //System.debug("onlineProdDetailList:"+onlineProdDetailList);
            
            if(onlineProdDetailList!=null && onlineProdDetailList.size()>0){
                detailsList = new List<DetailDisplay>();
            }
            
            //Company Address Query
            try{
                partner = [select Office_Address__c from Partner__c where Id=:onlineEnqForPDF.Partner_Id__c];
                partnerAddress = ', '+partner.Office_Address__c;
            }catch(Exception partnerQueryEx){
                System.debug('##partnerQueryEx:'+partnerQueryEx.getStackTraceString());
            }
            
             for(Online_Detail__c eachProdDetail : onlineProdDetailList){
                //isTotal = true;
                System.debug('######################----------------In For Loop');
                try{
                 DetailDisplay detailDisp = new DetailDisplay();
                 detailDisp.model = [select Name from Price_Specification_Book_Product__c where Id=:eachProdDetail.Model__c].Name;
                 detailDisp.color = eachProdDetail.Color__c;
                 detailDisp.descreption = eachProdDetail.Product_Description__c;
                 detailDisp.productType = eachProdDetail.Product_Type__c;
                 detailDisp.productFamily = eachProdDetail.Product_Family__c;
                 detailDisp.qty = String.valueOf(eachProdDetail.Qty__c);
                 detailDisp.retailerCodeName = [select Name from Retailer_Code__c where Id=:eachProdDetail.Retailer_Code__c].Name;
                 detailDisp.productImage = eachProdDetail.Product_Image_ID__c;
                 retailerCodeName = detailDisp.retailerCodeName;

                 detailsList.add(detailDisp);
                 }catch(System.Exception e){
                    System.debug('##List:'+e.getStackTraceString());
                }
            }
            
                //lCurrency = onlineEnqForPDF.Preferred_Currency__c.substring(0,3);
                exportTerm = onlineEnqForPDF.Export_Term__c;
                salesRepRemarks=onlineEnqForPDF.Sales_Rep_Remark__c;
                salesRepRemarks=lineBreaks(salesRepRemarks);
                paymentTerm = onlineEnqForPDF.Payment_Term__c;
                salesPerson = onlineEnqForPDF.Account_Manager__c;
                salesPersonEmail = onlineEnqForPDF.Account_Manager_Email_Address__c;
                salesPersonContactNumber = onlineEnqForPDF.Account_Manager_Contact_Number__c;
                division = onlineEnqForPDF.Division__c;
                label = onlineEnqForPDF.Label__c;
                season = onlineEnqForPDF.Season__c;
                seasonYear = onlineEnqForPDF.Season_Year__c;
                manufaturerCode = onlineEnqForPDF.Manufacturer_Code__c;
                supplierCode = onlineEnqForPDF.Supplier_Code__c;
                expectedShipDate = onlineEnqForPDF.Expected_Ship_Date__c;
                
                if(String.isEmpty(onlineEnqForPDF.Sales_Rep_Remark__c) || String.isBlank(onlineEnqForPDF.Sales_Rep_Remark__c)){
                    showRemarks = false;
                }else{
                    showRemarks = true;
                }
            }
            }catch(System.Exception e){
                System.debug('##GlobalEx:'+e.getStackTraceString());
            }
    }
    
    public string lineBreaks(string inText)
    {
       if (inText == null)
           return '';
       else
           return inText.replaceAll('<','(').replaceAll('>',')').replaceAll('\n','<br/>');
    }
}