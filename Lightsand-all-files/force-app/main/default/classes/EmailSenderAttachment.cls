public without sharing class EmailSenderAttachment {
    User[] usr = null;
    public void sendFinalPOMail(Wooden_Hanger_Requisition_Form__c WHDForPDF, String groupName, List<String> additionalEmailIds, String urlStr, String InternalCSUrl, Attachment attachmentPDF){
        if(WHDForPDF!=null){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if(additionalEmailIds!=null && additionalEmailIds.size()>0){
             //   additionalEmailIds.addAll(getEmailAddresses(groupName));
            }else{
             //   additionalEmailIds = getEmailAddresses(groupName);
            }
            System.debug('##All Email Addresses--->'+additionalEmailIds);
            System.debug('##All Email Addresses Size--->'+additionalEmailIds.size());
            //mail.setToAddresses(additionalEmailIds);
                  
            //Map<Id, Profile> ProfileOwner = new Map<Id, Profile>([Select p.Id, p.Name from Profile p where Id =: userinfo.getProfileId()]);
            //mail.setSenderDisplayName(ProfileOwner.get(UserInfo.getUserId()).Name);//Sender would be owner of Profile
            
            // mail.setTargetObjectId(recipient.id); //target to receipient
           // mail.setTemplateId(et.id);
            
            EmailTemplate et = [SELECT id, Name, Description, Subject, Body FROM EmailTemplate where Name='WD Mainetti to Factory Form'];
            
            String subject = et.Subject;
            if(WHDForPDF.Name != null){
                subject = subject.replace('{!Wooden_Hanger_Requisition_Form__c.Name}', WHDForPDF.Name);
            } 
            if(WHDForPDF.Name != null){
                subject = subject.replace('{!Wooden_Hanger_Requisition_Form__c.Customer_Information__c}', WHDForPDF.Customer_Information__c);
            } else {
            subject = subject.replace('{!Wooden_Hanger_Requisition_Form__c.Customer_Information__c}', ' ');
           }
            if(WHDForPDF.OwnerId != null){
                User owner = [select Email, Name, Phone from User where Id=:WHDForPDF.OwnerId];
                
                
                if(owner.Name != null){
                    subject= subject.replace('{!Wooden_Hanger_Requisition_Form__c.OwnerFullName}', owner.Name);
                } 
                            
            } 
            mail.setSubject(subject);
            
            String body = et.Body;
            
            
            if(WHDForPDF.OwnerId != null){
                User owner = [select Email, Name, Phone from User where Id=:WHDForPDF.OwnerId];
                
                
                if(owner.Name != null){
                    body = body .replace('{!Wooden_Hanger_Requisition_Form__c.OwnerFullName}', owner.Name);
                } 
                            
            }
            if(WHDForPDF.LastModifiedById!= null){
                User owner = [select Email, Name, Phone from User where Id=:WHDForPDF.LastModifiedById];
                
                
                if(owner.Name != null){
                    body = body .replace('{!Wooden_Hanger_Requisition_Form__c.LastModifiedBy}', owner.Name);
                } 
                            
            } 
            if(WHDForPDF.Name != null){
                body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Name}', WHDForPDF.Name);
            } else {
            body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Name}', '');
            }
            
            if(WHDForPDF.Customer_Information__c!= null){
                body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Customer_Information__c}', WHDForPDF.Customer_Information__c);
            } else {
            body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Customer_Information__c}', '');
            }
            
            if(WHDForPDF.Generation_Date__c!= null){
                body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Generation_Date__c}', DateUtils.getFormattedDate(WHDForPDF.Generation_Date__c));
            } else {
            body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Generation_Date__c}', '');
            }

            if(WHDForPDF.Model__c!= null){
                body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Model__c}', WHDForPDF.Model__c);
            } else {
            body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Model__c}', '');
            }
            
            if(WHDForPDF.Length__c!= null){
                body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Length__c}', WHDForPDF.Length__c);
            } else {
            body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Length__c}', '');
            }
            
            if(WHDForPDF.Width__c!= null){
                body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Width__c}', WHDForPDF.Width__c);
            } else {
            body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Width__c}', '');
            }
            
            if(WHDForPDF.Remark_Model__c!= null){
                body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Remark_Model__c}', WHDForPDF.Remark_Model__c);
            } else {
            body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Remark_Model__c}', '');
            }
                   
            if(WHDForPDF.Remark_IC__c!= null){
                body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Remark_IC__c}', WHDForPDF.Remark_IC__c);
            } else {
            body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Remark_IC__c}', '');
            }
            
            if(WHDForPDF.Remark__c!= null){
                body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Remark__c}', WHDForPDF.Remark_IC__c);
            } else {
            body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Remark__c}', '');
            }
            
            if(WHDForPDF.Country__c!= null){
                body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Country__c}', WHDForPDF.Country__c);
            } else {
            body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Country__c}', '');
            }
            
            //System.debug('##Comments--->'+WHDForPDF.Customer_Comments__c);
           
            if(WHDForPDF != null){
                body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Link}', InternalCSUrl+WHDForPDF.Id);
            } else {
            body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Link}', '');
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
            
            //attachment others
            List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
           for (Attachment attachItr : [SELECT id,Name,Body FROM Attachment WHERE Parentid =: WHDForPDF.Id and NAME='a'])
            {
                Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                efa.setFileName(attachItr.Name);
                efa.setBody(attachItr.Body);
                fileAttachments.add(efa);
            }
            
            
            
            
            String[] ccAddrs = new String[]{UserInfo.getUserEmail()};
            mail.setCcAddresses(ccAddrs);
            mail.setToAddresses(additionalEmailIds);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
            
            
            
            
        }
    }
    //to mainetti
    public void sendFinalMAINMail(Wooden_Hanger_Requisition_Form__c WHDForPDF, String groupName, List<String> additionalEmailIds, String urlStr, String InternalCSUrl, Attachment attachmentPDF){
        if(WHDForPDF!=null){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if(additionalEmailIds!=null && additionalEmailIds.size()>0){
             //   additionalEmailIds.addAll(getEmailAddresses(groupName));
            }else{
             //   additionalEmailIds = getEmailAddresses(groupName);
            }
            System.debug('##All Email Addresses--->'+additionalEmailIds);
            System.debug('##All Email Addresses Size--->'+additionalEmailIds.size());
            //mail.setToAddresses(additionalEmailIds);
                  
            //Map<Id, Profile> ProfileOwner = new Map<Id, Profile>([Select p.Id, p.Name from Profile p where Id =: userinfo.getProfileId()]);
            //mail.setSenderDisplayName(ProfileOwner.get(UserInfo.getUserId()).Name);//Sender would be owner of Profile
            
            // mail.setTargetObjectId(recipient.id); //target to receipient
           // mail.setTemplateId(et.id);
            
            EmailTemplate et = [SELECT id, Name, Description, Subject, Body FROM EmailTemplate where Name='WD New Sample Form Alert to Mainetti'];
            
            String subject = et.Subject;
            if(WHDForPDF.Name != null){
                subject = subject.replace('{!Wooden_Hanger_Requisition_Form__c.Name}', WHDForPDF.Name);
            } 
            if(WHDForPDF.OwnerId != null){
                User owner = [select Email, Name, Phone from User where Id=:WHDForPDF.OwnerId];
                
                
                if(owner.Name != null){
                    subject= subject.replace('{!Wooden_Hanger_Requisition_Form__c.OwnerFullName}', owner.Name);
                } 
                            
            } 
            mail.setSubject(subject);
            
            String body = et.Body;
            
            
            if(WHDForPDF.OwnerId != null){
                User owner = [select Email, Name, Phone from User where Id=:WHDForPDF.OwnerId];
                
                
                if(owner.Name != null){
                    body = body .replace('{!Wooden_Hanger_Requisition_Form__c.OwnerFullName}', owner.Name);
                } 
                            
            } 
            if(WHDForPDF.Name != null){
                body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Name}', WHDForPDF.Name);
            } else {
            body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Name}', '');
            }
            
            if(WHDForPDF.Customer_Information__c!= null){
                body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Customer_Information__c}', WHDForPDF.Customer_Information__c);
            } else {
            body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Customer_Information__c}', '');
            }
            
            if(WHDForPDF.Request_Date__c!= null){
                body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Request_Date__c}', DateUtils.getFormattedDate(WHDForPDF.Request_Date__c));
            } else {
            body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Request_Date__c}', '');
            }

            if(WHDForPDF.Model__c!= null){
                body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Model__c}', WHDForPDF.Model__c);
            } else {
            body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Model__c}', '');
            }
            
            if(WHDForPDF.Length__c!= null){
                body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Length__c}', WHDForPDF.Length__c);
            } else {
            body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Length__c}', '');
            }
            
            if(WHDForPDF.Width__c!= null){
                body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Width__c}', WHDForPDF.Width__c);
            } else {
            body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Width__c}', '');
            }
            
            if(WHDForPDF.Remark_Model__c!= null){
                body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Remark_Model__c}', WHDForPDF.Remark_Model__c);
            } else {
            body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Remark_Model__c}', '');
            }
                   
            if(WHDForPDF.Remark_IC__c!= null){
                body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Remark_IC__c}', WHDForPDF.Remark_IC__c);
            } else {
            body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Width__c}', '');
            }
            
            if(WHDForPDF.Country__c!= null){
                body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Country__c}', WHDForPDF.Country__c);
            } else {
            body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Country__c}', '');
            }
            
            //System.debug('##Comments--->'+WHDForPDF.Customer_Comments__c);
           
            if(WHDForPDF != null){
                body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Link}', InternalCSUrl+WHDForPDF.Id);
            } else {
            body = body.replace('{!Wooden_Hanger_Requisition_Form__c.Link}', '');
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