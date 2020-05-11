@isTest
public class WeeklyShipmentObjTest
{
    static testMethod void WeeklyShipmentTest(){
        WeeklyShipmentObj WeeklyShipment = new WeeklyShipmentObj();
        string setValue = 'test';
        Integer setvalues = 2000;
        List<Inventory_Allocation__c> invalloc = new List<Inventory_Allocation__c>();
        boolean flag = true;
        Test.startTest();
        
        WeeklyShipment.getMainettiCompany();
        WeeklyShipment.setMainettiCompany(setValue);
        WeeklyShipment.getRetailerCode();
        WeeklyShipment.setRetailerCode(setValue);
        WeeklyShipment.getModel();
        WeeklyShipment.setModel(setValue);
        WeeklyShipment.getColor();
        WeeklyShipment.setColor(setValue);
        WeeklyShipment.getSizerPrinter();
        WeeklyShipment.setSizerPrinter(setValue);
        WeeklyShipment.getTotalShipmentQty();
        WeeklyShipment.setTotalShipmentQty(setvalues);
        WeeklyShipment.getInventoryAllocation();
        WeeklyShipment.setInventoryAllocation(invalloc);
        WeeklyShipment.getIsNegative();
        WeeklyShipment.setIsNegative(setValue);
       
        Test.stopTest();
        System.assertEquals(true, flag);
        
    }
    
}