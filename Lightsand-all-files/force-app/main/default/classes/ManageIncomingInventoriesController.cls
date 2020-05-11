public with sharing class ManageIncomingInventoriesController {

    public String batchId {get; set;}
    public List<RTS_Product_Inv_Detail__c> detailsList {get; set;}  
    public Boolean showTable {get; set;}
    public Boolean isDuplicate {get; set;}
    public String selectedIds {get; set;}
    public Integer totalQuantity {get; set;}
    public Integer totalCartons {get; set;}

    public ManageIncomingInventoriesController() {
        showTable = false;
        detailsList = new List <RTS_Product_Inv_Detail__c> ();
        batchId = '';
        totalQuantity = 0;
        totalCartons = 0;
    }

    public List<SelectOption> getbatchIdList() {
        List<SelectOption> selectOptionList = new List<SelectOption>();
        Set<String> options = new Set<String>();
        selectOptionList.add(new Selectoption ('',System.Label.None));
        // DC - 17-Nov-2015
        // Updated query filter to only include batches with some/all unconfirmed products.
        // [Manager_Confirmed__c=false]
        for(RTS_Product_Inv_Detail__c invDetailsObj : [SELECT Id,
                                                              Lot_No__c
                                                         FROM RTS_Product_Inv_Detail__c
                                                        WHERE Manager_Confirmed__c=false
                                                     ORDER BY Lot_No__c ASC
                                                        LIMIT 500]) {
            if(!options.contains(invDetailsObj.Lot_No__c)) {
                selectOptionList.add(new Selectoption (invDetailsObj.Lot_No__c,invDetailsObj.Lot_No__c));
            }
            options.add(invDetailsObj.Lot_No__c);
            
        }
        return selectOptionList;
    }
    
    public void searchQuery() {
        detailsList = new List <RTS_Product_Inv_Detail__c> ();
        system.debug('Inside searcgg'+batchId);
        //system.debug('Inside searcgg');
        String queryString = '';
        if(String.isNotBlank(batchId)){
            // DC - 17-Nov-2015
            // Updated query to include only unconfirmed products from the batch. [Manager_Confirmed__c=false]
            // DC 18-Nov-2015
            // Removed condition [Manager_Confirmed__c=false] and filtered in apex instead of query.
            // Added query limit
            queryString = 'SELECT Id,RTS_Product_ID__r.Name, JDE_SKU__c, Model__c, Lot_No__c, Transaction_Date__c,'
                      + ' Inventory_Type__c, Location__c, Packer__c, Quantity__c, Total_Carton__c, '
                      + ' Manager_Confirmed__c '
                      + ' FROM RTS_Product_Inv_Detail__c'
                      + ' where Lot_No__c = ' + '\''+ batchId + '\''
                      + ' Limit 500';
        }
        System.debug('queryString*********'+queryString);
        if(String.isNotBlank(queryString)){
            system.debug('-- inside if queryString');
            detailsList = Database.Query(queryString);
            system.debug('-- detailsList if queryString'+detailsList);

            isDuplicate = new DuplicateChecker(detailsList).checkDuplicates();

            List<RTS_Product_Inv_Detail__c> filteredDetailsList = 
                new List<RTS_Product_Inv_Detail__c>();
            totalQuantity = 0;
            totalCartons = 0;
            for(RTS_Product_Inv_Detail__c detailIterator : detailsList) {

                if(detailIterator.Manager_Confirmed__c == false) {
                    totalQuantity = totalQuantity + (Integer) detailIterator.Quantity__c;
                    totalCartons = totalCartons + (Integer) detailIterator.Total_Carton__c;
                    filteredDetailsList.add(detailIterator);
                }
            }

            if(!filteredDetailsList.isEmpty()) {
                detailsList = new List<RTS_Product_Inv_Detail__c>();
                detailsList.addAll(filteredDetailsList);
            } else {
                detailsList = new List<RTS_Product_Inv_Detail__c>();
            }
            if(isDuplicate == true) {
                ApexPages.Message myMsg =
                    new ApexPages.Message(ApexPages.Severity.Warning,
                                          System.Label.Duplicate_RTS_Product_Inv_Detail_error);
                ApexPages.addMessage(myMsg);
            }
        }
        else {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                                                           System.Label.batch_Id);
           ApexPages.addMessage(myMsg);
        }
        showTable = detailsList.isEmpty() ? false : true;
    }
    
    public PageReference confirmUpdate() {

        // DC - 17-Nov-2015
        // Commented out checkbox related code from the method.
        /*Set<String> changedIdSet = new Set<String>();
        if(String.isNotBlank(selectedIds))
            changedIdSet.addAll(selectedIds.split(','));
        else {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,System.Label.update_record);
            ApexPages.addMessage(myMsg);
            return null;
        }*/
        List<RTS_Product_Inv_Detail__c> recordsToUpdate = new List<RTS_Product_Inv_Detail__c>();
        for(RTS_Product_Inv_Detail__c productInv : detailsList) {
            // if(changedIdSet.contains(productInv.Id)) {
                productInv.Manager_Confirmed__c = true;
                recordsToUpdate.add(productInv);
            // }
        }
        
        try {
            update recordsToUpdate;
        } catch(DmlException exceptionInstance) {
            System.debug(exceptionInstance.getMessage());
        }
        searchQuery();
        return null;
    }
    
    public PageReference deleteRecord() {
        // DC - 17-Nov-2015
        // Commented out checkbox related code from the method.
        /*Set<String> idToDeleteSet = new Set<String>();
        if(String.isNotBlank(selectedIds)) {
            idToDeleteSet.addAll(selectedIds.split(','));
        }
        else {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,System.Label.delete_record);
            ApexPages.addMessage(myMsg);
            return null;
        }
        List<RTS_Product_Inv_Detail__c> recordToDelete = new List<RTS_Product_Inv_Detail__c>();
        for(RTS_Product_Inv_Detail__c productInv : detailsList) {
            if(idToDeleteSet.contains(productInv.Id))
                recordToDelete.add(productInv);
        }*/
        // DC - 17-Nov-2015
        // Added try catch block.
        try {
            delete detailsList;
        } catch(DmlException exceptionInstance) {
            System.debug(exceptionInstance.getMessage());
        }
        searchQuery();
        return null;
    }

    public class DuplicateChecker {

        List<RTS_Product_Inv_Detail__c> detailsList;
        Boolean isConfirmed;

        public DuplicateChecker(List<RTS_Product_Inv_Detail__c> pDetailsList) {
            detailsList = pDetailsList;
        }

        public Boolean checkDuplicates() {

            if(!detailsList.isEmpty()) {

                isConfirmed = detailsList[0].Manager_Confirmed__c;

                for(RTS_Product_Inv_Detail__c detailIterator : detailsList) {
                    if(detailIterator.Manager_Confirmed__c != isConfirmed) {
                        return true;
                    }
                }
            }

            return false;
        }
    }

}