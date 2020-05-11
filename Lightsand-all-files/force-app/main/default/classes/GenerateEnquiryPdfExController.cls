public class GenerateEnquiryPdfExController {

    public String manufacturerCode { get; set; }
     public Online_Enquiry__c onlineEnqForPDF {get;set;}
     public List < DetailDisplay > detailsList {get;set;}
     public String lCurrency {get;set;}
     public String retailerCodeName {get;set;}
     public String exportTerm {get;set;}
     public String customerComments{get;set;}
     public Boolean showCustomerComments{set;get;}
     public String division{get;set;}
     public String label{get;set;}
     public String season{get;set;}
     Public String SeasonYear{get;set;}
     public String manufaturerCode{get;set;}
     public String supplierCode{get;set;}
     Public String CustomerPO{get;set;}
     //2019-Nov-28 Tony : adding the total Qty
     Public String totalqty{get;set;}
     
     public Boolean isProdImageToBeDisplayed {
      get;
      set;
     }
 
     Public Date expectedShipDate{get;set;}
     
         public GenerateEnquiryPdfExController() {
          // getting Online Enquiry Row Id
          String onlineEnquiryId = ApexPages.currentPage().getparameters().get('id');
          System.debug('##onlineEnquiryId:'+onlineEnquiryId);
          try{
          // checking empty or null
          if (!String.isEmpty(onlineEnquiryId) && onlineEnquiryId.length() > 0) {
               // querying Online Enquiry others detail.    
               try{
               onlineEnqForPDF = [select Name, Customer_PO_No__c, Enquiry_Date__c, Division__c, Label__c, Season__c, Season_Year__c, Manufacturer_Code__c, Supplier_Code__c, Sales_Representative__c, Mainetti_Company__c, Bill_to_Company__c, Bill_to_Address1__c, Bill_to_Address2__c, Bill_to_Contact__c, Bill_to_State__c, Bill_to_Country__c, Bill_to_Email__c, Bill_to_Fax__c, Bill_to_Postcode__c, Bill_to_Tel__c, Ship_to_Address1__c, Ship_to_Address2__c, Ship_to_Company__c, Ship_to_Contact__c, Ship_to_Country__c, Ship_to_Email__c, Ship_to_Fax__c, Ship_to_Postcode__c, Ship_to_State__c, Ship_to_Tel__c, Order_Country__c, Order_Customer_Name__c, OwnerId, Expected_Ship_Date__c, Customer_Comments__c, Retailer_Code__c, Preferred_Currency__c,Export_Term__c,Retailer_Code__r.Display_Image_In_Document__c from Online_Enquiry__c where Id = : onlineEnquiryId];
               System.debug('Queried Online Enquiry:' + onlineEnqForPDF);
               }catch(System.Exception onlineEnqForPDFQueryEx){
                    System.debug('##onlineEnqForPDFQuery:'+onlineEnqForPDFQueryEx.getStackTraceString());
                }

                // added for conditionally image display
                isProdImageToBeDisplayed = onlineEnqForPDF.Retailer_Code__r.Display_Image_In_Document__c;
    
               // query product line asociated to Online Enquiry
               //List < Online_Detail__c > onlineProdDetailList = [select Model__c, Color__c, Product_Description__c, Product_Type__c, Product_Family__c, Qty__c, Retailer_Code__c, Model_Remark__c,Product_Image_ID__c from Online_Detail__c where TransactionID__c = : onlineEnquiryId];
              //List < Online_Detail__c > onlineProdDetailList = [select Model__c,Online_Details_Status__c, Color__c, Product_Description__c, Product_Type__c, Product_Family__c, Qty__c, Retailer_Code__c, Model_Remark__c,Product_Image_ID__c from Online_Detail__c where TransactionID__c = : onlineEnquiryId and Online_Details_Status__c='New']; 
              List < Online_Detail__c > onlineProdDetailList = [select Model__c,Online_Details_Status__c, Color__c, Product_Description__c, Product_Type__c, Product_Family__c, Qty__c, Retailer_Code__c, Model_Remark__c,Product_Image_ID__c from Online_Detail__c where TransactionID__c = : onlineEnquiryId and Online_Details_Status__c!='Cancel']; 
              System.debug('Queried Online Product Details:' + onlineProdDetailList);
              System.debug('Product Details #######################:' + onlineProdDetailList);
                
               // saving memory
               if (onlineProdDetailList != null && onlineProdDetailList.size() > 0) {
                detailsList = new List < DetailDisplay > ();
               }
               //2019-Nov-28 Tony : adding the total Qty
               Decimal totalSum = 0;
               // getting all the product line item 
               for (Online_Detail__c eachProdDetail: onlineProdDetailList) {
                System.debug('######################----------------In For Loop');
                try{
                     System.debug('Product Status########:' + eachProdDetail.Online_Details_Status__c);
                    DetailDisplay detailDisp = new DetailDisplay();
                    detailDisp.model = [select Name from Price_Specification_Book_Product__c where Id = : eachProdDetail.Model__c].Name;
                    System.debug('MODEL########:' + detailDisp.model);
                    detailDisp.color = eachProdDetail.Color__c;
                    detailDisp.descreption = eachProdDetail.Product_Description__c;
                    detailDisp.productType = eachProdDetail.Product_Type__c;
                    detailDisp.productFamily = eachProdDetail.Product_Family__c;
                    detailDisp.qty = String.valueOf(eachProdDetail.Qty__c);
                    detailDisp.retailerCodeName = [select Name from Retailer_Code__c where Id = : eachProdDetail.Retailer_Code__c].Name;
                    retailerCodeName = detailDisp.retailerCodeName;
                    detailDisp.modelRemark = eachProdDetail.Model_Remark__c;
                    detailDisp.productImage = eachProdDetail.Product_Image_ID__c;
                    totalSum = totalSum+eachProdDetail.Qty__c;
                    detailsList.add(detailDisp);
                }catch(System.Exception e){
                    System.debug('##List:'+e.getStackTraceString());
                }
               }
               // END

               // may be used in future
               lCurrency = onlineEnqForPDF.Preferred_Currency__c.substring(0, 3);
               exportTerm = onlineEnqForPDF.Export_Term__c;
               division = onlineEnqForPDF.Division__c;
                label = onlineEnqForPDF.Label__c;
                season = onlineEnqForPDF.Season__c;
                seasonYear = onlineEnqForPDF.Season_Year__c;
                manufaturerCode = onlineEnqForPDF.Manufacturer_Code__c;
                supplierCode = onlineEnqForPDF.Supplier_Code__c;
                expectedShipDate = onlineEnqForPDF.Expected_Ship_Date__c;
                CustomerPO = onlineEnqForPDF.Customer_PO_No__c;
                //2019-Nov-28 Tony : adding the total Qty
                totalqty=string.valueOf(totalSum);
               
               
              }else{
                System.debug('Online Enquiry ROW Id is empty or null.');
              }
              
                customerComments = onlineEnqForPDF.Customer_Comments__c;
                customerComments = lineBreaks(customerComments);
                if(String.isEmpty(onlineEnqForPDF.Customer_Comments__c) || String.isBlank(onlineEnqForPDF.Customer_Comments__c)){
                    showCustomerComments = false;
                }else{
                    showCustomerComments = true;
                }
            }catch(System.Exception e){
                System.debug('##GlobalEx:'+e.getStackTraceString());
            }   
            
        } // constructor :END

    public string lineBreaks(string inText)
    {
       if (inText == null)
           return '';
       else
           return inText.replaceAll('<','(').replaceAll('>',')').replaceAll('\n','<br/>');
    }       
 }// class :END