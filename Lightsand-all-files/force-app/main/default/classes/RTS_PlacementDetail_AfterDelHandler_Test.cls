/**
 *  @author         : DC
 *  @LastModified   : 12/03/2015
 *  @Comment        : Initial draft. Test Class for RTS_PlacementDetail_AfterDeleteHandler
 */
@isTest
public class RTS_PlacementDetail_AfterDelHandler_Test {

    public static testMethod void statusCheckBeforeDeleteTest() {
        
        //Create test data for RTS Product Inventory
        RTS_Product_Inventory__c testProductInventory = new RTS_Product_Inventory__c();
        testProductInventory.Local_System_SKU__c = 'test';
        insert testProductInventory;
        
        //Create test data for RTS Placement
        RTS_Placement__c testPlacement = new RTS_Placement__c();
        insert testPlacement;
        
        //Create test data for RTS Placement Detail
        RTS_Placement_Detail__c testPlacementDetail = new RTS_Placement_Detail__c();
        testPlacementDetail.RTS_Placement__c = testPlacement.Id;
        testPlacementDetail.RTS_Product_ID__c = testProductInventory.Id;
        testPlacementDetail.Order_Line_Status__c = 'test';
        insert testPlacementDetail;
        
        system.Test.startTest();
            try{
                delete testPlacementDetail;
            }
            catch(DmlException oException){
            	List<RTS_Placement_Detail__c> testList = [Select Id from RTS_Placement_Detail__c where Order_Line_Status__c = 'test'];
                System.assertEquals('test', [select Order_Line_Status__c from RTS_Placement_Detail__c where Order_Line_Status__c = 'test'][0].Order_Line_Status__c);
            }
        system.Test.stopTest();
    }
    
    //Create test data for RTS Product Inventory
    
    //Create test data for RTS Placement
}