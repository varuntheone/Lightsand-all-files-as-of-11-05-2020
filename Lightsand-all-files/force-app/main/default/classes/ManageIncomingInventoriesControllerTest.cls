/** Test class for ManageIncomingInventoriesController.
 */
@isTest
private class ManageIncomingInventoriesControllerTest {

    static testMethod void ManageIncomingInventoriesContTest() {
        
        //Creating Test Data for Product
        List<Product__c> lstProducts = ManageIncomingInventoriesControllerTest.createDummyProducts(1);
        insert lstProducts;
        
        //Creating Test Data for RTS_Product_Inventory
        List<RTS_Product_Inventory__c> lstProductInvts = 
                         ManageIncomingInventoriesControllerTest.createDummyRTSProductInvntry(1, lstProducts);
        insert lstProductInvts;
        
        //Creating Test Data for RTS_Product_Inv_Detail__c
        List<RTS_Product_Inv_Detail__c> lstProductInvtDetails = 
                         ManageIncomingInventoriesControllerTest.createDummyRTS_ProductInvDetails(5, lstProductInvts);
        insert lstProductInvtDetails;
        
        //Starting Test
        System.Test.StartTest();
            //Setting current Page;        
            PageReference myVfPage = Page.ManageIncomingInventories;
            System.Test.setCurrentPage(myVfPage);
            
            ManageIncomingInventoriesController mngIncInvCtrl = new ManageIncomingInventoriesController();
            mngIncInvCtrl.getbatchIdList();
            mngIncInvCtrl.batchId = lstProductInvtDetails[0].Lot_No__c;
            PageReference confirmPR = mngIncInvCtrl.confirmUpdate();
            system.assertEquals(confirmPR, null);
            
            PageReference deletePR = mngIncInvCtrl.deleteRecord();
            system.assertEquals(mngIncInvCtrl.detailsList.size(), 0);
            system.assertEquals(deletePR, null);
                       
            mngIncInvCtrl.batchId = '';
            mngIncInvCtrl.searchQuery();
                
        System.Test.StopTest();
         
        
    }//End ManageIncomingInventoriesCont method
    
    
    //The method will create dummy records of Product
    public static List<Product__c> createDummyProducts(Integer pCount){
        List<Product__c> lstTempProducts = new List<Product__c>();
        for(Integer index = 0; index < pCount; index ++){
            lstTempProducts.add(new Product__c(Mainetti_Model__c = '58' + index,
                                               Material__c = 'METAL',
                                               Orderable__c = true,
                                               Status__c = 'Active',
                                               Product_Description__c = 'Test metallic product of model 584',
                                               Product_Type__c = 'ACCESSORIES',
                                               Product_Family__c = 'CLIP'));
            
        }//End for
        return lstTempProducts;
    }//End createDummyProducts method
    
    
    //The method will create dummy records of RTS Product Inventory
    public static List<RTS_Product_Inventory__c> createDummyRTSProductInvntry(Integer pCount, 
                                                                              List<Product__c> pLstProducts){
        List<RTS_Product_Inventory__c> lstTempRTS_ProdInvntry = new List<RTS_Product_Inventory__c>();
        
        for(Integer index = 0; index < pCount; index ++){
            lstTempRTS_ProdInvntry.add(new RTS_Product_Inventory__c(Model__c = pLstProducts[index].Id,
                                                                    Net_Weight__c = 12.5 + index,
                                                                    UOM__c = 'PC',
                                                                    Box_Qty__c = 12 + index,
                                                                    Color__c = 'BLK',
                                                                    Local_System_SKU__c = 'TEST-123' + index,
                                                                    Add_on__c = 'BLACK FOAM'));
        } //End for
        return lstTempRTS_ProdInvntry;
    }//End createDummyRTSProductInvntry method
    
    
    //The method will create dummy records of RTS Product Inventory Details
    public static List<RTS_Product_Inv_Detail__c> createDummyRTS_ProductInvDetails(Integer pCount, 
                                                                            List<RTS_Product_Inventory__c> pLstProdctInv){
        List<RTS_Product_Inv_Detail__c> lstTempRTS_ProdInvDetls = new List<RTS_Product_Inv_Detail__c>();
        for(Integer index = 0; index < pCount; index ++){
            lstTempRTS_ProdInvDetls.add(new RTS_Product_Inv_Detail__c(RTS_Product_ID__c = pLstProdctInv[0].Id,
                                                                      JDE_SKU__c = 'RGR-6212 BLK027-22' + index,
                                                                      Quantity__c = 11 + index,
                                                                      Total_Carton__c = 32 + index,
                                                                      Lot_No__c = 'B1121323' + index,
                                                                      Manager_Confirmed__c = false));
        }//End for
        return lstTempRTS_ProdInvDetls ;
    }//End createDummyRTS_ProductInvDetails method
    
}//End ManageIncomingInventoriesControllerTest Class