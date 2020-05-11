global class ShipmentSummaryForTheWeekIterable implements    Iterable<SObject>,Iterator<SObject>{
    public Iterator<SObject> iterator() { return this; }    
    
    List<SObject> sobjs {get; set;} 
    Integer i {get; set;} 
    
    public ShipmentSummaryForTheWeekIterable(){ 
        System.debug('Start ShipmentSummaryForTheWeekIterable');
        Date startdate = date.today();
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
         
        sobjs = new List<SObject>();
        /*
        SET<ID> onlineKeys = onLineEnquiry.keyset();
        
        MAP<String,String> externalId = new MAP<String,String>();
        
        List<Weekly_Demand_Consolidated_Order_Id__c> consolidateIds = [SELECT External_Id__c,Online_Enquiry__c,Week_End_Date__c FROM  Weekly_Demand_Consolidated_Order_Id__c	WHERE Online_Enquiry__c IN:onlineKeys]; 
       for( Weekly_Demand_Consolidated_Order_Id__c consId : consolidateIds ) {
           consId.Week_End_Date__c = weekEndDate;
           sobjs.add(consId);
           externalId.put(consId.External_Id__c,consId.Online_Enquiry__c);            
       }       
         integer externalIdSize = sobjs.size();
		 System.debug('##### ShipmentSummaryForTheWeekIterable:::Weekly_Demand_Consolidated_Order_Id__c: External_Id__c: :::SIZE'+externalIdSize);           
        SET<String> externalIdKeys = externalId.keyset();  
		                 
       List<Weekly_Demand_Summary__c> weeklyShipmentSummaryResult = [Select Id,External_Id__c,Mainetti_Model__r.Name, Order_to_Company__c, Retailer_Code__r.Name ,Mainetti_Model__c,Color__c ,Sizer_Print__c  FROM  Weekly_Demand_Summary__c	WHERE External_Id__c IN:externalIdKeys]; 
       for( Weekly_Demand_Summary__c demandSum : weeklyShipmentSummaryResult ) {
           sobjs.add(demandSum);
           
       }
       integer demandSummarySize = (sobjs.size()-externalIdSize);
       System.debug('##### ShipmentSummaryForTheWeekIterable:::: Weekly_Demand_Summary__c: :::SIZE'+demandSummarySize);
        
        Map<string,Weekly_Demand_Summary__c> weeklyDemandSummaryMap = fetchWeeklyDemandSummaryForTheWeekShipmentPortal(weeklyShipmentSummaryResult,externalId);
        
        MAP<ID,ID>  weeklyDemandSummaryIdMap = new MAP<ID,ID>();
        for(string shipmentKey : weeklyDemandSummaryMap.keySet()){
            Weekly_Demand_Summary__c  weeklyDemandSummary = weeklyDemandSummaryMap.get(shipmentKey); 
            weeklyDemandSummaryIdMap.put(weeklyDemandSummary.Id, weeklyDemandSummary.Id);
        }
        SET<ID> weeklyDemandSummaryIds = weeklyDemandSummaryIdMap.keyset(); 
        
        List<Weekly_Shipment_Summary__c> weeklyShipmentSummaryIds = [Select Weekly_Demand_Summary__c,Quantity__c,Week_Number__c FROM Weekly_Shipment_Summary__c  WHERE  Weekly_Demand_Summary__c IN:weeklyDemandSummaryIds];
        
        for (Weekly_Shipment_Summary__c weeklyShipment : weeklyShipmentSummaryIds){
			weeklyShipment.Week_Number__c = '0';
           sobjs.add(weeklyShipment);           
       }
      integer weeklyShipmentSize = (sobjs.size() - demandSummarySize );
                                                        
        System.debug('##### ShipmentSummaryForTheWeekIterable:::: Weekly_Shipment_Summary__c::::SIZE'+weeklyShipmentSize);
         
        
       MAP<ID,ID> salesOrderNumber = new MAP<ID,ID>();
        System.debug('ShipmentSummaryForTheWeekIterable:::salesOrderList size:::'+salesOrderItemList.size()); 
        for (AggregateResult salesOrderItemNo : salesOrderItemList){
            salesOrderNumber.put(String.valueOf(salesOrderItemNo.get('salesItemNo')) ,String.valueOf(salesOrderItemNo.get('salesItemNo')));
        }            
             
        SET<ID> salesOrderItemIds = salesOrderNumber.keySet();
              
       List<Weekly_Demand_Consolidated_Order_Id__c> salesOrdNumDemandListResult = [Select Weekly_Demand_Summary__c,Sales_Order_Item__c,Week_End_Date__c  FROM  Weekly_Demand_Consolidated_Order_Id__c WHERE Sales_Order_Item__c  IN:salesOrderItemIds]; 
       for( Weekly_Demand_Consolidated_Order_Id__c consId : salesOrdNumDemandListResult ) {
           consId.Week_End_Date__c = Null;
           sobjs.add(consId);
       }
       integer consIdSize = (sobjs.size() - (demandSummarySize+weeklyShipmentSize) );
       System.debug('##### ShipmentSummaryForTheWeekIterable:::: Weekly_Demand_Consolidated_Order_Id__c: :::SIZE'+consIdSize);
                             
       MAP<ID,ID> salesOrderItemNumDemandIds = fetchSalesOrderItemNumbersForShipmentDoneInTheWeek(salesOrdNumDemandListResult);                                                
       
       SET<ID> weeklyDemandIds = new SET<ID>();
        for(ID demandIds : salesOrderItemNumDemandIds.keySet()){             
            weeklyDemandIds.add(demandIds); 
        }         
                             
		List<Weekly_Shipment_Summary__c> weeklyShipmentSummaryWDIds = [Select Id, Mainetti_Company__c , Retailer_Code__r.Name ,Mainetti_Model__c,Mainetti_Model__r.Name,Color__c ,Sizer_Print__c ,Quantity__c,Weekly_Demand_Summary__c,Week_Number__c FROM Weekly_Shipment_Summary__c  WHERE  Weekly_Demand_Summary__c IN:weeklyDemandIds];
        for (Weekly_Shipment_Summary__c weeklyShipment : weeklyShipmentSummaryWDIds){  
            weeklyShipment.Week_Number__c = '1';
            sobjs.add(weeklyShipment);
        }
       integer magNetSize = (sobjs.size() -  (demandSummarySize+weeklyShipmentSize+consIdSize) );
       System.debug('##### ShipmentSummaryForTheWeekIterable:::: Weekly_Shipment_Summary__c MAGNET: :::SIZE'+magNetSize);
*/
                   
       List<Partner__c> partner = [Select  Name, Default_Order_to_Company__c from Partner__c where Default_Order_to_Company__c != null and Partner_Status__c = 'Active' and  RecordType.Name in('Mainetti Company','Licensee Partner')]; 
       for( Partner__c part : partner ) {
           sobjs.add(part);
       }
        integer partnerSize = (sobjs.size());
        System.debug('##### ShipmentSummaryForTheWeekIterable:::: Partner::::SIZE'+partnerSize);
       i = 0;   
      
        System.debug('End ShipmentSummaryForTheWeekIterable::: OverAll:SIZE'+sobjs.size());
       
    }   
    global boolean hasNext(){         
        if(i >= sobjs.size()) 
            return false; 
        else 
            return true; 
    }    
    global SObject next(){ 
        //if(i == 8){ i++; return null;} 
        i=i+1; 
        return sobjs[i-1]; 
    }   
   
}