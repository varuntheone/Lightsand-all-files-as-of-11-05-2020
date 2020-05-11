@isTest
public class WarehouseReuseCenterTest {
    static testMethod void getWarehouseDataTest() {      
        
        Data_Upload_Transaction__c dataUpload  = new Data_Upload_Transaction__c();
        dataUpload.Warehouse__c = 'LongHua Factory';
        insert dataUpload;
        
        Reuse_center_Inventory_Manager__c reuseManager = new Reuse_center_Inventory_Manager__c();
        reuseManager.Warehouse__c = 'a1op0000000f5pFAAQ';
        reuseManager.Warehouse_name_holder__c = 'a1op0000000f5pFAAQ';
        
        reuseManager.User__c = '005p0000001gNj6AAE';
        insert reuseManager;
        
        Reuse_center_Inventory_Manager__c reuseManagerWarehouse = new Reuse_center_Inventory_Manager__c();
        reuseManagerWarehouse.Warehouse_name_holder__c = 'a1op0000000f5pFAAQ';
        reuseManagerWarehouse.User__c = '00590000001AqYIAA0';
        //reuseManagerRetailer.Warehouse_name_holder__c = ' ';
        insert reuseManagerWarehouse;
        
        boolean flag = true;
        Test.startTest();
        WarehouseReuseCenterClass.getWarehouseData();        
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
    static testMethod void saveDataTest() {
        Reuse_center_Inventory_Manager__c reusecenter = new Reuse_center_Inventory_Manager__c();
        
        //string WarehouseName = 'Ningbo Warehouse';
        User userDetail = new User();
        //userDetail.Id = '005p0000001gNj6AAE';
        //userDetail.Name = 'Ashwin Raj';
        List<User> userList = new List<User>();
        userList.add(userDetail);
        
        boolean flag = true;
        Test.startTest();
        WarehouseReuseCenterClass.saveData(reusecenter,userList);        
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
    static testMethod void fetchDataTest() {
        string keyWord = 'a';
        
        boolean flag = true;
        Test.startTest();
        WarehouseReuseCenterClass.fetchLookupWarehousedataList(keyWord); 
        WarehouseReuseCenterClass.fetchLookupUserdataList(keyWord);        
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
    static testMethod void deleteDataTest() {
         Data_Upload_Transaction__c dataUpload  = new Data_Upload_Transaction__c();
        dataUpload.Warehouse__c = 'LongHua Factory';
        insert dataUpload;
        
        Reuse_center_Inventory_Manager__c reuseManager = new Reuse_center_Inventory_Manager__c();
        reuseManager.Warehouse__c = dataUpload.Id;
        reuseManager.Warehouse_name_holder__c = dataUpload.Id;
        reuseManager.User__c = '005p0000001gNj6AAE';
        insert reuseManager;
        string WarehouseName = 'Ningbo Warehouse';
        
        boolean flag = true;
        Test.startTest();
        WarehouseReuseCenterClass.deleteData(WarehouseName);        
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
    static testMethod void deleteUserTest() {
         Data_Upload_Transaction__c dataUpload  = new Data_Upload_Transaction__c();
        dataUpload.Warehouse__c = 'LongHua Factory';
        insert dataUpload;
        
        Reuse_center_Inventory_Manager__c reuseManager = new Reuse_center_Inventory_Manager__c();
        reuseManager.Warehouse__c = dataUpload.Id;
         reuseManager.Warehouse_name_holder__c = dataUpload.Id;
        reuseManager.User__c = '005p0000001gNj6AAE';
        insert reuseManager;
        
        boolean flag = true;
        Test.startTest();
        WarehouseReuseCenterClass.deleteUser(dataUpload.Id,'Ashwin Raj');        
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
    static testMethod void getUserTest() {
        string WarehouseName = 'Ningbo Warehouse';
        
        boolean flag = true;
        Test.startTest();
        WarehouseReuseCenterClass.getUsers(WarehouseName);
        WarehouseReuseCenterClass.fetchWarehouseId(WarehouseName);        
        Test.stopTest();
        System.assertEquals(true, flag);
    }
}