public without sharing class ConfirmReceivedController {
	list<mould_action__c> ma_list = new list<mould_action__c>();

	public ConfirmReceivedController(apexpages.standardSetController sc) {
		ma_list = (list<mould_action__c>)sc.getSelected();
	}
	
	public pageReference confirmReceived() {
		set<id> ma_set = new set<id>();
		for (mould_action__c ma:ma_list) {
			ma_set.add(ma.id);
		}
		ma_list = [select name, mould__c, mould__r.To_Mould__c, Mould_Action_Form__r.recordType.developerName, Mould_Action_Form__r.New_Record_Owner__c, 
			Mould_Action_Form__r.New_Holder_Name__c, Mould_Action_Form__r.To_Country__c, Mould_Action_Form__r.To_Factory__c, Mould_Action_Form__r.New_Holder_Company__c 
			from mould_action__c where id in :ma_set];
		set<id> m_set = new set<id>();		
		for (mould_action__c ma:ma_list) {
			m_set.add(ma.mould__c);	
			if (ma.mould__r.To_Mould__c != null) {
				m_set.add(ma.mould__r.To_Mould__c);
			}
		}
		map<id, mould__c> m_map = new map<id, mould__c>([select id from mould__c where id in :m_set]);
		for (mould_action__c ma:ma_list) {
			if (ma.Mould_Action_Form__r.recordType.developerName == 'Movement_Lock' || ma.Mould_Action_Form__r.recordType.developerName == 'Migration_Lock') {
				if (userInfo.getUserId() != ma.Mould_Action_Form__r.New_Record_Owner__c) {
					apexpages.addMessage(new apexpages.Message(apexpages.severity.error, 'Not allowed to confirm the reception of mould for mould action ' + 
						ma.name + ' because you are not the new record owner.'));
				}
				else {
					if (ma.Mould_Action_Form__r.recordType.developerName == 'Movement_Lock') {
						ma.Confirm_Received__c = true;						
						mould__c m = m_map.get(ma.mould__c);
						m.Mould_Status__c = 'Active';
						m.status_updated_date__c = date.today();							
						m.ownerId = ma.Mould_Action_Form__r.New_Record_Owner__c;
						m.Mould_Holder__c = ma.Mould_Action_Form__r.New_Holder_Name__c;
						m.Country__c = ma.Mould_Action_Form__r.To_Country__c;
						m.Factory_Name__c = ma.Mould_Action_Form__r.To_Factory__c;
						m.Holder_Company__c = ma.Mould_Action_Form__r.New_Holder_Company__c;
					}
					else if (ma.Mould_Action_Form__r.recordType.developerName == 'Migration_Lock') {
						ma.Confirm_Received__c = true;				
						mould__c m = m_map.get(ma.mould__r.To_Mould__c);
						m.Mould_Status__c = 'Active';
						m.status_updated_date__c = date.today();					
					}						
				}	
			}

		}		
		update m_map.values();
		update ma_list;
		return new pageReference('/' + sObjectType.mould_action__c.getKeyPrefix() + '/o');
	} 
}