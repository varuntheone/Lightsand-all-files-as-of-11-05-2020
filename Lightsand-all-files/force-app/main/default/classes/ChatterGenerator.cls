public with sharing class ChatterGenerator {

	public static final String FI_TYPE_TEXT_POST = 'TextPost';
	public static final String FI_TYPE_LINK_POST = 'LinkPost';
	public static final String FI_TYPE_CONTENT_POST = 'ContentPost';

	public CollaborationGroup generateChatterGroup(String name, Boolean isPublic) {
		return new CollaborationGroup(
			Name = name
			, CollaborationType = isPublic ? 'Public' : 'Private'
		);
	}
	
	public FeedItem generatePost(ID parentId, String content) {
		return new FeedItem(
			Type = FI_TYPE_TEXT_POST
			, ParentId = parentId
			, Body = content
		);
	}
	
	public FeedItem generateLinkPost(ID parentId, String link, String name, String content) {
		return new FeedItem(
			Type = FI_TYPE_LINK_POST
			, ParentId = parentId
			, Body = content
			, LinkUrl = link
			, Title = name
		);
	}
	
	public FeedItem generateContentPost(ID parentId, String fileName, Blob fileBinary, String content) {
		return new FeedItem(
			Type = FI_TYPE_CONTENT_POST
			, ParentId = parentId
			, ContentFileName = fileName
			, ContentData = fileBinary
			, Body = content
		);
	}
	
	public FeedItem generateContentPost(ID parentId) {
		return generateContentPost(parentId, 'Test PDF File.pdf', Blob.toPdf('Test PDF'), 'It is test file');
	}
}