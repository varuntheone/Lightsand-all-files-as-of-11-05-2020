@isTest public class EmailSenderTest1{
    @IsTest(SeeAllData=true) public static void testEmailSenderTest() {
        //Online_Enquiry__c onlineEnqForPDF1 = [select Name, Order_Customer_Name__c, Bill_to_Company__c, Ship_to_Company__c, Ship_to_Contact__c, OwnerId, Retailer_Code__c , Expected_Ship_Date__c, Customer_Comments__c, Id from Online_Enquiry__c where Id=:rowId1];
        List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Ship_Bill_Address__c' and isActive=true];
        System.debug('Record Types:'+rtypes);
        Ship_Bill_Address__c billaddr = new Ship_Bill_Address__c();
        billaddr.Address_1__c = 'test';
        billaddr.Address_2__c = 'test';
        billaddr.City__c = 'Bangalore';
        billaddr.Contact__c = 'test';
        billaddr.Country__c = 'India';
        billaddr.Email_Address__c = 'test@crmit.com';
        billaddr.Factory_Name__c = 'test';
        for(RecordType rt: rtypes){
            if(rt.Name == 'Bill To'){
                System.debug('##Bill To Id:'+rt.Id);
                billaddr.RecordTypeId = rt.Id;
            }
        }
        insert billaddr;
        System.debug('##BNill Addr Id:'+billaddr.Id);
        Ship_Bill_Address__c shipaddr = new Ship_Bill_Address__c();
        shipaddr.Address_1__c = 'test';
        shipaddr.Address_2__c = 'test';
        shipaddr.City__c = 'Bangalore';
        shipaddr.Contact__c = 'test';
        shipaddr.Country__c = 'India';
        shipaddr.Email_Address__c = 'test@crmit.com';
        shipaddr.Factory_Name__c = 'test';
        for(RecordType rt: rtypes){
            if(rt.Name == 'Ship To'){
                System.debug('##Ship To Id:'+rt.Id);
                shipaddr.RecordTypeId = rt.Id;
             }
        }
        insert shipaddr;
        System.debug('##BNill Addr Id:'+shipaddr.Id);
        Retailer_Code__c rc = new Retailer_Code__c();
        rc.Name = 'JC PENNEY';
        //rc.Account__c = '001N000000HULtC'; //sandbox
        rc.Account__c = '0019000000sJJVs'; //production
        rc.Market_Segment__c = 'USA';
        insert rc;
        System.debug('##RC Id:'+rc.Id);
        //String retailerCodeId = 'a0090000003DMBR';
        //Retailer_Code__c rc = [select Name, Account__c, Market_Segment__c from Retailer_Code__c where Id=:retailerCodeId];
        //Date dt = Date.today();;
        //dt.today();
        
        Online_Enquiry__c onlineEnqForPDF1 = new Online_Enquiry__c(Bill_to_Company__c=billaddr.Id, Ship_to_Company__c=shipaddr.Id, Ship_to_Contact__c='test', Retailer_Code__c = rc.Id, Expected_Ship_Date__c=Date.today(), Customer_Comments__c='test');
        insert onlineEnqForPDF1;
        System.debug('##Enq Id:'+onlineEnqForPDF1.Id);
        System.debug('##--->onlineEnqForPDF1 :'+onlineEnqForPDF1 );
        List<String> additionalEmailIds = new List<String>();
        additionalEmailIds.add('dtejas@crmit.com');
         String urlStr = 'http://www.google.com';
         Attachment attachmentPDF = new Attachment();
        attachmentPDF.Name = onlineEnqForPDF1.Id+'.pdf';
        attachmentPDF.Body = Blob.toPdf('Test');
        attachmentPDF.ParentId = onlineEnqForPDF1.Id;
        insert attachmentPDF;
        System.debug('##Attach Id:'+attachmentPDF.Id);
         String groupName = 'Online Enquiry-HK-USA Group';
         //EmailSender emailSender = new EmailSender();
        //emailSender.sendMail(onlineEnqForPDF1, groupName, additionalEmailIds, urlStr, null,attachmentPDF);
        //emailSender.sendMail(onlineEnqForPDF1, groupName, null, urlStr, null,attachmentPDF);
        onlineEnqForPDF1.Customer_Comments__c = 'test';
        update onlineEnqForPDF1;
        System.debug('##See comments');
       //emailSender.sendMail(onlineEnqForPDF1, groupName, additionalEmailIds, urlStr, null,attachmentPDF);
        onlineEnqForPDF1.Bill_To__c = null;
        onlineEnqForPDF1.Ship_To__c = null;
         onlineEnqForPDF1.Customer_Comments__c = 'Test';
       onlineEnqForPDF1.Ship_to_Contact__c = null;
       onlineEnqForPDF1.Retailer_Code__c = null;
       onlineEnqForPDF1.Expected_Ship_Date__c = null;
       onlineEnqForPDF1.Customer_Comments__c = null;
       update onlineEnqForPDF1;
         //emailSender.sendMail(onlineEnqForPDF1, groupName, null, urlStr, null,attachmentPDF);
        //emailSender.sendMail(null, groupName, null, urlStr, null,attachmentPDF);
       
    }
}