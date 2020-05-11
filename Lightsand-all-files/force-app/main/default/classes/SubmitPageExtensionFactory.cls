public class SubmitPageExtensionFactory {
    public String WHNId{get; set;}

    public SubmitPageExtensionFactory(ApexPages.StandardController controller) {

       WHNId= ApexPages.currentPage().getparameters().get('id');
       System.debug('######WHNId:'+WHNId);
       
    }

 
    public SubmitPageExtensionFactory(ApexPages.StandardSetController controller) {
    
       WHNId= ApexPages.currentPage().getparameters().get('id');
       System.debug('######WHNId:'+WHNId);
       
    }
    
    public PageReference init(){
        if(WHNId!= null && WHNId.length() > 0){
            UtilityFactory.getFinalPDFContent(WHNId);
        }
        //Online_Enquiry__c onlineEnquiry = [select Id from Online_Enquiry__c where Id=:onlineEnqId];
        //return new ApexPages.StandardController(onlineEnquiry).view();
        Wooden_Hanger_Requisition_Form__c WHNsampleId= [select Id from Wooden_Hanger_Requisition_Form__c where Id=:WHNId];
        return new ApexPages.StandardController(WHNsampleId).view();
    }
}