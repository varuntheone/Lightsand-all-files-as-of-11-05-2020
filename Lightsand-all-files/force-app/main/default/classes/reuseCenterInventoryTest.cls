@isTest
public class reuseCenterInventoryTest {
    static testMethod void getCompanyDataTest() {
        
        Reuse_center_Inventory_Manager__c reuseManager = new Reuse_center_Inventory_Manager__c();
        reuseManager.Mainetti_Company__c = 'a05p0000003OHyJAAW';
        reuseManager.User__c = '005p0000001gNj6AAE';
        insert reuseManager;
        
        Reuse_center_Inventory_Manager__c reuseManagerRetailer = new Reuse_center_Inventory_Manager__c();
        reuseManagerRetailer.Mainetti_Company__c = 'a05p0000003OHyJAAW';
        reuseManagerRetailer.User__c = '00590000001AqYIAA0';
        insert reuseManagerRetailer;
        
        boolean flag = true;
        Test.startTest();
        reuseCenterInventory.getRetailerData();        
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
    static testMethod void saveDataTest(){
        Partner__c patner = new Partner__c();
        User userDetail = new User();
        
        List<User> userList = new List<User>();
        userList.add(userDetail);
        
        boolean flag = true;
        Test.startTest();
        reuseCenterInventory.saveData(patner,userList);        
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
    static testMethod void fetchDataTest() {
        string keyWord = 'a';
        
        boolean flag = true;
        Test.startTest();
        reuseCenterInventory.fetchLookupRetailerdataList(keyWord); 
        reuseCenterInventory.fetchLookupUserdataList(keyWord);        
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
    static testMethod void deleteDataTest() {
        Reuse_center_Inventory_Manager__c reuseManager = new Reuse_center_Inventory_Manager__c();
        reuseManager.Mainetti_Company__c = 'a05p0000003OHyJAAW';
        reuseManager.User__c = '005p0000001gNj6AAE';
        insert reuseManager;
        string MainettiName = 'Mainetti (HK) Ltd';
        
        boolean flag = true;
        Test.startTest();
        reuseCenterInventory.deleteData(MainettiName);        
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
    static testMethod void deleteUserTest() {
        Reuse_center_Inventory_Manager__c reuseManager = new Reuse_center_Inventory_Manager__c();
        reuseManager.Mainetti_Company__c = 'a05p0000003OHyJAAW';
        reuseManager.User__c = '005p0000001gNj6AAE';
        insert reuseManager;
        
        boolean flag = true;
        Test.startTest();
        reuseCenterInventory.deleteUser('a05p0000003OHyJAAW','Ashwin Raj');        
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
    static testMethod void getUserTest() {
        string MainettiName = 'Mainetti (HK) Ltd';
        
        boolean flag = true;
        Test.startTest();
        reuseCenterInventory.getUsers(MainettiName);
        reuseCenterInventory.fetchRetailerId(MainettiName);        
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
}