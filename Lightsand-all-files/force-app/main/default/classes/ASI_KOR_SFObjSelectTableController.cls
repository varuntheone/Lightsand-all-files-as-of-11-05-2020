public with sharing class ASI_KOR_SFObjSelectTableController extends ASI_KOR_AbstractComponentController {
	
	private final static Integer BTN_STAGE_DEF_INDEX = 0;
	
	// VF Component Attributes
	public String sObjTypeStr { get; set; }
	public String displayFieldsStr { get; set; }
	public String defWhereStatmStr { get; set; }
	public String whereStatmStr { get; set; }
	public Integer numOfRowInTable { get; set; }
	public String pageBlockTitleStr { get {if (pageBlockTitleStr == null) return sObjLabel; return pageBlockTitleStr;} set; }
	public String defOrderByStr { get; set; }
	public String orderByStr { get; set; }
	
	// Variables used by VF Component
	public List<SFObjSelectTableElement> tableEleList { get; private set; }
	public String sObjLabel { get { if (sObjLabel == null) {sObjLabel = sObjType.getDescribe().getLabel();} return sObjLabel; } private set; }
	public List<SFObjSelectTableDisplayField> displayFieldList { get; private set; }
	public List<SFObjSelectTableActionBtn> actionBtnList { get; private set; }
	public Integer currentPageNum { get; protected set { currentPageNum = value; newPageNum = String.valueOf(value); } }
	public String newPageNum { get; set; }
	public Integer maxPageNum { get { return maxNumOfPage(); } private set; }
	public Boolean initDummyVar { get { if (initDummyVar != true) initDummyVar = init(); return initDummyVar; } set; }
	
	private Map<String, Integer> defBtnStage; // Default button stage
	protected Map<ID, Map<String, Integer>> cachedBtnStageMap;
	protected Schema.SObjectType sObjType;
	protected List<String> queryFieldList;
	protected Integer totalNumOfRecord;

	public ASI_KOR_SFObjSelectTableController() {
		this.actionBtnList = new SFObjSelectTableActionBtn[] {
			new SFObjSelectTableActionBtn('add', new String[] {'Add', 'Added'}, new Boolean[] {false, true})
		};
		this.defBtnStage = new Map<String, Integer>{'add' => BTN_STAGE_DEF_INDEX};
		this.sObjType = null;
		this.whereStatmStr = '';
		this.orderByStr = '';
		this.tableEleList = new List<SFObjSelectTableElement>();
		this.numOfRowInTable = 25;
		this.currentPageNum = 1;
		this.totalNumOfRecord = 0;
		this.cachedBtnStageMap = new Map<ID, Map<String, Integer>>();
	}
	
	public Boolean init() {
		this.sObjType = Schema.getGlobalDescribe().get(sObjTypeStr);
		this.setFields(displayFieldsStr);
		
		// Initialize action buttons
		List<SFObjSelectTableActionBtn> tempActionBtnList = null;
		if (pageController != null)
			tempActionBtnList = ((ASI_KOR_SFObjSelectTableAbstract)pageController).sobjst_initActionButtonList();
		if (tempActionBtnList != null) {
			this.actionBtnList = tempActionBtnList;
			this.defBtnStage.clear();
			for (SFObjSelectTableActionBtn tempActionBtn : this.actionBtnList) {
				this.defBtnStage.put(tempActionBtn.id, BTN_STAGE_DEF_INDEX);
			}
		}
		// Initialize action button stages
		Map<ID, Map<String, Integer>> tempBtnStageMap = null;
		if (pageController != null)
			tempBtnStageMap = ((ASI_KOR_SFObjSelectTableAbstract)pageController).sobjst_initActionButtonStageMap();
		if (tempBtnStageMap != null)
			this.cachedBtnStageMap = tempBtnStageMap;
		
		this.whereStatmStr = this.defWhereStatmStr;
		this.orderByStr = this.defOrderByStr;
		
		reloadData();
		return true;
	}
	
	public void reloadData() {
		String countQueryStr = String.format('SELECT {0} FROM {1}{2}', new String[] {
			'COUNT()'
			, sObjTypeStr
			, (whereStatmStr != null && whereStatmStr.trim().length() > 0) ? ' WHERE ' + whereStatmStr : ''
		});
		Integer limitInt = numOfRowInTable;
		Integer offsetInt = (currentPageNum - 1) * numOfRowInTable;
		String queryStrFormat = 'SELECT {0} FROM {1}';
		if (whereStatmStr != null && whereStatmStr.trim().length() > 0) queryStrFormat += ' WHERE ({2})';
		if (orderByStr != null && orderByStr.trim().length() > 0) queryStrFormat += ' ORDER BY {3}';
		queryStrFormat += ' LIMIT {4} OFFSET {5}';
		String queryStr = String.format(queryStrFormat, new String[] {
			strListToStr(queryFieldList)
			, sObjTypeStr
			, whereStatmStr
			, orderByStr
			, ':limitInt'
			, ':offsetInt'
		});
		system.debug('DDDDDDDDDDD'+countQueryStr);
		// TODO: Handle exception
		this.totalNumOfRecord = database.countQuery(countQueryStr);
		List<sObject> sObjList = database.query(queryStr);
		for (SFObjSelectTableElement tableEle : this.tableEleList) this.cachedBtnStageMap.put(tableEle.sObj.Id, tableEle.btnStage);
		this.tableEleList = new List<SFObjSelectTableElement>();
		for (sObject sObj : sObjList) {
			Map<String, Integer> initBtnStage = this.cachedBtnStageMap.get(sObj.Id);
			SFObjSelectTableElement tableEle = new SFObjSelectTableElement(initBtnStage == null ? this.defBtnStage.clone() : initBtnStage);
			tableEle.sObj = sObj;
			tableEleList.add(tableEle);
		}
	}
	
	public void setDataFilter(String whereStatm) {
		this.whereStatmStr = whereStatm;
		this.orderByStr = 'Name';
		this.currentPageNum = 1;
	}
	
	public void setDataFilter(String whereStatm, String orderBy) {
		this.whereStatmStr = whereStatm;
		this.orderByStr = orderBy;
		this.currentPageNum = 1;
	}
	
	public void setBtnStageBySObjId(ID sObjId, Map<String, Integer> btnKeyToStageMap) {
		SFObjSelectTableElement tEle = searchTableElementById(sObjId);
		tEle.btnStage = btnKeyToStageMap.clone();
	}
	public void setBtnStageBySObjId(ID sObjId, String btnKey, Integer stage) {
		SFObjSelectTableElement tEle = searchTableElementById(sObjId);
		if (tEle != null)
			tEle.btnStage.put(btnKey, stage);
	}
	public void setBtnStagesForAll(Map<String, Integer> btnKeyToStageMap) {
		List<SFObjSelectTableElement> tEleList = this.tableEleList;
		for (SFObjSelectTableElement tEle : tEleList) {
			tEle.btnStage = btnKeyToStageMap.clone();
		}
	}
	
	/**
	 * Methods used in page
	 */
	
	public void triggerRowAction() {
		String btnId = ApexPages.currentPage().getParameters().get('PARAM_BTN_ID');
		String objId = ApexPages.currentPage().getParameters().get('PARAM_SOBJ_ID');
		if (btnId == null) {
			System.debug('Empty value of button Id');
			return;
		} else if (objId == null) {
			System.debug('Empty value of selected object Id');
			return;
		}
		SFObjSelectTableElement tEle = searchTableElementById(objId);
		tEle.btnStage.put(btnId, 1);
		if (pageController != null) ((ASI_KOR_SFObjSelectTableAbstract)pageController).sobjst_triggerActionForSObject(this, btnId, tEle.sObj);
	}
	
	public void changeBtnStage(String sObjId, String btnId, Integer stage) {
		SFObjSelectTableElement tEle = searchTableElementById(sObjId);
		tEle.btnStage.put(btnId, stage);
	}
	
	public void firstPage() { implChangePage(1); }
	public void lastPage() { implChangePage(this.maxNumOfPage());}
	public void prevPage() { implChangePage(this.currentPageNum - 1); }
	public void nextPage() { implChangePage(this.currentPageNum + 1); }
	public void changePage() {
		String changeToPageStr = newPageNum;
		Integer changeToPage = 1;
		if (changeToPageStr != null) {
			try {
				changeToPage = Integer.valueOf(changeToPageStr);
			} catch (TypeException te) {
				changeToPage = 1;
			}
		}
		implChangePage(changeToPage);
	}
	public void implChangePage(Integer pageNum) {
		Integer maxPNum = this.maxNumOfPage();
		if (pageNum <= 0) this.currentPageNum = 1;
		else if (pageNum > maxPNum) this.currentPageNum = maxPNum;
		else this.currentPageNum = pageNum;
		this.reloadData();
	}
	private Integer maxNumOfPage() {
		if (this.totalNumOfRecord == 0 || this.numOfRowInTable == 0)
			return 1;
		return ((this.totalNumOfRecord - 1) / this.numOfRowInTable) + 1;
	}
	
	private void setFields(String fieldsStr) {
		List<String> displayFieldNameList = strToStrList(fieldsStr);
		this.displayFieldList = new List<SFObjSelectTableDisplayField>();
		Map<String, Schema.SObjectField> fieldMap = this.sObjType.getDescribe().fields.getMap();
		for (String fieldName : displayFieldNameList) {
			SFObjSelectTableDisplayField df = new SFObjSelectTableDisplayField();
			Schema.SObjectField sObjField = fieldMap.get(fieldName);
			if (sObjField == null) {
				System.debug('Unknown field: ' + fieldName);
				continue;
			}
			Schema.DescribeFieldResult sObjFieldDescribe = sObjField.getDescribe();
			df.label = sObjFieldDescribe.getLabel();
			df.name = sObjFieldDescribe.getName();
			displayFieldList.add(df);
		}
		this.queryFieldList = displayFieldNameList;
	}
	
	private SFObjSelectTableElement searchTableElementById(String theId) {
		if (tableEleList != null && theId != null) {
			for (SFObjSelectTableElement ele : tableEleList) {
				if (ele.sObj.Id == theId)
					return ele;
			}
		}
		return null;
	}
	
	private List<String> strToStrList(String inputStr) { return this.strToStrList(inputStr, ','); }
	private List<String> strToStrList(String inputStr, String delim) {
		List<String> result = new List<String>();
		if (inputStr != null && delim != null) {
			List<String> inputStrList = inputStr.split(delim, 0);
			for (String ele : inputStrList) {
				result.add(ele.trim());
			}
		}
		return result;
	}
	
	private String strListToStr(List<String> inputStrList) { return this.strListToStr(inputStrList, ','); }
	private String strListToStr(List<String> inputStrList, String delim) {
		String result = '';
		if (inputStrList != null && delim != null) {
			for (String ele : inputStrList) {
				result += delim + ele;
			}
		}
		if (result.length() >= delim.length()) {
			return result.substringAfter(delim);
		}
		return '';
	}
	
	public with sharing class SFObjSelectTableElement {
		public sObject sObj { get; set; }
		public Map<String, Integer> btnStage { get; set; }
		
		public SFObjSelectTableElement(Map<String, Integer> defBtnStage) {
			this.btnStage = defBtnStage.clone();
		}
	}
	
	public with sharing class SFObjSelectTableDisplayField {
		public String label { get; set; }
		public String name { get; set; }
	}
	
	public with sharing class SFObjSelectTableActionBtn {
		public String id { get; set; }
		public List<String> labels { get; set; }
		public List<Boolean> isDisableList { get; set; }
		
		public SFObjSelectTableActionBtn(String id, List<String> labels, List<Boolean> isDisableList) {
			this.id = id;
			this.labels = labels;
			this.isDisableList = isDisableList;
		}
	}
	
}