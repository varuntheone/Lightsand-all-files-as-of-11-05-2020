public class WarehouseReuseCenterClass {
    
 
     @AuraEnabled
    public static List<Reuse_center_Inventory_Manager__c> getWarehouseData(){
        
       // List<Reuse_center_Inventory_Manager__c> fetchdata=[Select Warehouse_name_holder__c, Warehouse_Name__c, User_Name__c from Reuse_center_Inventory_Manager__c  order by Warehouse_name_holder__c];
        List<Reuse_center_Inventory_Manager__c> fetchdata=[Select Warehouse__c, Warehouse_name_holder__c, Warehouse_Name__c, User_Name__c from Reuse_center_Inventory_Manager__c where Warehouse_name_holder__c <> null and User_Name__c <> null order By Warehouse_name_holder__c];
        map<string,map<string,string>> returnValue = new map<string,map<string,string>>();
        
        List<Reuse_center_Inventory_Manager__c> reuseInv = new List<Reuse_center_Inventory_Manager__c>();
        system.debug('fetchdata:'+fetchdata);
        for (Reuse_center_Inventory_Manager__c fetch : fetchdata){
            Reuse_center_Inventory_Manager__c updateObj =new Reuse_center_Inventory_Manager__c();
            if(!returnValue.containsKey(fetch.Warehouse_name_holder__c)){
                map<string,string> userMap = new map<string,string>();
                updateObj.Warehouse_name_holder__c = fetch.Warehouse_name_holder__c;
                updateObj.User_name_holder__c = fetch.User_Name__c;
                updateObj.Warehouse__c = fetch.Warehouse_name_holder__c;
                updateObj.Id = fetch.Id;
                reuseInv.add(updateObj);
                userMap.put(fetch.User_Name__c, fetch.User_Name__c);
                returnValue.put(fetch.Warehouse_name_holder__c, userMap);
                
            }else{
                map<string,string> userValueMap = returnValue.get(fetch.Warehouse_name_holder__c);
                if(!userValueMap.containsKey(fetch.User_Name__c)){                    
                    updateObj.User_name_holder__c = fetch.User_Name__c;
                    updateObj.Warehouse_name_holder__c = '';
                    updateObj.Warehouse__c = fetch.Warehouse_name_holder__c;
                    updateObj.Id = fetch.Id;
                    
                    reuseInv.add(updateObj);
                    userValueMap.put(fetch.User_Name__c, fetch.User_Name__c);
                    returnValue.put(fetch.Warehouse_name_holder__c, userValueMap);
                }
                
            }
        }
        system.debug('reuseInv:'+reuseInv);
        return reuseInv;
    }
     @AuraEnabled
            public static boolean saveData(Reuse_center_Inventory_Manager__c Warehouse, List<User> userList) {
        boolean saveStatus = false;
        system.debug('Warehouse:'+Warehouse);
        system.debug('userList:'+userList);
        List<Reuse_center_Inventory_Manager__c> insertList = new List<Reuse_center_Inventory_Manager__c>();
        for (User fetch : userList){
           // Reuse_center_Inventory_Manager__c objInsert = new Reuse_center_Inventory_Manager__c(Warehouse__c = Warehouse.Id);
             Reuse_center_Inventory_Manager__c objInsert = new Reuse_center_Inventory_Manager__c(Warehouse_name_holder__c = Warehouse.Warehouse__c, User__c = fetch.Id);
            insertList.add(objInsert);
            system.debug('objInsert:'+objInsert);
        }
        if(!insertList.isEmpty()){
            try{
                insert insertList;
                saveStatus = true;
                system.debug('insertList:'+insertList);
            }catch(Exception e){
                system.debug('Insertion failed:'+e.getMessage());
            }            
        }
        return saveStatus;
        
    }
    
     @AuraEnabled
    public static List<Data_Upload_Transaction__c> fetchLookupWarehousedataList(String enteredValue) {
        
        String searchKey = '%' + enteredValue + '%';
        List <Data_Upload_Transaction__c> lstOfValues = [Select Warehouse__c from Data_Upload_Transaction__c where Warehouse__c like : searchKey LIMIT 10];
        system.debug('Retailer_Code__c:'+lstOfValues);
        return lstOfValues;
    }
     @AuraEnabled
    public static List<User> fetchLookupUserdataList(String enteredValue) {
        
        String searchKey = '%' + enteredValue + '%';
        List <User> lstOfValues = [Select Name from User where Name like : searchKey LIMIT 10];
        system.debug('User:'+lstOfValues);
        return lstOfValues;
    }
     @AuraEnabled
    public static boolean deleteData(string warehouse) {
        boolean deleteStatus = false;
        List<Reuse_center_Inventory_Manager__c> lstOfValues = [Select id,Warehouse_name_holder__c from Reuse_center_Inventory_Manager__c where Warehouse_name_holder__c =:warehouse];
        if(!lstOfValues.isEmpty()){
            try{
                delete lstOfValues;
                deleteStatus = true;
            }catch(Exception e){
                system.debug('Deletion failed:'+e.getMessage());
            }            
        } 
        return deleteStatus;
    }
     @AuraEnabled
    public static boolean deleteUser(string warehouse, string userName) {
        boolean deleteStatus = false;
        system.debug('warehouse:'+warehouse);
        system.debug('userName:'+userName);
        List<Reuse_center_Inventory_Manager__c> lstOfValues = [Select id from Reuse_center_Inventory_Manager__c where Warehouse_name_holder__c =:warehouse and User_Name__c =:userName];
        system.debug('lstOfValues:'+lstOfValues);
        if(!lstOfValues.isEmpty()){
            try{
                delete lstOfValues; 
                deleteStatus = true;
            }catch(Exception e){                
                system.debug('Deletion failed:'+e.getMessage());
            }            
        } 
        return deleteStatus;
    }
     @AuraEnabled
        public static List<User> getUsers(String Warehouse) {
        List<User> userList= new List<User>();
        List<User> lstOfUsers = [Select Id,Name from User where Id IN (Select User__c from Reuse_center_Inventory_Manager__c where Warehouse_name_holder__c =:Warehouse)];        
        system.debug('lstOfUsers:'+lstOfUsers);
        return lstOfUsers;
    }
     @AuraEnabled
    public static List<Reuse_center_Inventory_Manager__c> fetchWarehouseId(String Warehouse) {
        List <Reuse_center_Inventory_Manager__c> lstOfValues = [Select Id,Warehouse_name_holder__c from Reuse_center_Inventory_Manager__c where Warehouse_name_holder__c =: Warehouse  LIMIT 1];
        system.debug('lstOfValues:'+lstOfValues);
        return lstOfValues;
    }
    
}