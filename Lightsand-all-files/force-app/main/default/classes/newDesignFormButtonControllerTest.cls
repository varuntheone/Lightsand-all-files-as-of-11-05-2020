@IsTest(SeeAllData = true)
public class newDesignFormButtonControllerTest {
	 @IsTest(SeeAllData=true) 
    public static void initilizNewDesignRecords() {
       
        
        Global_Opportunity__c globOpp =new Global_Opportunity__c();
        globOpp.Business_Vertical__c = 'Hanger Business';
        globOpp.Product_Category__c = 'HANGERS';
        globOpp.Product_Family__c ='TOP';
        globOpp.Sub_category__c = 'PLASTIC HANGERS';
        
        insert globOpp;
        
    
         Test.startTest();          
              PageReference pageRef = new ApexPages.StandardController(globOpp).view();
              Test.setCurrentPage(pageRef);          
             
              ApexPages.currentPage().getParameters().put('Id',String.valueOf(globOpp.Id));
              ApexPages.StandardController stdController =   new ApexPages.StandardController(globOpp);      
         	  newDesignFormButtonController designController = new newDesignFormButtonController(stdController); 
        
              SObject parent = stdController.getRecord();
               
        		globOpp =  [select id ,Total_Volume__c,Description__c,Retailer_Code__c from Global_Opportunity__c where id =: parent.Id ];
                
        Test.stopTest();        
     }
}