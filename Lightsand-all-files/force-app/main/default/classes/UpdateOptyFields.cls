public class UpdateOptyFields {
 /**public static Map < String, String > integerToTextMonthMap;
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
 
 @InvocableMethod
 public static void defaultOptyFields(List < Id > OpportunityIds) {
  System.debug('UpdateOptyFields.defaultOptyFields: START');
  List < User > currentUserList = [select id, Mainetti_Company__c from User where Id = : UserInfo.getUserId()];
  List < Opportunity__c > updateOptyList = new List < Opportunity__c > ();
  for (Opportunity__c eachOpty: [Select Id, User_Default_Company__c, Mainetti_Company1__c,
    Order_Year__c, Month__c, Currency__c, USD_Exchange_Rate__c from Opportunity__c where Id IN: OpportunityIds
   ]) {
   if (currentUserList != null && !currentUserList.isEmpty()) {
    System.debug('currentUserList: ' + currentUserList);
    eachOpty.Mainetti_Company1__c = currentUserList.get(0).Mainetti_Company__c;
   }

   String monthVal = '';
   if (integerToTextMonthMap.containsKey(eachOpty.Month__c)) {
    monthVal = integerToTextMonthMap.get(eachOpty.Month__c);
   }

   List < Exchange_Rate__c > exchangeRateList = [Select Id, ExRate_to_USD__c from Exchange_Rate__c where Year__c = : eachOpty.Order_Year__c AND Month__c = : monthVal AND Local_Currency__c = : eachOpty.Currency__c AND Active__c = TRUE order by CreatedDate DESC];
   if (exchangeRateList != null && !exchangeRateList.isEmpty()) {
    eachOpty.USD_Exchange_Rate__c = exchangeRateList.get(0).ExRate_to_USD__c;
    System.debug('No Exchnage Rate Defined for the Year__c: '+eachOpty.Order_Year__c+':Month__c: '+monthVal
                +':Local_Currency__c: '+eachOpty.Currency__c);
   }
   updateOptyList.add(eachOpty);
  }
  update updateOptyList;
  System.debug('UpdateOptyFields.defaultOptyFields: END');
 }**/
}