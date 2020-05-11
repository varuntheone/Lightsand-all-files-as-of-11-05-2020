@isTest
public  class sendMonthlySalesUploadEmailReminderTest {
    
    static testmethod void preparePublicGroupMembersForAlertTest()
    {
        Sales_Report_Company__c salesReport = new Sales_Report_Company__c(Company__c = 'Hong Kong', Contact_Email_Address__c = 'ashwin.raj@techkasetti.com');
        insert salesReport;
        List<Sales_Report_Company__c> salesReports = [Select Company__c,Contact_Email_Address__c from Sales_Report_Company__c where Send_Email_Notification__c = true];
        System.assertEquals(salesReport.Company__c, 'Hong Kong');
        System.assertEquals(salesReport.Contact_Email_Address__c, 'ashwin.raj@techkasetti.com');
        sendMonthlySalesUploadEmailReminder.getSalesCountryCompanyMap();
        String company = 'Hong Kong'; 
        String month = 'Jan';
        String year = '2019';
        String emailReminderSentTo = '';
        
        Sales_Report_Company__c salesRepComp = new Sales_Report_Company__c();
        salesRepComp.Company__c = 'Hong Kong';
        salesRepComp.Contact_Email_Address__c = 'ashwin.raj@techkasetti.com';
       // salesRepComp.Send_Email_Notification__c = true;
        Insert salesRepComp; 
        
        
        Data_Upload_Sales__c dataSales = new Data_Upload_Sales__c();
        dataSales.Sales_Data_Company__c = 'Hong Kong';
        dataSales.Month__c = 'Feb';
        dataSales.Year__c = '2020';
        insert dataSales;
        
        Set<String> userNameSet = new Set<String>();
        List<User> userListForGroup = [select Id from user where email IN:userNameSet];        
        Group publicGroup  = [SELECT Id FROM Group WHERE Name = 'Sales Upload Email Reminder Team'];
        sendMonthlySalesUploadEmailReminder.dataSubmitted(company,month,year);
        sendMonthlySalesUploadEmailReminder.creatUploadReminderTask(emailReminderSentTo);
        sendMonthlySalesUploadEmailReminder.getEmailAddressesForAlert();
        sendMonthlySalesUploadEmailReminder.preparePublicGroupMembersForAlert();
      //  sendMonthlySalesUploadEmailReminder.getSalesCountryCompanyMap();
       sendMonthlySalesUploadEmailReminder sendMonth = new sendMonthlySalesUploadEmailReminder();
        System.SchedulableContext ctx;
        sendMonth.execute(ctx);
    }
    
    static testmethod void preparePublicGroupForAlertTest(){
         Sales_Report_Company__c salesRepComp = new Sales_Report_Company__c();
        salesRepComp.Company__c = 'Hong Kong';
        salesRepComp.Contact_Email_Address__c = 'ashwin.raj@techkasetti.com';
        salesRepComp.Send_Email_Notification__c = true;
        Insert salesRepComp; 
        
        
        Data_Upload_Sales__c dataSales = new Data_Upload_Sales__c();
        dataSales.Sales_Data_Company__c = 'hong Kong';
        dataSales.Month__c = 'Feb';
        dataSales.Year__c = '2020';
        insert dataSales;
        
        Data_Upload_Sales__c dataSales1 = new Data_Upload_Sales__c();
        dataSales1.Sales_Data_Company__c = 'hong Kong';
        dataSales1.Month__c = 'Jan';
        dataSales1.Year__c = '2020';
        insert dataSales1;
         sendMonthlySalesUploadEmailReminder.getSalesCountryCompanyMap();
       sendMonthlySalesUploadEmailReminder.getEmailAddressesForAlert();
       // sendMonthlySalesUploadEmailReminder.preparePublicGroupMembersForAlert();
    }
    
     static testmethod void prepareMonthlyPublicGroupForAlertTest(){
         Sales_Report_Company__c salesRepComp = new Sales_Report_Company__c();
        salesRepComp.Company__c = 'Hong Kong';
        salesRepComp.Contact_Email_Address__c = 'ashwin.raj@techkasetti.com';
       // salesRepComp.Send_Email_Notification__c = true;
        Insert salesRepComp; 
        
        
        Data_Upload_Sales__c dataSales = new Data_Upload_Sales__c();
        dataSales.Sales_Data_Company__c = 'hong Kong';
        dataSales.Month__c = 'Jan';
        dataSales.Year__c = '2019';
        insert dataSales;
         sendMonthlySalesUploadEmailReminder.getSalesCountryCompanyMap();
       sendMonthlySalesUploadEmailReminder.getEmailAddressesForAlert();
        sendMonthlySalesUploadEmailReminder.preparePublicGroupMembersForAlert();
    }
}