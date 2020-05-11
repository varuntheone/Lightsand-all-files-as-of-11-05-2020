global class SupplySummaryForTheWeekIterable implements    Iterable<SObject>,Iterator<SObject>{
    public Iterator<SObject> iterator() { return this; }    
    
    List<SObject> sobjs {get; set;} 
    Integer i {get; set;} 
    
    public SupplySummaryForTheWeekIterable(){ 
        System.debug('Start SupplySummaryForTheWeekIterable');
        Date startdate = date.today();
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
       sobjs = new List<SObject>();
       List<Partner__c> partner = [Select  Name, Default_Order_to_Company__c from Partner__c where Default_Order_to_Company__c != null and Partner_Status__c = 'Active' and  RecordType.Name in('Mainetti Company','Licensee Partner')]; 
       for( Partner__c part : partner ) {
           sobjs.add(part);
       }
        integer partnerSize = (sobjs.size() );
        System.debug('##### SupplySummaryForTheWeekIterable:::: Partner::::SIZE'+partnerSize);
       i = 0;   
      
        System.debug('End SupplySummaryForTheWeekIterable::: OverAll:SIZE'+sobjs.size());
       
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