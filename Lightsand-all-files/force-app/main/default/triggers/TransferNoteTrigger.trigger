trigger TransferNoteTrigger on Transfer_Note__c (Before Update,After Update) {
    
    if(Trigger.IsUpdate && Trigger.IsBefore){
        TransferNoteTriggerHandler.updateTransferNoteData(Trigger.NewMap,Trigger.OldMap);
        TransferNoteTriggerHandler.checkValidation(Trigger.NewMap,Trigger.OldMap);
        //TransferNoteTriggerHandler.createTrackerRecord(Trigger.NewMap,Trigger.OldMap);
    }
    if(Trigger.IsUpdate && Trigger.IsAfter){       
        TransferNoteTriggerHandler.UpdateAllCartonStatus(Trigger.NewMap,Trigger.OldMap);      
        TransferNoteTriggerHandler.removeCartonsfromTransferNote(Trigger.NewMap,Trigger.OldMap);       
    }
    
}