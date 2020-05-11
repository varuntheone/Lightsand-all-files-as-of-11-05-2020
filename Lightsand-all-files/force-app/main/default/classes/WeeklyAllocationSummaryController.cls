public class WeeklyAllocationSummaryController {
    @AuraEnabled 
    public static WeeklyAllocationWrapper  fetchWeeklyAllocationBySearch(String mainettiCompany,String retailerCode,String modelName,String weekStart,String weekEnd,Integer pageNumber,Boolean isCurrentWeek,Integer recordToDisplay,String allocationType) {
        
        Date weekStartDate;
        Date weekEndDate;
        if(String.isNotBlank(weekStart)){
            weekStartDate = Date.valueOf(weekStart);
        }
        if(String.isNotBlank(weekEnd)){
            weekEndDate = Date.valueOf(weekEnd);
        }
        InventoryAllocationMaster invAllocMaster = new InventoryAllocationMaster();
        Map<string,Inventory_Allocation__c> weeklyDemandMap = new Map<string,Inventory_Allocation__c>(); 
        
        if(allocationType == 'Demand'){
            system.debug('Demand');
            weeklyDemandMap = invAllocMaster.getWeeklyAllocationForDemandForDisplay(mainettiCompany,retailerCode,modelName,weekStartDate,weekEndDate,isCurrentWeek,pageNumber,recordToDisplay,allocationType); 
        }
        else{
            system.debug('Supply');
            weeklyDemandMap = invAllocMaster.getWeeklyAllocationForSupplyForDisplay(mainettiCompany,retailerCode,modelName,weekStartDate,weekEndDate,isCurrentWeek,pageNumber,recordToDisplay,allocationType);
        }
        system.debug('weeklyDemandMapSize:'+weeklyDemandMap.size());
        WeeklyAllocationWrapper viewWeeklyAllocationtWrap = new WeeklyAllocationWrapper();
        List<Inventory_Allocation__c> WeeklyAllocationSummaryList = new List<Inventory_Allocation__c>();
        system.debug('weeklyDemandMap:'+weeklyDemandMap);
        
        //Page Next
        if(weeklyDemandMap != null){ 
            
            viewWeeklyAllocationtWrap.recordToDisplay = recordToDisplay;
            viewWeeklyAllocationtWrap.pageNumber = pageNumber;
            
            if(pageNumber == 1){
                //Getting the total Record count of the search result
                if(weeklyDemandMap.containsKey('TotalCount')){
                    Inventory_Allocation__c recCountList =  weeklyDemandMap.get('TotalCount');                     
                    String totalRecordCount =   recCountList.Week_Number__c; 
                    System.debug('totalRecordCount:::::recCountList.Week_Number__c:::::'+recCountList);
                    viewWeeklyAllocationtWrap.totalWeeklyAllocation = Integer.valueOf(totalRecordCount);
                    System.debug('totalRecordCount:'+viewWeeklyAllocationtWrap.totalWeeklyAllocation);                    
                }
            }
            
            //Build the View             		
            for(String demandKey : weeklyDemandMap.keyset()){
                Inventory_Allocation__c weekdemsum = weeklyDemandMap.get(demandKey);
                system.debug('weekdemsum:'+weekdemsum);
                
                
                WeeklyAllocationSummaryList.add(weekdemsum);
                
            }		
        }
        WeeklyAllocationSummaryList.remove(0);
        system.debug('WeeklyAllocationSummaryListSize:'+WeeklyAllocationSummaryList.size());
        viewWeeklyAllocationtWrap.WeeklyAllocationSummaryList = WeeklyAllocationSummaryList;
        return viewWeeklyAllocationtWrap;
    }
    @AuraEnabled	
    public static boolean DeleteRecords(String selId){
        boolean DeleteStatus=true;
        List<Inventory_Allocation__c> deleterecord =[select id from Inventory_Allocation__c where id=:selId];
        try{
            delete deleterecord;
        }
        catch(DMLException ex)
        {
            DeleteStatus=false;
        }
        return DeleteStatus ;
    }
    
    @AuraEnabled
    public static boolean updateAlocation(List<Inventory_Allocation__c> allocRecord ){
        boolean updateStatus=false;
        try{
            update allocRecord;
            updateStatus=true;
        }
        catch(DMLEXCEPTION ex){
        }
        return updateStatus;
    }
    @AuraEnabled
    public static boolean deleteAlocation(List<Inventory_Allocation__c> deltRecord ){
        boolean deleteStatus=false;
        try{
            update deltRecord;
            deleteStatus=true;
        }
        catch(DMLEXCEPTION ex){
            System.debug('If delete Fails:'+ex.getMessage());
        }
        return deleteStatus;
    }
    
    
    // create a wrapper class with @AuraEnabled Properties     
    public class WeeklyAllocationWrapper { 
        @AuraEnabled public Integer recordToDisplay {get;set;} 
        @AuraEnabled public Integer pageNumber {get;set;} 
        @AuraEnabled public Integer totalWeeklyAllocation {get;set;} 
        @AuraEnabled public List<Inventory_Allocation__c>WeeklyAllocationSummaryList {get;set;} 
        
    } 
    
}