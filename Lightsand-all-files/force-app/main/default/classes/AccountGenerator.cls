public with sharing class AccountGenerator {
	
	public static final String DEF_VALUE_NAME = 'Test Account';
	public static final String RTRetailer = 'Retailer';
	public static final String RTLabel_Retailer = 'Retailer';
	public static final String MSEGMENT_USA = 'USA';
	public static final String MSEGMENT_UK = 'UK';

	private static Map<String, RecordType> RTMap {
		get {
			if (RTMap == null) {
				List<RecordType> RTList = [SELECT Id, Name, DeveloperName, IsActive, SobjectType, NamespacePrefix, BusinessProcessId FROM RecordType WHERE SobjectType = 'Account'];
				RTMap = new Map<String, RecordType>();
				for (RecordType rt : RTList) {
					RTMap.put(rt.DeveloperName, rt);
				}
			}
			return RTMap;
		}
		set;
	} 

	public static RecordType getRecordTypeByDevName(String devName) { return RTMap.get(devName); }
	
	public Account generateBasicAccount() {
		return new Account(
			Name = DEF_VALUE_NAME
		);
	} 

	public Account generateAccount(ID rtID) {
		Account result = generateBasicAccount();
		result.RecordTypeId = rtID;
		return result;
	} 

	public Account generateAccount(String rtDevName) {
		return generateAccount(getRecordTypeByDevName(rtDevName).Id);
	}
	
}