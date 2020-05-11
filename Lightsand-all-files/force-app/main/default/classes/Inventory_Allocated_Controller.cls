public class Inventory_Allocated_Controller {
@AuraEnabled
public static List<Inventory_Allocation__c> Inventory_Allocation_Records() {
    List<Inventory_Allocation__c>lis= [SELECT Id,Name, Inventory_Allocation_Type__c,Quantity__c,Week_End_Date__c,Week_Start_Date__c,Week_Number__c from Inventory_Allocation__c limit 10];
   return lis;
}
   
}