@isTest
public class SalesErrorControllerTest {
    
    static testMethod void fetchsalesErrorData() {
        String batchId = 'a1Np000000IxbPkEAJ';
        Boolean missingData = true;
        Boolean validationFailed = true;
        Boolean warning = true;
        Boolean calculationFailed = true;
        Boolean remarks = true;
        Boolean dateMismatch = true;
        Integer pageNumber = 1;
        Integer recordToDisplay = 15;
        Test.startTest();
        SalesErrorController.fetchsalesErrorData(batchId, missingData, validationFailed,warning,calculationFailed,dateMismatch,remarks, pageNumber, recordToDisplay);
        Test.stopTest();
        
    }
    
    
}