/*****************************************************************
Purpose: Relase of Second Europe Carton process and Automation process 
Related Class Name : AddRemoveCartonfromTransferNoteTest 
Updated Date :5/2/2020                      
*****************************************************************/

public class AddRemoveCartonfromTransferNote {
    
    public static Id rtOfAsiaCartons = Schema.SObjectType.Carton_Details__c.getRecordTypeInfosByName().get('Asia Carton').getRecordTypeId();
    public static Id rtOfEuropeCartons = Schema.SObjectType.Carton_Details__c.getRecordTypeInfosByName().get('Europe Carton').getRecordTypeId();
   
    
    @AuraEnabled
    public static String updatecartonTransferNotefield(Id transferNoteID,List<String> cartonsIds){        
        Set<ID> cartonIDSet = new Set<ID>();        
        for(String str : cartonsIds){
            cartonIDSet.add(str);
        }
        List<Carton_Details__c> cartonList = [select id,Name,Status__c,Owner_Warehouse_ID__c,Owner_Warehouse_ID__r.Name from Carton_Details__c where Id IN : cartonIDSet];
        List<Carton_Details__c> updateCarton = new List<Carton_Details__c>();
        for(Carton_Details__c carton : cartonList){                
            carton.Transfer_Note__c = transferNoteID;
            updateCarton.add(carton);              
        }
        if(!updateCarton.isEmpty()){
            update updateCarton; 
        }     
        return 'sucess';
    }
    
    @AuraEnabled
    public static List<Carton_Details__c> getActiveCartonsNoTFNote(Id transferNoteID){
        
        Transfer_Note__c tNote = [select id,Name,Warehouse_ID__c from Transfer_Note__c where Id =: transferNoteID];
        //key = '%' + key + '%';
        //and Name LIKE :key
        List<Carton_Details__c> cartonList = [select id,Name,Status__c,Transfer_Note__c,Transfer_Note__r.Name,Owner_Warehouse_ID__c,Owner_Warehouse_ID__r.Name from Carton_Details__c where status__c = 'Active' and Owner_Warehouse_ID__c =: tNote.Warehouse_ID__c  and Transfer_Note__c = null];
        
        return cartonList;
    }
    
    @AuraEnabled
    public static List<Carton_Details__c> getActiveCartonswithTFNote(Id transferNoteID){
        
        Transfer_Note__c tNote = [select id,Name,Warehouse_ID__c from Transfer_Note__c where Id =: transferNoteID];
        List<Carton_Details__c> cartonList = [select id,Name,Status__c,Transfer_Note__c,Transfer_Note__r.Name,Owner_Warehouse_ID__c,Owner_Warehouse_ID__r.Name from Carton_Details__c where status__c = 'Active' and Owner_Warehouse_ID__c =: tNote.Warehouse_ID__c and Transfer_Note__c =: transferNoteID];
        
        return cartonList;
    }
    
    public class locationDetailWrapper{
        @AuraEnabled public string Street{get;set;}
        @AuraEnabled public string PostalCode{get;set;}
        @AuraEnabled public string City{get;set;}
        @AuraEnabled public string State{get;set;}
        @AuraEnabled public string Country{get;set;}
    }
    
    @AuraEnabled
    public static locationDetailWrapper getcartonDetailsAddress(ID recId){
        Carton_Details__c carton = [select id,name,Carton_City__c,Carton_Country__c,Carton_State__c,Carton_Street__c,Address__c from Carton_Details__c where id =: recId];
        locationDetailWrapper oLocationWrap = new locationDetailWrapper();
        oLocationWrap.Street = carton.Carton_Street__c;
        //oLocationWrap.PostalCode = carton.BillingPostalCode;
        oLocationWrap.City = carton.Carton_City__c;
        oLocationWrap.State = carton.Carton_State__c;
        oLocationWrap.Country = carton.Carton_Country__c;
        return oLocationWrap;
    }
    
    @AuraEnabled
    public static Transfer_Note__c getTransferNoteData(ID recId){        
        Transfer_Note__c transferNote = [select id,Name,Status__c,Total_Carton_Send__c from Transfer_Note__c where Id =: recId];
        return transferNote;
    }
    
    @AuraEnabled
    public static  String updateAllCartonStatus(ID recId,String lov){        
        string message = '';
        if(recId != null){
            List<Carton_Details__c> updateCartonList = new List<Carton_Details__c>();
            List<Carton_Details__c>  cartonsList =[select id,Name,Status__c,Transfer_Note__c from Carton_Details__c  where Transfer_Note__c =: recId];
            if(!cartonsList.isEmpty()){
                for(Carton_Details__c carton : cartonsList){
                    carton.Status__c = lov;
                    updateCartonList.add(carton);
                } 
            }
            if(!updateCartonList.isEmpty()){
                try{
                    update updateCartonList; 
                    message = 'SUCCESS';
                }Catch(Exception e){
                    message =''+e;
                }                
            }
        }
        return message;
        
    }
    
    @AuraEnabled
    public static Carton_Details__c getcartonRecordData(ID recId){        
        Carton_Details__c  carton =[select id,Name,Status__c,RecordType.Name,Filled_Box_Weight__c,Store_User__c,Customer_Warehouse__c,Transfer_Note__c from Carton_Details__c  where Id =: recId limit 1];
        return carton;
    }
    
