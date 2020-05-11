public with sharing class DisposalActionsController implements ASI_KOR_SFObjSelectTableAbstract, ASI_KOR_MassCreateAndUpdateAbstract {
	public string mouldActionFormId {get; set;}
	public mould__c mould_filter {get; set;}
	public string init_search {get; private set;}
		
	public DisposalActionsController(ApexPages.StandardSetController stdSetController) {
		this.componentControllerMap = new Map<String, ASI_KOR_ComponentInterface>();
		mould_filter = new mould__c();
		mouldActionFormId = apexpages.currentPage().getParameters().get('id');
		mould_action_form__c ma_form = [select from_company__c, from_factory__c from mould_action_form__c where id = :mouldActionFormId];		
		init_search = 'mould_status__c = \'Active\'';
		if (ma_form.from_company__c != null) {
			init_search += ' and holder_company__c = \'' + ma_form.from_company__c + '\'';
		}
		if (ma_form.from_factory__c != null) {
			init_search += ' and Factory__c = \'' + ma_form.from_factory__c + '\'';			
		}				
		for (mould_action__c ma:[select Mould_Directory__c from mould_action__c where mould_action_form__c = :mouldActionFormId]) {
			init_search += ' and id != \'' + ma.Mould_Directory__c + '\'';
		}
	}
	
	public void FilterMoulds() {
		string whereStatm = init_search;
		if (mould_filter.mould_id__c != null && mould_filter.mould_id__c.trim() != '') {
			whereStatm += 'and mould_id__c = \'' + mould_filter.mould_id__c.trim() + '\'';
		}
		else {
			if (mould_filter.name != null && mould_filter.name.trim() != '') {
				whereStatm += 'and name like \'%' + mould_filter.name.trim() + '%\'';
			}	
			if (mould_filter.model__c != null && mould_filter.model__c.trim() != '') {
				whereStatm += 'and model__c like \'%' + mould_filter.model__c.trim() + '%\'';
			}	
			if (mould_filter.factory_name__c != null && mould_filter.factory_name__c.trim() != '') {
				whereStatm += 'and Factory__c like \'%' + mould_filter.factory_name__c.trim() + '%\'';
			}	
		}
		ASI_KOR_SFObjSelectTableController sobjstController = (ASI_KOR_SFObjSelectTableController)this.getComponentController('selectTable');
		if (sobjstController != null) {
			sobjstController.setDataFilter(whereStatm);
			sobjstController.reloadData();
		}			
	}
	
	/**
	 * Methods to implement the ASI_KOR_SFObjSelectTableAbstract
	 */
	
	public List<ASI_KOR_SFObjSelectTableController.SFObjSelectTableActionBtn> sobjst_initActionButtonList() {
		return null;
	}
	
	public Map<ID, Map<String, Integer>> sobjst_initActionButtonStageMap() {
		return null;
	}
	
	public void sobjst_triggerActionForSObject(ASI_KOR_SFObjSelectTableController controller, String actionKey, sObject sObj) {
		if (actionKey == 'add') {
			ASI_KOR_MassCreateAndUpdateController mcauC = (ASI_KOR_MassCreateAndUpdateController)this.getComponentController('massCreateAndUpdate');
			mould_action__c mould_action = new mould_action__c(
				Mould_Directory__c = sObj.id, 
				mould_action_form__c = mouldActionFormId); 
			// Use ASI_KOR_MassCreateAndUpdateController.RTDEVNAME_MASTER if you have only one record type
			// Use Record Type developer name if you have more than 1 record type
			mcauC.addNewRowByInfo('Mould_Action', mould_action);
		}
	}
	
	/**
	 * Methods to implement the ASI_KOR_MassCreateAndUpdateAbstract
	 */
	
	public List<ASI_KOR_MassCreateAndUpdateController.PageBlockActionBtn> mcau_initPageBlockActionButtonList() {
		return null;
	}
	
	public PageReference mcau_triggerPageBlockAction(ASI_KOR_MassCreateAndUpdateController controller, String actionKey) {
		return null;
	}
	
	public void mcau_triggerActionForSObject(ASI_KOR_MassCreateAndUpdateController controller, String actionKey, sObject sObj) {
		mould_action__c mould_action = (mould_action__c)sObj;
		if (mould_action != null && mould_action.mould_directory__c != null && actionKey == ASI_KOR_MassCreateAndUpdateController.ACTION_REMOVE_NEW) {
			ASI_KOR_SFObjSelectTableController selectTableC = (ASI_KOR_SFObjSelectTableController)this.getComponentController('selectTable');
			// Revert the "add" button to "0" (0 = Add, 1 = Added) by mould record id (detail.MouldLookup__c)
			selectTableC.setBtnStageBySObjId(mould_action.mould_directory__c, 'add', 0);
		}
	}
	
	/*
	 * Methods and variables that extend the ASI_KOR_PageInterface
	 */
	
	private static String DEF_CC_KEY = 'DEFAULT';
	private Map<String, ASI_KOR_ComponentInterface> componentControllerMap;
	public DisposalActionsController thisController { get {return this;} set; }
	public void setComponentController(ASI_KOR_ComponentInterface cController) {
		this.componentControllerMap.put(DEF_CC_KEY, cController);
	}
	public void setComponentController(String key, ASI_KOR_ComponentInterface cController) {
		this.componentControllerMap.put(key, cController);
	}
	public ASI_KOR_ComponentInterface getComponentController() {
		return this.componentControllerMap.get(DEF_CC_KEY);
	}
	public ASI_KOR_ComponentInterface getComponentController(String key) {
		return this.componentControllerMap.get(key);
	}
	
}