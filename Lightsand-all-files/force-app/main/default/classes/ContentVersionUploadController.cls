public with sharing class ContentVersionUploadController {
 public String selectedSubSectionName {
  get;
  set;
 }

 public Boolean isPrimary {
  get;
  set;
 }

 public String opiId {
  get;
  set;
 }

 public ContentVersion contentVersion {
  get {
   if (contentVersion == null)
    contentVersion = new ContentVersion();
   return contentVersion;
  }
  set;
 }

 public ContentVersionUploadController(ApexPages.StandardController stdController) {
  opiId = apexpages.currentpage().getparameters().get('id');
 }

 public PageReference upload() {
  try {

   // lazy load checking
   if (!isPrimary) {
    List < ContentDocumentLink > ContentDocumentLinkList = [Select Id, contentDocumentId from ContentDocumentLink where LinkedEntityId = : opiId];
    if (ContentDocumentLinkList == null || ContentDocumentLinkList.isEmpty()) {
     isPrimary = true;
    }else{
         List<String> contentDocumentIdList = new   List<String> ();
        for(ContentDocumentLink eachContentDocumentLink : ContentDocumentLinkList){
            contentDocumentIdList.add(eachContentDocumentLink.contentDocumentId);
        }
         List<ContentVersion> contentversionList = [Select Id,ContentDocumentId,contentbodyId  from ContentVersion where ContentDocumentId IN :contentDocumentIdList AND description='Opportunity Item'];
         if(contentversionList==null || contentversionList.isEmpty()){
            isPrimary = true;
         }
    }
   }

   ContentVersion conVer = new ContentVersion();
   conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
   conVer.PathOnClient = contentVersion.Title; // The files name, extension is very important here which will help the file in preview.
   conVer.Title = contentVersion.Title; // Display name of the files
   conVer.VersionData = contentVersion.VersionData; // converting your binary string to Blog
   conVer.Description = selectedSubSectionName;
   insert conVer;

   // First get the content document Id from ContentVersion
   Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = : conVer.Id].ContentDocumentId;

   //Create ContentDocumentLink
   ContentDocumentLink cDe = new ContentDocumentLink();
   cDe.ContentDocumentId = conDoc;
   cDe.LinkedEntityId = apexpages.currentpage().getparameters().get('id');
   //cDe.LinkedEntityId = 'a0vp0000002bjMY'; // you can use objectId,GroupId etc
   cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
   cDe.Visibility = 'InternalUsers';
   insert cDe;

   if (isPrimary && selectedSubSectionName.equalsIgnoreCase('Opportunity Item')) {
    Opportunity_Item_Master__c updateOPIWithPrimaryImageId = new Opportunity_Item_Master__c();
    updateOPIWithPrimaryImageId.Id = cDe.LinkedEntityId;
    updateOPIWithPrimaryImageId.Line_Item_Image_Id__c = conVer.Id;
    update updateOPIWithPrimaryImageId;
   }
  } catch (DMLException e) {
   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error uploading attachment' + e.getMessage()));
   return null;
  } finally {
   contentVersion = new ContentVersion();
  }

  ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Attachment uploaded successfully'));
  return null;
 }

 public List < SelectOption > getSubsectionList() {
  List < SelectOption > countryOptions = new List < SelectOption > ();
  for (File_Upload__mdt eachFileUploadRow: [Select Section_name__c, Default__c from File_Upload__mdt order by Section_name__c]) {
   countryOptions.add(new SelectOption(eachFileUploadRow.Section_name__c, eachFileUploadRow.Section_name__c));
   if (eachFileUploadRow.Default__c) {
    selectedSubSectionName = eachFileUploadRow.Section_name__c;
   }
  }
  return countryOptions;
 }
}