public class PrintCartonQRcode {
    
    public List<Carton_Details__c> cartonList {get;set;}
    public List<Carton_Details__c> selectedCartonList = new List<Carton_Details__c>();
    
    
    public PrintCartonQRcode(Apexpages.Standardsetcontroller ssc){
        set<Id> cartonIdSet = new set<Id>();
        selectedCartonList = (List<Carton_Details__c>)ssc.getSelected();
        system.debug('---1-->'+selectedCartonList);
        for(Carton_Details__c carton : selectedCartonList){
            cartonIdSet.add(carton.Id);  
        }
        
        cartonList = [select id,Name,QR_Code__c,Status__c,Owner_Warehouse_Name__c,Registered_Date__c from Carton_Details__c where Id IN : cartonIdSet];
        //cartonList = [select id,Name,QR_Code__c,Status__c,Owner_Warehouse_Name__c,Registered_Date__c from Carton_Details__c where Id =: 'a1Sp0000000rENpEAM'];
        
        
    }  
    
    
        
    public void updateCartonStatus() {        
        if(!cartonList.isEmpty()){
            List<Carton_Details__c> updateCartonStatusList = new List<Carton_Details__c>();
            for(Carton_Details__c carton : cartonList){
                if(carton.Status__c == 'New'){
                    //carton.Status__c = 'Printed';
                    carton.Status__c = 'Active';
                    updateCartonStatusList.add(carton);
                }                
            }
            
            if(!updateCartonStatusList.isEmpty()){
                update updateCartonStatusList;
            } 
        }              
    }
    
}