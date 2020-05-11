@isTest
private class CapexTriggerTest {

    static testMethod void test_shareWithApprovers() {
        final List<String> USER_NAMES = new List<String>{'user1', 'user2', 'user3'};
        UserGenerator userGen = new UserGenerator();
        CapexGenerator capexGen = new CapexGenerator();
        List<User> testUserList = new List<User>();
        for (String userLastName : USER_NAMES) {
            User testUser = userGen.generateUser(userLastName);
            testUserList.add(testUser);
        }
        insert testUserList;
        //Jeffrey add global acct manager user info
        testUserList[2].Global_Account_Manager_Approver__c = true;
        update testUserList[2];
        
        
        
        // Jeffrey add test Capex Group ID - prepare Capex Auto Num - Start //
        List<Sys_Capex_Auto_Num__c> CPX_Num_List = new List<Sys_Capex_Auto_Num__c>();
        
        Sys_Capex_Auto_Num__c CPX_Num = new Sys_Capex_Auto_Num__c();
        CPX_Num.Capex_Company_Name__c ='Mainetti Bangladesh';
        CPX_Num.Capex_Location_code__c ='52';
        CPX_Num.Code__c='MBA';
        CPX_Num.Next_Num__c='001';
        CPX_Num.Year__c='2013';
        CPX_Num_List.add(CPX_Num);
        
        CPX_Num = new Sys_Capex_Auto_Num__c();
        CPX_Num.Code__c='GHA';
        CPX_Num.Next_Num__c='001';
        CPX_Num.Year__c='2013';
        CPX_Num_List.add(CPX_Num);
        
        CPX_Num = new Sys_Capex_Auto_Num__c();
        CPX_Num.Code__c='GCU';
        CPX_Num.Next_Num__c='0001';
        CPX_Num.Year__c='2013';
        CPX_Num_List.add(CPX_Num);
        
        CPX_Num = new Sys_Capex_Auto_Num__c();
        CPX_Num.Code__c='GCB';
        CPX_Num.Next_Num__c='0001';
        CPX_Num.Year__c='2013';
        CPX_Num_List.add(CPX_Num);
        
        CPX_Num = new Sys_Capex_Auto_Num__c();
        CPX_Num.Code__c='GP';
        CPX_Num.Next_Num__c='0001';
        CPX_Num.Year__c='2013';
        CPX_Num_List.add(CPX_Num);

        CPX_Num = new Sys_Capex_Auto_Num__c();
        CPX_Num.Code__c='GHS';
        CPX_Num.Next_Num__c='001';
        CPX_Num.Year__c='2013';
        CPX_Num_List.add(CPX_Num);
        
        insert CPX_Num_List;
        
        // Jeffrey add test Capex Group ID - prepare Capex Auto Num - End //
        
        
        Test.startTest();
        
        // Test insert
        Capex__c testCapex = capexGen.generateOtherCapex();
        Set<ID> expectShareTargetIdSet = new Set<ID>{
            testUserList.get(0).Id
            , testUserList.get(1).Id
        };
        testCapex.Country_Head_Sales_Director__c = testUserList.get(0).Id;
        testCapex.Regional_Director_Deputy__c = testUserList.get(1).Id;
        
        
        /////Jeffrey add Capex Group ID test - start//////
        testCapex.Capex_Approval_Status__c='New Registration';
        testCapex.Company_Name__c='Mainetti Bangladesh';
        testCapex.Capex_Year__c ='2013';
        List<Recordtype> Record_Type_ID = [select id from Recordtype where Name = 'Mould Capex'];
        testCapex.recordtypeID = Record_Type_ID[0].id;
        testCapex.Capex_Ownership__c='Licensees';
        testCapex.Capex_Code__c='GHA';
        insert testCapex;
        /////Jeffrey add Capex Group ID test - end//////
        
        validateSharingRules(testCapex, expectShareTargetIdSet);
        
         // Test duplicate users
        expectShareTargetIdSet = new Set<ID>{
            testUserList.get(1).Id
            , testUserList.get(2).Id
        };
        testCapex.Country_Head_Sales_Director__c = testUserList.get(1).Id;
        testCapex.Global_Account_Manager__c = testUserList.get(2).Id;
        testCapex.Regional_Director_Deputy__c = testUserList.get(1).Id;
        //Jeffrey add test - update approval status - start//
        testCapex.Capex_Approval_Status__c='Approved by COO';
        update testCapex;
        
        testCapex.Capex_Ownership__c='Mainetti';
        testCapex.Capex_Code__c='GCU';
        testCapex.Group_Capex_Number__c='';
        update testCapex;
        
        testCapex.Capex_Ownership__c='Mainetti';
        testCapex.Capex_Code__c='GCB';
        testCapex.Group_Capex_Number__c='';
        update testCapex;
        
        testCapex.Capex_Ownership__c='Mainetti';
        testCapex.Capex_Code__c='GP';
        testCapex.Group_Capex_Number__c='';
        update testCapex;
        
        testCapex.Capex_Ownership__c='Sub-contractor';
        testCapex.Capex_Code__c='GHS';
        testCapex.Group_Capex_Number__c='';
        update testCapex;
        
        //Jeffrey Capex Group test - End
        
        
        validateSharingRules(testCapex, expectShareTargetIdSet);
        
         // Test user removal
        expectShareTargetIdSet = new Set<ID>{
            testUserList.get(1).Id
        };
        testCapex.Country_Head_Sales_Director__c = testUserList.get(1).Id;
        testCapex.Global_Account_Manager__c = null;
        testCapex.Regional_Director_Deputy__c = null;
        update testCapex;
        validateSharingRules(testCapex, expectShareTargetIdSet);
        
        Test.stopTest();
    }
    
    static void validateSharingRules(Capex__c testCapex, Set<ID> expectShareTargetIdSet) {
        List<Capex__Share> testCapexShareList = [SELECT Id, UserOrGroupId FROM Capex__Share WHERE ParentId = :testCapex.Id];
        System.assert(testCapexShareList.size() >= expectShareTargetIdSet.size());
        for (ID expectedId : expectShareTargetIdSet) {
            Boolean isFound = false;
            for (Capex__Share capexShare : testCapexShareList) {
                if (capexShare.UserOrGroupId == expectedId) {
                    isFound = true;
                    break;
                }
            }
            System.assert(isFound);
        }
    }
}