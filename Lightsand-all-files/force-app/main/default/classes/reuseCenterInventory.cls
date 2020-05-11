public class reuseCenterInventory {
     @AuraEnabled
    public static List<Reuse_center_Inventory_Manager__c> getRetailerData(){
        
        List<Reuse_center_Inventory_Manager__c> fetchdata=[Select Mainetti_Name__c, User_Name__c, Mainetti_Company__c from Reuse_center_Inventory_Manager__c where Mainetti_Name__c <> null and User_Name__c <> null order by Mainetti_Name__c];
       
        map<string,map<string,string>> returnValue = new map<string,map<string,string>>();
        
        List<Reuse_center_Inventory_Manager__c> reuseInv = new List<Reuse_center_Inventory_Manager__c>();
        
        for (Reuse_center_Inventory_Manager__c fetch : fetchdata){
            Reuse_center_Inventory_Manager__c updateObj =new Reuse_center_Inventory_Manager__c();
            if(!returnValue.containsKey(fetch.Mainetti_Name__c)){
                map<string,string> userMap = new map<string,string>();
                updateObj.Mainetti_Name_Holder__c = fetch.Mainetti_Name__c;
                updateObj.User_name_holder__c = fetch.User_Name__c;
                updateObj.Mainetti_Company__c = fetch.Mainetti_Company__c;
                updateObj.Id = fetch.Id;
                 
                reuseInv.add(updateObj);
                userMap.put(fetch.User_Name__c, fetch.User_Name__c);
                returnValue.put(fetch.Mainetti_Name__c, userMap);
                
            }else{
                map<string,string> userValueMap = returnValue.get(fetch.Mainetti_Name__c);
                if(!userValueMap.containsKey(fetch.User_Name__c)){                    
                    updateObj.User_name_holder__c = fetch.User_Name__c;
                    updateObj.Mainetti_Name_Holder__c = '';
                    updateObj.Mainetti_Company__c = fetch.Mainetti_Company__c;
                    updateObj.Id = fetch.Id;
                    
                    reuseInv.add(updateObj);
                    userValueMap.put(fetch.User_Name__c, fetch.User_Name__c);
                    returnValue.put(fetch.Mainetti_Name__c, userValueMap);
                }
                
            }
        }
        system.debug('reuseInv:'+reuseInv);
        return reuseInv;
    }
     @AuraEnabled
    public static boolean saveData(Partner__c Partner, List<User> userList) {
        boolean saveStatus = false;
        system.debug('Partner:'+Partner);
        system.debug('userList:'+userList);
        List<Reuse_center_Inventory_Manager__c> insertList = new List<Reuse_center_Inventory_Manager__c>();
        for (User fetch : userList){
            Reuse_center_Inventory_Manager__c objInsert = new Reuse_center_Inventory_Manager__c(Mainetti_Company__c = Partner.Id, User__c = fetch.Id);
            insertList.add(objInsert);
        }
        if(!insertList.isEmpty()){
            try{
                insert insertList;
                saveStatus = true;
            }catch(Exception e){
                system.debug('Insertion failed:'+e.getMessage());
            }            
        }
        return saveStatus;
    }
     @AuraEnabled
    public static List<Partner__c> fetchLookupRetailerdataList(String enteredValue) {
        
        String searchKey = '%' + enteredValue + '%';
        List <Partner__c> lstOfValues = [Select Name from Partner__c where Name like : searchKey LIMIT 10];
        //system.debug('Retailer_Code__c:'+lstOfValues);
        return lstOfValues;
    }
     @AuraEnabled
    public static List<User> fetchLookupUserdataList(String enteredValue) {
        
        String searchKey = '%' + enteredValue + '%';
        List <User> lstOfValues = [Select Name from User where Name like : searchKey LIMIT 10];
        //system.debug('User:'+lstOfValues);
        return lstOfValues;
    }
     @AuraEnabled
    public static boolean deleteData(string mainettiName) {
        boolean deleteStatus = false;
        List<Reuse_center_Inventory_Manager__c> lstOfValues = [Select id,Mainetti_Name__c from Reuse_center_Inventory_Manager__c where Mainetti_Name__c =:mainettiName];
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
    public static boolean deleteUser(string mainettiName, string userName) {
        boolean deleteStatus = false;
                List<Reuse_center_Inventory_Manager__c> lstOfValues = [Select id from Reuse_center_Inventory_Manager__c where Mainetti_Company__c =:mainettiName and User_Name__c =:userName];
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
    public static List<User> getUsers(String mainettiName) {
        List<User> userList= new List<User>();
        List<User> lstOfUsers = [Select Id,Name from User where Id IN (Select User__c from Reuse_center_Inventory_Manager__c where Mainetti_Name__c =:mainettiName)];        
        //system.debug('lstOfUsers:'+lstOfUsers);
        return lstOfUsers;
    }
     @AuraEnabled
    public static List<Partner__c> fetchRetailerId(String mainettiName) {
        List <Partner__c> lstOfValues = [Select Id,Name from Partner__c where Name =: mainettiName LIMIT 1];
        system.debug('lstOfValues:'+lstOfValues);
        return lstOfValues;
    }
    
}