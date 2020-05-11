public with sharing class MouldActionFormRedirect {
	mould_action_form__c af = new mould_action_form__c();

	public MouldActionFormRedirect(apexpages.standardController sc) {
		af = (mould_action_form__c)sc.getRecord();
	}
	
	public pageReference redirect() {
// Redirect to MouldActionFormEdit page if selected record type is 'Change' or 'Modification'
// Otherwise, redirect to the standard edit page for Mould Action Form		
		string obj_type = mould_action_form__c.sobjectType.getDescribe().getKeyPrefix();
		
		id rtid;
		if (af.recordTypeId != null) {
			rtid = af.recordTypeId;
		}
		else {
			rtid = apexpages.currentPage().getParameters().get('RecordType'); 			
		}
		map<id, string> rt_map = new map<id, string>();
		set<id> cm_set = new set<id>();
		for (recordType rt:[select id, developerName from recordType where sobjectType = 'mould_action_form__c']) {
			rt_map.put(rt.id, rt.developerName);
			if (rt.developerName == 'Change' || rt.developerName == 'Modification') {
				cm_set.add(rt.id);
			}
		}
		
		string url;		
		if (cm_set.contains(rtid)) {
			url = '/apex/MouldActionFormEdit?';
		}
		else {
			url = '/' + obj_type + '/e?nooverride=1&';
		}
		if (af.id != null) {
			url += 'id=' + af.id + '&retURL=%2F' + af.id;
		}
		else if (rtid != null) {
			url += 'RecordType=' + rtid + '&retURL=%2F' + obj_type + '%2Fo';
			if (rt_map.get(rtid) == 'Migration') {
				string field_id;
				for (Field_ID__c f:Field_ID__c.getAll().values()) {
					if (f.Object_Name__c == 'Mould_Action_Form__c' && f.Field_Name__c == 'New_Record_Owner__c') {
						field_id = f.name;
						break;
					}
				}
				if (field_id != null) {
					url += '&CF' + field_id + '_lkid=' + userInfo.getUserId() + '&CF' + field_id + '=' + userInfo.getName();
				}
			}
		}
		pageReference pg = new pageReference(url);
		pg.setRedirect(true);
		return pg;		
	}
}