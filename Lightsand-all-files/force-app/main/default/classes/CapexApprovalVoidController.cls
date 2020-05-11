public without sharing class CapexApprovalVoidController {
    
    public static final String CHANGE_TO_STATUS = 'Capex No. Revise - Void';
    public static final String ALLOW_CHANGE_STATUS = 'Approved by COO';
    public static final Set<String> SKIP_CLONE_FIELDS = new Set<String> {
        'Capex_Year__c'
        , 'Group_Capex_Number__c'
        , 'Document_Attached__c'
        , 'Capex_Code__c'
    };
    public static final Map<String, Object> FIELD_AND_NEW_VALUE = new Map<String, Object> {
        'Capex_Approval_Status__c' => 'Resend Group Capex Revision'
        ,'Capex_Year__c'=>String.valueOf(system.today().year())
        
    };
    public static final Map<String, String> RT_DEV_NAME_CHANGE_MAP = new Map<String, String> {
        'Mould_Capex_Approved' => 'Mould_Capex'
        , 'Other_Capex_Approved' => 'Other_Capex'
    };
    
    public String myCapexId { get; set; }
    private Capex__c myCapex;
    private Capex__c newCapex;
    
    public CapexApprovalVoidController(ApexPages.StandardController stdController) {
        this.myCapexId = stdController.getId();
        Set<String> cloneFields = getAllCapexFields(SKIP_CLONE_FIELDS);
        cloneFields.add('recordtype.developername');
        this.myCapex = database.query(String.format('SELECT {0} FROM Capex__c WHERE Id = :myCapexId', new String[] {String.join(new List<String>(cloneFields), ',')}));
    }
    
    public PageReference initPage() {
        Boolean hasError = false;
        if (this.myCapex == null) {
            hasError = true;
            showPageError('Failed to retrieve record');
        } else if (ALLOW_CHANGE_STATUS != this.myCapex.Capex_Approval_Status__c) {
            hasError = true;
            showPageError(String.format('Only the record with status "{0}" is allowed', new String[] {ALLOW_CHANGE_STATUS}));
        } else {
            this.myCapex.Capex_Approval_Status__c = CHANGE_TO_STATUS;
            this.newCapex = this.myCapex.clone(false, false, false, false);
            this.newCapex.Cloned_from__c = myCapex.Id;
            // Assign values for the new record
            if (FIELD_AND_NEW_VALUE != null) {
                Set<String> newValueFieldSet = FIELD_AND_NEW_VALUE.keySet();
                for (String fn : newValueFieldSet) {
                    newCapex.put(fn, FIELD_AND_NEW_VALUE.get(fn));
                }
            }
            // Change record type if originally equal to specific values
            if (RT_DEV_NAME_CHANGE_MAP != null) {
                String origRTName = this.myCapex.RecordType.DeveloperName;
                String changeToRTDevName = origRTName == null ? null : RT_DEV_NAME_CHANGE_MAP.get(origRTName);
                if (changeToRTDevName != null) {
                    this.newCapex.RecordTypeId = CapexGenerator.getRecordTypeByDevName(changeToRTDevName).Id;
                }
            }
            System.Savepoint sp = Database.setSavepoint();
            try {
                insert newCapex;
                myCapex.Revision__c = newCapex.Id;
                update myCapex;
            } catch (Exception e) {
                hasError = true;
                database.rollback(sp);
                ApexPages.addMessages(e);
            }
        }
        return hasError == true ? null : new PageReference('/' + newCapex.Id);
    }
    
    private Set<String> getAllCapexFields(Set<String> skipFieldSet) {
        Map<String, Schema.SObjectField> allFieldDescribeMap = Schema.SObjectType.Capex__c.fields.getMap();
        Set<String> allFieldSet = allFieldDescribeMap.keySet();
        Set<String> creatableFieldSet = new Set<String>();
        Set<String> skipFieldLowerCaseSet = new Set<String>();
        if (skipFieldSet != null)
            for (String fn : skipFieldSet)
                skipFieldLowerCaseSet.add(fn.toLowerCase());
        for (String fn : allFieldSet) {
            Schema.DescribeFieldResult fieldDescribe = allFieldDescribeMap.get(fn).getDescribe();
            if (!fieldDescribe.isCalculated() && !fieldDescribe.isAutoNumber() && !skipFieldLowerCaseSet.contains(fn.toLowerCase())) {
                creatableFieldSet.add(fn);
            }
        }
        return creatableFieldSet;
    }
    
    private void showPageMessage(ApexPages.Severity severity, String msg) {
        ApexPages.addMessage(new ApexPages.Message(severity, msg));
    }
    private void showPageError(String msg) {
        showPageMessage(ApexPages.Severity.ERROR, msg);
    }
    
}