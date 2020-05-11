/*********************************************************************************
 * 
 * Description: Controller for displying Manage All Placement Orders and Manage All Replacement Orders.
 *
 * Version History
 * Date              Developer              Comments
 * ---------------  --------------------  --------------------------------------------------------------------------------
 * 2015-11-03        Neha Sonawane          Created   
**/

public with sharing class RTS_MangeAllPlacementDetailsController implements ASI_KOR_SFObjSelectTableAbstract, ASI_KOR_MassCreateAndUpdateAbstract {

    public static final String NONE = '-- None --';
    public static final String NA = 'N/A';

  public string mouldActionFormId {get; set;}
  public RTS_Product_Inventory__c mould_filter {get; set;}
  public boolean available {get;set;}
  public string modelName {get;set;}
  public string description1 {get;set;}
  public string description2 {get;set;}
  public string init_search {get; private set;}
  public boolean isOriginalPlacement{get;set;}
  public String selectedColor {get; set;}
  public String selectedLogo {get; set;}
  RTS_Placement__c rts_placementObj ;
  RTS_Placement__c rtsPlacement;
    public List<SelectOption> colorOptions {
        get {

            colorOptions = new List<SelectOption>{
                new SelectOption('', NONE)
            };
            Schema.DescribeFieldResult fieldResult = RTS_Product_Inventory__c.Color__c.getDescribe();
            List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();

            for(Schema.PicklistEntry entryIterator : picklistEntries)
            {
                colorOptions.add(new SelectOption(entryIterator.getLabel(), entryIterator.getValue()));
            }

            return colorOptions;
        }
      set;
    }

    public List<SelectOption> logoOptions {
        get {

            logoOptions = new List<SelectOption>{
                new SelectOption('', NONE),
                new SelectOption(NA, NA)
            };
            Schema.DescribeFieldResult fieldResult = RTS_Product_Inventory__c.Logo__c.getDescribe();
            List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();

            for(Schema.PicklistEntry entryIterator : picklistEntries)
            {
                logoOptions.add(new SelectOption(entryIterator.getLabel(), entryIterator.getValue()));
            }

            return logoOptions;
        }
      set;
    }

  public RTS_MangeAllPlacementDetailsController(ApexPages.StandardSetController stdSetController) {
    this.componentControllerMap = new Map<String, ASI_KOR_ComponentInterface>();
    mould_filter = new RTS_Product_Inventory__c();
    init_search = '';
    isOriginalPlacement = false;
    
           
    String rtId = Schema.getGlobalDescribe().get('RTS_Placement__c').getDescribe().getRecordTypeInfosByName().get('Original Placement Order').getRecordTypeId();
    mouldActionFormId = apexpages.currentPage().getParameters().get('id');
    
    rts_placementObj = [select Id,RecordTypeId,Inventory_Type__c,Expected_Ship_Date__c, Order_To_Company__c from RTS_Placement__c where id = :mouldActionFormId limit 1];    
    system.debug('rts_placementObj *******'+rts_placementObj );
    init_search = 'Model__r.Status__c = \'Active\'';
    for (RTS_Placement_Detail__c ma: [select RTS_Product_ID__c 
                                      from RTS_Placement_Detail__c 
                                      where RTS_Placement__c = :mouldActionFormId]) {
       init_search += ' and Id != \'' + ma.RTS_Product_ID__c + '\'';
    }
    init_search += ' and Inventory_Type__c = \'' + rts_placementObj.Inventory_Type__c + '\'' ;
    if(rts_placementObj.Order_To_Company__c != NULL) {
        init_search += ' and RTS_Partner__c = \'' + rts_placementObj.Order_To_Company__c + '\'';
    }
    System.debug('------ rtId ------ : ' + rtId);
    if(!String.isBlank(rtId) && rts_placementObj!=NULL && rts_placementObj.RecordTypeId.equals(rtId))
        isOriginalPlacement = true;
    
  }
  public void FilterMoulds() {
    string whereStatm = init_search;
    if (!(String.isBlank(modelName))) {
      whereStatm += ' and Model__r.Name LIKE \'%' + modelName + '%\'';
      /*whereStatm += ' or Description1__c LIKE \'%' + modelName + '%\'';
      whereStatm += ' or Description2__c LIKE \'%' + modelName + '%\')';*/
    }
    if(!(String.isBlank(description1))) {
      whereStatm += ' and Description1__c LIKE \'%' + description1 + '%\'';
    }
    if(!(String.isBlank(description2))) {
      whereStatm += ' and Description2__c LIKE \'%' + description2 + '%\'';
    }
    if(!(String.isBlank(selectedLogo))) {
      whereStatm += ' and Logo__c = \'' + selectedLogo + '\'';
    }
    if(!(String.isBlank(selectedColor))) {
      whereStatm += ' and Color__c = \'' + selectedColor + '\'';
    } 
    /*if(available) {
        whereStatm += ' and Available_Stock_Balance__c >= 0';
    }*/
    
    System.debug(' ---- whereStatm ---- : ' + whereStatm);
  
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
        List<RTS_Product_Inventory__c> sObjList = [SELECT Id,
                                                          Model__r.Mainetti_Model__c,
                                                          Logo__c,
                                                          Color__c
                                                     FROM RTS_Product_Inventory__c
                                                    WHERE Id = :sObj.Id];
        ASI_KOR_MassCreateAndUpdateController mcauC = (ASI_KOR_MassCreateAndUpdateController)this.getComponentController('massCreateAndUpdate');
        RTS_Placement_Detail__c rts_placementDetail = new RTS_Placement_Detail__c(
        RTS_Product_ID__c  = sObj.id, 
        RTS_Placement__c  = mouldActionFormId,
        Sys_Logo__c = sObjList[0].Logo__c,
        Sys_Color__c = sObjList[0].Color__c,
        Sys_Model__c = sObjList[0].Model__r.Mainetti_Model__c,
        Expected_Ship_Date__c = rts_placementObj.Expected_Ship_Date__c);
        // Use ASI_KOR_MassCreateAndUpdateController.RTDEVNAME_MASTER if you have only one record type
        // Use Record Type developer name if you have more than 1 record type
        mcauC.addNewRowByInfo('RTS_Placement_Detail', rts_placementDetail);
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
    RTS_Placement_Detail__c mould_action = (RTS_Placement_Detail__c)sObj;
    if (mould_action != null && mould_action.RTS_Product_ID__c != null && actionKey == ASI_KOR_MassCreateAndUpdateController.ACTION_REMOVE_NEW) {
      ASI_KOR_SFObjSelectTableController selectTableC = (ASI_KOR_SFObjSelectTableController)this.getComponentController('selectTable');
      // Revert the "add" button to "0" (0 = Add, 1 = Added) by mould record id (detail.MouldLookup__c)
      selectTableC.setBtnStageBySObjId(mould_action.RTS_Product_ID__c, 'add', 0);
    }
  }
  
  /*
   * Methods and variables that extend the ASI_KOR_PageInterface
   */
  
  private static String DEF_CC_KEY = 'DEFAULT';
  private Map<String, ASI_KOR_ComponentInterface> componentControllerMap;
  public RTS_MangeAllPlacementDetailsController thisController { get {return this;} set; }
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