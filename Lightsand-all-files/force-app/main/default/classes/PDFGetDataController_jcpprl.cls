public class PDFGetDataController_jcpprl{

    public Online_Enquiry__c onlineEnqForPDF{get; set;}
    public String totalProdDetails {get; set;}
    public List<DetailDisplay> detailsList {get; set;}
    
    public PDFGetDataController_jcpprl(){
        System.debug('##Inside Constructor');
        totalProdDetails = '';
        String onlineEnquiryId = ApexPages.currentPage().getparameters().get('id');
        System.debug('##onlineEnquiryId:'+onlineEnquiryId);
        if(!String.isEmpty(onlineEnquiryId) && onlineEnquiryId.length()>0){
                onlineEnqForPDF = [select Name,Enquiry_Date__c,Sales_Representative__c,Mainetti_Company__c,Bill_to_Company__c,Bill_to_Address1__c,Bill_to_Address2__c,Bill_to_Contact__c,Bill_to_State__c,Bill_to_Country__c,Bill_to_Email__c,Bill_to_Fax__c,Bill_to_Postcode__c,Bill_to_Tel__c,Ship_to_Address1__c,Ship_to_Address2__c,Ship_to_Company__c,Ship_to_Contact__c,Ship_to_Country__c,Ship_to_Email__c,Ship_to_Fax__c,Ship_to_Postcode__c,Ship_to_State__c,Ship_to_Tel__c,Order_Country__c,Order_Customer_Name__c,OwnerId,Expected_Ship_Date__c,Customer_Comments__c,Retailer_Code__c from Online_Enquiry__c where Id=:onlineEnquiryId];        
            System.debug('onlineEnqForPDF'+onlineEnqForPDF);
            System.debug('onlineEnqForPDF'+onlineEnqForPDF.Bill_to_Company__c);
            List<Online_Detail__c> onlineProdDetailList = [select Model__c,Color__c,Product_Description__c,Product_Type__c,Product_Family__c,Qty__c,Retailer_Code__c,Model_Remark__c from Online_Detail__c where TransactionID__c=:onlineEnquiryId];
            if(onlineProdDetailList!=null && onlineProdDetailList.size()>0){
                detailsList = new List<DetailDisplay>();
            }
             for(Online_Detail__c eachProdDetail : onlineProdDetailList){
                System.debug('######################----------------In For Loop');
                 DetailDisplay detailDisp = new DetailDisplay();
                 detailDisp.model = [select Name from Price_Specification_Book_Product__c where Id=:eachProdDetail.Model__c].Name;
                 detailDisp.color = eachProdDetail.Color__c;
                 detailDisp.descreption = eachProdDetail.Product_Description__c;
                 detailDisp.productType = eachProdDetail.Product_Type__c;
                 detailDisp.productFamily = eachProdDetail.Product_Family__c;
                 detailDisp.qty = String.valueOf(eachProdDetail.Qty__c);
                 detailDisp.retailerCodeName = [select Name from Retailer_Code__c where Id=:eachProdDetail.Retailer_Code__c].Name;
                 detailDisp.modelRemark = eachProdDetail.Model_Remark__c;
                 detailsList.add(detailDisp);
               
            }
            }
    }
}