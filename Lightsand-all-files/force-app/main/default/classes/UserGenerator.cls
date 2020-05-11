public with sharing class UserGenerator {
	public static final String DEF_VALUE_PROFILE_NAME = 'Standard User';
	public static final ID DEF_VALUE_PROFILE_ID;
	public static final String DEF_VALUE_ROLE_NAME = null;
	public static final ID DEF_VALUE_ROLE_ID;
	public static final String DEF_VALUE_EMAIL_DOMAIN = '@manetti.com';
	public static final String DEF_VALUE_EMAIL_ENCODE_KEY = 'UTF-8';
	public static final String DEF_VALUE_LOCALE = 'en_US';
	public static final String DEF_VALUE_LANG = 'en_US';
	public static final String DEF_VALUE_TIMEZONE = 'Asia/Hong_Kong';
	
	static {
		if (DEF_VALUE_PROFILE_NAME != null) {
			List<Profile> defProfileList = [SELECT Id FROM Profile WHERE Name = :DEF_VALUE_PROFILE_NAME];
			if (defProfileList.size() > 0) {
				DEF_VALUE_PROFILE_ID = defProfileList.get(0).Id;
			}
		}
		if (DEF_VALUE_ROLE_NAME != null) {
			List<UserRole> defRoleList = [SELECT Id FROM UserRole WHERE Name = :DEF_VALUE_ROLE_NAME];
			if (defRoleList.size() > 0) {
				DEF_VALUE_ROLE_ID = defRoleList.get(0).Id;
			}
		}
	}
	
	public User generateBasicUser(String username, String email
		, String lastName, String firstName, String nickName, String alias
		, ID userProfileId, ID userRoleId) {
		return new User(
			Username = username
			, Email = email
			, LastName = lastName
			, FirstName = firstName
			, CommunityNickname = nickName
			, Alias = alias
			, ProfileId = userProfileId
			, UserRoleId = userRoleId
			, EmailEncodingKey = DEF_VALUE_EMAIL_ENCODE_KEY
			, LocaleSidKey = DEF_VALUE_LOCALE
			, LanguageLocaleKey = DEF_VALUE_LANG
			, TimeZoneSidKey = DEF_VALUE_TIMEZONE
		);
	}

	public User generateUser(String lastName) {
		String convertedName = lastName.trim().replace(' ', '_').toLowerCase();
		return generateBasicUser(
			convertedName + DEF_VALUE_EMAIL_DOMAIN, convertedName + DEF_VALUE_EMAIL_DOMAIN
			, lastName, null, convertedName, convertedName
			, DEF_VALUE_PROFILE_ID, DEF_VALUE_ROLE_ID
		);
	}

}