public class InventryApex {
    @auraEnabled
    public static List<Weekly_Demand_Summary__c> getOrdertoCompany()
    {
      List<Weekly_Demand_Summary__c>Ws= [Select Order_to_Company__c,Mainetti_Model__r.Name,Retailer_Code__r.Name,Color__c,Sizer_Print__c ,Week_Start_Date__c,Week_End_Date__c from Weekly_Demand_Summary__c where id='a25p0000000r0xnAAA'];
        return Ws;
            
    }
    
     @auraEnabled
    public static Inventory_Allocation__c save(double Qty)
    {
       Inventory_Allocation__c allocation = new Inventory_Allocation__c();
           allocation.Quantity__c = Qty;
        /*Integer Week_Start_Date =1/1/2020;
        Integer Week_End_Date =7/1/2020;
         Date startdate = date.today();
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
        Date weekStartDate = todaydateinstance.adddays(-7).toStartOfWeek();
          Date weekEndDate = todaydateinstance.adddays(10).tostartofweek();*/
      /* Integer Week_Start_Date= 1/10/20;
        Integer Week_End_Date= 7/12/20;*/
        
     insert allocation;
     return allocation;
}
}