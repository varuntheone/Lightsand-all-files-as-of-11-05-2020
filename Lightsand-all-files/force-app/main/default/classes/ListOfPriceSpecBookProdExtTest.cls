@IsTest public class ListOfPriceSpecBookProdExtTest{
    
    @IsTest(SeeAllData=true) public static void testListOfPriceSpecBookProdTest() {
        Price_Specification_Book_Product__c product = new Price_Specification_Book_Product__c();
        ApexPages.StandardController stdController = new ApexPages.StandardController(product);
        ListOfPriceSpecBookProdExt listOfPriceSpecBookProdeExt = new ListOfPriceSpecBookProdExt(stdController);
        listOfPriceSpecBookProdeExt.retailerCode = 'a0090000003DMBR';
        listOfPriceSpecBookProdeExt.country = 'India';
        listOfPriceSpecBookProdeExt = new ListOfPriceSpecBookProdExt(stdController);
    }

}