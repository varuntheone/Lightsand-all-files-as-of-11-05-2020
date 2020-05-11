global class sendMonthlySalesUploadEmailReminder implements Schedulable{
    
    global void execute(SchedulableContext ctx) {
        preparePublicGroupMembersForAlert(); 
    }
	//Getting the list of User Ids based on their email Id
    public static void preparePublicGroupMembersForAlert(){
        List<String> emailIds = getEmailAddressesForAlert();
        System.debug('emailIds'+emailIds);
        
        Set<String> userNameSet = new Set<String>();
        String emailReminderSentTo = '';
        for (string email : emailIds){
            if(string.isNotBlank(email)){
                userNameSet.add(email);
                emailReminderSentTo += email;
            }
        }   
        System.debug('userName'+userNameSet);
        
        List<User> userListForGroup = [select Id from user where email IN:userNameSet];
        
        System.debug('userListForGroup'+userListForGroup);
        Group publicGroup  = [SELECT Id FROM Group WHERE Name = 'Sales Upload Email Reminder Team'];
        System.debug('publicGroup'+publicGroup);
        list<groupMember> newGroupList = new list<groupMember>();
        list<groupMember> existingMemGroupList = [SELECT UserOrGroupId FROM GroupMember WHERE GroupId =:publicGroup.Id];
        System.debug('existingMemGroupList'+existingMemGroupList);
        if(existingMemGroupList.size() > 0){
            delete existingMemGroupList;
        }
        for(User us : userListForGroup){
            groupMember gp = new groupMember(groupId = publicGroup.Id);
            gp.UserOrGroupId = us.Id;
            newGroupList.add(gp);
        }
        System.debug('newGroupList .size()'+newGroupList.size());
        if(newGroupList.size() > 0){
              insert newGroupList; 
            //creating the task in the future only if there
            // are memebers in the group
        	creatUploadReminderTask(emailReminderSentTo);
         }       
        
    }
    
    
    // getting all the companies for which sales data will be uploaded.
    public static Map<string,string> getSalesCountryCompanyMap(){
        
        Map<string,string> salesCompMap = new Map<string,string>();
        list<Sales_Report_Company__c> salesCompany = new list<Sales_Report_Company__c>();
        salesCompany = [Select Company__c,Contact_Email_Address__c from Sales_Report_Company__c where Send_Email_Notification__c = true];    
        System.debug('salesCompany:'+salesCompany);
        for (Sales_Report_Company__c salesCmp : salesCompany){  
            if(String.isNotBlank(salesCmp.Company__c) && String.isNotEmpty(salesCmp.Contact_Email_Address__c))
                salesCompMap.put(salesCmp.Company__c.toLowerCase(),salesCmp.Contact_Email_Address__c);              
        }  
        System.debug('Sales Company Email MAP::::'+salesCompMap);
        return salesCompMap;
    }
    //Checking which all the companies have submitted the data for the particular month and year)
    public static List<Data_Upload_Sales__c> dataSubmitted(string companyArray, string selmonth, string selyear)
    {
        System.debug('companyArray::::'+companyArray+'::::selmonth:::::'+selmonth+'::::::selyear::::::'+selyear);
        List<string> companyList = companyArray.split(',');
        Set<String> companyName = new Set<String>();
        for (string valFormt : companyList){
            if(string.isNotBlank(valFormt)){
                companyName.add(valFormt);
            }
        }   
        System.debug('LIST companyName::::'+companyName);
        List<Data_Upload_Sales__c> fetchData = [select Sales_Data_Company__c,Month__c,Year__c from  Data_Upload_Sales__c where Sales_Data_Company__c IN:companyName and Month__c =: selmonth and Year__c =: selyear];
        System.debug('dataSubmitted::::'+fetchData.size());
        return fetchData;        
    }
    public static List<String> getEmailAddressesForAlert() {
        Map<string,string> companyMap = getSalesCountryCompanyMap();
         system.debug('companyMap:'+companyMap);
        String companyNameString = '';
        for(String comp : companyMap.keyset()){
           
            //String companyName = companyMap.get(comp);
            String companyName = comp;
            if(String.isNotBlank(companyName)){
                companyNameString += companyName+',';
            }
        }
        System.debug('companyNameString::::'+companyNameString);
        Date currentDate =  Date.today();
        String uploadSubmitMonth = String.valueOf(currentDate.month()-1);
        String uploadSubmitYear = String.valueOf(currentDate.year());
        
        Map <String, String> monthString = new Map <String, String> {'1'=>'jan', '2'=>'feb'
            , '3'=>'mar', '4'=>'apr', '5'=>'may', '6'=>'jun', '7'=>'jul', '8'=>'aug', '9'=>'sep'
            , '10'=>'oct', '11'=>'nov', '12'=>'dec'}; 
                System.debug('uploadSubmitMonth::::'+uploadSubmitMonth+':::::uploadSubmitYear:::'+uploadSubmitYear+':::monthString.get(uploadSubmitMonth):::'+monthString.get(uploadSubmitMonth));
        List<Data_Upload_Sales__c> companiesDataSubmitted =  dataSubmitted(companyNameString, monthString.get(uploadSubmitMonth), uploadSubmitYear);
         System.debug('companiesDataSubmitted::::'+companiesDataSubmitted);
        Map<string,string> dataNotSubmittedCompanies = companyMap;
        for ( Data_Upload_Sales__c uploadCompanies : companiesDataSubmitted ){
            
            if(companyMap.containsKey(uploadCompanies.Sales_Data_Company__c.toLowerCase())){
                System.debug('uploadCompanies.Sales_Data_Company__c.toLowerCase()::::::::'+uploadCompanies.Sales_Data_Company__c.toLowerCase());
                dataNotSubmittedCompanies.remove(uploadCompanies.Sales_Data_Company__c.toLowerCase());
            }                     
        }    
        System.debug('dataNotSubmittedCompanies::::::::'+dataNotSubmittedCompanies);
        List<String> mailToAddresses = new List<String>();
        for(String comp : dataNotSubmittedCompanies.keyset()){
            String companyEmailAddress = dataNotSubmittedCompanies.get(comp);
            mailToAddresses.add(companyEmailAddress);
        }
        //string tempEmail = 'tony.cheung@mainetti.com';
        //mailToAddresses.add(tempEmail);
        System.debug('mailToAddresses::::::::'+mailToAddresses);
        return mailToAddresses;
    }
    @future
    public static void creatUploadReminderTask(String emailReminderSentTo){
        
        Date d = (System.today()+3);
        Datetime dt = (DateTime)d;
        String dayOfWeek = dt.format('EEEE');
        
        //boolean  status = true;
        Task tsk = new Task();
        tsk.Subject = 'Sales Upload Email Reminder Team';
        //tsk.WhatId = [select Id from Inventory_Transaction_Master__c Limit 1].Id;
        //This is the default...
        tsk.OwnerId = UserInfo.getUserId();
        tsk.CallDisposition = dayOfWeek;
        tsk.Description = 'Email Send To Following Users \n'+emailReminderSentTo;
        tsk.Status = 'In Progress';
        tsk.Type = 'Upload Reminder';
        
        try {
            insert tsk;
        } catch (Exception e) {
            //status=false;
            System.debug('######### Error During Task Creation::::'+e.getMessage());
        }       
        System.debug('######### New Task Created:::::---'+tsk.Id);
       
        //return status;
    }
    
}