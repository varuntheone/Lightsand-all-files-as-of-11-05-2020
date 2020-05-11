public class NewOrEdigProductSelectionExtension{
private final Online_Detail__c onlineDetail {get; set;}
    private String retailerCode {get; set;}
    private String onlineEnquiryId {get; set;}
    private String onlineDetailId {get; set;}
    public Online_Enquiry__c onlineEnquiry{get; set;}
    private Price_Specification_Book_Product__c products {get; set;}
    //Create a map between the Record Type Name and Id for easy retrieval
  Map<String,String> detailRecordTypes = new Map<String,String>{};
    public NewOrEdigProductSelectionExtension(ApexPages.StandardController controller){
       // onlineDetail = (Online_Detail__c)controller.getRecord();
        //onlineEnquiryId = ApexPages.currentPage().getparameters().get('OnlineEnquiryId');
        List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Online_Detail__c' and isActive=true];
        for(RecordType rt: rtypes){
            detailRecordTypes.put(rt.Name,rt.Id);
        }
        onlineDetailId= ApexPages.currentPage().getparameters().get('id');
        System.debug('##onlineDetailId--->'+onlineDetailId);
        onlineEnquiryId = ApexPages.currentPage().getparameters().get('CF00N90000009J0Lk_lkid');
        if(onlineEnquiryId==null || onlineEnquiryId.length()==0 && ApexPages.currentPage().getparameters().get('OnlineEnquiryId')!=null){
            onlineEnquiryId = ApexPages.currentPage().getparameters().get('OnlineEnquiryId');
        }
         System.debug('##onlineEnquiryId--->'+onlineEnquiryId);
        if(onlineDetailId!=null && onlineDetailId.length()>0){
            onlineEnquiryId = [select TransactionID__c from Online_Detail__c where Id=:onlineDetailId].TransactionID__c;
            System.debug('##Inside If onlineEnquiryId--->'+onlineEnquiryId);
            onlineEnquiry = [Select Id, Name, flagOnCreate__c, TempRetailerCodeId__c, Enquiry_Date__c, Ship_to_Country__c, Customer_PO_No__c, Order_Country__c, Expected_Ship_Date__c, Enquiry_Status__c, Mainetti_Company__c, Sales_Representative__c, Retailer_Code__c, Bill_to_Company__c, Bill_to_Address1__c, Bill_to_Address2__c, Bill_to_State__c, Bill_to_Postcode__c, Bill_to_Country__c, Ship_to_Company__c, Ship_to_Address1__c, Ship_to_Address2__c, Ship_to_State__c, Ship_to_Postcode__c, Retailer_Code1__c, (Select Reuse_Virgin__c, USD_Price_100__c, Freight_Term__c, TempModelId__c, Model__c, Color__c, Product_Type__c, Product_Family__c, Product_Description__c, Qty__c, Model_Remark__c, TempModel__c from Transaction_Detail__r where Id=:onlineDetailId and RecordTypeId=:detailRecordTypes.get('Open Order')) from Online_Enquiry__c WHERE Id=:onlineEnquiryId];
        } else{  
           // System.debug('###onlineEnquiryId---->'+onlineEnquiryId);
            onlineEnquiry = [Select Id, Name, flagOnCreate__c, TempRetailerCodeId__c, Enquiry_Date__c, Ship_to_Country__c, Customer_PO_No__c, Order_Country__c, Expected_Ship_Date__c, Enquiry_Status__c, Mainetti_Company__c, Sales_Representative__c, Retailer_Code__c, Bill_to_Company__c, Bill_to_Address1__c, Bill_to_Address2__c, Bill_to_State__c, Bill_to_Postcode__c, Bill_to_Country__c, Ship_to_Company__c, Ship_to_Address1__c, Ship_to_Address2__c, Ship_to_State__c, Ship_to_Postcode__c, Retailer_Code1__c, (Select Reuse_Virgin__c, USD_Price_100__c, Freight_Term__c, TempModelId__c, Model__c, Color__c, Product_Type__c, Product_Family__c, Product_Description__c, Qty__c, Model_Remark__c, TempModel__c from Transaction_Detail__r where RecordTypeId=:detailRecordTypes.get('Open Order')) from Online_Enquiry__c WHERE Id=:onlineEnquiryId];
            }
          System.debug('###onlineEnquiry---->'+onlineEnquiry);
            //System.debug('###onlineDetail.Retailer_Code__c---->'+onlineDetail.Retailer_Code__c);
             //System.debug('###onlineEnquiry.Retailer_Code__c---->'+onlineEnquiry.Retailer_Code__c);
            //onlineDetail.Model__c = [select Name, Product_Unique_ID__c, Customer_Ref_Model__c, Account__c, Price_1000pcs__c, Retailer_Code__c, Product_Status__c, Price_Specification_Book__r.Book_Status__c, Price_Specification_Book__r.RecordTypeId from Price_Specification_Book_Product__c where Price_Specification_Book__r.Book_Status__c='Active' and Price_Specification_Book__r.RecordTypeId='01290000000RyBQ' and Retailer_Code__c = :onlineEnquiry.Retailer_Code__c and Product_Status__c='Active' and Country__c= :onlineEnquiry.Order_Country__c LIMIT 1].Id;
        
        
         lstInner = new List<innerClass>();
         if(onlineEnquiry!=null){
             if(onlineEnquiry.Transaction_Detail__r!=null && onlineEnquiry.Transaction_Detail__r.size()>0){
                 List<Online_Detail__c> onlineDetails = onlineEnquiry.Transaction_Detail__r;
                 for(Online_Detail__c eachOnlineDetail : onlineDetails){
                     innerClass objInnerClass = new innerClass(count);
                     objInnerClass.onlineDetail = eachOnlineDetail;
                     objInnerClass.color = eachOnlineDetail.Color__c;
                     objInnerClass.pdtDesc = eachOnlineDetail.Product_Description__c;
                     objInnerClass.pdtType = eachOnlineDetail.Product_Type__c;
                     objInnerClass.pdtFamily = eachOnlineDetail.Product_Family__c;
                     //objInnerClass.usdPrice = eachOnlineDetail.
                     //objInnerClass.freightTerms = eachOnlineDetail.Freight_Term__c;
                     lstInner.add(objInnerClass); 
                 }
                 
             }
         }
        Integer totalRows = 4;
        Integer totalRecords = lstInner.size();
        Integer requiredRows = 0;
        if(totalRows>totalRecords){
            requiredRows = totalRows - totalRecords;
        }
        if(requiredRows>0){
            for(Integer i=0; i<requiredRows; i++){
                addMore();
            }
        }
        //addMore();
        //addMore();
        //addMore();
        //addMore();
        selectedRowIndex = '3';
    }
    public PageReference Save(){
        if(lstInner!=null && lstInner.size()>0){
             System.debug('Product Save Called---->'+lstInner.size());
            for(innerClass ic : lstInner){
                System.debug('These Products will be Saved--->'+ic.onlineDetail.TempModel__c+': Prod Id--->'+ic.onlineDetail.TempModelId__c);
                if(ic.onlineDetail.TempModel__c!=null && ic.onlineDetail.TempModel__c.length()>0 
                   && ic.onlineDetail.TempModelId__c!=null && ic.onlineDetail.TempModelId__c.length()>0){
                    ic.onlineDetail.Model__c = ic.onlineDetail.TempModelId__c;
                    System.debug('##TransactionID--->'+ic.onlineDetail.TransactionID__c);
                    if(ic.onlineDetail.TransactionID__c==null){
                        System.debug('##inside if--->'+ic.onlineDetail.TransactionID__c);
                        ic.onlineDetail.TransactionID__c = onlineEnquiryId;
                    }
                       System.debug('Qty---->'+ic.onlineDetail.Qty__c);    
                       if(ic.onlineDetail.Qty__c==null){
                           ic.onlineDetail.Qty__c=0;
                       }
                    
                    System.debug('Before Save---->'+ic.onlineDetail.Id);
                    upsert(ic.onlineDetail);
                    System.debug('After Save---->'+ic.onlineDetail.Id);
                    //Adding record type details start
                       System.debug('#####Before onlineDetail--->'+ic.onlineDetail.RecordTypeId);
                       ic.onlineDetail.RecordTypeId=detailRecordTypes.get('Open Order');
                       upsert(ic.onlineDetail);
                       System.debug('#####After onlineDetail--->'+ic.onlineDetail.RecordTypeId);
                    //Adding record type details end      
                }
            }
           // onlineEnquiry.flagOnCreate__c=true;
            //update(onlineEnquiry);
            //return new PageReference('/MainettiOnline/'+onlineEnquiryId+'?customSave=true&name='+onlineEnquiry.Name);
            //return new ApexPages.StandardController(onlineEnquiry).view();
            return null;
        }
        return null;
    }
    
    public PageReference Cancel(){
        //return new PageReference('/MainettiOnline/'+onlineEnquiryId);
        //onlineEnquiry.flagOnCreate__c=true;
        //update(onlineEnquiry);
        return new ApexPages.StandardController(onlineEnquiry).view();
    }
    //list of the inner class
    public List<innerClass> lstInner 
    {   get;set;    }
    //will indicate the row to be deleted
    public String selectedRowIndex
    {get;set;}  
    
    //no. of rows added/records in the inner class list
    public Integer count = 1;
    //{get;set;}
     //add one more row
    public void Add()
    {   
        count = count+1;
        addMore();      
    }
    
    /*Begin addMore*/
    public void addMore()
    {
        System.debug('Called Add More');
        //call to the iner class constructor
        innerClass objInnerClass = new innerClass(count);
        system.debug('lstInner before---->'+lstInner.size()); 
        //add the record to the inner class list
        lstInner.add(objInnerClass);    
        system.debug('lstInner after---->'+lstInner.size());            
    }/* end addMore*/
    
    /* begin delete */
    public void Del()
    {
        system.debug('lstInner.size()---->'+lstInner.size());
        system.debug('selected row index---->'+selectedRowIndex);
        lstInner.remove(Integer.valueOf(selectedRowIndex)-1);
        count = count - 1;
        
    }/*End del*/
    public PageReference init(){
        retailerCode = ApexPages.currentPage().getparameters().get('retailercode');
        return null;
    }
     /*Inner Class*/
    public class innerClass
    {       
        /*recCount acts as a index for a row. This will be helpful to identify the row to be deleted */
        public String recCount
        {get;set;}
        
        public final String color {get; set;}
        public final String pdtDesc {get; set;}
        public final String pdtType {get; set;}
        public final String pdtFamily {get; set;}
        public final String usdPrice {get; set;}
        public final String freightTerms {get; set;}
        
        public Online_Detail__c onlineDetail {get; set;}
        
        /*Inner Class Constructor*/
        public innerClass(Integer intCount)
        {
            recCount = String.valueOf(intCount);        
            
            /*create a new account*/
            onlineDetail = new Online_Detail__c();
            
        }/*End Inner class Constructor*/    
    }/*End inner Class*/

    /*For PDF Generation and Sending Mail*/
    public PageReference Submit(){
        this.Save();
        System.debug('######## Calling Utility Get Final PDF Content Method from Submit() of NewOrEdigProductSelectionExtension');
        Utility.getFinalPDFContent(onlineEnquiryId);
        System.debug('######## Utility Get Final PDF Content Method is Over Submit() of NewOrEdigProductSelectionExtension');
        return new ApexPages.StandardController(onlineEnquiry).view();
    }
    /*For PDF Generation and Sending Mail*/
}