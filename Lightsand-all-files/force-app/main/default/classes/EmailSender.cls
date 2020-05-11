public without sharing class EmailSender {
    User[] usr = null;
    public void sendMail(Online_Enquiry__c onlineEnqForPDF, String groupName, List<String> additionalEmailIds, String urlStr,String InternalCSUrl, Attachment attachmentPDF) {
        if(onlineEnqForPDF!=null){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if(additionalEmailIds!=null && additionalEmailIds.size()>0){
                additionalEmailIds.addAll(getEmailAddresses(groupName));
            }else{
                additionalEmailIds = getEmailAddresses(groupName);
            }
            System.debug('##All Email Addresses--->'+additionalEmailIds);
            System.debug('##All Email Addresses Size--->'+additionalEmailIds.size());
            mail.setToAddresses(additionalEmailIds);
                  
            //Map<Id, Profile> ProfileOwner = new Map<Id, Profile>([Select p.Id, p.Name from Profile p where Id =: userinfo.getProfileId()]);
            //mail.setSenderDisplayName(ProfileOwner.get(UserInfo.getUserId()).Name);//Sender would be owner of Profile
            
            // mail.setTargetObjectId(recipient.id); //target to receipient
           // mail.setTemplateId(et.id);
            
            EmailTemplate et = [SELECT id, Name, Description, Subject, Body FROM EmailTemplate where Name='Online Enquiry Alert to Country Sales'];
            
            String subject = et.Subject;
            if(onlineEnqForPDF.Name != null){
                subject = subject.replace('{!Online_Enquiry__c.Name}', onlineEnqForPDF.Name);
            } 
            if(onlineEnqForPDF.Order_Customer_Name__c != null){
                subject = subject.replace('{!Online_Enquiry__c.Order_Customer_Name__c}', onlineEnqForPDF.Order_Customer_Name__c);
            } 
            mail.setSubject(subject);
            
            String body = et.Body;
            if(onlineEnqForPDF.Name != null){
                body = body.replace('{!Online_Enquiry__c.Name}', onlineEnqForPDF.Name);
            } 
            if(onlineEnqForPDF.Order_Customer_Name__c != null){
                body = body.replace('{!Online_Enquiry__c.Order_Customer_Name__c}', onlineEnqForPDF.Order_Customer_Name__c);
            } 
            if(onlineEnqForPDF.Bill_to_Company__c != null){
                body = body.replace('{!Online_Enquiry__c.Bill_to_Company__c}', onlineEnqForPDF.Bill_to_Company__c);
            } else {
                body = body.replace('{!Online_Enquiry__c.Bill_to_Company__c}', '');
            }
            if(onlineEnqForPDF.Ship_to_Company__c != null){
                body = body.replace('{!Online_Enquiry__c.Ship_to_Company__c}', onlineEnqForPDF.Ship_to_Company__c);
            } else {
                body = body.replace('{!Online_Enquiry__c.Ship_to_Company__c}', '');
            }
            if(onlineEnqForPDF.Ship_to_Contact__c != null){
                body = body.replace('{!Online_Enquiry__c.Ship_to_Country__c}', onlineEnqForPDF.Ship_to_Contact__c);
            } else {
                body = body.replace('{!Online_Enquiry__c.Ship_to_Country__c}', '');
            }
            if(onlineEnqForPDF.OwnerId != null){
                User owner = [select Email, Name, Phone from User where Id=:onlineEnqForPDF.OwnerId];
                
                
                if(owner.Name != null){
                    body = body.replace('{!Online_Enquiry__c.OwnerFullName}', owner.Name);
                } 
                if(owner.Phone != null){
                    body = body.replace('{!Online_Enquiry__c.OwnerPhone}', owner.Phone);
                } 
                if(owner.Email != null){
                    body = body.replace('{!Online_Enquiry__c.OwnerEmail}', owner.Email);
                }             
            } 
            if(onlineEnqForPDF.Retailer_Code__c != null){
                body = body.replace('{!Online_Enquiry__c.Retailer_Code__c}', [select Name from Retailer_Code__c where Id=:onlineEnqForPDF.Retailer_Code__c].Name);
            } else {
                body = body.replace('{!Online_Enquiry__c.Retailer_Code__c}', '');
            }
            if(onlineEnqForPDF.Expected_Ship_Date__c != null){
                body = body.replace('{!Online_Enquiry__c.Expected_Ship_Date__c}', DateUtils.getFormattedDate(onlineEnqForPDF.Expected_Ship_Date__c));
            } else {
                body = body.replace('{!Online_Enquiry__c.Expected_Ship_Date__c}', '');
            }
            System.debug('##Comments--->'+onlineEnqForPDF.Customer_Comments__c);
            if(onlineEnqForPDF.Customer_Comments__c != null && onlineEnqForPDF.Customer_Comments__c.length()>0){
                body = body.replace('{!Online_Enquiry__c.Customer_Comments__c}', onlineEnqForPDF.Customer_Comments__c);
            } else {
                body = body.replace('{!Online_Enquiry__c.Customer_Comments__c}', '');
            }
            
            if(onlineEnqForPDF != null){
                body = body.replace('{!Online_Enquiry__c.Link}', InternalCSUrl+onlineEnqForPDF.Id);
            } 
           
            System.debug('##Email Template--->'+et.Body);
            mail.setPlainTextBody(body);
            
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setBody(attachmentPDF.Body);
            attach.setFileName(attachmentPDF.Name);
            attach.setContentType(attachmentPDF.ContentType);
            attach.setInline(false);
            Messaging.EmailFileAttachment[] attachment = new Messaging.EmailFileAttachment[]{attach};
            mail.setFileAttachments(attachment);
            
            String[] ccAddrs = new String[]{UserInfo.getUserEmail()};
            mail.setCcAddresses(ccAddrs);
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
     
        public void sendEnqConfirmMail(Online_Enquiry__c onlineEnqForPDF, String groupName, List<String> additionalEmailIds, String urlStr,String InternalCSUrl, Attachment attachmentPDF) {
        if(onlineEnqForPDF!=null){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if(additionalEmailIds!=null && additionalEmailIds.size()>0){
                additionalEmailIds.addAll(getEmailAddresses(groupName));
            }else{
                additionalEmailIds = getEmailAddresses(groupName);
            }
            System.debug('##All Email Addresses--->'+additionalEmailIds);
            System.debug('##All Email Addresses Size--->'+additionalEmailIds.size());
            //mail.setToAddresses(additionalEmailIds);
                  
            EmailTemplate et = [SELECT id, Name, Description, Subject, Body FROM EmailTemplate where Name='Online Enquiry Confirmation Alert to community'];
            
            String subject = et.Subject;
            if(onlineEnqForPDF.Name != null){
                subject = subject.replace('{!Online_Enquiry__c.Name}', onlineEnqForPDF.Name);
            } 
             
            mail.setSubject(subject);
            
            String body = et.Body;
            if(onlineEnqForPDF.Name != null){
                body = body.replace('{!Online_Enquiry__c.Name}', onlineEnqForPDF.Name);
            } 
            if(onlineEnqForPDF.Order_Customer_Name__c != null){
                body = body.replace('{!Online_Enquiry__c.Order_Customer_Name__c}', onlineEnqForPDF.Order_Customer_Name__c);
            } 
            if(onlineEnqForPDF.Account_Manager__c != null){
                body = body.replace('{!Online_Enquiry__c.Account_Manager__c}', onlineEnqForPDF.Account_Manager__c);
            } else {
                body = body.replace('{!Online_Enquiry__c.Account_Manager__c}', '');
            }
            
            if(onlineEnqForPDF.Account_Manager_Email_Address__c != null){
                body = body.replace('{!Online_Enquiry__c.Account_Manager_Email_Address__c}', onlineEnqForPDF.Account_Manager_Email_Address__c);
                additionalEmailIds.add(onlineEnqForPDF.Account_Manager_Email_Address__c);
            } else {
                body = body.replace('{!Online_Enquiry__c.Account_Manager_Email_Address__c}', '');
            }
            
            if(onlineEnqForPDF.Account_Manager_Contact_Number__c != null){
                body = body.replace('{!Online_Enquiry__c.Account_Manager_Contact_Number__c}', onlineEnqForPDF.Account_Manager_Contact_Number__c);
            } else {
                body = body.replace('{!Online_Enquiry__c.Account_Manager_Contact_Number__c}', '');
            }

            if(onlineEnqForPDF != null){
            
                body = body.replace('{!Online_Enquiry__c.Link}', urlStr + 'CustomerPortal/'+onlineEnqForPDF.Id);
            } 
           
            // set To : email
            if(onlineEnqForPDF.OwnerId != null){
                User owner = [select Email, Name, Phone from User where Id=:onlineEnqForPDF.OwnerId];
                
                if(owner.Email != null){
                    //body = body.replace('{!Online_Enquiry__c.OwnerEmail}', owner.Email);
                    mail.setToAddresses(new String[]{owner.Email});
                }             
            }
           
            System.debug('##Email Template--->'+et.Body);
            mail.setPlainTextBody(body);
            
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setBody(attachmentPDF.Body);
            attach.setFileName(attachmentPDF.Name);
            attach.setContentType(attachmentPDF.ContentType);
            attach.setInline(false);
            Messaging.EmailFileAttachment[] attachment = new Messaging.EmailFileAttachment[]{attach};
            mail.setFileAttachments(attachment);
            
            additionalEmailIds.add(UserInfo.getUserEmail());
            mail.setCcAddresses(additionalEmailIds);
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
    
    public void sendQuotationMail(Online_Enquiry__c onlineEnqForPDF, String groupName, List<String> additionalEmailIds, String urlStr,String InternalCSUrl, Attachment attachmentPDF,String latestAttVersion) {
        if(onlineEnqForPDF!=null){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if(additionalEmailIds!=null && additionalEmailIds.size()>0){
                additionalEmailIds.addAll(getEmailAddresses(groupName));
            }else{
                additionalEmailIds = getEmailAddresses(groupName);
            }
            System.debug('##All Email Addresses--->'+additionalEmailIds);
            System.debug('##All Email Addresses Size--->'+additionalEmailIds.size());
            //mail.setToAddresses(additionalEmailIds);
            //mail.setCcAddresses(additionalEmailIds);
            
            //Map<Id, Profile> ProfileOwner = new Map<Id, Profile>([Select p.Id, p.Name from Profile p where Id =: userinfo.getProfileId()]);
            //mail.setSenderDisplayName(ProfileOwner.get(UserInfo.getUserId()).Name);//Sender would be owner of Profile
            
            // mail.setTargetObjectId(recipient.id); //target to receipient
           // mail.setTemplateId(et.id);
            
            EmailTemplate et = [SELECT id, Name, Description, Subject, Body FROM EmailTemplate where Name='Online Quotation Alert to Community'];
            
            String subject = et.Subject;
            if(latestAttVersion != null){
                subject = subject.replace('{!Online_Enquiry__c.Name}', latestAttVersion);
            }  
            mail.setSubject(subject);
            
            String body = et.Body;
            if(onlineEnqForPDF.Name != null){
                body = body.replace('{!Online_Enquiry__c.Name}', onlineEnqForPDF.Name);
            } 
            
            if(onlineEnqForPDF.Account_Manager__c != null){
                body = body.replace('{!Online_Enquiry__c.Account_Manager__c}', onlineEnqForPDF.Account_Manager__c);
            } else {
                body = body.replace('{!Online_Enquiry__c.Account_Manager__c}', '');
            }
            
            if(onlineEnqForPDF.Account_Manager_Email_Address__c != null){
                body = body.replace('{!Online_Enquiry__c.Account_Manager_Email_Address__c}', onlineEnqForPDF.Account_Manager_Email_Address__c);
                additionalEmailIds.add(onlineEnqForPDF.Account_Manager_Email_Address__c);
            } else {
                body = body.replace('{!Online_Enquiry__c.Account_Manager_Email_Address__c}', '');
            }
            
            if(onlineEnqForPDF.Account_Manager_Contact_Number__c != null){
                body = body.replace('{!Online_Enquiry__c.Account_Manager_Contact_Number__c}', onlineEnqForPDF.Account_Manager_Contact_Number__c);
            } else {
                body = body.replace('{!Online_Enquiry__c.Account_Manager_Contact_Number__c}', '');
            }

            if(onlineEnqForPDF != null){
            
                body = body.replace('{!Online_Enquiry__c.Link}', urlStr + 'CustomerPortal/'+onlineEnqForPDF.Id);
            } 
           
            // set To : email
            if(onlineEnqForPDF.OwnerId != null){
                User owner = [select Email, Name, Phone from User where Id=:onlineEnqForPDF.OwnerId];
                
                if(owner.Email != null){
                    body = body.replace('{!Online_Enquiry__c.OwnerEmail}', owner.Email);
                    mail.setToAddresses(new String[]{owner.Email});
                }             
            } 
           
            System.debug('##Email Template--->'+et.Body);
            mail.setPlainTextBody(body);
            
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setBody(attachmentPDF.Body);
            attach.setFileName(attachmentPDF.Name);
            attach.setContentType(attachmentPDF.ContentType);
            attach.setInline(false);
            Messaging.EmailFileAttachment[] attachment = new Messaging.EmailFileAttachment[]{attach};
            mail.setFileAttachments(attachment);
            
            //String[] ccAddrs = new String[]{UserInfo.getUserEmail()};
            additionalEmailIds.add(UserInfo.getUserEmail());
            mail.setCcAddresses(additionalEmailIds);
            //mail.setToAddresses(ccAddrs);
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
    
    public void sendFinalPOMail(Online_Enquiry__c onlineEnqForPDF, String groupName, List<String> additionalEmailIds, String urlStr, String InternalCSUrl, Attachment attachmentPDF){
        if(onlineEnqForPDF!=null){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if(additionalEmailIds!=null && additionalEmailIds.size()>0){
                additionalEmailIds.addAll(getEmailAddresses(groupName));
            }else{
                additionalEmailIds = getEmailAddresses(groupName);
            }
            System.debug('##All Email Addresses--->'+additionalEmailIds);
            System.debug('##All Email Addresses Size--->'+additionalEmailIds.size());
            //mail.setToAddresses(additionalEmailIds);
                  
            //Map<Id, Profile> ProfileOwner = new Map<Id, Profile>([Select p.Id, p.Name from Profile p where Id =: userinfo.getProfileId()]);
            //mail.setSenderDisplayName(ProfileOwner.get(UserInfo.getUserId()).Name);//Sender would be owner of Profile
            
            // mail.setTargetObjectId(recipient.id); //target to receipient
           // mail.setTemplateId(et.id);
            
            EmailTemplate et = [SELECT id, Name, Description, Subject, Body FROM EmailTemplate where Name='Online Enquiry PO Received Alert to Mainetti Sales'];
            
            String subject = et.Subject;
            if(onlineEnqForPDF.Name != null){
                subject = subject.replace('{!Online_Enquiry__c.Name}', onlineEnqForPDF.Name);
            } 
            if(onlineEnqForPDF.Order_Customer_Name__c != null){
                subject = subject.replace('{!Online_Enquiry__c.Order_Customer_Name__c}', onlineEnqForPDF.Order_Customer_Name__c);
            } 
            mail.setSubject(subject);
            
            String body = et.Body;
            if(onlineEnqForPDF.Name != null){
                body = body.replace('{!Online_Enquiry__c.Name}', onlineEnqForPDF.Name);
            } 
            
            if(onlineEnqForPDF.Order_Customer_Name__c != null){
                body = body.replace('{!Online_Enquiry__c.Order_Customer_Name__c}', onlineEnqForPDF.Order_Customer_Name__c);
            }
            
            if(onlineEnqForPDF.Enquiry_Date__c != null){
                body = body.replace('{!Online_Enquiry__c.Enquiry_Date__c}', DateUtils.getFormattedDate(onlineEnqForPDF.Enquiry_Date__c));
            }

            if(onlineEnqForPDF.Customer_PO_No__c != null){
                body = body.replace('{!Online_Enquiry__c.Customer_PO_No__c}', onlineEnqForPDF.Customer_PO_No__c);
            }
            
            if(onlineEnqForPDF.Bill_to_Company__c != null){
                body = body.replace('{!Online_Enquiry__c.Bill_to_Company__c}', onlineEnqForPDF.Bill_to_Company__c);
            } else {
                body = body.replace('{!Online_Enquiry__c.Bill_to_Company__c}', '');
            }
            if(onlineEnqForPDF.Ship_to_Company__c != null){
                body = body.replace('{!Online_Enquiry__c.Ship_to_Company__c}', onlineEnqForPDF.Ship_to_Company__c);
            } else {
                body = body.replace('{!Online_Enquiry__c.Ship_to_Company__c}', '');
            }
            
            if(onlineEnqForPDF.Ship_to_Contact__c != null){
                body = body.replace('{!Online_Enquiry__c.Ship_to_Country__c}', onlineEnqForPDF.Ship_to_Contact__c);
            } else {
                body = body.replace('{!Online_Enquiry__c.Ship_to_Country__c}', '');
            }
            
            if(onlineEnqForPDF.OwnerId != null){
                User owner = [select Email, Name, Phone from User where Id=:onlineEnqForPDF.OwnerId];
               
                if(owner.Name != null){
                    body = body.replace('{!Online_Enquiry__c.OwnerFullName}', owner.Name);
                } 
                if(owner.Phone != null){
                    body = body.replace('{!Online_Enquiry__c.OwnerPhone}', owner.Phone);
                } 
                if(owner.Email != null){
                    body = body.replace('{!Online_Enquiry__c.OwnerEmail}', owner.Email);
                }             
            } 
            
            if(onlineEnqForPDF.Retailer_Code__c != null){
                body = body.replace('{!Online_Enquiry__c.Retailer_Code__c}', [select Name from Retailer_Code__c where Id=:onlineEnqForPDF.Retailer_Code__c].Name);
            } else {
                body = body.replace('{!Online_Enquiry__c.Retailer_Code__c}', '');
            }
            if(onlineEnqForPDF.Expected_Ship_Date__c != null){
                body = body.replace('{!Online_Enquiry__c.Expected_Ship_Date__c}', DateUtils.getFormattedDate(onlineEnqForPDF.Expected_Ship_Date__c));
            } else {
                body = body.replace('{!Online_Enquiry__c.Expected_Ship_Date__c}', '');
            }
            
            System.debug('##Comments--->'+onlineEnqForPDF.Customer_Comments__c);
            if(onlineEnqForPDF.Customer_Comments__c != null && onlineEnqForPDF.Customer_Comments__c.length()>0){
                body = body.replace('{!Online_Enquiry__c.Customer_Comments__c}', onlineEnqForPDF.Customer_Comments__c);
            } else {
                body = body.replace('{!Online_Enquiry__c.Customer_Comments__c}', '');
            }
            if(onlineEnqForPDF != null){
                body = body.replace('{!Online_Enquiry__c.Link}', InternalCSUrl+onlineEnqForPDF.Id);
            }
           
            if(onlineEnqForPDF.Account_Manager_Email_Address__c != null){
                additionalEmailIds.add(onlineEnqForPDF.Account_Manager_Email_Address__c);
            }
            
            System.debug('##Email Template--->'+et.Body);
            mail.setPlainTextBody(body);
            
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setBody(attachmentPDF.Body);
            attach.setFileName(attachmentPDF.Name);
            attach.setContentType(attachmentPDF.ContentType);
            attach.setInline(false);
            Messaging.EmailFileAttachment[] attachment = new Messaging.EmailFileAttachment[]{attach};
            mail.setFileAttachments(attachment);
            
            String[] ccAddrs = new String[]{UserInfo.getUserEmail()};
            mail.setCcAddresses(ccAddrs);
            mail.setToAddresses(additionalEmailIds);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
    
    private List<String> getEmailAddresses(String groupName){
        List<String> idList = new List<String>();
        List<String> mailToAddresses = new List<String>();
        Group g = [SELECT (select userOrGroupId from groupMembers) FROM group WHERE name =:groupName];
        for (GroupMember gm : g.groupMembers) {
            idList.add(gm.userOrGroupId);
        }
        System.debug('##In Id List--->'+idList);
        usr = [SELECT Id, Name, TempEmailFormula__c FROM user WHERE id IN :idList];
        System.debug('##Users--->'+usr);
        for(User u : usr) {
            System.debug('##Each Email--->'+u.TempEmailFormula__c);
            //System.debug([select TempEmail__c from User where Id=:u.Id].TempEmail__c);
            if(u.TempEmailFormula__c != null){
                mailToAddresses.add(u.TempEmailFormula__c);
            }
        }
        return mailToAddresses;
    }
}