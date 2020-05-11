/**
 *  @description : Apex test class for RTS_OrderStatusDisplayPageController
 *  @author : DC
 *  @revision :
 *      * 04Dec2015 1.0     @comment : Created
 *      * 30Dec2015 1.1     @comment : Updated test code to run as a specific user
 */
@isTest
private class RTS_OrderStatusDisplayPageCtrl_Test {

    // DC 1.1 - Added method to create user data.
    static User createUser(Integer counter) {
        Profile profInstance = [select id from profile where name='Mainetti - User S6'];
        System.debug(counter);
        User userInstance = new User(alias = 'stand' + counter, email='standarduser@testorg.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = profInstance.Id, 
            timezonesidkey='America/Los_Angeles', username='standarduser' + counter + '@testorg.com',
            Inventory_Type__c = 'China1; China2; International');
        return userInstance;
    }

    static testMethod void myUnitTest() {

        // Create test data for Partner__c
        Partner__c partnerInstance = new Partner__c(
            Name = 'NingBo RTS',
            Partner_Status__c = 'Active',
            Type_of_Operation__c = 'RTS',
            Year_of_Incorporation__c = 2015,
            Year_Starting_Mainetti_Production__c = 2015,
            Allowed_Inventory_Types__c = 'China1;International',
            RTS_Partner_Code__c = 'NBO'
        );
        insert partnerInstance;

        // Create test data for Product__c
        Product__c productInstance = new Product__c(
            Mainetti_Model__c = '584',
            Material__c = 'METAL',
            Orderable__c = true,
            Status__c = 'Active',
            Product_Description__c = 'Test metallic product of model 584',
            Product_Type__c = 'ACCESSORIES',
            Product_Family__c = 'CLIP'
        );
        insert productInstance;

        // Create test data for RTS_Product_Inventory__c
        RTS_Product_Inventory__c inventoryInstance = new RTS_Product_Inventory__c(
            Model__c = productInstance.Id,
            Net_Weight__c = 12.5,
            UOM__c = 'PC',
            Box_Qty__c = 12,
            Color__c = 'BLK',
            Local_System_SKU__c = 'TEST-1234',
            Add_on__c = 'BLACK FOAM'
        );
        insert inventoryInstance;

        // Create test data for Ship_Bill_Address__c
        Ship_Bill_Address__c billAddressInstance = new Ship_Bill_Address__c(
            Address_1__c = 'Test Street 1',
            Address_2__c = 'Test Avenue 2',
            Bill_Ship_Status__c = 'Active',
            City__c = 'Test City',
            State__c = 'Test State',
            Country__c = 'Test Country',
            Postcode__c = '123456',
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Ship_Bill_Address__c' AND DeveloperName = 'Bill_To'].Id
        );
        insert billAddressInstance;

        // Create test data for Ship_Bill_Address__c
        Ship_Bill_Address__c shipAddressInstance = new Ship_Bill_Address__c(
            Address_1__c = 'Test Street 1',
            Address_2__c = 'Test Avenue 2',
            Bill_Ship_Status__c = 'Active',
            City__c = 'Test City',
            State__c = 'Test State',
            Country__c = 'Test Country',
            Postcode__c = '123456',
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Ship_Bill_Address__c' AND DeveloperName = 'Ship_To'].Id
        );
        insert shipAddressInstance;

        // Create test data for RTS_Placement__c
        RTS_Placement__c placementInstance = new RTS_Placement__c(
            Bill_To__c = billAddressInstance.Id,
            Ship_To__c = shipAddressInstance.Id,
            Customer_Comments__c = 'Test customer placement comment',
            Expected_Ship_Date__c = Date.today().addDays(2),
            Inventory_Type__c = 'China1',
            Placement_Date__c = Date.today().addDays(-1),
            Order_To_Company__c = partnerInstance.Id,
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'RTS_Placement__c' AND DeveloperName = 'Original_Placement_Order'].Id
        );
        insert placementInstance;

        Id detailRTId = [SELECT Id FROM RecordType WHERE SObjectType = 'RTS_Placement_Detail__c' AND DeveloperName = 'RTS_Placement_Detail'].Id;
        // Create test data for RTS_Placement_Detail__c - 1
        RTS_Placement_Detail__c detailInstance1 = new RTS_Placement_Detail__c(
            RTS_Placement__c = placementInstance.Id,
            RTS_Product_ID__c = inventoryInstance.Id,
            Order_Line_Status__c = 'Open',
            Sys_Model__c = '584',
            Expected_Ship_Date__c = Date.today().addDays(2),
            Quantity__c = 10,
            RecordTypeId = detailRTId
        );
        insert detailInstance1;

        // Create test data for RTS_Placement_Detail__c - 2
        RTS_Placement_Detail__c detailInstance2 = new RTS_Placement_Detail__c(
            RTS_Placement__c = placementInstance.Id,
            RTS_Product_ID__c = inventoryInstance.Id,
            Order_Line_Status__c = 'Approved',
            Sys_Model__c = '584',
            Expected_Ship_Date__c = Date.today().addDays(2),
            Quantity__c = 10,
            RecordTypeId = detailRTId
        );
        insert detailInstance2;

        // Create test data for RTS_Placement_Detail__c - 3
        RTS_Placement_Detail__c detailInstance3 = new RTS_Placement_Detail__c(
            RTS_Placement__c = placementInstance.Id,
            RTS_Product_ID__c = inventoryInstance.Id,
            Order_Line_Status__c = 'Cancel Rejected',
            Sys_Model__c = '584',
            Expected_Ship_Date__c = Date.today().addDays(2),
            Quantity__c = 10,
            RecordTypeId = detailRTId
        );
        insert detailInstance3;

