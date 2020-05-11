/**
 *  @description : Apex test class for RTS_MangeAllPlacementDetailsController
 *  @author : DC
 *  @revision :
 *      * 04Dec2015 1.0     @comment : Created
 *      * 30Dec2015 1.1     @comment : Updated test code to run as a specific user
 */
@isTest
private class RTS_MangeAllPlacementDetailsCtrlTest {

    static testMethod void unitTest() {

        // DC 1. - Created user data for testing.
        Profile profInstance = [select id from profile where name='Mainetti - User S6'];
        User userInstance = new User(alias = 'stand', email='standarduser@testorg.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = profInstance.Id, 
            timezonesidkey='America/Los_Angeles', username='standarduser100@testorg.com',
            Inventory_Type__c = 'China1; China2; International');

        // DC 1.1 - added runAs for testing
        System.runAs(userInstance) {
            //Create test data for Partner
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

            //Create test data for RTS Product Inventory
            RTS_Product_Inventory__c testProductInventory = new RTS_Product_Inventory__c();
            testProductInventory.Local_System_SKU__c = 'test';
            insert testProductInventory;
        
            // DC 1.1 - Updated data creation for RTS Placement
            //Create test data for RTS Placement
            RTS_Placement__c oTestPlacement = new RTS_Placement__c(
                Customer_Comments__c = 'Test customer placement comment',
                Expected_Ship_Date__c = Date.today().addDays(2),
                Inventory_Type__c = 'China1',
                Placement_Date__c = Date.today().addDays(-1),
                Order_To_Company__c = partnerInstance.Id,
                RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'RTS_Placement__c' AND DeveloperName = 'Original_Placement_Order'].Id
            );
            insert oTestPlacement;
        
            //Create test data for RTS Placement Detail
            RTS_Placement_Detail__c testPlacementDetail = new RTS_Placement_Detail__c();
            testPlacementDetail.RTS_Placement__c = oTestPlacement.Id;
            testPlacementDetail.RTS_Product_ID__c = testProductInventory.Id;
            testPlacementDetail.Order_Line_Status__c = 'test';
            insert testPlacementDetail;
        
            System.test.startTest();
            
                //Create instance of Product Inventory List
                List<RTS_Product_Inventory__c> testInventoryList = new List<RTS_Product_Inventory__c>();
                testInventoryList.add(testProductInventory);
            
                //Create instance of Standard Set Controller
                ApexPages.StandardSetController objStdSetCtrl = new ApexPages.StandardSetController(testInventoryList);
            
                //Set current Page Reference with Placement Id
                System.Test.setCurrentPageReference(Page.RTS_MangeAll_RTSPlacementDetails);
                ApexPages.currentPage().getParameters().put('id', oTestPlacement.Id);
            
                //Controller instance
                RTS_MangeAllPlacementDetailsController oRTS_MangeAllPlacementDetailsController = new RTS_MangeAllPlacementDetailsController(objStdSetCtrl);
                List<SelectOption> colorOptionsList = oRTS_MangeAllPlacementDetailsController.colorOptions;
                List<SelectOption> logoOptionsList = oRTS_MangeAllPlacementDetailsController.logoOptions;
                oRTS_MangeAllPlacementDetailsController.available = true;
            
                //ASI_KOR_ComponentInterface objInterface;
                //ASI_KOR_SFObjSelectTableController objTableController = new ASI_KOR_SFObjSelectTableController();
                ASI_KOR_MassCreateAndUpdateController objMassController = new ASI_KOR_MassCreateAndUpdateController();
                objMassController.sObjTypeStr = 'RTS_Placement_Detail__c';
                objMassController.displayFieldsStr = 'RTS_Product_ID__c&read=A,Sys_Model__c&read=A,Quantity__c&req=T,Remark__c&req=F,Expected_Ship_Date__c&req=F';
                objMassController.isUseFirstRowForNew = false;
                // objMassController.whereStatm = 'RTS_Placement__c = \'' +  + '\'';
            
                objMassController.init();
            
                oRTS_MangeAllPlacementDetailsController.modelName = 'test';
                oRTS_MangeAllPlacementDetailsController.selectedLogo = 'test';
                oRTS_MangeAllPlacementDetailsController.selectedColor = 'test';
            
                //oRTS_MangeAllPlacementDetailsController.setComponentController('selectTable', objTableController);
                oRTS_MangeAllPlacementDetailsController.setComponentController('massCreateAndUpdate', objMassController);
                //oRTS_MangeAllPlacementDetailsController.setComponentController(objTableController);
                ASI_KOR_ComponentInterface interfaceTest2 = oRTS_MangeAllPlacementDetailsController.getComponentController();
                ASI_KOR_ComponentInterface interfaceTest1 = oRTS_MangeAllPlacementDetailsController.getComponentController('selectTable');
                oRTS_MangeAllPlacementDetailsController.mcau_initPageBlockActionButtonList();
            
                List<ASI_KOR_SFObjSelectTableController.SFObjSelectTableActionBtn> testListTableActionBtn = 
                                                    oRTS_MangeAllPlacementDetailsController.sobjst_initActionButtonList();
                Map<ID, Map<String, Integer>> testMap = oRTS_MangeAllPlacementDetailsController.sobjst_initActionButtonStageMap();
                oRTS_MangeAllPlacementDetailsController.mcau_triggerPageBlockAction(new ASI_KOR_MassCreateAndUpdateController(), 'test');
            
                oRTS_MangeAllPlacementDetailsController.FilterMoulds();
                //
                oRTS_MangeAllPlacementDetailsController.sobjst_triggerActionForSObject(new ASI_KOR_SFObjSelectTableController(),
                                                                                   'add', 
                                                                                   testInventoryList[0]);
                /*                                                                      
                oRTS_MangeAllPlacementDetailsController.mcau_triggerActionForSObject(new ASI_KOR_MassCreateAndUpdateController(), 
                                                                                     'remove_new', 
                                                                                     testPlacementDetail);
                */            
            System.test.stopTest();
        }
    }
}