    @AuraEnabled
    public static String addCartonfromTransferNote(ID cartonId){
        string message = '';
        if(cartonId != null){                    
            List<Transfer_Note__c> TransferNoteList =  [select id,Status__c,Warehouse_ID__c,Customer_Warehouse__c from Transfer_Note__c  where Cartons_Added_By__c =:UserInfo.getUserId() and Status__c ='Cartons Adding Started' limit 1];
            if(!TransferNoteList.isEmpty()){                
                Carton_Details__c carton =[select id,Name,Transfer_Note__c,Owner_Warehouse_ID__c,Customer_Warehouse__c  from Carton_Details__c where Id =: cartonId limit 1];
                for(Transfer_Note__c tfNote : TransferNoteList){                    
                    carton.Owner_Warehouse_ID__c = tfNote.Warehouse_ID__c;
                    carton.Transfer_Note__c  = tfNote.id;
                    carton.Customer_Warehouse__c = tfNote.Customer_Warehouse__c;
                    carton.Status__c = 'Active'; 
                }
                update carton;
                message = 'SUCCESS';
            }else{
                message = 'Error'; 
            }
        }
        return message;
    }
    
    @AuraEnabled
    public static String removeCartonFromTransferNote(ID cartonId){
        string message = ''; 
        if(cartonId != null){
            //and (Transfer_Note__r.Goods_Loaded_By__c =: UserInfo.getUserId() or Transfer_Note__r.Warehouse_ID__c =: UserInfo.getUserId() )
            List<Carton_Details__c> cartonList =[select id,Name,Transfer_Note__c  from Carton_Details__c where Id =: cartonId  limit 1];
            for(Carton_Details__c carton : cartonList){
                //carton.Company__c = null;
                carton.Transfer_Note__c  = null;
                carton.Status__c = 'Active';
            }
            update cartonList;
            message = 'SUCCESS';
        }else{
            message = 'Error'; 
        }
        return message;
    }    
    
    @AuraEnabled
    public static List<String> getPickListValues(String objName, String str) {            
        String[] options = new String[]{}; 
            Schema.DescribeFieldResult plistvalues = Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap().get(str).getDescribe();
        options.add('--None--');
        for(PicklistEntry ent:plistvalues.getpicklistvalues()){
            options.add(ent.getLabel());
        }        
        return options;
    }
    
    @AuraEnabled
    public static Transfer_Note__c transferNoteStatusAutomation(ID recId){        
        Transfer_Note__c transferNote;
        system.debug('-------->'+recId);
        if(recId != null){
            system.debug('-------->'+recId);
           transferNote = [select id,Name,Status__c,Is_This_Transfer_Note_Closed__c from Transfer_Note__c where Id =: recId];
            
            if(!transferNote.Is_This_Transfer_Note_Closed__c && transferNote.Status__c == 'In transit'){
                profile profile = [select Name from profile where id =: UserInfo.getProfileId() Limit 1];             
                if(profile.Name == Label.RTS_Customer_Warehouse_Profile_Name){
                    transferNote.Status__c = 'Closed';
                    transferNote.Is_This_Transfer_Note_Closed__c = true;
                    update transferNote;
                }
            }
        }
        return transferNote;
    }
    
     @AuraEnabled
    public static Carton_Details__c CartonStatusAutomation(ID recId){        
        Carton_Details__c carton;
        if(recId != null){
            carton = [select id,Name,RecordTypeId,RecordType.Name,Status__c,Store_User__c,Is_This_Carton_Filling_in_Progress__c from Carton_Details__c where Id =: recId];
            profile profile = [select Name from profile where id =: UserInfo.getProfileId() Limit 1];
            // Activation process removed from automation, requested by: YY. 
            /*if(profile.Name == Label.RTS_Mainetti_Internal_Re_Active_User_profile && (carton.Status__c == 'Printed' || carton.Status__c == 'Sorting in Progress' || carton.Status__c == 'Obsoleted')){
                carton.Status__c = 'Active';                
                update carton;
            } */
            //adding new condition for maintetti users scan and active 
            if(carton.RecordTypeId == rtOfAsiaCartons){
                if((profile.Name == Label.RTS_Mainetti_Internal_Re_Active_User_profile || profile.Name == Label.RTS_Mainetti_Internal_Receive_User_profile) && (carton.Status__c == 'Filling in Progress' || carton.Status__c == 'Obsoleted')){
                    carton.Status__c = 'Active';                
                    update carton;
                }            
                
                if(!carton.Is_This_Carton_Filling_in_Progress__c && profile.Name == Label.RTS_Store_user_Profile_Name && carton.Status__c == 'Customer Warehouse'){                             
                    carton.Status__c = 'Filling in Progress';
                    carton.Is_This_Carton_Filling_in_Progress__c = true;
                    update carton;
                } 
            }
            
            if(carton.RecordTypeId == rtOfEuropeCartons){ 
                system.debug('------>'+carton.RecordType.Name);
                if(profile.Name == Label.UK_RTS_Mainetti_Internal_Re_Active_User && (carton.Status__c == 'Filling in Progress' || carton.Status__c == 'Obsoleted')){
                    carton.Status__c = 'Active';                
                    update carton;
                } 
                                                       
                if(carton.Is_This_Carton_Filling_in_Progress__c == false && profile.Name == Label.UK_RTS_Store_user && carton.Status__c == 'Active'){                             
                    carton.Status__c = 'Filling in Progress';
                    carton.Is_This_Carton_Filling_in_Progress__c = true;
                    update carton;
                } 
            }
             
        }
        return carton;
    }
    
    @AuraEnabled
    Public Static String getUserInformation(){
         profile profile = [select Name from profile where id =: UserInfo.getProfileId() Limit 1];
        return profile.Name;
    }
    
}