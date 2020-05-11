@IsTest
public class PrintCartonQRcodeTest {
    public static Id recordTypeofcompany = Schema.SObjectType.Partner__c.getRecordTypeInfosByName().get('Mainetti Company').getRecordTypeId();
    Public static TestMethod void tfPringTest(){
        
        Partner__c partner = new Partner__c();
        partner.Name = 'Mainetti (HK) Ltd';
        partner.RecordTypeId = recordTypeofcompany;        
        insert partner;
        
        Retailer_Code__c rcode = new Retailer_Code__c();
        rcode.Name = 'MACYS';
        insert rcode;
        List<Customer_Warehouse__c> cwList = new List<Customer_Warehouse__c>();
        Customer_Warehouse__c warehouse = new Customer_Warehouse__c();
        warehouse.Name = 'MACYS0001';
        warehouse.Type__c = 'Warehouse';
        warehouse.Retailer_Code__c = rcode.id;
        cwList.add(warehouse);
        
        Customer_Warehouse__c store = new Customer_Warehouse__c();
        store.Name = 'MACYS0002';
        store.Type__c = 'Store';
        store.Retailer_Code__c = rcode.id;
        cwList.add(store);
        
        Insert cwList;
        
        Transfer_Note__c tfn = new Transfer_Note__c();
        tfn.Retailer_Code__c = rcode.id;
        tfn.Warehouse_ID__c = partner.id;
        tfn.Customer_Warehouse__c =  warehouse.id;
        insert tfn;
        
        List<Carton_Details__c> cartonList = new List<Carton_Details__c>();
        
        Carton_Details__c carton = new Carton_Details__c();
        carton.Status__c = 'New';
        carton.Owner_Warehouse_ID__c = partner.id;
        carton.Transfer_Note__c = tfn.id;
        cartonList.add(carton);
        
        insert cartonList;
        PageReference pageRef = Page.BatchCartonPrint;
        pageRef.getParameters().put('Id', String.valueOf(carton.Id));
        Test.setCurrentPage(pageRef); 
        
        ApexPages.Standardsetcontroller sc = new ApexPages.Standardsetcontroller(cartonList);
        sc.setSelected(cartonList);
        PrintCartonQRcode tfp = new PrintCartonQRcode(sc);
        tfp.updateCartonStatus();
        
        
 
        
    }
}