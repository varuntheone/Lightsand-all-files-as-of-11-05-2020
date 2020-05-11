public class ProductConfiguratorExtension {
    
    public List<String> sectionsList{get;set;}
    public Map<String,String[]> fieldsMap{get;set;}
    public ProductConfigurationFieldsSetup__mdt prodConfigMdt {get;set;}
    public Product_Configurator__c prodConfidObj{get;set;}
    public String type {get;set;}
    public Map<String,String> ProductConfigurationImageFieldsMap {get;set;}
    public String imageFormulaFields {get;set;}
    public List<Product_Configurator__c> pdObjList {get;set;}
     public Product_Configurator__c pdObj {get;set;}
    public String recordTypeId {get;set;}
    public String recordType  {get;set;}
    public ID recordID {get;set;}
    
    public ProductConfiguratorExtension(ApexPages.StandardController stdController) {
        sectionsList = new List<String>();
        fieldsMap = new Map<String,String[]>();
        ProductConfigurationImageFieldsMap = new Map<String,String>();
        String queryFields='';
        type = 'Edit';
        
        try{                       
            recordID = ApexPages.currentPage().getParameters().get('id');
            recordTypeId = ApexPages.currentPage().getParameters().get('RecordType');    
            if(String.isNotBlank(recordTypeId)){
                type='New';
                recordType = [SELECT Id,Name from RecordType where sObjectType='Product_Configurator__c' and Id= :recordTypeId LIMIT 1].Name;
            }else{
               Product_Configurator__c prodConf = [SELECT recordType.Name from Product_Configurator__c where Id = :recordID];
                recordType = prodConf.recordType.Name;
            }
         }catch(Exception exe){             
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,exe.getMessage()));             
            System.debug('Error ::: '+exe);            
        }        
    }
    
    public PageReference initialize(){
      String queryFields='';
          try{
            
              List<Schema.FieldSetMember> imageFieldSetMemberList =  readFieldSet('Image_Fields');
              for(Schema.FieldSetMember fieldSetMemberObj : imageFieldSetMemberList)
              {
                  String fieldAPIName = fieldSetMemberObj.getFieldPath();
                  imageFormulaFields = String.isBlank(imageFormulaFields)?fieldAPIName:imageFormulaFields+','+fieldAPIName;  
              } 
              
              pdObjList =  Database.query('SELECT ID,'+imageFormulaFields+' FROM Product_Configurator__c WHERE recordType.Name = :recordType LIMIT 1');
             
              if(pdObjList==null || pdObjList.size() <= 0){
                  pdObj = new Product_Configurator__c();
              }else{
                  pdObj = pdObjList.get(0);
                  
              }            
              
              prodConfigMdt = [SELECT ID,Name__c,Fields__c FROM ProductConfigurationFieldsSetup__mdt WHERE Name__c= :recordType LIMIT 1];
              
              String[] fieldSetupMdtArray = (prodConfigMdt.Fields__c).split(',');
              Set<String> queryFieldsSet = new Set<String>();
              
              for(String eachFieldMdt : fieldSetupMdtArray){
                  
                  String sectionName =eachFieldMdt.split('=')[0];
                  String fieldSetName =eachFieldMdt.split('=')[1];   
                  List<String> eachSectionFieldList = new List<String>();                
                  sectionsList.add(sectionName);
                   System.debug('fieldSetName '+fieldSetName);
                  List<Schema.FieldSetMember> fieldSetMemberList =  readFieldSet(fieldSetName);
                  System.debug('fieldSetMemberList ');
                  
                  for(Schema.FieldSetMember fieldSetMemberObj : fieldSetMemberList)
                  {
                      String fieldAPIName = fieldSetMemberObj.getFieldPath();
                      queryFieldsSet.add(fieldAPIName);                                       
                      eachSectionFieldList.add(fieldAPIName);
                  }                
                  fieldsMap.put(sectionName,eachSectionFieldList);
              }    
              List<String> queryFieldsList = new List<String>(queryFieldsSet);                
              queryFields = String.join(queryFieldsList, ',');
              if(type.equalsIgnoreCase('New')){
                  prodConfidObj = new Product_Configurator__c();
              }
              else{
                 String queryString = 'SELECT ID,'+queryFields+' FROM Product_Configurator__c WHERE ID =:recordID';     
                 prodConfidObj =  Database.query(queryString); 
              }
              
        }catch(Exception exe){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,exe.getMessage()));             
            System.debug('Error ::: '+exe);            
        }  
        
        return null;
    }
    
    public static List<Schema.FieldSetMember> readFieldSet(String fieldSetName)
    {
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get('Product_Configurator__c');
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName.trim());
        return fieldSetObj.getFields(); 
    } 
        
    public PageReference save(){        
        if(type.equalsIgnoreCase('New')){            
            prodConfidObj.RecordTypeId=RecordTypeId;
            insert prodConfidObj;
            return  new PageReference('/'+prodConfidObj.Id);            
        }else{
            update prodConfidObj;
            return  new PageReference('/'+prodConfidObj.Id);            
        }
    }
    
    public PageReference continuePage(){
        PageReference pagRef=  new PageReference('https://mainetti--lightsand.cs31.my.salesforce.com');
        pagRef.setRedirect(true);        
        return pagRef;
    }
}