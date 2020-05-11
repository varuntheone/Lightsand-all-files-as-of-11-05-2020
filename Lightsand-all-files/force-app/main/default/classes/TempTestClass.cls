public  class TempTestClass {
    public  void getProductPickListValue(){
		productDependentPicklist pdp = new productDependentPicklist();
    	  String contrfieldApiName = 'Business_Vertical__c';
          String depfieldApiName   = 'Sub_category__c';  
    	  String depfieldApiName1   = 'Product_Type__c';  	
    	  sObject sProduct = new Product__c(); 
         Map<String, List<String>> pickValue =  productDependentPicklist.getDependentMap(sProduct,depfieldApiName1,depfieldApiName);
         System.debug('pickValue::::'+pickValue);
    }
}