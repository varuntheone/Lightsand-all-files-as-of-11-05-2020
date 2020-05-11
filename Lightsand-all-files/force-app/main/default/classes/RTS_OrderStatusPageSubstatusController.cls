/*********************************************************************************
 * Name: RTS_OrderStatusPageSubstatusController
 * Description: Controller for page RTS_OrderStatusPageSubstatusController that displays substatus and updates it.
 *
 * Version History
 * Date        Developer        Comments
 * ---------------  --------------------  --------------------------------------------------------------------------------
 * 2015-10-28    Neha Sonawane   Created      
 * 2015-10-29    Neha Sonawane   Updated - changes made to show detail records
 * 
*********************************************************************************/
global class RTS_OrderStatusPageSubstatusController{

    public String wrapOnHold { get; set; }

    public String substatusPage { get; set; }
    public List<TargetWrapper> lstWrap{get;set;}//wrapper list for  RTS Placement records having placement status'Request for Cancel'
    public List<TargetWrapper> lstWrapOnHoldRequestCancel{get;set;}//wrapper list for  RTS Placement records having placement status'On-Hold' or 'Request for approval'
    public static boolean showError{get;set;}
    public List<TargetWrapper> lstWrapApproved{get;set;}//wrapper list for  RTS Placement records having placement status'Approved'
    List<SelectOption> optionStatus;
    public Boolean setDimBln {get;set;}
    public Boolean blnShowMsg {get;set;}
    public RTS_OrderStatusPageSubstatusController(){
        getCancelRecords();
        getOnHoldAndRequestedRecords();
        changeSubStatus();
        blnShowMsg = false;
        setDimBln = true;
        optionStatus = new List<SelectOption>();
    }
    
    //Remote action to display the approved orders
      
    @RemoteAction
    public static map<Id,list<string>> getApprovedOrders1(List<String> recordIds ,String status, List<String> placementList,
                                     List<String> subStatusList, List<String> remarkList) {
        //showError = false;
         //System.debug('**showError **** '+showError );
        if(recordIds <> NULL && !recordIds.isEmpty()){
        
        map<String,RTS_Placement__c> idRTSobjMap= 
                                new map <String,RTS_Placement__c>([select Id,
                                                                          OwnerId,Name, 
                                                                          Inventory_Type__c, 
                                                                          Placement_Date__c, 
                                                                          Expected_Ship_Date__c, 
                                                                          // Replacement_Order__c, 
                                                                          // Placement_Status__c, 
                                                                          // Sub_Status__c,
                                                                          Remark__c
                                                                     from RTS_Placement__c 
                                                                    where ID IN : recordIds]);
        integer i=0;
        for(String rtsObj: idRTSobjMap.keyset()){
          
                 if(status== 'Save') {
                   if(remarkList[i] <> ''){
                   idRTSobjMap.get(rtsObj).Remark__c = remarkList[i];
                   }
                   // idRTSobjMap.get(rtsObj).Placement_Status__c = placementList[i];
                   // idRTSobjMap.get(rtsObj).Sub_Status__c = subStatusList[i];
                     
                 }
                 else if (status <> 'Save'){
                   // idRTSobjMap.get(rtsObj).Placement_Status__c = status ;
                 }
          i++;
        }// end of for
        
        map<Id, list<String>> updateResult = new map<Id, list<string>>();
       
        Database.SaveResult[] lsr = database.update(idRTSobjMap.values(),false); 
       
        String errorMsg;
        
        for(Database.SaveResult sr:lsr) {
        
            if(!sr.isSuccess()) {
            
                errorMsg = '';
            
                for(Database.Error err : sr.getErrors()) {
        
                    errorMsg += err.getFields() +': ' + err.getMessage();
        
                    System.debug('fields that affected this error: '+err.getFields()+': ' + err.getFields());
        
                }

            
            }
        
            updateResult.put(sr.getId(),new list<String>{''+sr.isSuccess(),errorMsg});
            
        }
            return updateResult; 
        }
        else {
       // system.debug('showError *************'+showError );
             //showError = true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select atleast one checkbox');
            ApexPages.addMessage(myMsg);
            
            return null;
        
        }
    }
    
    //Populate Status picklist values
     public List<SelectOption> getItems() {
               optionStatus = new List<SelectOption>();
               // SelectOption group1 = new SelectOption('Request for Approval','<option value="Request for Approval" label="Request for Approval" style="background:#2081A1;"></option >');
               //SelectOption group2 = new SelectOption('On-hold','<option value="On-hold" label="On-hold" style="background:pink;"></option >');
               
                SelectOption group1 = new SelectOption('Request for Approval','Request for Approval');
                SelectOption group2 = new SelectOption('On-hold','On-hold');
                
                group1.setEscapeItem(false);
                group2.setEscapeItem(false);
                optionStatus.add(group1);
                optionStatus.add(group2);
             
                return optionStatus ;
    }
    //Populate Substatus picklist values    
    public static List<SelectOption> getsubItems() {
                List<SelectOption> options = new List<SelectOption>();
                options.add(new SelectOption('','--None--'));
                options.add(new SelectOption('Out of Stock','Out of Stock'));
                options.add(new SelectOption('Late Delivery','Late Delivery'));
                return options;
    }
    
     public pageReference substatusPage(){
         PageReference pageRef = new PageReference('/apex/RTS_Showsubstatus');
         return pageRef;
    
    }
      
    public void getCancelRecords() {
         blnShowMsg = false;
        lstWrap= new List<TargetWrapper>();
        List<RTS_Placement__c> lstRTSCancelOrder = new List<RTS_Placement__c>();
        List<RTS_Placement_Detail__c> lstRTSPlacementCancelOrder = new List<RTS_Placement_Detail__c>();

        lstRTSPlacementCancelOrder = [Select Id, 
                                            RTS_Placement__c,
                                            RTS_Product_ID__c,
                                            Model__c,
                                            Quantity__c,
                                            // RTS_Placement__r.Placement_Status__c,
                                            Local_System_SKU__c from RTS_Placement_Detail__c 
                                            /*where RTS_Placement__r.Placement_Status__c = 'Request for Cancel'*/];
        map<Id, list<RTS_Placement_Detail__c>> mapRTSIdWithDetails = new map<Id, list<RTS_Placement_Detail__c>>();
        
        for(RTS_Placement_Detail__c RTSDetail : lstRTSPlacementCancelOrder){
            if (mapRTSIdWithDetails.containsKey(RTSDetail.RTS_Placement__c)) {
                mapRTSIdWithDetails.get(RTSDetail.RTS_Placement__c).add(RTSDetail);
            }
            else {
                mapRTSIdWithDetails.put(RTSDetail.RTS_Placement__c, new RTS_Placement_Detail__c[]{ RTSDetail });
            }
        }
        
        lstRTSCancelOrder = [select Id, 
                                            OwnerId,Name, 
                                            Inventory_Type__c, 
                                            Placement_Date__c, 
                                            Expected_Ship_Date__c, 
                                            // Replacement_Order__c, 
                                            // Placement_Status__c, 
                                            // Sub_Status__c,
                                            Remark__c
                                            from RTS_Placement__c 
                                            where ID IN : mapRTSIdWithDetails.keySet()];
                                            
        lstWrap = new List<TargetWrapper>();
        for(RTS_Placement__c obj : lstRTSCancelOrder){
            lstWrap.add(new TargetWrapper(obj, mapRTSIdWithDetails.get(obj.Id)));
        }
    }
    
    public void getOnHoldAndRequestedRecords(){
         blnShowMsg = false;
        lstWrapOnHoldRequestCancel= new List<TargetWrapper>();
        List<RTS_Placement__c> lstRTSCancelOrder = new List<RTS_Placement__c>();
        List<RTS_Placement_Detail__c> lstRTSOnHoldRequested = new List<RTS_Placement_Detail__c>();

        lstRTSOnHoldRequested = [Select Id, 
                                            RTS_Placement__c,
                                            RTS_Product_ID__c,
                                            Model__c,
                                            Quantity__c,
                                            // RTS_Placement__r.Placement_Status__c,
                                            Local_System_SKU__c from RTS_Placement_Detail__c 
                                           /* where RTS_Placement__r.Placement_Status__c = 'Request for Approval' 
                                            OR RTS_Placement__r.Placement_Status__c = 'On-hold'*/];
        map<Id, list<RTS_Placement_Detail__c>> mapRTSIdWithDetails = new map<Id, list<RTS_Placement_Detail__c>>();
        
        for(RTS_Placement_Detail__c RTSDetail : lstRTSOnHoldRequested){
            //options.add(RTSDetail.RTS_Placement__r.Placement_Status__c);
            if (mapRTSIdWithDetails.containsKey(RTSDetail.RTS_Placement__c)) {
                mapRTSIdWithDetails.get(RTSDetail.RTS_Placement__c).add(RTSDetail);
            }
            else {
                mapRTSIdWithDetails.put(RTSDetail.RTS_Placement__c, new RTS_Placement_Detail__c[]{ RTSDetail });
            }
        }
        
        lstRTSCancelOrder = [select Id, 
                                            OwnerId,Name, 
                                            Inventory_Type__c, 
                                            Placement_Date__c, 
                                            Expected_Ship_Date__c, 
                                            // Replacement_Order__c, 
                                            // Placement_Status__c, 
                                            // Sub_Status__c,
                                            Remark__c
                                            from RTS_Placement__c 
                                            where ID IN : mapRTSIdWithDetails.keySet()];
                                            
        lstWrapOnHoldRequestCancel = new List<TargetWrapper>();
        for(RTS_Placement__c obj : lstRTSCancelOrder){
            lstWrapOnHoldRequestCancel.add(new TargetWrapper(obj, mapRTSIdWithDetails.get(obj.Id)));
        }
        
            getApprovedRecords();
       
    }


    public void getApprovedRecords(){
        blnShowMsg = false;
        lstWrapApproved= new List<TargetWrapper>();
        List<RTS_Placement__c> lstRTSCancelOrder = new List<RTS_Placement__c>();
        List<RTS_Placement_Detail__c> lstRTSOnHoldRequested = new List<RTS_Placement_Detail__c>();

        lstRTSOnHoldRequested = [Select Id, 
                                            RTS_Placement__c,
                                            RTS_Product_ID__c,
                                            Model__c,
                                            Quantity__c,
                                            // RTS_Placement__r.Placement_Status__c,
                                            Local_System_SKU__c from RTS_Placement_Detail__c 
                                            /*where RTS_Placement__r.Placement_Status__c = 'Approved'*/];
        map<Id, list<RTS_Placement_Detail__c>> mapRTSIdWithDetails = new map<Id, list<RTS_Placement_Detail__c>>();
        
        for(RTS_Placement_Detail__c RTSDetail : lstRTSOnHoldRequested){
            if (mapRTSIdWithDetails.containsKey(RTSDetail.RTS_Placement__c)) {
                mapRTSIdWithDetails.get(RTSDetail.RTS_Placement__c).add(RTSDetail);
            }
            else {
                mapRTSIdWithDetails.put(RTSDetail.RTS_Placement__c, new RTS_Placement_Detail__c[]{ RTSDetail });
            }
        }
        
        lstRTSCancelOrder = [select Id, 
                                            OwnerId,Name, 
                                            Inventory_Type__c, 
                                            Placement_Date__c, 
                                            Expected_Ship_Date__c, 
                                            // Replacement_Order__c, 
                                            // Placement_Status__c, 
                                            // Sub_Status__c,
                                            Remark__c
                                            from RTS_Placement__c 
                                            where ID IN : mapRTSIdWithDetails.keySet()];
                                            
        lstWrapApproved = new List<TargetWrapper>();
        for(RTS_Placement__c obj : lstRTSCancelOrder){
            lstWrapApproved.add(new TargetWrapper(obj, mapRTSIdWithDetails.get(obj.Id)));
        }

    }
    
    // this method is used to dim the picklist value if placement status set to 'Request for Approve'
    
    public pageReference changeSubStatus() {
        blnShowMsg = true;
        for(TargetWrapper tw : lstWrapOnHoldRequestCancel ) {
            if(tw.status =='Request for Approval' || tw.status == null ||  tw.status == '') {
               tw.subStatus= '';
                setDimBln =true;
                
            }
            else {
                setDimBln =false;
            }
        }
         return null;
    }
    // to toggle error message
    public pagereference closedMessage() {
        blnShowMsg = true;
      return null;
    }
    
   
    //Wrapper Class
    public class TargetWrapper{
        public RTS_Placement__c RTS {get;set;}
        public List<RTS_Placement_Detail__c> lstRTSDetails {get;set;}
         public String status{get;set;}
         public String subStatus{get;set;}
        
        public Boolean getHasChild(){//Check if RTS Placement has children
            return this.lstRTSDetails != null && this.lstRTSDetails.size() > 0;
        }
        
        //Constructor
        public TargetWrapper(RTS_Placement__c RTS, List<RTS_Placement_Detail__c> lstRTSDetails) {
            this.RTS = RTS;
            this.lstRTSDetails = lstRTSDetails;
        }
    }
    
    

}