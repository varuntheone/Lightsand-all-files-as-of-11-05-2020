public with sharing class AttachmentGenerator {
	
	public Attachment generateAttachment(ID parentId, String fileName, Blob bodyBlob) {
		return new Attachment(
			ParentId = parentId
			, Name = fileName
			, Body = bodyBlob
		);
	}
	
	public Attachment generatePDFAttachment(ID parentId, String fileName, String pdfContent) {
		return generateAttachment(parentId, fileName, Blob.toPdf(pdfContent));
	}
}