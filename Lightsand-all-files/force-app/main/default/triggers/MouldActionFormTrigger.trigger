trigger MouldActionFormTrigger on Mould_Action_Form__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {

    if (trigger.isAfter) {
        if (trigger.isInsert) {
            routineAfterInsert();
        }
        else if (trigger.isUpdate) {
            routineAfterUpdate();
        }
    }

    private static string buildQuery(string sobject_name, string relationship_name) {
        string q = 'select '; 
        boolean start = true;             
        for (string f:schema.getGlobalDescribe().get(sobject_name).getDescribe().fields.getMap().keySet()) {
            if (start) {
                q += f;
                start = false;
            }
            else {
                q += ', ' + f;
            }
        }
        q += ' from ';
        if (relationship_name != null) {
            q += relationship_name;
        }
        else {
            q += sobject_name;
        }
        return q;
    }

    private void routineAfterInsert() {
// Create sharing objects for new mould owners, new mould holders, new record owners, migration approver and disposal approver 
        list<mould_action_form__share> new_share_list = new list<mould_action_form__share>();
        for (mould_action_form__c m:trigger.new) {
            if (m.new_owner_name__c != null) {
                new_share_list.add(new mould_action_form__share(
                    parentId = m.id, 
                    userOrGroupId = m.new_owner_name__c,
                    rowCause = schema.mould_action_form__share.rowCause.new_mould_owner__c,
                    accessLevel = 'read'));
            }
            if (m.new_holder_name__c != null) {
                new_share_list.add(new mould_action_form__share(
                    parentId = m.id,
                    userOrGroupId = m.new_holder_name__c,
                    rowCause = schema.mould_action_form__share.rowCause.new_mould_holder__c,
                    accessLevel = 'read'));
            }
            if (m.new_record_owner__c != null) {
                new_share_list.add(new mould_action_form__share(
                    parentId = m.id,
                    userOrGroupId = m.new_record_owner__c,
                    rowCause = schema.mould_action_form__share.rowCause.new_record_owner__c,
                    accessLevel = 'read'));
            }
            if (m.Migration_Approver__c != null) {
                new_share_list.add(new mould_action_form__share(
                    parentId = m.id,
                    userOrGroupId = m.Migration_Approver__c,
                    rowCause = schema.mould_action_form__share.rowCause.Migration_Approver__c,
                    accessLevel = 'edit'));
            }   
            if (m.Disposal_Approver__c != null) {
                new_share_list.add(new mould_action_form__share(
                    parentId = m.id,
                    userOrGroupId = m.Disposal_Approver__c,
                    rowCause = schema.mould_action_form__share.rowCause.Disposal_Approver__c,
                    accessLevel = 'edit'));
            }                                                   
        }
                
        if (new_share_list.size() > 0) {
            insert new_share_list;
        }
    }
    
    private void routineAfterUpdate() {
// Delete sharing objects for old mould owners, old mould holders, old record owners, old migration approver and old disposal approver
// Create sharing objects for new mould owners, new mould holders, new record owners, new migration approver and new disposal approver  
        id old_owner, old_holder, old_record_owner, old_migration_approver, old_disposal_approver;
        list<id> old_owner_list = new list<id>();
        list<id> old_holder_list = new list<id>();
        list<id> old_record_owner_list = new list<id>();
        list<id> old_migration_approver_list = new list<id>();  
        list<id> old_disposal_approver_list = new list<id>();                               
        list<mould_action_form__share> old_share_list = new list<mould_action_form__share>();       
        list<mould_action_form__share> new_share_list = new list<mould_action_form__share>();       
        for (mould_action_form__c m:trigger.new) {
            old_owner = trigger.oldMap.get(m.id).new_owner_name__c;
            if (m.new_owner_name__c != old_owner) {
                if (old_owner != null) {
                    old_owner_list.add(m.id);
                }
                if (m.new_owner_name__c != null) {
                    new_share_list.add(new mould_action_form__share(
                        parentId = m.id,
                        userOrGroupId = m.new_owner_name__c,
                        rowCause = schema.mould_action_form__share.rowCause.new_mould_owner__c,
                        accessLevel = 'read'));
                }
            }
            old_holder = trigger.oldMap.get(m.id).new_holder_name__c;
            if (m.new_holder_name__c != old_holder) {
                if (old_holder != null) {
                    old_holder_list.add(m.id);
                }
                if (m.new_holder_name__c != null) {
                    new_share_list.add(new mould_action_form__share(
                        parentId = m.id,
                        userOrGroupId = m.new_holder_name__c,
                        rowCause = schema.mould_action_form__share.rowCause.new_mould_holder__c,
                        accessLevel = 'read'));
                }
            }
            old_record_owner = trigger.oldMap.get(m.id).new_record_owner__c;
            if (m.new_record_owner__c != old_record_owner) {
                if (old_record_owner != null) {
                    old_record_owner_list.add(m.id);
                }
                if (m.new_record_owner__c != null) {
                    new_share_list.add(new mould_action_form__share(
                        parentId = m.id,
                        userOrGroupId = m.new_record_owner__c,
                        rowCause = schema.mould_action_form__share.rowCause.new_record_owner__c,
                        accessLevel = 'read'));
                }
            }
            old_migration_approver = trigger.oldMap.get(m.id).migration_approver__c;
            if (m.migration_approver__c != old_migration_approver) {
                if (old_migration_approver != null) {
                    old_migration_approver_list.add(m.id);
                }
                if (m.migration_approver__c != null) {
                    new_share_list.add(new mould_action_form__share(
                        parentId = m.id,
                        userOrGroupId = m.migration_approver__c,
                        rowCause = schema.mould_action_form__share.rowCause.migration_approver__c,
                        accessLevel = 'edit'));
                }
            }           
            old_disposal_approver = trigger.oldMap.get(m.id).disposal_approver__c;
            if (m.disposal_approver__c != old_disposal_approver) {
                if (old_disposal_approver != null) {
                    old_disposal_approver_list.add(m.id);
                }
                if (m.disposal_approver__c != null) {
                    new_share_list.add(new mould_action_form__share(
                        parentId = m.id,
                        userOrGroupId = m.disposal_approver__c,
                        rowCause = schema.mould_action_form__share.rowCause.disposal_approver__c,
                        accessLevel = 'edit'));
                }
            }                       
// Recreate sharing objects for new record owners with edit access when a movement action form is submitted 
            if (m.Mould_Action_Type__c == 'Movement-Lock' && trigger.oldMap.get(m.id).Mould_Action_Type__c == 'Movement' && m.new_record_owner__c != null) {
                old_record_owner_list.add(m.id);
                new_share_list.add(new mould_action_form__share(
                    parentId = m.id,
                    userOrGroupId = m.new_record_owner__c,
                    rowCause = schema.mould_action_form__share.rowCause.new_record_owner__c,
                    accessLevel = 'edit'));             
            }   
        }
        
        if (old_owner_list.size() > 0 || old_holder_list.size() > 0 || old_record_owner_list.size() > 0 || old_migration_approver_list.size() > 0 || old_disposal_approver_list.size() > 0) {
            old_share_list = [select id from mould_action_form__share 
                where (parentId in :old_owner_list and rowCause = :schema.mould_action_form__share.rowCause.new_mould_owner__c)
                or (parentId in :old_holder_list and rowCause = :schema.mould_action_form__share.rowCause.new_mould_holder__c)
                or (parentId in :old_record_owner_list and rowCause = :schema.mould_action_form__share.rowCause.new_record_owner__c)
                or (parentId in :old_migration_approver_list and rowCause = :schema.mould_action_form__share.rowCause.migration_approver__c)
                or (parentId in :old_disposal_approver_list and rowCause = :schema.mould_action_form__share.rowCause.disposal_approver__c)];
            delete old_share_list;
        }
        if (new_share_list.size() > 0) {
            insert new_share_list;
        }
        
        list<id> submitted_list = new list<id>();
        list<id> rejected_list = new list<id>();        
        list<id> approved_list = new list<id>();
        for (Mould_Action_Form__c maf:trigger.new) {
            if (maf.Action_Status__c != trigger.oldMap.get(maf.id).Action_Status__c) {
                if (maf.Action_Status__c == 'Submitted') {
                    submitted_list.add(maf.id);
                }
                else if (maf.Action_Status__c == 'Rejected') {
                    rejected_list.add(maf.id);
                }                               
                else if (maf.Action_Status__c == 'Approved') {
                    approved_list.add(maf.id);
                }               
            }           
        }

// If a mould action form is submitted, update the related mould status to be "in progress"
        if (submitted_list.size() > 0) {
            list<mould_action__c> ma_list = [select mould__c, mould_action_form__r.recordType.developerName, mould_action_form__r.New_Record_Owner__c 
                from mould_action__c where mould_action_form__c in :submitted_list];
            set<id> mid_set = new set<id>();
            for (Mould_Action__c ma:ma_list) {
                mid_set.add(ma.mould__c);
            }
            map<id, mould__c> m_map = new map<id, mould__c>([select id from mould__c where id in :mid_set]);
            for (mould_action__c ma:ma_list) {
                if (ma.mould_action_form__r.recordType.developerName == 'Movement_Lock') {
                    m_map.get(ma.mould__c).mould_status__c = 'Movement in Transit';
                    m_map.get(ma.mould__c).Status_Updated_Date__c = date.today();
                }               
                else if (ma.mould_action_form__r.recordType.developerName == 'Migration') {
                    m_map.get(ma.mould__c).mould_status__c = 'Migration in progress';
                    m_map.get(ma.mould__c).Status_Updated_Date__c = date.today();
                }
                else if (ma.mould_action_form__r.recordType.developerName == 'Change') {
                    m_map.get(ma.mould__c).mould_status__c = 'Change in progress';
                    m_map.get(ma.mould__c).Status_Updated_Date__c = date.today();
                }               
                else if (ma.mould_action_form__r.recordType.developerName == 'Disposal') {
                    m_map.get(ma.mould__c).mould_status__c = 'Disposal in progress';
                    m_map.get(ma.mould__c).Status_Updated_Date__c = date.today();
                }               
            }
            update m_map.values();                                          
        }
        
// If a mould action form is rejected, reset the related mould status to active
        if (rejected_list.size() > 0) {
            list<mould_action__c> ma_list = [select mould__c, mould_action_form__r.recordType.name from mould_action__c where mould_action_form__c in :rejected_list];
            set<id> mid_set = new set<id>();
            for (Mould_Action__c ma:ma_list) {
                mid_set.add(ma.mould__c);
            }
            map<id, mould__c> m_map = new map<id, mould__c>([select id from mould__c where id in :mid_set]);
            for (mould_action__c ma:ma_list) {
                m_map.get(ma.mould__c).mould_status__c = 'Active';
                m_map.get(ma.mould__c).Status_Updated_Date__c = date.today();               
            }
            update m_map.values();                                          
        }

// If a mould action form is approved, 
//  update the original mould status and mould record type 
//  create new moulds and the associated mould products, if necessary
//  link the mould actions to the new moulds
        if (approved_list.size() > 0) {
            list<mould_action__c> ma_list = 
                [select mould__c, mould_action_form__r.recordType.developerName, mould_action_form__r.group_capex_number__c,
                     mould_action_form__r.New_Record_Owner__c, mould_action_form__r.New_Holder_Name__c, mould_action_form__r.New_Holder_Company__c,
                     mould_action_form__r.New_Owner_Name__c, Action_Complete_Date__c, mould_action_form__r.To_Factory__c,
                     mould_action_form__r.To_Country__c, mould_action_form__r.Owner_Group__c, mould_action_form__r.Owner_Entity__c
                from mould_action__c where mould_action_form__c in :approved_list for update];
            set<id> mid_set = new set<id>();
            for (Mould_Action__c ma:ma_list) {
                mid_set.add(ma.mould__c);
            }
            map<id, mould__c> m_map = new map<id, mould__c>();
            for (mould__c m:database.Query(buildQuery('mould__c', null) + ' where id in :mid_set for update')) {
                m_map.put(m.id, m);
            }
            map<string, id> rt_map = new map<string, id>();
            for (recordType rt:[select id, developerName from recordType where sobjectType = 'mould__c']) {
                rt_map.put(rt.developername, rt.id);
            }                       

            map<id, mould__c> new_mould_map = new map<id, mould__c>();
            set<id> mm_set = new set<id>();
            for (mould_action__c ma:ma_list) {
                if (ma.mould_action_form__r.recordType.developerName == 'Migration_Lock') {
                    m_map.get(ma.mould__c).recordTypeId = rt_map.get('Mould_Locked');                   
                    m_map.get(ma.mould__c).mould_status__c = 'Migrated';
                    m_map.get(ma.mould__c).Status_Updated_Date__c = date.today();                   
                    mould__c new_mould = m_map.get(ma.mould__c).clone(false, true);
                    new_mould.recordTypeId = rt_map.get('New_Mould');                       
                    new_mould.Model__c = null;
                    new_mould.mould_status__c = 'Inactive';                 
                    new_mould.from_mould__c = ma.mould__c;
                    if (ma.mould_action_form__r.group_capex_number__c != null) {
                        new_mould.approved_capex__c = ma.mould_action_form__r.group_capex_number__c;                        
                    }
                    if (ma.mould_action_form__r.New_Record_Owner__c != null) {
                        new_mould.ownerId = ma.mould_action_form__r.New_Record_Owner__c;                        
                    }
                    new_mould.Mould_Holder__c = ma.mould_action_form__r.New_Holder_Name__c;
                    new_mould.Mould_Owner__c = ma.mould_action_form__r.New_Owner_Name__c;
                    new_mould.Factory_Name__c = ma.mould_action_form__r.To_Factory__c;
                    new_mould.Country__c = ma.mould_action_form__r.To_Country__c;   
                    new_mould.Holder_Company__c = ma.mould_action_form__r.New_Holder_Company__c;
                    new_mould.Owner_Group__c = ma.mould_action_form__r.Owner_Group__c;
                    new_mould.Owner_Entity__c = ma.mould_action_form__r.Owner_Entity__c;                                                                                        
                    new_mould_map.put(ma.id, new_mould);                    
                    mm_set.add(ma.mould__c);
                }
                else if (ma.mould_action_form__r.recordType.developerName == 'Modification') {
                    m_map.get(ma.mould__c).recordTypeId = rt_map.get('Mould_Locked');                   
                    m_map.get(ma.mould__c).mould_status__c = 'Modified';
                    m_map.get(ma.mould__c).Status_Updated_Date__c = date.today();                   
                    mould__c new_mould = m_map.get(ma.mould__c).clone(false, true);
                    new_mould.recordTypeId = rt_map.get('Pending_Modification');                    
                    new_mould.Model__c = null;                  
                    new_mould.mould_status__c = 'Pending Modification';
                    new_mould.from_mould__c = ma.mould__c;
                    new_mould.approved_capex__c = ma.mould_action_form__r.group_capex_number__c;
                    new_mould.Expected_Mould_Completion_Date__c = ma.Action_Complete_Date__c;
                    new_mould_map.put(ma.id, new_mould);    
                    mm_set.add(ma.mould__c);
                }
                else if (ma.mould_action_form__r.recordType.developerName == 'Change') {
                    m_map.get(ma.mould__c).recordTypeId = rt_map.get('Mould_Locked');
                    m_map.get(ma.mould__c).mould_status__c = 'Changed';
                    m_map.get(ma.mould__c).Status_Updated_Date__c = date.today();                   
                    mould__c new_mould = m_map.get(ma.mould__c).clone(false, true);
                    new_mould.recordTypeId = rt_map.get('Pending_Change');
                    new_mould.Model__c = null;                  
                    new_mould.mould_status__c = 'Changed Mould pending Mould ID Approval';
                    new_mould.from_mould__c = ma.mould__c;
                    new_mould.approved_capex__c = ma.mould_action_form__r.group_capex_number__c;    
                    new_mould.Expected_Mould_Completion_Date__c = ma.Action_Complete_Date__c;                                   
                    new_mould.Mould_ID__c = null;
                    new_mould.Mould_ID_Approval__c = 'Pending for Mould ID';    
                    new_mould_map.put(ma.id, new_mould);    
                }
                else if (ma.mould_action_form__r.recordType.developerName == 'Disposal_Lock') {
                    m_map.get(ma.mould__c).recordTypeId = rt_map.get('Mould_Locked');                   
                    m_map.get(ma.mould__c).mould_status__c = 'Disposal';
                    m_map.get(ma.mould__c).Status_Updated_Date__c = date.today();                   
                }                                                                   
            }
            
            if (new_mould_map.size() > 0) {
                insert new_mould_map.values();
                for (mould_action__c ma:ma_list) {
                    if (new_mould_map.containsKey(ma.id)) {
                        ma.to_mould__c = new_mould_map.get(ma.id).id;
                    }
                }
                update ma_list;
                for (mould__c m:new_mould_map.values()) {
                    if (m_map.containsKey(m.from_mould__c)) {
                        m_map.get(m.from_mould__c).to_mould__c = m.id;
                    }
                }
            }
            update m_map.values();
            
            if (mm_set.size() > 0) {
                map<id, mould__c> mp_map = new map<id, mould__c>();
                for (mould__c m:database.query('select (' + buildQuery('mould_product__c', 'mould_products__r') + ') from mould__c where id in :mm_set')) {
                    mp_map.put(m.id, m);
                }               
                    
                list<mould_product__c> new_mp_list = new list<mould_product__c>();
                for (mould__c m:new_mould_map.values()) {
                    if (mp_map.containsKey(m.from_mould__c)) {
                        for (mould_product__c mp:mp_map.get(m.from_mould__c).mould_products__r) {
                            mould_product__c new_mp = mp.clone(false, true);
                            new_mp.mould__c = m.id;
                            new_mp_list.add(new_mp);
                        }
                    }
                }
                insert new_mp_list;
            }
        }                       
    }
}