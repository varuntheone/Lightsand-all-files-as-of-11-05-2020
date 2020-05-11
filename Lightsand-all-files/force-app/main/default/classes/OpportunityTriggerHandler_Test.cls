@IsTest(seeAllData=false)
public class OpportunityTriggerHandler_Test {

    
    @IsTest
    public static void createOppotunity(){
        
        Exchange_Rate__c exchangeRate = new Exchange_Rate__c();
        exchangeRate.Month__c='Dec';
        exchangeRate.Year__c='2017';
        exchangeRate.Local_Currency__c='HKD - Hong Kong Dollar';
        exchangeRate.ExRate_to_USD__c=1.0;
        exchangeRate.Active__c=true;
        insert exchangeRate;
        
        Opportunity__c opp = new Opportunity__c();
        opp.Currency__c='HKD - Hong Kong Dollar';
		opp.Start_Date__c= Date.parse('12/12/2017');
        opp.Opportunity_Name__c='test opp';
        opp.Lead_Source__c='Other';
        opp.Customer_Type__c='Existing Business';
        insert opp;
        
        
    }
    
}