/*****************************************************************
Purpose: Relase of Second Europe Carton process
Related Class Name : CartonDetailsTriggerHandler , CartonDetailsTrigger , 
Updated Date :5/2/2020                      
*****************************************************************/


@isTest
public class RTSTriggerHandlerTest {
    
    public static Id recordTypeofcompany = Schema.SObjectType.Partner__c.getRecordTypeInfosByName().get('Mainetti Company').getRecordTypeId();
     public static Id rtOfAsiaCartons = Schema.SObjectType.Carton_Details__c.getRecordTypeInfosByName().get('Asia Carton').getRecordTypeId();
    public static Id rtOfEuropeCartons = Schema.SObjectType.Carton_Details__c.getRecordTypeInfosByName().get('Europe Carton').getRecordTypeId();
   
    Public static TestMethod void transferNoteTriggerTest(){
        
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
        carton.RecordTypeId = rtOfAsiaCartons;
        cartonList.add(carton);
        
        insert cartonList;
        
        tfn.Status__c = 'Closed';
        update tfn;
        
        tfn.Warehouse_ID__c = null;
        update tfn;
    }
    
    
    
    Public static TestMethod void cartonDetailsAuromationTest(){
        
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
        carton.RecordTypeId = rtOfAsiaCartons;
        cartonList.add(carton); 
        
        Carton_Details__c cart = new Carton_Details__c();
        cart.Status__c = 'Active';
        cart.Owner_Warehouse_ID__c = partner.id;
        cart.RecordTypeId = rtOfEuropeCartons;
        cart.Transfer_Note__c = tfn.id;
        cart.How_Many_Cartons__c = 2;
        cartonList.add(cart); 
        
        insert cartonList;
        
        carton.Status__c = 'Empty Box in Transit';        
        update carton;
        
        carton.Status__c = 'Customer Warehouse';
        update carton;
        
        carton.Status__c = 'Filling in Progress';
        carton.Store_User__c = store.id;
        cart.Status__c = 'Filling in Progress';
        cart.Store_User__c = store.id;
        update carton;
        update cart;
        
        carton.Status__c = 'Active';
        cart.Status__c = 'Active';
        update carton; 
        update cart;
    }
}