public class newProductButtonController {
    private final SObject parent;
    public Design_Log_Form__c designLogForm {get; set;}
    //public String lastError {get; set;}
    
    public newProductButtonController(ApexPages.StandardController sc) {
        parent = sc.getRecord();
        designLogForm = new Design_Log_Form__c();                 
        designLogForm =[select Project_Status__c from Design_Log_Form__c where Id =:parent.Id];	
        if(designLogForm.Project_Status__c != 'Complete'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Design Project Status has to be Complete, to create a New Product'));
        }
     }  
}