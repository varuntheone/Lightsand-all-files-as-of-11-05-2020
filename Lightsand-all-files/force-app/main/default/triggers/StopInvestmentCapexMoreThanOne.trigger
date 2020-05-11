trigger StopInvestmentCapexMoreThanOne on Capex__c (before insert, after insert) {
    if(Trigger.isBefore){
        for(Capex__c newCapex : Trigger.new){
            if(newCapex!=null && (newCapex.RecordTypeId=='01290000000SVCG') || newCapex.RecordTypeId=='01290000000SVCI'){
               String parentBudgetedCapexId = newCapex.Budgeted_Capex__c;
                if(parentBudgetedCapexId!=null && parentBudgetedCapexId.length()>0){
                  Capex__c parentBudgetedCapexInstance = [select Id, Budget_Invested__c from Capex__c where Id=:newCapex.Budgeted_Capex__c];
                    if(parentBudgetedCapexInstance!=null && parentBudgetedCapexInstance.Budget_Invested__c==true){
                        System.debug('####This budgeted capex has been used in another Capex item.');
                        newCapex.addError('This budgeted capex has been used in another Capex item.');
                    }
                }
            }
        }
    }
    if(Trigger.isAfter){
    for(Capex__c newCapex : Trigger.new){
        if(newCapex!=null && (newCapex.RecordTypeId=='01290000000SVCG') || newCapex.RecordTypeId=='01290000000SVCI'){
            
   System.debug('####'+newCapex.Budgeted_Capex__c);
   String parentBudgetedCapexId = newCapex.Budgeted_Capex__c;
        if(parentBudgetedCapexId!=null && parentBudgetedCapexId.length()>0){
            Capex__c parentBudgetedCapexInstance = [select Id, Budget_Invested__c from Capex__c where Id=:newCapex.Budgeted_Capex__c];
            parentBudgetedCapexInstance.Budget_Invested__c = true;
            update parentBudgetedCapexInstance;
            System.debug('####Updated Parent Successfully:');
        }
    }
    }
    }
}