public class UtilityProductConfigurator {
 /*Utility Method - Generates PDF and Sends Mail - START*/
 private static transient Map<String, Id> recordTypeIds;
 private static transient Map<String, Schema.SObjectType> gd;
 
 public static void getFinalPDFContent(String ProdConId) {
 
    // querying online enquiry for mail parameter
    Product_Configurator__c ProdConForPDF= [select Name,RecordTypeId from Product_Configurator__c where Id = : ProdConId];

    //  setting Online Enquiry Row Id
    System.debug('getFinalPDFContent - START');
    //PagePDF Code
    PageReference pdf = Page.PdfGeneratorWHN;    
    
    
    try{
    if(ProdConForPDF.RecordTypeId == getRecordTypeIdByName('Product_Configurator__c','Garment Bag'))
    //if(ProdConForPDF.RecordTypeId == '012p00000005CpKAAU')
    {
    pdf = Page.PdfGeneratorProdConGarmentBag;    
    pdf.getParameters().put('id', ProdConId);
    }
    //if(ProdConForPDF.RecordTypeId == '012p00000005CpPAAU')
    else if(ProdConForPDF.RecordTypeId == getRecordTypeIdByName('Product_Configurator__c','Packaging Box'))
    {
    pdf = Page.PdfGeneratorProdConPackingBox;    
    pdf.getParameters().put('id', ProdConId);
    }
    else if(ProdConForPDF.RecordTypeId == getRecordTypeIdByName('Product_Configurator__c','Paper Bag'))
    {
    pdf = Page.PdfGeneratorProdConPaperBag;    
    pdf.getParameters().put('id', ProdConId);
    }
    else if(ProdConForPDF.RecordTypeId == getRecordTypeIdByName('Product_Configurator__c','Polybag'))
    {
    pdf = Page.PdfGeneratorProdConPackingBox;    
    pdf.getParameters().put('id', ProdConId);
    }
    else if(ProdConForPDF.RecordTypeId == getRecordTypeIdByName('Product_Configurator__c','Trims-Paper'))
    {
    pdf = Page.PdfGeneratorTrimsPaper;    
    pdf.getParameters().put('id', ProdConId);
    }
    else if(ProdConForPDF.RecordTypeId == getRecordTypeIdByName('Product_Configurator__c','Trims-PFL'))
    {
    pdf = Page.PdfGeneratorProdConPackingBox;    
    pdf.getParameters().put('id', ProdConId);
    }
    else if(ProdConForPDF.RecordTypeId == getRecordTypeIdByName('Product_Configurator__c','Trims-Woven'))
    {
    pdf = Page.PdfGeneratorProdConPackingBox;    
    pdf.getParameters().put('id', ProdConId);
    }
    
    else
    {
    pdf = Page.PdfGeneratorProdConTest;    
    pdf.getParameters().put('id', ProdConId);
    }
   
    }catch(Exception attachmentQueryEx){
        System.debug('Exception Occured While Generating Quote:'+attachmentQueryEx);
    }


    // query Attachment
    Integer latestVersionNumber = 1;
    try{
        //Attachment lastVerAttachment = [SELECT Name FROM Attachment where ParentId=:onlineEnquiryId AND Name Like '%_QUOTE_V%' order by Name DESC LIMIT 1];
        Attachment lastVerAttachment = [SELECT Name FROM Attachment where ParentId=:ProdConId AND Name Like '%_V%' order by CreatedDate DESC LIMIT 1];
         
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
    attachmentPDF.Name = ProdConForPDF.Name + '_V'+string.valueof(latestVersionNumber)+'.pdf';
    //attachmentPDF.Name = ProdConForPDF.Name + '_V'+string.valueof(latestVersionNumber)+'.xls';
    attachmentPDF.IsPrivate = false;
    attachmentPDF.ParentId = ProdConId;
    insert attachmentPDF;
    System.debug('getFinalPDFContent - END');

    // update Quotation Date
    //ProdConForPDF.PO_Generation_Date__c = Date.today();
    //ProdConForPDF.Quotation_Status__c = 'PO Received';
    //ProdConForPDF.Enquiry_Status__c = 'PO Received';
    //ProdConForPDF.RecordTypeId = getRecordTypeIdByName('Online_Enquiry__c','Order -Locked');
    
    //ProdConForPDF.Is_Email_Reminder_Enabled__c = false;
    update(ProdConForPDF);
    
    //Send Mail Logic Starts
    
    try {
        Email_Order_Detail__c emailOrderDetail = [select URLString__c,InternalCSUrl__c, Group_Name__c, Additional_Email_Addresses__c from Email_Order_Detail__c where Order_to_Country__c = : ProdConForPDF.NAME];
        String urlOfRec = '';
        String InternalCSUrl = '';
        if (emailOrderDetail != null) {
             String addtionMailIds = emailOrderDetail.Additional_Email_Addresses__c;
             //String addtionMailIds = 'portal.admin@mainetti.com;'+ ProdConForPDF.Factory_email__c ;
             
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
              
              EmailSenderAttachment emailSend = new EmailSenderAttachment();
              //emailSend.sendMail(emailOrderDetail.Group_Name__c, additionalEmailIds);
              //emailSend.sendMail(onlineEnqForPDF, emailOrderDetail.Group_Name__c, additionalEmailIds, urlOfRec, attachmentPDF);
              //Tony
              
             // emailSend.sendFinalPOMail(ProdConForPDF, emailOrderDetail.Group_Name__c, additionalEmailIds, urlOfRec, InternalCSUrl, attachmentPDF);
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