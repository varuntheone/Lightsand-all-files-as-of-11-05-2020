global class DemandSummaryForTheWeekIterable implements    Iterable<SObject>,Iterator<SObject>{
    public Iterator<SObject> iterator() { return this; }        
    List<SObject> sobjs {get; set;} 
    Integer i {get; set;}     
    public DemandSummaryForTheWeekIterable(){ 
        System.debug('Start DemandSummaryForTheWeekIterable');
        Date startdate = date.today();
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
         
        sobjs = new List<SObject>();
        String getQueryPartnerString='Select  Name, Default_Order_to_Company__c from Partner__c where Default_Order_to_Company__c != null and Partner_Status__c = \'Active\' and  RecordType.Name in(\'Mainetti Company\',\'Licensee Partner\')';
        for(List<Partner__c> part : Database.Query(getQueryPartnerString)) {       
           sobjs.addAll(part);
       }        
       i = 0;         
        //System.debug('records'+Database.Query(getQueryPartnerString));
        System.debug('End DemandSummaryForTheWeekIterable::: OverAll:SIZE'+sobjs.size());
       
    }   
    global boolean hasNext(){         
        if(i >= sobjs.size()) 
            return false; 
        else 
            return true; 
    }    
    global SObject next(){ 
        //if(i == 8){ i++; return null;} 
        i=i+1; 
        return sobjs[i-1]; 
    }      
}