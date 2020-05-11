trigger MouldActionTrigger on Mould_Action__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
	if (trigger.isBefore) {
		if (trigger.isInsert || trigger.isUpdate) {
			routineBeforeUpsert();
		}
	}
	else {
		if (trigger.isInsert || trigger.isUpdate) {
			routineAfterUpsert();
		}
	}

	private void routineAfterUpsert() {
// Check whether the mould record owner is the same as the other moulds that to be migrated together.		
//	If yes, set the migration approver of the migration action form to the mould record owner.	
//  If no, display error message.
		set<id> maf_set = new set<id>();
		for (Mould_Action__c ma:trigger.new) {
			if (ma.Mould_Action_Type__c == 'Migration') {
				if (trigger.isInsert || (trigger.isUpdate && ma.mould__c != trigger.oldMap.get(ma.id).mould__c)) {
					maf_set.add(ma.Mould_Action_Form__c);					
				}
			}
		}
		if (maf_set.size() > 0) {
			list<Mould_Action_Form__c> maf_list = [select (select mould__r.ownerId from mould_actions__r) from Mould_Action_Form__c where id in :maf_set for update];
			set<id> err_maf_set = new set<id>();
			boolean update_maf = false;
			for (mould_action_form__c maf:maf_list) {
				id record_owner;
				boolean same_owner = true;
				for (mould_action__c ma:maf.mould_actions__r) {
					if (record_owner == null) {
						record_owner = ma.mould__r.ownerId;
					}
					else if (ma.mould__r.ownerId != record_owner) {
						same_owner = false;
						break;
					}
				}
				if (same_owner) {
					maf.Migration_Approver__c = record_owner;
					update_maf = true;
				}
				else {
					err_maf_set.add(maf.id);					
				}
			}
			if (update_maf) {
				update maf_list;
			}
			if (err_maf_set.size() > 0) {
				for (mould_action__c ma:trigger.new) {
					if (err_maf_set.contains(ma.mould_action_form__c)) {
						ma.mould_directory__c.addError('The mould record owner does not match the other moulds that are to be migrated together');
					}
				}
			}
		}	
	}
	
	private void routineBeforeUpsert() {
		set<id> maf_set = new set<id>();
		set<id> md_set = new set<id>();
		for (Mould_Action__c ma:trigger.new) {
			maf_set.add(ma.Mould_Action_Form__c);
			md_set.add(ma.Mould_Directory__c);
		}
		
// Set mould__c according to the value in Mould_Directory__c		
		map<id, Mould_Directory__c> md_map = new map<id, Mould_Directory__c>([select Mould__c, Factory__c, Holder_Company__c from Mould_Directory__c where id in :md_set]);
		for (Mould_Action__c ma:trigger.new) {
			if (ma.Mould_Directory__c == null) {
				ma.Mould__c = null;
			}
			else {
				ma.Mould__c = md_map.get(ma.Mould_Directory__c).Mould__c;
			}
		}
		
// For mould change/modification actions, validate the company and factory of selected mould against those of the mould action form
		map<id, Mould_Action_Form__c> maf_map = new map<id, Mould_Action_Form__c>([select From_Company__c, From_Factory__c from Mould_Action_Form__c where id in :maf_set]);
		for (Mould_Action__c ma:trigger.new) {
			if (ma.Mould_Action_Type__c == 'Change' || ma.Mould_Action_Type__c == 'Modification') {
				if (ma.Mould_Directory__c != null) {
					if (maf_map.get(ma.Mould_Action_Form__c).From_Factory__c != null && md_map.get(ma.Mould_Directory__c).Factory__c != maf_map.get(ma.Mould_Action_Form__c).From_Factory__c) {
						ma.Mould_Directory__c.addError('The factory of the selected mould does not match with the From Factory specified in the mould action form');
					}		
					if (maf_map.get(ma.Mould_Action_Form__c).From_Company__c != null && md_map.get(ma.Mould_Directory__c).Holder_Company__c != maf_map.get(ma.Mould_Action_Form__c).From_Company__c) {
						ma.Mould_Directory__c.addError('The holder company of the selected mould does not match with the From Company specified in the mould action form');
					}
				}						
			}
		}
	}
}