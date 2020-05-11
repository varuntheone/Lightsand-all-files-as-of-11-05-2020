trigger Update_Model on Mould_Product__c (after insert, after update, before delete) 
{

    if(trigger.isinsert)
    {
        set<id> Mould_set=new set<id>();

        for( Mould_Product__c MP : trigger.new)
        {
            Mould_set.add(MP.Mould__c);
        }

        Map<ID, Mould__c> mouldMap = new Map<ID, Mould__c>([select id, Model__c from Mould__c where id in :Mould_set]);
        List<Mould__c> Mould_toUpdate_List = new List<Mould__c>();
        for( Mould_Product__c MP : trigger.new)
        {     
            if(mouldMap.get(mp.Mould__c).Model__c!=null)
            {
                string new_model =MP.SYS_Product_Name__c+',';
                if(mouldMap.get(mp.Mould__c).Model__c.contains(new_model))
                {
                    
                }
                else
                {
                    mouldMap.get(mp.Mould__c).Model__c = mouldMap.get(mp.Mould__c).Model__c+MP.SYS_Product_Name__c+',';
                    Mould_toUpdate_List.add(mouldMap.get(mp.Mould__c)) ;
                }
            }
            else
            {
                mouldMap.get(mp.Mould__c).Model__c = MP.SYS_Product_Name__c+',';
                Mould_toUpdate_List.add(mouldMap.get(mp.Mould__c)) ;
            }
        }
        if(Mould_toUpdate_List.size()>0)
        {
            update mouldMap.values();
        }
    }
    
    if(trigger.isupdate)
    {
        for( Mould_Product__c MP : trigger.new)
        {
        
            if(trigger.oldMap.get(MP.id).SYS_Product_Name__c !=MP.SYS_Product_Name__c)
            {
                //List<Mould_Product_c> MPList = [select id,  SYS_Product_Name__c         string Mould_Detail='';
                 
                Mould__C MOU = [select id, Model__c from Mould__c where id=:MP.Mould__c];
                
                string full_list = MOU.Model__c;
                string old_value = trigger.oldMap.get(MP.id).SYS_Product_Name__c;
                string new_value = MP.SYS_Product_Name__c;
                
                MOU.Model__c= full_list.replace(old_value,New_value);
                update MOU;
                
                List<Mould_Directory__c> MD_List = new List<Mould_Directory__c>();
                MD_List=[select id from Mould_Directory__c where Mould__c=:MOU.id];
                
                if(MD_List.size()>0)
                {
                    update MD_List;
                }
                
            }
        }
    }
    
    if(trigger.isdelete)
    {
        for( Mould_Product__c MP : trigger.old)
        {
            Mould__C MOU = [select id, Model__c from Mould__c where id=:MP.Mould__c];
            
            if(MOU.Model__c.contains(MP.SYS_Product_Name__c))
            {
                string to_replace = MP.SYS_Product_Name__c+',';
                string temp = MOU.Model__c.replace(to_replace,'');
                
                MOU.Model__c=temp.replace('  ',' ');
                update MOU;
            }
        }
    }
        

}