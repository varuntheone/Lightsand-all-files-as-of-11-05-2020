public interface ASI_KOR_SFObjSelectTableAbstract extends ASI_KOR_PageInterface {
	
	List<ASI_KOR_SFObjSelectTableController.SFObjSelectTableActionBtn> sobjst_initActionButtonList();
	Map<ID, Map<String, Integer>> sobjst_initActionButtonStageMap();
	void sobjst_triggerActionForSObject(ASI_KOR_SFObjSelectTableController controller, String actionKey, sObject sObj);
}