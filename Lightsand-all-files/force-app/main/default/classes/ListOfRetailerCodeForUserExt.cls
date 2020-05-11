public class ListOfRetailerCodeForUserExt{
    public List<Contact_Related_Retailer__c> retailerCodes {get{
        if(contactId!=null && contactId.length()>0){
            retailerCodes  = [select Name, Retailer_Code__c, Retailer_Name__c, Contact__c from Contact_Related_Retailer__c where Contact__c=:contactId];
            System.debug('retailerCodes--->'+retailerCodes);
            return retailerCodes;
        }
        return retailerCodes;
    } set;}
    public List<DisplayProperties> customRetailerCodes{get;set;}
    public User loggedInUser {get; set;}
    private String contactId {get; set;}
    public ListOfRetailerCodeForUserExt(){
        System.debug('User Id--->'+UserInfo.getUserId());
        loggedInUser = [select Name, ContactId from User where Id=:UserInfo.getUserId()];
        System.debug('loggedInUser--->'+loggedInUser);
       
        contactId = loggedInUser.ContactId;
        System.debug('contactId--->'+contactId);
        if(contactId!=null && contactId.length()>0){
            retailerCodes  = [select Name, Retailer_Code__c, Retailer_Name__c, Contact__c from Contact_Related_Retailer__c where Contact__c=:contactId];
            System.debug('retailerCodes--->'+retailerCodes);
            for(Contact_Related_Retailer__c eachContRetCode : retailerCodes){
                if(customRetailerCodes==null){
                    customRetailerCodes = new List<DisplayProperties>();
                }
                DisplayProperties displayProp = new DisplayProperties();
                displayProp.RetailerCodeId = eachContRetCode.Retailer_Code__c;
                displayProp.RetailerCodeName = eachContRetCode.Retailer_Name__c;
                customRetailerCodes.add(displayProp);
            }
        }
        //loggedInUser = null;
    }

    
    public class DisplayProperties{

    public String RetailerCodeId{get; set;}
    public String RetailerCodeName{get; set;}
    public void DisplayProperties(){
        
    }

    }
}