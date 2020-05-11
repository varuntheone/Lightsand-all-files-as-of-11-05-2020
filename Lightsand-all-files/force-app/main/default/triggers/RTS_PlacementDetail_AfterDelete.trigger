/**
 *  @author         : DC
 *  @LastModified   : 11/25/2015
 *  @Comment        : Initial draft. Calls handler to check status of placement detail
 */

trigger RTS_PlacementDetail_AfterDelete on RTS_Placement_Detail__c (before delete) {

    if(trigger.isBefore == true && trigger.isDelete == true) {
        RTS_PlacementDetail_AfterDeleteHandler.statusCheckBeforeDelete(trigger.old);
    } // End of If

} // End of trigger "RTS_PlacementDetail_AfterDelete"