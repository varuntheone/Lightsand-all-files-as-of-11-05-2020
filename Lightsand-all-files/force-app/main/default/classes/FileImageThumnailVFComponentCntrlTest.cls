@IsTest(SeeAllData=false)
public class FileImageThumnailVFComponentCntrlTest {
    
    
    @IsTest public static void getFiles(){
        
        Opportunity__c newOpp = new Opportunity__c();
        newOpp.Customer_Type__c='Existing Business';
        newOpp.Lead_Source__c='Existing Customer';
        newOpp.Opportunity_Name__c='Test Opp';
        insert newOpp;
        
        
        Opportunity_Item_Master__c oppItem = new Opportunity_Item_Master__c();
        oppItem.Opportunity_ID__c=newOpp.Id;        
        oppItem.Potential_Volume__c=1;
        oppItem.Product_Category__c='HANGERS';        
        oppItem.Stage__c='Pending';
        oppItem.Product_SubCategory__c='PLASTIC HANGERS';
        oppItem.Potential_Unit_Price__c=1;
        insert oppItem;
        
        ContentVersion conVer = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert conVer;
        
        // First get the content document Id from ContentVersion
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = : conVer.Id].ContentDocumentId;
        
        //Create ContentDocumentLink
        ContentDocumentLink cDe = new ContentDocumentLink();
        cDe.ContentDocumentId = conDoc;
        cDe.LinkedEntityId = oppItem.Id;
        cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
        cDe.Visibility = 'InternalUsers';
        insert cDe;
        
        FileImageThumnailVFComponentContoroller cntrl = new FileImageThumnailVFComponentContoroller();
        cntrl.opportunityItemId=oppItem.Id;
        PageReference pdgRef =  cntrl.getFiles();
        
        
        
        
        
    }

}