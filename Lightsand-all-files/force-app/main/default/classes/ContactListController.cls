// Apex Controller for Contact List Lightning Component
public class ContactListController {
        
    @AuraEnabled
    public static List<User> getContactList(List<Id> accountIds) {
        // Getting the list of contacts from where Id is in accountIds
                List<User> contactList = [SELECT Id, FirstName, LastName, Email, Phone FROM User WHERE Id in :accountIds];
                // Returning the contact list
        return contactList;
    }

    @AuraEnabled
    public static List<Customer_Information__c> getCustomerInformation(List<Id> accountIds) {
        // Getting the list of contacts from where Id is in accountIds
                List<Customer_Information__c> customerInfo = [SELECT Id,Bill_to_Address1__c,Phone__c,Bill_to_Contact__c,Bill_to_Email__c FROM Customer_Information__c WHERE Ownerid =: accountIds];
                // Returning the contact list
        return customerInfo;
    }
    
    
	@AuraEnabled
    public static Map<String,String> saveContactList(List<Customer_Information__c> contactList) {
        // Forming a  string map to return response
        Map<String,String> resultMap = new Map<String,String>();
        // Adding try catch for exception handling
        try {
                // Updating the Contact List
            update contactList;
            // Setting the success status and message in resultMap
            resultMap.put('status', 'success');
                resultMap.put('message', 'Contacts Updated Successfully');        
        }
        catch(Exception e) {
            // Setting the success status and message in resultMap
            resultMap.put('status', 'error');
                        resultMap.put('message',e.getMessage());
        }
        // Returning the result string map
        return resultMap;
    }
}