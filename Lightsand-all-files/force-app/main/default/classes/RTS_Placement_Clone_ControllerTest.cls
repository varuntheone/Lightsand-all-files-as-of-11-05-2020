/**
 * Description : Apex test class for RTS_Placement_Clone_Controller
 */
@isTest
private class RTS_Placement_Clone_ControllerTest {

    //Test method to test cloneWithItems method
    static testMethod void cloneWithItemsTest() {
        // TO DO: implement unit test
        
        //Create test data for RTS Product Inventory
        RTS_Product_Inventory__c testProductInventory = new RTS_Product_Inventory__c();
        testProductInventory.Local_System_SKU__c = 'test';
        insert testProductInventory;
        
        //Create test data for RTS Placement
        RTS_Placement__c oTestPlacement = new RTS_Placement__c();
        insert oTestPlacement;
        
        //Create test data for RTS Placement Detail
        RTS_Placement_Detail__c testPlacementDetail = new RTS_Placement_Detail__c();
        testPlacementDetail.RTS_Placement__c = oTestPlacement.Id;
        testPlacementDetail.RTS_Product_ID__c = testProductInventory.Id;
        testPlacementDetail.Order_Line_Status__c = 'test';
        insert testPlacementDetail;
        
        System.test.startTest();
        
            //Create instance of Standard controller 
            ApexPages.StandardController objStdCtrl = new ApexPages.StandardController(oTestPlacement); 

            System.Test.setCurrentPageReference(Page.RTS_Placement_Clone_Page);
            ApexPages.currentPage().getParameters().put('id', oTestPlacement.Id);
            
            RTS_Placement_Clone_Controller oRTS_Placement_Clone_Controller = new RTS_Placement_Clone_Controller(objStdCtrl);
            oRTS_Placement_Clone_Controller.cloneWithItems();
            System.assertEquals(2, [select Id from RTS_Placement__c].size());
                        
        System.test.stopTest();
    }
}