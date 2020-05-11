public class WeeklySupplySummaryClass {
    @AuraEnabled
    public static ViewSupplySummaryWrapper  fetchSupplySummaryBySearch(String orderToCompany,String retailerCode,String modelName,String weekStart,String weekEnd,boolean isCurrentWeek,Integer pageNumber ,Integer recordToDisplay, String source, String warehouse) {
        //system.debug('### Inside fetchSupplySummaryBySearch ###');
        //system.debug('source:'+source);
        //system.debug('warehouse:'+warehouse);
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
        
        Map<string,Weekly_Supply_Summary__c> weeklySupplySummaryMap = invAllocMaster.fetchWeeklySupplySummaryDisplay( orderToCompany, retailerCode, modelName, weekStartDate, weekEndDate,isCurrentWeek,pageNumber,recordToDisplay,source,warehouse);
        ViewSupplySummaryWrapper viewSupplySummaryWrap = new ViewSupplySummaryWrapper();
        List<ViewDemandForecastObj> viewSupplySummaryList = new List<ViewDemandForecastObj>();
        //system.debug('weeklySupplySummaryMapSize:'+weeklySupplySummaryMap.size());
        
        
        /*list<AggregateResult> allocatedQuantity = [Select Inventory_Allocation_Supply__c, sum(Quantity__c) allocatedQtys from Inventory_Allocation__c GROUP BY Inventory_Allocation_Supply__c]; 
for ( AggregateResult allctQty : allocatedQuantity ){
allocatedQtyMap.put((String)allctQty.get('Inventory_Allocation_Supply__c'),(Decimal)allctQty.get('allocatedQtys'));
}*/
        
        /* Put retailer as key and allocated user as value to check for the logged in user has permission to allocate --Start-- */
        /*Map<string,Map<string,string>> retailerUserAllocation = new Map<string,Map<string,string>>();
        List<Reuse_center_Inventory_Manager__c> userData = [Select Mainetti_Name__c, User_Name__c from Reuse_center_Inventory_Manager__c];
        
        for(Reuse_center_Inventory_Manager__c data : userData){            
            if(!retailerUserAllocation.containsKey(data.Mainetti_Name__c)){  
                Map<string,string> userMap = new Map<string,string>();
                userMap.put(data.User_Name__c,data.User_Name__c);
                retailerUserAllocation.put(data.Mainetti_Name__c,userMap);
            }else{
                Map<string,string> userMap = retailerUserAllocation.get(data.Mainetti_Name__c);
                userMap.put(data.User_Name__c,data.User_Name__c);
                retailerUserAllocation.put(data.Mainetti_Name__c,userMap);
            }
        }*/      
        /* Put retailer as key and allocated user as value to check for the logged in user has permission to allocate --End-- */
        
        if(weeklySupplySummaryMap != null){ 
            
            viewSupplySummaryWrap.recordToDisplay = recordToDisplay;
            viewSupplySummaryWrap.pageNumber = pageNumber;
            
            if(pageNumber ==1){
                //Getting the total Record count of the search result
                if(weeklySupplySummaryMap.containsKey('TotalCount')){
                    Weekly_Supply_Summary__c recCountList =  weeklySupplySummaryMap.get('TotalCount');                     
                    String totalRecordCount =   recCountList.Week_Number__c; 
                    //System.debug('totalRecordCount:::::recCountList.Week_Number__c:::::'+recCountList);
                    viewSupplySummaryWrap.totalDemandForecast = Integer.valueOf(totalRecordCount);                      
                }
            }
            
            
            Map<string,Weekly_Supply_Summary__c> allocatedQtyMap;
            if(isCurrentWeek){
                Map<ID,ID> supplierIdsMap = new Map<ID,ID>();
                
                for(Weekly_Supply_Summary__c supplyVal : weeklySupplySummaryMap.values()){
                    if(String.isNotBlank(supplyVal.Id)){
                        supplierIdsMap.put(supplyVal.Id,supplyVal.Id);
                    }
                    
                }
                SET<ID> supplierKeys = supplierIdsMap.keyset();
                allocatedQtyMap = invAllocMaster.fetchInventoryAllocationForSupplierIdsV2(supplierKeys); //Changed by varun on 08-05-2020
            }else{
                allocatedQtyMap = invAllocMaster.getWeeklySupplyInventoryAllocationSummaryV2(orderToCompany,retailerCode,modelName,weekStartDate,weekEndDate,isCurrentWeek);
            }
            
            Map<string,string> supplyAddMap = new Map<string,string>();
            Map<string,string> supplySubMap = new Map<string,string>();
            if(source == 'Virgin'){                
                AggregateResult[] allocationData = [Select Inventory_Allocation_Supply__c supplyId, Inventory_Allocation_Supply_Virgin__c supplyVirginId, sum(Quantity__c) quantity from Inventory_Allocation__c
                                                    group by Inventory_Allocation_Supply__c, Inventory_Allocation_Supply_Virgin__c];
                
                for(AggregateResult allData : allocationData){
                    if(String.isNotBlank(String.valueOf(allData.get('supplyId'))) && String.isNotBlank(String.valueOf(allData.get('supplyId')))){
                        supplyAddMap.put(String.valueOf(allData.get('supplyId')),String.valueOf(allData.get('quantity')));
                        supplySubMap.put(String.valueOf(allData.get('supplyVirginId')),String.valueOf(allData.get('quantity')));
                    }
                }
            }
            
            //Build the View
            for(string suppliersKey : weeklySupplySummaryMap.keySet()){            
                //for(Weekly_Supply_Summary__c supplyVal : weeklySupplySummaryMap.values()){
                system.debug('suppliersKey:'+suppliersKey);
                Weekly_Supply_Summary__c  supplyVal = weeklySupplySummaryMap.get(suppliersKey);
                
                Decimal qtyAllctd;
                ViewDemandForecastObj viewDmdForecast = new ViewDemandForecastObj();
                Weekly_Supply_Summary__c  supplyAllQty = allocatedQtyMap.get(suppliersKey);
                
                if(supplyAllQty != null){ 
                    if(supplyAllQty.Quantity__c != null){
                        qtyAllctd = supplyAllQty.Quantity__c;
                    }else{
                        qtyAllctd = 0;
                    }
                }else{
                    qtyAllctd = 0;
                }
                
                //system.debug('qtyAllctd:'+qtyAllctd);
                
                //setting the demand details in the wrapper
                //viewDmdForecast.weeklySupplyId = supplyVal.Id;
                viewDmdForecast.mainettiCompany = supplyVal.Mainetti_Company__c; 
                viewDmdForecast.retailerCode = supplyVal.Retailer_Name__c;
                viewDmdForecast.model = supplyVal.Mainetti_Model_Name__c;
                viewDmdForecast.color = supplyVal.Color__c;
                viewDmdForecast.sizerPrinter = supplyVal.Sizer_Print__c;
                viewDmdForecast.source = supplyVal.Source__c;
                viewDmdForecast.warehouse = supplyVal.Warehouse__c;
                //system.debug('supplyVal.Quantit'+supplyVal.Quantity__c);
                
                if(String.isNotBlank(viewDmdForecast.mainettiCompany)&& String.isNotBlank(viewDmdForecast.retailerCode) && String.isNotBlank(viewDmdForecast.model) && String.isNotBlank(viewDmdForecast.color)){
                    if(supplyVal.Quantity__c != null){                    
                        viewDmdForecast.totalSupplyQty = supplyVal.Quantity__c; 
                    }else{
                        viewDmdForecast.totalSupplyQty = 0; 
                    }
                    
                    
                    if(qtyAllctd != null){
                        viewDmdForecast.totalAllocationQty = qtyAllctd;
                    }else{
                        viewDmdForecast.totalAllocationQty = 0;
                    }
                    
                    
                   if(source == 'Virgin'){
                        string subQty = supplySubMap.get(supplyVal.Id);
                        if(String.isNotBlank(subQty)){
                            viewDmdForecast.totalSupplyQty = supplyVal.Quantity__c + Decimal.valueOf(subQty);
                        }else{
                            viewDmdForecast.totalSupplyQty = supplyVal.Quantity__c;
                        }
                    }
                    
                    
                    viewDmdForecast.totalBalance = viewDmdForecast.totalSupplyQty - viewDmdForecast.totalAllocationQty;
                    if(viewDmdForecast.totalBalance < 0){
                        viewDmdForecast.isNegative = 'Negative';
                    }else{
                        viewDmdForecast.isNegative = 'Postive';
                    }
                    
                                        
                    /* --Start-- Check if the logged in user is allowed to allocate --Start-- */                   
                    /*if(isCurrentWeek){
                        viewDmdForecast.weeklySupplyId = supplyVal.Id;                        
                        String userName = UserInfo.getName();
                        Map<string,string> userAllocated = retailerUserAllocation.get(supplyVal.Retailer_Name__c);
                        
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
                        viewDmdForecast.weeklySupplyId = supplyVal.Id;                        
                        String userName = UserInfo.getName();
                        Map<string,string> userAllocated = companyUserAllocation.get(supplyVal.Mainetti_Company__c);
                        system.debug('userAllocated:'+userAllocated);
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
                    
                    
                    viewSupplySummaryList.add(viewDmdForecast);  
                }     
                
                
                //viewSupplySummaryList.add(viewDmdForecast);
            }
        }
        //system.debug('viewSupplySummaryListSize:'+viewSupplySummaryList.size());
        viewSupplySummaryWrap.DemandForecastListToDisplay = viewSupplySummaryList;
        //system.debug('viewSupplySummaryWrap:'+viewSupplySummaryWrap);
        return viewSupplySummaryWrap;
    }
    
    /*
     * The below method is used in the conversion of order to company to mainetti company.
     * Method returns order to company as key, mainetti company as value.
     * @author Varun.
     * */
    /*public static Map<string,Map<string,string>> orderCmpToMainettiCmp(){
        Map<string,Map<string,string>> companyMap = new Map<string,Map<string,string>>();
        List<Partner__c> companyData = [Select Name, Default_Order_to_Company__c from Partner__c where Default_Order_to_Company__c <> null];
        
        for(Partner__c data : companyData){            
            if(!companyMap.containsKey(data.Default_Order_to_Company__c)){
                Map<string,string> mainettiCmp = new Map<string,string>();
                mainettiCmp.put(data.Name, data.Name);
                companyMap.put(data.Default_Order_to_Company__c,mainettiCmp);
            }else{
                Map<string,string> mainettiCmp = companyMap.get(data.Default_Order_to_Company__c);
                mainettiCmp.put(data.Name, data.Name);
                companyMap.put(data.Default_Order_to_Company__c,mainettiCmp);
            }
            
        }
        system.debug('companyMap:'+companyMap);
        return companyMap;
    }*/
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
        system.debug('ordertocompany'+ordertocompany);
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
    
    // create a wrapper class with @AuraEnabled Properties     
    public class ViewSupplySummaryWrapper { 
        @AuraEnabled public Integer recordToDisplay {get;set;} 
        @AuraEnabled public Integer pageNumber {get;set;} 
        @AuraEnabled public Integer totalDemandForecast {get;set;} 
        @AuraEnabled public List<ViewDemandForecastObj> DemandForecastListToDisplay {get;set;} 
    } 
    
}