        // Create test data for RTS_Placement_Detail__c - 4
        RTS_Placement_Detail__c detailInstance4 = new RTS_Placement_Detail__c(
            RTS_Placement__c = placementInstance.Id,
            RTS_Product_ID__c = inventoryInstance.Id,
            Order_Line_Status__c = 'Rejected',
            Sys_Model__c = '584',
            Expected_Ship_Date__c = Date.today().addDays(2),
            Quantity__c = 10,
            RecordTypeId = detailRTId
        );
        insert detailInstance4;

        List<Id> listSelectedIds = new List<Id>{
            detailInstance4.Id,
            detailInstance3.Id
        };

        List<SelectOption> listItems;
        List<SelectOption> listSubItems;

        System.Test.startTest();
            System.runAs(createUser(988)) {     // DC 1.1 - added runAs(user)
                System.Test.setCurrentPage(Page.RTS_OrderStatusDisplayPage);
                ApexPages.currentPage().getParameters().put('selectTab', 'name1');
                RTS_OrderStatusDisplayPageController controller = new RTS_OrderStatusDisplayPageController();
                RTS_OrderStatusDisplayPageController.getApprovedOrders(listSelectedIds, 'Approved');
                listItems = controller.getItems();
                listSubItems = RTS_OrderStatusDisplayPageController.getsubItemsOptions();
            }
        System.Test.stopTest();

