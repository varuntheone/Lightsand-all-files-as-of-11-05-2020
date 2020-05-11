public class designLogTechnicalPersonEmailController{
 
    //Our collection of the class/wrapper objects wrapAccount
    public List<wrapUser> wrapUserList {get; set;}
    public List<User> selectedUsers{get;set;}
    public List<Technical_Person_Design_Notification__c> allReadySelectedUsers{get;set;}
    public List<Technical_Person_Design_Notification__c> techSelectedUsers{get;set;}
    public SObject parent;
    public Design_Log_Form__c designLogForm {get; set;}
    public Boolean disableButton {get;set;}
    public String currentRecordId {get;set;}
   
    public designLogTechnicalPersonEmailController(ApexPages.StandardController sc){
        
        parent  = sc.getRecord();
        currentRecordId = parent.Id;
        //checking the project status, only if completed should we be doing next actions
         designLogForm =[select Project_Status__c from Design_Log_Form__c where Id =:parent.Id];
       
        //checking the design project status
        if(designLogForm.Project_Status__c == 'Complete'){
                if(wrapUserList == null) {
                    Design_Log_Task_Record_Id__c detail = Design_Log_Task_Record_Id__c.getInstance();
                    String queryParameter = detail.profile_names__c;
                    String[] setProfiles =  queryParameter.split(',');
                    wrapUserList = new List<wrapUser>();
                    allReadySelectedUsers =[select Technical_Person_Email__c from Technical_Person_Design_Notification__c where Design_Log_Form__c=:parent.Id];
                   
                    Boolean recordExists = false; 
                    //for(User u: [select UserName,UserRole.Name, Profile.Name,Email, LastName, IsActive, FirstName from User where IsActive = true and profile.name IN :setProfiles
                      //           order by LastName limit 100]) {       
                     for(User u: [select UserName,UserRole.Name, Profile.Name,Email, LastName, IsActive, FirstName,Mainetti_Company__c from User where IsActive = true and Id IN (select userorgroupid from groupmember where group.name =:setProfiles)
                                 order by LastName limit 100]) {       
                                     recordExists = true;
                                     Boolean emailExists = false;
                                     // As each Account is processed we create a new wrapAccount object and add it to the wrapAccountList
                                     for(Technical_Person_Design_Notification__c tpdnObj:allReadySelectedUsers){                            
                                         if(tpdnObj.Technical_Person_Email__c == u.Email){
                                             emailExists=true;
                                         }
                                     }
                                     if(!emailExists){
                                         wrapUserList.add(new wrapUser(u));
                                     }
                                 }
                    if(!recordExists){
                         disableButton=true;
                    }
                }
        }else{
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Design Project Status has to be "Complete", to send Email to Technical Persons'));
            disableButton=true;
        }
    }
 
    public void processSelected() {
        
    selectedUsers = new List<User>();
 	techSelectedUsers = new List<Technical_Person_Design_Notification__c>();	
        for(wrapUser wrapUserObj : wrapUserList) {
            if(wrapUserObj.selected == true) {
                selectedUsers.add(wrapUserObj.user);
                Technical_Person_Design_Notification__c techPerson = new Technical_Person_Design_Notification__c();
                techPerson.Design_Log_Form__c = parent.Id;
                techPerson.Technical_Person_Email__c = wrapUserObj.user.Email;
                techPerson.Name = wrapUserObj.user.UserName;
                String designLogURL = URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/r/' + parent.Id +'/related/Design_Drawing_File_Details__r/view';
                techPerson.Design_Record_Link__c= designLogURL;

                techSelectedUsers.add(techPerson);
            }
        }
         if(techSelectedUsers.size() > 0){
            insert techSelectedUsers;
        }
    }
 
   // This is our wrapper/container class. In this example a wrapper class contains both the standard salesforce object Account and a Boolean value
    public class wrapUser {
        public User user {get; set;}
        public Boolean selected {get; set;}
        public wrapUser(User usr) {
            user = usr;
            selected = false;
        }
    }

}