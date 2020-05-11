public class TransferNoteInformationPrint {
    
    string transferNoteId {get;set;}
    public TransferNoteInformationPrint(ApexPages.StandardController stdController) {
       this.transferNoteId =  stdController.getId();

    }
    /*public TransferNoteInformationPrint(){
       transferNoteId = ApexPages.currentPage().getParameters().get('dnId');
    } */
    
    Public class  TransferNoteWrapper{
        Public Transfer_Note__c transferNote {get;set;}
        public List<Carton_Details__c> cartonsList {get;set;}
    }
    
    Public TransferNoteWrapper getTransferNoteInformation(){
    
    TransferNoteWrapper TNote = new TransferNoteWrapper();
    
        Transfer_Note__c dr = [select id,name,QR_Code__c,Status__c,Warehouse_City__c,Warehouse_Contact__c ,Document_Date__c,Total_Carton_Send__c,Warehouse_Name__c,Warehouse_Address1__c,Warehouse_Fax__c,Warehouse_Country__c,Warehouse_Email__c,Customer_Warehouse_Name__c,Customer_Address__c,Customer_City__c,Customer_Contact__c,Customer_Country__c,Customer_Email__c,Customer_Telephone__c,Customer_Warehouse__c,Customer_Warehouse__r.Name,
                                        Warehouse_Tel__c,Retailer_Code__r.Name,Remark__c,Customer_Fax__c  from  Transfer_Note__c where id =: transferNoteId];
        List<Carton_Details__c> crList = [select id,Name,Status__c,QR_Code__c,Registered_Date__c from Carton_Details__c where Transfer_Note__c =: transferNoteId];
        
        TNote.transferNote = dr;
        TNote.cartonsList = crList;
    
    return TNote;
    } 
}