public class SubmitPageExtensionProductConfigurator {
    public String ProductConfigId{get; set;}

    public SubmitPageExtensionProductConfigurator(ApexPages.StandardController controller) {

       ProductConfigId= ApexPages.currentPage().getparameters().get('id');
       System.debug('######ProductConfigId:'+ProductConfigId);
       
    }

 
    public SubmitPageExtensionProductConfigurator(ApexPages.StandardSetController controller) {
    
       ProductConfigId= ApexPages.currentPage().getparameters().get('id');
       System.debug('######ProductConfigId:'+ProductConfigId);
       
    }
    
    public PageReference init(){
        if(ProductConfigId!= null && ProductConfigId.length() > 0){
            UtilityProductConfigurator.getFinalPDFContent(ProductConfigId);
        }
        //Online_Enquiry__c onlineEnquiry = [select Id from Online_Enquiry__c where Id=:onlineEnqId];
        //return new ApexPages.StandardController(onlineEnquiry).view();
        Product_Configurator__c productConfig= [select Id from Product_Configurator__c where Id=:ProductConfigId];
        return new ApexPages.StandardController(productConfig).view();
    }
}