public class DisplayInventoryClass {
  @AuraEnabled
    public static List<Inventory_Allocation__c> fetch(){
        List<Inventory_Allocation__c> allocationData = new List<Inventory_Allocation__c>();
        Map<String,String> retailerWarehouseMap = getWarehouse();
        
        //List<Inventory_Allocation__c> allocationList = [SELECT Inventory_Allocation_Type__c, Quantity__c,Week_Start_Date__c, Week_End_Date__c,Inventory_Allocation_Demand__c FROM Inventory_Allocation__c where Physically_Available__c =false];
        List<Inventory_Allocation__c> allocationList = [SELECT Inventory_Allocation_Type__c, Quantity__c,Inventory_Allocation_Demand__c FROM Inventory_Allocation__c
                                                        where Physically_Available__c =false];
        system.debug('allocationList:'+allocationList);
        for(Inventory_Allocation__c  allData : allocationList ){
            String retailerName = getRetailerForDemand(allData.Inventory_Allocation_Demand__c);
            system.debug('retailerName:'+retailerName);
            Inventory_Allocation__c allocationObj = new Inventory_Allocation__c();
            allocationObj.Id = allData.Id;
           system.debug('allData:'+allData);
            allocationObj.Retailer_Name__c = retailerName;
            allocationObj.Warehouse_Name__c = retailerWarehouseMap.get(retailerName);
            allocationObj.Quantity__c = allData.Quantity__c;
            //allocationObj.Inventory_Allocation_Type__c = allData.Inventory_Allocation_Type__c;
            //allocationObj.Week_Start_Date__c= allData.Week_Start_Date__c;
            //allocationObj.Week_End_Date__c= allData.Week_End_Date__c;
            allocationData.add(allocationObj);
             system.debug('allocationData:'+allocationData);
            
        }
        // system.debug('allocationData:'+allocationData);
        
        return allocationData;
    }
    public static String getRetailerForDemand(Id demandId){   
        system.debug('demandId:'+demandId);
        String retailerName = '';
        if(demandId <> null){
            retailerName = [SELECT Retailer_Code__r.Name FROM Weekly_Demand_Summary__c WHERE Id=:demandId LIMIT 1].Retailer_Code__r.Name;
        }
         system.debug('retailerName:'+retailerName);
        return retailerName;
       
    }
    
    public static Map<String,String> getWarehouse(){
        Map<String,String> retailerWarehouseMap = new Map<String,String>();
        List<Data_Upload_Transaction__c> retailerWarehouseList = [SELECT Retailer_Code__r.Name,Warehouse__c FROM Data_Upload_Transaction__c
                                                           where Retailer_Code__c <> null and Warehouse__c <> null ];
        
        for(Data_Upload_Transaction__c  warehouseData : retailerWarehouseList ){            
            retailerWarehouseMap.put(warehouseData.Retailer_Code__r.Name, warehouseData.Warehouse__c);          
        }
         system.debug('retailerWarehouseMap:'+retailerWarehouseMap);
        return retailerWarehouseMap;
    }
    
    
    /*@AuraEnabled
    public static List<Inventory_Allocation__c> fetchData(){
        List<Inventory_Allocation__c> acc = [SELECT Id,Physically_Available__c FROM Inventory_Allocation__c ];
        return acc;
    }*/
    
    
     @AuraEnabled
    public static Boolean save (List<Id> checkedId){
        system.debug('checkedId:'+checkedId);
        Boolean updateStatus = false;
        try{
            for(Id  IDvalue:checkedId ){
                Inventory_Allocation__c invAllc = new Inventory_Allocation__c();
                InvAllc.Physically_Available__c = true ;
                invAllc.Id = IDvalue;
                Update invAllc;
                updateStatus = true;
            }
        }
        catch(DMLException e){
            updateStatus = false;
        } 
        return updateStatus;
    }
    
    
}