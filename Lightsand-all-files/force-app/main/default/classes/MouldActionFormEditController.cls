public with sharing class MouldActionFormEditController {
    public mould_action_form__c maf = new mould_action_form__c();
    
    public mould_action__c mould_action {get; set;}
    public string subtitle {get; private set;}

    public MouldActionFormEditController(apexpages.standardController sc) {
        maf = (mould_action_form__c)sc.getRecord();
        list<mould_action__c> ma_list = new list<mould_action__c>();
        if (maf.id != null) {
            string query = 'select ';        
            for (schema.fieldSetMember f:sObjectType.mould_action__c.FieldSets.Edit_Section.getFields()) {
                query += f.getFieldPath() + ', ';
            }
            query += 'Mould_Action_Form__c from mould_action__c where Mould_Action_Form__c = \'' + maf.id + '\' limit 1';
            ma_list = database.query(query);        
        }
        else {
            maf.recordTypeId = apexpages.currentPage().getParameters().get('RecordType');
            maf.OwnerId = userInfo.getUserId();
        }
        if (ma_list.size() > 0) {
            mould_action = ma_list[0];
        }
        else {
            mould_action = new mould_action__c();           
        }

		map<id, string> rt_map = new map<id, string>();
		for (recordType rt:[select developerName from recordType where sobjectType = 'mould_action_form__c' and (developerName = 'change' or developerName = 'modification')]) {
			rt_map.put(rt.id, rt.developerName);
		}        
        if (rt_map.get(maf.recordTypeId) == 'Change') {
        	subtitle = 'Mould Change Detail';
        }
        else if (rt_map.get(maf.recordTypeId) == 'Modification') {
        	subtitle = 'Mould Modification Detail';
        }        
    }
    
    public pageReference save() {    	
    	if (upsertData()) {
    		return new pageReference('/' + maf.id);
    	}    		
        else {
        	return null;
        }
    }
    
    public pageReference saveNew() {
    	if (upsertData()) {
	    	pageReference pg = new pageReference('/apex/MouldActionFormEdit?RecordType=' + maf.RecordTypeId);
    		pg.setRedirect(true);
    		return pg;    		
    	}    	
        else {
        	return null;
        }
    }
    
    private boolean upsertData() {
    	try {
  	      upsert maf;  
	        if (mould_action.Mould_Action_Form__c == null) {
    	        mould_action.Mould_Action_Form__c = maf.id;
        	}
        	try {
		        upsert mould_action;            		
        	}
	  	    catch(exception ex2) {
				apexpages.addMessages(ex2);
				return false;	  	    	
	  	    }    		
    	}
		catch(exception ex1) {
			apexpages.addMessages(ex1);
			return false;
		}
		return true;
    }
}