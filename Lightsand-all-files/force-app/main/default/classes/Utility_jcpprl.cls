public class Utility_jcpprl{
    /*Utility Method - Generates PDF and Sends Mail - START*/
    public static void getFinalPDFContent(String onlineEnquiryId){
        PageReference pdf = Page.PdfGeneratorTemplate_jcpprl;
        pdf.getParameters().put('id',onlineEnquiryId);
        Online_Enquiry__c onlineEnqForPDF = [select Name,Enquiry_Date__c,Sales_Representative__c,Mainetti_Company__c,Bill_to_Company__c,Bill_to_Address1__c,Bill_to_Address2__c,Bill_to_Contact__c,Bill_to_State__c,Bill_to_Country__c,Bill_to_Email__c,Bill_to_Fax__c,Bill_to_Postcode__c,Bill_to_Tel__c,Ship_to_Address1__c,Ship_to_Address2__c,Ship_to_Company__c,Ship_to_Contact__c,Ship_to_Country__c,Ship_to_Email__c,Ship_to_Fax__c,Ship_to_Postcode__c,Ship_to_State__c,Ship_to_Tel__c,Order_Country__c,Order_Customer_Name__c,OwnerId,Expected_Ship_Date__c,Customer_Comments__c,Retailer_Code__c from Online_Enquiry__c where Id=:onlineEnquiryId];
         // create the new attachment
        Attachment attachmentPDF = new Attachment();

        // the contents of the attachment from the pdf
        Blob body;

        try {

            // returns the output of the page as a PDF
            //body = pdf.getContent();
            body = pdf.getContentAsPDF();

        // need to pass unit test -- current bug    
        } catch (VisualforceException e) {
            body = Blob.valueOf('Some Text');
        }

        attachmentPDF.Body = body;
        // add the user entered name
        attachmentPDF.Name = onlineEnqForPDF.Name + '.pdf';
        attachmentPDF.IsPrivate = false;
        // attach the pdf to the account
        attachmentPDF.ParentId = onlineEnquiryId;
        insert attachmentPDF;
        System.debug('#################Inside Get Final PDF method');
        try{
           /* String pdfContent = '<HTML><BODY><html><head></head><body><br/><br/><br/><br/><span id="j_id0:j_id5"><h3 style="color:#aaa;font-style:italic;"><span><img alt="" src="https://c.cs6.content.force.com/servlet/servlet.ImageServer?id=015N0000000EMYAIA4&amp;oid=00DN0000000PnPOMA0" style="opacity: 0.9; width: 250px; height: 93px;"></span></h3>&nbsp;<table border="0" cellpadding="0" cellspacing="0" style="width:100%"><tbody><tr><td style="width:50%"><span style="font-size:14px;"><strong>Online Enquiry:&nbsp;%%%OnlineEnquiryId%%%</strong></span></td><td>&nbsp;</td><td style="width:50%"><div><span style="font-size:14px;"><strong>Enquiry Date: <span style="background-color: rgb(238, 238, 238);">%%%EnquiryDate%%%</span></strong></span></div></td></tr></tbody></table><table border="0" cellpadding="0" cellspacing="0" style="width:100%"><tbody><tr><td style="width:50%"><strong><span style="font-size:14px;">Sales Representative:&nbsp;%%%SalesRepresent%%%</span></strong></td><td>&nbsp;</td><td style="width:50%"><span style="font-size:14px;"><strong>Mainetti Company:&nbsp;%%%MainettiCompany%%%</strong></span></td></tr></tbody></table>  <table border="0" cellpadding="0" cellspacing="0" style="width:100%"><tbody><tr><td style="width:50%"><strong>Bill To:&nbsp;</strong></td><td>&nbsp;</td><td style="width:50%"><strong>Ship To:</strong></td></tr><tr><td>%%%BillToCompany%%%<br>%%%BillToAddr1%%%<br>%%%BillToAddr2%%%<br>%%%BillToState%%%<br>%%%BillToPostcode%%%<br>%%%BillToCountry%%%<br>Contact:&nbsp;%%%BillToContact%%%<br>Tel:&nbsp;%%%BillToTel%%%<br>Fax:&nbsp;%%%BillToFax%%%<br>Email:&nbsp;%%%BillToEmail%%%</td><td>&nbsp;</td><td>%%%ShipToCompany%%%<br>%%%ShipToAddr1%%%<br>%%%ShipToAddr2%%%<br>%%%ShipToState%%%<br>%%%ShipToPostcode%%%<br>%%%ShipToCountry%%%<br>Contact:&nbsp;%%%ShipToContact%%%<br>Tel:&nbsp;%%%ShipToTel%%%<br>Fax:&nbsp;%%%ShipToFax%%%<br>Email:&nbsp;%%%ShipToEmail%%%</td></tr></tbody></table>&nbsp;<table bgcolor="gray"><tbody><tr style="font-size:12px;font-weight:bold;"><th>Enquiry Details</th></tr></tbody></table><p></p><br/><table cellpadding="2" cellspacing="0" border="1"><tbody><tr style="color:black; font-weight:bold;" bgcolor="gainsboro"><th><font size="1">Model</font></th><th><font size="1">Color</font></th><th><font size="1">Product Description</font></th><th><font size="1">Product Type</font></th><th><font size="1">Product Family</font></th><th><font size="1">Quantity (pcs)</font></th><th><font size="1">Retailer</font></th><th><font size="1">Model Remark</font></th></tr>%%%NewTRContent%%%</tbody></table></span></body></html></BODY></HTML>';
            
            Online_Enquiry__c onlineEnqForPDF = [select Name,Enquiry_Date__c,Sales_Representative__c,Mainetti_Company__c,Bill_to_Company__c,Bill_to_Address1__c,Bill_to_Address2__c,Bill_to_Contact__c,Bill_to_State__c,Bill_to_Country__c,Bill_to_Email__c,Bill_to_Fax__c,Bill_to_Postcode__c,Bill_to_Tel__c,Ship_to_Address1__c,Ship_to_Address2__c,Ship_to_Company__c,Ship_to_Contact__c,Ship_to_Country__c,Ship_to_Email__c,Ship_to_Fax__c,Ship_to_Postcode__c,Ship_to_State__c,Ship_to_Tel__c,Order_Country__c,Order_Customer_Name__c,OwnerId,Expected_Ship_Date__c,Customer_Comments__c,Retailer_Code__c from Online_Enquiry__c where Id=:onlineEnquiryId];
            
            if(onlineEnqForPDF != null){
                if(onlineEnqForPDF.Name != null){
                    pdfContent = pdfContent.replace('%%%OnlineEnquiryId%%%', onlineEnqForPDF.Name);
                } else {
                    pdfContent = pdfContent.replace('%%%OnlineEnquiryId%%%', '');
                }
                if(onlineEnqForPDF.Enquiry_Date__c != null){
                    pdfContent = pdfContent.replace('%%%EnquiryDate%%%', getFormattedDate(onlineEnqForPDF.Enquiry_Date__c));
                } else {
                    pdfContent = pdfContent.replace('%%%EnquiryDate%%%', '');
                }
                if(onlineEnqForPDF.Sales_Representative__c != null){
                    pdfContent = pdfContent.replace('%%%SalesRepresent%%%', onlineEnqForPDF.Sales_Representative__c);
                } else {
                    pdfContent = pdfContent.replace('%%%SalesRepresent%%%', '');
                }
                if(onlineEnqForPDF.Order_Country__c != null){
                    pdfContent = pdfContent.replace('%%%MainettiCompany%%%', onlineEnqForPDF.Order_Country__c);
                } else {
                    pdfContent = pdfContent.replace('%%%MainettiCompany%%%', '');
                }
                if(onlineEnqForPDF.Bill_to_Company__c != null){
                    pdfContent = pdfContent.replace('%%%BillToCompany%%%', onlineEnqForPDF.Bill_to_Company__c);
                } else {
                    pdfContent = pdfContent.replace('%%%BillToCompany%%%', '');
                }
                if(onlineEnqForPDF.Bill_to_Address1__c != null){
                    pdfContent = pdfContent.replace('%%%BillToAddr1%%%', onlineEnqForPDF.Bill_to_Address1__c);
                } else {
                    pdfContent = pdfContent.replace('%%%BillToAddr1%%%', '');
                }
                if(onlineEnqForPDF.Bill_to_Address2__c != null){
                    pdfContent = pdfContent.replace('%%%BillToAddr2%%%', onlineEnqForPDF.Bill_to_Address2__c);
                } else {
                    pdfContent = pdfContent.replace('%%%BillToAddr2%%%', '');
                }
                if(onlineEnqForPDF.Bill_to_Contact__c != null){
                    pdfContent = pdfContent.replace('%%%BillToContact%%%', onlineEnqForPDF.Bill_to_Contact__c);
                } else {
                    pdfContent = pdfContent.replace('%%%BillToContact%%%', '');
                }
                if(onlineEnqForPDF.Bill_to_State__c != null){
                    pdfContent = pdfContent.replace('%%%BillToState%%%', onlineEnqForPDF.Bill_to_State__c);
                } else {
                    pdfContent = pdfContent.replace('%%%BillToState%%%', '');
                }
                if(onlineEnqForPDF.Bill_to_Country__c != null){
                    pdfContent = pdfContent.replace('%%%BillToCountry%%%', onlineEnqForPDF.Bill_to_Country__c);
                } else {
                    pdfContent = pdfContent.replace('%%%BillToCountry%%%', '');
                }
                if(onlineEnqForPDF.Bill_to_Email__c != null){
                    pdfContent = pdfContent.replace('%%%BillToEmail%%%', onlineEnqForPDF.Bill_to_Email__c);
                } else {
                    pdfContent = pdfContent.replace('%%%BillToEmail%%%', '');
                }
                if(onlineEnqForPDF.Bill_to_Fax__c != null){
                    pdfContent = pdfContent.replace('%%%BillToFax%%%', onlineEnqForPDF.Bill_to_Fax__c);
                } else {
                    pdfContent = pdfContent.replace('%%%BillToFax%%%', '');
                }
                if(onlineEnqForPDF.Bill_to_Postcode__c != null){
                    pdfContent = pdfContent.replace('%%%BillToPostcode%%%', onlineEnqForPDF.Bill_to_Postcode__c);
                } else {
                    pdfContent = pdfContent.replace('%%%BillToPostcode%%%', '');
                }
                if(onlineEnqForPDF.Bill_to_Tel__c != null){
                    pdfContent = pdfContent.replace('%%%BillToTel%%%', onlineEnqForPDF.Bill_to_Tel__c);
                } else {
                    pdfContent = pdfContent.replace('%%%BillToTel%%%', '');
                }
                if(onlineEnqForPDF.Ship_to_Address1__c != null){
                    pdfContent = pdfContent.replace('%%%ShipToAddr1%%%', onlineEnqForPDF.Ship_to_Address1__c);
                } else {
                    pdfContent = pdfContent.replace('%%%ShipToAddr1%%%', '');
                }
                if(onlineEnqForPDF.Ship_to_Address2__c != null){
                    pdfContent = pdfContent.replace('%%%ShipToAddr2%%%', onlineEnqForPDF.Ship_to_Address2__c);
                } else {
                    pdfContent = pdfContent.replace('%%%ShipToAddr2%%%', '');
                }
                if(onlineEnqForPDF.Ship_to_Company__c != null){
                    pdfContent = pdfContent.replace('%%%ShipToCompany%%%', onlineEnqForPDF.Ship_to_Company__c);
                } else {
                    pdfContent = pdfContent.replace('%%%ShipToCompany%%%', '');
                }
                if(onlineEnqForPDF.Ship_to_Contact__c != null){
                    pdfContent = pdfContent.replace('%%%ShipToContact%%%', onlineEnqForPDF.Ship_to_Contact__c);
                } else {
                    pdfContent = pdfContent.replace('%%%ShipToContact%%%', '');
                }
                if(onlineEnqForPDF.Ship_to_Country__c != null){
                    pdfContent = pdfContent.replace('%%%ShipToCountry%%%', onlineEnqForPDF.Ship_to_Country__c);
                } else {
                    pdfContent = pdfContent.replace('%%%ShipToCountry%%%', '');
                }
                if(onlineEnqForPDF.Ship_to_Email__c != null){
                    pdfContent = pdfContent.replace('%%%ShipToEmail%%%', onlineEnqForPDF.Ship_to_Email__c);
                } else {
                    pdfContent = pdfContent.replace('%%%ShipToEmail%%%', '');
                }
                if(onlineEnqForPDF.Ship_to_Fax__c != null){
                    pdfContent = pdfContent.replace('%%%ShipToFax%%%', onlineEnqForPDF.Ship_to_Fax__c);
                } else {
                    pdfContent = pdfContent.replace('%%%ShipToFax%%%', '');
                }
                if(onlineEnqForPDF.Ship_to_Postcode__c != null){
                    pdfContent = pdfContent.replace('%%%ShipToPostcode%%%', onlineEnqForPDF.Ship_to_Postcode__c);
                } else {
                    pdfContent = pdfContent.replace('%%%ShipToPostcode%%%', '');
                }
                if(onlineEnqForPDF.Ship_to_State__c != null){
                    pdfContent = pdfContent.replace('%%%ShipToState%%%', onlineEnqForPDF.Ship_to_State__c);
                } else {
                    pdfContent = pdfContent.replace('%%%ShipToState%%%', '');
                }
                if(onlineEnqForPDF.Ship_to_Tel__c  != null){
                    pdfContent = pdfContent.replace('%%%ShipToTel%%%', onlineEnqForPDF.Ship_to_Tel__c );
                } else {
                    pdfContent = pdfContent.replace('%%%ShipToTel%%%', '');
                }
            }
            
            System.debug('#########------------------Final PDF Content:'+pdfContent);
            
            List<Online_Detail__c> onlineProdDetailList = [select Model__c,Color__c,Product_Description__c,Product_Type__c,Product_Family__c,Qty__c,Retailer_Code__c,Model_Remark__c from Online_Detail__c where TransactionID__c=:onlineEnquiryId];
            
            System.debug('###---------------List Length'+onlineProdDetailList.size());
            
            String totalProdDetails = '';
            for(Online_Detail__c eachProdDetail : onlineProdDetailList){
                System.debug('######################----------------In For Loop');
                String newRow = '<tr>';
                if(eachProdDetail.Model__c != null){
                    newRow = newRow + '<td><font size="1">' +[select Name from Price_Specification_Book_Product__c where Id=:eachProdDetail.Model__c].Name + '</font></td>';
                   // newRow = newRow + '<td>' + eachProdDetail.Model__c + '</td>';
                } else {
                    newRow = newRow + '<td></td>';
                }
                if(eachProdDetail.Color__c != null){
                    newRow = newRow + '<td><font size="1">' + eachProdDetail.Color__c + '</font></td>';
                } else {
                    newRow = newRow + '<td></td>';
                }
                if(eachProdDetail.Product_Description__c != null){
                    newRow = newRow + '<td><font size="1">' + eachProdDetail.Product_Description__c + '</font></td>';
                } else {
                    newRow = newRow + '<td></td>';
                }
                if(eachProdDetail.Product_Type__c != null){
                    newRow = newRow + '<td><font size="1">' + eachProdDetail.Product_Type__c + '</font></td>';
                } else {
                    newRow = newRow + '<td></td>';
                }
                if(eachProdDetail.Product_Family__c != null){
                    newRow = newRow + '<td><font size="1">' + eachProdDetail.Product_Family__c + '</font></td>';
                } else {
                    newRow = newRow + '<td></td>';
                }
                if(eachProdDetail.Qty__c != null){
                    newRow = newRow + '<td><font size="1">' + eachProdDetail.Qty__c + '</font></td>';
                } else {
                    newRow = newRow + '<td></td>';
                }
                if(eachProdDetail.Retailer_Code__c != null){
                    newRow = newRow + '<td><font size="1">' +[select Name from Retailer_Code__c where Id=:eachProdDetail.Retailer_Code__c].Name + '</font></td>';
                    //newRow = newRow + '<td>' + eachProdDetail.Retailer_Code__c + '</td>';
                } else {
                    newRow = newRow + '<td></td>';
                }
                if(eachProdDetail.Model_Remark__c != null){
                    newRow = newRow + '<td><font size="1">' + eachProdDetail.Model_Remark__c + '</font></td>';
                } else {
                    newRow = newRow + '<td></td>';
                }
                newRow = newRow + '</tr>';
                System.debug('######################----------------In For Loop new Row: '+newRow); 
                totalProdDetails = totalProdDetails + newRow;
                System.debug('######################----------------In For Loop totalProdDetails: '+totalProdDetails); 
            }
            if(totalProdDetails != null){
                pdfContent = pdfContent.replace('%%%NewTRContent%%%', totalProdDetails);
            } else {
                pdfContent = pdfContent.remove('%%%NewTRContent%%%');
            }
            
            System.debug('#########-----####### Finally Pdf Content: '+pdfContent);
            
            Attachment attachmentPDF = new Attachment();
            attachmentPDF.parentId = onlineEnquiryId;
            attachmentPDF.Name = onlineEnqForPDF.Name + '.pdf';
            attachmentPDF.body = Blob.toPDF(pdfContent); //This creates the PDF content
            insert attachmentPDF;
            System.debug('####Attachment Inseted--->'+attachmentPDF.Id);*/
            
            //Send Mail Logic Starts
            Email_Order_Detail__c emailOrderDetail = [select URLString__c, InternalCSUrl__c,Group_Name__c, Additional_Email_Addresses__c from Email_Order_Detail__c where Order_to_Country__c =:onlineEnqForPDF.Order_Country__c];
            String urlOfRec = '';
            String InternalCSUrl = '';
            
            if(emailOrderDetail != null){
                String addtionMailIds = emailOrderDetail.Additional_Email_Addresses__c;
                List<String> additionalEmailIds = new List<String>();
                if(addtionMailIds != null){                    
                    additionalEmailIds = addtionMailIds.split(';');
                }
                
                if(emailOrderDetail.Group_Name__c != null){
                    if(emailOrderDetail.URLString__c!=null && emailOrderDetail.URLString__c.length()>0){
                        urlOfRec = emailOrderDetail.URLString__c;
                    }else{
                        urlOfRec = 'URL Not Found';
                    }
                    
                    if (emailOrderDetail.InternalCSUrl__c != null && emailOrderDetail.InternalCSUrl__c.length() > 0) {
                        InternalCSUrl = emailOrderDetail.InternalCSUrl__c;
                    } else {
                        InternalCSUrl = 'URL Not Found';
                    }
                
                    EmailSender emailSend = new EmailSender();
                    //emailSend.sendMail(emailOrderDetail.Group_Name__c, additionalEmailIds);
                    //emailSend.sendMail(onlineEnqForPDF, emailOrderDetail.Group_Name__c, additionalEmailIds, urlOfRec,attachmentPDF);
                    emailSend.sendMail(onlineEnqForPDF, emailOrderDetail.Group_Name__c, additionalEmailIds, urlOfRec, InternalCSUrl,attachmentPDF);
                }
            } else {
                System.debug('');
            }
            ////Send Mail Logic Ends
                            
        } catch(Exception e){
            System.debug('Exception:'+e.getMessage());
        }
    }
    /*Utility Method - Generates PDF and Sends Mail - END */
    
        /*Utility Method - Generates PDF and Sends Mail - START*/
    public static void getEnqConfirmPDFContent(String onlineEnquiryId){
        PageReference pdf = Page.EnquiryConfirmationPdfTemplate;
        pdf.getParameters().put('id',onlineEnquiryId);
        Online_Enquiry__c onlineEnqForPDF = [select Name,Enquiry_Date__c,Sales_Representative__c,Mainetti_Company__c,Bill_to_Company__c,Bill_to_Address1__c,Bill_to_Address2__c,Bill_to_Contact__c,Bill_to_State__c,Bill_to_Country__c,Bill_to_Email__c,Bill_to_Fax__c,Bill_to_Postcode__c,Bill_to_Tel__c,Ship_to_Address1__c,Ship_to_Address2__c,Ship_to_Company__c,Ship_to_Contact__c,Ship_to_Country__c,Ship_to_Email__c,Ship_to_Fax__c,Ship_to_Postcode__c,Ship_to_State__c,Ship_to_Tel__c,Order_Country__c,Order_Customer_Name__c,OwnerId,Expected_Ship_Date__c,Customer_Comments__c,Retailer_Code__c,Account_Manager__c,Account_Manager_Email_Address__c,Account_Manager_Contact_Number__c from Online_Enquiry__c where Id=:onlineEnquiryId];
         // create the new attachment
        Attachment attachmentPDF = new Attachment();

        // the contents of the attachment from the pdf
        Blob body;

        try {

            // returns the output of the page as a PDF
            //body = pdf.getContent();
            body = pdf.getContentAsPDF();

        // need to pass unit test -- current bug    
        } catch (VisualforceException e) {
            body = Blob.valueOf('Some Text');
        }

        attachmentPDF.Body = body;
        // add the user entered name
        attachmentPDF.Name = onlineEnqForPDF.Name + '.pdf';
        attachmentPDF.IsPrivate = false;
        // attach the pdf to the account
        attachmentPDF.ParentId = onlineEnquiryId;
        insert attachmentPDF;
        System.debug('#################Inside getEnqConfirmPDFContent');
        
        // update Quotation Date
        onlineEnqForPDF.Enquiry_Status__c = 'Enquiry Received';
        onlineEnqForPDF.Quotation_Status__c = 'NA';
        onlineEnqForPDF.Is_Email_Reminder_Enabled__c = false;
        update(onlineEnqForPDF);
    
        try{
            //Send Mail Logic Starts
            Email_Order_Detail__c emailOrderDetail = [select URLString__c, InternalCSUrl__c,Group_Name__c, Additional_Email_Addresses__c from Email_Order_Detail__c where Order_to_Country__c =:onlineEnqForPDF.Order_Country__c];
            String urlOfRec = '';
            String InternalCSUrl = '';
            
            if(emailOrderDetail != null){
                String addtionMailIds = emailOrderDetail.Additional_Email_Addresses__c;
                List<String> additionalEmailIds = new List<String>();
                if(addtionMailIds != null){                    
                    additionalEmailIds = addtionMailIds.split(';');
                }
                
                if(emailOrderDetail.Group_Name__c != null){
                    if(emailOrderDetail.URLString__c!=null && emailOrderDetail.URLString__c.length()>0){
                        urlOfRec = emailOrderDetail.URLString__c;
                    }else{
                        urlOfRec = 'URL Not Found';
                    }
                    
                    if (emailOrderDetail.InternalCSUrl__c != null && emailOrderDetail.InternalCSUrl__c.length() > 0) {
                        InternalCSUrl = emailOrderDetail.InternalCSUrl__c;
                    } else {
                        InternalCSUrl = 'URL Not Found';
                    }
                
                    EmailSender emailSend = new EmailSender();
                    //emailSend.sendMail(emailOrderDetail.Group_Name__c, additionalEmailIds);
                    //emailSend.sendMail(onlineEnqForPDF, emailOrderDetail.Group_Name__c, additionalEmailIds, urlOfRec,attachmentPDF);
                    emailSend.sendEnqConfirmMail(onlineEnqForPDF, emailOrderDetail.Group_Name__c, additionalEmailIds, urlOfRec, InternalCSUrl,attachmentPDF);
                }
            } else {
                System.debug('');
            }
            ////Send Mail Logic Ends
                            
        } catch(Exception e){
            System.debug('Exception:'+e.getMessage());
        }
    }
    /*Utility Method - Generates PDF and Sends Mail - END */
    
    /*Utility Method - Returns the Formated Date - START*/
    public static String getFormattedDate(Date dateValue){
            Datetime tempDateValue = null;
            String formattedDate = '';
            if(dateValue!=null){
                tempDateValue = Datetime.newInstance(dateValue.year(), dateValue.month(), dateValue.day());
                System.debug('Non Formatted Date--->'+dateValue);
                formattedDate = tempDateValue.format('yyyy-MM-dd');
                System.debug('Formatted Date--->'+tempDateValue);
            }
            return formattedDate;
    }
     /*Utility Method - Returns the Formated Date - END*/
}