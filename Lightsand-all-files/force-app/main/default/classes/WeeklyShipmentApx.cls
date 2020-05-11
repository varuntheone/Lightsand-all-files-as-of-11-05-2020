public class WeeklyShipmentApx {
    @AuraEnabled(cacheable=true) 
    public static WeeklyShipmentWrapper fetchWeeklyShipmentBySearch(String mainettiCompany,String retailerCode,String model,String weekStart,String weekEnd,boolean isCurrentWeek,Integer pageNumber ,Integer recordToDisplay,Integer totalShipmentQty) {
        //system.debug('model:'+model);
        //system.debug('pageNumber:'+pageNumber);
        //system.debug('recordToDisplay:'+recordToDisplay);
        Date weekStartDate;
        Date weekEndDate;
        if(String.isNotBlank(weekStart)){
            weekStartDate = Date.valueOf(weekStart);
        }
        if(String.isNotBlank(weekEnd)){
            weekEndDate = Date.valueOf(weekEnd);
        }   
        InventoryAllocationMaster invAllocMaster = new InventoryAllocationMaster();

        Map<string,Weekly_Shipment_Summary__c> weeklyShipmentMap = invAllocMaster.fetchWeeklyShipmentSummaryDisplay( mainettiCompany, retailerCode, model,weekStartDate,weekEndDate,isCurrentWeek,pageNumber,recordToDisplay);
        WeeklyShipmentWrapper viewWeeklyShipmentWrap = new WeeklyShipmentWrapper();
        List<WeeklyShipmentObj> viewWeeklyShipmentList = new List<WeeklyShipmentObj>();
        //system.debug('weeklyShipmentMap:'+weeklyShipmentMap);
        if(weeklyShipmentMap != null){            
            
            viewWeeklyShipmentWrap.recordToDisplay = recordToDisplay;
            viewWeeklyShipmentWrap.pageNumber = pageNumber;
            
            if(pageNumber == 1){
                //Getting the total Record count of the search result
                if(weeklyShipmentMap.containsKey('TotalCount')){
                    Weekly_Shipment_Summary__c recCountList =  weeklyShipmentMap.get('TotalCount');                     
                    String totalRecordCount =   recCountList.Week_Number__c; 
                    //System.debug('totalRecordCount:::::recCountList.Week_Number__c:::::'+recCountList);
                    viewWeeklyShipmentWrap.totalWeeklyShipment = Integer.valueOf(totalRecordCount);                      
                }
            }
            
            //Build the View   
           //system.debug('weeklyShipmentMapSize:'+weeklyShipmentMap.size());
                      		
            for(String shipmentKey : weeklyShipmentMap.keyset()){
            //for(Weekly_Shipment_Summary__c shipmentVal : weeklyShipmentMap.values()){
                Weekly_Shipment_Summary__c shipmentVal = weeklyShipmentMap.get(shipmentKey);
                //system.debug('shipmentKey:'+weeklyShipmentMap.values());

                WeeklyShipmentObj viewWeeklyShipment = new WeeklyShipmentObj();
                
                //setting the Shipment details in the wrapper
               
                viewWeeklyShipment.mainettiCompany = shipmentVal.Mainetti_Company__c; 
                viewWeeklyShipment.retailerCode =shipmentVal.Retailer_Name__c;
                viewWeeklyShipment.model=shipmentVal.Mainetti_Model_Name__c;
                viewWeeklyShipment.color=shipmentVal.Color__c;
                viewWeeklyShipment.sizerPrinter=shipmentVal.Sizer_Print__c;
                viewWeeklyShipment.totalShipmentQty=shipmentVal.Quantity__c;
                viewWeeklyShipment.totalBalance = viewWeeklyShipment.totalShipmentQty;
                viewWeeklyShipmentList.add(viewWeeklyShipment);
            }
        }
        
        viewWeeklyShipmentWrap.WeeklyShipmentListToDisplay = viewWeeklyShipmentList;
        //system.debug('viewWeeklyShipmentWrap:'+viewWeeklyShipmentWrap);
        return viewWeeklyShipmentWrap;
    }
    
    // create a wrapper class with @AuraEnabled Properties     
    public class WeeklyShipmentWrapper { 
        @AuraEnabled public Integer recordToDisplay {get;set;} 
        @AuraEnabled public Integer pageNumber {get;set;} 
        @AuraEnabled public Integer totalWeeklyShipment {get;set;} 
        @AuraEnabled public List<WeeklyShipmentObj> WeeklyShipmentListToDisplay {get;set;} 
    } 

}