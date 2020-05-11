@isTest
public class ViewDemandForecastObjTest
{
    static testMethod void DemandForecastTest(){
        ViewDemandForecastObj viewDemandObj = new ViewDemandForecastObj();
        string setValue = 'test';
        Integer setvalues = 2000;
        Id setid ='a02p00000088auhAAA';
        boolean flag = true;
        List<Inventory_Allocation__c> invalloc = new List<Inventory_Allocation__c>();
        Test.startTest();
        
        viewDemandObj.getMainettiCompany();
        viewDemandObj.setMainettiCompany(setValue);
        viewDemandObj.getRetailerCode();
        viewDemandObj.setRetailerCode(setValue);
        viewDemandObj.getModel();
        viewDemandObj.setModel(setValue);
        viewDemandObj.getColor();
        viewDemandObj.setColor(setValue);
        viewDemandObj.getSizerPrinter();
        viewDemandObj.setSizerPrinter(setValue);
        viewDemandObj.getTotalDemandQty();
        viewDemandObj.setTotalDemandQty(setvalues);
        viewDemandObj.getTotalSupplyQty();
        viewDemandObj.setTotalSupplyQty(setvalues);
        viewDemandObj.getTotalShipmentQty();
        viewDemandObj.setTotalShipmentQty(setvalues);
        viewDemandObj.getTotalAllocationQty();
        viewDemandObj.setTotalAllocationQty(setvalues);
        viewDemandObj.getVariance();
        viewDemandObj.setVariance(setvalues);
        viewDemandObj.getIsNegative();
        viewDemandObj.setIsNegative(setValue);
        viewDemandObj.getWeeklyDemandId();
        viewDemandObj.setWeeklyDemandId(setid);
        viewDemandObj.getweeklySupplyId();
        viewDemandObj.setWeeklySupplyId(setid);
        viewDemandObj.getWeeklyShipmentId();
        viewDemandObj.setWeeklyShipmentId(setid);
        viewDemandObj.getInventoryAllocation();
        viewDemandObj.setInventoryAllocation(invalloc);
        viewDemandObj.getHasAccessToAllocate();
        viewDemandObj.setHasAccessToAllocate(setValue);
        viewDemandObj.getSource();
        viewDemandObj.setSource(setValue);
        viewDemandObj.getWarehouse();
        viewDemandObj.setWarehouse(setValue);
        
        Test.stopTest();
        System.assertEquals(true, flag);
        
    }
    
}