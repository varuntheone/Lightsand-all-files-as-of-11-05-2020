@isTest
public class OpportunityItemReadOnlyTest {
    Public static TestMethod void opportunityItemTriggerTest(){
        try{
            ID groupId = [select id from Group where Type = 'Organization'].id;
            
            Opportunity__c opp = new Opportunity__c();
            opp.Opportunity_Name__c = 'Test Trigger';
            opp.Details__c ='Welcome';
            insert opp;
            
            Opportunity_Item_Master__c oim = new Opportunity_Item_Master__c();
            oim.Product_Name__c = 'Item Test';
            oim.Business_Vertical__c = 'TLA';
            oim.Potential_Volume__c = 200;
            oim.Potential_Unit_Price__c = 10;
            oim.Product_Category__c = 'CARTON';
            oim.Product_SubCategory__c = 'CARTON';
            oim.UOM__c = 'PC';
            oim.Stage__c = 'Pending';
            oim.Opportunity_ID__c = opp.Id;
            insert oim;
            
            
            Opportunity__Share oppShare = new Opportunity__Share();
            
            oppShare.AccessLevel = 'Read';
            oppShare.ParentId = opp.Id;
            oppShare.UserOrGroupId = groupId;
            insert oppShare;
            
            oim.Potential_Unit_Price__c = 20;
            update oim;
            
            List<UserRecordAccess> usr =[SELECT RecordId FROM UserRecordAccess WHERE UserId =: UserInfo.getUserId() AND HasEditAccess = True AND RecordId =: opp.Id];
            if(usr.size() == 0){
				throw new MyException('No Access to Edit');    
            }                     
        } catch(Exception e){             
            Boolean expectedExceptionThrown =  e.getMessage().contains('No Access to Edit') ? true : false;            
            System.AssertEquals(expectedExceptionThrown, true);                             
        } 
    }
    public class myException extends Exception {}

}