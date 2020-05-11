public class OpportunityTriggerHandler {
    
    public static Map < String, String > integerToTextMonthMap; //Map holds Interger to Text mapping for MOnth
    static {
        integerToTextMonthMap = new Map < String, String > ();
        integerToTextMonthMap.put('1', 'Jan');
        integerToTextMonthMap.put('2', 'Feb');
        integerToTextMonthMap.put('3', 'Mar');
        integerToTextMonthMap.put('4', 'Apr');
        integerToTextMonthMap.put('5', 'May');
        integerToTextMonthMap.put('6', 'Jun');
        integerToTextMonthMap.put('7', 'Jul');
        integerToTextMonthMap.put('8', 'Aug');
        integerToTextMonthMap.put('9', 'Sep');
        integerToTextMonthMap.put('10', 'Oct');
        integerToTextMonthMap.put('11', 'Nov');
        integerToTextMonthMap.put('12', 'Dec');
    }
    
    private static boolean run = true;
    public static boolean runOnce(){
        if(run){
            run=false;
            return true;
        }else{
            return run;
        }
    }
    
    public static void updateExhangeRate(List<Opportunity__c> Records){
        
        LIST<String> yearList = new List<String>(); //-- Holds the year value from opportunity__c record for IN query against Exchange_Rate__c
        LIST<String> monthList = new List<String>(); //-- Holds the month value from opportunity__c record for IN query against Exchange_Rate__c
        LIST<String> currencyList = new List<String>(); //-- Holds the currency value from opportunity__c record for IN query against Exchange_Rate__c
        
         User  currentUser = [select id, Mainetti_Company__c from User where Id = : UserInfo.getUserId() LIMIT 1];
        
        //-- Build the List required for query
        for(Opportunity__c eachRecord : Records){            
           if(String.isNotBlank(eachRecord.Order_Year__c))
                yearList.add(eachRecord.Order_Year__c);
            
            if(String.isNotBlank(eachRecord.Month__c))
                monthList.add(integerToTextMonthMap.get(eachRecord.Month__c));
            
            if(String.isNotBlank(eachRecord.Currency__c))
                currencyList.add(eachRecord.Currency__c); 
        }
        
        
        if(!yearList.isEmpty() && !monthList.isEmpty() && !currencyList.isEmpty()){//-- null check
            //-- Query Exchange_Rate__c to get all required mapping records
            List < Exchange_Rate__c > exchangeRateList = [Select Id, ExRate_to_USD__c,Year__c,Local_Currency__c,Month__c from Exchange_Rate__c where Year__c IN :yearList AND Month__c IN :monthList AND Local_Currency__c = :currencyList AND Active__c = TRUE order by CreatedDate DESC];
                
            
            if (exchangeRateList != null && !exchangeRateList.isEmpty()) {
                
                LIST<Opportunity__c> updateOppList = new LIST<Opportunity__c>();//-- Opportunity__c update List           
                Map<String,Decimal> exchangeRateMap = new Map<String,Decimal>();//-- map to hold Year+month+currncy as Key and ExRate_to_USD__c as value
                for(Exchange_Rate__c eachExRate :  exchangeRateList){
                    exchangeRateMap.put(eachExRate.Year__c+'#@#'+eachExRate.Month__c+'#@#'+eachExRate.Local_Currency__c, eachExRate.ExRate_to_USD__c);
                }
   
                //-- build update list for opportunity__c 
                for(Opportunity__c eachRecord : Records){               	
                    
                    Opportunity__c updateOpp = new Opportunity__c(Id=eachRecord.Id);
                    
                    if(String.isNotBlank(eachRecord.Order_Year__c) && String.isNotBlank(eachRecord.Month__c)
                      && String.isNotBlank(eachRecord.Currency__c)){
                          updateOpp.USD_Exchange_Rate__c = exchangeRateMap.get(eachRecord.Order_Year__c+'#@#'+integerToTextMonthMap.get(eachRecord.Month__c)+'#@#'+eachRecord.Currency__c);
                    }
                   
                    if (currentUser != null) {
                        updateOpp.Mainetti_Company1__c = currentUser.Mainetti_Company__c;
                    }
                     updateOppList.add(updateOpp);
                }
                
                //-- Update opportunity with USD_Exchange_Rate__c value
                if(!updateOppList.isEmpty()){
                    update updateOppList;
                }                
            }
        }
    }

}