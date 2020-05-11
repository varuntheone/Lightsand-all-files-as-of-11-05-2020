@isTest
private class TestMouldMgmt {
    
    static testMethod void testMouldActionFormTrigger() {
        map<string, id> rt_map = new map<string, id>();
        for (recordType rt:[select id, developerName from recordType where sobjectType = 'mould_action_form__c']) {
            rt_map.put(rt.developername, rt.id);
        }
    
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id, Mould_Disposal_Approver__c=true,
            TimeZoneSidKey='America/Los_Angeles', UserName='tester@mainetti.com');
        insert u;    
        User u1 = new User(Alias = 'standt', Email='standarduser@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id, Mould_Disposal_Approver__c=true,
            TimeZoneSidKey='America/Los_Angeles', UserName='tester1@mainetti.com');
        insert u1; 
           
        mould_action_form__c maf = new mould_action_form__c(recordtypeId=rt_map.get('Movement'),
            new_owner_name__c = u.id, new_holder_name__c=u.id, new_record_owner__c=u.id, Migration_Approver__c=u.id, Disposal_Approver__c=u.id); 
        insert maf;
        
        Mould__c m = new mould__c(name='test');
        insert m;
        Mould_Product__c mp = new Mould_Product__c(mould__c = m.id);
        insert mp;
        mould_directory__c md = [select id from mould_directory__c where mould__c = :m.id];
        Mould_Action__c ma = new Mould_Action__c(Mould_Action_Form__c = maf.id, mould_directory__c = md.id); 
        insert ma;
        
        maf.new_owner_name__c=u1.id;
        maf.new_holder_name__c=u1.id;
        maf.new_record_owner__c=u1.id;
        maf.Migration_Approver__c=u1.id;
        maf.Disposal_Approver__c=u1.id;                
        update maf;
        id mid;
        mid = [select mould__c from mould_action__c where mould_action_form__c = :maf.id limit 1][0].mould__c;
        system.debug('mid: ' + mid);
        
        maf.recordtypeId = rt_map.get('Movement_Lock');
        maf.Action_Status__c = 'Submitted'; 
        update maf; 
        maf.Action_Status__c = 'Rejected'; 
        update maf;
        maf.Action_Status__c = 'Submitted'; 
        update maf; 
        maf.Action_Status__c = 'Approved'; 
        update maf;        
        
        maf.RecordTypeId = rt_map.get('Migration');
        maf.Action_Status__c = 'Submitted';         
        update maf;
        maf.RecordTypeId = rt_map.get('Migration_Lock');        
        maf.Action_Status__c = 'Approved'; 
        update maf; 
         
        maf.RecordTypeId = rt_map.get('Change');
        maf.Action_Status__c = 'Submitted';         
        update maf;
        maf.Action_Status__c = 'Approved'; 
        update maf;  
         
        maf.RecordTypeId = rt_map.get('Modification');
        maf.Action_Status__c = 'Submitted';         
        update maf;
        maf.Action_Status__c = 'Approved'; 
        update maf;  
                
