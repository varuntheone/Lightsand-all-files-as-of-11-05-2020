@isTest
private class CreatePOFromCaseCSVAttachBatchTest
{
    static testmethod void testBatch() 
    {
        
        Case newCase = new Case();
        newCase.Subject ='Test Emai Case [##]Macy';
        newCase.Origin ='PO Email';
        newCase.Batch_Status__c='Not Started';
        insert newCase;
        
        EmailMessage emailMessage = new EmailMessage();
        emailMessage.Subject='Test';
        emailMessage.ParentId=newCase.Id;        
        insert emailMessage;
        
        List<ID> caseIdList = new List<ID>();
        caseIdList.add(newCase.ID);
        
        Attachment newAttachment = new Attachment();
        newAttachment.Name='TestCSV';
        newAttachment.ParentId=emailMessage.Id;
        newAttachment.Body=Blob.valueOf('04,4500259652,20180109,1440,FA17,TWINCITY LEATHER FASHION (GUANGZHOU,"NO.1 DONG HUA DA LU DONG XIN JIAO,","TU HUA, HAI ZHU QU",GUANGZHOU,190,000000,CN,MEGALINK INTERNATIONAL HOLDING LTD,13 & 14/F LLADRO CENTRE,72-80 HOI YUEN ROAD,KWUN TONG,ZZ,0,HK,Port Logistics - Building 17,5026 Chino Hills Parkway,,CHINO,CA,917105643,US,10,6,EA,1,BLACK,612000653553.00,L,L,148,ANDREI KNIT PANT FX LEATHR,46DTP2G134-001,GBGUSA,BCBG MAX AZRIA,20180210\n');
        insert newAttachment;
        
        String query ='Select Id, Name, Body, BodyLength,ParentId from Attachment where ParentId IN (SELECT Id from EmailMessage where ParentId IN :caseIdList)';
        CreatePOFromCaseCSVAttachBatch  processCaseCSVBatch = new CreatePOFromCaseCSVAttachBatch(query,caseIdList); 
        Database.executeBatch(processCaseCSVBatch);
    }
    
    static testmethod void testBatch1() 
    {
        
        Case newCase = new Case();
        newCase.Subject ='850_SETLOG001_100349028_20180530224906_MAINETTI_100347974 CSV REPORT FOR MAINETTI';
        newCase.Origin ='PO Email';
        newCase.Batch_Status__c='Not Started';
        insert newCase;
        
        EmailMessage emailMessage = new EmailMessage();
        emailMessage.Subject='Test';
        emailMessage.ParentId=newCase.Id;        
        insert emailMessage;
        
        List<ID> caseIdList = new List<ID>();
        caseIdList.add(newCase.ID);
        
        Attachment newAttachment = new Attachment();
        newAttachment.Name='TestCSV';
        newAttachment.ParentId=emailMessage.Id;
        newAttachment.Body=Blob.valueOf('04\t4500259652\t20180109\t1440\tFA17\tTWINCITY LEATHER FASHION (GUANGZHOU\t"asdsadasd"\t"Tasdas"\tGUANGZHOU\t190\t000000\tCN\tMEGALINK INTERNATIONAL HOLDING LTD\t13 & 14/F LLADRO CENTRE\t72-80 HOI YUEN ROAD\tKWUN TONG\tZZ\t0\tHK\tPort Logistics - Building 17\t5026 Chino Hills Parkway\t\tCHINO\tCA\t917105643\tUS\t10\t6\tEA\t1\tBLACK\t612000653553.00\tL\tL\t148\tANDREI KNIT PANT FX LEATHR\t46DTP2G134-001\tGBGUSA\tBCBG MAX AZRIA\t20180210\n');
        insert newAttachment;
        
        String query ='Select Id, Name, Body, BodyLength,ParentId from Attachment where ParentId IN (SELECT Id from EmailMessage where ParentId IN :caseIdList)';
        CreatePOFromCaseCSVAttachBatch  processCaseCSVBatch = new CreatePOFromCaseCSVAttachBatch(query,caseIdList); 
        Database.executeBatch(processCaseCSVBatch);
    }
}