public class InventoryAllocationSearchApex {
    
    // Custom Lookup for Retailer data
    @AuraEnabled
    public static List<Retailer_Code__c> fetchLookupRetailerdataList(String enteredValue) {
        
        String searchKey = '%' + enteredValue + '%';
        List <Retailer_Code__c> lstOfValues = [Select Name from Retailer_Code__c where Name like : searchKey LIMIT 15];
        //system.debug('Retailer_Code__c:'+lstOfValues);
        return lstOfValues;
    }
    
     // Custom Lookup for Product data
    @AuraEnabled
    public static List<Product__c> fetchLookupProductdataList(String enteredValue) {
        
        String searchKey = '%' + enteredValue + '%';
        List <Product__c> lstOfValues = [Select Name from Product__c where Name like : searchKey LIMIT 15];        
        return lstOfValues;
    }
    
           
    // Custom Lookup for Mainetti Company data
    @AuraEnabled
    public static List<Partner__c> fetchLookupMainettidataList(String enteredValue) {
        
        String searchKey = '%' + enteredValue + '%';
        List <Partner__c> lstOfValues = [Select Default_Order_to_Company__c from Partner__c where Default_Order_to_Company__c like : searchKey and RecordType.Name IN ('Mainetti Company','Licensee Partner') and Default_Order_to_Company__c <> null LIMIT 10];
        return lstOfValues;
    } 
    
    
     @AuraEnabled 
    public static Map<String, String> getWarehouseMap(){
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Data_Upload_Transaction__c.Warehouse__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            //Put Picklist Value & Label in Map
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }
    
    
}