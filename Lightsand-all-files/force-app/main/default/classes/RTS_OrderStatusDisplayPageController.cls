/*********************************************************************************
 * Name: RTS_OrderStatusDisplayPageController
 * Description: Controller for page RTS_OrderStatusDisplayPage that displays RTS Placement records
 *
 * Version History
 * Date        Developer        Comments
 * ---------------  --------------------  --------------------------------------------------------------------------------
 * 2015-10-28    Neha Sonawane   Created      
 * 2015-10-29    Neha Sonawane   Updated - changes made to show detail records
 * 2016-01-12    DC              Updated - changes in the filter criteria of the query in getRejectedRecords method
*********************************************************************************************************/
global without sharing class RTS_OrderStatusDisplayPageController {

    public static final Integer CANCEL_ORDERS_SELECTOR = 1;
    public static final Integer REQUEST_FOR_APPROVAL_SELECTOR = 1;
    public static final Integer APPROVED_SELECTOR = 1;
    // public static final Integer LAST_365_DAYS = 365;

    public List<ChildWrapper> lstWrap                               {get; set;} // wrapper list for  RTS Placement Detail records having Order Line Status 'Request for Cancel'
    public List<ChildWrapper> lstWrapOnHoldRequestCancel            {get; set;} // wrapper list for  RTS Placement Detail records having Order Line Status 'On-Hold' or 'Request for approval'
    public List<ChildWrapper> lstWrapApproved                       {get; set;} // wrapper list for  RTS Placement Detail records having Order Line Status 'Approved'
    public List<ChildWrapper> lstWrapRejected                       {get; set;} // wrapper list for  RTS Placement Detail records having Order Line Status 'Rejected' and Order Status != 'Completed'
    public Boolean setDimBln                                        {get; set;}
    public Boolean blnShowMsg                                       {get; set;}
    public String subItems                                          {get; set;}
    public Date expectedShipDate                                    {get; set;}
    global RTS_Placement_Detail__c detailInstance                   {get; set;}
    public String selectedTab                                       {get; set;}
    public String rejectReason                                      {get; set;}

    List<SelectOption> optionStatus;

    public RTS_OrderStatusDisplayPageController() {
        // detail = new RTS_Product_Inv_Detail__c(Transaction_Date__c = Date.today());
        getCancelRecords();
        getOnHoldAndRequestedRecords();
        changeSubStatus();
        getRejectedRecords();
        if(!lstWrapOnHoldRequestCancel.isEmpty()) {
            detailInstance = new RTS_Placement_Detail__c(Id = lstWrapOnHoldRequestCancel[0].placementDetail.Id, Expected_Ship_Date__c = Date.today());
        } else {
            detailInstance = new RTS_Placement_Detail__c(Expected_Ship_Date__c = Date.today());
        }
        blnShowMsg = false;
        setDimBln = true;
        optionStatus = new List<SelectOption>();
        selectedTab=ApexPages.currentPage().getParameters().get('selectTab');
    }

    // Remote action to display the approved orders
    @RemoteAction
    public static map<Id,list<string>> getApprovedOrders(List<String> recordIds ,String status) {

        Database.SaveResult[] lsr;
        List<RTS_Placement_Detail__c> lstPlacementDetails = new List<RTS_Placement_Detail__c>();
        map<Id, list<String>> updateResult = new map<Id, list<string>>();

        if(recordIds != NULL && !recordIds.isEmpty()) {

            for(Id recordId : recordIds) {
                lstPlacementDetails.add( new RTS_Placement_Detail__c(
                Id = recordId, Order_Line_Status__c = status));
            }

            if(!lstPlacementDetails.isEmpty()) {

                String errorMsg;
                lsr = database.update(lstPlacementDetails, false);

                for(Database.SaveResult sr:lsr) {

                    if(!sr.isSuccess()) {
                        errorMsg = '';

                        for(Database.Error err : sr.getErrors()) {

                            errorMsg += err.getFields() +': ' + err.getMessage();
                            System.debug('fields that affected this error: '+err.getFields()+': ' + err.getFields());
                        }
                    }
                    updateResult.put(sr.getId(),new list<String>{'' + sr.isSuccess(),errorMsg});
                }
            }
            return updateResult;
        } else {
            return null;
        }
    }

    // Populate Status picklist values
    public List<SelectOption> getItems() {

        optionStatus = new List<SelectOption>();

        SelectOption group1 = new SelectOption(System.Label.Request_Approval,System.Label.Request_Approval);
        SelectOption group2 = new SelectOption(System.Label.RTS_OnHold,System.Label.RTS_OnHold);

        group1.setEscapeItem(false);
        group2.setEscapeItem(false);
        optionStatus.add(group1);
        optionStatus.add(group2);

        return optionStatus ;
    }

    // Populate Substatus picklist values    
    public static List<SelectOption> getsubItemsOptions() {

        List<SelectOption> options = new List<SelectOption>();

        options.add(new SelectOption('',System.Label.None));
        options.add(new SelectOption(System.Label.Outofstock,System.Label.Outofstock));
        options.add(new SelectOption(System.Label.Latedelivery,System.Label.Latedelivery));

        return options;
    }

    public void getCancelRecords() {
        blnShowMsg = false;
        lstWrap = new List<ChildWrapper>();
        List<RTS_Placement__c> lstRTSCancelOrder = new List<RTS_Placement__c>();
        List<RTS_Placement_Detail__c> lstRTSPlacementCancelOrder = new List<RTS_Placement_Detail__c>();

        lstRTSPlacementCancelOrder = [SELECT RTS_Placement__r.Name,
                                             RTS_Placement__r.Order_To_Company__c,
                                             RTS_Placement__c,
                                             RTS_Placement__r.Ship_To_Country__c,
                                             RTS_Placement__r.Placement_Date__c,
                                             RTS_Placement__r.Bill_To_Company__c,
                                             RTS_Placement__r.Inventory_Type__c,
                                             RTS_Product_ID__c,
                                             Model__c,
                                             Local_System_SKU__c,
                                             RTS_Product_ID__r.Available_Stock_Balance__c,
                                             Quantity__c,
                                             Expected_Ship_Date__c,
                                             Order_Line_Status__c,
                                             Order_Line_Sub_Status__c
                                        FROM RTS_Placement_Detail__c
                                       WHERE Order_Line_Status__c =: System.Label.RTS_request_cancel
                                    ORDER BY Order_Line_Status__c ASC, Expected_Ship_Date__c ASC];

        for(RTS_Placement_Detail__c RTSDetail : lstRTSPlacementCancelOrder){
            lstWrap.add(new ChildWrapper(RTSDetail));
        }
        getApprovedRecords();
        getRejectedRecords();
    }

    public void getOnHoldAndRequestedRecords(){

        blnShowMsg = false;
        lstWrapOnHoldRequestCancel = new List<ChildWrapper>();
        List<RTS_Placement__c> lstRTSCancelOrder = new List<RTS_Placement__c>();
        List<RTS_Placement_Detail__c> lstRTSOnHoldRequested = new List<RTS_Placement_Detail__c>();

        lstRTSOnHoldRequested = [SELECT RTS_Placement__r.Name,
                                        RTS_Placement__r.Order_To_Company__c,
                                        RTS_Placement__c,
                                        RTS_Placement__r.Ship_To_Country__c,
                                        RTS_Placement__r.Placement_Date__c,
                                        RTS_Placement__r.Bill_To_Company__c,
                                        RTS_Placement__r.Inventory_Type__c,
                                        RTS_Product_ID__c,
                                        Model__c,
                                        Local_System_SKU__c,
                                        RTS_Product_ID__r.Available_Stock_Balance__c,
                                        Quantity__c,
                                        Expected_Ship_Date__c,
                                        Order_Line_Status__c,
                                        Order_Line_Sub_Status__c
                                   FROM RTS_Placement_Detail__c
                                  WHERE (Order_Line_Status__c =: System.Label.Request_Approval
                                     OR Order_Line_Status__c =: System.Label.RTS_OnHold)
                               ORDER BY Order_Line_Status__c ASC, Expected_Ship_Date__c ASC];

        for(RTS_Placement_Detail__c RTSDetail : lstRTSOnHoldRequested){
            lstWrapOnHoldRequestCancel.add(new ChildWrapper(RTSDetail));
        }

        getApprovedRecords();
        getRejectedRecords();
    }

    public pageReference subStatusPage(){

        System.debug('------ selectedTab ------ : ' + selectedTab);
        // selectedTab = System.Label.name2;

        PageReference pageRef = Page.RTS_Showsubstatus;
        pageRef.setRedirect(false);

        Integer counter = 0;
        ChildWrapper childInstance;

        for(ChildWrapper child : lstWrapOnHoldRequestCancel) {
            if(child.isChecked == true) {
                childInstance = new ChildWrapper(child.placementDetail);
                counter++;
            }
        }

        if(counter > 0) {
            if(counter == 1) {
                subItems = childInstance.placementDetail.Order_Line_Sub_Status__c;
                detailInstance.Expected_Ship_Date__c = childInstance.placementDetail.Expected_Ship_Date__c;
            }
            return pageRef;
        }

        return null;
    }

    public pageReference saveSubStatus(){
        System.debug('------ selectedTab 1 ------ : ' + selectedTab);
        // selectedTab = System.Label.name2;
        List<RTS_Placement_Detail__c> placementDetailList = new List<RTS_Placement_Detail__c>();

        for(ChildWrapper child : lstWrapOnHoldRequestCancel) {
            if(child.isChecked){
                child.placementDetail.Order_Line_Status__c = System.Label.RTS_OnHold;
                child.placementDetail.Order_Line_Sub_Status__c = subItems;
                child.placementDetail.Expected_Ship_Date__c = detailInstance.Expected_Ship_Date__c;
                placementDetailList.add(child.placementDetail);
            }
        }

        try{
            update placementDetailList;
        }

        catch(Exception ex){
            System.debug('======= ' + ex.getMessage());
        }

        PageReference pageRef = Page.RTS_OrderStatusDisplayPage;
        pageRef.getParameters().put('selectTab',selectedTab);
        pageRef.setRedirect(true);
        return pageRef;

    }

    public pageReference rejectReasonPage(){

        System.debug('------ selectedTab ------ : ' + selectedTab);
        // selectedTab = System.Label.name2;

        PageReference pageRef = Page.RTS_RejectReason;
        pageRef.setRedirect(false);

        for(ChildWrapper child : lstWrapOnHoldRequestCancel) {
            if(child.isChecked == true) {
                pageRef.getParameters().put('rr', 'true');
                return pageRef;
            }
        }

        for(ChildWrapper child : lstWrap) {
            if(child.isChecked == true) {
                pageRef.getParameters().put('crr', 'true');
                return pageRef;
            }
        }

        return null;
    }

    public pageReference saveRejectReason(){
        System.debug('------ selectedTab 1 ------ : ' + selectedTab);
        // selectedTab = System.Label.name2;
        List<RTS_Placement_Detail__c> placementDetailList = new List<RTS_Placement_Detail__c>();

        Boolean rejectStatus = ApexPages.currentPage().getParameters().containsKey('rr');
        Boolean cancelRejectStatus = ApexPages.currentPage().getParameters().containsKey('crr');

        List<ChildWrapper> childList = new List<ChildWrapper>();

        if(rejectStatus == true) {
            childList.addAll(lstWrapOnHoldRequestCancel);
        }
        if(cancelRejectStatus == true) {
            childList.addAll(lstWrap);
        }

        String childStatus;

        for(ChildWrapper child : childList) {
            if(true == child.isChecked) {
                if(true == rejectStatus) {
                    childStatus = System.Label.RTS_Rejected;
                } else if(true == cancelRejectStatus) {
                    childStatus = System.Label.RTS_CancelRejected;
                }
                child.placementDetail.Order_Line_Status__c = childStatus;
                child.placementDetail.Reject_Reason__c = rejectReason;
                placementDetailList.add(child.placementDetail);
            }
        }

        try {
            if(!placementDetailList.isEmpty()) {
                update placementDetailList;
            }
        }

        catch(Exception ex) {
            System.debug('======= ' + ex.getMessage());
        }

        PageReference pageRef = Page.RTS_OrderStatusDisplayPage;
        pageRef.getParameters().put('selectTab',selectedTab);
        pageRef.setRedirect(true);
        return pageRef;

    }

    public pageReference cancelSubStatus(){

         // selectedTab = System.Label.name2;
         PageReference pageRef = Page.RTS_OrderStatusDisplayPage;
         pageRef.getParameters().put('selectTab',selectedTab);
         pageRef.setRedirect(true);
         return pageRef;

    }

    public void getApprovedRecords(){
        blnShowMsg = false;

        lstWrapApproved = new List<ChildWrapper>();
        List<RTS_Placement__c> lstRTSCancelOrder = new List<RTS_Placement__c>();
        List<RTS_Placement_Detail__c> lstRTSOnHoldRequested = new List<RTS_Placement_Detail__c>();

        lstRTSOnHoldRequested = [SELECT RTS_Placement__r.Name,
                                        RTS_Placement__c,
                                        RTS_Placement__r.Order_To_Company__c,
                                        RTS_Placement__r.Ship_To_Country__c,
                                        RTS_Placement__r.Placement_Date__c,
                                        RTS_Placement__r.Bill_To_Company__c,
                                        RTS_Placement__r.Inventory_Type__c,
                                        RTS_Product_ID__c,
                                        Model__c,
                                        Local_System_SKU__c,
                                        RTS_Product_ID__r.Available_Stock_Balance__c,
                                        Quantity__c,
                                        Expected_Ship_Date__c,
                                        Order_Line_Status__c,
                                        Order_Line_Sub_Status__c
                                   FROM RTS_Placement_Detail__c
                                  WHERE Order_Line_Status__c = :System.Label.RTS_Approved
                                     OR Order_Line_Status__c = :System.Label.RTS_CancelRejected
                                     OR Order_Line_Status__c = :System.Label.RTS_CancelApproved
                               ORDER BY Order_Line_Status__c ASC, Expected_Ship_Date__c ASC];

        for(RTS_Placement_Detail__c obj : lstRTSOnHoldRequested){
            lstWrapApproved.add(new ChildWrapper(obj));
        }

    }

    public void getRejectedRecords() {
        blnShowMsg = false;

        lstWrapRejected = new List<ChildWrapper>();
        List<RTS_Placement__c> lstRTSCancelOrder = new List<RTS_Placement__c>();
        List<RTS_Placement_Detail__c> lstRTSOnHoldRequested = new List<RTS_Placement_Detail__c>();

        Set<String> setStatuses = new Set<String> {
            System.Label.RTS_Cancelled,
            System.Label.RTS_Completed,
            System.Label.RTS_Rejected
        };

        lstRTSOnHoldRequested = [SELECT RTS_Placement__r.Name,
                                        RTS_Placement__c,
                                        RTS_Placement__r.Order_To_Company__c,
                                        RTS_Placement__r.Ship_To_Country__c,
                                        RTS_Placement__r.Placement_Date__c,
                                        RTS_Placement__r.Bill_To_Company__c,
                                        RTS_Placement__r.Inventory_Type__c,
                                        RTS_Product_ID__c,
                                        Model__c,
                                        Local_System_SKU__c,
                                        RTS_Product_ID__r.Available_Stock_Balance__c,
                                        Quantity__c,
                                        Expected_Ship_Date__c,
                                        Order_Line_Status__c,
                                        Order_Line_Sub_Status__c
                                  FROM RTS_Placement_Detail__c
                                  WHERE (Order_Line_Status__c = :System.Label.RTS_Rejected
                                    AND RTS_Placement__r.Order_Header_Status__c  = :System.Label.RTS_Open)
                                    OR (Order_Line_Status__c = :System.Label.RTS_Rejected 
                                    AND RTS_Placement__r.Order_Header_Status__c  = :System.Label.RTS_Rejected
                                    AND RTS_Placement__r.LastModifiedDate = LAST_N_DAYS : 365)
                                 ORDER BY Order_Line_Status__c ASC, Expected_Ship_Date__c ASC];
                               
                               /* WHERE Order_Line_Status__c = :System.Label.RTS_Rejected
                                    AND RTS_Placement__r.Order_Header_Status__c NOT IN : setStatuses
                                    AND RTS_Placement__r.LastModifiedDate = LAST_N_DAYS : 365*/

        for(RTS_Placement_Detail__c obj : lstRTSOnHoldRequested){
            lstWrapRejected.add(new ChildWrapper(obj));
        }

    }

    public pageReference changeSubStatus() {
        /*blnShowMsg = true;

        for(TargetWrapper tw : lstWrapOnHoldRequestCancel ) {

            if(tw.status == System.Label.Request_Approval || tw.status == null ||  tw.status == '') {
               tw.subStatus= '';
                setDimBln =true;
            } else {
                setDimBln =false;
            }
        }*/
        return null;
    }

    // to toggle error message
    /*public pagereference closedMessage() {
        blnShowMsg = true;
        return null;
    }*/

    public class ChildWrapper {

        public RTS_Placement_Detail__c placementDetail      {get; set;}
        public Boolean isChecked                            {get; set;}

        public ChildWrapper(RTS_Placement_Detail__c pPlacementDetail) {
            placementDetail = pPlacementDetail;
            isChecked = false;
        }
    }
}