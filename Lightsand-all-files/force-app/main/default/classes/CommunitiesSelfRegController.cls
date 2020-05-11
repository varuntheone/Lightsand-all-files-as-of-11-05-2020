/**
 * An apex page controller that supports self registration of users in communities that allow self registration
 */
public class CommunitiesSelfRegController {
 public String firstName {
  get;
  set;
 }
 public String lastName {
  get;
  set;
 }
 public String email {
  get;
  set;
 }
 public String password {
  get;
  set {
   password = value == null ? value : value.trim();
  }
 }
 public String confirmPassword {
  get;
  set {
   confirmPassword = value == null ? value : value.trim();
  }
 }
 public String communityNickname {
  get;
  set {
   communityNickname = value == null ? value : value.trim();
  }
 }
 public String companyName {
  get;
  set;
 }
 public String title {
  get;
  set;
 }
 public String fax {
  get;
  set;
 }
 public String telephone {
  get;
  set;
 }
 public User userNew {
  get;
  set;
 }
 public String tempPassword {
  get;
  set;
 }
 public Boolean isErrorExists {
  get;
  set;
 }
 
 public List<Retailer_Code__c> retailerList {
  get;
  set;
 }
 
 public List<String> retailerNamePickList {
  get;
  set;
 }
 
 public Integer uniqueId{
    get;
    set;
}

 public Map<String,Id> retailerNameIdMap{
    get;
    set;
}
 
 public CommunitiesSelfRegController() {
    userNew = new User();

    // retailer rows
    rows=new List<Row>();
    rows.add(new Row());
    
    // List of retailer
    retailerList = new List<Retailer_Code__c>();
    retailerNamePickList = new List<String>();
    retailerNameIdMap = new Map<String,Id>();
    //retailerList = [Select Id,Name from Retailer_Code__c];
    retailerList = [Select Id,Name from Retailer_Code__c where Online_Enquiry__c=true];
    for(Retailer_Code__c eachRetailer : retailerList){
        retailerNamePickList.add(eachRetailer.Name);
        retailerNameIdMap.put(eachRetailer.Name,eachRetailer.Id);
    }
 }
 
 private boolean isValidPassword() {
  return password == confirmPassword;
 }

 public PageReference registerUser() {
  // it's okay if password is null - we'll send the user a random password in that case
  if (!isValidPassword()) {
   ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.site.passwords_dont_match);
   ApexPages.addMessage(msg);
   return null;
  }

  //  String profileId = null; // To be filled in by customer.
  //  String roleEnum = null; // To be filled in by customer.
  //  String accountId = ''; // To be filled in by customer.

  String profileId = '00e90000001iB5Y'; // To be filled in by customer.
  String roleEnum = null; // To be filled in by customer.
  // String accountId = '001N000000AF0o3'; // To be filled in by customer.
  //String accountId = '001N000000HULtC'; // Sandbox AccountID.
  //String accountId = '0019000000sJJVs'; // Sandfull AccountID
  //String accountId = '0019000000sJJVs'; // Sandfull/Production AccountID
  String accountId = '001p000000Hw757'; //Lightsand AccountID

  String userName = email;

  // User u = new User();
  // userNew = new User();
  userNew.Username = userNew.Email;
  //userNew.Email = email;
  //userNew.FirstName = firstName;
  //userNew.LastName = lastName;
  //userNew.CommunityNickname = communityNickname;
  userNew.ProfileId = profileId;
  //userNew.CompanyName = companyName;
  //userNew.Title = title;
  //userNew.Fax = fax;
  //userNew.Phone = telephone;

  userNew.IsActive = false;
  userNew.EmailEncodingKey = 'UTF-8';

  // added by pawan for multiple retailer
  /*
  String relatedInfo = 'Retailer Name;Manufacturer / Factory Code;Supplier Code'+
                        '\n---------------------------------------------------------------------';
  for(Row eachRow : rows){
    if(relatedInfo.length()>0){
        relatedInfo = relatedInfo +'\n'+eachRow.val1+';'+eachRow.val2+';'+eachRow.val3;
    }
  }
  userNew.Related_Retailer_Information__c = relatedInfo;
  System.debug('relatedInfo:'+relatedInfo);
  */
  
  // added by pawan
  //userNew.Order_to_Company__c='India - Mainetti (India) Pvt Ltd';
  //userNew.Related_Retailer__c = relatedRetailer;
  //userNew.Related_Retailer__c = relatedRetailer;

