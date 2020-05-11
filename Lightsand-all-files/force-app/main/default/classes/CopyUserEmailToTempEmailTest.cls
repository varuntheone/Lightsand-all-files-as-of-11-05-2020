@isTest public class CopyUserEmailToTempEmailTest{
    @IsTest(SeeAllData=true) 
        public static void testCopyUserEmailToTempEmailTriggerTest() {
          test.startTest(); 
            String accountId = '0019000000sJJVs';
            String email='crmitdtejas62@gmail.com';
            String firstname='Tejas';
            String lastName = 'Jambekar';
            Contact c = new Contact();
            c.FirstName = firstname;
            c.LastName = lastname;
            c.Email = email;
            c.AccountId = accountId;
            insert c;
                   
            User newUser = new User(profileId = '00e90000001hj73',username = 'newUser@yahoo.com',email = 'pb@ff.com',emailencodingkey = 'UTF-8',localesidkey = 'en_US',languagelocalekey = 'en_US',timezonesidkey = 'America/Los_Angeles',alias='nuser',lastname='lastname', contactId = c.Id);
			insert newUser;
        test.stopTest();
            
        }

}