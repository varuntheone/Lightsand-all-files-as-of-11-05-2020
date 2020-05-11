/**
 *  @author         : DC
 *  @LastModified   : 11/25/2015
 *  @Comment        : Initial draft. If the Placement Detail status is "Open" & "Cancelled",
 *                    shows an error message.
 */

public with sharing class RTS_PlacementDetail_AfterDeleteHandler {

    public static void statusCheckBeforeDelete(List<RTS_Placement_Detail__c> lstOldPlacementDetails) {

        // Iterate over "Trigger.Old"
        for(RTS_Placement_Detail__c placementIterator : lstOldPlacementDetails) {

            // Check if the Placement Detail status is "Open" or "Cancelled".
            if( !placementIterator.Order_Line_Status__c.equalsIgnoreCase(System.Label.RTS_Cancelled)
            &&  !placementIterator.Order_Line_Status__c.equalsIgnoreCase(System.Label.RTS_Open)) {

                placementIterator.addError(System.Label.RTS_Delete_Error);

            } // End If
        } // End For

    } // End method "statusCheckBeforeDelete"
} // End Class "RTS_PlacementDetail_AfterDeleteHandler"