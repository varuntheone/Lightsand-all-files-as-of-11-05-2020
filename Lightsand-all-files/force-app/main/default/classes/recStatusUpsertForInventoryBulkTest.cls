@isTest
public class recStatusUpsertForInventoryBulkTest {
    
    static testMethod void Test1(){
        //string batchId = 'a1Np000000IxdzyEAB';
        String userEmail = UserInfo.getUserEmail();
         Inventory_Transaction_Master__c invtrans = new Inventory_Transaction_Master__c();
        invtrans.Batch_Status__c = 'Migration In Progress';
        invtrans.Record_Type__c  = 'sales';
        insert invtrans;
        string batchId = invtrans.id;
        
                Sales_Transaction_Stage__c stageValue = new Sales_Transaction_Stage__c();
        stageValue.Color__c = 'GRAY';
        stageValue.Record_Status__c = '2 - Data Validation Successful';
        stageValue.Upload_Batch_No__c = invtrans.id;
        stageValue.Company__c = 'Hong Kong Packaging';
        stageValue.Year__c = '2019';
        stageValue.Unit_Sold__c = '234';
        stageValue.Unit_Price_100_EUR__c = '24';
        stageValue.Unit_Price_100_USD__c = '25';
        stageValue.Sales_EUR__c = '10';
        stageValue.Sales_USD__c = '20';
        stageValue.Unit_Sold__c = '234';
        stageValue.ExRate_to_EUR__c = '234';
        stageValue.ExRate_to_USD__c = '234';
        stageValue.Local_Net_Unit_Pirce_100__c = '234';
        stageValue.Sales_Transaction_Currency__c = '234';
        stageValue.Gross_Sales_USD__c = '12.2';
        stageValue.Freight_Charge_USD__c = '2.2';
        insert stageValue;
        
        List<Sales_Transaction_Stage__c> transferRecords= new List<Sales_Transaction_Stage__c>();
        transferRecords.add(stageValue);
       /*  List<Weekly_Supply_Consolidated_Id__c> weeklySupplpyConsolidatedList  = new List<Weekly_Supply_Consolidated_Id__c>();
             //List<Weekly_Supply_Summary__c> weeklySupplySummaryList = new List<Weekly_Supply_Summary__c>();
             for(Integer i=0; i<=9901; i++){
                 Weekly_Supply_Consolidated_Id__c weekdemconsol = new Weekly_Supply_Consolidated_Id__c();
                // Weekly_Supply_Summary__c weekSuply = new Weekly_Supply_Summary__c();
                 weeklySupplpyConsolidatedList.add(weekdemconsol);
                 //weeklySupplySummaryList.add(weekSuply);
             }*/
        
        
         string csv = '[{"Company__c":"Hong Kong Packaging","Year__c":"2019","Week__c":"Wk45","Month__c":"Jan","Item_code__c":"484","Material__c":"PP","Source__c":"Virgin","Model__c":"1000","Printed_Logo__c":"demoLogo","Color__c":"BLACK","Customer__c":"xxxxx","Customer_local_name__c":"xxxx","Mainetti_Brand__c":"Mainetti","Category__c":"HANGERS & ACCESSORIES","Sub_Category__c":"HANGERS","Family__c":"BOTTOM","Order_Type__c":"3rd","Unit_Sold__c":"8000","Unit_Price_100_EUR__c":"10.65123","Unit_Price_100_USD__c":"12.40602","Net_Unit_Price_100__c":"11","Sales_EUR__c":"2","Sales_USD__c":"5","Transaction_Currency__c":"HKD","ExRate_to_EUR__c":"9.08505","ExRate_to_USD__c":"7.8","Local_Net_Unit_Pirce_100__c":"13","Sales_Transaction_Currency__c":"2438.527291","Shipped_To_Factory__c":"xxxxxx","Shipped_To_Country__c":"xxxxxx","Label__c":"NL","End_user__c":"NL","Vendor__c":"MACYS","Division__c":"FOB","Retailer_Brand__c":"MMG","Royalty_Rate__c":"USA","Market__c":"USA","Remarks__c":"CHINA","LOB__c":"AAF","SO_Number__c":"18001464","Production_Country__c":"CHINA","Local_Currency__c":"HKD","Gross_Sales_USD__c":"10"}]';
        string fileName = 'sample';
        Inventory_Transaction_Master__c value = new Inventory_Transaction_Master__c(); 
        value.Batch_Status__c = 'Migration Success';
        value.Record_Type__c = 'Sales';
        value.Mainetti_Company__c = 'Mainetti (HK) Ltd';
        insert value;
        
        
        
        
        
        Test.startTest();        
        recStatusUpsertForInventoryBulk obj = new recStatusUpsertForInventoryBulk(batchId,userEmail);
           List<Sales_Transaction_Stage__c> salesTransStage = new  List<Sales_Transaction_Stage__c>();
        Database.BatchableContext BC1;
        obj.start(BC1);
        obj.execute(BC1, transferRecords);
        DataBase.executeBatch(obj);         
        Test.stopTest();
    }

}