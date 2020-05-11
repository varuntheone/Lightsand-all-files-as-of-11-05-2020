public class UpdateCreateProductConfigurator {
    @AuraEnabled
	public static Opportunity_Item_Master__c updateCheck(Id caseId){
        list<Opportunity_Item_Master__c> Pl_list = new list<Opportunity_Item_Master__c>();
        pl_list = [select id,New_Product_Configurator__c,Materials__c from Opportunity_Item_Master__c where Id = :caseId];
        Opportunity_Item_Master__c p =new Opportunity_Item_Master__c();
        p.id=pl_list[0].id;
        p.New_Product_Configurator__c=true;
        update p;
        return p;
    }
}