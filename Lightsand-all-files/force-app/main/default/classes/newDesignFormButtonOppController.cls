public class newDesignFormButtonOppController {
    private final SObject parent;
    public Opportunity__c theOpp {get; set;}
    public String lastError {get; set;}
    
    public newDesignFormButtonOppController(ApexPages.StandardController sc) {
        parent = sc.getRecord();
        theOpp =  [select id ,Related_Global_opportunity_Id__c,Customer_Information__c,Customer_Type__c,Total_Volume__c,Details__c,Retailer__c from Opportunity__c where id =: parent.Id ];
        lastError = '';             
		               
     }  

}