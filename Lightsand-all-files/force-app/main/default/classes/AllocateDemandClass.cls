public class AllocateDemandClass {
    @AuraEnabled
    public static ViewSupplySummaryWrapper getDataFromDemand(String demandId){
        String retailerCode, mainettiModel, color, sizerPrinter,supplyId,warehouseForSave;
        Date weekStartDate, weekEndDate;
        Decimal supplyQty, remainingQty;
        
        ViewSupplySummaryWrapper viewSupplySummaryWrap = new ViewSupplySummaryWrapper();
        List<ViewDemandForecastObj> viewSupplySummaryList = new List<ViewDemandForecastObj>();
        
        List<Weekly_Demand_Summary__c> demandData = [Select Retailer_Code__r.Name, Mainetti_Model__r.Name, Color__c, Sizer_Print__c, Week_Start_Date__c, Week_End_Date__c
                                                    from Weekly_Demand_Summary__c where Id =:demandId];
        for(Weekly_Demand_Summary__c demand: demandData){
            retailerCode = demand.Retailer_Code__r.Name;
            mainettiModel = demand.Mainetti_Model__r.Name;
            color = demand.Color__c;
            weekStartDate = demand.Week_Start_Date__c;
            weekEndDate = demand.Week_End_Date__c;
        }
        List<Weekly_Supply_Summary__c> supplyData = [Select Id, Retailer_Code__r.Name, Mainetti_Model__r.Name, Color__c, Sizer_Print__c, Quantity__c,Warehouse__c from Weekly_Supply_Summary__c
                                                     where Retailer_Code__r.Name =:retailerCode and Mainetti_Model__r.Name =:mainettiModel and Color__c =:color
                                                     and Week_Start_Date__c >=:weekStartDate and Week_End_Date__c <=:weekEndDate and Source__c ='Reuse'
                                                    ];
        system.debug('supplyData:'+supplyData);
        for(Weekly_Supply_Summary__c supply: supplyData){
            supplyId = supply.Id;
            supplyQty = supply.Quantity__c;
            warehouseForSave = supply.Warehouse__c;
        }
        
        List<AggregateResult> fetchTotalAllocatedQty = [Select sum(Quantity__c) Quantity from Inventory_Allocation__c 
                                                        where Inventory_Allocation_Supply__c =: supplyId];
        for(AggregateResult allQty : fetchTotalAllocatedQty){            
            String allocatdQty = String.valueOf(allQty.get('Quantity'));
            if(String.isNotBlank(allocatdQty) && supplyQty != null){
                remainingQty = supplyQty - Decimal.valueOf(allocatdQty);
            }else{
                remainingQty = supplyQty;
            }
        }
        
        //Build the View 
        ViewDemandForecastObj viewDmdForecast = new ViewDemandForecastObj();
        
        viewDmdForecast.retailerCode = retailerCode;
        viewDmdForecast.model = mainettiModel;
        viewDmdForecast.color = color;
        viewDmdForecast.sizerPrinter = sizerPrinter;
        viewDmdForecast.weeklySupplyId = supplyId;
        viewDmdForecast.totalBalance = remainingQty;
        viewDmdForecast.warehouse = warehouseForSave;
        
        viewSupplySummaryList.add(viewDmdForecast);
        viewSupplySummaryWrap.DemandForecastListToDisplay = viewSupplySummaryList;
        return viewSupplySummaryWrap;
    }
    
    @AuraEnabled
    public static ViewSupplySummaryWrapper getDataFromSupply(String supplyId){
        
        String retailerCode, mainettiModel, color, sizerPrinter, demandId;
        Date weekStartDate, weekEndDate;
        Decimal supplyQty, remainingQty;
        
        Date startdate = date.today();
        Date todaydateinstance = date.newinstance(startdate.year(),startdate.month(), startdate.day());
        
        Date weekStart = todaydateinstance.toStartOfWeek();
        Date weekEnd = todaydateinstance.adddays(7).tostartofweek();
        //system.debug('weekStart:'+weekStart);
        //system.debug('weekEnd:'+weekEnd);
        
        ViewSupplySummaryWrapper viewSupplySummaryWrap = new ViewSupplySummaryWrapper();
        List<ViewDemandForecastObj> viewSupplySummaryList = new List<ViewDemandForecastObj>();
        
        List<Weekly_Supply_Summary__c> supplyData = [Select Retailer_Code__r.Name, Mainetti_Model__r.Name, Color__c, Sizer_Print__c, Quantity__c, Week_Start_Date__c, Week_End_Date__c
                                                    from Weekly_Supply_Summary__c where Id =:supplyId and Week_Start_Date__c =:weekStart and Week_End_Date__c =:weekEnd];
        for(Weekly_Supply_Summary__c sup: supplyData){
            retailerCode = sup.Retailer_Code__r.Name;
            mainettiModel = sup.Mainetti_Model__r.Name;
            color = sup.Color__c;
            sizerPrinter = sup.Sizer_Print__c;
            supplyQty = sup.Quantity__c;
            weekStartDate = sup.Week_Start_Date__c;
            weekEndDate = sup.Week_End_Date__c;
        }
        
        List<Weekly_Demand_Summary__c> demandData = [Select Id, Retailer_Code__r.Name, Mainetti_Model__r.Name, Color__c, Sizer_Print__c, Quantity__c from Weekly_Demand_Summary__c
                                                     where Retailer_Code__r.Name =:retailerCode and Mainetti_Model__r.Name =:mainettiModel and Color__c =:color
                                                     and Week_Start_Date__c >=:weekStartDate and Week_End_Date__c <=:weekEndDate
                                                    ];
        system.debug('demandData:'+demandData);
        for(Weekly_Demand_Summary__c demand : demandData){            
            demandId = demand.Id;
        }
        
        List<AggregateResult> fetchTotalAllocatedQty = [Select sum(Quantity__c) Quantity from Inventory_Allocation__c 
                                                        where Inventory_Allocation_Supply__c =: supplyId];        
        for(AggregateResult allQty : fetchTotalAllocatedQty){            
            String allocatdQty = String.valueOf(allQty.get('Quantity'));
            system.debug('allocatdQty:'+allocatdQty);
            if(String.isNotBlank(allocatdQty) && supplyQty != null){
                remainingQty = supplyQty - Decimal.valueOf(allocatdQty);
            }else{
                remainingQty = supplyQty;
            }
        }
            
        
        
        //Build the View 
        ViewDemandForecastObj viewDmdForecast = new ViewDemandForecastObj();
        
        viewDmdForecast.retailerCode = retailerCode;
        viewDmdForecast.model = mainettiModel;
        viewDmdForecast.color = color;
        viewDmdForecast.sizerPrinter = sizerPrinter;
        viewDmdForecast.weeklyDemandId = demandId;
        viewDmdForecast.totalBalance = remainingQty;
        
        viewSupplySummaryList.add(viewDmdForecast);
        viewSupplySummaryWrap.DemandForecastListToDisplay = viewSupplySummaryList;
        return viewSupplySummaryWrap;
    }
    
    @AuraEnabled
    public static boolean saveAllocation(Integer quantity, String supplyId, String demandId, String allocataionType, String warehouseSupplyId, String warehouseForSave){
        system.debug('quantity:'+quantity);
        system.debug('supplyId:'+supplyId);
        system.debug('demandId:'+demandId);
        system.debug('warehouseSupplyId:'+warehouseSupplyId);
        system.debug('allocataionType:'+allocataionType);
        system.debug('warehouseForSave:'+warehouseForSave);
        
        
        if(String.isNotBlank(warehouseForSave))
            warehouseEmailGroup(warehouseForSave);// This method dynamically generates users for an public group.
        
        boolean saveStatus = false;
        
        Date startdate = date.today();
        Date todaydateinstance = date.newinstance(startdate.year(),startdate.month(), startdate.day());
        
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        //String currentWeek = String.valueOf(getWeekNumber(startdate));
        
        Inventory_Allocation__c insertData = new Inventory_Allocation__c();
        insertData.Quantity__c = quantity;
        insertData.Week_Start_Date__c = weekStartDate;
        insertData.Week_End_Date__c = weekEndDate;
        insertData.Inventory_Allocation_Type__c = allocataionType;
        insertData.Inventory_Allocation_Supply__c = supplyId;
        insertData.Ready_to_send_email__c = true;
        
        if(allocataionType == 'Demand'){
            insertData.Inventory_Allocation_Demand__c = demandId;
        }else{
            insertData.Inventory_Allocation_Supply_Virgin__c = warehouseSupplyId;
        }        
        
        try{
            insert insertData;
            saveStatus = true;
        }catch(DMLException e){   
            //saveStatus = false;
            system.debug('Error in insertDataUploadTransaction: during DataUploadTransaction'+e.getMessage());
        }
        
        return saveStatus;
    }
    
    //This method returns the start of the week number for a given date ie for a month
    public static Integer getWeekNumber(Date startdate){
        
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
        Integer currentyear = startdate.year();
        
        Date yearstartdate = date.newinstance(currentyear, 01, 01);
        Date year2ndweek = yearstartdate.adddays(7).tostartofweek();
        
        if(startdate<year2ndweek)
            return 1;
        integer numberDaysDue = year2ndweek.daysBetween(todaydateinstance);
        
        Integer numberOfWeek;
        if(math.mod(numberDaysDue,7)==0)
            numberOfWeek = math.MOD(Integer.valueof(math.FLOOR( ( numberDaysDue )/7)),52)+1;
        else
            numberOfWeek = math.MOD(Integer.valueof(math.FLOOR( ( numberDaysDue )/7)),52)+2;
        if(numberOfWeek==53)
            numberOfWeek=1;
        //system.debug('numberOfWeek'+numberOfWeek);
        return numberOfWeek;
        
    }
    
    /*@AuraEnabled
    public static boolean userPermission(String retailer){
        boolean status = false;
        String userName = UserInfo.getName();        
        List<Reuse_center_Inventory_Manager__c> userData = [Select Id from Reuse_center_Inventory_Manager__c where 
                                                            Retailer_Name__c =:retailer and User_Name__c =:userName];
        if(userData.size() > 0){
            status = true;
        }
        //system.debug('status:'+status);
        return status;
    }*/
    
    @AuraEnabled
    public static AggregateResult[] listWarehouse(String retailer,String model,String color,String sizerPrint,String warehouse){
        system.debug('retailer:'+retailer);
        system.debug('model:'+model);
        system.debug('color:'+color);
        system.debug('sizerPrint:'+sizerPrint);
        
        Date startdate = date.today();
        Date todaydateinstance = date.newinstance(startdate.year(),startdate.month(), startdate.day());
        
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        AggregateResult[] wareHouseList = [Select Id,Warehouse__c warehouse,Retailer_Code__r.Name retailer,Mainetti_Model__r.Name model,Color__c color,Sizer_Print__c print from Weekly_Supply_Summary__c where Warehouse__c !=:warehouse and
                                           Retailer_Code__r.Name =:retailer and Mainetti_Model__r.Name =:model and
                                           Color__c =:color and Sizer_Print__c =:sizerPrint and Source__c='Virgin' and
                                           Week_Start_Date__c =:weekStartDate and Week_End_Date__c =:weekEndDate
                                           group by Id,Warehouse__c,Retailer_Code__r.Name,Mainetti_Model__r.Name,Color__c,Sizer_Print__c];
        
        system.debug('wareHouseList:'+wareHouseList);
        //List<Weekly_Supply_Summary__c>
        return wareHouseList;
    }
    
    /*
     * The below method is used to dynamically add users to a public group assigned for an warehouse(manager).
     * The group will be used to send email for allocations.
     * @author Varun.
     * 
     * */
    @future
    public static void warehouseEmailGroup(String warehouse){
        system.debug('*****Inside warehouseEmailGroup*****');
        system.debug('warehouse:'+warehouse);
        List<Reuse_center_Inventory_Manager__c> userListForWarehouse = [select User_Name__c from Reuse_center_Inventory_Manager__c where Warehouse_Name__c =:warehouse];
        system.debug('userListForWarehouse:'+userListForWarehouse);
        Set<String> userNameSet = new Set<String>();
        
        for (Reuse_center_Inventory_Manager__c userList : userListForWarehouse){
            userNameSet.add(userList.User_Name__c);
        }
        system.debug('userNameSet:'+userNameSet);
        
        List<User> userListForGroup = [select Id from user where Name IN:userNameSet];
        system.debug('userListForGroup:'+userListForGroup);
        
        Group publicGroup  = [SELECT Id FROM Group WHERE Name = 'Warehouse Assigned Managers Team'];
        system.debug('publicGroup:'+publicGroup);
        
        list<groupMember> newGroupList = new list<groupMember>();
        list<groupMember> existingMemGroupList = [SELECT UserOrGroupId FROM GroupMember WHERE GroupId =:publicGroup.Id];
        
        if(existingMemGroupList.size() > 0){
            delete existingMemGroupList;
        }
        
        for(User us : userListForGroup){
            groupMember gp = new groupMember(groupId = publicGroup.Id);
            gp.UserOrGroupId = us.Id;
            newGroupList.add(gp);
        }
        System.debug('newGroupList .size()'+newGroupList.size());
        
        if(newGroupList.size() > 0){
              insert newGroupList;
         }
    }
    
    // create a wrapper class with @AuraEnabled Properties     
    public class ViewSupplySummaryWrapper { 
        //@AuraEnabled public Integer recordToDisplay {get;set;} 
        //@AuraEnabled public Integer pageNumber {get;set;} 
        //@AuraEnabled public Integer totalDemandForecast {get;set;} 
        @AuraEnabled public List<ViewDemandForecastObj> DemandForecastListToDisplay {get;set;} 
    } 

}