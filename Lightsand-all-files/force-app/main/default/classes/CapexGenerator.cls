public with sharing class CapexGenerator {
	public static final String DEF_VALUE_OWNERSHIP = 'Mainetti';
	public static final Integer DEF_VALUE_PAY_BACK_PERIOD = 3;
	public static final String DEF_VALUE_CATEGORY_MOULD = 'Mould for New Business';
	public static final String DEF_VALUE_CATEGORY_OTHER = 'Automation';
	public static final String DEF_VALUE_CAPEX_YEAR = String.valueOf(System.today().year());
	public static final String RT_Budgeted = 'Budgeted_Capex';
	public static final String RT_Mould = 'Mould_Capex';
	public static final String RT_MouldApproved = 'Mould_Capex_Approved';
	public static final String RT_Other = 'Other_Capex';
	public static final String RT_OtherApproved = 'Other_Capex_Approved';
	
	private static Map<String, RecordType> RTMap {
		get {
			if (RTMap == null) {
				List<RecordType> RTList = [SELECT Id, Name, DeveloperName, IsActive, SobjectType, NamespacePrefix, BusinessProcessId FROM RecordType WHERE SobjectType = 'Capex__c'];
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
	
	public Capex__c generateBasicCapex() {
		return new Capex__c(
			Capex_Ownership__c = DEF_VALUE_OWNERSHIP
			, Pay_Back_Period__c = DEF_VALUE_PAY_BACK_PERIOD
			, Capex_Year__c = DEF_VALUE_CAPEX_YEAR
		);
	} 

	public Capex__c generateCapex(ID rtID, Retailer_Code__c retailerCode) {
		Capex__c result = generateBasicCapex();
		result.RecordTypeId = rtID;
		if (rtID == getRecordTypeByDevName(RT_Mould).Id) {
			result.Capex_Category__c = DEF_VALUE_CATEGORY_MOULD;
			result.Retailer_Code1__c = retailerCode.Id;
		} else if (rtID == getRecordTypeByDevName(RT_Other).Id) {
			result.Capex_Category__c = DEF_VALUE_CATEGORY_OTHER;
		}
		return result;
	} 

	public Capex__c generateCapex(String rtDevName, Retailer_Code__c retailerCode) {
		return generateCapex(getRecordTypeByDevName(rtDevName).Id, retailerCode);
	}
	
	public Capex__c generateMouldCapex(Retailer_Code__c retailerCode) {
		return generateCapex(RT_Mould, retailerCode);
	}
	public Capex__c generateOtherCapex() {
		return generateCapex(RT_Other, null);
	}
}