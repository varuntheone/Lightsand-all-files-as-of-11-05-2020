public with sharing virtual class ASI_KOR_AbstractComponentController implements ASI_KOR_ComponentInterface {
	public ASI_KOR_PageInterface pageController {
		get { return this.getPageController(); }
		set { this.setPageController(value); }
	}
	public String componentKey { get { if (componentKey == null) componentKey = 'DEFAULT'; return componentKey; } set; }
	private ASI_KOR_PageInterface privatePageController;
	
	public void setPageController(ASI_KOR_PageInterface pController) {
		if (this.privatePageController == null) {
			this.privatePageController = pController;
			this.privatePageController.setComponentController(this.componentKey, this);
		}
	}
	public ASI_KOR_PageInterface getPageController() {
		return this.privatePageController;
	}

}