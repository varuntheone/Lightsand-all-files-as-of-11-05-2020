public class summaryapex {
    @AuraEnabled
    public static ViewSupplySummaryWrapper  fetchSupplySummaryBySearch(String orderToCompany,String retailerCode,String modelName,String weekStart,String weekEnd,boolean isCurrentWeek) {
        system.debug('### Inside fetchSupplySummaryBySearch ###');
        system.debug('orderToCompanyFisrt:'+orderToCompany);
        Date weekStartDate;
        Date weekEndDate;
        if(String.isNotBlank(weekStart)){
            weekStartDate = Date.valueOf(weekStart);
        }
        if(String.isNotBlank(weekEnd)){
            weekStartDate = Date.valueOf(weekStart);
        }
        InventoryAllocationMaster invAllocMaster = new InventoryAllocationMaster();
        
        Map<string,Weekly_Supply_Summary__c> weeklySupplySummaryMap = invAllocMaster.fetchWeeklySupplySummary( orderToCompany, retailerCode, modelName, weekStartDate, weekEndDate,isCurrentWeek);
        ViewSupplySummaryWrapper viewSupplySummaryWrap = new ViewSupplySummaryWrapper();
        List<ViewDemandForecastObj> viewSupplySummaryList = new List<ViewDemandForecastObj>();
        //system.debug('weeklySupplySummaryMapSize:'+weeklySupplySummaryMap.size());
        
        
        /*list<AggregateResult> allocatedQuantity = [Select Inventory_Allocation_Supply__c, sum(Quantity__c) allocatedQtys from Inventory_Allocation__c GROUP BY Inventory_Allocation_Supply__c]; 
for ( AggregateResult allctQty : allocatedQuantity ){
allocatedQtyMap.put((String)allctQty.get('Inventory_Allocation_Supply__c'),(Decimal)allctQty.get('allocatedQtys'));
}*/
        
        /* Put retailer as key and allocated user as value to check for the logged in user has permission has allowed to allocate --Start-- */
        Map<string,Map<string,string>> retailerUserAllocation = new Map<string,Map<string,string>>();
        List<Reuse_center_Inventory_Manager__c> userData = [Select Retailer_Name__c, User_Name__c from Reuse_center_Inventory_Manager__c];
        
        for(Reuse_center_Inventory_Manager__c data : userData){            
            if(!retailerUserAllocation.containsKey(data.Retailer_Name__c)){  
                Map<string,string> userMap = new Map<string,string>();
                userMap.put(data.User_Name__c,data.User_Name__c);
                retailerUserAllocation.put(data.Retailer_Name__c,userMap);
            }else{
                Map<string,string> userMap = retailerUserAllocation.get(data.Retailer_Name__c);
                userMap.put(data.User_Name__c,data.User_Name__c);
                retailerUserAllocation.put(data.Retailer_Name__c,userMap);
            }
        }        
        /* Put retailer as key and allocated user as value to check for the logged in user has permission has allowed to allocate --End-- */
        
        if(weeklySupplySummaryMap != null){ 
            Map<string,Weekly_Supply_Summary__c> allocatedQtyMap;
            if(isCurrentWeek){
                Map<ID,ID> supplierIdsMap = new Map<ID,ID>();
                
                for(Weekly_Supply_Summary__c supplyVal : weeklySupplySummaryMap.values()){
                    if(String.isNotBlank(supplyVal.Id)){
                        supplierIdsMap.put(supplyVal.Id,supplyVal.Id);
                    }
                    
                }
                SET<ID> supplierKeys = supplierIdsMap.keyset();
                allocatedQtyMap = invAllocMaster.fetchInventoryAllocationForSupplierIds(supplierKeys);
            }else{
                allocatedQtyMap = invAllocMaster.getWeeklySupplyInventoryAllocationSummary(orderToCompany,retailerCode,modelName,weekStartDate,weekEndDate,isCurrentWeek);
            }
            
            
            //Build the View
            for(string suppliersKey : weeklySupplySummaryMap.keySet()){            
                //for(Weekly_Supply_Summary__c supplyVal : weeklySupplySummaryMap.values()){
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
                    
                    viewDmdForecast.totalBalance = viewDmdForecast.totalSupplyQty - viewDmdForecast.totalAllocationQty;
                    if(viewDmdForecast.totalBalance < 0){
                        viewDmdForecast.isNegative = 'Negative';
                    }else{
                        viewDmdForecast.isNegative = 'Postive';
                    }
                    
                    
                    /* --Start-- Check if the logged in user is allowed to allocate --Start-- */                   
                    if(isCurrentWeek){
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
                    }
                    /* --End-- Check if the logged in user is allowed to allocate --End-- */
                    
                    viewSupplySummaryList.add(viewDmdForecast);  
                }     
                
                
                //viewSupplySummaryList.add(viewDmdForecast);
            }
        }
        
        viewSupplySummaryWrap.DemandForecastListToDisplay = viewSupplySummaryList;
        system.debug('viewSupplySummaryWrap:'+viewSupplySummaryWrap);
        return viewSupplySummaryWrap;
    }
    
    // create a wrapper class with @AuraEnabled Properties     
    public class ViewSupplySummaryWrapper { 
        @AuraEnabled public Integer recordToDisplay {get;set;} 
        @AuraEnabled public Integer pageNumber {get;set;} 
        @AuraEnabled public Integer totalDemandForecast {get;set;} 
        @AuraEnabled public List<ViewDemandForecastObj> DemandForecastListToDisplay {get;set;} 
    } 
    
}