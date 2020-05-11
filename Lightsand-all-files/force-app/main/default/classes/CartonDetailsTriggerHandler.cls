/*****************************************************************
Purpose: updating all Carton and tracking cartons process
Related Test Class Name : RTSTriggerHandlerTest 
Updated Date :5/2/2020                      
*****************************************************************/

public class CartonDetailsTriggerHandler {    
    
    public static Id rtOfAsiaCartons = Schema.SObjectType.Carton_Details__c.getRecordTypeInfosByName().get('Asia Carton').getRecordTypeId();
    public static Id rtOfEuropeCartons = Schema.SObjectType.Carton_Details__c.getRecordTypeInfosByName().get('Europe Carton').getRecordTypeId();
    
    public static void reActivateCarton(Map<ID,Carton_Details__c> cdnewMap , Map<ID,Carton_Details__c> cdOldMap){
        for(Carton_Details__c cd : cdnewMap.values()){
            if(cdOldMap.containsKey(cd.id)){
                
                //&& (cdOldMap.get(cd.id).Status__c == 'Sorting in Progress' || cdOldMap.get(cd.id).Status__c == 'Obsoleted')
                if(cdnewMap.get(cd.id).Status__c == 'Active' && cdOldMap.get(cd.id).Status__c != cdnewMap.get(cd.id).Status__c){   
                   // Reset carton details of 
                    cd.Transfer_Note__c = null;
                    cd.Filled_Box_Weight__c = null;
                    cd.Store_User__c = null;
                    cd.Customer_Warehouse__c = null;
                    cd.Is_This_Carton_Filling_in_Progress__c = false;                                  
                } 
            }
        }        
    }
    
    public Static void CreateMultipleCartons(List<Carton_Details__c> newCartonList){
        if(newCartonList != null){
            List<Carton_Details__c> createNewCartons = new List<Carton_Details__c>();
            for(Carton_Details__c carton : newCartonList){                
                if(carton.How_Many_Cartons__c != null){
                    for(Integer i=1; i<= carton.How_Many_Cartons__c-1 ; i++){
                        Carton_Details__c activeCartons = new Carton_Details__c();
                        activeCartons.Owner_Warehouse_ID__c = carton.Owner_Warehouse_ID__c;
                        activeCartons.Registered_Date__c = carton.Registered_Date__c;
                        activeCartons.Status__c = carton.Status__c;
                        activeCartons.Empty_Box_Weight__c = carton.Empty_Box_Weight__c;
                        createNewCartons.add(activeCartons);
                    }
                }
            }
            
            if(!createNewCartons.isEmpty()){
                insert createNewCartons;
            }
        }
    }
    
    Public Static void CountofCartons(List<Carton_Details__c> newCartonList,List<Carton_Details__c> oldCartonList){
        Set<Id> transferNoteIdSet = new Set<Id>();
        if(newCartonList != null){
            for(Carton_Details__c carton : newCartonList){
                if(carton.Transfer_Note__c != null && carton.RecordTypeId == rtOfAsiaCartons){                   
                    transferNoteIdSet.add(carton.Transfer_Note__c); 
                }                
            }
        }
        
        if(oldCartonList != null){
            for(Carton_Details__c carton : oldCartonList){
                if(carton.Transfer_Note__c != null){
                    transferNoteIdSet.add(carton.Transfer_Note__c); 
                }                
            }
        }
        if(!transferNoteIdSet.isEmpty()){
            List<Transfer_Note__c> updateTransferNoteList = new  List<Transfer_Note__c>();
            for(Transfer_Note__c transferNote : [select id,(select id from Carton_Details_TN__r),Total_Carton_Send__c from Transfer_Note__c where Id IN : transferNoteIdSet]){
                transferNote.Total_Carton_Send__c = transferNote.Carton_Details_TN__r.size();
                updateTransferNoteList.add(transferNote);
            }
            
            if(!updateTransferNoteList.isEmpty()){
                update updateTransferNoteList;
            }
            
        }
    }
    
