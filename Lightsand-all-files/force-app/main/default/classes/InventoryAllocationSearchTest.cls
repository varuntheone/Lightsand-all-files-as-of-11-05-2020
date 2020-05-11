@isTest
public class InventoryAllocationSearchTest {
    @isTest
     static void getAllocationResults()
    {
        String enteredValue = 'G';
        InventoryAllocationSearchApex.fetchLookupRetailerdataList(enteredValue);
        InventoryAllocationSearchApex.fetchLookupProductdataList(enteredValue);
        InventoryAllocationSearchApex.fetchLookupMainettidataList(enteredValue);
        InventoryAllocationSearchApex.getWarehouseMap();
    }

}