  System.debug('#####Order_to_Company__c = ' + userNew.Order_to_Company__c);
  System.debug('#####Buyer_Code__c = ' + userNew.Buyer_Code__c);
  //System.debug('#####Mainetti_Company__c = '+userNew.Mainetti_Company__c);

  System.debug('##User Name = ' + userName);
  System.debug('Creating Portal User');
  System.debug('##Password = ' + password);

  tempPassword = password;
  isErrorExists = true;
  String userId = Site.createPortalUser(userNew, accountId, password);

  if (userId != null) {
    
    //  Adding Related Retailers
    User u = [SELECT u.Id,u.ContactId,u.IsActive from User u where u.Id =:userId];
    List<Retailer_Related_Data__c> retailerDataList = new List<Retailer_Related_Data__c>();
    for(Row eachRow : rows){
        Retailer_Related_Data__c relatedRetailer = new Retailer_Related_Data__c();
        relatedRetailer.ContactID__c = u.ContactId;
        relatedRetailer.Retailer_Code__c = retailerNameIdMap.get(eachRow.val1);
        relatedRetailer.Manufacturer_Factory_Code__c = eachRow.val2;
        relatedRetailer.Supplier_Code__c = eachRow.val3;
        retailerDataList.add(relatedRetailer);
    }
    
    // create in batch
    try{
        insert(retailerDataList);
    }catch(Exception e){
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
        ApexPages.addMessage(msg);
        return null;
    }
    
    System.debug('Related Retailer added successfully');
  
  
   if (password != null && password.length() > 1) {
    //User toUpdateUser = [select Name, IsActive from User where Id=:userId];
    //toUpdateUser.IsActive = false;
    //update toUpdateUser;
    PageReference page = System.Page.CommunitiesSelfRegConfirm;
    page.setRedirect(true);
    return page;
    //return Site.login(userName, password, null);
   } else {
    PageReference page = System.Page.CommunitiesSelfRegConfirm;
    page.setRedirect(true);
    return page;
   }
  } else {
   isErrorExists = true;
   System.debug('##Setting Error exist flag to true:' + isErrorExists);
  }
  System.debug('User Id found NULL');
  return null;
 }

 /*
 public PageReference checkUserExist() {
  isErrorExists = false;
  System.debug('##Email:' + email);
  Boolean isException = false;
  User u = null;
  try {
   u = [select Id from User where Username = : email];
  } catch (Exception e) {
   System.debug('##Error:' + e.getMessage());
   isException = true;
  }

  if (isException) {
   System.debug('##userNew:' + userNew);

   String accountId = '001N000000HULtC';
   System.debug('##User Name---------> = ' + userNew.Email);
   System.debug('Creating Portal User');
   System.debug('##Password----------> = ' + tempPassword);

   String userId = Site.createPortalUser(userNew, accountId, tempPassword);
   System.debug('##userId------>' + userId);

   if (userId != null) {
    if (tempPassword != null && tempPassword.length() > 1) {
     //User toUpdateUser = [select Name, IsActive from User where Id=:userId];
     //toUpdateUser.IsActive = false;
     //update toUpdateUser;
     System.debug('##Logging-----------');
     return Site.login(userNew.Email, tempPassword, null);
    } else {
     PageReference page = System.Page.CommunitiesSelfRegConfirm;
     page.setRedirect(true);
     return page;
    }
   }
  }
  return null;
 }*/

public static User user { get; set; }
 
@RemoteAction
public static User getUserByEmail(String email) {
    user = [SELECT Id FROM User WHERE Email = :email];
    return user;
}


// Related Retailer - START
public List<Row> rows {get; set;}

public class Row
{
    public String val1 {get; set;}
    public String val2 {get; set;}
    public String val3 {get; set;}
}

public void addRow()
{
    rows.add(new Row());
}

public pagereference removeRow()
{
    if(rows.size()!=1){
        Integer indexVal = Integer.valueof(system.currentpagereference().getparameters().get('index'));
        //Remove the contact from the table    
        rows.remove(indexVal - 1);  
    }else{
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'At least, One Retailer is mandatory to register.');
        ApexPages.addMessage(msg);          
    }
    
    return null;
}

public List<SelectOption> getReatilersOptions(){
    List<SelectOption> options1 = new List<SelectOption>();
    List<string> tempList = new List<String>();
    tempList.addAll(retailerNamePickList);
    tempList.sort();
    options1.add(new SelectOption('--None--','--None--'));
    for(String s : tempList)
        options1.add(new SelectOption(s,s));
    return options1;
}
// Related Retailer - END    
    
}