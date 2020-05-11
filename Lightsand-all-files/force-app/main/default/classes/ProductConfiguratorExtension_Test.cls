@IsTest(SeeAllData = true)
public class ProductConfiguratorExtension_Test {
    
      @IsTest(SeeAllData=true) public static void testNewRecordCreation() {
          
          Product_Configurator__c prodConf = new Product_Configurator__c();
          prodConf.Outer_Dimension_cm__c='2';
          prodConf.Height_cm__c=2.0;
          insert prodConf;
          
          Id ProdConfId = prodConf.Id;          
          ID RecordTypeId = [Select Id,RecordTypeId from Product_Configurator__c Where Id = :ProdConfId].RecordTypeId;
          
          Test.startTest();          
              PageReference pageRef = Page.ProductConfiguratorPage;
              Test.setCurrentPage(pageRef);           
              
              
              ApexPages.currentPage().getParameters().put('id', ProdConfId);
              ApexPages.currentPage().getParameters().put('RecordType', RecordTypeId);              
              ApexPages.StandardController stdController =   new ApexPages.StandardController(prodConf);              
              ProductConfiguratorExtension prodConExt = new ProductConfiguratorExtension(stdController);
              
              prodConExt.initialize();
              prodConExt.continuePage();
              prodConExt.save();         
          
          Test.stopTest();
    }
    
    @IsTest(SeeAllData=true) public static void testEditRecord() {
          
          Product_Configurator__c prodConf = new Product_Configurator__c();
          prodConf.Outer_Dimension_cm__c='2';
          prodConf.Height_cm__c=2.0;
          insert prodConf;
          
          Id ProdConfId = prodConf.Id;          
          
          Test.startTest();          
              PageReference pageRef = Page.ProductConfiguratorPage;
              Test.setCurrentPage(pageRef);           
              
              
              ApexPages.currentPage().getParameters().put('id', ProdConfId);             
              ApexPages.StandardController stdController =   new ApexPages.StandardController(prodConf);              
              ProductConfiguratorExtension prodConExt = new ProductConfiguratorExtension(stdController);
              
              prodConExt.initialize();
              prodConExt.continuePage();
              prodConExt.save();         
          
          Test.stopTest();
    }
}