@IsTest(SeeAllData = true)
public class newDesignFormButtonOppControllerTest {
 @IsTest(SeeAllData=true) 
    public static void initilizNewDesignRecords() {
       
        
        Opportunity__c Opp =new Opportunity__c();
         Opp.Opportunity_Name__c = 'New Design Button';      
        insert Opp;
        
    
         Test.startTest();          
              PageReference pageRef = new ApexPages.StandardController(Opp).view();
              Test.setCurrentPage(pageRef);          
             
              ApexPages.currentPage().getParameters().put('Id',String.valueOf(Opp.Id));
              ApexPages.StandardController stdController =   new ApexPages.StandardController(Opp);      
         	  newDesignFormButtonOppController designController = new newDesignFormButtonOppController(stdController); 
        
              SObject parent = stdController.getRecord();
               
        		Opp =  [select id ,Related_Global_opportunity_Id__c,Customer_Information__c,Customer_Type__c,Total_Volume__c,Details__c,Retailer__c from Opportunity__c where id =: parent.Id ];
                
        Test.stopTest();        
     }
}