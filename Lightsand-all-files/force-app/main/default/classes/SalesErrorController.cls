public class SalesErrorController {
    /*
     * The below method is used to fetch error records from Sales transaction stage object.
     * @author Varun.
     * 
     * */
    @AuraEnabled
    public static List<Sales_Transaction_Stage__c> fetchsalesErrorData(String batchId,Boolean missingData,Boolean validationFailed,Boolean warning,Boolean calculationFailed,Boolean dateMismatch,Boolean remarks, Integer pageNumber, Integer recordToDisplay){
        //system.debug('batchId:'+batchId);
        system.debug('missingData:'+missingData);
        //system.debug('pageNumber:'+pageNumber);
        //system.debug('recordToDisplay:'+recordToDisplay);
        List<Sales_Transaction_Stage__c> salesErrorDataList = new List<Sales_Transaction_Stage__c>();      
        String searchQuery = 'SELECT Id,unit_sold_warning__c,Color_Formula__c,Gross_Sales_USD__c,Gross_Sales_USD_FB__c,Gross_Sales_USD_NF__c,Freight_Charge_USD__c,Freight_Charge_USD_FB__c,Freight_Charge_USD_NF__c,selected_ui_values__c,Row_No__c,Week_FB__c,Year_FB__c,Source_FB__c,Month_FB__c,Unit_Sold_FB__c,Local_Net_Unit_Pirce_FB__c,Net_Unit_Price_100_FB__c,ExRate_to_USD_FB__c,ExRate_to_EUR_FB__c,Calculation_Failed__c,Remark__c,Label__c,End_user__c,Royalty_Rate__c,Printed_Logo__c,Customer_local_name__c,Net_Unit_Price_100__c,Local_Net_Unit_Pirce_100__c,ExRate_to_USD__c,ErrorMapData__c,validation_failed__c,warning_consolidate_key__c,SO_Number__c,SO_Number_FB__c,SO_Number_NF__c,LOB__c,LOB_FB__c,LOB_NF__c, Company__c,Company_FB__c,Customer__c,Customer_FB__c,Transaction_Currency__c,Transaction_Currency_FB__c,Transaction_Currency_NF__c, Division__c,Division_FB__c,Division_NF__c,Mainetti_Brand__c,Mainetti_Brand_FB__c,Mainetti_Brand_NF__c,Item_code__c,Item_code_FB__c,Item_code_NF__c,Production_Country__c,Production_Country_FB__c,Production_Country_NF__c,Retailer_Brand__c,Retailer_Brand_FB__c,Retailer_Brand_NF__c, Material__c,Material_FB__c,Material_NF__c,Company_NF__c,Model__c,Model_FB__c,Model_NF__c,Market__c,Market_FB__c,Market_NF__c,Vendor__c,Vendor_FB__c,Vendor_NF__c, Category__c,Category_FB__c,Category_NF__c,Sub_Category__c,Sub_Category_FB__c,Sub_Category_NF__c,Order_Type__c,Order_Type_FB__c,Order_Type_NF__c, Shipped_To_Country__c,Shipped_To_Country_FB__c,Shipped_To_Country_NF__c,Shipped_To_Factory__c,Shipped_To_Factory_FB__c,Shipped_To_Factory_NF__c, Color__c,Color_FB__c,Color_NF__c,Country__c,Country_NF__c,ExRate_to_EUR__c,ExRate_to_EUR_NF__c, ExRate_to_USD_NF__c,Local_Currency__c,Local_Currency_NF__c,Local_Currency_FB__c,Month__c,Month_NF__c,Remarks__c,Retailer_Code__c,Retailer_Code_NF__c, Sales_Local__c,SL_NF__c,Source__c,Source_NF__c,Unit_Sold__c,US_NF__c,UOM__c,UOM_NF__c,Week__c,Week_NF__c,Year__c,Year_NF__c,Upload_Batch_No__c,  Family__c,Family_FB__c,Family_NF__c,Sales_Transaction_Currency__c,STC_FB__c,STC_NF__c,Sales_EUR__c,Sales_EUR_FB__c,Sales_EUR_NF__c,  Sales_USD__c,Sales_USD_FB__c,Sales_USD_NF__c,Unit_Price_100_EUR__c,Unit_Price_100_EUR_FB__c,Unit_Price_100_EUR_NF__c,wrong_date__c,  Unit_Price_100_USD__c,Unit_Price_100_USD_FB__c,Unit_Price_100_USD_NF__c,Label_FB__c,Retailer_Check__c,Model_Check__c,Company_Formula__c,Year_Formula__c,Week_Formula__c,Month_Formula__c,Item_Code_Formula__c,Material_Formula__c,Source_Formula__c,Model_Formula__c,Customer_Formula__c,Customer_Local_Name_Formula__c,Category_Formula__c,Sub_Category_Formula__c,Family_Formula__c,Order_Type_Formula__c,Unit_Sold_Formula__c,Unit_Price_100_EUR_Formula__c,Unit_Price_100_USD_Formula__c,Net_Unit_Price_100_Formula__c,Sales_EUR_Formula__c,Sales_USD_Formula__c,Transaction_Currency_Formula__c,ExRate_to_EUR_Formula__c,ExRate_to_USD_Formula__c,Local_Net_Unit_Pirce_100_Formula__c,Sales_Transaction_Currency_Formula__c,Shipped_To_Factory_Formula__c,Shipped_To_Country_Formula__c,Label_Formula__c,Vendor_Formula__c,Division_Formula__c,Retailer_Brand_Formula__c,Royalty_Rate_Formula__c,Market_Formula__c,LOB_Formula__c,SO_Number_Formula__c,Production_Country_Formula__c,Gross_Sales_USD_Formula__c,Freight_Charge_USD_Formula__c FROM Sales_Transaction_Stage__c WHERE Transaction_Master_Id__c=:batchId';
        
        if(validationFailed){
           searchQuery += ' AND ( Company_NF__c=:validationFailed OR Year_NF__c=:validationFailed OR Week_NF__c=:validationFailed'+
                			' OR Month_NF__c=:validationFailed OR Item_code_NF__c=:validationFailed OR Material_NF__c=:validationFailed OR Source_NF__c=:validationFailed OR Model_NF__c=:validationFailed OR Printed_Logo_NF__c=:validationFailed'+
                ' OR Color_NF__c=:validationFailed OR Customer_NF__c=:validationFailed OR Customer_local_name_NF__c=:validationFailed OR Category_NF__c=:validationFailed'+
                ' OR Sub_Category_NF__c=:validationFailed OR Family_NF__c=:validationFailed OR Order_Type_NF__c=:validationFailed OR US_NF__c=:validationFailed OR Unit_Price_100_EUR_NF__c=:validationFailed'+
                ' OR Unit_Price_100_USD_NF__c=:validationFailed OR Net_Unit_Price_100_NF__c=:validationFailed OR Sales_EUR_NF__c=:validationFailed OR Sales_USD_NF__c=:validationFailed OR Transaction_Currency_NF__c=:validationFailed'+
                ' OR ExRate_to_EUR_NF__c=:validationFailed OR ExRate_to_USD_NF__c=:validationFailed OR Local_Net_Unit_Pirce_NF__c=:validationFailed OR STC_NF__c=:validationFailed'+
                ' OR Shipped_To_Factory_NF__c=:validationFailed OR Shipped_To_Country_NF__c=:validationFailed OR Label_NF__c=:validationFailed OR End_user_NF__c=:validationFailed '+
                ' OR Vendor_NF__c=:validationFailed OR Division_NF__c=:validationFailed OR Retailer_Brand_NF__c=:validationFailed  OR Royalty_Rate_NF__c=:validationFailed '+
                ' OR Market_NF__c=:validationFailed OR LOB_NF__c=:validationFailed OR SO_Number_NF__c=:validationFailed OR Production_Country_NF__c=:validationFailed'+
                ' OR Gross_Sales_USD_NF__c=:validationFailed OR Freight_Charge_USD_NF__c=:validationFailed OR selected_ui_values__c=:validationFailed)';
            //vendorFailPresent = true;
        }
        if(missingData){
            searchQuery += ' AND (Company_FB__c=:missingData OR Year_FB__c=:missingData OR Week_FB__c=:missingData'+
                			' OR Month_FB__c=:missingData OR Item_code_FB__c=:missingData OR Material_FB__c=:missingData OR Source_FB__c=:missingData OR Model_FB__c=:missingData OR Printed_Logo_FB__c=:missingData'+
                ' OR Color_FB__c=:missingData OR Customer_FB__c=:missingData OR Customer_local_name_FB__c=:missingData OR Category_FB__c=:missingData'+
                ' OR Sub_Category_FB__c=:missingData OR Family_FB__c=:missingData OR Order_Type_FB__c=:missingData OR Unit_Sold_FB__c=:missingData OR Unit_Price_100_EUR_FB__c=:missingData'+
                ' OR Unit_Price_100_USD_FB__c=:missingData OR Net_Unit_Price_100_FB__c=:missingData OR Sales_EUR_FB__c=:missingData OR Sales_USD_FB__c=:missingData OR Transaction_Currency_FB__c=:missingData'+
                ' OR ExRate_to_EUR_FB__c=:missingData OR ExRate_to_USD_FB__c=:missingData OR Local_Net_Unit_Pirce_FB__c=:missingData OR STC_FB__c=:missingData'+
                ' OR Shipped_To_Factory_FB__c=:missingData OR Shipped_To_Country_FB__c=:missingData OR Label_FB__c=:missingData OR End_user_FB__c=:missingData '+
                ' OR Vendor_FB__c=:missingData OR Division_FB__c=:missingData OR Retailer_Brand_FB__c=:missingData  OR Royalty_Rate_FB__c=:missingData '+
                ' OR Market_FB__c=:missingData OR LOB_FB__c=:missingData OR SO_Number_FB__c=:missingData OR Production_Country_FB__c=:missingData'+
                ' OR Gross_Sales_USD_FB__c=:missingData OR Freight_Charge_USD_FB__c=:missingData)';
        }
        if(calculationFailed){
            searchQuery += ' AND Calculation_Failed__c=:calculationFailed';
        }
        system.debug('warning:'+warning);
		if(warning){
            searchQuery += ' AND (warning_consolidate_key__c=:warning OR unit_sold_warning__c=:warning) ';
        }
		if(dateMismatch){
            searchQuery += ' AND wrong_date__c=:dateMismatch';
        }
        if(remarks)
        {
            searchQuery += ' AND Remarks__c <> null';
        }
        
        system.debug('searchQuery:'+searchQuery);
        List<Sales_Transaction_Stage__c> fetchErrorList = Database.query(searchQuery);
        system.debug('fetchErrorList:'+fetchErrorList.size());       
        return fetchErrorList; 
    }

}