        System.assertEquals(
            'Approved',
            [SELECT Order_Line_Status__c FROM RTS_Placement_Detail__c WHERE Id = :detailInstance3.Id].Order_Line_Status__c
        );

    }

    static testMethod void myUnitTest1() {

        // Create test data for Partner__c
        Partner__c partnerInstance = new Partner__c(
            Name = 'NingBo RTS',
            Partner_Status__c = 'Active',
            Type_of_Operation__c = 'RTS',
            Year_of_Incorporation__c = 2015,
            Year_Starting_Mainetti_Production__c = 2015,
            Allowed_Inventory_Types__c = 'China1;International',
            RTS_Partner_Code__c = 'NBO'
        );
        insert partnerInstance;

        // Create test data for Product__c
        Product__c productInstance = new Product__c(
            Mainetti_Model__c = '584',
            Material__c = 'METAL',
            Orderable__c = true,
            Status__c = 'Active',
            Product_Description__c = 'Test metallic product of model 584',
            Product_Type__c = 'ACCESSORIES',
            Product_Family__c = 'CLIP'
        );
        insert productInstance;

        // Create test data for RTS_Product_Inventory__c
        RTS_Product_Inventory__c inventoryInstance = new RTS_Product_Inventory__c(
            Model__c = productInstance.Id,
            Net_Weight__c = 12.5,
            UOM__c = 'PC',
            Box_Qty__c = 12,
            Color__c = 'BLK',
            Local_System_SKU__c = 'TEST-1234',
            Add_on__c = 'BLACK FOAM'
        );
        insert inventoryInstance;

        // Create test data for Ship_Bill_Address__c
        Ship_Bill_Address__c billAddressInstance = new Ship_Bill_Address__c(
            Address_1__c = 'Test Street 1',
            Address_2__c = 'Test Avenue 2',
            Bill_Ship_Status__c = 'Active',
            City__c = 'Test City',
            State__c = 'Test State',
            Country__c = 'Test Country',
            Postcode__c = '123456',
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Ship_Bill_Address__c' AND DeveloperName = 'Bill_To'].Id
        );
        insert billAddressInstance;

        // Create test data for Ship_Bill_Address__c
        Ship_Bill_Address__c shipAddressInstance = new Ship_Bill_Address__c(
            Address_1__c = 'Test Street 1',
            Address_2__c = 'Test Avenue 2',
            Bill_Ship_Status__c = 'Active',
            City__c = 'Test City',
            State__c = 'Test State',
            Country__c = 'Test Country',
            Postcode__c = '123456',
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Ship_Bill_Address__c' AND DeveloperName = 'Ship_To'].Id
        );
        insert shipAddressInstance;

        // Create test data for RTS_Placement__c
        RTS_Placement__c placementInstance = new RTS_Placement__c(
            Bill_To__c = billAddressInstance.Id,
            Ship_To__c = shipAddressInstance.Id,
            Customer_Comments__c = 'Test customer placement comment',
            Expected_Ship_Date__c = Date.today().addDays(2),
            Inventory_Type__c = 'China1',
            Placement_Date__c = Date.today().addDays(-1),
            Order_To_Company__c = partnerInstance.Id,
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'RTS_Placement__c' AND DeveloperName = 'Original_Placement_Order'].Id
        );
        insert placementInstance;

        Id detailRTId = [SELECT Id FROM RecordType WHERE SObjectType = 'RTS_Placement_Detail__c' AND DeveloperName = 'RTS_Placement_Detail'].Id;
        // Create test data for RTS_Placement_Detail__c - 1
        RTS_Placement_Detail__c detailInstance1 = new RTS_Placement_Detail__c(
            RTS_Placement__c = placementInstance.Id,
            RTS_Product_ID__c = inventoryInstance.Id,
            Order_Line_Status__c = 'Open',
            Sys_Model__c = '584',
            Expected_Ship_Date__c = Date.today().addDays(2),
            Quantity__c = 10,
            RecordTypeId = detailRTId
        );
        insert detailInstance1;

        // Create test data for RTS_Placement_Detail__c - 2
        RTS_Placement_Detail__c detailInstance2 = new RTS_Placement_Detail__c(
            RTS_Placement__c = placementInstance.Id,
            RTS_Product_ID__c = inventoryInstance.Id,
            Order_Line_Status__c = 'Approved',
            Sys_Model__c = '584',
            Expected_Ship_Date__c = Date.today().addDays(2),
            Quantity__c = 10,
            RecordTypeId = detailRTId
        );
        insert detailInstance2;

        // Create test data for RTS_Placement_Detail__c - 3
        RTS_Placement_Detail__c detailInstance3 = new RTS_Placement_Detail__c(
            RTS_Placement__c = placementInstance.Id,
            RTS_Product_ID__c = inventoryInstance.Id,
            Order_Line_Status__c = System.Label.Request_Approval,
            Sys_Model__c = '584',
            Expected_Ship_Date__c = Date.today().addDays(2),
            Quantity__c = 10,
            RecordTypeId = detailRTId
        );
        insert detailInstance3;

        // Create test data for RTS_Placement_Detail__c - 4
        RTS_Placement_Detail__c detailInstance4 = new RTS_Placement_Detail__c(
            RTS_Placement__c = placementInstance.Id,
            RTS_Product_ID__c = inventoryInstance.Id,
            Order_Line_Status__c = System.Label.Request_Approval,
            Sys_Model__c = '584',
            Expected_Ship_Date__c = Date.today().addDays(2),
            Quantity__c = 10,
            RecordTypeId = detailRTId
        );
        insert detailInstance4;

        List<Id> listSelectedIds = new List<Id>{
            detailInstance4.Id,
            detailInstance3.Id
        };

        List<SelectOption> listItems;
        List<SelectOption> listSubItems;

        System.Test.startTest();
            System.runAs(createUser(23)) {     // DC 1.1 - added runAs(user)
                System.Test.setCurrentPage(Page.RTS_OrderStatusDisplayPage);
                ApexPages.currentPage().getParameters().put('selectTab', 'name1');
                RTS_OrderStatusDisplayPageController controller = new RTS_OrderStatusDisplayPageController();
                RTS_OrderStatusDisplayPageController.getApprovedOrders(listSelectedIds, 'Approved');
                listItems = controller.getItems();
                listSubItems = RTS_OrderStatusDisplayPageController.getsubItemsOptions();
            }
        System.Test.stopTest();

        System.assertEquals(
            'On-hold',
            [SELECT Order_Line_Status__c FROM RTS_Placement_Detail__c WHERE Id = :detailInstance3.Id].Order_Line_Status__c
        );

    }

    static testMethod void myUnitTest2() {

        // Create test data for Partner__c
        Partner__c partnerInstance = new Partner__c(
            Name = 'NingBo RTS',
            Partner_Status__c = 'Active',
            Type_of_Operation__c = 'RTS',
            Year_of_Incorporation__c = 2015,
            Year_Starting_Mainetti_Production__c = 2015,
            Allowed_Inventory_Types__c = 'China1;International',
            RTS_Partner_Code__c = 'NBO'
        );
        insert partnerInstance;

        // Create test data for Product__c
        Product__c productInstance = new Product__c(
            Mainetti_Model__c = '584',
            Material__c = 'METAL',
            Orderable__c = true,
            Status__c = 'Active',
            Product_Description__c = 'Test metallic product of model 584',
            Product_Type__c = 'ACCESSORIES',
            Product_Family__c = 'CLIP'
        );
        insert productInstance;

        // Create test data for RTS_Product_Inventory__c
        RTS_Product_Inventory__c inventoryInstance = new RTS_Product_Inventory__c(
            Model__c = productInstance.Id,
            Net_Weight__c = 12.5,
            UOM__c = 'PC',
            Box_Qty__c = 12,
            Color__c = 'BLK',
            Local_System_SKU__c = 'TEST-1234',
            Add_on__c = 'BLACK FOAM'
        );
        insert inventoryInstance;

        // Create test data for Ship_Bill_Address__c
        Ship_Bill_Address__c billAddressInstance = new Ship_Bill_Address__c(
            Address_1__c = 'Test Street 1',
            Address_2__c = 'Test Avenue 2',
            Bill_Ship_Status__c = 'Active',
            City__c = 'Test City',
            State__c = 'Test State',
            Country__c = 'Test Country',
            Postcode__c = '123456',
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Ship_Bill_Address__c' AND DeveloperName = 'Bill_To'].Id
        );
        insert billAddressInstance;

        // Create test data for Ship_Bill_Address__c
        Ship_Bill_Address__c shipAddressInstance = new Ship_Bill_Address__c(
            Address_1__c = 'Test Street 1',
            Address_2__c = 'Test Avenue 2',
            Bill_Ship_Status__c = 'Active',
            City__c = 'Test City',
            State__c = 'Test State',
            Country__c = 'Test Country',
            Postcode__c = '123456',
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Ship_Bill_Address__c' AND DeveloperName = 'Ship_To'].Id
        );
        insert shipAddressInstance;

        // Create test data for RTS_Placement__c
        RTS_Placement__c placementInstance = new RTS_Placement__c(
            Bill_To__c = billAddressInstance.Id,
            Ship_To__c = shipAddressInstance.Id,
            Customer_Comments__c = 'Test customer placement comment',
            Expected_Ship_Date__c = Date.today().addDays(2),
            Inventory_Type__c = 'China1',
            Placement_Date__c = Date.today().addDays(-1),
            Order_To_Company__c = partnerInstance.Id,
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'RTS_Placement__c' AND DeveloperName = 'Original_Placement_Order'].Id
        );
        insert placementInstance;

        Id detailRTId = [SELECT Id FROM RecordType WHERE SObjectType = 'RTS_Placement_Detail__c' AND DeveloperName = 'RTS_Placement_Detail'].Id;
        // Create test data for RTS_Placement_Detail__c - 1
        RTS_Placement_Detail__c detailInstance1 = new RTS_Placement_Detail__c(
            RTS_Placement__c = placementInstance.Id,
            RTS_Product_ID__c = inventoryInstance.Id,
            Order_Line_Status__c = 'Open',
            Sys_Model__c = '584',
            Expected_Ship_Date__c = Date.today().addDays(2),
            Quantity__c = 10,
            RecordTypeId = detailRTId
        );
        insert detailInstance1;

        // Create test data for RTS_Placement_Detail__c - 2
        RTS_Placement_Detail__c detailInstance2 = new RTS_Placement_Detail__c(
            RTS_Placement__c = placementInstance.Id,
            RTS_Product_ID__c = inventoryInstance.Id,
            Order_Line_Status__c = 'Approved',
            Sys_Model__c = '584',
            Expected_Ship_Date__c = Date.today().addDays(2),
            Quantity__c = 10,
            RecordTypeId = detailRTId
        );
        insert detailInstance2;

        // Create test data for RTS_Placement_Detail__c - 3
        RTS_Placement_Detail__c detailInstance3 = new RTS_Placement_Detail__c(
            RTS_Placement__c = placementInstance.Id,
            RTS_Product_ID__c = inventoryInstance.Id,
            Order_Line_Status__c = System.Label.RTS_request_cancel,
            Sys_Model__c = '584',
            Expected_Ship_Date__c = Date.today().addDays(2),
            Quantity__c = 10,
            RecordTypeId = detailRTId
        );
        insert detailInstance3;

        // Create test data for RTS_Placement_Detail__c - 4
        RTS_Placement_Detail__c detailInstance4 = new RTS_Placement_Detail__c(
            RTS_Placement__c = placementInstance.Id,
            RTS_Product_ID__c = inventoryInstance.Id,
            Order_Line_Status__c = System.Label.RTS_request_cancel,
            Sys_Model__c = '584',
            Expected_Ship_Date__c = Date.today().addDays(2),
            Quantity__c = 10,
            RecordTypeId = detailRTId
        );
        insert detailInstance4;

        List<Id> listSelectedIds = new List<Id>{
            detailInstance4.Id,
            detailInstance3.Id
        };

        List<SelectOption> listItems;
        List<SelectOption> listSubItems;

        System.Test.startTest();
            System.runAs(createUser(716)) {     // DC 1.1 - added runAs(user)
                System.Test.setCurrentPage(Page.RTS_OrderStatusDisplayPage);
                ApexPages.currentPage().getParameters().put('selectTab', 'name1');
                RTS_OrderStatusDisplayPageController controller = new RTS_OrderStatusDisplayPageController();
                map<Id,list<string>> resultMap = RTS_OrderStatusDisplayPageController.getApprovedOrders(listSelectedIds, 'Approved');
                listItems = controller.getItems();
                listSubItems = RTS_OrderStatusDisplayPageController.getsubItemsOptions();
            }
        System.Test.stopTest();

        System.assertEquals(
            'Approved',
            [SELECT Order_Line_Status__c FROM RTS_Placement_Detail__c WHERE Id = :detailInstance3.Id].Order_Line_Status__c
        );

    }

    static testMethod void myUnitTest3() {

        // Create test data for Partner__c
        Partner__c partnerInstance = new Partner__c(
            Name = 'NingBo RTS',
            Partner_Status__c = 'Active',
            Type_of_Operation__c = 'RTS',
            Year_of_Incorporation__c = 2015,
            Year_Starting_Mainetti_Production__c = 2015,
            Allowed_Inventory_Types__c = 'China1;International',
            RTS_Partner_Code__c = 'NBO'
        );
        insert partnerInstance;

        // Create test data for Product__c
        Product__c productInstance = new Product__c(
            Mainetti_Model__c = '584',
            Material__c = 'METAL',
            Orderable__c = true,
            Status__c = 'Active',
            Product_Description__c = 'Test metallic product of model 584',
            Product_Type__c = 'ACCESSORIES',
            Product_Family__c = 'CLIP'
        );
        insert productInstance;

        // Create test data for RTS_Product_Inventory__c
        RTS_Product_Inventory__c inventoryInstance = new RTS_Product_Inventory__c(
            Model__c = productInstance.Id,
            Net_Weight__c = 12.5,
            UOM__c = 'PC',
            Box_Qty__c = 12,
            Color__c = 'BLK',
            Local_System_SKU__c = 'TEST-1234',
            Add_on__c = 'BLACK FOAM'
        );
        insert inventoryInstance;

        // Create test data for Ship_Bill_Address__c
        Ship_Bill_Address__c billAddressInstance = new Ship_Bill_Address__c(
            Address_1__c = 'Test Street 1',
            Address_2__c = 'Test Avenue 2',
            Bill_Ship_Status__c = 'Active',
            City__c = 'Test City',
            State__c = 'Test State',
            Country__c = 'Test Country',
            Postcode__c = '123456',
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Ship_Bill_Address__c' AND DeveloperName = 'Bill_To'].Id
        );
        insert billAddressInstance;

        // Create test data for Ship_Bill_Address__c
        Ship_Bill_Address__c shipAddressInstance = new Ship_Bill_Address__c(
            Address_1__c = 'Test Street 1',
            Address_2__c = 'Test Avenue 2',
            Bill_Ship_Status__c = 'Active',
            City__c = 'Test City',
            State__c = 'Test State',
            Country__c = 'Test Country',
            Postcode__c = '123456',
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Ship_Bill_Address__c' AND DeveloperName = 'Ship_To'].Id
        );
        insert shipAddressInstance;

        // Create test data for RTS_Placement__c
        RTS_Placement__c placementInstance = new RTS_Placement__c(
            Bill_To__c = billAddressInstance.Id,
            Ship_To__c = shipAddressInstance.Id,
            Customer_Comments__c = 'Test customer placement comment',
            Expected_Ship_Date__c = Date.today().addDays(2),
            Inventory_Type__c = 'China1',
            Placement_Date__c = Date.today().addDays(-1),
            Order_To_Company__c = partnerInstance.Id,
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'RTS_Placement__c' AND DeveloperName = 'Original_Placement_Order'].Id
        );
        insert placementInstance;

        Id detailRTId = [SELECT Id FROM RecordType WHERE SObjectType = 'RTS_Placement_Detail__c' AND DeveloperName = 'RTS_Placement_Detail'].Id;
        // Create test data for RTS_Placement_Detail__c - 1
        RTS_Placement_Detail__c detailInstance1 = new RTS_Placement_Detail__c(
            RTS_Placement__c = placementInstance.Id,
            RTS_Product_ID__c = inventoryInstance.Id,
            Order_Line_Status__c = 'Open',
            Sys_Model__c = '584',
            Expected_Ship_Date__c = Date.today().addDays(2),
            Quantity__c = 10,
            RecordTypeId = detailRTId
        );
        insert detailInstance1;

        // Create test data for RTS_Placement_Detail__c - 2
        RTS_Placement_Detail__c detailInstance2 = new RTS_Placement_Detail__c(
            RTS_Placement__c = placementInstance.Id,
            RTS_Product_ID__c = inventoryInstance.Id,
            Order_Line_Status__c = 'Approved',
            Sys_Model__c = '584',
            Expected_Ship_Date__c = Date.today().addDays(2),
            Quantity__c = 10,
            RecordTypeId = detailRTId
        );
        insert detailInstance2;

        // Create test data for RTS_Placement_Detail__c - 3
        RTS_Placement_Detail__c detailInstance3 = new RTS_Placement_Detail__c(
            RTS_Placement__c = placementInstance.Id,
            RTS_Product_ID__c = inventoryInstance.Id,
            Order_Line_Status__c = System.Label.RTS_request_cancel,
            Sys_Model__c = '584',
            Expected_Ship_Date__c = Date.today().addDays(2),
            Quantity__c = 10,
            RecordTypeId = detailRTId
        );
        insert detailInstance3;

        // Create test data for RTS_Placement_Detail__c - 4
        RTS_Placement_Detail__c detailInstance4 = new RTS_Placement_Detail__c(
            RTS_Placement__c = placementInstance.Id,
            RTS_Product_ID__c = inventoryInstance.Id,
            Order_Line_Status__c = System.Label.RTS_request_cancel,
            Sys_Model__c = '584',
            Expected_Ship_Date__c = Date.today().addDays(2),
            Quantity__c = 10,
            RecordTypeId = detailRTId
        );
        insert detailInstance4;

        List<Id> listSelectedIds;

        List<SelectOption> listItems;
        List<SelectOption> listSubItems;

        map<Id,list<string>> resultMap;

        System.Test.startTest();
            System.runAs(createUser(456)) {     // DC 1.1 - added runAs(user)
                System.Test.setCurrentPage(Page.RTS_OrderStatusDisplayPage);
                ApexPages.currentPage().getParameters().put('selectTab', 'name1');
                RTS_OrderStatusDisplayPageController controller = new RTS_OrderStatusDisplayPageController();
                resultMap = RTS_OrderStatusDisplayPageController.getApprovedOrders(listSelectedIds, 'Approved');
                listItems = controller.getItems();
                listSubItems = RTS_OrderStatusDisplayPageController.getsubItemsOptions();
            }
        System.Test.stopTest();

        System.assertEquals(2, listItems.size());
        System.assertEquals(3, listSubItems.size());
        System.assertEquals(NULL, resultMap);

    }

    static testMethod void myUnitTest4() {

        // Create test data for Partner__c
        Partner__c partnerInstance = new Partner__c(
            Name = 'NingBo RTS',
            Partner_Status__c = 'Active',
            Type_of_Operation__c = 'RTS',
            Year_of_Incorporation__c = 2015,
            Year_Starting_Mainetti_Production__c = 2015,
            Allowed_Inventory_Types__c = 'China1;International',
            RTS_Partner_Code__c = 'NBO'
        );
        insert partnerInstance;

        // Create test data for Product__c
        Product__c productInstance = new Product__c(
            Mainetti_Model__c = '584',
            Material__c = 'METAL',
            Orderable__c = true,
            Status__c = 'Active',
            Product_Description__c = 'Test metallic product of model 584',
            Product_Type__c = 'ACCESSORIES',
            Product_Family__c = 'CLIP'
        );
        insert productInstance;

        // Create test data for RTS_Product_Inventory__c
        RTS_Product_Inventory__c inventoryInstance = new RTS_Product_Inventory__c(
            Model__c = productInstance.Id,
            Net_Weight__c = 12.5,
            UOM__c = 'PC',
            Box_Qty__c = 12,
            Color__c = 'BLK',
            Local_System_SKU__c = 'TEST-1234',
            Add_on__c = 'BLACK FOAM'
        );
        insert inventoryInstance;

        // Create test data for Ship_Bill_Address__c
        Ship_Bill_Address__c billAddressInstance = new Ship_Bill_Address__c(
            Address_1__c = 'Test Street 1',
            Address_2__c = 'Test Avenue 2',
            Bill_Ship_Status__c = 'Active',
            City__c = 'Test City',
            State__c = 'Test State',
            Country__c = 'Test Country',
            Postcode__c = '123456',
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Ship_Bill_Address__c' AND DeveloperName = 'Bill_To'].Id
        );
        insert billAddressInstance;

        // Create test data for Ship_Bill_Address__c
        Ship_Bill_Address__c shipAddressInstance = new Ship_Bill_Address__c(
            Address_1__c = 'Test Street 1',
            Address_2__c = 'Test Avenue 2',
            Bill_Ship_Status__c = 'Active',
            City__c = 'Test City',
            State__c = 'Test State',
            Country__c = 'Test Country',
            Postcode__c = '123456',
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Ship_Bill_Address__c' AND DeveloperName = 'Ship_To'].Id
        );
        insert shipAddressInstance;

        // Create test data for RTS_Placement__c
        RTS_Placement__c placementInstance = new RTS_Placement__c(
            Bill_To__c = billAddressInstance.Id,
            Ship_To__c = shipAddressInstance.Id,
            Customer_Comments__c = 'Test customer placement comment',
            Expected_Ship_Date__c = Date.today().addDays(2),
            Inventory_Type__c = 'China1',
            Placement_Date__c = Date.today().addDays(-1),
            Order_To_Company__c = partnerInstance.Id,
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'RTS_Placement__c' AND DeveloperName = 'Original_Placement_Order'].Id
        );
        insert placementInstance;

        Id detailRTId = [SELECT Id FROM RecordType WHERE SObjectType = 'RTS_Placement_Detail__c' AND DeveloperName = 'RTS_Placement_Detail'].Id;
        // Create test data for RTS_Placement_Detail__c - 1
        RTS_Placement_Detail__c detailInstance1 = new RTS_Placement_Detail__c(
            RTS_Placement__c = placementInstance.Id,
            RTS_Product_ID__c = inventoryInstance.Id,
            Order_Line_Status__c = 'Open',
            Sys_Model__c = '584',
            Expected_Ship_Date__c = Date.today().addDays(2),
            Quantity__c = 10,
            RecordTypeId = detailRTId
        );
        insert detailInstance1;

        // Create test data for RTS_Placement_Detail__c - 2
        RTS_Placement_Detail__c detailInstance2 = new RTS_Placement_Detail__c(
            RTS_Placement__c = placementInstance.Id,
            RTS_Product_ID__c = inventoryInstance.Id,
            Order_Line_Status__c = 'Approved',
            Sys_Model__c = '584',
            Expected_Ship_Date__c = Date.today().addDays(2),
            Quantity__c = 10,
            RecordTypeId = detailRTId
        );
        insert detailInstance2;

        // Create test data for RTS_Placement_Detail__c - 3
        RTS_Placement_Detail__c detailInstance3 = new RTS_Placement_Detail__c(
            RTS_Placement__c = placementInstance.Id,
            RTS_Product_ID__c = inventoryInstance.Id,
            Order_Line_Status__c = 'Approved',
            Sys_Model__c = '584',
            Expected_Ship_Date__c = Date.today().addDays(2),
            Quantity__c = 10,
            RecordTypeId = detailRTId
        );
        insert detailInstance3;

        // Create test data for RTS_Placement_Detail__c - 4
        RTS_Placement_Detail__c detailInstance4 = new RTS_Placement_Detail__c(
            RTS_Placement__c = placementInstance.Id,
            RTS_Product_ID__c = inventoryInstance.Id,
            Order_Line_Status__c = System.Label.RTS_request_cancel,
            Sys_Model__c = '584',
            Expected_Ship_Date__c = Date.today().addDays(2),
            Quantity__c = 10,
            RecordTypeId = detailRTId
        );
        insert detailInstance4;

        List<Id> listSelectedIds = new List<Id>{
            detailInstance2.Id,
            detailInstance3.Id
        };

        List<SelectOption> listItems;
        List<SelectOption> listSubItems;

        System.Test.startTest();
            System.runAs(createUser(56)) {     // DC 1.1 - added runAs(user)
                System.Test.setCurrentPage(Page.RTS_OrderStatusDisplayPage);
                ApexPages.currentPage().getParameters().put('selectTab', 'name1');
                RTS_OrderStatusDisplayPageController controller = new RTS_OrderStatusDisplayPageController();
                RTS_OrderStatusDisplayPageController.getApprovedOrders(listSelectedIds, 'Approved');
                listItems = controller.getItems();
                listSubItems = RTS_OrderStatusDisplayPageController.getsubItemsOptions();
            }
        System.Test.stopTest();

        System.assertEquals(
            'Approved',
            [SELECT Order_Line_Status__c FROM RTS_Placement_Detail__c WHERE Id = :detailInstance3.Id].Order_Line_Status__c
        );

    }

    static testMethod void myUnitTest5() {

        // Create test data for Partner__c
        Partner__c partnerInstance = new Partner__c(
            Name = 'NingBo RTS',
            Partner_Status__c = 'Active',
            Type_of_Operation__c = 'RTS',
            Year_of_Incorporation__c = 2015,
            Year_Starting_Mainetti_Production__c = 2015,
            Allowed_Inventory_Types__c = 'China1;International',
            RTS_Partner_Code__c = 'NBO'
        );
        insert partnerInstance;

        // Create test data for Product__c
        Product__c productInstance = new Product__c(
            Mainetti_Model__c = '584',
            Material__c = 'METAL',
            Orderable__c = true,
            Status__c = 'Active',
            Product_Description__c = 'Test metallic product of model 584',
            Product_Type__c = 'ACCESSORIES',
            Product_Family__c = 'CLIP'
        );
        insert productInstance;

        // Create test data for RTS_Product_Inventory__c
        RTS_Product_Inventory__c inventoryInstance = new RTS_Product_Inventory__c(
            Model__c = productInstance.Id,
            Net_Weight__c = 12.5,
            UOM__c = 'PC',
            Box_Qty__c = 12,
            Color__c = 'BLK',
            Local_System_SKU__c = 'TEST-1234',
            Add_on__c = 'BLACK FOAM'
        );
        insert inventoryInstance;

        // Create test data for Ship_Bill_Address__c
        Ship_Bill_Address__c billAddressInstance = new Ship_Bill_Address__c(
            Address_1__c = 'Test Street 1',
            Address_2__c = 'Test Avenue 2',
            Bill_Ship_Status__c = 'Active',
            City__c = 'Test City',
            State__c = 'Test State',
            Country__c = 'Test Country',
            Postcode__c = '123456',
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Ship_Bill_Address__c' AND DeveloperName = 'Bill_To'].Id
        );
        insert billAddressInstance;

        // Create test data for Ship_Bill_Address__c
        Ship_Bill_Address__c shipAddressInstance = new Ship_Bill_Address__c(
            Address_1__c = 'Test Street 1',
            Address_2__c = 'Test Avenue 2',
            Bill_Ship_Status__c = 'Active',
            City__c = 'Test City',
            State__c = 'Test State',
            Country__c = 'Test Country',
            Postcode__c = '123456',
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Ship_Bill_Address__c' AND DeveloperName = 'Ship_To'].Id
        );
        insert shipAddressInstance;

        // Create test data for RTS_Placement__c
        RTS_Placement__c placementInstance = new RTS_Placement__c(
            Bill_To__c = billAddressInstance.Id,
            Ship_To__c = shipAddressInstance.Id,
            Customer_Comments__c = 'Test customer placement comment',
            Expected_Ship_Date__c = Date.today().addDays(2),
            Inventory_Type__c = 'China1',
            Placement_Date__c = Date.today().addDays(-1),
            Order_To_Company__c = partnerInstance.Id,
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'RTS_Placement__c' AND DeveloperName = 'Original_Placement_Order'].Id
        );
        insert placementInstance;

        Id detailRTId = [SELECT Id FROM RecordType WHERE SObjectType = 'RTS_Placement_Detail__c' AND DeveloperName = 'RTS_Placement_Detail'].Id;
        // Create test data for RTS_Placement_Detail__c - 1
        RTS_Placement_Detail__c detailInstance1 = new RTS_Placement_Detail__c(
            RTS_Placement__c = placementInstance.Id,
            RTS_Product_ID__c = inventoryInstance.Id,
            Order_Line_Status__c = 'On-hold',
            Sys_Model__c = '584',
            Expected_Ship_Date__c = Date.today().addDays(2),
            Quantity__c = 10,
            RecordTypeId = detailRTId
        );
        insert detailInstance1;

        // Create test data for RTS_Placement_Detail__c - 2
        RTS_Placement_Detail__c detailInstance2 = new RTS_Placement_Detail__c(
            RTS_Placement__c = placementInstance.Id,
            RTS_Product_ID__c = inventoryInstance.Id,
            Order_Line_Status__c = 'On-hold',
            Sys_Model__c = '584',
            Expected_Ship_Date__c = Date.today().addDays(2),
            Quantity__c = 10,
            RecordTypeId = detailRTId
        );
        insert detailInstance2;

        // Create test data for RTS_Placement_Detail__c - 3
        RTS_Placement_Detail__c detailInstance3 = new RTS_Placement_Detail__c(
            RTS_Placement__c = placementInstance.Id,
            RTS_Product_ID__c = inventoryInstance.Id,
            Order_Line_Status__c = 'On-hold',
            Sys_Model__c = '584',
            Expected_Ship_Date__c = Date.today().addDays(2),
            Quantity__c = 10,
            RecordTypeId = detailRTId
        );
        insert detailInstance3;

        // Create test data for RTS_Placement_Detail__c - 4
        RTS_Placement_Detail__c detailInstance4 = new RTS_Placement_Detail__c(
            RTS_Placement__c = placementInstance.Id,
            RTS_Product_ID__c = inventoryInstance.Id,
            Order_Line_Status__c = System.Label.RTS_request_cancel,
            Sys_Model__c = '584',
            Expected_Ship_Date__c = Date.today().addDays(2),
            Quantity__c = 10,
            RecordTypeId = detailRTId
        );
        insert detailInstance4;

        List<Id> listSelectedIds = new List<Id>{
            detailInstance2.Id,
            detailInstance3.Id
        };

        List<SelectOption> listItems;
        List<SelectOption> listSubItems;

        System.Test.startTest();
            System.Test.setCurrentPage(Page.RTS_OrderStatusDisplayPage);
            ApexPages.currentPage().getParameters().put('selectTab', 'name1');
            RTS_OrderStatusDisplayPageController controller = new RTS_OrderStatusDisplayPageController();
            System.debug(controller.lstWrapOnHoldRequestCancel);
            System.runAs(createUser(67)) {     // DC 1.1 - added runAs(user)
                RTS_OrderStatusDisplayPageController.getApprovedOrders(listSelectedIds, 'On-hold');
                controller.lstWrapOnHoldRequestCancel[0].isChecked = true;
                controller.subStatusPage();
                controller.expectedShipDate = Date.today();
                controller.subItems = System.Label.Outofstock;
                controller.saveSubStatus();
                controller.cancelSubStatus();
                listItems = controller.getItems();
                listSubItems = RTS_OrderStatusDisplayPageController.getsubItemsOptions();
            }
        System.Test.stopTest();

        List<RTS_Placement_Detail__c> detailList = [SELECT Id,
                                                           Order_Line_Sub_Status__c
                                                      FROM RTS_Placement_Detail__c
                                                     WHERE Id = :controller.lstWrapOnHoldRequestCancel[0].placementDetail.Id
                                                     LIMIT 1];

        System.assertEquals(System.Label.Outofstock, detailList[0].Order_Line_Sub_Status__c);

    }

    static testMethod void myUnitTest6() {

        // Create test data for Partner__c
        Partner__c partnerInstance = new Partner__c(
            Name = 'NingBo RTS',
            Partner_Status__c = 'Active',
            Type_of_Operation__c = 'RTS',
            Year_of_Incorporation__c = 2015,
            Year_Starting_Mainetti_Production__c = 2015,
            Allowed_Inventory_Types__c = 'China1;International',
            RTS_Partner_Code__c = 'NBO'
        );
        insert partnerInstance;

        // Create test data for Product__c
        Product__c productInstance = new Product__c(
            Mainetti_Model__c = '584',
            Material__c = 'METAL',
            Orderable__c = true,
            Status__c = 'Active',
            Product_Description__c = 'Test metallic product of model 584',
            Product_Type__c = 'ACCESSORIES',
            Product_Family__c = 'CLIP'
        );
        insert productInstance;

        // Create test data for RTS_Product_Inventory__c
        RTS_Product_Inventory__c inventoryInstance = new RTS_Product_Inventory__c(
            Model__c = productInstance.Id,
            Net_Weight__c = 12.5,
            UOM__c = 'PC',
            Box_Qty__c = 12,
            Color__c = 'BLK',
            Local_System_SKU__c = 'TEST-1234',
            Add_on__c = 'BLACK FOAM'
        );
        insert inventoryInstance;

        // Create test data for Ship_Bill_Address__c
        Ship_Bill_Address__c billAddressInstance = new Ship_Bill_Address__c(
            Address_1__c = 'Test Street 1',
            Address_2__c = 'Test Avenue 2',
            Bill_Ship_Status__c = 'Active',
            City__c = 'Test City',
            State__c = 'Test State',
            Country__c = 'Test Country',
            Postcode__c = '123456',
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Ship_Bill_Address__c' AND DeveloperName = 'Bill_To'].Id
        );
        insert billAddressInstance;

        // Create test data for Ship_Bill_Address__c
        Ship_Bill_Address__c shipAddressInstance = new Ship_Bill_Address__c(
            Address_1__c = 'Test Street 1',
            Address_2__c = 'Test Avenue 2',
            Bill_Ship_Status__c = 'Active',
            City__c = 'Test City',
            State__c = 'Test State',
            Country__c = 'Test Country',
            Postcode__c = '123456',
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Ship_Bill_Address__c' AND DeveloperName = 'Ship_To'].Id
        );
        insert shipAddressInstance;

        // Create test data for RTS_Placement__c
        RTS_Placement__c placementInstance = new RTS_Placement__c(
            Bill_To__c = billAddressInstance.Id,
            Ship_To__c = shipAddressInstance.Id,
            Customer_Comments__c = 'Test customer placement comment',
            Expected_Ship_Date__c = Date.today().addDays(2),
            Inventory_Type__c = 'China1',
            Placement_Date__c = Date.today().addDays(-1),
            Order_To_Company__c = partnerInstance.Id,
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'RTS_Placement__c' AND DeveloperName = 'Original_Placement_Order'].Id
        );
        insert placementInstance;

        Id detailRTId = [SELECT Id FROM RecordType WHERE SObjectType = 'RTS_Placement_Detail__c' AND DeveloperName = 'RTS_Placement_Detail'].Id;
        // Create test data for RTS_Placement_Detail__c - 1
        RTS_Placement_Detail__c detailInstance1 = new RTS_Placement_Detail__c(
            RTS_Placement__c = placementInstance.Id,
            RTS_Product_ID__c = inventoryInstance.Id,
            Order_Line_Status__c = 'On-hold',
            Sys_Model__c = '584',
            Expected_Ship_Date__c = Date.today().addDays(2),
            Quantity__c = 10,
            RecordTypeId = detailRTId
        );
        insert detailInstance1;

        // Create test data for RTS_Placement_Detail__c - 2
        RTS_Placement_Detail__c detailInstance2 = new RTS_Placement_Detail__c(
            RTS_Placement__c = placementInstance.Id,
            RTS_Product_ID__c = inventoryInstance.Id,
            Order_Line_Status__c = 'On-hold',
            Sys_Model__c = '584',
            Expected_Ship_Date__c = Date.today().addDays(2),
            Quantity__c = 10,
            RecordTypeId = detailRTId
        );
        insert detailInstance2;

        // Create test data for RTS_Placement_Detail__c - 3
        RTS_Placement_Detail__c detailInstance3 = new RTS_Placement_Detail__c(
            RTS_Placement__c = placementInstance.Id,
            RTS_Product_ID__c = inventoryInstance.Id,
            Order_Line_Status__c = 'On-hold',
            Sys_Model__c = '584',
            Expected_Ship_Date__c = Date.today().addDays(2),
            Quantity__c = 10,
            RecordTypeId = detailRTId
        );
        insert detailInstance3;

        // Create test data for RTS_Placement_Detail__c - 4
        RTS_Placement_Detail__c detailInstance4 = new RTS_Placement_Detail__c(
            RTS_Placement__c = placementInstance.Id,
            RTS_Product_ID__c = inventoryInstance.Id,
            Order_Line_Status__c = System.Label.RTS_request_cancel,
            Sys_Model__c = '584',
            Expected_Ship_Date__c = Date.today().addDays(2),
            Quantity__c = 10,
            RecordTypeId = detailRTId
        );
        insert detailInstance4;

        List<Id> listSelectedIds = new List<Id>{
            detailInstance2.Id,
            detailInstance3.Id
        };

        List<SelectOption> listItems;
        List<SelectOption> listSubItems;

        System.Test.startTest();
            System.runAs(createUser(78)) {     // DC 1.1 - added runAs(user)
                System.Test.setCurrentPage(Page.RTS_OrderStatusDisplayPage);
                ApexPages.currentPage().getParameters().put('selectTab', 'name1');
                RTS_OrderStatusDisplayPageController controller = new RTS_OrderStatusDisplayPageController();
                System.debug(controller.lstWrapOnHoldRequestCancel);
                RTS_OrderStatusDisplayPageController.getApprovedOrders(listSelectedIds, 'On-hold');
                controller.lstWrapOnHoldRequestCancel[0].isChecked = true;
                controller.rejectReasonPage();
                controller.rejectReason = 'test rejection reason!';
                controller.saveRejectReason();
                controller.cancelSubStatus();
                listItems = controller.getItems();
                listSubItems = RTS_OrderStatusDisplayPageController.getsubItemsOptions();
            }
        System.Test.stopTest();
    }
}