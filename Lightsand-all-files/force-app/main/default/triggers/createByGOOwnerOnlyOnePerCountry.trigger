trigger createByGOOwnerOnlyOnePerCountry on Opportunity_by_Company__c (before insert,before update) {
    String onlyOneCountryErrorMsg='Only One Record Per Country can be created for a Global Opportunity.';
    String obcCreatRestrictErrorMsg='Only the record owner of the Global Opportunity can create new forecast by country.';
    
    //System.debug('obc.Country__c:::'+obc.Country__c);
    //System.debug('obc.Global_Opportunity__c:::'+obc.Global_Opportunity__c);
    if(Trigger.isInsert){
        for(Opportunity_by_Company__c obc : trigger.new){
            List<Opportunity_by_Company__c> obcRec =[SELECT Id FROM Opportunity_by_Company__c WHERE Country__c =: obc.Country__c  AND  Global_Opportunity__c =: obc.Global_Opportunity__c];
            if( obcRec.size() > 0 ){                 
                obc.addError(onlyOneCountryErrorMsg,false); 
            }
        }
    }
    if(Trigger.isUpdate){
        for(Opportunity_by_Company__c obc : trigger.new){
            Opportunity_by_Company__c  oldObc = Trigger.oldMap.get(obc.Id);
            if(oldObc.Country__c != obc.Country__c)
            { 
                List<Opportunity_by_Company__c> obcRec =[SELECT Id FROM Opportunity_by_Company__c WHERE Country__c =: obc.Country__c  AND  Global_Opportunity__c =: obc.Global_Opportunity__c];
                if( obcRec.size() > 0 ){                 
                    obc.addError(onlyOneCountryErrorMsg,false); 
                }
            }
        }
    }
    for(Opportunity_by_Company__c obc : trigger.new){
        List<Global_Opportunity__c> goRec =[SELECT ownerId FROM Global_Opportunity__c WHERE ID =: obc.Global_Opportunity__c];
        if( goRec.size() > 0 ){
            System.debug('obc.OwnerId:::'+obc.OwnerId);
            System.debug('goRec[0].ownerId:::'+goRec[0].ownerId);
            if(obc.OwnerId != goRec[0].ownerId){
                obc.addError(obcCreatRestrictErrorMsg,false);                 
            }            
        }         
        
    }
}