/**
 *  @description : Apex test class for RTS_OrderStatusDisplayPageController
 *  @author : DC
 *  @revision :
 *      * 07Dec2015 1.0     @comment : Created
 *      * 11Jan2016 1.1     @comment : Updated test data to insert Partner__c records.
 */

@isTest
private class RTS_OrderStatusPageSubstatusCtrlTest {

    static testMethod void testOrdersRetrieval() {

        // DC 1.1 - Inserting Partner Data
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
            Order_To_Company__c = partnerInstance.Id, // DC 1.1 - Populated Lookup to Partner
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
            RTS_OrderStatusPageSubstatusController subStatusCtrl = new RTS_OrderStatusPageSubstatusController();
            subStatusCtrl.getItems();
            RTS_OrderStatusPageSubstatusController.getsubItems();
            PageReference subStatusPageRef = subStatusCtrl.substatusPage();
            subStatusCtrl.closedMessage();
        System.Test.stopTest();
        
        System.assertEquals('/apex/RTS_Showsubstatus', subStatusPageRef.getUrl());
    }
    
    static testMethod void testGetApprovedOrders() {

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
            Order_To_Company__c = partnerInstance.Id, // DC 1.1 - Populated Lookup to Partner
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
            placementInstance.Id
        };

        List<SelectOption> listItems;
        List<SelectOption> listSubItems;

        System.Test.startTest();
            RTS_OrderStatusPageSubstatusController subStatusCtrl = new RTS_OrderStatusPageSubstatusController();
            map<Id,list<string>> returnValue 
                = RTS_OrderStatusPageSubstatusController.getApprovedOrders1(listSelectedIds, 'Save', null, null, new List<String>{'Remark1'});
        System.Test.stopTest();
        
        Set<String> statusList = new Set<String>();
        statusList.addAll(returnValue.get(placementInstance.Id));
        
        // Check success
        System.assert(statusList.contains('true'));
    }
    
    static testMethod void testGetApprovedOrdersNegative() {

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
            Order_To_Company__c = partnerInstance.Id, // DC 1.1 - Populated Lookup to Partner
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

        List<SelectOption> listItems;
        List<SelectOption> listSubItems;

        System.Test.startTest();
            RTS_OrderStatusPageSubstatusController subStatusCtrl = new RTS_OrderStatusPageSubstatusController();
            subStatusCtrl.wrapOnHold = '';
            subStatusCtrl.substatusPage = '';
            RTS_OrderStatusPageSubstatusController.showError= false;
            map<Id,list<string>> returnValue 
                = RTS_OrderStatusPageSubstatusController.getApprovedOrders1(null, 'Save', null, null, null);
        System.Test.stopTest();
        
        // Check method returns null
        System.assertEquals(null, returnValue);
    }
}