    public static void createTrackerRecord(Map<ID,Carton_Details__c> cdnewMap , Map<ID,Carton_Details__c> cdOldMap){
        
        List<Tracker__c> cartonTrackerList = new List<Tracker__c>();
        
        for(Carton_Details__c cd: cdnewMap.values()){
            
            ////tracking Europe Region Carton details  
            if(cdOldMap.containsKey(cd.id) && cdnewMap.get(cd.id).RecordTypeId == rtOfEuropeCartons){
                 if(cdOldMap.get(cd.id).Status__c == 'Active' && cdnewMap.get(cd.id).Status__c == 'Filling in Progress' && cdnewMap.get(cd.id).Status__c != cdOldMap.get(cd.id).Status__c){
                    Tracker__c tracker = new Tracker__c();
                    tracker.Carton_Details__c = cd.id;                                        
                    tracker.Warehouse_ID__c = cd.Owner_Warehouse_Name__c; 
                    tracker.Customer_Warehouse__c = cd.Customer_Warehouse_Name__c; 
                    tracker.Registered_Date__c = cd.Registered_Date__c;                    
                    tracker.Carton_Status__c = cdnewMap.get(cd.id).Status__c;                   
                    tracker.Store_ID__c = cdOldMap.get(cd.id).Store_User__c;
                    tracker.Retail_Store__c = cdOldMap.get(cd.id).Store_Name__c;
                    tracker.Empty_Box_Weight__c = cdOldMap.get(cd.id).Empty_Box_Weight__c;
                    //Tony edited
                    tracker.Filled_Box_Weight__c = cdOldMap.get(cd.id).Filled_Box_Weight__c;
                    tracker.Tracking_Date__c = Date.today();
                    cartonTrackerList.add(tracker);
                 }
                
                 if(cdnewMap.get(cd.id).Status__c == 'Active' && (cdOldMap.get(cd.id).Status__c == 'Filling in Progress' || cdOldMap.get(cd.id).Status__c == 'Obsoleted') && cdnewMap.get(cd.id).Status__c != cdOldMap.get(cd.id).Status__c){
                    Tracker__c tracker = new Tracker__c();
                    tracker.Carton_Details__c = cd.id;                                        
                    tracker.Warehouse_ID__c = cd.Owner_Warehouse_Name__c; 
                    tracker.Customer_Warehouse__c = cd.Customer_Warehouse_Name__c; 
                    tracker.Registered_Date__c = cd.Registered_Date__c;                    
                    tracker.Carton_Status__c = cdnewMap.get(cd.id).Status__c;                   
                    tracker.Store_ID__c = cdOldMap.get(cd.id).Store_User__c;
                    tracker.Retail_Store__c = cdOldMap.get(cd.id).Store_Name__c;
                    tracker.Carton_Re_Activated_User_Name__c = UserInfo.getUserName();
                    tracker.Empty_Box_Weight__c = cdOldMap.get(cd.id).Empty_Box_Weight__c;
                    //Tony edited
                    tracker.Filled_Box_Weight__c = cdOldMap.get(cd.id).Filled_Box_Weight__c;
                    tracker.Tracking_Date__c = Date.today();
                    cartonTrackerList.add(tracker);
                }
            }
            
            //tracking Asia Region Carton details 
            
            if(cdOldMap.containsKey(cd.id) && cdnewMap.get(cd.id).RecordTypeId == rtOfAsiaCartons){
                
                if(cdnewMap.get(cd.id).Status__c == 'Customer Warehouse' && cdOldMap.get(cd.id).Status__c == 'Empty Box in Transit' && cdnewMap.get(cd.id).Status__c != cdOldMap.get(cd.id).Status__c){
                    Tracker__c tracker = new Tracker__c();
                    tracker.Carton_Details__c = cd.id; 
                    tracker.Carton_Status__c = cdnewMap.get(cd.id).Status__c;                                       
                    tracker.Transfer_Note_Name__c = cd.Transfer_Note_Name__c;                 
                    tracker.Warehouse_ID__c = cd.Owner_Warehouse_Name__c; 
                    tracker.Customer_Warehouse__c = cd.Customer_Warehouse_Name__c;
                    tracker.Registered_Date__c = cd.Registered_Date__c;              
                    tracker.Transfer_Note_Status__c = cdnewMap.get(cd.id).Transfer_Note_Status__c;
                    tracker.Tracking_Date__c = Date.today();
                    cartonTrackerList.add(tracker);
                }
                
                if(cdnewMap.get(cd.id).Status__c == 'Filling in Progress' && cdOldMap.get(cd.id).Status__c == 'Customer Warehouse' && cdnewMap.get(cd.id).Status__c != cdOldMap.get(cd.id).Status__c){
                    Tracker__c tracker = new Tracker__c();
                    tracker.Carton_Details__c = cd.id;
                    tracker.Transfer_Note_Name__c = cd.Transfer_Note_Name__c;
                    tracker.Warehouse_ID__c = cd.Owner_Warehouse_Name__c;
                    tracker.Customer_Warehouse__c = cd.Customer_Warehouse_Name__c; 
                    tracker.Retail_Store__c = cd.Store_Name__c;
                    //Tony Added
                    tracker.Store_ID__c = cd.Store_User__c;
                    tracker.Registered_Date__c = cd.Registered_Date__c;                    
                    tracker.Carton_Status__c = cdnewMap.get(cd.id).Status__c;
                    tracker.Transfer_Note_Status__c = cdnewMap.get(cd.id).Transfer_Note_Status__c;
                    tracker.Tracking_Date__c = Date.today();
                    cartonTrackerList.add(tracker);
                }
                /* commented by venkata reddy
                 * removed sorting in progress process step 
                if(cdnewMap.get(cd.id).Status__c == 'Sorting in Progress' && cdOldMap.get(cd.id).Status__c == 'Filling in Progress' && cdnewMap.get(cd.id).Status__c != cdOldMap.get(cd.id).Status__c){
                    Tracker__c tracker = new Tracker__c();
                    tracker.Carton_Details__c = cd.id;
                    tracker.Transfer_Note_Name__c = cd.Transfer_Note_Name__c;                      
                    tracker.Warehouse_ID__c = cd.Owner_Warehouse_Name__c; 
                    tracker.Customer_Warehouse__c = cd.Customer_Warehouse_Name__c; 
                    tracker.Registered_Date__c = cd.Registered_Date__c;                    
                    tracker.Carton_Status__c = cdnewMap.get(cd.id).Status__c;
                    tracker.Transfer_Note_Status__c = cdnewMap.get(cd.id).Transfer_Note_Status__c;
                    tracker.Retail_Store__c = cd.Store_Name__c;
                    //Tony Added
                    tracker.Store_ID__c = cd.Store_User__c;
                    tracker.Tracking_Date__c = Date.today();
                    cartonTrackerList.add(tracker);
                } */ 
                // changed old map status (Sorting in Progress) ----- to -------- (Filling in Progress)
                if(cdnewMap.get(cd.id).Status__c == 'Active' && (cdOldMap.get(cd.id).Status__c == 'Filling in Progress' || cdOldMap.get(cd.id).Status__c == 'Obsoleted') && cdnewMap.get(cd.id).Status__c != cdOldMap.get(cd.id).Status__c){
                    Tracker__c tracker = new Tracker__c();
                    tracker.Carton_Details__c = cd.id;
                    tracker.Transfer_Note_Name__c = cd.Transfer_Note_Name__c;                      
                    tracker.Warehouse_ID__c = cd.Owner_Warehouse_Name__c; 
                    tracker.Customer_Warehouse__c = cd.Customer_Warehouse_Name__c; 
                    tracker.Registered_Date__c = cd.Registered_Date__c;                    
                    tracker.Carton_Status__c = cdnewMap.get(cd.id).Status__c;
                    //Tony Added
                    tracker.Store_ID__c = cdOldMap.get(cd.id).Store_User__c;
                    tracker.Retail_Store__c = cdOldMap.get(cd.id).Store_Name__c;
                    tracker.Carton_Re_Activated_User_Name__c = UserInfo.getUserName();
                    tracker.Transfer_Note_Status__c = cdnewMap.get(cd.id).Transfer_Note_Status__c;
                    tracker.Tracking_Date__c = Date.today();
                    cartonTrackerList.add(tracker);
                }
            }   
        }
        
        if(!cartonTrackerList.isEmpty()){
            insert cartonTrackerList;
        }
    }
    
}