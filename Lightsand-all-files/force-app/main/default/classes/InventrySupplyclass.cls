public class InventrySupplyclass{
    @auraEnabled
    public static List<Weekly_Supply_Summary__c> getSupplySummary()
    {
        List<Weekly_Supply_Summary__c> Ws= [Select Id,Mainetti_Company__c , Retailer_Code__r.Name ,Mainetti_Model__r.Name,Color__c ,Sizer_Print__c,Quantity__c FROM Weekly_Supply_Summary__c];
        return Ws;
        
    }
    @auraEnabled
    public static Map<String,decimal> getWeeklySupplySummary(){        
        List <Weekly_Supply_Summary__c> WeeklySupplySummary = [Select id,Mainetti_Company__c,Retailer_Code__r.Name ,Mainetti_Model__r.Name,Color__c,Sizer_Print__c,Quantity__c FROM Weekly_Supply_Summary__c];
        Map<string,decimal> weeklySupplyMap = new Map<string,decimal>(); 
        Map<string,decimal> invQtyMap = new Map<string,decimal>(); 
        
        for (Weekly_Supply_Summary__c weeklySupply : WeeklySupplySummary){
            //String supplyKey =  weeklySupply.Mainetti_Company__c+'#'+weeklySupply.Retailer_Code__r.Name+'#'+weeklySupply.Mainetti_Model__r.Name+'#'+weeklySupply.Color__c+'#'+weeklySupply.Sizer_Print__c+'#'+weeklySupply.Quantity__c;    
            weeklySupplyMap.put(weeklysupply.Id,weeklySupply.Quantity__c);   
            System.debug(weeklySupplyMap);
        }
        
        for (String supplyid : weeklySupplyMap.keySet()) {
            List<Inventory_Allocation__c> InvAllOcation =[Select Id, Quantity__c from Inventory_Allocation__c where Inventory_Allocation_Supply__c=:supplyid];   
            for (Inventory_Allocation__c invQty : InvAllOcation){
                if(invQty.Quantity__c != null){
                    invQtyMap.put(supplyid,invQty.Quantity__c);	
                }   
            }
        }
        for(String Supplyid : weeklySupplyMap.keySet()){
            Decimal SupplyQty =weeklySupplyMap.get(supplyid);
            Decimal AllocatedQty =invQtyMap.get(supplyid);
           Decimal BalanceQty = SupplyQty-AllocatedQty;
           /* List<Decimal> TotalSupply = new List<Decimal>();
            TotalSupply =weeklySupplyMap.values();
            System.debug('getWeeklySupplySummary::TotalSupply'+TotalSupply);
            System.debug('getWeeklySupplySummary::BalanceQty'+BalanceQty);*/
            
        }
        System.debug('getWeeklySupplySummary::weeklySupplyMap'+weeklySupplyMap);
        return weeklySupplyMap; 
    }
}