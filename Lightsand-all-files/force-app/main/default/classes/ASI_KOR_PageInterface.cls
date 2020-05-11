public virtual interface ASI_KOR_PageInterface {

	void setComponentController(ASI_KOR_ComponentInterface cController);
	void setComponentController(String key, ASI_KOR_ComponentInterface cController);
	ASI_KOR_ComponentInterface getComponentController();
	ASI_KOR_ComponentInterface getComponentController(String key);
}