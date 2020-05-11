trigger CopyContactDataToUser on Contact(after update) {
 if (!Recursive.isWorking()) {
  // set to true to avoid infinite loop   
  Recursive.setWorking();
  if (Trigger.isUpdate) {
   try{   
   for (Contact U: Trigger.new) {
    System.debug('##Contact User:' + u.Id);
    //System.debug('##User Email:'+u.Email);
    if (u.Id != null) {
     User userContact = [select Id from User where ContactId = : u.Id];
     if (usercontact != null) {
      //usercontact.Order_to_Company__c = u.Order_to_Company__c;
      //usercontact.Company_Factory_Name__c = u.CompanyName;
      //usercontact.Title = u.Title;
      //usercontact.Preferred_Currency__c = u.Preferred_Currency__c;
      //usercontact.Customer_Related_Retailer__c = u.Related_Retailer__c;
      
      // By Pawan 05 SEP 2016
      //usercontact.Supplier_Code__c = u.Supplier_Code__c;
      //usercontact.Manufacturer_Code__c = u.Manufacturer_Code__c;
      // By Pawan 05 SEP 2016 END
      
      usercontact.EmailEncodingKey = 'UTF-8';
      
       // added by pawan 05 SEP 2016
       usercontact.Related_Retailer_Information__c = u.Related_Retailer_Information__c;
       
      update usercontact;
      System.debug('##Contact updated in trigger successfully');
     }
    }
   }
  }catch(Exception e){
    System.debug(LoggingLevel.ERROR,'Contact updation failed:'+e);
  }
  }
 }
 // set to false to avoid infinite loop
 Recursive.setClosed();
}