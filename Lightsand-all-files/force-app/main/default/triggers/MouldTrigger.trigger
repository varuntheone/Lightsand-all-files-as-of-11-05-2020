trigger MouldTrigger on Mould__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {

    if (trigger.isAfter) {
        if (trigger.isInsert) {
            routineAfterInsert();
        }
        else if (trigger.isUpdate) {
            routineAfterUpdate();
        }
    }
    else {
        if (trigger.isDelete) {
            routineBeforeDelete();
        }
    }

    private void routineAfterInsert() {
// Create sharing objects for mould owners and mould holders
        list<mould__share> new_share_list = new list<mould__share>();
        for (mould__c m:trigger.new) {
            if (m.mould_owner__c != null) {
                new_share_list.add(new mould__share(
                    parentId = m.id,
                    userOrGroupId = m.mould_owner__c,
                    rowCause = schema.mould__share.rowCause.mould_owner__c,
                    accessLevel = 'read'));
            }
            if (m.mould_holder__c != null) {
                new_share_list.add(new mould__share(
                    parentId = m.id,
                    userOrGroupId = m.mould_holder__c,
                    rowCause = schema.mould__share.rowCause.mould_holder__c,
                    accessLevel = 'read'));
            }
        }
                
        if (new_share_list.size() > 0) {
            insert new_share_list;
        }

// Create Mould Directory object
        list<user> u = [select id from user where profile.name = 'System Administrator' and isActive = true limit 1];
        list<Mould_Directory__c> md_list = new list<Mould_Directory__c>();
        for (mould__c m:trigger.new) {
            Mould_Directory__c md = new Mould_Directory__c();
            md.name = m.name;
            md.Mould__c = m.id;
            //30-5-2013 Jeffrey add for Mould Creation logic - start
            md.SYS_Mould_Directory_Status__c=m.Mould_Status__c;
            md.Model_txt__c=m.Model__c;
            //30-5-2013 Jeffrey add for Mould Creation logic - start
            if (u.size() > 0) {
                md.ownerId = u[0].id;
            }
            md_list.add(md);                
        }
        if (md_list.size() > 0) {
            insert md_list;             
        }
    }
    
    private void routineAfterUpdate() {
// Delete sharing objects for old mould owners and old mould holders
// Create sharing objects for new mould owners and new mould holders        
        id old_owner, old_holder;
        list<id> old_owner_list = new list<id>();
        list<id> old_holder_list = new list<id>();      
        list<mould__share> old_share_list = new list<mould__share>();       
        list<mould__share> new_share_list = new list<mould__share>();       
        for (mould__c m:trigger.new) {
            old_owner = trigger.oldMap.get(m.id).mould_owner__c;
            if (m.mould_owner__c != old_owner) {
                if (old_owner != null) {
                    old_owner_list.add(m.id);
                }
                if (m.mould_owner__c != null) {
                    new_share_list.add(new mould__share(
                        parentId = m.id,
                        userOrGroupId = m.mould_owner__c,
                        rowCause = schema.mould__share.rowCause.mould_owner__c,
                        accessLevel = 'read'));
                }
            }
            old_holder = trigger.oldMap.get(m.id).mould_holder__c;
            if (m.mould_holder__c != old_holder) {
                if (old_holder != null) {
                    old_holder_list.add(m.id);
                }
                if (m.mould_holder__c != null) {
                    new_share_list.add(new mould__share(
                        parentId = m.id,
                        userOrGroupId = m.mould_holder__c,
                        rowCause = schema.mould__share.rowCause.mould_holder__c,
                        accessLevel = 'read'));
                }
            }           
        }
        
        if (old_owner_list.size() > 0 || old_holder_list.size() > 0) {
            old_share_list = [select id from mould__share 
                where (parentId in :old_owner_list and rowCause = :schema.mould__share.rowCause.mould_owner__c)
                or (parentId in :old_holder_list and rowCause = :schema.mould__share.rowCause.mould_holder__c)];
            delete old_share_list;
        }
        if (new_share_list.size() > 0) {
            insert new_share_list;
        }
        
// Update Mould Directory objects accordingly if mould name is changed
        set<id> mid_set = new set<id>();        
        for (mould__c m:trigger.new) {
            if (m.name != trigger.oldMap.get(m.id).name) {
                mid_set.add(m.id);
            }
            // 30-5-2013 Jeffrey add to update mould directory status and Model - start
            if (m.Mould_Status__c != trigger.oldMap.get(m.id).Mould_Status__c || m.Model__c!= trigger.oldMap.get(m.id).Model__c) {
                mid_set.add(m.id);
            }
            // 30-5-2013 Jeffrey add to update mould directory status and Model - end
        }

        
        if (mid_set.size() > 0) {
            list<Mould_Directory__c> md_list = [select Mould__c from Mould_Directory__c where Mould__c in :mid_set for update];                 
            for (Mould_Directory__c md:md_list) {
                md.name = trigger.newMap.get(md.mould__c).name;
                // 30-5-2013 Jeffrey add to update mould directory status - start
                md.SYS_Mould_Directory_Status__c = trigger.newMap.get(md.mould__c).Mould_Status__c;
                // 30-5-2013 Jeffrey add to update mould directory status - end
            }
            update md_list;
        }       
    }
    
    private void routineBeforeDelete() {
// Delete the corresponding mould directory object      
        set<id> xmid_set = new set<id>();
        for (mould__c m:trigger.old) {
            xmid_set.add(m.id);
        }
        list<Mould_Directory__c> xmd_list = [select id from Mould_Directory__c where Mould__c in :xmid_set for update];     
        delete xmd_list;                    
    }
}