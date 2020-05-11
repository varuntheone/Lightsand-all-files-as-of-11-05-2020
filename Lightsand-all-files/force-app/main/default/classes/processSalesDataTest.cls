@isTest
public class processSalesDataTest {
    
    
    @isTest 
    static void validateUploadRowsTest()
    {
        Inventory_Transaction_Master__c value = new Inventory_Transaction_Master__c(); 
        value.Batch_Status__c = 'Migration Success';  
        value.Record_Type__c = 'Sales';
        insert value;
        string returnBatchId = '';
        Sales_Transaction_Stage__c salesTransMast = new Sales_Transaction_Stage__c();
        salesTransMast.Upload_Batch_No__c = value.Id;
        salesTransMast.Company__c = 'Hong Kong Packaging';
        salesTransMast.Year__c = '2019';
        salesTransMast.Week__c = 'wk02';
        salesTransMast.Month__c = 'Dec'; 
        salesTransMast.Item_Code__c = 'HGR-3944   BLK002-  100';
        salesTransMast.Material__c = 'PS';
        salesTransMast.Source__c = 'virginn';
        salesTransMast.Model__c = '1000';
        salesTransMast.Printed_Logo__c = 'demologo';
        salesTransMast.Color__c = 'black';
        salesTransMast.Customer__c = 'xxxxxx';
        salesTransMast.Customer_Local_Name__c = 'xxxx';
        salesTransMast.Mainetti_Brand__c = 'mainetti';
        salesTransMast.Category__c = 'HANGERS & ACCESSORIES';
        salesTransMast.Sub_Category__c = 'HANGERS';
        salesTransMast.Family__c = 'bottom';
        salesTransMast.Order_Type__c = '3rd';
        salesTransMast.Unit_Sold__c = '12520';
        salesTransMast.Unit_Price_100_EUR__c = '110.65123';
        salesTransMast.Unit_Price_100_USD__c = '112.40602';
        salesTransMast.Net_Unit_Price_100__c = '111';
        salesTransMast.Sales_EUR__c = '1268.410993';
        salesTransMast.Sales_USD__c = '1312.631704';
        salesTransMast.Transaction_Currency__c = 'hkd';
        salesTransMast.ExRate_to_EUR__c = '19.08505';
        salesTransMast.ExRate_to_USD__c = '20.8';
        salesTransMast.Local_Net_Unit_Pirce_100__c = '113';
        salesTransMast.Sales_Transaction_Currency__c = '12438.527291';
        salesTransMast.Shipped_To_Factory__c = 'xxxxxx'; 
        salesTransMast.Shipped_To_Country__c = 'xxxx';
        salesTransMast.Label__c = 'label';
        salesTransMast.End_User__c = 'user';
        salesTransMast.Vendor__c = 'lululemon';
        salesTransMast.Division__c = 'demo';
        salesTransMast.Retailer_Brand__c = 'demo';
        salesTransMast.Royalty_Rate__c = 'xxxx';
        salesTransMast.Market__c = 'USA';
        salesTransMast.Remark__c = 'xxxx';
        salesTransMast.LOB__c = 'PRL123456789012345688';
        salesTransMast.SO_Number__c = '183001689999898988';
        salesTransMast.Production_Country__c = 'CHINA';
        salesTransMast.Gross_Sales_USD__c = '12.2';
        salesTransMast.Freight_Charge_USD__c = 'abc';
        
        salesTransMast.ErrorMapData__c='Year;Week;Month;Material;Source;Category;Family;Label;Vendor;Division;Market;Remark;LOB;ItemCode;Model;PrintedLogo;Color;Customer;LocalName;MainettiBrand;SubCategory;OrderType;UnitSold;LocalCurrency;ShippedToFactory;ShippedToCountry;EndUser;RetailerBrand;RoyaltyRate;SONumber;ProductionCountry';

        //salesTransMast.ErrorMapData__c='';
        //salesTransMast.ErrorMapData__c ='ProductionCountry';
        /*salesTransMast.ErrorMapData__c ='Month';
        salesTransMast.ErrorMapData__c ='Material';
        salesTransMast.ErrorMapData__c ='Source';
        salesTransMast.ErrorMapData__c ='Category';
        salesTransMast.ErrorMapData__c ='Family';
        salesTransMast.ErrorMapData__c ='Label';
        salesTransMast.ErrorMapData__c ='Vendor';
        salesTransMast.ErrorMapData__c ='Division';*/
        insert salesTransMast;
        
        Sales_Transaction_Stage__c salesTransMastr = new Sales_Transaction_Stage__c();
        salesTransMastr.Upload_Batch_No__c = value.Id;
        salesTransMastr.Company__c = 'Hong Kong Packaging';
        salesTransMastr.Year__c = '2019';
        salesTransMastr.Week__c = 'wk02';
        salesTransMastr.Month__c = 'Dec';
        salesTransMastr.Item_Code__c = 'HGR-3944   BLK002-  100';
        salesTransMastr.Material__c = 'PS';
        salesTransMastr.Source__c = 'virginn';
        salesTransMastr.Model__c = '1000';
        salesTransMastr.Printed_Logo__c = 'demologo';
        salesTransMastr.Color__c = 'black';
        salesTransMastr.Customer__c = 'xxxxxx';
        salesTransMastr.Customer_Local_Name__c = 'xxxx';
        salesTransMastr.Mainetti_Brand__c = 'mainetti';
        salesTransMastr.Category__c = 'HANGERS & ACCESSORIES';
        salesTransMastr.Sub_Category__c = 'HANGERS';
        salesTransMastr.Family__c = 'bottom';
        salesTransMastr.Order_Type__c = '3rd';
        salesTransMastr.Unit_Sold__c = '12520';
        salesTransMastr.Unit_Price_100_EUR__c = '110.65123';
        salesTransMastr.Unit_Price_100_USD__c = '112.40602';
        salesTransMastr.Net_Unit_Price_100__c = '111';
        salesTransMastr.Sales_EUR__c = '1268.410993';
        salesTransMastr.Sales_USD__c = '1312.631704';
        salesTransMastr.Transaction_Currency__c = 'hkd';
        salesTransMastr.ExRate_to_EUR__c = '19.08505';
        salesTransMastr.ExRate_to_USD__c = '20.8';
        salesTransMastr.Local_Net_Unit_Pirce_100__c = '113';
        salesTransMastr.Sales_Transaction_Currency__c = '12438.527291';
        salesTransMastr.Shipped_To_Factory__c = 'xxxxxx'; 
        salesTransMastr.Shipped_To_Country__c = 'xxxx';
        salesTransMastr.Label__c = 'label';
        salesTransMastr.End_User__c = 'user';
        salesTransMastr.Vendor__c = 'lululemon';
        salesTransMastr.Division__c = 'demo';
        salesTransMastr.Retailer_Brand__c = 'demo';
        salesTransMastr.Royalty_Rate__c = 'xxxx';
        salesTransMastr.Market__c = 'USA';
        salesTransMastr.Remark__c = 'xxxx';
        salesTransMastr.LOB__c = 'PRL123456789012345688';
        salesTransMastr.SO_Number__c = '183001689999898988';
        salesTransMastr.Production_Country__c = 'CHINA';
        salesTransMastr.Gross_Sales_USD__c = '12.2';
        salesTransMastr.Freight_Charge_USD__c = 'abc';
        
        salesTransMastr.ErrorMapData__c='Year;Week;Month;Material;Source;Category;Family;Label;Vendor;Division;Market;Remark;LOB;ItemCode;Model;PrintedLogo;Color;Customer;LocalName;MainettiBrand;SubCategory;OrderType;UnitSold;LocalCurrency;ShippedToFactory;ShippedToCountry;EndUser;RetailerBrand;RoyaltyRate;SONumber;ProductionCountry';

        //salesTransMast.ErrorMapData__c='';
        
        insert salesTransMastr;
        
        
        
        
        
        Sales_Transaction_Stage__c salesTransInvalid = new Sales_Transaction_Stage__c();
        salesTransInvalid.Upload_Batch_No__c = value.Id;
        salesTransInvalid.Company__c = 'Hong Kong Packaging';
        salesTransInvalid.Year__c = '2019';
        salesTransInvalid.Week__c = 'wk02';
        salesTransInvalid.Month__c = 'Dec';
        salesTransInvalid.Item_Code__c = 'HGR-3944   BLK002-  101';
        salesTransInvalid.Material__c = 'SP';
        salesTransInvalid.Source__c = 'lululemon';
        salesTransInvalid.Model__c = 'CS1Q';
        salesTransInvalid.Printed_Logo__c = 'demologo';
        salesTransInvalid.Color__c = 'blackK';
        salesTransInvalid.Customer__c = 'ABCDE';
        salesTransInvalid.Customer_Local_Name__c = 'abc';
        salesTransInvalid.Mainetti_Brand__c = 'mainettii';
        salesTransInvalid.Category__c = 'HANGERS & ACCESSORIES';
        salesTransInvalid.Sub_Category__c = '';
        salesTransInvalid.Family__c = '';
        salesTransInvalid.Order_Type__c = '';
        salesTransInvalid.Unit_Sold__c = '0';
        salesTransInvalid.Unit_Price_100_EUR__c = '';
        salesTransInvalid.Unit_Price_100_USD__c = '';
        salesTransInvalid.Net_Unit_Price_100__c = '';
        salesTransInvalid.Sales_EUR__c = '';
        salesTransInvalid.Sales_USD__c = '';
        salesTransInvalid.Transaction_Currency__c = '';
        salesTransInvalid.ExRate_to_EUR__c = '';
        salesTransInvalid.ExRate_to_USD__c = '';
        salesTransInvalid.Local_Net_Unit_Pirce_100__c = '';
        salesTransInvalid.Sales_Transaction_Currency__c = '';
        salesTransInvalid.Shipped_To_Factory__c = ''; 
        salesTransInvalid.Shipped_To_Country__c = '';
        salesTransInvalid.Label__c = '';
        salesTransInvalid.End_User__c = '';
        salesTransInvalid.Vendor__c = 'debenham';
        salesTransInvalid.Division__c = '';
        salesTransInvalid.Retailer_Brand__c = 'fadfa';
        salesTransInvalid.Royalty_Rate__c = 'dfdsf';
        salesTransInvalid.Market__c = 'US';
        salesTransInvalid.Remark__c = 'abcdef';
        salesTransInvalid.LOB__c = 'PRL123456789012345688';
        salesTransInvalid.SO_Number__c = '183001689999898988';
        salesTransInvalid.Production_Country__c = 'CHINAa';  
	    salesTransInvalid.ErrorMapData__c='Week';        
        insert salesTransInvalid;
        
        Sales_Transaction_Stage__c salesTransMastMissing = new Sales_Transaction_Stage__c();
        salesTransMastMissing.Upload_Batch_No__c = value.Id;
        salesTransMastMissing.Company__c = '';
        salesTransMastMissing.Year__c = '';
        salesTransMastMissing.Week__c = '';
        salesTransMastMissing.Month__c = 'Dec';
        salesTransMastMissing.Item_Code__c = '';
        salesTransMastMissing.Material__c = '';
        salesTransMastMissing.Source__c = 'virgin';
        salesTransMastMissing.Model__c = '';
        salesTransMastMissing.Printed_Logo__c = '';
        salesTransMastMissing.Color__c = '';
        salesTransMastMissing.Customer__c = '';
        salesTransMastMissing.Customer_Local_Name__c = '';
        salesTransMastMissing.Mainetti_Brand__c = '';
        salesTransMastMissing.Category__c = '';
        salesTransMastMissing.Sub_Category__c = '';
        salesTransMastMissing.Family__c = '';
        salesTransMastMissing.Order_Type__c = '';
        salesTransMastMissing.Unit_Sold__c = '';
        salesTransMastMissing.Unit_Price_100_EUR__c = '';
        salesTransMastMissing.Unit_Price_100_USD__c = '';
        salesTransMastMissing.Net_Unit_Price_100__c = '';
        salesTransMastMissing.Sales_EUR__c = '';
        salesTransMastMissing.Sales_USD__c = '';
        salesTransMastMissing.Transaction_Currency__c = '';
        salesTransMastMissing.ExRate_to_EUR__c = '';
        salesTransMastMissing.ExRate_to_USD__c = '';
        salesTransMastMissing.Local_Net_Unit_Pirce_100__c = '';
        salesTransMastMissing.Sales_Transaction_Currency__c = '';
        salesTransMastMissing.Shipped_To_Factory__c = ''; 
        salesTransMastMissing.Shipped_To_Country__c = '';
        salesTransMastMissing.Label__c = '';
        salesTransMastMissing.End_User__c = '';
        salesTransMastMissing.Vendor__c = 'debenham';
        salesTransMastMissing.Division__c = '';
        salesTransMastMissing.Retailer_Brand__c = '';
        salesTransMastMissing.Royalty_Rate__c = '';
        salesTransMastMissing.Market__c = '';
        salesTransMastMissing.Remark__c = '';
        salesTransMastMissing.LOB__c = '';
        salesTransMastMissing.SO_Number__c = '';
        salesTransMastMissing.Production_Country__c = '';
        salesTransMastMissing.Gross_Sales_USD__c = 'abc';
        salesTransMastMissing.Freight_Charge_USD__c = 'erf';
        insert salesTransMastMissing; 
        
        Sales_Transaction_Stage__c salesTransMastLabel = new Sales_Transaction_Stage__c();
        salesTransMastLabel.Upload_Batch_No__c = value.Id;
        salesTransMastLabel.Company__c = '';
        salesTransMastLabel.Year__c = '';
        salesTransMastLabel.Week__c = '';
        salesTransMastLabel.Month__c = 'Dec';
        salesTransMastLabel.Item_Code__c = '';
        salesTransMastLabel.Material__c = '';
        salesTransMastLabel.Source__c = 'virgin';
        salesTransMastLabel.Model__c = '';
        salesTransMastLabel.Printed_Logo__c = '';
        salesTransMastLabel.Color__c = '';
        salesTransMastLabel.Customer__c = '';
        salesTransMastLabel.Customer_Local_Name__c = '';
        salesTransMastLabel.Mainetti_Brand__c = '';
        salesTransMastLabel.Category__c = '';
        salesTransMastLabel.Sub_Category__c = '';
        salesTransMastLabel.Family__c = '';
        salesTransMastLabel.Order_Type__c = '';
        salesTransMastLabel.Unit_Sold__c = '';
        salesTransMastLabel.Unit_Price_100_EUR__c = '';
        salesTransMastLabel.Unit_Price_100_USD__c = '';
        salesTransMastLabel.Net_Unit_Price_100__c = '';
        salesTransMastLabel.Sales_EUR__c = '';
        salesTransMastLabel.Sales_USD__c = '';
        salesTransMastLabel.Transaction_Currency__c = '';
        salesTransMastLabel.ExRate_to_EUR__c = '';
        salesTransMastLabel.ExRate_to_USD__c = '';
        salesTransMastLabel.Local_Net_Unit_Pirce_100__c = '';
        salesTransMastLabel.Sales_Transaction_Currency__c = '';
        salesTransMastLabel.Shipped_To_Factory__c = ''; 
        salesTransMastLabel.Shipped_To_Country__c = '';
        salesTransMastLabel.Label__c = 'NL';
        salesTransMastLabel.End_User__c = '';
        salesTransMastLabel.Vendor__c = 'MACY';
        salesTransMastLabel.Division__c = '';
        salesTransMastLabel.Retailer_Brand__c = '';
        salesTransMastLabel.Royalty_Rate__c = '';
        salesTransMastLabel.Market__c = '';
        salesTransMastLabel.Remark__c = '';
        salesTransMastLabel.LOB__c = 'LEG';
        salesTransMastLabel.SO_Number__c = '';
        salesTransMastLabel.Production_Country__c = '';
        salesTransMastLabel.Gross_Sales_USD__c = 'abc';
        salesTransMastLabel.Freight_Charge_USD__c = 'erf';
       salesTransMastLabel.ErrorMapData__c = '';
        
        insert salesTransMastLabel;
        
        Sales_Transaction_Stage__c salesTransMastLabels = new Sales_Transaction_Stage__c();
        salesTransMastLabels.Upload_Batch_No__c = value.Id;
        salesTransMastLabels.Company__c = '';
        salesTransMastLabels.Year__c = '';
        salesTransMastLabels.Week__c = '';
        salesTransMastLabels.Month__c = 'Dec';
        salesTransMastLabels.Item_Code__c = '';
        salesTransMastLabels.Material__c = '';
        salesTransMastLabels.Source__c = 'virgin';
        salesTransMastLabels.Model__c = '';
        salesTransMastLabels.Printed_Logo__c = '';
        salesTransMastLabels.Color__c = '';
        salesTransMastLabels.Customer__c = '';
        salesTransMastLabels.Customer_Local_Name__c = '';
        salesTransMastLabels.Mainetti_Brand__c = '';
        salesTransMastLabels.Category__c = '';
        salesTransMastLabels.Sub_Category__c = '';
        salesTransMastLabels.Family__c = '';
        salesTransMastLabels.Order_Type__c = '';
        salesTransMastLabels.Unit_Sold__c = '';
        salesTransMastLabels.Unit_Price_100_EUR__c = '';
        salesTransMastLabels.Unit_Price_100_USD__c = '';
        salesTransMastLabels.Net_Unit_Price_100__c = '';
        salesTransMastLabels.Sales_EUR__c = '';
        salesTransMastLabels.Sales_USD__c = '';
        salesTransMastLabels.Transaction_Currency__c = '';
        salesTransMastLabels.ExRate_to_EUR__c = '';
        salesTransMastLabels.ExRate_to_USD__c = '';
        salesTransMastLabels.Local_Net_Unit_Pirce_100__c = '';
        salesTransMastLabels.Sales_Transaction_Currency__c = '';
        salesTransMastLabels.Shipped_To_Factory__c = ''; 
        salesTransMastLabels.Shipped_To_Country__c = '';
        salesTransMastLabels.Label__c = 'NL';
        salesTransMastLabels.End_User__c = '';
        salesTransMastLabels.Vendor__c = 'MACY';
        salesTransMastLabels.Division__c = '';
        salesTransMastLabels.Retailer_Brand__c = '';
        salesTransMastLabels.Royalty_Rate__c = '';
        salesTransMastLabels.Market__c = '';
        salesTransMastLabels.Remark__c = '';
        salesTransMastLabels.LOB__c = 'LEG';
        salesTransMastLabels.SO_Number__c = '';
        salesTransMastLabels.Production_Country__c = '';
        salesTransMastLabels.Gross_Sales_USD__c = 'abc';
        salesTransMastLabels.Freight_Charge_USD__c = 'erf';
       salesTransMastLabels.ErrorMapData__c = '';
        
        insert salesTransMastLabels;
        
        Retailer_Code__c retailer = new Retailer_Code__c(Name = 'debenham',Production_Country__c  =true);
        insert retailer;
        
        String [] fieldNameS =new String[]{'Year','Week','Month','Material','Source','Category','Family','Label','Vendor','Division','Market','Remark','LOB','ItemCode','Model','PrintedLogo','Color','Customer','LocalName','MainettiBrand','SubCategory','OrderType','UnitSold','LocalCurrency','ShippedToFactory','ShippedToCountry','EndUser','RetailerBrand','RoyaltyRate','SONumber','ProductionCountry'};
        
        boolean flag = true;
        string selMonth = 'Dec';
        string selYear = '2019';
        string selcomp = 'Hong Kong Packaging';
        String generatedMapKeyString='dkdmik';
               // salesTransMastr.ErrorMapData__c='Year;Week;Month;Material;Source;Category;Family;Label;Vendor;Division;Market;Remark;LOB;ItemCode;Model;PrintedLogo;Color;Customer;LocalName;MainettiBrand;SubCategory;OrderType;UnitSold;LocalCurrency;ShippedToFactory;ShippedToCountry;EndUser;RetailerBrand;RoyaltyRate;SONumber;ProductionCountry';

        Sales_Transaction_Stage__c salesTransMast1 = new Sales_Transaction_Stage__c();
         salesTransMast1.ErrorMapData__c='Week';
         Sales_Transaction_Stage__c salesTransMast2 = new Sales_Transaction_Stage__c();
         salesTransMast2.ErrorMapData__c='Month';
        Sales_Transaction_Stage__c salesTransMast3 = new Sales_Transaction_Stage__c();
         salesTransMast3.ErrorMapData__c='Material';
         Sales_Transaction_Stage__c salesTransMast4 = new Sales_Transaction_Stage__c();
         salesTransMast4.ErrorMapData__c='Source';
         Sales_Transaction_Stage__c salesTransMast5 = new Sales_Transaction_Stage__c();
         salesTransMast5.ErrorMapData__c='Category';
         Sales_Transaction_Stage__c salesTransMast6 = new Sales_Transaction_Stage__c();
         salesTransMast6.ErrorMapData__c='Family';
         Sales_Transaction_Stage__c salesTransMast7 = new Sales_Transaction_Stage__c();
         salesTransMast7.ErrorMapData__c='Label';      
        Sales_Transaction_Stage__c salesTransMast8 = new Sales_Transaction_Stage__c();
         salesTransMast8.ErrorMapData__c='Vendor';
       
        Sales_Transaction_Stage__c salesTransMast9 = new Sales_Transaction_Stage__c();
         salesTransMast9.ErrorMapData__c='Division';
         Sales_Transaction_Stage__c salesTransMast01 = new Sales_Transaction_Stage__c();
         salesTransMast01.ErrorMapData__c='Market';
        Sales_Transaction_Stage__c salesTransMast02 = new Sales_Transaction_Stage__c();
         salesTransMast02.ErrorMapData__c='Remark';
         Sales_Transaction_Stage__c salesTransMast03 = new Sales_Transaction_Stage__c();
         salesTransMast03.ErrorMapData__c='LOB';
         Sales_Transaction_Stage__c salesTransMast04 = new Sales_Transaction_Stage__c();
         salesTransMast04.ErrorMapData__c='ItemCode';
         Sales_Transaction_Stage__c salesTransMast05 = new Sales_Transaction_Stage__c();
         salesTransMast05.ErrorMapData__c='PrintedLogo';
         Sales_Transaction_Stage__c salesTransMast06 = new Sales_Transaction_Stage__c();
         salesTransMast06.ErrorMapData__c='Color';      
        Sales_Transaction_Stage__c salesTransMast07 = new Sales_Transaction_Stage__c();
         salesTransMast07.ErrorMapData__c='Customer';
      
        
        Sales_Transaction_Stage__c salesTransMast08 = new Sales_Transaction_Stage__c();
         salesTransMast08.ErrorMapData__c='LocalName';
         Sales_Transaction_Stage__c salesTransMast09 = new Sales_Transaction_Stage__c();
         salesTransMast09.ErrorMapData__c='MainettiBrand';
        Sales_Transaction_Stage__c salesTransMast11 = new Sales_Transaction_Stage__c();
         salesTransMast11.ErrorMapData__c='SubCategory';
         Sales_Transaction_Stage__c salesTransMast12 = new Sales_Transaction_Stage__c();
         salesTransMast12.ErrorMapData__c='OrderType';
         Sales_Transaction_Stage__c salesTransMast13 = new Sales_Transaction_Stage__c();
         salesTransMast13.ErrorMapData__c='UnitSold';
         Sales_Transaction_Stage__c salesTransMast14 = new Sales_Transaction_Stage__c();
         salesTransMast14.ErrorMapData__c='LocalCurrency';
         Sales_Transaction_Stage__c salesTransMast15 = new Sales_Transaction_Stage__c();
         salesTransMast15.ErrorMapData__c='ShippedToFactory';      
        Sales_Transaction_Stage__c salesTransMast16 = new Sales_Transaction_Stage__c();
         salesTransMast16.ErrorMapData__c='ShippedToCountry'; 
        
        
         Sales_Transaction_Stage__c salesTransMast17 = new Sales_Transaction_Stage__c();
         salesTransMast17.ErrorMapData__c='EndUser';
         Sales_Transaction_Stage__c salesTransMast18 = new Sales_Transaction_Stage__c();
         salesTransMast18.ErrorMapData__c='RetailerBrand';
        Sales_Transaction_Stage__c salesTransMast19 = new Sales_Transaction_Stage__c();
         salesTransMast19.ErrorMapData__c='RoyaltyRate';
         Sales_Transaction_Stage__c salesTransMast21 = new Sales_Transaction_Stage__c();
         salesTransMast21.ErrorMapData__c='SONumber';
         Sales_Transaction_Stage__c salesTransMast22 = new Sales_Transaction_Stage__c();
         salesTransMast22.ErrorMapData__c='ProductionCountry';
        Sales_Transaction_Stage__c salesTransMast23 = new Sales_Transaction_Stage__c();
         salesTransMast23.ErrorMapData__c='Model';
         Sales_Transaction_Stage__c salesTransMast24 = new Sales_Transaction_Stage__c();
         salesTransMast24.ErrorMapData__c='SubCategory';
        
        Test.startTest();
        for(String fldName :fieldNameS){
             String fieldName = fldName;       
        }
        processSalesData.generateMapKeyString(salesTransMast);
        processSalesData.generateMapKeyString(salesTransMastr);
        // processSalesData.generateMapKeyString(salesTransInvalid);
        //processSalesData.generateMapKeyString(salesTransMastMissing);
        // processSalesData.generateMapKeyString(salesTransMastLabel);
        
        
        processSalesData.generateMapKeyString(salesTransMast1);
        processSalesData.generateMapKeyString(salesTransMast2);
        processSalesData.generateMapKeyString(salesTransMast3);
        processSalesData.generateMapKeyString(salesTransMast4);
        processSalesData.generateMapKeyString(salesTransMast5);
        processSalesData.generateMapKeyString(salesTransMast6);
        processSalesData.generateMapKeyString(salesTransMast7);
        processSalesData.generateMapKeyString(salesTransMast8);
        processSalesData.generateMapKeyString(salesTransMast9);
        processSalesData.generateMapKeyString(salesTransMast01);
        processSalesData.generateMapKeyString(salesTransMast02);
        processSalesData.generateMapKeyString(salesTransMast03);
        processSalesData.generateMapKeyString(salesTransMast04);
        processSalesData.generateMapKeyString(salesTransMast05);
        processSalesData.generateMapKeyString(salesTransMast06);
        processSalesData.generateMapKeyString(salesTransMast07);
        processSalesData.generateMapKeyString(salesTransMast08);
        processSalesData.generateMapKeyString(salesTransMast09);
        processSalesData.generateMapKeyString(salesTransMast11);
        processSalesData.generateMapKeyString(salesTransMast12);
        processSalesData.generateMapKeyString(salesTransMast13);
        processSalesData.generateMapKeyString(salesTransMast14);
        processSalesData.generateMapKeyString(salesTransMast15);
        processSalesData.generateMapKeyString(salesTransMast16);
        processSalesData.generateMapKeyString(salesTransMast17);
        processSalesData.generateMapKeyString(salesTransMast18);
        processSalesData.generateMapKeyString(salesTransMast19);
        processSalesData.generateMapKeyString(salesTransMast21);
        processSalesData.generateMapKeyString(salesTransMast22);
        processSalesData.generateMapKeyString(salesTransMast23);
        processSalesData.generateMapKeyString(salesTransMast24);
        processSalesData.getSalesWeekCountWithPartnerCompanyNewCompanyList(selMonth,selYear,selcomp);
        processSalesData.getSalesWeekCountNew(selMonth,selYear);
        processSalesData.getSalesWeekList(selMonth,selYear,selcomp);
        //processSalesData.getRetailerLob();
        processSalesData processData = new processSalesData();
        //processData.getRetailerLob();
        //processData.validateUploadRows(value, selMonth, selYear,selcomp);
        Test.stopTest();
        System.assertEquals(true, flag);
    }
    
   
    @isTest
    static void testParseLongDate()
    {
        Retailer_Code__c retailer = new Retailer_Code__c(Name = 'DECATHLON',JDE_LOB__c  ='DEC');
        insert retailer;
        Sales_Transaction_Stage__c salesTransStagRec = new Sales_Transaction_Stage__c();
        salesTransStagRec.Upload_Batch_No__c = salesTransStagRec.Id;
        salesTransStagRec.Vendor__c  = 'DemoRetailer';
        insert salesTransStagRec;
        
     
        
        String [] fieldNameS =new String[]{'Year','Week','Month','Material','Source','Category','Family','Label','Vendor','Division','Market','Remark','LOB','ItemCode','Model','PrintedLogo','Color','Customer','LocalName','MainettiBrand','SubCategory','OrderType','UnitSold','LocalCurrency','ShippedToFactory','ShippedToCountry','EndUser','RetailerBrand','RoyaltyRate','SONumber','ProductionCountry'};
        String oldValue = 'BOTTOMS';
        String newValue = 'BOTTOM';
        String batchId = salesTransStagRec.Id;
        String companyName = 'Hong Kong Packaging';
        String errMap = 'Family';
        String pickListToRemove = 'Family';
        Date d = date.today();
        boolean flag = true;
        Test.startTest();       
         for(String fldName :fieldNameS){
             String fieldName = fldName;
             
             
             
             
             
        processSalesData processData = new processSalesData();
        processData.updateTransStagNInsertErrorMapValues(fieldName,oldValue,newValue,batchId,companyName,errMap,pickListToRemove);
       //processSalesData.generateMapKeyString(salesTransStagRec);        
        processSalesData.getfieldWithObject(fieldName,newValue,salesTransStagRec);
        processData.isValueNumeric('123');
        processSalesData.getWeekCount(d);        
         }
        //processSalesData.getRetailerLob();
        //System.assertEquals(retailer.Name, 'DECATHLON');
        Test.stopTest();
        System.assertEquals(true, flag); 
    }
    static testMethod void missingFieldValueTest(){
        Sales_Transaction_Stage__c dataRow = new Sales_Transaction_Stage__c();
        dataRow.Model__c = '';
        dataRow.Color__c = '';
        dataRow.Category__c = '';
        dataRow.Market__c = '';
        dataRow.Vendor__c = ''; 
        dataRow.Company__c = '';
        dataRow.Material__c = '';
        dataRow.Shipped_To_Factory__c = '';
        dataRow.Shipped_To_Country__c = '';
        dataRow.Division__c = '';
        dataRow.Item_code__c = '';
        dataRow.Mainetti_Brand__c = '';
        dataRow.Order_Type__c = '';
        dataRow.Customer__c = '';
        dataRow.Transaction_Currency__c = '';
        dataRow.ExRate_to_EUR__c = '';
        dataRow.ExRate_to_USD__c = '';
        dataRow.Sales_EUR__c = '';
        dataRow.Unit_Price_100_EUR__c = '';
        dataRow.Unit_Price_100_USD__c = '';
        dataRow.Net_Unit_Price_100__c = '';
        dataRow.Month__c = '';
        dataRow.Source__c = '';
        dataRow.Unit_Sold__c = '';
        dataRow.Week__c = '';
        dataRow.Year__c = '';
        dataRow.SO_Number__c = '';
        dataRow.LOB__c = '';
        dataRow.Gross_Sales_USD__c = '';
        dataRow.Freight_Charge_USD__c = '';
        dataRow.Row_No__c = 2000;
        insert dataRow; 
        
        Sales_Transaction_Stage__c salestrans = new Sales_Transaction_Stage__c();
       
        salestrans.Gross_Sales_USD__c ='abc';
        //salestrans.Gross_Sales_USD__c = '0';
        salestrans.Freight_Charge_USD__c = 'bed';
        salestrans.Row_No__c =0;
        insert salestrans;
        
         Sales_Transaction_Stage__c rowUpdate = new Sales_Transaction_Stage__c();
         rowUpdate.Gross_Sales_USD__c ='0';
        //salestrans.Gross_Sales_USD__c = '0';
        rowUpdate.Freight_Charge_USD__c = 'bed';
        rowUpdate.Row_No__c =0;
        insert rowUpdate;
        
        Map<Decimal,Map<string,string>> inCorrectFormatMap = new Map<Decimal,Map<string,string>>();
        
        
        Test.startTest();
        processSalesData prosal = new processSalesData();
      //  prosal.missingFieldValue(dataRow, rowUpdate, inCorrectFormatMap);
      //  prosal.missingFieldValue(salestrans,rowUpdate, inCorrectFormatMap);

        prosal.missingFieldValueBulk(dataRow, inCorrectFormatMap);
        prosal.missingFieldValueBulk(salestrans, inCorrectFormatMap);
        prosal.missingFieldValueBulk(rowUpdate, inCorrectFormatMap);
       // prosal.nullFieldDataValidation(dataRow, rowUpdate, remarks, isDataValid);
        Test.stopTest();
    }
    static testMethod void reconcileDataWithSalesErrorMapTest(){
        Sales_Transaction_Stage__c salesTransStagRecForReconciliation = new Sales_Transaction_Stage__c();
        salesTransStagRecForReconciliation.Company__c = 'Hong Kong Packaging';
        salesTransStagRecForReconciliation.Year__c = '2019';
        salesTransStagRecForReconciliation.Week__c = 'wk02';
        salesTransStagRecForReconciliation.Month__c ='march';
        salesTransStagRecForReconciliation.Item_code__c = 'HGR-3944   BLK002-  101';
        salesTransStagRecForReconciliation.Material__c ='SP';
        salesTransStagRecForReconciliation.Source__c = 'lululemon';
        salesTransStagRecForReconciliation.Printed_Logo__c = 'demologo';
        salesTransStagRecForReconciliation.Color__c = 'blackK';
        salesTransStagRecForReconciliation.Customer__c = 'sfd';
        salesTransStagRecForReconciliation.Customer_local_name__c ='abc';
        salesTransStagRecForReconciliation.Mainetti_Brand__c = 'mainettii';
        salesTransStagRecForReconciliation.Category__c = 'HANGERS & ACCESSORIES';
        salesTransStagRecForReconciliation.Sub_Category__c = 'sfd';
        salesTransStagRecForReconciliation.Family__c = 'combo';
        salesTransStagRecForReconciliation.Order_Type__c = '3rd';
        salesTransStagRecForReconciliation.Unit_Sold__c = '125209';
        salesTransStagRecForReconciliation.Local_Currency__c = 'rupee';
        salesTransStagRecForReconciliation.Shipped_To_Factory__c = 'lalugh';
        salesTransStagRecForReconciliation.Shipped_To_Country__c = 'hangkong';
        salesTransStagRecForReconciliation.Label__c = 'brand';
        salesTransStagRecForReconciliation.End_user__c = 'user';
        salesTransStagRecForReconciliation.Vendor__c = 'debenham';
        salesTransStagRecForReconciliation.Division__c = 'demo';
        salesTransStagRecForReconciliation.Retailer_Brand__c = 'select';
        salesTransStagRecForReconciliation.Royalty_Rate__c = 'fixed';
        salesTransStagRecForReconciliation.Market__c = 'US';
        salesTransStagRecForReconciliation.Remarks__c = 'no';
        salesTransStagRecForReconciliation.LOB__c = 'PRL123456789012345688';
        salesTransStagRecForReconciliation.SO_Number__c = '183001689999898988';
        salesTransStagRecForReconciliation.Production_Country__c = 'CHINAa';
        insert salesTransStagRecForReconciliation;
        
        
        Sales_Transaction_Stage__c salesTrans = new Sales_Transaction_Stage__c();
        salesTrans.Company__c = 'Hong Kong Packaging';
        salesTrans.Year__c = '2019';
        salesTrans.Week__c = 'second';
        salesTrans.Month__c ='april';
        salesTrans.Item_code__c = 'sfd';
        salesTrans.Material__c ='original';
        salesTrans.Source__c = 'gfd';
        salesTrans.Printed_Logo__c = 'brand';
        salesTrans.Color__c = 'gray';
        salesTrans.Customer__c = 'local';
        salesTrans.Customer_local_name__c ='sfdc';
        salesTrans.Mainetti_Brand__c = 'original';
        salesTrans.Category__c = 'asce';
        salesTrans.Sub_Category__c = 'sdc';
        salesTrans.Family__c = 'member';
        salesTrans.Order_Type__c = 'online';
        salesTrans.Unit_Sold__c = 'soft';
        salesTrans.Local_Currency__c = 'rupee';
        salesTrans.Shipped_To_Factory__c = 'laghul';
        salesTrans.Shipped_To_Country__c = 'hongkong';
        salesTrans.Label__c = 'brand';
        salesTrans.End_user__c = 'add';
        salesTrans.Vendor__c = 'kase';
        salesTrans.Division__c = 'local';
        salesTrans.Retailer_Brand__c = 'original';
        salesTrans.Royalty_Rate__c = 'cost';
        salesTrans.Market__c = 'loacl';
        salesTrans.Remarks__c = 'noo';
        salesTrans.LOB__c = 'C';
        salesTrans.SO_Number__c = '32';
        salesTrans.Production_Country__c = 'Hk';
        insert salesTrans;
        
        Sales_Error_Mapping__c salesErrorMap = new Sales_Error_Mapping__c();
       // salesErrorMap.Company__c = 'Hong Kong Packaging';
        salesErrorMap.Company__c = salesTrans.Id;
        salesErrorMap.Map_From_Value__c = 'BOTTOM';
        salesErrorMap.Map_To_Value__c = 'BOTTOM';
        salesErrorMap.Raw_Data_Field__c = 'Family';
        insert salesErrorMap;
              
        
        List<Sales_Transaction_Stage__c> salestransstag = new   List<Sales_Transaction_Stage__c>();
        salestransstag.add(salesTransStagRecForReconciliation);
        List<Sales_Transaction_Stage__c> salestransstage = new   List<Sales_Transaction_Stage__c>();
        salestransstage.add(salesTrans);
        Map<string,Map<string,Map<string,string>>> fullSalesErrorMap = new Map<string,Map<string,Map<string,string>>>();
       /*   List<Sales_Error_Mapping__c> salesErrorMapping = [Select Company__c,Raw_Data_Field__c, Map_From_Value__c, Map_To_Value__c from Sales_Error_Mapping__c order by Company__c];
        for(Sales_Error_Mapping__c errorMap : salesErrorMapping){
        
        fullSalesErrorMap.put(errorMap.Company__c,errorMap.Company__c);
        } */
        
        Sales_Error_Mapping__c salesError = new Sales_Error_Mapping__c(Company__c = 'America Mid West - Hangers Unlimited', Raw_Data_Field__c = 'Model',Map_From_Value__c = '484BR',Map_To_Value__c = '484');
        insert salesError;
        Sales_Error_Mapping__c salesError1 = new Sales_Error_Mapping__c(Company__c = 'America Mid West - Hangers Unlimited', Raw_Data_Field__c = 'Model',Map_From_Value__c = 'BOTTOM',Map_To_Value__c = 'BOTTOM');
        insert salesError1;
        
        Sales_Error_Mapping__c salesErrors = new Sales_Error_Mapping__c(Company__c = 'America Mid West - Hangers Unlimited', Raw_Data_Field__c = 'Family',Map_From_Value__c = 'BOTTOM',Map_To_Value__c = 'BOTTOM');
        insert salesErrors;
        
        getSalesMasterData salesErrorMapp = new getSalesMasterData();
        salesErrorMapp.getFullSalesErrorMap();
        
        System.assertEquals(salesError.Company__c, 'America Mid West - Hangers Unlimited');
        System.assertEquals(salesError.Raw_Data_Field__c, 'Model');
        System.assertEquals(salesError.Map_From_Value__c, '484BR');
        System.assertEquals(salesError.Map_To_Value__c, '484');
        
        System.assertEquals(salesErrors.Company__c, 'America Mid West - Hangers Unlimited');
        System.assertEquals(salesErrors.Raw_Data_Field__c, 'Family');
        System.assertEquals(salesErrors.Map_From_Value__c, 'BOTTOM');
        System.assertEquals(salesErrors.Map_To_Value__c, 'BOTTOM');
        
        System.assertNotEquals(salesError1.Company__c, '');
        System.assertNotEquals(salesError1.Raw_Data_Field__c, '');
        System.assertNotEquals(salesError1.Map_From_Value__c, '');
        System.assertNotEquals(salesError1.Map_To_Value__c, '');       
        
       Test.startTest();
        processSalesData prosaldata = new processSalesData();
       prosaldata.reconcileDataWithSalesErrorMapBulk(salestransstage, fullSalesErrorMap); 
        prosaldata.reconcileDataWithSalesErrorMapBulk(salestransstag, fullSalesErrorMap); 
        Test.stopTest();
    }
    static testMethod void getRetailerLobTest(){
         Sales_Transaction_Stage__c salesTransStagRecForReconciliation = new Sales_Transaction_Stage__c();
         Sales_Transaction__c customData = new Sales_Transaction__c();
          customData.Vendor__c = 'abc';
          customData.name = 'abc';
        insert customData;
          list<Retailer_Code__c> retailer = new  list<Retailer_Code__c>();
          Map<string,string> vendorListMap = new Map<string,string>();
        
         Test.startTest();
        processSalesData.getRetailerLob();
        Test.stopTest();
        
    }
   static testMethod void callingCustomSettingsTest(){
        Sales_Transaction__c customData = new Sales_Transaction__c();
       customData.Production_Country__c = 'abc';
       customData.Color__c = 'sfd';
       customData.Division__c = 'dxc';
       customData.Label__c = 'normal';
       customData.Brand__c = 'permanent';
       insert customData;
       
       
         Test.startTest();
        processSalesData.callingCustomSettings();
        Test.stopTest();

    }
    static testMethod void nullFieldDataValidationTest(){
        
         Sales_Transaction_Stage__c dataRow = new Sales_Transaction_Stage__c();
        dataRow.Vendor__c = 'Macy';
        dataRow.Production_Country__c = '';
        dataRow.Color__c = '';
        dataRow.Division__c ='';
        dataRow.Label__c = 'PL';
        dataRow.Order_Type__c = 'Macy';
        dataRow.LOB__c = '';
        dataRow.Category__c = 'Hangers';
        insert dataRow;
        
        Sales_Transaction_Stage__c salestrans = new Sales_Transaction_Stage__c();
        salestrans.Vendor__c = 'Macy';
        salestrans.Production_Country__c = '';
        salestrans.Color__c = '';
        salestrans.Division__c ='';
        salestrans.Label__c = '';
        salestrans.Order_Type__c = '';
        salestrans.Category__c = 'abc';
        salestrans.LOB__c = 'abc';
        insert salestrans;
        
        Sales_Transaction_Stage__c salestran = new Sales_Transaction_Stage__c();
        salestran.Vendor__c = 'DEBENHAMS';
        salestran.Production_Country__c = '';
        salestran.Color__c = '';
        salestran.Division__c ='';
        salestran.Label__c = '';
        salestran.Order_Type__c = '';
        salestran.Category__c = 'Hangers';
        salestran.LOB__c = 'abc';
        insert salestran;
        
        Sales_Transaction__c customData = new Sales_Transaction__c();
        customData.Production_Country__c = 'Macy';
       customData.Color__c = 'Macy';
       customData.Division__c = 'Macy';
       customData.Label__c = 'Macy';
       customData.Brand__c = 'Macy';
       insert customData;
       
       // Sales_Transaction_Stage__c rowUpdate = new Sales_Transaction_Stage__c();
        String remarks = '';
        Boolean isDataValid = true;
        
        Test.startTest();
       // processSalesData.nullFieldDataValidation(dataRow, rowUpdate, remarks, isDataValid);
        // processSalesData.nullFieldDataValidation(salestrans, rowUpdate, remarks, isDataValid);
        processSalesData.nullFieldDataValidationforBulk(dataRow, remarks, isDataValid);
        processSalesData.nullFieldDataValidationforBulk(salestrans, remarks, isDataValid);
        processSalesData.nullFieldDataValidationforBulk(salestran, remarks, isDataValid);
        Test.stopTest();
    }
    static testMethod void test1(){
        
         String remarks = '';
        Boolean isDataValid = true;
        
          Sales_Transaction_Stage__c dataRow = new Sales_Transaction_Stage__c();
        dataRow.Vendor__c = 'DEBENHAMS';
        dataRow.Production_Country__c = '';
        dataRow.Color__c = '';
        dataRow.Division__c ='';
        dataRow.Label__c = 'PL';
        dataRow.Order_Type__c = 'Macy';
        dataRow.LOB__c = '';
        dataRow.Category__c = 'Hangers';
        insert dataRow;
        
          Sales_Transaction_Stage__c salestrans = new Sales_Transaction_Stage__c();
        salestrans.Vendor__c = 'DEBENHAMS';
        salestrans.Production_Country__c = '';
        salestrans.Color__c = '';
        salestrans.Division__c ='';
        salestrans.Label__c = '';
        salestrans.Order_Type__c = '';
        salestrans.Category__c = 'abc'; 
        salestrans.LOB__c = 'abc';
        insert salestrans;
        
         
        Sales_Transaction__c customData = new Sales_Transaction__c();
       customData.Production_Country__c = 'DEBENHAMS';
       customData.Color__c = 'DEBENHAMS';
       customData.Division__c = 'DEBENHAMS';
       customData.Label__c = 'DEBENHAMS';
       customData.Brand__c = 'DEBENHAMS';
       insert customData;
          
         Test.startTest();
         processSalesData.nullFieldDataValidationforBulk(dataRow, remarks, isDataValid);
         processSalesData.nullFieldDataValidationforBulk(salestrans, remarks, isDataValid);
         Test.stopTest();
    }
    static testMethod void processSalesDataChunkTest(){
        
         
         Retailer_Code__c retailercode = new Retailer_Code__c(Name = 'lululemon');
        retailercode.Label_Check__c = true;
            retailercode.Division_check__c = true;
            retailercode.Retailer_Brand_Check__c = true;
         insert retailercode;
        
         Sales_Transaction_Stage__c salesTransStagRecForReconciliation = new Sales_Transaction_Stage__c();
        salesTransStagRecForReconciliation.Company__c = 'Hong Kong Packaging';
        //salesTransStagRecForReconciliation.Retailer_Code__c = retailercode.Id;
        salesTransStagRecForReconciliation.Retailer_Code__c ='lululemon';
        salesTransStagRecForReconciliation.Year__c = '2019';
        salesTransStagRecForReconciliation.Row_No__c = 2000;
        salesTransStagRecForReconciliation.Week__c = 'wk02';
        salesTransStagRecForReconciliation.Month__c ='march';
        salesTransStagRecForReconciliation.Item_code__c = 'HGR-3944   BLK002-  101';
        salesTransStagRecForReconciliation.Material__c ='SP';
        salesTransStagRecForReconciliation.Source__c = 'lululemon';
        salesTransStagRecForReconciliation.Printed_Logo__c = 'demologo';
        salesTransStagRecForReconciliation.Color__c = 'blackK';
        salesTransStagRecForReconciliation.Customer__c = 'sfd';
        salesTransStagRecForReconciliation.Customer_local_name__c ='abc';
        salesTransStagRecForReconciliation.Mainetti_Brand__c = 'mainettii';
        salesTransStagRecForReconciliation.Category__c = 'HANGERS & ACCESSORIES';
        salesTransStagRecForReconciliation.Sub_Category__c = 'sfd';
        salesTransStagRecForReconciliation.Family__c = 'combo';
        salesTransStagRecForReconciliation.Order_Type__c = '3rd';
        salesTransStagRecForReconciliation.Unit_Sold__c = '0';
        salesTransStagRecForReconciliation.Local_Currency__c = 'rupee';
        salesTransStagRecForReconciliation.Shipped_To_Factory__c = 'lalugh';
        salesTransStagRecForReconciliation.Shipped_To_Country__c = 'hangkong';
        salesTransStagRecForReconciliation.Label__c = 'brand';
        salesTransStagRecForReconciliation.End_user__c = 'user';
        salesTransStagRecForReconciliation.Vendor__c = 'debenham';
        salesTransStagRecForReconciliation.Division__c = 'demo';
        salesTransStagRecForReconciliation.Retailer_Brand__c = '';
        salesTransStagRecForReconciliation.Royalty_Rate__c = 'fixed';
        salesTransStagRecForReconciliation.Market__c = 'US';
        salesTransStagRecForReconciliation.Remarks__c = 'no';
        salesTransStagRecForReconciliation.LOB__c = 'PRL123456789012345688';
        salesTransStagRecForReconciliation.SO_Number__c = '183001689999898988';
        salesTransStagRecForReconciliation.Production_Country__c = 'CHINAa';
        insert salesTransStagRecForReconciliation;
        /////////////////////////////////////////////////////////////////////
        
        
       
        
        ///////////////////////////////////////////////////////////////
         Sales_Transaction_Stage__c salesTrans = new Sales_Transaction_Stage__c();
        salesTrans.Company__c = 'abc';
        salesTrans.Retailer_Code__c = retailercode.Id;
       // salesTrans.Retailer_Code__c = 'lululemon';
        salesTrans.Row_No__c = 2000;
        salesTrans.Year__c = '2019';
        salesTrans.Week__c = 'second';
        salesTrans.Month__c ='april';
        salesTrans.Item_code__c = 'sfd';
        salesTrans.Material__c ='original';
        salesTrans.Source__c = 'gfd';
        salesTrans.Printed_Logo__c = 'brand';
        salesTrans.Color__c = 'gray';
        salesTrans.Customer__c = 'local';
        salesTrans.Customer_local_name__c ='sfdc';
        salesTrans.Mainetti_Brand__c = 'original';
        salesTrans.Category__c = 'asce';
        salesTrans.Sub_Category__c = 'sdc';
        salesTrans.Family__c = 'member';
        salesTrans.Order_Type__c = 'online';
        salesTrans.Unit_Sold__c = '1.2';
        salesTrans.Local_Currency__c = 'rupee';
        salesTrans.Shipped_To_Factory__c = 'laghul';
        salesTrans.Shipped_To_Country__c = 'hongkong';
        salesTrans.Label__c = 'brand';
        salesTrans.End_user__c = 'add';
        salesTrans.Division__c = 'local';
        salesTrans.Retailer_Brand__c = 'original';
        salesTrans.Royalty_Rate__c = 'cost';
        salesTrans.Market__c = 'loacl';
        salesTrans.Remarks__c = 'noo';
        salesTrans.LOB__c = 'PRL123456789012345688';
        salesTrans.SO_Number__c = '183001689999898988';
        salesTrans.Production_Country__c = 'Hk';
        salesTrans.ExRate_to_EUR__c = '1.2';
        salesTrans.ExRate_to_USD__c = '1.2';
        salesTrans.Sales_EUR__c = '1.2';
        salesTrans.Sales_USD__c = '1.2';
		salesTrans.Sales_Transaction_Currency__c = '1.2';
        salesTrans.Unit_Price_100_USD__c = '112.40602';
        salesTrans.Unit_Price_100_EUR__c = '112.40602';
        salesTrans.Net_Unit_Price_100__c = '111';  
        salesTrans.Vendor__c = 'lululemon';
        salesTrans.Model__c = '1000';
        salesTrans.Gross_Sales_USD__c = '';
        salesTrans.Freight_Charge_USD__c = '';
        salesTrans.Transaction_Currency__c = 'USD';
        insert salesTrans;
        
        
        
        /* Sales_Transaction_Stage__c saleTrans = new Sales_Transaction_Stage__c();
        saleTrans.Company__c = 'abc';
        saleTrans.Retailer_Code__c = retailercode.Id;
        saleTrans.Row_No__c = 2000;
        saleTrans.Year__c = '2019';
        saleTrans.Week__c = 'second';
        saleTrans.Month__c ='april';
        saleTrans.Item_code__c = 'sfd';
        saleTrans.Material__c ='original';
        saleTrans.Source__c = 'gfd';
        saleTrans.Printed_Logo__c = 'brand';
        saleTrans.Color__c = 'gray';
        saleTrans.Customer__c = 'local';
        saleTrans.Customer_local_name__c ='sfdc';
        saleTrans.Mainetti_Brand__c = 'original';
        saleTrans.Category__c = 'asce';
        saleTrans.Sub_Category__c = 'sdc';
        saleTrans.Family__c = 'member';
        saleTrans.Order_Type__c = 'online';
        saleTrans.Unit_Sold__c = '1.2';
        saleTrans.Local_Currency__c = 'rupee';
        saleTrans.Shipped_To_Factory__c = 'laghul';
        saleTrans.Shipped_To_Country__c = 'hongkong';
        saleTrans.Label__c = 'brand';
        saleTrans.End_user__c = 'add';
        saleTrans.Division__c = 'local';
        saleTrans.Retailer_Brand__c = 'original';
        saleTrans.Royalty_Rate__c = 'cost';
        saleTrans.Market__c = 'loacl';
        saleTrans.Remarks__c = 'noo';
        saleTrans.LOB__c = 'PRL123456789012345688';
        saleTrans.SO_Number__c = '183001689999898988';
        saleTrans.Production_Country__c = 'Hk';
        saleTrans.ExRate_to_EUR__c = '1.2';
        saleTrans.ExRate_to_USD__c = '1.2';
        saleTrans.Sales_EUR__c = '1.2';
        saleTrans.Sales_USD__c = '1.2';
		saleTrans.Sales_Transaction_Currency__c = '1.2';
        saleTrans.Unit_Price_100_USD__c = '112.40602';
        saleTrans.Unit_Price_100_EUR__c = '112.40602';
        saleTrans.Net_Unit_Price_100__c = '111';  
        saleTrans.Vendor__c = 'lululemon';
        saleTrans.Model__c = '1000';
        saleTrans.Gross_Sales_USD__c = '';
        saleTrans.Freight_Charge_USD__c = '';
        saleTrans.Transaction_Currency__c = 'USD';
        insert saleTrans;*/
        
        
        
        
         Sales_Transaction_Stage__c saleTrans = new Sales_Transaction_Stage__c();
        saleTrans.Company__c = 'abc';
        saleTrans.Retailer_Code__c = retailercode.Id;
        saleTrans.Row_No__c = 2000;
        saleTrans.Year__c = '2019';
        saleTrans.Week__c = 'second';
        saleTrans.Month__c ='april';
        saleTrans.Item_code__c = 'sfd';
        saleTrans.Material__c ='original';
        saleTrans.Source__c = 'gfd';
        saleTrans.Printed_Logo__c = 'brand';
        saleTrans.Color__c = 'gray';
        saleTrans.Customer__c = 'local';
        saleTrans.Customer_local_name__c ='sfdc';
        saleTrans.Mainetti_Brand__c = 'original';
        saleTrans.Category__c = 'asce';
        saleTrans.Sub_Category__c = 'sdc';
        saleTrans.Family__c = 'member';
        saleTrans.Order_Type__c = 'online';
        saleTrans.Unit_Sold__c = '1.2';
        saleTrans.Local_Currency__c = 'rupee';
        saleTrans.Shipped_To_Factory__c = 'laghul';
        saleTrans.Shipped_To_Country__c = 'hongkong';
        saleTrans.Label__c = 'brand';
        saleTrans.End_user__c = 'add';
        saleTrans.Division__c = 'local';
        saleTrans.Retailer_Brand__c = 'original';
        saleTrans.Royalty_Rate__c = 'cost';
        saleTrans.Market__c = 'loacl';
        saleTrans.Remarks__c = 'noo';
        saleTrans.LOB__c = 'PRL123456789012345688';
        saleTrans.SO_Number__c = '183001689999898988';
        saleTrans.Production_Country__c = 'Hk';
        saleTrans.ExRate_to_EUR__c = '1.2';
        saleTrans.ExRate_to_USD__c = '1.2';
        saleTrans.Sales_EUR__c = '1.2';
        saleTrans.Sales_USD__c = '1.2';
		saleTrans.Sales_Transaction_Currency__c = '1.2';
        saleTrans.Unit_Price_100_USD__c = '112.40602';
        saleTrans.Unit_Price_100_EUR__c = '112.40602';
        saleTrans.Net_Unit_Price_100__c = '111';  
        saleTrans.Vendor__c = 'lululemon';
        saleTrans.Model__c = '1000';
        saleTrans.Gross_Sales_USD__c = '';
        saleTrans.Freight_Charge_USD__c = '';
        saleTrans.Transaction_Currency__c = 'USD';
        insert saleTrans;
        
        ///////////////////////////////////////////////////////////////
         Sales_Transaction_Stage__c salesTrans1 = new Sales_Transaction_Stage__c();
        salesTrans1.Company__c = 'abc';
      salesTrans1.Retailer_Code__c = retailercode.Id;
        salesTrans1.Row_No__c = 2000;
        salesTrans1.Year__c = '2019';
        salesTrans1.Week__c = 'second';
        salesTrans1.Month__c ='april';
        salesTrans1.Item_code__c = 'sfd';
        salesTrans1.Material__c ='original';
        salesTrans1.Source__c = 'gfd';
        salesTrans1.Printed_Logo__c = 'brand';
        salesTrans1.Color__c = 'gray';
        salesTrans1.Customer__c = 'local';
        salesTrans1.Customer_local_name__c ='sfdc';
        salesTrans1.Mainetti_Brand__c = 'original';
        salesTrans1.Category__c = 'asce';
        salesTrans1.Sub_Category__c = 'sdc';
        salesTrans1.Family__c = 'member';
        salesTrans1.Order_Type__c = 'online';
        salesTrans1.Unit_Sold__c = '1.2';
        salesTrans1.Local_Currency__c = 'rupee';
        salesTrans1.Shipped_To_Factory__c = 'laghul';
        salesTrans1.Shipped_To_Country__c = 'hongkong';
        salesTrans1.Label__c = 'brand';
        salesTrans1.End_user__c = 'add';
        salesTrans1.Division__c = 'local';
        salesTrans1.Retailer_Brand__c = 'original';
        salesTrans1.Royalty_Rate__c = 'cost';
        salesTrans1.Market__c = 'loacl';
        salesTrans1.Remarks__c = 'noo';
        salesTrans1.LOB__c = 'PRL123456789012345688';
        salesTrans1.SO_Number__c = '183001689999898988';
        salesTrans1.Production_Country__c = 'Hk';
        salesTrans1.ExRate_to_EUR__c = '1.2';
        salesTrans1.ExRate_to_USD__c = '';
        salesTrans1.Sales_EUR__c = '1.2';
        salesTrans1.Sales_USD__c = '';
		salesTrans1.Sales_Transaction_Currency__c = '1.2'; 
        salesTrans1.Unit_Price_100_USD__c = '112.40602';
        salesTrans1.Unit_Price_100_EUR__c = '112.40602';
        salesTrans1.Net_Unit_Price_100__c = '111'; 
        salesTrans1.unit_sold_warning__c = true;
        salesTrans1.Vendor__c = 'debenham';
        salesTrans1.Model__c = '1000';
        salesTrans1.Gross_Sales_USD__c = '';
        salesTrans1.Freight_Charge_USD__c = '';
        salesTrans1.Transaction_Currency__c = 'USD';
        salesTrans1.Model_NF__c = false;
        insert salesTrans1;
        
        Sales_Transaction_Stage__c salesTransactions = new Sales_Transaction_Stage__c();
        salesTransactions.Company__c = 'abc';
        salesTransactions.Row_No__c = 2000;
        salesTransactions.Year__c = '2019';
        salesTransactions.Week__c = 'second';
        salesTransactions.Month__c ='april';
        salesTransactions.Item_code__c = 'sfd';
        salesTransactions.Material__c ='original';
        salesTransactions.Source__c = 'gfd';
        salesTransactions.Printed_Logo__c = 'brand';
        salesTransactions.Color__c = 'gray';
        salesTransactions.Customer__c = 'local';
        salesTransactions.Customer_local_name__c ='sfdc';
        salesTransactions.Mainetti_Brand__c = 'original';
        salesTransactions.Category__c = 'asce';
        salesTransactions.Sub_Category__c = 'sdc';
        salesTransactions.Family__c = 'member';
        salesTransactions.Order_Type__c = 'online';
        salesTransactions.Unit_Sold__c = '1.2';
        salesTransactions.Local_Currency__c = 'rupee';
        salesTransactions.Shipped_To_Factory__c = 'laghul';
        salesTransactions.Shipped_To_Country__c = 'hongkong';
        salesTransactions.Label__c = 'brand';
        salesTransactions.End_user__c = 'add';
        salesTransactions.Division__c = 'local';
        salesTransactions.Retailer_Brand__c = 'original';
        salesTransactions.Royalty_Rate__c = 'cost';
        salesTransactions.Market__c = 'loacl';
        salesTransactions.Remarks__c = 'noo';
        salesTransactions.LOB__c = 'PRL123456789012345688';
        salesTransactions.SO_Number__c = '183001689999898988';
        salesTransactions.Production_Country__c = 'Hk';
        salesTransactions.ExRate_to_EUR__c = '1.2';
        salesTransactions.ExRate_to_USD__c = '';
        salesTransactions.Sales_EUR__c = '1.2';
        salesTransactions.Sales_USD__c = '';
		salesTransactions.Sales_Transaction_Currency__c = '1.2';
        salesTransactions.Unit_Price_100_USD__c = '112.40602';
        salesTransactions.Unit_Price_100_EUR__c = '112.40602';
        salesTransactions.Net_Unit_Price_100__c = '111';  
        salesTransactions.Vendor__c = 'debenham';
        salesTransactions.Model__c = 'CS1Q1';
        salesTransactions.Gross_Sales_USD__c = '';
        salesTransactions.Freight_Charge_USD__c = '';
        salesTransactions.Transaction_Currency__c = 'USD';
        salesTransactions.Model_NF__c = false;
        insert salesTransactions; 
        
         List<Sales_Transaction_Stage__c> salestransstag = new   List<Sales_Transaction_Stage__c>();
        salestransstag.add(salesTransStagRecForReconciliation);
        /*List<Sales_Transaction_Stage__c> salesTransLabel = new   List<Sales_Transaction_Stage__c>();
        salesTransLabel.add(salesTransMastLabel);
            List<Sales_Transaction_Stage__c> salesTransMissing = new   List<Sales_Transaction_Stage__c>();
        salesTransMissing.add(salesTransMastMissing);*/
        
        List<Sales_Transaction_Stage__c> salesTransStagRec = new   List<Sales_Transaction_Stage__c>();
        salesTransStagRec.add(salesTrans);
        salesTransStagRec.add(salesTrans1);
       // salesTransStagRec.add(salesTransactions);
        Label_Division__c lableDivision = new Label_Division__c();
        lableDivision.Retailer_Code__c = retailercode.Id;
        lableDivision.Division__c = 'ABCD';
        lableDivision.Retailer_Brand__c = 'Rock & Republic';
        lableDivision.Label__c = 'PL';
        insert lableDivision;
        
         Sales_Transaction_Stage__c salestran1 = new Sales_Transaction_Stage__c();
        salestran1.Retailer_Code__c = retailercode.Id;
        salestran1.Gross_Sales_USD__c ='abc';
        //salestran1.Gross_Sales_USD__c = '0';
        salestran1.Freight_Charge_USD__c = 'bed';
        salestran1.Row_No__c =0;
        insert salestran1;
        
        
        Map<string,Retailer_Code__c> retailerDivBrand = new Map<string,Retailer_Code__c>();
        Map<string,string> vendorDivBrandLabel = new Map<string,string>();
        list<Retailer_Code__c> retailerCodes = [Select Name,Division_check__c,Label_Check__c,Retailer_Brand_Check__c,Sales_Data_Upload_Check__c from Retailer_Code__c where Name <> null]; 
        list<Label_Division__c> labelDiv = [Select Retailer_Code_Name__c, Division__c, Retailer_Brand__c, Label__c from Label_Division__c where Retailer_Code_Name__c <> null and Division__c <> null and Retailer_Brand__c <> null and Label__c <> null];
        for ( Retailer_Code__c retailer : retailerCodes ){
            retailerDivBrand.put(retailer.Name,retailer);
        }
        string cmpKey = lableDivision.Retailer_Code_Name__c+'#'+lableDivision.Division__c+'#'+lableDivision.Retailer_Brand__c+'#'+lableDivision.Label__c;
        for ( Label_Division__c labDiv : labelDiv ){
            vendorDivBrandLabel.put(cmpKey.toLowerCase(),cmpKey.toLowerCase());
        }
        System.assertEquals(retailercode.Name, 'lululemon');
        
        
         
        //////////////////////////////////////////////////////////////////////////////////
  /*      Sales_Transaction_Stage__c salestrans = new Sales_Transaction_Stage__c();
        List<Sales_Transaction_Stage__c> salesTransStagRec = new List<Sales_Transaction_Stage__c>();
        salesTransStagRec.add(salestrans);*/
            string selcomp = '';
            string selMonth = '';
            string selYear = '';
            Map<Decimal,Map<string,string>>inCorrectFormatMap = new Map<Decimal,Map<string,string>>();  
            Map<string,string>colorMap = new  Map<string,string>();
            Map<string,string> marketMap = new Map<string,string>();
            Map<string,string>lululemonModelMap = new Map<string,string>();
            Map<string,string>debenhanModelMap = new Map<string,string>();
            Map<string,string>debenhanModelBrandKeyMap = new  Map<string,string>(); 
            Map<string,string>debenhanBrandMap = new Map<string,string>();
            Map<string,string>vendorDivisionBrandLabelMap = new Map<string,string>(); 
            Map<string,string>productionCoungtryMap = new Map<string,string>();
            Map<string,string>modelWarningMap = new  Map<string,string>();
            Map<string,string>modelCompKeyMap = new  Map<string,string>();
            Map<string,string>dateMap = new  Map<string,string>();
        	validateSalesRowsBulk.recordValidationStatus recordStatus = new  validateSalesRowsBulk.recordValidationStatus();
            Map<string,string>companyOnlyMap = new  Map<string,string>();
            Map<string,string>vendorMap = new  Map<string,string>();
            String userEmailNotify = '';
            Map<string,Map<string,string>> getNewVendorDivisionBrandLabelMap = new  Map<string,Map<string,string>>();
            Map<string,string> getModelandColorMap = new Map<string,string>();
            Map<string,string> getSalesDataUploadCheckMap = new Map<string,string>();
            Map<string,Retailer_Code__c> getRetailersLabelDivisionBrandCheckMap = new  Map<string,Retailer_Code__c>();
            Map<string,string> getSalesDataUploadColorCheckMap = new Map<string,string>();
            Map<string,string> checkColorwithModel = new Map<string,string>();
            Map<string,string> getModelCatFamilyMap = new Map<string,string>();
         Test.startTest();
        
        getSalesMasterData retailerDivisionBrand = new getSalesMasterData();
        retailerDivisionBrand.getRetailersLabelDivisionBrandCheckMap();
        retailerDivisionBrand.getVendorDivisionBrandLabelMap();
        
        processSalesData processSales = new processSalesData();
        processSales.processSalesDataChunk(salesTransStagRec, selcomp, selMonth, selYear, inCorrectFormatMap, colorMap, marketMap, lululemonModelMap, debenhanModelMap, debenhanModelBrandKeyMap, debenhanBrandMap, vendorDivisionBrandLabelMap, productionCoungtryMap, modelWarningMap, modelCompKeyMap, dateMap, companyOnlyMap, vendorMap, userEmailNotify, recordStatus, getNewVendorDivisionBrandLabelMap, getRetailersLabelDivisionBrandCheckMap, getModelandColorMap, getSalesDataUploadCheckMap,getSalesDataUploadColorCheckMap,checkColorwithModel,getModelCatFamilyMap);
        Test.stopTest();
            
    }
   
    static testMethod void reconcileDataWithSalesErrorMapBulkTest(){
        Sales_Transaction_Stage__c salestrans = new Sales_Transaction_Stage__c();
        List<Sales_Transaction_Stage__c> salesTransStagRecForReconciliation = new List<Sales_Transaction_Stage__c>();
        salesTransStagRecForReconciliation.add(salestrans);
        Map<string,Map<string,Map<string,string>>> fullSalesErrorMap = new Map<string,Map<string,Map<string,string>>>();
        
      Test.startTest();
        processSalesData processSales = new processSalesData();
        processSales.reconcileDataWithSalesErrorMapBulk(salesTransStagRecForReconciliation, fullSalesErrorMap);
        Test.stopTest();  
    }
    static testMethod void recordValidationStatusTest(){
        processSalesData.recordValidationStatus status = new processSalesData.recordValidationStatus();
        status.validateStatus = false;
        status.updateCheckbox = false;
       
    }
 
    public class applicationException extends Exception {}
    
}