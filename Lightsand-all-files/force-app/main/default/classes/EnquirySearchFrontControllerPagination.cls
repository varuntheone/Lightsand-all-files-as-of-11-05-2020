public class EnquirySearchFrontControllerPagination{
        public Online_Enquiry__c onlineEnquiry {get; set;}
        LIST<Online_Enquiry__c> onlineEnquiriesResultList {get; set;}
        public Online_Detail__c onlineDetail {get; set;}
        public String errorMessage {get;set;}
        public boolean indicatorToPopulateErrorMessageBasedOnSearchCriteriaEmpty = true;
        //For Error Messages Start
        public boolean errorForFieldName=false;
        public boolean getErrorForFieldName(){
            return errorForFieldName;
        }
        public void setErrorForFieldName(boolean error){
            this.errorForFieldName = error;
        }
        
        //Pagination variables start
        private integer counter=0;  //keeps track of the offset
        private integer list_size=10; //sets the page size or number of rows
        public integer total_size; //used to show user the total size of the list
        private integer tempTotal_size=0;
        private integer totalRecordsInCurrentPage=0;
        public integer getTotalRecordsInCurrentPage(){
           if(totalRecordsInCurrentPage==0){
            totalRecordsInCurrentPage = list_size;
           }
           if(totalRecordsInCurrentPage>total_size){
            return total_size;
           }
           return totalRecordsInCurrentPage;
        }
          
        public integer getCounter(){
            return counter;
        }
        public integer getList_size(){
            return list_size;
        }
        //Pagination variables end
        private final integer searchChars=2;
        
        List<Online_Enquiry__c> noOfRows;

        //public List<Online_Enquiry__c> searchResList{get; set;}
        public List<DisplaySearchProperties> formattedQueryResultList {get; set;}
        //Page Block Methods Start
        public PageReference Beginning() { //user clicked beginning
              counter = 0;
             this.search();
              totalRecordsInCurrentPage = this.getTotalRecordsInCurrentPage();
              if(total_size<list_size){
              totalRecordsInCurrentPage = total_size;
              }else{
              totalRecordsInCurrentPage = list_size;
              }
              return null;
        }
     
        public PageReference Previous() { //user clicked previous button
          counter -= list_size;
          this.search();
           totalRecordsInCurrentPage = this.getTotalRecordsInCurrentPage();
           totalRecordsInCurrentPage = totalRecordsInCurrentPage -list_size;
           if(totalRecordsInCurrentPage - counter!=list_size){
           totalRecordsInCurrentPage = totalRecordsInCurrentPage +(list_size-(totalRecordsInCurrentPage - counter));
           }
          return null;
        }
     
        public PageReference Next() { //user clicked next button
          counter += list_size;
            this.search();
            totalRecordsInCurrentPage = this.getTotalRecordsInCurrentPage();
            totalRecordsInCurrentPage = totalRecordsInCurrentPage +list_size;
            if(totalRecordsInCurrentPage > total_size){
                totalRecordsInCurrentPage = total_size;
            }
          return null;
        }
     
        public PageReference End() { //user clicked end
          counter = total_size - math.mod(total_size, list_size);
          this.search();
           totalRecordsInCurrentPage = this.getTotalRecordsInCurrentPage();
          totalRecordsInCurrentPage = total_size;
          return null;
        }
     
        public Boolean getDisablePrevious() { 
          //this will disable the previous and beginning buttons
          if (counter>0) return false; else return true;
        }
     
        public Boolean getDisableNext() { //this will disable the next and end buttons
          if (counter + list_size < total_size) return false; else return true;
        }
     
        public Integer getTotal_size() {
          return total_size;
        }
     
        public Integer getPageNumber() {
          return counter/list_size + 1;
        }
        public Integer getTotalPages() {
          if (math.mod(total_size, list_size) > 0) {
             return total_size/list_size + 1;
          } else {
             return (total_size/list_size);
          }
        }
        //Page Block Methods Ends
        public EnquirySearchFrontControllerPagination(ApexPages.StandardController controller){
           onlineEnquiry = (Online_Enquiry__c)controller.getRecord();
           
            //onlineDetail.TransactionID__c = onlineEnquiry.Id;
            onlineDetail = new Online_Detail__c();
            //this.search();
        }
        
        public void Search(){
            System.debug('Enq Id--->'+onlineEnquiry.Name);
            System.debug('Enquiry Date--->'+onlineEnquiry.Enquiry_Date__c);
            System.debug('Enquiry Ship To Country--->'+onlineEnquiry.Ship_to_Country__c);
            System.debug('Enquiry Customer PO--->'+onlineEnquiry.Customer_PO_No__c);
            System.debug('Enquiry Order Country--->'+onlineEnquiry.Order_Country__c);
            System.debug('Enquiry Ship Date--->'+onlineEnquiry.Expected_Ship_Date__c);
            System.debug('Enquiry Status--->'+onlineEnquiry.Enquiry_Status__c);
            System.debug('Detail Model--->'+onlineDetail.Model__c);
             System.debug('Detail Model--->'+onlineDetail.TempModel__c);
            System.debug('Detail Color--->'+onlineDetail.Color__c);
            System.debug('Detail Product Type--->'+onlineDetail.Product_Type__c);
            System.debug('Detail Product Family--->'+onlineDetail.Product_Family__c);
            indicatorToPopulateErrorMessageBasedOnSearchCriteriaEmpty = true;
            total_size=getEnquiryCountWithBuildQuery();
            //For Pagination display records start
            if(formattedQueryResultList == null){
                tempTotal_size=total_size;
            }
            if(tempTotal_size!=total_size){
                counter=0;
                totalRecordsInCurrentPage=0;
            }
            //For Pagination display records end
            onlineEnquiriesResultList = getBuildedEnquiryQuery();
            /*for(Online_Enquiry__c enquiry : searchResList){
                System.debug('####Details from query---->'+enquiry.Transaction_Detail__r);
            }*/
            buildSearchResult(onlineEnquiriesResultList);
            Integer I=1;
            //For Error Messages Start
           /* if(indicatorToPopulateErrorMessageBasedOnSearchCriteriaEmpty && (onlineEnquiry.Name==null || onlineEnquiry.Name=='' || (onlineEnquiry.Name).length()<searchChars)){
                this.setErrorForFieldName(true);
            }else{
                indicatorToPopulateErrorMessageBasedOnSearchCriteriaEmpty=false;
                this.setErrorForFieldName(false);
            }*/
            if (errorForFieldName) {
               // classInputPostalCode = 'error';  // put the errorclass, red borders
                errorMessage = 'One of the field in search criteria must have at-least 2 characters or Cavity field should have an exact value';
                System.debug('####Message--->'+errorMessage );
                formattedQueryResultList = null;
                total_size=0;
            } else {
                //   classInputPostalCode = '';
                errorMessage = '';
            }
            //For Error Messages End
        }
        
        public void buildSearchResult(List<Online_Enquiry__c> returnedQureryResult){
            formattedQueryResultList = new List<DisplaySearchProperties>();
            if(returnedQureryResult!=null && returnedQureryResult.size()>0){
                for(Online_Enquiry__c enquiry : returnedQureryResult){
                    System.debug('####Details from query---->'+enquiry.Transaction_Detail__r);
                    List<Online_Detail__c> listOfOnlineDetails = enquiry.Transaction_Detail__r;
                    if(listOfOnlineDetails!=null && listOfOnlineDetails.size()>0){
                        for(Online_Detail__c eachOnlineDetail : listOfOnlineDetails){
                            //Online_Enquiry__c newEnquiry = enquiry;
                            //newEnquiry.Transaction_Detail__r = new List<Online_Detail__c>();
                            DisplaySearchProperties displayProp = new DisplaySearchProperties();    
                            displayProp.Name = enquiry.Name;
                            displayProp.Id = enquiry.Id;
                            displayProp.EnquiryDate = getFormattedDate(enquiry.Enquiry_Date__c);
                            displayProp.OrderCountry = enquiry.Order_Country__c;
                            displayProp.BillToFactory = getFormattedAddress(enquiry.Bill_to_Company__c, enquiry.Bill_to_Address1__c, enquiry.Bill_to_Address2__c, enquiry.Bill_to_State__c, enquiry.Bill_to_Postcode__c, enquiry.Bill_to_Country__c);
                            displayProp.ShipToFactory = getFormattedAddress(enquiry.Ship_to_Company__c, enquiry.Ship_to_Address1__c, enquiry.Ship_to_Address2__c, enquiry.Ship_to_State__c, enquiry.Ship_to_Postcode__c, enquiry.Ship_to_Country__c);
                            displayProp.ShipToCountry = enquiry.Ship_to_Country__c;
                            displayProp.ExpectedShipDate = getFormattedDate(enquiry.Expected_Ship_Date__c);
                            displayProp.EnquiryStatus = enquiry.Enquiry_Status__c;
                            displayProp.CustomerPONumber = enquiry.Customer_PO_No__c;
                            if(enquiry.Retailer_Code__c!=null ){
                                 displayProp.RetailerCode = [select Name from Retailer_Code__c where Id=:enquiry.Retailer_Code__c].Name;
                            }
                            displayProp.MainettiCompany = enquiry.Mainetti_Company__c;
                            displayProp.SalesRepresentative = enquiry.Sales_Representative__c;
                            /*if(eachOnlineDetail.Model__c!=null){
                                displayProp.Model = [select Name from Price_Specification_Book_Product__c where Id=:eachOnlineDetail.Model__c].Name;
                            }*/
                            displayProp.Model = eachOnlineDetail.TempModel__c;
                            displayProp.Color = eachOnlineDetail.Color__c;
                            displayProp.ProductType = eachOnlineDetail.Product_Type__c;
                            displayProp.ProductFamily = eachOnlineDetail.Product_Family__c;
                            displayProp.ProductDescreption = eachOnlineDetail.Product_Family__c;
                            if(eachOnlineDetail.Qty__c!=null){
                                displayProp.Qty = String.valueOf(eachOnlineDetail.Qty__c);
                            }else{
                                displayProp.Qty = '';
                            }
                            displayProp.ModelRemark = eachOnlineDetail.Model_Remark__c;
                            
                            formattedQueryResultList.add(displayProp);
                            }
                    }else{
                            DisplaySearchProperties displayProp = new DisplaySearchProperties();    
                            displayProp.Name = enquiry.Name;
                            displayProp.Id = enquiry.Id;
                            displayProp.EnquiryDate = getFormattedDate(enquiry.Enquiry_Date__c);
                            displayProp.OrderCountry = enquiry.Order_Country__c;
                            displayProp.BillToFactory = getFormattedAddress(enquiry.Bill_to_Company__c, enquiry.Bill_to_Address1__c, enquiry.Bill_to_Address2__c, enquiry.Bill_to_State__c, enquiry.Bill_to_Postcode__c, enquiry.Bill_to_Country__c);
                            displayProp.ShipToFactory = getFormattedAddress(enquiry.Ship_to_Company__c, enquiry.Ship_to_Address1__c, enquiry.Ship_to_Address2__c, enquiry.Ship_to_State__c, enquiry.Ship_to_Postcode__c, enquiry.Ship_to_Country__c);
                            displayProp.ShipToCountry = enquiry.Ship_to_Country__c;
                            displayProp.ExpectedShipDate = getFormattedDate(enquiry.Expected_Ship_Date__c);
                            displayProp.EnquiryStatus = enquiry.Enquiry_Status__c;
                            displayProp.CustomerPONumber = enquiry.Customer_PO_No__c;
                            displayProp.RetailerCode = enquiry.Retailer_Code__c;
                            displayProp.MainettiCompany = enquiry.Mainetti_Company__c;
                            displayProp.SalesRepresentative = enquiry.Sales_Representative__c;
                            formattedQueryResultList.add(displayProp);
                    }
                }
            }
        }
        
        public Integer getEnquiryCountWithBuildQuery(){
            Integer totalRecordsCount=0;
            String queryStr = buildSOQLQuery(true);
            System.debug('Query String:'+queryStr);
             totalRecordsCount = Database.countQuery(queryStr);
                System.debug('####TotalSize####'+totalRecordsCount);
            return totalRecordsCount;
           }
           
           public List<Online_Enquiry__c> getBuildedEnquiryQuery(){
            List<Online_Enquiry__c> enquiries;
            String queryStr = buildSOQLQuery(false);
            queryStr = queryStr+' LIMIT '+list_size+' OFFSET '+counter;
            System.debug('####queryStr--->'+queryStr);
            enquiries = Database.query(queryStr);
            return enquiries;
            }       
           
         //Build SQL Query Start
        public String buildSOQLQuery(Boolean isConstructor){
        String finalSQLQuery = '';
        String finalSQLQueryPart1 = '';
        if(isConstructor){
            finalSQLQueryPart1 = 'Select count() from Online_Enquiry__c WHERE';
        }else{
            /* if(checkOnlineDetailQueryPresent()){
             finalSQLQueryPart1 = 'Select Name, Enquiry_Date__c, Ship_to_Country__c, Customer_PO_No__c, Order_Country__c, Expected_Ship_Date__c, Enquiry_Status__c, Mainetti_Company__c, Sales_Representative__c, Retailer_Code__c, Bill_to_Company__c, Bill_to_Address1__c, Bill_to_Address2__c, Bill_to_State__c, Bill_to_Postcode__c, Bill_to_Country__c, Ship_to_Company__c, Ship_to_Address1__c, Ship_to_Address2__c, Ship_to_State__c, Ship_to_Postcode__c, Retailer_Code1__c, '+getDetailQueryPart()+' from Online_Enquiry__c WHERE ';
            }else{
            finalSQLQueryPart1 = 'Select Name, Enquiry_Date__c, Ship_to_Country__c, Customer_PO_No__c, Order_Country__c, Expected_Ship_Date__c, Enquiry_Status__c, Mainetti_Company__c, Sales_Representative__c, Retailer_Code__c, Bill_to_Company__c, Bill_to_Address1__c, Bill_to_Address2__c, Bill_to_State__c, Bill_to_Postcode__c, Bill_to_Country__c, Ship_to_Company__c, Ship_to_Address1__c, Ship_to_Address2__c, Ship_to_State__c, Ship_to_Postcode__c, Retailer_Code1__c from Online_Enquiry__c Where ';
            }*/
            finalSQLQueryPart1 = 'Select Id, Name, Enquiry_Date__c, Ship_to_Country__c, Customer_PO_No__c, Order_Country__c, Expected_Ship_Date__c, Enquiry_Status__c, Mainetti_Company__c, Sales_Representative__c, Retailer_Code__c, Bill_to_Company__c, Bill_to_Address1__c, Bill_to_Address2__c, Bill_to_State__c, Bill_to_Postcode__c, Bill_to_Country__c, Ship_to_Company__c, Ship_to_Address1__c, Ship_to_Address2__c, Ship_to_State__c, Ship_to_Postcode__c, Retailer_Code1__c, '+getDetailQueryPart()+' from Online_Enquiry__c WHERE ';
        }
        String finalSQLQueryPart2 = getSQLQueryPart2();
        finalSQLQuery = finalSQLQueryPart1 + finalSQLQueryPart2;
        System.debug('####Final Query:'+finalSQLQuery );
            return finalSQLQuery;
        }
        public boolean checkOnlineDetailQueryPresent(){
            if((onlineDetail.TempModel__c!=null)||(onlineDetail.Product_Type__c!=null && onlineDetail.Product_Type__c.length()>0)||(onlineDetail.Color__c!=null && onlineDetail.Color__c.length()>0)||(onlineDetail.Product_Family__c!=null && onlineDetail.Product_Family__c.length()>0)){
                return true;
            }else{
                return false;
            }
        }
        public String getDetailQueryPart(){
            String detailQueryPart = '(Select Model__c, Color__c, Product_Type__c, Product_Family__c, Product_Description__c, Qty__c, Model_Remark__c, TempModel__c from Transaction_Detail__r';
            if(checkOnlineDetailQueryPresent()){
                detailQueryPart = detailQueryPart + ' where';
            }
            /*if(onlineDetail.Model__c!=null){
                if(!detailQueryPart.endsWith('where')){
                detailQueryPart = detailQueryPart + ' AND ';
                }
                detailQueryPart = detailQueryPart + ' Model__c';
                detailQueryPart = detailQueryPart + ' = ';
                detailQueryPart = detailQueryPart +'\'';
                //queryPart2 = queryPart2+'%';
                detailQueryPart = detailQueryPart + onlineDetail.Model__c;
                detailQueryPart = detailQueryPart +'\'';
            }*/
            if(onlineDetail.TempModel__c!=null){
                if(!detailQueryPart.endsWith('where')){
                    detailQueryPart = detailQueryPart + ' AND ';
                }
                detailQueryPart = detailQueryPart + ' TempModel__c';
                detailQueryPart = detailQueryPart + ' LIKE ';
                detailQueryPart = detailQueryPart +'\'';
                detailQueryPart = detailQueryPart +'%';
                detailQueryPart = detailQueryPart + onlineDetail.TempModel__c;
                detailQueryPart = detailQueryPart+ '%';
                detailQueryPart = detailQueryPart +'\'';
            }
            if(!isEmptyOrNullOrNone(onlineDetail.Color__c)){
                if(!detailQueryPart.endsWith('where')){
                    detailQueryPart = detailQueryPart + ' AND ';
                }
                detailQueryPart = detailQueryPart + ' Color__c';
                 detailQueryPart = detailQueryPart + ' LIKE ';
                 detailQueryPart = detailQueryPart +'\'';
                 detailQueryPart = detailQueryPart +'%';
                detailQueryPart = detailQueryPart + onlineDetail.Color__c;
                detailQueryPart = detailQueryPart+ '%';
                detailQueryPart = detailQueryPart +'\'';
            }
            if(!isEmptyOrNullOrNone(onlineDetail.Product_Type__c)){
                if(!detailQueryPart.endsWith('where')){
                detailQueryPart = detailQueryPart + ' AND ';
                }
                detailQueryPart = detailQueryPart + ' Product_Type__c';
                 detailQueryPart = detailQueryPart + ' LIKE ';
                 detailQueryPart = detailQueryPart +'\'';
                 detailQueryPart = detailQueryPart +'%';
                detailQueryPart = detailQueryPart + onlineDetail.Product_Type__c;
                detailQueryPart = detailQueryPart+ '%';
                detailQueryPart = detailQueryPart +'\'';
            }
             if(!isEmptyOrNullOrNone(onlineDetail.Product_Family__c)){
                 if(!detailQueryPart.endsWith('where')){
                detailQueryPart = detailQueryPart + ' AND ';
                }
                detailQueryPart = detailQueryPart + ' Product_Family__c';
                 detailQueryPart = detailQueryPart + ' LIKE ';
                  detailQueryPart = detailQueryPart +'\'';
                 detailQueryPart = detailQueryPart +'%';
                detailQueryPart = detailQueryPart + onlineDetail.Product_Family__c;
                 detailQueryPart = detailQueryPart+ '%';
                detailQueryPart = detailQueryPart +'\'';
            }
            detailQueryPart = detailQueryPart+')';
            return detailQueryPart;
        }
        
        public String getSQLQueryPart2(){
            String queryPart2 = '';
            if(!isEmptyOrNullOrNone(onlineEnquiry.Name)){
                //queryPart2 = queryPart2+' AND ';
                queryPart2 = queryPart2+' Name ';
                queryPart2 = queryPart2+' LIKE ';
                queryPart2 = queryPart2+'\'';
                queryPart2 = queryPart2+'%';    
                queryPart2 = queryPart2+onlineEnquiry.Name;
                queryPart2 = queryPart2+'%';
                queryPart2 = queryPart2+'\'';
            }
            System.debug('#### 1 queryPart2-->'+queryPart2 );
            if(onlineEnquiry.Enquiry_Date__c!=null){
                //queryPart2 = queryPart2+' AND ';
                if(queryPart2!=''){
                    queryPart2 = queryPart2 + ' AND ';
                }
                queryPart2 = queryPart2+' Enquiry_Date__c ';
                queryPart2 = queryPart2+' = ';
                //queryPart2 = queryPart2+'\'';
                //queryPart2 = queryPart2+'%';    
                queryPart2 = queryPart2+getFormattedDate(onlineEnquiry.Enquiry_Date__c);
                //queryPart2 = queryPart2+'%';
                //queryPart2 = queryPart2+'\'';
            }
            System.debug('#### 2 queryPart2-->'+queryPart2 );
            if(!isEmptyOrNullOrNone(onlineEnquiry.Ship_to_Country__c)){
               // queryPart2 = queryPart2+' AND ';
                if(queryPart2!=''){
                    queryPart2 = queryPart2 + ' AND ';
                }
                queryPart2 = queryPart2+' Ship_to_Country__c ';
                queryPart2 = queryPart2+' LIKE ';
                queryPart2 = queryPart2+'\'';
                queryPart2 = queryPart2+'%';    
                queryPart2 = queryPart2+onlineEnquiry.Ship_to_Country__c;
                queryPart2 = queryPart2+'%';
                queryPart2 = queryPart2+'\'';
            }
            System.debug('#### 3 queryPart2-->'+queryPart2 );
            if(!isEmptyOrNullOrNone(onlineEnquiry.Customer_PO_No__c)){
                //queryPart2 = queryPart2+' AND ';
                 if(queryPart2!=''){
                    queryPart2 = queryPart2 + ' AND ';
                }
                queryPart2 = queryPart2+' Customer_PO_No__c ';
                queryPart2 = queryPart2+' LIKE ';
                queryPart2 = queryPart2+'\'';
                queryPart2 = queryPart2+'%';    
                queryPart2 = queryPart2+onlineEnquiry.Customer_PO_No__c;
                queryPart2 = queryPart2+'%';
                queryPart2 = queryPart2+'\'';
            }
            System.debug('#### 4 queryPart2-->'+queryPart2 );
            if(!isEmptyOrNullOrNone(onlineEnquiry.Order_Country__c)){
                //queryPart2 = queryPart2+' AND ';
                 if(queryPart2!=''){
                    queryPart2 = queryPart2 + ' AND ';
                }
                queryPart2 = queryPart2+' Order_Country__c';
                queryPart2 = queryPart2+' LIKE ';
                queryPart2 = queryPart2+'\'';
                queryPart2 = queryPart2+'%';    
                queryPart2 = queryPart2+onlineEnquiry.Order_Country__c;
                queryPart2 = queryPart2+'%';
                queryPart2 = queryPart2+'\'';
            }
            System.debug('#### 5 queryPart2-->'+queryPart2 );
            if(onlineEnquiry.Expected_Ship_Date__c!=null){
                //queryPart2 = queryPart2+' AND ';
                 if(queryPart2!=''){
                    queryPart2 = queryPart2 + ' AND ';
                }
                queryPart2 = queryPart2+' Expected_Ship_Date__c';
                queryPart2 = queryPart2+' = ';
               // queryPart2 = queryPart2+'\'';
                //queryPart2 = queryPart2+'%';    
                queryPart2 = queryPart2+getFormattedDate(onlineEnquiry.Expected_Ship_Date__c);
                //queryPart2 = queryPart2+'%';
               // queryPart2 = queryPart2+'\'';
            }
            if(!isEmptyOrNullOrNone(onlineEnquiry.Enquiry_Status__c)){
                //queryPart2 = queryPart2+' AND ';
                System.debug('#### Start queryPart2-->'+queryPart2 );
                 if(queryPart2!=''){
                    queryPart2 = queryPart2 + ' AND ';
                }
                System.debug('#### End queryPart2-->'+queryPart2);
                queryPart2 = queryPart2+' Enquiry_Status__c';
                queryPart2 = queryPart2+' LIKE ';
                queryPart2 = queryPart2+'\'';
                queryPart2 = queryPart2+'%';    
                queryPart2 = queryPart2+onlineEnquiry.Enquiry_Status__c;
                queryPart2 = queryPart2+'%';
                queryPart2 = queryPart2+'\'';
            }
            return queryPart2;
        }

        public static Boolean isEmptyOrNullOrNone(String fieldName){
            if(fieldName==null||fieldName.equals('')||fieldName.length()==0){
                return true;
            }else{
                return false;
            }
            return false;
        }
        public static String getFormattedDate(Date dateValue){
            Datetime tempDateValue = null;
            String formattedDate = '';
            if(dateValue!=null){
                tempDateValue = Datetime.newInstance(dateValue.year(), dateValue.month(), dateValue.day());
                System.debug('Non Formatted Date--->'+dateValue);
                formattedDate = tempDateValue.format('yyyy-MM-dd');
                System.debug('Formatted Date--->'+tempDateValue);
            }
            return formattedDate;
        }
        public static String getFormattedAddress(String company, String addr1, String addr2, String state, String postCode, String country){
            String fullAddress = '';
            if(company!=null && company.length()>0){
                fullAddress = fullAddress + company;
            }
            if(addr1!=null && addr1.length()>0){
                if(fullAddress.length()>0 && !fullAddress.endsWith(',')){
                    fullAddress = fullAddress + ',';
                }
                fullAddress = fullAddress + addr1;
            }
            if(addr2!=null && addr2.length()>0){
                if(fullAddress.length()>0 && !fullAddress.endsWith(',')){
                    fullAddress = fullAddress + ',';
                }
                fullAddress = fullAddress + addr2;
            }
            if(state!=null && state.length()>0){
                if(fullAddress.length()>0 && !fullAddress.endsWith(',')){
                    fullAddress = fullAddress + ',';
                }
                fullAddress = fullAddress + state;
            }
            if(postCode!=null && postCode.length()>0){
                 if(fullAddress.length()>0 && !fullAddress.endsWith(',')){
                    fullAddress = fullAddress + ',';
                }
                fullAddress = fullAddress + postCode;
            }
            if(country!=null && country.length()>0){
                if(fullAddress.length()>0 && !fullAddress.endsWith(',')){
                    fullAddress = fullAddress + ',';
                }
                fullAddress = fullAddress + country;
            }
            return fullAddress;
        }
    public class DisplaySearchProperties{

    public String Name{get; set;}
    public String Id{get; set;}
    public String EnquiryDate{get; set;}
    public String OrderCountry{get; set;}
    public String BillToFactory{get; set;}
    public String ShipToFactory{get; set;}
    public String ShipToCountry{get; set;}
    public String ExpectedShipDate{get; set;}
    public String EnquiryStatus{get; set;}
    public String CustomerPONumber{get; set;}
    public String RetailerCode{get; set;}
    public String MainettiCompany{get; set;}
    public String SalesRepresentative{get; set;}
    public String Model{get; set;}
    public String Color{get; set;}
    public String ProductType{get; set;}
    public String ProductFamily{get; set;}
    public String ProductDescreption{get; set;}
    public String Qty{get; set;}
    public String ModelRemark{get; set;}
    

    public void DisplaySearchProperties(){
        
    }

    }
}