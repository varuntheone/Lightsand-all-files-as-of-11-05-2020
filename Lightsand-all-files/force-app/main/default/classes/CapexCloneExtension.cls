public class CapexCloneExtension{
private Capex__c budgetedCapex {get; set;}
private Capex__c originalBudgetedCapex {get; set;}
private Capex__c newCapex = null;
private String oldId = '';
 // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    public CapexCloneExtension(ApexPages.StandardController stdController) {
        this.budgetedCapex = (Capex__c)stdController.getRecord();
        System.debug('###budgetedCapex.id:'+budgetedCapex.Id);
        budgetedCapex=[select Name, Budget_Amount_Euro__c from Capex__c where Id=:budgetedCapex.Id];
        System.debug('###budgetedCapex.name:'+budgetedCapex.name);
//        System.debug('###budgetedCapex.id:'+budgetedCapex.Id);
        originalBudgetedCapex = [select Capex_Category__c from Capex__c where Id=:budgetedCapex.Id];
        oldId = budgetedCapex.Id;
        //budgetedCapex.name='Tejas';
      //  newCapex = budgetedCapex.clone(false, true);
               
      }
      
      public PageReference init(){
        
        
        String soql = getCreatableFieldsSOQL('Capex__c','id=:oldId');
originalBudgetedCapex = (Capex__c)Database.query(soql);
newCapex = originalBudgetedCapex.clone(false, true);
//insert newCapex;

        // System.debug('#### Parent capex:'+originalBudgetedCapex.name);
       // newCapex.Budgeted_Capex__c=budgetedCapex.id;
        if(budgetedCapex.Id!=null){
        System.debug('#### Capex Year:'+newCapex.Capex_Year__c);
        Date today = Date.today();
        
       // newCapex.Capex_Year__c=String.valueOf(Date.today().year());
        //newCapex.id='';
        System.debug('###originalBudgetedCapex.Capex_Category__c'+originalBudgetedCapex.Capex_Category__c);
        if(originalBudgetedCapex.Capex_Category__c == 'Mould for New Business/New Production'){
         System.debug('###Inside if');
        newCapex.RecordTypeId = '01290000000SVCG';
        }else{
        System.debug('###Inside else');
         newCapex.RecordTypeId = '01290000000SVCI';
        }
        newCapex.Budgeted_Capex__c=budgetedCapex.Id;
        newCapex.Cloned_from__c = budgetedCapex.Id;
        newCapex.Capex_Approval_Status__c = 'New Registration';
       // newCapex.Budget_Amount_Euro__c=budgetedCapex.Budget_Amount_Euro__c;
        newCapex.Budgeted_Yes_No__c = 'Yes';
        newCapex.OwnerId = UserInfo.getUserId();    
       // newCapex.Void_Remark__c = 'Testing Clonning4';    
        insert newCapex;
        //System.debug('####New BudgetedValue:'+newCapex.Budgeted_Yes_No__c);    
        newCapex.Budgeted_Yes_No__c = 'Yes';
        update newCapex;
         System.debug('###Budgeted Capex:'+budgetedCapex.Id);
        System.debug('###New Capex:'+newCapex.Id);
            PageReference pgref = new PageReference('/'+newCapex.Id);
           // pgref.getParameters().putAll(ApexPages.currentPage().getParameters());
            pgref.setRedirect(true);
            return pgref;
        }
        return null;
        }
      // Returns a dynamic SOQL statement for the whole object, includes only creatable fields since we will be inserting a cloned result of this query
    public static string getCreatableFieldsSOQL(String objectName, String whereClause){
         
        String selects = '';
         
        if (whereClause == null || whereClause == ''){ return null; }
         
        // Get a map of field name and field token
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
         
        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                if (fd.isCreateable()){ // field is creatable
                    selectFields.add(fd.getName());
                }
            }
        }
         //System.debug('###Select Fields:'+selectFields);
        if (!selectFields.isEmpty()){
            for (string s:selectFields){
                selects += s + ',';
            }
            System.debug('###Select Size:'+selectFields.size());
             System.debug('###Select Fields:'+selects);
            if (selects.endsWith(',')){selects = selects.substring(0,selects.lastIndexOf(','));}
             
        }
         
        return 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;
         
    }
}