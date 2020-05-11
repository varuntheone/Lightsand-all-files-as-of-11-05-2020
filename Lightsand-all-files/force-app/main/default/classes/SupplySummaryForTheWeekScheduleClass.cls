global class SupplySummaryForTheWeekScheduleClass implements Schedulable{ 
    @ReadOnly 
    global void execute (SchedulableContext ctx){ 
		Date startdate = date.today();
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
		List<AggregateResult> stockVirginList = new List<AggregateResult>();
        
        String getQueryString = 'SELECT Mainetti_Company__r.Name OrderToCompany,Retailer_Code__c RetailerCode,Retailer_Code__r.Name RetailerName,Inventory_Model__c Model,Inventory_Model__r.Name ModelName,Color__c Color,Sizer_Print__c Printer, SUM(Stock_In_Qty__c) Quantity,Warehouse__c Warehouse FROM  Data_Upload_Transaction__c WHERE Record_Type__c=\'Inventory\' AND  Source__c=\'Virgin\'AND Mainetti_Company__r.Name <> NULL  GROUP BY Mainetti_Company__r.Name,Retailer_Code__c,Retailer_Code__r.Name,Inventory_Model__c,Inventory_Model__r.Name,Color__c ,Sizer_Print__c,Warehouse__c';
        for(AggregateResult[]  stockVirginListResult : Database.Query(getQueryString)) {
            stockVirginList.addAll(stockVirginListResult);
        }
        
        List<AggregateResult> stockReuseList = new List<AggregateResult>();
        
        String getQueryStringReuse = 'SELECT Mainetti_Company__r.Name OrderToCompany,Retailer_Code__c RetailerCode,Retailer_Code__r.Name RetailerName,Inventory_Model__c Model,Inventory_Model__r.Name ModelName,Color__c Color,Sizer_Print__c Printer, SUM(Stock_In_Qty__c) Quantity,Warehouse__c Warehouse FROM  Data_Upload_Transaction__c WHERE Record_Type__c=\'Inventory\' AND  Source__c=\'Reuse\' AND Mainetti_Company__r.Name <> NULL  GROUP BY Mainetti_Company__r.Name,Retailer_Code__c,Retailer_Code__r.Name,Inventory_Model__c,Inventory_Model__r.Name,Color__c,Sizer_Print__c,Warehouse__c';
        for( AggregateResult[]  stockReuseListResult : Database.Query(getQueryStringReuse)) {
            stockReuseList.addAll(stockReuseListResult);
        }
        System.debug('stockVirginList SIZE:::'+stockVirginList.size()+'::::stockReuseList SIZE:::'+stockReuseList.size());
        SupplySummaryForTheWeekbatchClass supply = new SupplySummaryForTheWeekbatchClass(stockVirginList,stockReuseList); 
        Database.executeBatch(supply); 
    } 
}