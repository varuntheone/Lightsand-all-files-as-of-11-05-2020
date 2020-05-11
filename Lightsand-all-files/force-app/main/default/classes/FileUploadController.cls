public with sharing class FileUploadController {
 @AuraEnabled
 public static Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) {
  // check if fileId id ''(Always blank in first chunk), then call the saveTheFile method,
  //  which is save the check data and return the attachemnt Id after insert, 
  //  next time (in else) we are call the appentTOFile() method
  //   for update the attachment with reamins chunks   
  if (fileId == '') {
   fileId = saveTheFile(parentId, fileName, base64Data, contentType);
  } else {
   appendToFile(fileId, base64Data);
  }

  return Id.valueOf(fileId);
 }


 public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) {
  base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
  ContentVersion conVer = new ContentVersion();
  conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
  conVer.PathOnClient = fileName; // The files name, extension is very important here which will help the file in preview.
  conVer.Title = fileName; // Display name of the files
  conVer.VersionData = EncodingUtil.base64Decode(base64Data); // converting your binary string to Blog
  insert conVer;

  // First get the content document Id from ContentVersion
  Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = : conVer.Id].ContentDocumentId;

  //Create ContentDocumentLink
  ContentDocumentLink cDe = new ContentDocumentLink();
  cDe.ContentDocumentId = conDoc;
  cDe.LinkedEntityId = parentId; // you can use objectId,GroupId etc
  cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
  cDe.Visibility = 'InternalUsers';
  insert cDe;

  return cDe.Id;
 }

 /*
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
 
        Attachment oAttachment = new Attachment();
        oAttachment.parentId = parentId;
 
        oAttachment.Body = EncodingUtil.base64Decode(base64Data);
        oAttachment.Name = fileName;
        oAttachment.ContentType = contentType;
 
        insert oAttachment;
 
        return oAttachment.Id;
    }*/

 private static void appendToFile(Id fileId, String base64Data) {
  base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');

  Attachment a = [
   SELECT Id, Body
   FROM Attachment
   WHERE Id = : fileId
  ];

  String existingBody = EncodingUtil.base64Encode(a.Body);

  a.Body = EncodingUtil.base64Decode(existingBody + base64Data);

  update a;
 }
}