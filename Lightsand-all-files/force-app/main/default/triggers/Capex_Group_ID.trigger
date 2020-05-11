trigger Capex_Group_ID on Capex__c (before update, before insert)
{
    if(trigger.isupdate)
    {
    
        for (Capex__c capex : trigger.new)
        {
            if(capex.Group_Capex_Number__c==null || capex.Group_Capex_Number__c=='')
            {
                if(capex.Capex_Approval_Status__c=='Approved by GOO' && capex.Capex_Code__c!=null )
                {

                    List<Sys_Capex_Auto_Num__c> NewCPX_Num = [select Next_Num__c from Sys_Capex_Auto_Num__c where Code__c=:capex.Capex_Code__c and Year__c=:capex.Capex_Year__c for update];
                    if(NewCPX_Num.size()!=1 )
                    {
                            capex.adderror('Cannot assign Capex Group Code, please contact Administrator');
                    }
                
                    if(capex.Capex_Ownership__c=='Licensees')
                    {
                       
                        //Sys_Capex_Auto_Num__c newGHANum = [select Next_Num__c from Sys_Capex_Auto_Num__c where Capex_Code__c=:capex.Capex_Code__c and Year__c=:capex.Capex_Year__c for update];
                        //database.insert(newLicenseeNum);
                       
                        //newLicenseeNum = [select name from Sys_Licensee_Auto_Number__c where Latest__c = true];
                       
                        //string temp = capex.Capex_Code__c+'-'+capex.Capex_Year__c.right(2)+'/'+newLicenseeNum.name+'('+capex.Location_Code__c;

                        string temp = capex.Capex_Code__c+capex.Capex_Year__c.right(2)+NewCPX_Num[0].Next_Num__c;
                       
                        capex.Group_Capex_Number__c=temp;
                       
                        string newNum = string.valueof(integer.valueof(NewCPX_Num[0].Next_Num__c)+1);
                       

                        for(integer i = newNum.length(); i<3;i++)
                        {
                            newNum='0'+newNum;
                        }
              
                        NewCPX_Num[0].Next_Num__c=newNum;
                  
                        update(NewCPX_Num[0]);
                    }
                   
                    else if((capex.Capex_Ownership__c=='Mainetti' || capex.Capex_Ownership__c=='Techstar' || capex.Capex_Ownership__c=='Petterssons' || capex.Capex_Ownership__c=='Hangers Unlimited') && capex.Capex_Code__c=='GCU')
                    { 
                        string temp = capex.Capex_Code__c+'-'+capex.Capex_Year__c.right(2)+'/'+NewCPX_Num[0].Next_Num__c+'('+capex.Location_Code__c+')';
                        capex.Group_Capex_Number__c=temp;
                        
                        string newNum = string.valueof(integer.valueof(NewCPX_Num[0].Next_Num__c)+1);
                        for(integer i = newNum.length(); i<4;i++)
                        {
                            newNum='0'+newNum;
                        }
              
                        NewCPX_Num[0].Next_Num__c=newNum;
                  
                        update(NewCPX_Num[0]);
                    }
                   
                    else if((capex.Capex_Ownership__c=='Mainetti' || capex.Capex_Ownership__c=='Techstar' || capex.Capex_Ownership__c=='Petterssons' || capex.Capex_Ownership__c=='Hangers Unlimited') && capex.Capex_Code__c=='GCB')
                    {

                        string temp = capex.Capex_Code__c+'-'+capex.Capex_Year__c.right(2)+'/'+NewCPX_Num[0].Next_Num__c+'('+capex.Location_Code__c+')';
                        capex.Group_Capex_Number__c=temp;
                        string newNum = string.valueof(integer.valueof(NewCPX_Num[0].Next_Num__c)+1);
                        for(integer i = newNum.length(); i<4;i++)
                        {
                            newNum='0'+newNum;
                        }
              
                        NewCPX_Num[0].Next_Num__c=newNum;
                    
                        update(NewCPX_Num[0]);
                    }
                    
                    else if((capex.Capex_Ownership__c=='Mainetti' || capex.Capex_Ownership__c=='Techstar' || capex.Capex_Ownership__c=='Petterssons' || capex.Capex_Ownership__c=='Hangers Unlimited') && capex.Capex_Code__c=='GP')
                    {

                        string temp = capex.Capex_Code__c+'-'+capex.Capex_Year__c.right(2)+'/'+NewCPX_Num[0].Next_Num__c+'('+capex.Location_Code__c+')';
                        capex.Group_Capex_Number__c=temp;
                        string newNum = string.valueof(integer.valueof(NewCPX_Num[0].Next_Num__c)+1);
                        for(integer i = newNum.length(); i<4;i++)
                        {
                            newNum='0'+newNum;
                        }
              
                        NewCPX_Num[0].Next_Num__c=newNum;
                  
                        update(NewCPX_Num[0]);
                    }
                    
                    else if( (capex.Capex_Ownership__c=='Sub-contractor' ||  capex.Capex_Ownership__c=='Others') && capex.Capex_Code__c=='GHS')
                    {

                        string temp = capex.Capex_Code__c+capex.Capex_Year__c.right(2)+NewCPX_Num[0].Next_Num__c;
                       
                        capex.Group_Capex_Number__c=temp;
                       
                        string newNum = string.valueof(integer.valueof(NewCPX_Num[0].Next_Num__c)+1);
                       

                        for(integer i = newNum.length(); i<3;i++)
                        {
                            newNum='0'+newNum;
                        }
              
                        NewCPX_Num[0].Next_Num__c=newNum;
                  
                        update(NewCPX_Num[0]);
                    }
                    
                    
                }
                
                
                
                
                
                
            }
            //////fill in Location Code
            if(capex.Company_Name__c!=null &&  capex.Location_Code__c==null)
            {
                List<Sys_Capex_Auto_Num__c> NewCPX_Num = [select Next_Num__c, Capex_Location_code__c from Sys_Capex_Auto_Num__c where Capex_Company_Name__c=:capex.Company_Name__c and Year__c=:capex.Capex_Year__c for update];
                
                if(NewCPX_Num.size()!=1 )
                {
                        capex.adderror('Cannot find Local Code for Mainetti Company!');
                }
                
                capex.Location_Code__c = NewCPX_Num[0].Capex_Location_code__c;
            }
            
            
            
            
            //////gen Local Application Number
            
            if(capex.Company_Name__c!=null && capex.Local_Application_No__c==null)
            {
                List<Recordtype> Record_Type_ID = [select id from Recordtype where Name = 'Budgeted Capex'];
                
                if(capex.recordtypeID != Record_Type_ID[0].id)
                {
                    List<Sys_Capex_Auto_Num__c> NewCPX_Num = [select Next_Num__c, Code__c, Capex_Location_code__c from Sys_Capex_Auto_Num__c where Capex_Company_Name__c=:capex.Company_Name__c and Year__c=:capex.Capex_Year__c for update];
                    if(NewCPX_Num.size()!=1 )
                    {
                            capex.adderror('Cannot assign Local Application No., please contact Administrator');
                    }
                
                    string temp = NewCPX_Num[0].Code__c+'-'+capex.Capex_Year__c+'-'+NewCPX_Num[0].Next_Num__c;
                       
                        capex.Local_Application_No__c=temp;
                        
                       
                       
                        string newNum = string.valueof(integer.valueof(NewCPX_Num[0].Next_Num__c)+1);
                       

                    for(integer i = newNum.length(); i<4;i++)
                    {
                        newNum='0'+newNum;
                    }
          
                    NewCPX_Num[0].Next_Num__c=newNum;
              
                    update(NewCPX_Num[0]);
                }
            }
        }
    }
    
    if(trigger.isinsert)
    {
        for (Capex__c capex : trigger.new)
        {
            if(capex.Company_Name__c!=null &&  capex.Location_Code__c==null)
            {
                List<Sys_Capex_Auto_Num__c> NewCPX_Num = [select Next_Num__c, Capex_Location_code__c from Sys_Capex_Auto_Num__c where Capex_Company_Name__c=:capex.Company_Name__c and Year__c=:capex.Capex_Year__c for update];
                
                if(NewCPX_Num.size()!=1 )
                {
                        capex.adderror('Cannot find Local Code for Mainetti Company!');
                }
                
                capex.Location_Code__c = NewCPX_Num[0].Capex_Location_code__c;
            }

            
            //////gen Local Application Number
            
            if(capex.Company_Name__c!=null && capex.Local_Application_No__c==null)
            {
                List<Recordtype> Record_Type_ID = [select id from Recordtype where Name = 'Budgeted Capex'];
                
                if(capex.recordtypeID != Record_Type_ID[0].id)
                {
                    List<Sys_Capex_Auto_Num__c> NewCPX_Num = [select Next_Num__c, Code__c, Capex_Location_code__c from Sys_Capex_Auto_Num__c where Capex_Company_Name__c=:capex.Company_Name__c and Year__c=:capex.Capex_Year__c for update];
                    if(NewCPX_Num.size()!=1 )
                    {
                            capex.adderror('Cannot assign Local Application No., please contact Administrator');
                    }
                
                    string temp = NewCPX_Num[0].Code__c+'-'+capex.Capex_Year__c+'-'+NewCPX_Num[0].Next_Num__c;
                       
                        capex.Local_Application_No__c=temp;
                        
                       
                       
                        string newNum = string.valueof(integer.valueof(NewCPX_Num[0].Next_Num__c)+1);
                       

                    for(integer i = newNum.length(); i<4;i++)
                    {
                        newNum='0'+newNum;
                    }
          
                    NewCPX_Num[0].Next_Num__c=newNum;
              
                    update(NewCPX_Num[0]);
                }
            }
        }
    }
}