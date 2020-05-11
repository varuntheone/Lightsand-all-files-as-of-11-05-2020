public with sharing class viewDemandForecastController {
    @AuraEnabled() 
    public static ViewDemandForeCastWrapper  fetchDemandForecastBySearch(String mainettiCompany,String retailerCode,String modelName,String weekStart,String weekEnd,boolean onlyShortFallRecords,Integer pageNumber,Integer recordToDisplay,boolean isCurrentWeek) {
        
        //List<Reuse_center_Inventory_Manager__c> userData = getUserAllocationAccess();
        //system.debug('userData:'+userData.size());
         Map<string,Map<string,string>>  companyUserAllocation = companyUserAllocation();
        Date weekStartDate;
        Date weekEndDate;
        if(String.isNotBlank(weekStart)){
            weekStartDate = Date.valueOf(weekStart);
        }
        if(String.isNotBlank(weekEnd)){
            weekEndDate = Date.valueOf(weekEnd);
        }
        
        InventoryAllocationMaster invAllocMaster = new InventoryAllocationMaster();
        
        Map<string,Weekly_Demand_Summary__c> weeklyDemandSummaryMap = invAllocMaster.fetchWeeklyDemandSummary( mainettiCompany, retailerCode, modelName, weekStartDate,weekEndDate,pageNumber,recordToDisplay,isCurrentWeek);
        
        ViewDemandForeCastWrapper viewDemandForecastWrap = new ViewDemandForeCastWrapper();
        List<ViewDemandForecastObj> viewDemandForecastList = new List<ViewDemandForecastObj>();
        if(weeklyDemandSummaryMap != null){
            
            viewDemandForecastWrap.recordToDisplay = recordToDisplay;
            viewDemandForecastWrap.pageNumber = pageNumber;
            
            if(pageNumber ==1){
                //Getting the total Record count of the search result
                if(weeklyDemandSummaryMap.containsKey('TotalCount')){
                    Weekly_Demand_Summary__c recCountList =  weeklyDemandSummaryMap.get('TotalCount');                     
                    String totalRecordCount =   recCountList.Week_Number__c; 
                    //System.debug('totalRecordCount:::::recCountList.Week_Number__c:::::'+recCountList);
                    viewDemandForecastWrap.totalDemandForecast = Integer.valueOf(totalRecordCount);                      
                }
            } 
            
            //Getting the Supply details
            Map<string,Weekly_Supply_Summary__c> weeklySupplySummaryMap = invAllocMaster.fetchWeeklySupplySummary(mainettiCompany,retailerCode,modelName,weekStartDate,weekEndDate,isCurrentWeek);
            // Map<string,Weekly_Supply_Summary__c> weeklySupplySummaryMap = new Map<string,Weekly_Supply_Summary__c>();
            Map<string,Weekly_Demand_Summary__c> weeklyInventoryAllocationSummaryMap;
            Map<string,Weekly_Demand_Summary__c> weeklyInventoryAllocationSummaryQtyNotAvailMap;
            Map<string,Weekly_Shipment_Summary__c> weeklyShipmentSummaryMap;
            if(isCurrentWeek){
                //Getting the Demand Summary Ids for the getting the shipping details
                MAP<ID,ID>  weeklyDemandSummaryIdMap = new MAP<ID,ID>();
                for(string demandKey : weeklyDemandSummaryMap.keySet()){                   
                    Weekly_Demand_Summary__c  weeklyDemandSummaryID = weeklyDemandSummaryMap.get(demandKey); 
                    if(weeklyDemandSummaryID != null && (weeklyDemandSummaryID.Id != null))
                    weeklyDemandSummaryIdMap.put(weeklyDemandSummaryID.Id, weeklyDemandSummaryID.Id);                    
                    
                }                
                SET<ID> weeklyDemandSummaryIds = weeklyDemandSummaryIdMap.keyset(); 
                //Fetching all the shipment details
                //weeklyShipmentSummaryMap = invAllocMaster.fetchWeeklyShipmentSummaryForDemandId(weeklyDemandSummaryIds); 
                weeklyInventoryAllocationSummaryMap = invAllocMaster.fetchInventoryAllocationForDemandIds(weeklyDemandSummaryIds);
                weeklyInventoryAllocationSummaryQtyNotAvailMap = invAllocMaster.fetchInventoryAllocationForDemandIdsQtyNotAvailable(weeklyDemandSummaryIds);
                
            }else{
                //weeklyShipmentSummaryMap = invAllocMaster.fetchWeeklyShipmentSummary(mainettiCompany,retailerCode,modelName,weekStartDate,weekEndDate,isCurrentWeek);
                weeklyInventoryAllocationSummaryMap =	invAllocMaster.getWeeklyInventoryAllocationSummary( mainettiCompany, retailerCode, modelName, weekStartDate,weekEndDate,isCurrentWeek);
                weeklyInventoryAllocationSummaryQtyNotAvailMap =	invAllocMaster.getWeeklyInventoryAllocationSummaryQtyNotAvailable( mainettiCompany, retailerCode, modelName, weekStartDate,weekEndDate,isCurrentWeek);
            } 
            
            /* Put retailer as key and allocated user as value to check for the logged in user has permission to allocate --Start-- */
            Map<string,Map<string,string>> retailerUserAllocation = new Map<string,Map<string,string>>();
            //List<Reuse_center_Inventory_Manager__c> userData = new List<Reuse_center_Inventory_Manager__c>()
                // = [Select Retailer_Name__c, User_Name__c from Reuse_center_Inventory_Manager__c];
            
            /*for(Reuse_center_Inventory_Manager__c data : userData){            
                if(!retailerUserAllocation.containsKey(data.Retailer_Name__c)){  
                    Map<string,string> userMap = new Map<string,string>();
                    userMap.put(data.User_Name__c,data.User_Name__c);
                    retailerUserAllocation.put(data.Retailer_Name__c,userMap);
                }else{
                    Map<string,string> userMap = retailerUserAllocation.get(data.Retailer_Name__c);
                    userMap.put(data.User_Name__c,data.User_Name__c);
                    retailerUserAllocation.put(data.Retailer_Name__c,userMap);
                }
            }   */     
            /* Put retailer as key and allocated user as value to check for the logged in user has permission to allocate --End-- */
            
                        
            //Build the View
            //system.debug('weeklyDemandSummaryMapSize:'+weeklyDemandSummaryMap.size());
            for(string demandKey : weeklyDemandSummaryMap.keySet()){
                //system.debug('########demandKey::::::'+demandKey);
                if(demandKey != 'TotalCount'){
                    ViewDemandForecastObj viewDmdForecast = new ViewDemandForecastObj();
                    Weekly_Demand_Summary__c  weeklyInventoryAlloc = new Weekly_Demand_Summary__c ();
                    Weekly_Demand_Summary__c  weeklyInventoryAllocQtyNotAvail = new Weekly_Demand_Summary__c ();
                    Weekly_Demand_Summary__c  weeklyDemandSummary = weeklyDemandSummaryMap.get(demandKey); 
                    //system.debug('########weeklyDemandSummary::::::'+weeklyDemandSummary);
                    Weekly_Supply_Summary__c  weeklySupplySummary = weeklySupplySummaryMap.get(demandKey);
                    //Weekly_Shipment_Summary__c  weeklyShipmentSummary = weeklyShipmentSummaryMap.get(demandKey);
                    if(!isCurrentWeek){
                        weeklyInventoryAlloc = weeklyInventoryAllocationSummaryMap.get(demandKey);
                         weeklyInventoryAllocQtyNotAvail = weeklyInventoryAllocationSummaryQtyNotAvailMap.get(demandKey);
                    }else{
                        weeklyInventoryAlloc = weeklyInventoryAllocationSummaryMap.get(weeklyDemandSummary.Id);
                        weeklyInventoryAllocQtyNotAvail = weeklyInventoryAllocationSummaryQtyNotAvailMap.get(weeklyDemandSummary.Id);                        
                        
                    }
                    Weekly_Demand_Summary__c  weeklyInventoryAllocationSummary = weeklyInventoryAlloc;
                    Weekly_Demand_Summary__c  weeklyInventoryAllocationSummaryQtyNotAvail = weeklyInventoryAllocQtyNotAvail;
                    //setting the demand details in the wrapper								 
                    viewDmdForecast.mainettiCompany = weeklyDemandSummary.Order_to_Company__c;	
                    viewDmdForecast.retailerCode =weeklyDemandSummary.Retailer_Name__c;
                    viewDmdForecast.model=weeklyDemandSummary.Mainetti_Model_Name__c;
                    viewDmdForecast.color=weeklyDemandSummary.Color__c;
                    viewDmdForecast.sizerPrinter=weeklyDemandSummary.Sizer_Print__c;
                    //system.debug('company:'+viewDmdForecast.mainettiCompany+' '+'retailer:'+viewDmdForecast.retailerCode+' '+'model:'+viewDmdForecast.model+' '+'color:'+viewDmdForecast.color);
                    if(String.isNotBlank(viewDmdForecast.mainettiCompany)&& String.isNotBlank(viewDmdForecast.retailerCode) && String.isNotBlank(viewDmdForecast.model) && String.isNotBlank(viewDmdForecast.color)){
                        if(weeklyDemandSummary!=null){
                            decimal total = 0;
                            if(weeklyDemandSummary.Quantity__c != null){
                                total = weeklyDemandSummary.Quantity__c;
                            }
                            viewDmdForecast.totalDemandQty= Integer.valueOf(total);
                        }else{
                            viewDmdForecast.totalDemandQty=0;
                        }                
                        if(weeklySupplySummary!=null){
                            decimal total = 0;
                            if(weeklySupplySummary.Quantity__c != null){
                                total = weeklySupplySummary.Quantity__c;
                            }
                            viewDmdForecast.totalSupplyQty=Integer.valueOf(total);
                        }else{
                            viewDmdForecast.totalSupplyQty=0;
                        }                
                        if(isCurrentWeek){
                            viewDmdForecast.weeklyDemandId=weeklyDemandSummary.Id;
                            if(weeklySupplySummary!=null){
                                if(weeklySupplySummary.Id != null)
                                    viewDmdForecast.weeklySupplyId=weeklySupplySummary.Id;
                            }                  
                            double totAllocQty = 0;
                            double totNotAllocQty = 0;
                            //system.debug('totAllocQty:'+weeklyInventoryAllocationSummary);
                            //system.debug('totAllocQtyNotAvail:'+weeklyInventoryAllocationSummaryQtyNotAvail);
                            if(weeklyInventoryAllocationSummary != null){
                                /*
                                 * isAllocationDone__c Checkbox is checked if stock is physically available/received.
                                 * So display total allocation only if the checkbox is checked.
                                 * Modified by @Varun
                                 * */
                                //if(weeklyInventoryAllocationSummary.isAllocationDone__c == true && weeklyInventoryAllocationSummary.Quantity__c != null){
                                //system.debug('totAllocQty:'+weeklyInventoryAllocationSummary.Quantity__c);
                                    totAllocQty = weeklyInventoryAllocationSummary.Quantity__c;  
                                	//totNotAllocQty = weeklyInventoryAllocationSummaryQtyNotAvail.Quantity__c;
                                //}else{
                                    //totAllocQty = 0;
                                //}                         
                            }
                            if(weeklyInventoryAllocationSummaryQtyNotAvail != null){
                                totNotAllocQty = weeklyInventoryAllocationSummaryQtyNotAvail.Quantity__c;
                            }
                           viewDmdForecast.totalAllocationQty= totAllocQty;
                           viewDmdForecast.allocationNotReceived= totNotAllocQty;
                        }else{
                            double totAllocQty = 0;
                            double totNotAllocQty = 0;
                            //system.debug('totAllocQty:'+weeklyInventoryAllocationSummary);
                            //system.debug('totAllocQtyNotAvail:'+weeklyInventoryAllocationSummaryQtyNotAvail);
                            if(weeklyInventoryAllocationSummary != null){
                                totAllocQty = weeklyInventoryAllocationSummary.Quantity__c;
                            }
                            if(weeklyInventoryAllocationSummaryQtyNotAvail != null){
                                totNotAllocQty = weeklyInventoryAllocationSummaryQtyNotAvail.Quantity__c;
                            }
                            viewDmdForecast.totalAllocationQty= totAllocQty;
                            viewDmdForecast.allocationNotReceived= totNotAllocQty;
                        }
                        
                        //system.debug('weeklyInventoryAllocationSummary.Quantity__c:'+weeklyInventoryAllocationSummary);
                        /*if(weeklyInventoryAllocationSummary != null){
                            if(weeklyInventoryAllocationSummary.isAllocationDone__c == false && weeklyInventoryAllocationSummary.Quantity__c != null){
                                viewDmdForecast.allocationNotReceived = weeklyInventoryAllocationSummary.Quantity__c;
                            }
                        }*/
                        /* --Start-- Check if the logged in user is allowed to allocate --Start-- */
                       /* if(isCurrentWeek){                        
                            String userName = UserInfo.getName();
                            //system.debug('userName:'+userName);
                            Map<string,string> userAllocated = retailerUserAllocation.get(viewDmdForecast.retailerCode);
                            
                            if(userAllocated != null){
                                if(userAllocated.containsKey(userName)){
                                    viewDmdForecast.hasAccessToAllocate = 'True';
                                }else{
                                    viewDmdForecast.hasAccessToAllocate = 'False';
                                }                        
                            }else{
                                viewDmdForecast.hasAccessToAllocate = 'False';
                            }
                        }else{
                            viewDmdForecast.hasAccessToAllocate = 'False';
                        }*/
                        if(isCurrentWeek){                        
                            String userName = UserInfo.getName();
                            //system.debug('userName:'+userName);
                            Map<string,string> userAllocated = companyUserAllocation.get(viewDmdForecast.mainettiCompany);
                            
                            if(userAllocated != null){
                                if(userAllocated.containsKey(userName)){
                                    viewDmdForecast.hasAccessToAllocate = 'True';
                                }else{
                                    viewDmdForecast.hasAccessToAllocate = 'False';
                                }                        
                            }else{
                                viewDmdForecast.hasAccessToAllocate = 'False';
                            }
                        }else{
                            viewDmdForecast.hasAccessToAllocate = 'False';
                        }
                        /* --End-- Check if the logged in user is allowed to allocate --End-- */
                        
                        //System.debug('viewDmdForecast.totalDemandQty:::'+viewDmdForecast.totalDemandQty+'::viewDmdForecast.totalSupplyQty::'+viewDmdForecast.totalSupplyQty+'::viewDmdForecast.totalSupplyQty::'+viewDmdForecast.totalSupplyQty);
                        //viewDmdForecast.variance =((viewDmdForecast.totalDemandQty - viewDmdForecast.totalSupplyQty )-viewDmdForecast.totalShipmentQty);                
                        viewDmdForecast.variance =(viewDmdForecast.totalDemandQty - viewDmdForecast.totalSupplyQty );
                        
                        //System.debug('viewDmdForecast.totalDemandQty:::'+viewDmdForecast.totalDemandQty+'::viewDmdForecast.totalSupplyQty::'+viewDmdForecast.totalSupplyQty+'::viewDmdForecast.totalAllocationQty::'+viewDmdForecast.totalAllocationQty);
                        //System.debug('viewDmdForecast.variance:::'+viewDmdForecast.variance);
                        
                        viewDmdForecast.totalBalance = (viewDmdForecast.totalAllocationQty  - viewDmdForecast.variance);
                        
                        if(viewDmdForecast.totalBalance < 0){
                            viewDmdForecast.isNegative = 'Negative';
                        }else{
                            viewDmdForecast.isNegative = 'Postive';
                        }
                        
                        if(onlyShortFallRecords){
                            //system.debug('if shortfall is true');
                            if(viewDmdForecast.isNegative == 'Negative'){
                                viewDemandForecastList.add(viewDmdForecast);
                            }
                        }else{
                            //system.debug('if shortfall is false');
                            viewDemandForecastList.add(viewDmdForecast);
                        }
                        
                        //viewDemandForecastList.add(viewDmdForecast);
                    }
                }
            }            
        }
        //System.debug('viewDemandForecastList:::::'+viewDemandForecastList);
        viewDemandForecastWrap.DemandForecastListToDisplay = viewDemandForecastList;
        return viewDemandForecastWrap;        
    }
    
    public static List<Reuse_center_Inventory_Manager__c> getUserAllocationAccess(){
        List<Reuse_center_Inventory_Manager__c> userData = [Select Retailer_Name__c, User_Name__c from Reuse_center_Inventory_Manager__c];
        return userData;
    }
      public static Map<string,string> orderCompanyToMainettiCompany(){
        Map<string,string> ordercompany = new Map<string,string>();
         List<Partner__c> companyData = [Select Name, Default_Order_to_Company__c from Partner__c where Default_Order_to_Company__c <> null];
        
        for(Partner__c data : companyData){           
                 ordercompany.put(data.Name, data.Default_Order_to_Company__c);
            }
        return ordercompany;
    
    }
    public static Map<string,Map<string,string>> companyUserAllocation(){
      Map<string,string>  ordertocompany = orderCompanyToMainettiCompany();
        Map<string,Map<string,string>> retailerUserAlloc = new Map<string,Map<string,string>>();
        //system.debug('ordertocompany'+ordertocompany);
        List<Reuse_center_Inventory_Manager__c> userData = [Select Mainetti_Name__c, User_Name__c from Reuse_center_Inventory_Manager__c
                                                            where Mainetti_Name__c <> null and User_Name__c <> null];
        
        for(Reuse_center_Inventory_Manager__c data : userData){            
            if(!retailerUserAlloc.containsKey(ordertocompany.get(data.Mainetti_Name__c))){  
                Map<string,string> userMap = new Map<string,string>();
                userMap.put(data.User_Name__c,data.User_Name__c);
                retailerUserAlloc.put(ordertocompany.get(data.Mainetti_Name__c),userMap);
                
            }else{
                Map<string,string> userMap = retailerUserAlloc.get(ordertocompany.get(data.Mainetti_Name__c));
                userMap.put(data.User_Name__c,data.User_Name__c);
                retailerUserAlloc.put(ordertocompany.get(data.Mainetti_Name__c),userMap);
            }
        }
        return retailerUserAlloc;
    }
    
    /*else{                    
if(weeklyInventoryAllocationSummary != null){
if(weeklyInventoryAllocationSummary.isAllocationDone__c == true && weeklyInventoryAllocationSummary.Quantity__c != null){
viewDmdForecast.totalAllocationQty= weeklyInventoryAllocationSummary.Quantity__c;
}else{
viewDmdForecast.totalAllocationQty= 0;
}
}else{
viewDmdForecast.totalAllocationQty= 0;
}
}*/
    public static Double allocationQtyforNotReceived(String demandId){
        Double quantity;
        AggregateResult[] allocationQtyList=  [SELECT Sum(Quantity__c) qty FROM Inventory_Allocation__c where Physically_Available__c =false 
                                               and Inventory_Allocation_Demand__c=:demandId];
        
        for(AggregateResult listData : allocationQtyList){
            quantity = Double.valueOf(listData.get('qty'));
        }
        system.debug('quantity:'+quantity);
        return quantity;
    }
    
    // create a wrapper class with @AuraEnabled Properties     
    public class ViewDemandForeCastWrapper { 
        @AuraEnabled public Integer recordToDisplay {get;set;} 
        @AuraEnabled public Integer pageNumber {get;set;} 
        @AuraEnabled public Integer totalDemandForecast {get;set;} 
        @AuraEnabled public List<ViewDemandForecastObj> DemandForecastListToDisplay {get;set;} 
    } 
}