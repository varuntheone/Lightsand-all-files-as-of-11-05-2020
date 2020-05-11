trigger Mould_ID on Mould__c (before update)
{
    if(trigger.isupdate)
    {
    
        for (Mould__c Mou: trigger.new)
        {
            if(Mou.Mould_ID__c==null || Mou.Mould_ID__c=='')
            {
                if(Mou.Mould_Status__c=='Active' && Mou.Capex_Verification_Status__c=='Approved' && MOU.Mould_ID_Approval__c=='Approved')
                {

                    List<Sys_Capex_Auto_Num__c> NewMou_ID = [select Next_Num__c from Sys_Capex_Auto_Num__c where Code__c='Mould ID Auto Num'];
                    if(NewMou_ID.size()!=1 )
                    {
                            Mou.adderror('Cannot assign Mould ID, please contact Administrator');
                    }
                
                        //Sys_Capex_Auto_Num__c newGHANum = [select Next_Num__c from Sys_Capex_Auto_Num__c where Capex_Code__c=:capex.Capex_Code__c and Year__c=:capex.Capex_Year__c for update];
                        //database.insert(newLicenseeNum);
                       
                        //newLicenseeNum = [select name from Sys_Licensee_Auto_Number__c where Latest__c = true];
                       
                        //string temp = capex.Capex_Code__c+'-'+capex.Capex_Year__c.right(2)+'/'+newLicenseeNum.name+'('+capex.Location_Code__c;

                        string temp = '16'+NewMou_ID[0].Next_Num__c;
                       
                        Mou.Mould_ID__c=temp;
                       
                        string newNum = string.valueof(integer.valueof(NewMou_ID[0].Next_Num__c)+1);
                       

                        for(integer i = newNum.length(); i<3;i++)
                        {
                            newNum='0'+newNum;
                        }
              
                        NewMou_ID[0].Next_Num__c=newNum;
                  
                        update(NewMou_ID[0]);
                    }   
                    
                }
           }
     }
            
}