        maf.RecordTypeId = rt_map.get('Disposal');
        maf.Action_Status__c = 'Submitted';         
        update maf;
        maf.RecordTypeId = rt_map.get('Disposal_Lock');        
        maf.Action_Status__c = 'Approved'; 
        update maf; 

    }
    
    // Jeffrey add for Mould ID test - start
    static testMethod void testMouldID() 
    {
        List<Sys_Capex_Auto_Num__c> CPX_Num_List = new List<Sys_Capex_Auto_Num__c>();
        
        Sys_Capex_Auto_Num__c CPX_Num = new Sys_Capex_Auto_Num__c();
        
        CPX_Num = new Sys_Capex_Auto_Num__c();
        CPX_Num.Code__c='Mould ID Auto Num';
        CPX_Num.Next_Num__c='001';
        CPX_Num.Year__c='2013';
        CPX_Num_List.add(CPX_Num);
        
        insert CPX_Num_List;
        
        map<string, id> rt_map = new map<string, id>();
        for (recordType rt:[select id, developerName from recordType where sobjectType = 'mould_action_form__c']) 
        {
            rt_map.put(rt.developername, rt.id);
        }
    
        Mould__c m = new mould__c(name='test', mould_status__c='Active');
        insert m;
        
        m.Capex_Verification_Status__c='Approved';
        m.Mould_ID_Approval__c='Approved';
        update m;
        
    }
    // Jeffrey add for Mould ID test - end
    
    // Jeffrey add for Model test - start
    static testMethod void testModel() 
    {
        Mould__c m = new mould__c(name='test');
        insert m;
        
        Product__c p = new  Product__c(name='test Product');
        insert p;
        
        Product__c p2 = new Product__c(name='test Product222');
        insert p2;
        
        Product__c p3 = new Product__c(name='test Product333');
        insert p3;
        
        Mould_Product__c mp1 = new Mould_Product__c(mould__c = m.id, Mould_Products__c=p.id);
        insert mp1;
        
        Mould_Product__c mp2 = new Mould_Product__c(mould__c = m.id, Mould_Products__c=p2.id);
        insert mp2;
        
        mp2.Mould_Products__c=p3.id;
        update mp2;
        
        
        
        map<string, id> rt_map = new map<string, id>();
        for (recordType rt:[select id, developerName from recordType where sobjectType = 'mould_action_form__c']) 
        {
            rt_map.put(rt.developername, rt.id);
        }
    
        
        
        m.Capex_Verification_Status__c='Approved';
        m.Mould_ID_Approval__c='Approved';
        update m;
        
    }
    
    
    static testMethod void testConfirmReceivedController() { 
        map<string, id> rt_map = new map<string, id>();
        for (recordType rt:[select id, developerName from recordType where sobjectType = 'mould_action_form__c']) {
            rt_map.put(rt.developername, rt.id);
        }
            
        mould_action_form__c maf = new mould_action_form__c(recordtypeId=rt_map.get('Movement_Lock'), New_Record_Owner__c=userInfo.getUserId()); 
        insert maf;
        Mould__c m = new mould__c(name='test');
        insert m;
        Mould_Product__c mp = new Mould_Product__c(mould__c = m.id);
        insert mp;
        mould_directory__c md = [select id from mould_directory__c where mould__c = :m.id];
        Mould_Action__c ma = new Mould_Action__c(Mould_Action_Form__c = maf.id, mould_directory__c = md.id); 
        insert ma;   
        list<mould_action__c> ma_list = new list<mould_action__c>{ma};
        
        apexpages.standardSetController sc = new apexpages.standardSetController(ma_list);
        sc.setSelected(ma_list);    
        ConfirmReceivedController cx = new ConfirmReceivedController(sc);   
        cx.confirmReceived();           
    } 
    
    
    
    
    static testMethod void testDisposalActionsController() { 
        map<string, id> rt_map = new map<string, id>();
        for (recordType rt:[select id, developerName from recordType where sobjectType = 'mould_action_form__c']) {
            rt_map.put(rt.developername, rt.id);
        }
            
        mould_action_form__c maf = new mould_action_form__c(recordtypeId=rt_map.get('Disposal'), 
            from_company__c ='test', from_factory__c='test'); 
        insert maf;
        Mould__c m = new mould__c(name='test', mould_status__c='Active');
        insert m;
        Mould_Product__c mp = new Mould_Product__c(mould__c = m.id);
        insert mp;
        mould_directory__c md = [select id from mould_directory__c where mould__c = :m.id];
        Mould_Action__c ma = new Mould_Action__c(Mould_Action_Form__c = maf.id, mould_directory__c = md.id); 
        insert ma;   
        list<mould_action__c> ma_list = new list<mould_action__c>{ma};  

        pageReference p = page.DisposalActionsPage;
        test.setCurrentPage(p);  
        apexpages.currentPage().getParameters().put('id', maf.id);   
        
        apexpages.standardSetController sc = new apexpages.standardSetController(ma_list);
        sc.setSelected(ma_list);    
        DisposalActionsController cx = new DisposalActionsController(sc);  
        cx.mould_filter.name = 'test';
        cx.mould_filter.model__c = 'test';
        cx.mould_filter.factory_name__c = 'test';
        cx.filterMoulds();                                          
    }      
    
    static testMethod void testMigrationActionsController() { 
        map<string, id> rt_map = new map<string, id>();
        for (recordType rt:[select id, developerName from recordType where sobjectType = 'mould_action_form__c']) {
            rt_map.put(rt.developername, rt.id);
        }
            
        mould_action_form__c maf = new mould_action_form__c(recordtypeId=rt_map.get('Migration'), 
            from_company__c ='test', from_factory__c='test'); 
        insert maf;
        Mould__c m = new mould__c(name='test', mould_status__c='Active');
        insert m;
        Mould_Product__c mp = new Mould_Product__c(mould__c = m.id);
        insert mp;
        mould_directory__c md = [select id from mould_directory__c where mould__c = :m.id];
        Mould_Action__c ma = new Mould_Action__c(Mould_Action_Form__c = maf.id, mould_directory__c = md.id); 
        insert ma;   
        list<mould_action__c> ma_list = new list<mould_action__c>{ma};  

        pageReference p = page.MigrationActionsPage;
        test.setCurrentPage(p);  
        apexpages.currentPage().getParameters().put('id', maf.id);   
        
        apexpages.standardSetController sc = new apexpages.standardSetController(ma_list);
        sc.setSelected(ma_list);    
        MigrationActionsController cx = new MigrationActionsController(sc);  
        cx.mould_filter.name = 'test';
        cx.mould_filter.model__c = 'test';
        cx.mould_filter.factory_name__c = 'test';
        cx.filterMoulds();                                          
    }          
    
    static testMethod void testMovementActionsController() { 
        map<string, id> rt_map = new map<string, id>();
        for (recordType rt:[select id, developerName from recordType where sobjectType = 'mould_action_form__c']) {
            rt_map.put(rt.developername, rt.id);
        }
            
        mould_action_form__c maf = new mould_action_form__c(recordtypeId=rt_map.get('Movement'), 
            from_company__c ='test', from_factory__c='test'); 
        insert maf;
        Mould__c m = new mould__c(name='test', mould_status__c='Active');
        insert m;
        Mould_Product__c mp = new Mould_Product__c(mould__c = m.id);
        insert mp;
        mould_directory__c md = [select id from mould_directory__c where mould__c = :m.id];
        Mould_Action__c ma = new Mould_Action__c(Mould_Action_Form__c = maf.id, mould_directory__c = md.id); 
        insert ma;   
        list<mould_action__c> ma_list = new list<mould_action__c>{ma};  

        pageReference p = page.MovementActionsPage;
        test.setCurrentPage(p);  
        apexpages.currentPage().getParameters().put('id', maf.id);   
        
        apexpages.standardSetController sc = new apexpages.standardSetController(ma_list);
        sc.setSelected(ma_list);    
        MovementActionsController cx = new MovementActionsController(sc);  
        cx.mould_filter.name = 'test';
        cx.mould_filter.model__c = 'test';
        cx.mould_filter.factory_name__c = 'test';
        cx.filterMoulds();                                          
    }
    static testMethod void testMouldActionFormEditController() { 
        map<string, id> rt_map = new map<string, id>();
        for (recordType rt:[select id, developerName from recordType where sobjectType = 'mould_action_form__c']) {
            rt_map.put(rt.developername, rt.id);
        }
            
        mould_action_form__c maf = new mould_action_form__c(recordtypeId=rt_map.get('Change'), 
            from_company__c ='test', from_factory__c='test'); 
        insert maf;
        Mould__c m = new mould__c(name='test', mould_status__c='Active', Holder_Company__c='test', Factory_Name__c='test');
        insert m;
        Mould_Product__c mp = new Mould_Product__c(mould__c = m.id);
        insert mp;
        mould_directory__c md = [select id from mould_directory__c where mould__c = :m.id];
        Mould_Action__c ma = new Mould_Action__c(Mould_Action_Form__c = maf.id, mould_directory__c = md.id); 
        insert ma;   

        apexpages.standardController sc = new apexpages.standardController(maf);
        MouldActionFormEditController cx = new MouldActionFormEditController(sc);
        cx.save();
        cx.saveNew();
    }

    static testMethod void testMouldActionFormRedirect() {
        map<string, id> rt_map = new map<string, id>();
        for (recordType rt:[select id, developerName from recordType where sobjectType = 'mould_action_form__c']) {
            rt_map.put(rt.developername, rt.id);
        }
                    
        pageReference p = page.MouldActionFormRedirect;
        test.setCurrentPage(p);  
        apexpages.currentPage().getParameters().put('RecordType', rt_map.get('Change'));   

        mould_action_form__c maf = new mould_action_form__c();        
        apexpages.standardController sc = new apexpages.standardController(maf);
        MouldActionFormRedirect cx = new MouldActionFormRedirect(sc); 
        cx.redirect();      
    }                     
}