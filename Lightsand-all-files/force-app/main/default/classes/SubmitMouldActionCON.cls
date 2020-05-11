public with sharing class SubmitMouldActionCON {
  
  private static final String CHANGE_TO_STATUS = 'Submitted';
  public Mould_Action_Form__c MAF{ get; set; }
  
  public SubmitMouldActionCON (ApexPages.StandardController stdCon) {
    ID MAFId = stdCon.getId();
    this.MAF= [SELECT Id, RecordTypeID, Action_Status__c, Pending_Action_Count__c, SYS_Mould_Detail_multi__c FROM Mould_Action_Form__c WHERE Id = :MAFId ];
  }
  
  public PageReference submitMouldActionForm() {
    PageReference redirectPage = null;
    if (MAF.Action_Status__c != CHANGE_TO_STATUS) {
        if (MAF.Pending_Action_Count__c == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No moulds pending for move'));
        }
        else {
            MAF.Action_Status__c = CHANGE_TO_STATUS;
            MAF.RecordTypeID='01290000000SgjW';
            
            
            List<Mould_Action__c> MAList = [select id, SYS_Mould_Name__c,SYS_Mould_ID__c, SYS_Mould_Model__c,SYS_Mould_Cavity__c,  SYS_Mould_Owner_Factory__c, SYS_Mould_Owner_Country__c, SYS_Mould_Owner_Company__c  from Mould_Action__c where Mould_Action_Form__c=:MAF.id];
          
            string Mould_Detail='';
            
            for(Mould_Action__c MA_Line : MAList)
            {
                Mould_Detail = Mould_Detail+ MA_Line.SYS_Mould_Name__c+' (' + MA_Line.SYS_Mould_ID__c +'), Cavity:'+MA_Line.SYS_Mould_Cavity__c+'<br/>';
            }
            
            MAF.SYS_Mould_Detail_multi__c=Mould_Detail;

            
            try {
                update MAF;
                redirectPage = new PageReference('/' + MAF.Id);
            } 
            catch (DmlException dmle) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, dmle.getDmlMessage(0)));
            }           
        }           
    }
    return redirectPage;
  }
}