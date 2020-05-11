public class TransferNoteTriggerHandler {
    
    
    public Static Void checkValidation(Map<ID,Transfer_Note__c> tfnewMap,Map<ID,Transfer_Note__c> tfOldMap){
        if(!tfnewMap.values().isEmpty()){
            for(Transfer_Note__c tfNote : tfnewMap.values()){
                if(tfNote.Total_Carton_Send__c <= 0 && tfNote.Status__c == 'In transit' && (tfOldMap.get(tfNote.id).Status__c == 'Cartons Adding Started' || tfOldMap.get(tfNote.id).Status__c == 'New')){
                    tfNote.addError('Please add cartons to Transfer Note and Confirm .');
                }
            }
        }   
    }
    
    public Static Void removeCartonsfromTransferNote(Map<ID,Transfer_Note__c> tfnewMap,Map<ID,Transfer_Note__c> tfOldMap){
        Set<ID> tfIdSet = new Set<ID>();        
        if(!tfnewMap.values().isEmpty()){
            for(Transfer_Note__c tfNote : tfnewMap.values()){
                if(tfOldMap.get(tfNote.id).Warehouse_ID__c != null  && tfnewMap.get(tfNote.id).Warehouse_ID__c != tfOldMap.get(tfNote.id).Warehouse_ID__c){
                  tfIdSet.add(tfNote.id);                  
                }               
            }
        }
       if(!tfOldMap.values().isEmpty()){
            for(Transfer_Note__c tfNote : tfOldMap.values()){
                if(tfOldMap.get(tfNote.id).Warehouse_ID__c == null &&  tfnewMap.get(tfNote.id).Warehouse_ID__c != null  && tfnewMap.get(tfNote.id).Warehouse_ID__c != tfOldMap.get(tfNote.id).Warehouse_ID__c){
                  tfIdSet.add(tfNote.id);                  
                }               
            }
        }
        
        if(!tfIdSet.isEmpty()){
            List<Carton_Details__c> updateCartonList = new List<Carton_Details__c>();
            List<Carton_Details__c>  cartonsList =[select id,Name,Status__c,Transfer_Note__c from Carton_Details__c  where Transfer_Note__c =: tfIdSet];
            if(!cartonsList.isEmpty()){
                for(Carton_Details__c carton : cartonsList){
                    carton.Status__c = 'Active';
                    carton.Owner_Warehouse_ID__c = null;
                    carton.Transfer_Note__c = null;
                    carton.Store_User__c = null;
                    carton.Customer_Warehouse__c = null;                    
                    updateCartonList.add(carton);
                } 
            }            
            if(!updateCartonList.isEmpty()){
                update updateCartonList;
            }
        }
        
    }
    
    public Static Void UpdateAllCartonStatus(Map<ID,Transfer_Note__c> tfnewMap,Map<ID,Transfer_Note__c> tfOldMap){
        Set<ID> tfIdSet = new Set<ID>();
        	if(!tfnewMap.values().isEmpty()){
            for(Transfer_Note__c tfNote : tfnewMap.values()){
                tfIdSet.add(tfNote.id);                  
            }
        }
        if(!tfIdSet.isEmpty()){
            List<Carton_Details__c> updateCartonList = new List<Carton_Details__c>();
            List<Transfer_Note__c> transferNoteList = [select id,Name,Status__c,Warehouse_ID__c,Customer_Warehouse__c,(select id,Name,Status__c,Owner_Warehouse_ID__c,Customer_Warehouse__c,Transfer_Note__c from Carton_Details_TN__r) from Transfer_Note__c where id IN: tfIdSet];
            for(Transfer_Note__c tfn:  transferNoteList){
                if(tfn.Carton_Details_TN__r.size() > 0){
                    for(Carton_Details__c carton : tfn.Carton_Details_TN__r){
                        if(tfOldMap.containsKey(tfn.id)){
                            if(tfn.Status__c == 'In transit' && tfOldMap.get(tfn.id).Status__c != 'In transit'){
                                carton.Status__c = 'Empty Box in Transit';
                                updateCartonList.add(carton);
                            }
                            system.debug('---inside tf note--->'+tfn.Status__c+'--old--->'+tfOldMap.get(tfn.id).Status__c);
                            if(tfn.Status__c == 'Closed' && tfOldMap.get(tfn.id).Status__c != 'Closed'){
                                carton.Status__c = 'Customer Warehouse';
                                carton.Owner_Warehouse_ID__c = tfn.Warehouse_ID__c;
                                carton.Customer_Warehouse__c = tfn.Customer_Warehouse__c;
                                updateCartonList.add(carton);
                            }          
                        }
                    }  
                }                
            }   
            system.debug('--updateCartonList-->'+updateCartonList);
            if(!updateCartonList.isEmpty()){
                update updateCartonList;
            } 
        }        
    }
    
    Public Static Void updateTransferNoteData(Map<ID,Transfer_Note__c> tfnewMap,Map<ID,Transfer_Note__c> tfOldMap){
        for(Transfer_Note__c transferNote: tfnewMap.values()){
            if(tfOldMap.get(transferNote.id).Status__c == 'New' && tfOldMap.get(transferNote.id).Total_Carton_Send__c == 0 && tfnewMap.get(transferNote.id).Total_Carton_Send__c > 0){
                transferNote.Status__c = 'Cartons Adding Started';
            }
           if(transferNote.Status__c == 'Cartons Adding Started'){
                transferNote.Cartons_Added_By__c  = UserInfo.getUserId();
            }                       
        }                
    }
    
    
    /* comment this functionality not required for transfer note
    public static void createTrackerRecord(Map<ID,Transfer_Note__c> tfnewMap , Map<ID,Transfer_Note__c> tfOldMap){
        for(Transfer_Note__c tNote: tfnewMap.values()){
            if(tfOldMap.containsKey(tNote.id)){
                if(tfOldMap.get(tNote.id).Status__c == 'In transit' && tfnewMap.get(tNote.id).Status__c == 'Closed'){
                     Tracker__c track = new Tracker__c();
                    track.Transfer_Note__c = tNote.id;             
                    track.Type__c = 'Transfer Note';
                    track.Warehouse_ID__c = tNote.Warehouse_ID__c;
                    track.Registered_Document_Date__c = tNote.Document_Date__c;
                    //track.Tracking_Goods_Loaded_By__c = tNote.Tracking_Goods_Loaded_By__c;
                    insert track;
                    // Reset transfer Note Information
                    tNote.Warehouse_ID__c = null;
                    tNote.Retailer_Code__c = null;
                    tNote.Customer_Warehouse__c = null;
                    tNote.Document_Date__c = null;
                    tNote.Status__c = 'Closed';
                }
            }   
        }
    }  */

}