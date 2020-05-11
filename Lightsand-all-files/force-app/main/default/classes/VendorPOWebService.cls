global class VendorPOWebService {
    
 global static String DELIM_THREE_HASH = '###';
    
  
  global class POHeaderRequestList {
      webservice POHeaderRequest[] PoHeader;
  }
    
    global class POHeaderRequest {
      webservice String PONumber;
      webservice String FactoryID;
      webservice PODetails PODetails;      
  }
    
    global class POHeaderRespons {
      webservice POHeaderResponseList POHeaderResponseList;
  }
    
    global class POHeaderResponseList {
      webservice List<POHeaderResponse> POHeaderResponse;
  }
    
  global class POHeaderResponse {
      webservice ID RecordID;
      webservice String PONumber;
      webservice String Status;
      webservice String ExceptionCode;
      webservice String ExceptionMessage;
      webservice PODetailsResponse PODetailList;
  }
    
    
  global class PODetails {
      webservice PODetail[] PODetail;
  }
    
     global class PODetailsResponse {
      webservice List<PODetailResponse> PODetailResponse;
  }
    
    global class PODetailResponse {
      webservice ID RecordID;
      webservice String ProductCode;
      webservice String Status;
      webservice String ExceptionCode;
      webservice String ExceptionMessage;      
  }
    
    global class PODetail {
      webservice String ProductCode;
      webservice Decimal LineNumber;
	  webservice String Status;
      webservice Date DeliveryDate;
      webservice Decimal Quantity;
  }
    

  webservice static POHeaderRespons CreateVenderPO(POHeaderRequestList POHeaderList) { 
      
      POHeaderRespons POHeaderResponsObj = new POHeaderRespons();
      
      Map<String,POHeaderResponse> responseMap = new Map<String,POHeaderResponse>();
      List<POHeaderResponse> responseList = new List<POHeaderResponse>();
      //--UPSERT Vendor_PO_Header__c
      Map<String,Id> poNumberAndHeaderIDMap = new Map<String,Id>();      
      Map<String,Vendor_PO_Details__c> poNumbProductCodeAndPODetailMap = new Map<String,Vendor_PO_Details__c>();      
      List<POHeaderRequest> vendorPOList = POHeaderList.PoHeader;
      
      List<String> factoryIDList = new List<String>();
      
      if(vendorPOList!=null && vendorPOList.size() > 0){          
          
          List<Vendor_PO_Header__c> poHeaderUpList = new List<Vendor_PO_Header__c>();          
          for(POHeaderRequest poHeader : vendorPOList){
              
              Vendor_PO_Header__c poHeaderObj = new Vendor_PO_Header__c();
              poHeaderObj.PO_Number__c = poHeader.PONumber;
              poHeaderObj.Factory_ID__c = poHeader.FactoryID;              
              poHeaderUpList.add(poHeaderObj);
              
              if(String.isNotBlank(poHeader.PONumber)){
              	factoryIDList.add(poHeader.FactoryID);    
              }              
              
              PODetail[] PODetails = poHeader.PODetails.PODetail;              
              
              for(PODetail eachPODetail : PODetails){
                  Vendor_PO_Details__c newPODetail = new Vendor_PO_Details__c();
                  newPODetail.Product_Code__c = eachPODetail.ProductCode;
                  newPODetail.Line_Number__c =   eachPODetail.LineNumber;                  
                  newPODetail.Delivery_Date__c =   eachPODetail.DeliveryDate;
                  newPODetail.Quantity__c =   eachPODetail.Quantity;
                  newPODetail.Status__c =   eachPODetail.Status;  
                  newPODetail.PO_Number__c =   poHeader.PONumber;
                  newPODetail.PO_Number_Bar_Code__c=poHeader.PONumber+DELIM_THREE_HASH+eachPODetail.ProductCode;
                  poNumbProductCodeAndPODetailMap.put(poHeader.PONumber+DELIM_THREE_HASH+eachPODetail.ProductCode, newPODetail);                  
              }              
          }
          
          //-- Query Customer Information Table to get mapping for factoryID 
          Map<String,String> vendorMap = new Map<String,String>();
          if(factoryIDList.size() >0){            
              List<Customer_Information__c> custInfoList = [SELECT ID,National_Vendor_ID__c FROM Customer_Information__c WHERE National_Vendor_ID__c IN :factoryIDList];
         	  for(Customer_Information__c eachCustInfo : custInfoList){                  
                  vendorMap.put(eachCustInfo.National_Vendor_ID__c,eachCustInfo.ID);
              }          
          }
                    
          if(poHeaderUpList!=null && poHeaderUpList.size()>0){
          	  
              List<Vendor_PO_Header__c> poHeaderUpsertList = new List<Vendor_PO_Header__c> ();
              if(vendorMap.size() > 0){
                  
                  for(Vendor_PO_Header__c eachVendPO : poHeaderUpList){
                      
                      if(String.isNotBlank(eachVendPO.Factory_ID__c) && vendorMap.containskey(eachVendPO.Factory_ID__c)){
                          eachVendPO.Customer_Information__c=vendorMap.get(eachVendPO.Factory_ID__c);
                      }
                      poHeaderUpsertList.add(eachVendPO);                      
                  }                  
              }else{
                  poHeaderUpsertList = poHeaderUpList;
              }
              
              Database.UpsertResult[] results = Database.upsert(poHeaderUpsertList,Vendor_PO_Header__c.Fields.PO_Number__c,false);
              for(Integer index = 0; index < results.size(); index++) { 
                
                  Database.UpsertResult sr = results[index];                  
                  POHeaderResponse resp = new POHeaderResponse();
                    if (sr.isSuccess()) {                        
                        resp.Status='Success';
                        resp.PONumber=poHeaderUpsertList[index].PO_Number__c;
                        resp.RecordID=sr.getId();
                        responseList.add(resp);
                        
                        responseMap.put(poHeaderUpsertList[index].PO_Number__c,resp);                        
                        poNumberAndHeaderIDMap.put(poHeaderUpsertList[index].PO_Number__c,sr.getID());
                    }
                    else {
                        
                        String statusCode ='';
                        String statusMessage ='';
                        // Operation failed, so get all errors                
                        for(Database.Error err : sr.getErrors()) {
                           statusCode =statusCode+err.getStatusCode();
                           statusMessage =statusMessage+err.getMessage();                            
                        }                        
                         resp.Status='Failed';
                         resp.ExceptionCode=statusCode;
                         resp.PONumber=poHeaderUpsertList[index].PO_Number__c;
                         resp.ExceptionMessage=statusMessage;
                        responseList.add(resp);
                        responseMap.put(poHeaderUpsertList[index].PO_Number__c,resp);
                    }                      
              }             
          }
          
          List<Vendor_PO_Details__c> poDetailList = new List<Vendor_PO_Details__c>();
          
          if(poNumbProductCodeAndPODetailMap!=null && poNumbProductCodeAndPODetailMap.size()>0){
              
              
              for(String eachKey : poNumbProductCodeAndPODetailMap.keySet()){                  
                  if(String.isNotBlank(eachKey)){
                      
                      Vendor_PO_Details__c eachPoDetail = poNumbProductCodeAndPODetailMap.get(eachKey);
                      String poNumber = eachKey.split(DELIM_THREE_HASH)[0];
                      if(poNumberAndHeaderIDMap!=null && poNumberAndHeaderIDMap.containsKey(poNumber)){
                          eachPoDetail.Vendor_PO_ID__c=poNumberAndHeaderIDMap.get(poNumber);
                          poDetailList.add(eachPoDetail);
                      }                  
                  }
              }
              
              if(poDetailList!=null && poDetailList.size()>0){
                  
                  Database.UpsertResult[] results = Database.upsert(poDetailList,Vendor_PO_Details__c.Fields.Product_Code__c,false);
                  for(Integer index = 0; index < results.size(); index++) { 
                    
                      String poNumber = poDetailList[index].PO_Number__c;
                      
                      Database.UpsertResult sr = results[index];                  
                      PODetailResponse resp = new PODetailResponse();
                        if (sr.isSuccess()) {                        
                            resp.Status='Success';
                            resp.ProductCode=poDetailList[index].Product_Code__c;
                            resp.RecordID=sr.getId();                      
                        }
                        else {
                            
                            String statusCode ='';
                            String statusMessage ='';
                            // Operation failed, so get all errors                
                            for(Database.Error err : sr.getErrors()) {
                               statusCode =statusCode+err.getStatusCode();
                               statusMessage =statusMessage+err.getMessage();                            
                            }                        
                             resp.Status='Failed';
                             resp.ProductCode=poDetailList[index].Product_Code__c;
                             resp.ExceptionCode=statusCode;
                             resp.ExceptionMessage=statusMessage;
                        }
                      
                          POHeaderResponse poHeaderResponseObj  = responseMap.get(poNumber);
                      	  PODetailsResponse PODetailsResponseObj = poHeaderResponseObj.PODetailList;
                          if(PODetailsResponseObj==null){
                              PODetailsResponseObj = new PODetailsResponse();
                          }
						  poHeaderResponseObj.PODetailList = PODetailsResponseObj;
                          List<PODetailResponse> PODetailResponseList = PODetailsResponseObj.PODetailResponse;
                      
                          if(PODetailResponseList==null || PODetailResponseList.size()<=0){
                              PODetailResponseList = new List<PODetailResponse>();
                          }
                      	  poHeaderResponseObj.PODetailList.PODetailResponse=PODetailResponseList;
                      	  PODetailResponseList.add(resp);                      
                      
                          poHeaderResponseObj.PODetailList.PODetailResponse=PODetailResponseList;
                          responseMap.put(poNumber,poHeaderResponseObj);                      
                  }                  
              }
          }     
      }
      
      POHeaderResponseList POHeaderResponseListObj =new POHeaderResponseList();
      POHeaderResponseListObj.POHeaderResponse= responseMap.values();
      POHeaderResponsObj.POHeaderResponseList = POHeaderResponseListObj;
      
    return  POHeaderResponsObj;
  }

}