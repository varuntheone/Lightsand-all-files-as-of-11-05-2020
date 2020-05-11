@IsTest(SeeAllData=false)
public class PDFFilePreviewControllerTest {

    
    @IsTest public static void pdfFilePreview(){
        
        ContentVersion contentVersion_1 = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion_1;
        
       
        PageReference pageRef = Page.PDFFilePreviewVF;
        pageRef.getParameters().put('id',[SELECT ID FROM ContentVersion LIMIT 1][0].Id);//'068p0000000zlVwAAI');
        Test.setCurrentPage(pageRef);
        PDFFilePreviewController controller = new PDFFilePreviewController();
        ContentVersion contentVersionObj =controller.contVersionObj;
         String pdfData =controller.pdfData;
       
        
    }
    
}