trigger Update_Mould_Detail on Mould_Action__c (after insert) 
{

    for( Mould_Action__c MA : trigger.new)
    {
         List<Mould_Action__c> MAList = [select id, SYS_Mould_Name__c,SYS_Mould_ID__c, SYS_Mould_Model__c,SYS_Mould_Cavity__c,  SYS_Mould_Owner_Factory__c, SYS_Mould_Owner_Country__c, SYS_Mould_Owner_Company__c  from Mould_Action__c where Mould_Action_Form__c=:MA.Mould_Action_Form__c];
          
          string Mould_Detail='';
            
        for(Mould_Action__c MA_Line : MAList)
        {
            Mould_Detail = Mould_Detail+ MA_Line.SYS_Mould_Name__c+' (' + MA_Line.SYS_Mould_ID__c +'), Cavity:'+MA_Line.SYS_Mould_Cavity__c+'<br/>';
        }
        
        Mould_Action_Form__c MAF = [select id, SYS_Mould_Detail_multi__c from Mould_Action_Form__c where id=:MA.Mould_Action_Form__c];
        
        Mould_Detail.replace('null','');
        MAF.SYS_Mould_Detail_multi__c =Mould_Detail;
        update MAF;
    }
}