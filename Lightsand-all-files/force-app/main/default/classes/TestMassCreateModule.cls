@isTest
private class TestMassCreateModule {

	public static testMethod void test_main() {
        map<string, id> rt_map = new map<string, id>();
        for (recordType rt:[select id, developerName from recordType where sobjectType = 'mould_action_form__c']) {
            rt_map.put(rt.developername, rt.id);
        }

        mould_action_form__c maf = new mould_action_form__c(recordtypeId=rt_map.get('Movement')); 
        insert maf;
        mould__c m = new mould__c(name='test');
        insert m;
        
		list<mould_action__c> ma_list = new list<mould_action__c>();
		ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(ma_list);
		
		Test.startTest();
		
		// Initialize the page
		PageReference testPage = Page.MovementActionsPage;
		Map<String, String> pageParams = testPage.getParameters();
		pageParams.put('id', maf.Id);
		Test.setCurrentPageReference(testPage);
		MovementActionsController testCon = new MovementActionsController(stdSetController);
		ASI_KOR_MassCreateAndUpdateController mcauCon = new ASI_KOR_MassCreateAndUpdateController();
		ASI_KOR_SFObjSelectTableController sobjstCon = new ASI_KOR_SFObjSelectTableController();
		
		// Assign component attributes
		mcauCon.sObjTypeStr = 'Mould_Action__c';
		mcauCon.displayFieldsStr = 'Mould_Directory__c&req=T&read=A, remark__c&req=F';
		mcauCon.whereStatm = 'mould_action_form__c = \'' + maf.id + '\'';
		mcauCon.pageBlockTitleStr = 'Mould Movement Actions';
		mcauCon.successLink = '/' + maf.Id;
		mcauCon.cancelLink = '/' + maf.Id;
		mcauCon.mode = 'EDIT';
		mcauCon.showAllRT = true;
		mcauCon.isUseFirstRowForNew = true;
		mcauCon.componentKey = 'massCreateAndUpdate';
		mcauCon.pageController = testCon.thisController;
		
		sobjstCon.sObjTypeStr = 'Mould_Directory__c';
		sobjstCon.displayFieldsStr = 'mould_id__c, name, holder_company__c, factory__c, original_brand__c, engraved_logo__c, mould_type__c, mould_usability__c, mould_condition__c, cavity__c';
		sobjstCon.defWhereStatmStr = null;
		sobjstCon.orderByStr = 'Name';
		sobjstCon.numOfRowInTable = 8;
		sobjstCon.componentKey = 'selectTable';
		sobjstCon.pageController = testCon.thisController;
		
		Boolean initPageBool = mcauCon.dummyVar;
		initPageBool = sobjstCon.initDummyVar;
		
		// Start testing user actions
		
		// Change page number
		sobjstCon.nextPage();
		sobjstCon.lastPage();
		sobjstCon.prevPage();
		sobjstCon.firstPage();
		
		// Filter products
		/*
		testCon.filterIGNameOrCode = itemGroups.get(1).Name;
		testCon.filterItemGroup();
		System.assertEquals(1, sobjstCon.tableEleList.size());
		*/
		
		// Add product
		pageParams.put('PARAM_BTN_ID', 'add');
		pageParams.put('PARAM_SOBJ_ID', sobjstCon.tableEleList.get(0).sObj.Id);
		sobjstCon.triggerRowAction();
		
		// Remove product
		pageParams.put(mcauCon.PARAM_RTID, 'Mould_Action');
		pageParams.put(mcauCon.PARAM_TRID, mcauCon.theRecordTypeElementList.get(0).myRecordList.get(0).id);
		mcauCon.removeNew();
		
		// Add product
		pageParams.put('PARAM_BTN_ID', 'add');
		pageParams.put('PARAM_SOBJ_ID', sobjstCon.tableEleList.get(0).sObj.Id);
		sobjstCon.triggerRowAction();
		
		// Set values
		// mcauCon.theRecordTypeElementList.get(0).myRecordList.get(0).mySObj.put('ASI_KOR_Order_Qty__c', 2);
		
		// Save
		mcauCon.commitAll();
	
		Test.stopTest();
	}    
}