trigger UpdateRelatedRetailer on Retailer_Related_Data__c (after insert, after update, before delete) {
 if(trigger.isinsert)
    {
        set<id> Retailer_set=new set<id>();

        for( Retailer_Related_Data__c RRD : trigger.new)
        {
            Retailer_set.add(RRD.ContactID__c);
        }

        Map<ID, Contact> RetailerMap = new Map<ID, Contact>([select id, Related_Retailer__c from Contact where id in :Retailer_set]);
        List<Contact> Retailer_toUpdate_List = new List<Contact>();
        for( Retailer_Related_Data__c RRD : trigger.new)
        {     
            if(RetailerMap.get(RRD.ContactID__c).Related_Retailer__c!=null)
            {
                string new_retailer =RRD.Retailer_Name__c+',';
                if(RetailerMap.get(RRD.ContactID__c).Related_Retailer__c.contains(new_retailer))
                {
                    
                }
                else
                {
                    RetailerMap.get(RRD.ContactID__c).Related_Retailer__c = RetailerMap.get(RRD.ContactID__c).Related_Retailer__c+RRD.Retailer_Name__c+',';
                    Retailer_toUpdate_List.add(RetailerMap.get(RRD.ContactID__c)) ;
                }
            }
            else
            {
                RetailerMap.get(RRD.ContactID__c).Related_Retailer__c = RRD.Retailer_Name__c+',';
                Retailer_toUpdate_List.add(RetailerMap.get(RRD.ContactID__c)) ;
            }
        }
        if(Retailer_toUpdate_List.size()>0)
        {
            update RetailerMap.values();
        }
    }
    
    if(trigger.isupdate)
    {
        for( Retailer_Related_Data__c RRD : trigger.new)
        {
        
            if(trigger.oldMap.get(RRD.id).Retailer_Name__c !=RRD.Retailer_Name__c)
            {
                //List<Mould_Product_c> RRDList = [select id,  Retailer_Name__c         string Mould_Detail='';
                 
                Contact CON = [select id, Related_Retailer__c from Contact where id=:RRD.ContactID__c];
                
                string full_list = CON.Related_Retailer__c;
                string old_value = trigger.oldMap.get(RRD.id).Retailer_Name__c;
                string new_value = RRD.Retailer_Name__c;
                
                CON.Related_Retailer__c= full_list.replace(old_value,New_value);
                update CON;
                
               // List<Mould_Directory__c> MD_List = new List<Mould_Directory__c>();
               // MD_List=[select id from Mould_Directory__c where Contact=:CON.id];
                
               // if(MD_List.size()>0)
                //{
                  //  update MD_List;
               // }
                
            }
        }
    }
    
    if(trigger.isdelete)
    {
        for( Retailer_Related_Data__c RRD : trigger.old)
        {
            Contact CON = [select id, Related_Retailer__c from Contact where id=:RRD.ContactID__c];
            
            if(CON.Related_Retailer__c.contains(RRD.Retailer_Name__c))
            {
                string to_replace = RRD.Retailer_Name__c+',';
                string temp = CON.Related_Retailer__c.replace(to_replace,'');
                
                CON.Related_Retailer__c=temp.replace('  ',' ');
                update CON;
            }
        }
    }
}