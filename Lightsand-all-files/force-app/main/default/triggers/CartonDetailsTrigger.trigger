/*****************************************************************
Purpose: updating all Carton and tracking cartons process
Related Test Class Name : RTSTriggerHandlerTest 
Updated Date :5/2/2020                      
*****************************************************************/

trigger CartonDetailsTrigger on Carton_Details__c (After Insert, Before Update,After Update, After Delete,After undelete) {
    
    
    if(Trigger.IsAfter && Trigger.isInsert){
        CartonDetailsTriggerHandler.CreateMultipleCartons(trigger.new);
    }
    if(Trigger.IsBefore && Trigger.IsUpdate){        
        //CartonDetailsTriggerHandler.updateTransferNoteName(trigger.new);
        CartonDetailsTriggerHandler.reActivateCarton(Trigger.NewMap,Trigger.OldMap);
    }
    
    if(Trigger.IsAfter && Trigger.IsUpdate){
        CartonDetailsTriggerHandler.createTrackerRecord(Trigger.NewMap,Trigger.OldMap);
    }
    
    if(Trigger.IsAfter && (Trigger.IsUpdate || Trigger.isInsert)){
        CartonDetailsTriggerHandler.CountofCartons(trigger.new, trigger.old);
    }
    
    if( trigger.isAfter && trigger.isDelete){  
        CartonDetailsTriggerHandler.CountofCartons(null, trigger.old);
    }
    
    if( trigger.isAfter && trigger.isUndelete){
        CartonDetailsTriggerHandler.CountofCartons(trigger.new, null);
    }
}