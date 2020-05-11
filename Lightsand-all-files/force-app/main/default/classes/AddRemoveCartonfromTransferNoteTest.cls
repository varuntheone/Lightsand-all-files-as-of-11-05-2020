/*****************************************************************
Purpose: Relase of Second Europe Carton process and Automation process 
Related Class Name : AddRemoveCartonfromTransferNote 
Updated Date :5/2/2020                      
*****************************************************************/

@isTest
public class AddRemoveCartonfromTransferNoteTest {
    public static Id recordTypeofcompany = Schema.SObjectType.Partner__c.getRecordTypeInfosByName().get('Mainetti Company').getRecordTypeId();
     public static Id rtOfAsiaCartons = Schema.SObjectType.Carton_Details__c.getRecordTypeInfosByName().get('Asia Carton').getRecordTypeId();
    public static Id rtOfEuropeCartons = Schema.SObjectType.Carton_Details__c.getRecordTypeInfosByName().get('Europe Carton').getRecordTypeId();
   
    Public static TestMethod void cartonDetailsTest(){
        
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
        
        List<String> cartonIds = new List<String>();
        cartonIds.add(carton.id);
		
        AddRemoveCartonfromTransferNote.getActiveCartonsNoTFNote(tfn.id);
        AddRemoveCartonfromTransferNote.getActiveCartonswithTFNote(tfn.id);
        AddRemoveCartonfromTransferNote.getcartonDetailsAddress(carton.Id);
        AddRemoveCartonfromTransferNote.getTransferNoteData(tfn.id);
        AddRemoveCartonfromTransferNote.updateAllCartonStatus(tfn.id,'Printed');
        AddRemoveCartonfromTransferNote.getcartonRecordData(carton.Id);
        AddRemoveCartonfromTransferNote.addCartonfromTransferNote(carton.Id);
        AddRemoveCartonfromTransferNote.CartonStatusAutomation(carton.Id);
        AddRemoveCartonfromTransferNote.getPickListValues('Carton_Details__c','Status__c');
        AddRemoveCartonfromTransferNote.getUserInformation();
        AddRemoveCartonfromTransferNote.updatecartonTransferNotefield(tfn.id,cartonIds);
        AddRemoveCartonfromTransferNote.removeCartonFromTransferNote(carton.Id);
        AddRemoveCartonfromTransferNote.transferNoteStatusAutomation(tfn.id);
        
    }  
   
}