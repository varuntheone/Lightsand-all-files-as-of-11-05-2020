/**
 * An apex page controller that supports self registration of users in communities that allow self registration
 */
@IsTest public with sharing class CommunitiesSelfRegControllerTest {
 @IsTest(SeeAllData = true)
 public static void testCommunitiesSelfRegController() {
  // create controller
  CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
  controller.firstName = 'FirstName';
  controller.lastName = 'LastName';
  controller.email = 'test@force.com';
  controller.communityNickname = 'test';
  controller.companyName = 'testcompany';
  controller.title = 'Module lead';
  controller.telephone = '9663266726';

  // registerUser will always return null when the page isn't accessed as a guest user
  System.assert(controller.registerUser() == null);

  controller.password = 'abcd1234';
  controller.confirmPassword = 'abcd123';
  System.assert(controller.registerUser() == null);

  // creating test account
  Account communityAccount = new Account();
  communityAccount.Name = 'Community Account - Test';
  insert communityAccount;

  // creating user contact
  Contact userContact = new Contact();
  userContact.firstname = 'Pawan';
  userContact.lastname = 'Kumar';
  userContact.email = 'kpawantest@crmit.com';
  userContact.accountid = communityAccount.id;
  insert userContact;

  // create portal user 
  User portalUser = new User();
  portalUser.profileId = [select Id, Name from Profile where name = 'Mainetti Customer Community Login User'
   limit 1
  ].id;
  portalUser.username = userContact.email;
  portalUser.email = userContact.email;
  portalUser.emailencodingkey = 'UTF-8';
  portalUser.localesidkey = 'en_US';
  portalUser.languagelocalekey = 'en_US';
  portalUser.timezonesidkey = 'America/Los_Angeles';
  portalUser.alias = userContact.lastname;
  portalUser.lastname = userContact.lastname;
  portalUser.firstname = userContact.firstname;
  portalUser.contactId = userContact.Id;
  insert portalUser;

  // test action method
  CommunitiesSelfRegController.getUserByEmail(portalUser.email);
 }
}