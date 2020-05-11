@isTest
public class createByGOOwnerOnlyOnePerCountryTest {
    Public static TestMethod void createByGOOwnerOnlyOnePerCountryTriggerTest(){
        
        String onlyOneCountryErrorMsg='Only One Record Per Country can be created for a Global Opportunity.';
        String obcCreatRestrictErrorMsg='Only the record owner of the Global Opportunity can create new forecast by country.';
        //try{
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        
        User usr = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Mainetti System Administrator'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'vinod.k@techkasetti.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = r.Id
        );
        User usr1 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Mainetti-AppSubs-S6+QV'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = r.Id
        );
        insert r;
        insert usr;
        insert usr1;
        System.runAs(usr){
            Retailer_Code__c rcode = new Retailer_Code__c();
            rcode.Name = 'MACYS';
            insert rcode;
            
            Global_Opportunity__c gOpp = new Global_Opportunity__c();
            gOpp.Program_Name__c = 'Test Trigger';
            gOpp.Retailer_Code__c = rcode.id;
            gOpp.OwnerId =  usr.Id;
            gOpp.Global_Opportunity_Currencies__c = 'USD - United States Dollar';
            gOpp.Program_Starts_Year__c = '2019';
            gOpp.Business_Vertical__c ='Flexible Packaging';
            gOpp.Product_Category__c = 'POLYBAGS';
            gOpp.Sub_category__c = 'POLYBAGS';
            gOpp.Product_Family__c = 'POLYBAG';
            
            insert gOpp;
            
            Opportunity_by_Company__c obc0 = new Opportunity_by_Company__c();
            obc0.Global_Opportunity__c = gOpp.Id;
            obc0.Country__c = 'China';
            obc0.Value__c = 200;
            obc0.Volume__c = 10;
            obc0.OwnerId =  usr.Id;
            insert obc0;
            
            try{
                Opportunity_by_Company__c obc = new Opportunity_by_Company__c();
                obc.Global_Opportunity__c = gOpp.Id;
                obc.Country__c = 'China';
                obc.Value__c = 200;
                obc.Volume__c = 10;
                obc.OwnerId =  usr.Id;
                insert obc;
            } catch(Exception e){             
                Boolean expectedExceptionThrown =  e.getMessage().contains(onlyOneCountryErrorMsg) ? true : false;
                System.debug('expectedExceptionThrown:::::::onlyOneCountryErrorMsg'+expectedExceptionThrown); 
                System.AssertEquals(expectedExceptionThrown, true);                    
            }             
            try{
                Opportunity_by_Company__c obc1 = new Opportunity_by_Company__c();
                obc1.Global_Opportunity__c = gOpp.Id;
                obc1.Country__c = 'India';
                obc1.Value__c = 200;
                obc1.Volume__c = 10;
                obc1.OwnerId = usr1.Id;    
                insert obc1;
            } catch(Exception e){             
                Boolean expectedExceptionThrown =  e.getMessage().contains(obcCreatRestrictErrorMsg) ? true : false;
                System.AssertEquals(expectedExceptionThrown, true);    
                
            } 
            try{
                Opportunity_by_Company__c obc2 = new Opportunity_by_Company__c();
                obc2.Global_Opportunity__c = gOpp.Id;
                obc2.Id = obc0.Id;
                obc2.Country__c = 'China';
                obc2.Value__c = 200;
                obc2.Volume__c = 10;
                obc2.OwnerId = usr.Id;    
                update obc2;
            } catch(Exception e){             
                Boolean expectedExceptionThrown =  e.getMessage().contains(onlyOneCountryErrorMsg) ? true : false;
                System.AssertEquals(expectedExceptionThrown, true);                  
            }            
            try{
                Opportunity_by_Company__c obc3 = new Opportunity_by_Company__c();
                obc3.Global_Opportunity__c = gOpp.Id;
                obc3.Country__c = 'China';
                obc3.Value__c = 200;
                obc3.Volume__c = 10;
                obc3.OwnerId =  usr.Id;
                if(obc0.Country__c != obc3.Country__c)
                update obc0;
            } catch(Exception e){             
                Boolean expectedExceptionThrown =  e.getMessage().contains(onlyOneCountryErrorMsg) ? true : false;
                System.debug('expectedExceptionThrown:::::::onlyOneCountryErrorMsg'+expectedExceptionThrown); 
                System.AssertEquals(expectedExceptionThrown, true);                    
            }             
        }           
    }
    public class myException extends Exception {}
}