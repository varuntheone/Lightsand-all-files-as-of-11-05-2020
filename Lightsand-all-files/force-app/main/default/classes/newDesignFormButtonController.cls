public class newDesignFormButtonController {
    private final SObject parent;
    public Global_Opportunity__c theGlobalOpp {get; set;}
    public String lastError {get; set;}
    
    public newDesignFormButtonController(ApexPages.StandardController sc) {
        parent = sc.getRecord();
        theGlobalOpp = new Global_Opportunity__c();
        theGlobalOpp =  [select id ,Total_Volume__c,Description__c,Retailer_Code__c from Global_Opportunity__c where id =: parent.Id ];
        lastError = '';             
		               
     }  

}