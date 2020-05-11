public class Utility {
 /*Utility Method - Generates PDF and Sends Mail - START*/
 private static transient Map<String, Id> recordTypeIds;
 private static transient Map<String, Schema.SObjectType> gd;
 
 public static void getFinalPDFContent(String onlineEnquiryId) {
    //  setting Online Enquiry Row Id
    System.debug('getFinalPDFContent - START');
    PageReference pdf = Page.PdfGeneratorTemplate;
    pdf.getParameters().put('id', onlineEnquiryId);

    // querying online enquiry for mail parameter
    Online_Enquiry__c onlineEnqForPDF = [select Market__c,Name, Enquiry_Date__c, Sales_Representative__c, Mainetti_Company__c, Bill_to_Company__c, Bill_to_Address1__c, Bill_to_Address2__c, Bill_to_Contact__c, Bill_to_State__c, Bill_to_Country__c, Bill_to_Email__c, Bill_to_Fax__c, Bill_to_Postcode__c, Bill_to_Tel__c, Ship_to_Address1__c, Ship_to_Address2__c, Ship_to_Company__c, Ship_to_Contact__c, Ship_to_Country__c, Ship_to_Email__c, Ship_to_Fax__c, Ship_to_Postcode__c, Ship_to_State__c, Ship_to_Tel__c, Order_Country__c, Order_Customer_Name__c, OwnerId, Expected_Ship_Date__c, Customer_Comments__c, Retailer_Code__c from Online_Enquiry__c where Id = : onlineEnquiryId];

    // query Attachment
    Integer latestVersionNumber = 1;
    try{
        //Attachment lastVerAttachment = [SELECT Name FROM Attachment where ParentId=:onlineEnquiryId AND Name Like '%_QUOTE_V%' order by Name DESC LIMIT 1];
        Attachment lastVerAttachment = [SELECT Name FROM Attachment where ParentId=:onlineEnquiryId AND Name Like '%_PO_V%' order by CreatedDate DESC LIMIT 1];
         
        System.debug('lastVerAttachment:'+lastVerAttachment);
        String attachName = lastVerAttachment.Name;
        
        System.debug('attachName:'+attachName);
        String[] splittedName = attachName.split('\\.');
        
        if(lastVerAttachment!=null){
            if(attachName.contains('_V')){
                // attachment version issue fixed
                //String lastCharOfAttachName = splittedName[0].right(1);
                String lastCharOfAttachName = splittedName[0].split('_V')[1];
                System.debug('lastCharOfAttachName:'+lastCharOfAttachName);
                
                latestVersionNumber = Integer.valueof(lastCharOfAttachName)+1;
                System.debug('latestVersionNumber:'+latestVersionNumber);
            }
        }
    }catch(Exception attachmentQueryEx){
        System.debug('Exception Occured While Generating Quote:'+attachmentQueryEx);
    }
    
    // get pdf content
    Blob body;
    try {
    body = pdf.getContentAsPDF();
    } catch (VisualforceException e) {
    body = Blob.valueOf('Some Text');
    }

    // create the new attachment
    Attachment attachmentPDF = new Attachment();
    attachmentPDF.Body = body;
    //attachmentPDF.Name = onlineEnqForPDF.Name + '_PO.pdf';
    attachmentPDF.Name = onlineEnqForPDF.Name + '_PO_V'+string.valueof(latestVersionNumber)+'.pdf';
    attachmentPDF.IsPrivate = false;
    attachmentPDF.ParentId = onlineEnquiryId;
    insert attachmentPDF;
    System.debug('getFinalPDFContent - END');

    // update Quotation Date
    onlineEnqForPDF.PO_Generation_Date__c = Date.today();
    onlineEnqForPDF.Quotation_Status__c = 'PO Received';
    onlineEnqForPDF.Enquiry_Status__c = 'PO Generated';
    // update by tony 22-Mar
    //if(onlineEnqForPDF.RecordTypeId!=getRecordTypeIdByName('Online_Enquiry__c','Decathlon Order'))
    onlineEnqForPDF.RecordTypeId = getRecordTypeIdByName('Online_Enquiry__c','Order -Locked');
    //else
    //onlineEnqForPDF.RecordTypeId=getRecordTypeIdByName('Online_Enquiry__c','Decathlon Order');
    
    onlineEnqForPDF.Is_Email_Reminder_Enabled__c = false;
    update(onlineEnqForPDF);
    
    //Send Mail Logic Starts
    try {
        Email_Order_Detail__c emailOrderDetail = [select URLString__c,InternalCSUrl__c, Group_Name__c, Additional_Email_Addresses__c from Email_Order_Detail__c where Order_to_Country__c = : onlineEnqForPDF.Order_Country__c AND Market__c =:onlineEnqForPDF.Market__c LIMIT 1];
        String urlOfRec = '';
        String InternalCSUrl = '';
        if (emailOrderDetail != null) {
             String addtionMailIds = emailOrderDetail.Additional_Email_Addresses__c;
             List < String > additionalEmailIds = new List < String > ();
             if (addtionMailIds != null) {
              additionalEmailIds = addtionMailIds.split(';');
             }
             
             if (emailOrderDetail.Group_Name__c != null) {
              if (emailOrderDetail.URLString__c != null && emailOrderDetail.URLString__c.length() > 0) {
               urlOfRec = emailOrderDetail.URLString__c;
              } else {
               urlOfRec = 'URL Not Found';
              }
              
              if (emailOrderDetail.InternalCSUrl__c != null && emailOrderDetail.InternalCSUrl__c.length() > 0) {
               InternalCSUrl = emailOrderDetail.InternalCSUrl__c;
              } else {
               InternalCSUrl = 'URL Not Found';
              }
              
              EmailSender emailSend = new EmailSender();
              //emailSend.sendMail(emailOrderDetail.Group_Name__c, additionalEmailIds);
              //emailSend.sendMail(onlineEnqForPDF, emailOrderDetail.Group_Name__c, additionalEmailIds, urlOfRec, attachmentPDF);
              emailSend.sendFinalPOMail(onlineEnqForPDF, emailOrderDetail.Group_Name__c, additionalEmailIds, urlOfRec, InternalCSUrl, attachmentPDF);
             }
        } else {
            System.debug('Unable to query emailOrderDetail from Email_Order_Detail__c object.');
        }
    } catch (Exception e) {
        System.debug('Exception:' + e.getMessage());
    }
    ////Send Mail Logic Ends
  }
  /*Utility Method - Generates PDF and Sends Mail - END */

  public static void getRevisedFinalPDFContent(String onlineEnquiryId) {
    //  setting Online Enquiry Row Id
    System.debug('getFinalPDFContent - START');
    PageReference pdf = Page.PdfGeneratorTemplate;
    pdf.getParameters().put('id', onlineEnquiryId);

    // querying online enquiry for mail parameter
    Online_Enquiry__c onlineEnqForPDF = [select Market__c,Name, Enquiry_Date__c, Sales_Representative__c, Mainetti_Company__c, Bill_to_Company__c, Bill_to_Address1__c, Bill_to_Address2__c, Bill_to_Contact__c, Bill_to_State__c, Bill_to_Country__c, Bill_to_Email__c, Bill_to_Fax__c, Bill_to_Postcode__c, Bill_to_Tel__c, Ship_to_Address1__c, Ship_to_Address2__c, Ship_to_Company__c, Ship_to_Contact__c, Ship_to_Country__c, Ship_to_Email__c, Ship_to_Fax__c, Ship_to_Postcode__c, Ship_to_State__c, Ship_to_Tel__c, Order_Country__c, Order_Customer_Name__c, OwnerId, Expected_Ship_Date__c, Customer_Comments__c, Retailer_Code__c from Online_Enquiry__c where Id = : onlineEnquiryId];

    // query Attachment
    Integer latestVersionNumber = 1;
    try{
        //Attachment lastVerAttachment = [SELECT Name FROM Attachment where ParentId=:onlineEnquiryId AND Name Like '%_QUOTE_V%' order by Name DESC LIMIT 1];
        Attachment lastVerAttachment = [SELECT Name FROM Attachment where ParentId=:onlineEnquiryId AND Name Like '%_PO_V%' order by CreatedDate DESC LIMIT 1];
         
        System.debug('lastVerAttachment:'+lastVerAttachment);
        String attachName = lastVerAttachment.Name;
        
        System.debug('attachName:'+attachName);
        String[] splittedName = attachName.split('\\.');
        
        if(lastVerAttachment!=null){
            if(attachName.contains('_V')){
                // attachment version issue fixed
                //String lastCharOfAttachName = splittedName[0].right(1);
                String lastCharOfAttachName = splittedName[0].split('_V')[1];
                System.debug('lastCharOfAttachName:'+lastCharOfAttachName);
                
                latestVersionNumber = Integer.valueof(lastCharOfAttachName)+1;
                System.debug('latestVersionNumber:'+latestVersionNumber);
            }
        }
    }catch(Exception attachmentQueryEx){
        System.debug('Exception Occured While Generating Quote:'+attachmentQueryEx);
    }
    
    // get pdf content
    Blob body;
    try {
    body = pdf.getContentAsPDF();
    } catch (VisualforceException e) {
    body = Blob.valueOf('Some Text');
    }

    // create the new attachment
    Attachment attachmentPDF = new Attachment();
    attachmentPDF.Body = body;
    //attachmentPDF.Name = onlineEnqForPDF.Name + '_PO.pdf';
    attachmentPDF.Name = onlineEnqForPDF.Name + '_PO_V'+string.valueof(latestVersionNumber)+'.pdf';
    attachmentPDF.IsPrivate = false;
    attachmentPDF.ParentId = onlineEnquiryId;
    insert attachmentPDF;
    System.debug('getFinalPDFContent - END');

    // update Quotation Date
    onlineEnqForPDF.PO_Generation_Date__c = Date.today();
    //onlineEnqForPDF.Quotation_Status__c = 'PO Received';
    onlineEnqForPDF.Enquiry_Status__c = 'PO Change Request In-Progress';
    //onlineEnqForPDF.RecordTypeId = getRecordTypeIdByName('Online_Enquiry__c','Order -Locked');
    
    onlineEnqForPDF.Is_Email_Reminder_Enabled__c = false;
    update(onlineEnqForPDF);
    
    //Send Mail Logic Starts
    try {
        Email_Order_Detail__c emailOrderDetail = [select URLString__c,InternalCSUrl__c, Group_Name__c, Additional_Email_Addresses__c from Email_Order_Detail__c where Order_to_Country__c = : onlineEnqForPDF.Order_Country__c AND Market__c =:onlineEnqForPDF.Market__c LIMIT 1];
        String urlOfRec = '';
        String InternalCSUrl = '';
        if (emailOrderDetail != null) {
             String addtionMailIds = emailOrderDetail.Additional_Email_Addresses__c;
             List < String > additionalEmailIds = new List < String > ();
             if (addtionMailIds != null) {
              additionalEmailIds = addtionMailIds.split(';');
             }
             
             if (emailOrderDetail.Group_Name__c != null) {
              if (emailOrderDetail.URLString__c != null && emailOrderDetail.URLString__c.length() > 0) {
               urlOfRec = emailOrderDetail.URLString__c;
              } else {
               urlOfRec = 'URL Not Found';
              }
              
              if (emailOrderDetail.InternalCSUrl__c != null && emailOrderDetail.InternalCSUrl__c.length() > 0) {
               InternalCSUrl = emailOrderDetail.InternalCSUrl__c;
              } else {
               InternalCSUrl = 'URL Not Found';
              }
              
              EmailSender emailSend = new EmailSender();
              //emailSend.sendMail(emailOrderDetail.Group_Name__c, additionalEmailIds);
              //emailSend.sendMail(onlineEnqForPDF, emailOrderDetail.Group_Name__c, additionalEmailIds, urlOfRec, attachmentPDF);
              emailSend.sendFinalPOMail(onlineEnqForPDF, emailOrderDetail.Group_Name__c, additionalEmailIds, urlOfRec, InternalCSUrl, attachmentPDF);
             }
        } else {
            System.debug('Unable to query emailOrderDetail from Email_Order_Detail__c object.');
        }
    } catch (Exception e) {
        System.debug('Exception:' + e.getMessage());
    }
    ////Send Mail Logic Ends
  }
  /*Utility Method - Generates PDF and Sends Mail - END */
  
 /*Utility Method - Returns the Formated Date - START*/
 public static String getFormattedDate(Date dateValue) {
   Datetime tempDateValue = null;
   String formattedDate = '';
   if (dateValue != null) {
    tempDateValue = Datetime.newInstance(dateValue.year(), dateValue.month(), dateValue.day());
    System.debug('Non Formatted Date--->' + dateValue);
    formattedDate = tempDateValue.format('yyyy-MM-dd');
    System.debug('Formatted Date--->' + tempDateValue);
   }
   return formattedDate;
  }
  /*Utility Method - Returns the Formated Date - END*/

 public static void getQuotationPdf(String onlineEnquiryId) {
    //  setting Online Enquiry Row Id
    System.debug('getFinalPDFContent - START');
    PageReference qutotationPdf = Page.QutotationGenerationPdfTemplate;
    qutotationPdf.getParameters().put('id', onlineEnquiryId);

    // querying online enquiry details for mail parameter
    Online_Enquiry__c onlineEnqForPDF = [select Market__c,Name, Enquiry_Date__c, Sales_Representative__c, Mainetti_Company__c, Bill_to_Company__c, Bill_to_Address1__c, Bill_to_Address2__c, Bill_to_Contact__c, Bill_to_State__c, Bill_to_Country__c, Bill_to_Email__c, Bill_to_Fax__c, Bill_to_Postcode__c, Bill_to_Tel__c, Ship_to_Address1__c, Ship_to_Address2__c, Ship_to_Company__c, Ship_to_Contact__c, Ship_to_Country__c, Ship_to_Email__c, Ship_to_Fax__c, Ship_to_Postcode__c, Ship_to_State__c, Ship_to_Tel__c, Order_Country__c, Order_Customer_Name__c, OwnerId, Expected_Ship_Date__c, Customer_Comments__c, Retailer_Code__c,Account_Manager__c,Account_Manager_Email_Address__c,Account_Manager_Contact_Number__c from Online_Enquiry__c where Id = : onlineEnquiryId];

    // query Attachment
    Integer latestVersionNumber = 1;
    try{
        //Attachment lastVerAttachment = [SELECT Name FROM Attachment where ParentId=:onlineEnquiryId AND Name Like '%_QUOTE_V%' order by Name DESC LIMIT 1];
        Attachment lastVerAttachment = [SELECT Name FROM Attachment where ParentId=:onlineEnquiryId AND Name Like '%_QUOTE_V%' order by CreatedDate DESC LIMIT 1];
         
        System.debug('lastVerAttachment:'+lastVerAttachment);
        String attachName = lastVerAttachment.Name;
        
        System.debug('attachName:'+attachName);
        String[] splittedName = attachName.split('\\.');
        
        if(lastVerAttachment!=null){
            if(attachName.contains('_V')){
                // attachment version issue fixed
                //String lastCharOfAttachName = splittedName[0].right(1);
                String lastCharOfAttachName = splittedName[0].split('_V')[1];
                System.debug('lastCharOfAttachName:'+lastCharOfAttachName);
                
                latestVersionNumber = Integer.valueof(lastCharOfAttachName)+1;
                System.debug('latestVersionNumber:'+latestVersionNumber);
            }
        }
    }catch(Exception attachmentQueryEx){
        System.debug('Exception Occured While Generating Quote:'+attachmentQueryEx);
    }
    
    // the contents of the attachment from the pdf
    String versionNumber = 'V'+String.valueof(latestVersionNumber);
    qutotationPdf.getParameters().put('quoteVersion', versionNumber);
    Blob qutotationPdfBody;
    try {
        qutotationPdfBody = qutotationPdf.getContentAsPDF();
    } catch (VisualforceException e) {
        qutotationPdfBody = Blob.valueOf('Some Text');
    }
    
    // attachment name 
    String emailVersion = onlineEnqForPDF.Name + '_QUOTE_V'+string.valueof(latestVersionNumber);
    
    // create the new attachment
    Attachment qutotationPdfAttachment = new Attachment();
    qutotationPdfAttachment.Body = qutotationPdfBody;
    qutotationPdfAttachment.Name = onlineEnqForPDF.Name + '_QUOTE_V'+string.valueof(latestVersionNumber)+'.pdf';
    qutotationPdfAttachment.IsPrivate = false;
    qutotationPdfAttachment.ParentId = onlineEnquiryId;
    insert qutotationPdfAttachment;
    
    // update Quotation Date
    onlineEnqForPDF.Last_Quotation_Date__c = Date.today();
    onlineEnqForPDF.Quotation_Status__c = 'Quotation Send';
    onlineEnqForPDF.Is_Email_Reminder_Enabled__c = true;
    update(onlineEnqForPDF);
            
    try {
    //Send Mail Logic Starts
    Email_Order_Detail__c emailOrderDetail = [select URLString__c,InternalCSUrl__c, Group_Name__c, Additional_Email_Addresses__c from Email_Order_Detail__c where Order_to_Country__c = : onlineEnqForPDF.Order_Country__c AND Market__c =:onlineEnqForPDF.Market__c LIMIT 1];
    String urlOfRec = '';
    String InternalCSUrl = '';

    if (emailOrderDetail != null) {
     String addtionMailIds = emailOrderDetail.Additional_Email_Addresses__c;
     List < String > additionalEmailIds = new List < String > ();
     if (addtionMailIds != null) {
      additionalEmailIds = addtionMailIds.split(';');
     }
     if (emailOrderDetail.Group_Name__c != null) {
      if (emailOrderDetail.URLString__c != null && emailOrderDetail.URLString__c.length() > 0) {
       urlOfRec = emailOrderDetail.URLString__c;
      } else {
       urlOfRec = 'URL Not Found';
      }
      
      if (emailOrderDetail.InternalCSUrl__c != null && emailOrderDetail.InternalCSUrl__c.length() > 0) {
       InternalCSUrl = emailOrderDetail.InternalCSUrl__c;
      } else {
       InternalCSUrl = 'URL Not Found';
      }
              
      EmailSender emailSend = new EmailSender();
      //emailSend.sendMail(emailOrderDetail.Group_Name__c, additionalEmailIds);
      //emailSend.sendMail(onlineEnqForPDF, emailOrderDetail.Group_Name__c, additionalEmailIds, urlOfRec, qutotationPdfAttachment);
      emailSend.sendQuotationMail(onlineEnqForPDF, emailOrderDetail.Group_Name__c, additionalEmailIds, urlOfRec,InternalCSUrl, qutotationPdfAttachment,emailVersion);
     }
    } else {
        System.debug('Unable to query emailOrderDetail from Email_Order_Detail__c object.');
    }
    ////Send Mail Logic Ends

   } catch (Exception e) {
    System.debug('Exception:' + e.getMessage());
   }
 }

 /*Utility Method - Generates PDF and Sends Mail - START*/
 public static void getEnquiryPdfContent(String onlineEnquiryId) {
    // setting ROW ID
    PageReference pdf = Page.GenerateEnquiryPdf;
    pdf.getParameters().put('id', onlineEnquiryId);
    
    // querying online Enquiry for mail parameter
    Online_Enquiry__c onlineEnqForPDF = [select Market__c,Name, Enquiry_Date__c, Sales_Representative__c, Mainetti_Company__c, Bill_to_Company__c, Bill_to_Address1__c, Bill_to_Address2__c, Bill_to_Contact__c, Bill_to_State__c, Bill_to_Country__c, Bill_to_Email__c, Bill_to_Fax__c, Bill_to_Postcode__c, Bill_to_Tel__c, Ship_to_Address1__c, Ship_to_Address2__c, Ship_to_Company__c, Ship_to_Contact__c, Ship_to_Country__c, Ship_to_Email__c, Ship_to_Fax__c, Ship_to_Postcode__c, Ship_to_State__c, Ship_to_Tel__c, Order_Country__c, Order_Customer_Name__c, OwnerId, Expected_Ship_Date__c, Customer_Comments__c, Retailer_Code__c from Online_Enquiry__c where Id = : onlineEnquiryId];


    // query Attachment
    Integer latestVersionNumber = 1;
    try{
        //Attachment lastVerAttachment = [SELECT Name FROM Attachment where ParentId=:onlineEnquiryId AND Name Like '%_QUOTE_V%' order by Name DESC LIMIT 1];
        Attachment lastVerAttachment = [SELECT Name FROM Attachment where ParentId=:onlineEnquiryId AND Name Like '%_ENQUIRY_V%' order by CreatedDate DESC LIMIT 1];
         
        System.debug('lastVerAttachment:'+lastVerAttachment);
        String attachName = lastVerAttachment.Name;
        
        System.debug('attachName:'+attachName);
        String[] splittedName = attachName.split('\\.');
        
        if(lastVerAttachment!=null){
            if(attachName.contains('_V')){
                // attachment version issue fixed
                //String lastCharOfAttachName = splittedName[0].right(1);
                String lastCharOfAttachName = splittedName[0].split('_V')[1];
                System.debug('lastCharOfAttachName:'+lastCharOfAttachName);
                
                latestVersionNumber = Integer.valueof(lastCharOfAttachName)+1;
                System.debug('latestVersionNumber:'+latestVersionNumber);
            }
        }
    }catch(Exception attachmentQueryEx){
        System.debug('Exception Occured While Generating Enquiring PDF :'+attachmentQueryEx);
    }
    
    // attachment name 
    String emailVersion = onlineEnqForPDF.Name + '_QUOTE_V'+string.valueof(latestVersionNumber);
    
    // the contents of the attachment from the pdf
    Blob body;
    try {
        body = pdf.getContentAsPDF();
    } catch (VisualforceException e) {
        body = Blob.valueOf('Some Text');
    }
    
    // create the new attachment
    Attachment enquiryAttachmentPDF = new Attachment();
    enquiryAttachmentPDF.Body = body;
    //enquiryAttachmentPDF.Name = onlineEnqForPDF.Name + '.pdf';
    enquiryAttachmentPDF.Name = onlineEnqForPDF.Name + '_ENQUIRY_V'+string.valueof(latestVersionNumber)+'.pdf';
    enquiryAttachmentPDF.IsPrivate = false;
    enquiryAttachmentPDF.ParentId = onlineEnquiryId;
    insert enquiryAttachmentPDF;
    

    //Send Mail Logic Starts
    try {
        Email_Order_Detail__c emailOrderDetail = [select Market__c,URLString__c,InternalCSUrl__c, Group_Name__c, Additional_Email_Addresses__c from Email_Order_Detail__c where Order_to_Country__c = : onlineEnqForPDF.Order_Country__c AND Market__c =:onlineEnqForPDF.Market__c LIMIT 1];
        String urlOfRec = '';
        String InternalCSUrl = '';
        
        if (emailOrderDetail != null) {
         String addtionMailIds = emailOrderDetail.Additional_Email_Addresses__c;
         List < String > additionalEmailIds = new List < String > ();
         if (addtionMailIds != null) {
          additionalEmailIds = addtionMailIds.split(';');
         }
         
         if (emailOrderDetail.Group_Name__c != null) {
          if (emailOrderDetail.URLString__c != null && emailOrderDetail.URLString__c.length() > 0) {
           urlOfRec = emailOrderDetail.URLString__c;
          } else {
           urlOfRec = 'URL Not Found';
          }
          
        if (emailOrderDetail.InternalCSUrl__c != null && emailOrderDetail.InternalCSUrl__c.length() > 0) {
            InternalCSUrl = emailOrderDetail.InternalCSUrl__c;
        } else {
            InternalCSUrl = 'URL Not Found';
        }
      
          EmailSender emailSend = new EmailSender();
          //emailSend.sendMail(emailOrderDetail.Group_Name__c, additionalEmailIds);
          emailSend.sendMail(onlineEnqForPDF, emailOrderDetail.Group_Name__c, additionalEmailIds, urlOfRec,InternalCSUrl, enquiryAttachmentPDF);
         }
        } else {
            System.debug('Unable to query emailOrderDetail from Email_Order_Detail__c object.');
        }
    } catch (Exception e) {
    System.debug('Exception:' + e.getMessage());
         System.debug('STTTTTTTTTTTTTTTTT ERROR');
    }
    ////Send Mail Logic Ends
    
  }
  /*Utility Method - Generates PDF and Sends Mail - END */
  
  public static Id getRecordTypeIdByName(String objectType, String recordType){
    
        if(recordTypeIds == null)
        {
            recordTypeIds = new Map<String, Id>();
        }
        
        String sKey = objectType + '|' + recordType;
        if(recordTypeIds.get(sKey) == null)
        {
            Schema.DescribeSobjectResult objDesc = describeSObject(objectType);
            System.assert(objDesc != null, 'Invalid objectType ' + objectType);         
            Map<String, Schema.RecordTypeInfo> rtInfos = objDesc.getRecordTypeInfosByName(); 
            for(String rtName: rtInfos.keySet())
            {
                RecordTypeInfo rt = rtInfos.get(rtName);
                if(rt != null)
                {
                    String sKey2 = objectType + '|' + rtName;
                    recordTypeIds.put(sKey2, rt.getRecordTypeId());                 
                }
            }
        }
        
        return recordTypeIds.get(sKey);
    }
    private static Schema.DescribeSObjectResult describeSObject(String objectType)
    {
        Schema.SObjectType ot = getObjectType(objectType);
        if(ot == null) return null;
        return ot.getDescribe();
    }
    private static Schema.SObjectType getObjectType(String objectType)
    {
        if(gd == null)
            gd = Schema.getGlobalDescribe();
        Schema.SObjectType ot = gd.get(objectType);
        return ot;      
    }
}