//*************This is an Interface for the Batch Module for the running of
// Inventory Allocation for Demand/Supply/Shipment and Archieve of data on a daily
// basis
//global class InventoryAllocationBatch implements Schedulable{
global class InventoryAllocationBatch {
   /* global void execute(SchedulableContext ctx) {
        prepareWeeklyDemandForecastForInventoryAllocation();
    }*/
    
    //Getting the list of User Ids based on their email Id
    public void prepareWeeklyDemandForecastForInventoryAllocation(){
         InventoryAllocationMaster invAllocMaster = new InventoryAllocationMaster();
         ProcessInventoryAllocation processInvAlloc = new ProcessInventoryAllocation();
        //Get the current week Number and week start date and end date
        Date startdate = date.today();
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        String currentWeek = String.valueOf(invAllocMaster.getWeekNumber(startdate));
        
        System.debug('weekStartDate::'+weekStartDate+'::weekEndDate:::'+weekEndDate);
        
         //upsert all the records of Demand for the current date week  for both Portal and MagNET
         //boolean upsertDemandStatus = processInvAlloc.upsertAllDemandSummaryFortheWeek(currentWeek,weekStartDate,weekEndDate);
         
         //upsert all the records of Supply for the current date week
        boolean upsertSupplyStatus = processInvAlloc.upsertAllSupplySummaryFortheWeek(currentWeek,weekStartDate,weekEndDate);
         
        //upsert all the records of Shipment for the current date week for both Portal and MagNET
       	 //boolean upsertShipmentStatus = processInvAlloc.upsertAllShipmentSummaryFortheWeek(currentWeek,weekStartDate,weekEndDate);
        
         //Archieve the data of Sales from the Inventory Data Upload Object
    }
}