@IsTest(SeeAllData = true)
public class designLogTechnicalPersonEmailTest {
	
    @IsTest(SeeAllData=true) 
    public static void initilizeTechnicalPersonEmail() {
        List<designLogTechnicalPersonEmailController.wrapUser> wrapUserList;
        List<User> selectedUsers = new  List<User>();
        List<User> usrLst = new  List<User>();
        List<Technical_Person_Design_Notification__c> allReadySelectedUsers = new List<Technical_Person_Design_Notification__c>();
        List<Technical_Person_Design_Notification__c> techSelectedUsers  = new List<Technical_Person_Design_Notification__c>();
        User usr = new User();
        
        Design_Request_Form__c desigReqForm = new Design_Request_Form__c();
        desigReqForm.Design_Status__c = 'New_Design_Accepted_and_In_Progress';
        insert desigReqForm;          
        
        Id designId = desigReqForm.Id;    
        
        Design_Log_Form__c designLogForm =new Design_Log_Form__c();
        designLogForm.Project_Status__c = 'Complete';   
        designLogForm.Project_ID__c = desigReqForm.Id;
        insert designLogForm;
        
        String currentRecordId ;
        Boolean disableButton = false;
        Boolean emailExists = false;
        Test.startTest();          
        PageReference pageRef = new ApexPages.StandardController(designLogForm).view();
        Test.setCurrentPage(pageRef);          
        
        ApexPages.currentPage().getParameters().put('Id',String.valueOf(designLogForm.Id));
        ApexPages.StandardController stdController =   new ApexPages.StandardController(designLogForm);      
        designLogTechnicalPersonEmailController designController = new designLogTechnicalPersonEmailController(stdController); 
        
        SObject parent = stdController.getRecord();
        currentRecordId = parent.Id;
        designLogForm =[select Project_Status__c from Design_Log_Form__c where Id =:parent.Id];
        System.assertEquals(designLogForm.Project_Status__c, 'Complete');
        System.assertEquals(wrapUserList, null);
        
        String queryParameter	  = 'Design Technical Team';
        String[] setProfiles  =  queryParameter.split(',');
        Boolean recordExists = false; 
        
        Technical_Person_Design_Notification__c techPersonDesign = new Technical_Person_Design_Notification__c();
        techPersonDesign.Technical_Person_Email__c = 'tony.cheung@mainetti.com';
        techPersonDesign.Design_Log_Form__c= parent.Id;
        insert techPersonDesign;
        
        allReadySelectedUsers =[select Technical_Person_Email__c from Technical_Person_Design_Notification__c where Design_Log_Form__c=:parent.Id];
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Mainetti System Administrator' LIMIT 1];
        usr = new User(LastName = 'LIVESTON',
                       FirstName='JASON',
                       Alias = 'jliv',
                       Email = 'tony.cheung@mainetti.com',
                       Username = 'tony.cheung@mainetti.com',
                       ProfileId = profileId.id,
                       TimeZoneSidKey = 'GMT',
                       LanguageLocaleKey = 'en_US',
                       EmailEncodingKey = 'UTF-8',
                       LocaleSidKey = 'en_US'
                      );
        insert usr;
        
        Group newGroup = new Group();
        newGroup.Name = queryParameter;
        newGroup.DoesIncludeBosses = false; 
        insert newGroup;
        
        GroupMember newMember=new GroupMember();
        newMember.GroupId=newGroup.Id;
        newMember.UserOrGroupId=usr.Id;
        
        usrLst = [select UserName,UserRole.Name, Profile.Name,Email, LastName, IsActive, FirstName,Mainetti_Company__c from User where IsActive = true and Id IN (select userorgroupid from groupmember where group.name =:setProfiles)
                                 order by LastName limit 100];
        
        System.AssertEquals(allReadySelectedUsers[0].Technical_Person_Email__c, usrLst[0].Email);
        emailExists=true;
        disableButton = false;
        recordExists = true;
        
        system.assertNotEquals(emailExists,false);
        designLogTechnicalPersonEmailController.wrapUser wrpUsr = new  designLogTechnicalPersonEmailController.wrapUser(usr);
        wrpUsr.user = usr;
        wrpUsr.selected = true;
        wrapUserList = new List<designLogTechnicalPersonEmailController.wrapUser>();
        wrapUserList.add(wrpUsr);
        
        system.assertNotEquals(recordExists,false);
        disableButton = true;
        
        designController.wrapUserList = wrapUserList;
        designController.processSelected();   
        System.AssertEquals(wrpUsr.selected, true); 
        
        //insert techSelectedUsers;
        System.assertNotEquals(designLogForm.Project_Status__c, 'Shelved');
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Design Project Status has to be "Complete", to send Email to Technical Persons'));
        disableButton = true;
        Test.stopTest();        
     }
}