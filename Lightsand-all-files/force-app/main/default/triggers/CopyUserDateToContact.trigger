trigger CopyUserDateToContact on User (after insert) {
    if(Trigger.isInsert || Trigger.isUpdate){
        for(User U : Trigger.new){
            System.debug('##User Contact:'+u.contactid);
            System.debug('##User Email:'+u.Email);
            if(u.contactid!=null){
                Contact userContact = [select Id from Contact where Id=:u.ContactId];
                if(usercontact!=null){
                    usercontact.Order_to_Company__c = u.Order_to_Company__c;
                    //usercontact.Company_Factory_Name__c = u.CompanyName;
                    //Added By Pawan 24_APR_2016
                    usercontact.Company_Factory_Name__c = u.Company_Name__c;
                    usercontact.Title = u.Title;
                    usercontact.Preferred_Currency__c = u.Preferred_Currency__c;
                    
                    // commented by pawan 05 SEP 2016
                    //usercontact.Customer_Related_Retailer__c = u.Related_Retailer__c;
                    //usercontact.Supplier_Code__c = u.Supplier_Code__c;
                    //usercontact.Manufacturer_Code__c = u.Manufacturer_Code__c;
                    // commented by pawan 05 SEP 2016 -END
                    
                    // added by pawan 11 APR 2016
                    //usercontact.Related_Retailer__c = u.Related_Retailer__c;
                    
                    // added by pawan 05 SEP 2016
                    usercontact.Related_Retailer_Information__c = u.Related_Retailer_Information__c;
                    
                    update usercontact;
                    System.debug('##Contact updated in trigger successfully');
                }
            }
        }
    }
}