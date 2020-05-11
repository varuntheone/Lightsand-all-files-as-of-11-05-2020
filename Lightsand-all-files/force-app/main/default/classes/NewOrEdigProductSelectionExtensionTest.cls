@IsTest public class NewOrEdigProductSelectionExtensionTest{
    
    @IsTest(SeeAllData=true) public static void testNewOrEdigProductSelectionExtensionTest() {
        Online_Detail__c detail = new Online_Detail__c();
        ApexPages.StandardController stdController = new ApexPages.StandardController(detail);
        system.currentPageReference().getParameters().put('id', 'a0g9000000CzqAQ');
        NewOrEdigProductSelectionExtension extension1 = new NewOrEdigProductSelectionExtension(stdController);
         system.currentPageReference().getParameters().put('id', null);
         system.currentPageReference().getParameters().put('CF00N90000009J0Lk_lkid', 'a0f900000050AvE');
        NewOrEdigProductSelectionExtension extension = new NewOrEdigProductSelectionExtension(stdController);
        extension.addMore();
        extension.Cancel();
        extension.Del();
        extension.init();
        extension.Save();
        extension.Add();
        extension.Submit();
    }

}