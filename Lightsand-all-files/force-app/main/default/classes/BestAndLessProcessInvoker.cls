/*
* Author:        K.V.VINOD KUMAR
* Company:       TECHKASETTI
* Description:   Class for processing Best and Less Bulk Order Processor CSV Order from baser CSV_File_Data__c Object
* History
* <Date>          <28-02-2020>   <Class for processing Best and Less Bulk Order Processor Order from CSV_File_Data__c>
*/
public class BestAndLessProcessInvoker {
    
    @InvocableMethod(label='Best and Less Bulk Order Processor' description='Best and Less Bulk Order Processor')
    public static void processOrder (List<string> inputParams) {
        System.debug('START OF BestAndLessProcessInvoker inputParams' +inputParams.size()+'::::'+ inputParams);
        Database.executeBatch(new BestAndLessBulkOrderProcess(inputParams),10);
    }
}