global class processSalesData {
    
    global class  recordValidationStatus{
        public Boolean validateStatus { get; set; }
        public Boolean updateCheckbox { get; set; }        
    }
    
    /* public boolean missingFieldValue(Sales_Transaction_Stage__c dataRow,Sales_Transaction_Stage__c rowUpdate, Map<Decimal,Map<string,string>> inCorrectFormatMap){            
boolean missingField = true;
if(dataRow != null){
if(String.isBlank(dataRow.Model__c)){
rowUpdate.Model_FB__c = True;
missingField = false;
}
if(String.isBlank(dataRow.Color__c)){
rowUpdate.Color_FB__c = True;
missingField = false;
}
if(String.isBlank(dataRow.Category__c)){
rowUpdate.Category_FB__c = True;
missingField = false;
}
if(String.isBlank(dataRow.Market__c)){
rowUpdate.Market_FB__c = True;
missingField = false;
}
if(String.isBlank(dataRow.Vendor__c)){
rowUpdate.Vendor_FB__c = True;
missingField = false;
}
if(String.isBlank(dataRow.Company__c)){
rowUpdate.Company_FB__c = True;
missingField = false;
}
if(String.isBlank(dataRow.Material__c)){
rowUpdate.Material_FB__c = True;
missingField = false;
}
if(String.isBlank(dataRow.Shipped_To_Factory__c)){
rowUpdate.Shipped_To_Factory_FB__c = True;
missingField = false;
}
if(String.isBlank(dataRow.Shipped_To_Country__c)){
rowUpdate.Shipped_To_Country_FB__c = True;
missingField = false;
}
if(String.isBlank(dataRow.Division__c)){
rowUpdate.Division_FB__c = True;
missingField = false;
}
if(String.isBlank(dataRow.Item_code__c)){
rowUpdate.Item_code_FB__c = True;
missingField = false;
}
if(String.isBlank(dataRow.Mainetti_Brand__c)){
rowUpdate.Mainetti_Brand_FB__c = True;
missingField = false;
}
if(String.isBlank(dataRow.Order_Type__c)){
rowUpdate.Order_Type_FB__c = True;
missingField = false;
}
if(String.isBlank(dataRow.Customer__c)){
rowUpdate.Customer_FB__c = True;
missingField = false;
}
if(String.isBlank(dataRow.Transaction_Currency__c)){
rowUpdate.Transaction_Currency_FB__c = True;
missingField = false;
}
if(String.isBlank(dataRow.ExRate_to_EUR__C)){
rowUpdate.ExRate_to_EUR_FB__C = True;
missingField = false;
}
if(String.isBlank(dataRow.ExRate_to_USD__C)){
rowUpdate.ExRate_to_USD_FB__C = True;
missingField = false;
}
if(String.isBlank(dataRow.Sales_Transaction_Currency__c)){
rowUpdate.STC_FB__c = True;
missingField = false;
}
if(String.isBlank(dataRow.Sales_USD__c)){
rowUpdate.Sales_USD_FB__c = True; 
missingField = false;
}
if(String.isBlank(dataRow.Sales_EUR__c)){
rowUpdate.Sales_EUR_FB__c = True;
missingField = false;
}
if(String.isBlank(dataRow.Unit_Price_100_USD__c)){
rowUpdate.Unit_Price_100_USD_FB__c = True;
missingField = false;
}
if(String.isBlank(dataRow.Unit_Price_100_EUR__c)){
rowUpdate.Unit_Price_100_EUR_FB__c = True;
missingField = false;
}
//  if(String.isBlank(dataRow.Local_Net_Unit_Pirce_100__c)){
//  rowUpdate.Local_Net_Unit_Pirce_FB__c = True;
//  missingField = false;
//   }
if(String.isBlank(dataRow.Net_Unit_Price_100__c)){
rowUpdate.Net_Unit_Price_100_FB__c = True;
missingField = false;
}
if(String.isBlank(dataRow.Month__c)){
rowUpdate.Month_FB__c = True;
missingField = false;
}         
if(String.isBlank(dataRow.Source__c)){
rowUpdate.Source_FB__c = True;
missingField = false;
}
if(String.isBlank(dataRow.Unit_Sold__c)){
rowUpdate.Unit_Sold_FB__c = True;
missingField = false;
}
if(String.isBlank(dataRow.Week__c)){
rowUpdate.Week_FB__c = True;
missingField = false;
}
if(String.isBlank(dataRow.Year__c)){
rowUpdate.Year_FB__c = True;
missingField = false;
}
if(String.isBlank(dataRow.SO_Number__c)){
rowUpdate.SO_Number_FB__c = True;
missingField = false;
}
if(String.isBlank(dataRow.LOB__c)){
rowUpdate.LOB_FB__c = True;
missingField = false;
}
if(String.isBlank(dataRow.Gross_Sales_USD__c)){
rowUpdate.Gross_Sales_USD_FB__c = True;
missingField = false;
}else{
String grossValue = dataRow.Gross_Sales_USD__c;
decimal grossValueReturned = isValueNumeric(grossValue);
if(grossValueReturned == null){
if(inCorrectFormatMap.ContainsKey(dataRow.Row_No__c) ){
Map<string,string> formatMap = inCorrectFormatMap.get(dataRow.Row_No__c);
formatMap.put('Gross', 'Wrong Number Format for Gross Sales:'+grossValue);
inCorrectFormatMap.put(dataRow.Row_No__c,formatMap);
}else{
Map<string,string> formatMap = new Map<string,string>();
formatMap.put('Gross', 'Wrong Number Format for Gross Sales:'+grossValue);
inCorrectFormatMap.put(dataRow.Row_No__c,formatMap);
}
}  
}                    
if(String.isBlank(dataRow.Freight_Charge_USD__c)){
rowUpdate.Freight_Charge_USD_FB__c = True;
missingField = false;
}else{
String freightValue = dataRow.Freight_Charge_USD__c;
decimal freightValueReturned = isValueNumeric(freightValue);
if(freightValueReturned == null){
if(inCorrectFormatMap.ContainsKey(dataRow.Row_No__c) ){
Map<string,string> formatMap = inCorrectFormatMap.get(dataRow.Row_No__c);
formatMap.put('Freight', 'Wrong Number Format for Freight charge:'+freightValue);
inCorrectFormatMap.put(dataRow.Row_No__c,formatMap);
}else{
Map<string,string> formatMap = new Map<string,string>();
formatMap.put('Freight', 'Wrong Number Format for Freight charge::'+freightValue);
inCorrectFormatMap.put(dataRow.Row_No__c,formatMap);
}
}  
}
}
return missingField;
} */
    
    
    //------------------------------------------------------------
    public boolean missingFieldValueBulk(Sales_Transaction_Stage__c dataRow, Map<Decimal,Map<string,string>> inCorrectFormatMap){            
        boolean missingField = true;
        if(dataRow != null){
            if(String.isBlank(dataRow.Model__c)){
                dataRow.Model_FB__c = True;
                missingField = false;
            }
            System.debug('missingField Model__c'+missingField);
            /* if(String.isBlank(dataRow.Color__c)){
dataRow.Color_FB__c = True;
missingField = false;
}
System.debug('missingField Color__c'+missingField); */
            /*  if(String.isBlank(dataRow.Category__c)){
dataRow.Category_FB__c = True;
missingField = false;
}
System.debug('missingField Category__c'+missingField); */
           /* if(String.isBlank(dataRow.Family__c)){
dataRow.Family_FB__c = True;
missingField = false;
}
System.debug('missingField Family__c'+missingField); */
            if(String.isBlank(dataRow.Market__c)){
                dataRow.Market_FB__c = True;
                missingField = false;
            }
            System.debug('missingField Market__c'+missingField);
            if(String.isBlank(dataRow.Vendor__c)){
                dataRow.Vendor_FB__c = True;
                missingField = false;
            }
            System.debug('missingField Vendor__c'+missingField);
            if(String.isBlank(dataRow.Company__c)){
                dataRow.Company_FB__c = True;
                missingField = false;
            }
            System.debug('missingField Company__c'+missingField);
            if(String.isBlank(dataRow.Material__c)){
                dataRow.Material_FB__c = True;
                missingField = false;
            }
            System.debug('missingField Material__c'+missingField);
            if(String.isBlank(dataRow.Shipped_To_Factory__c)){
                dataRow.Shipped_To_Factory_FB__c = True;
                missingField = false;
            }
            System.debug('missingField Shipped_To_Factory__c'+missingField);
            if(String.isBlank(dataRow.Shipped_To_Country__c)){
                dataRow.Shipped_To_Country_FB__c = True;
                missingField = false;
            }
            System.debug('missingField Shipped_To_Country__c'+missingField);
            /* if(String.isBlank(dataRow.Division__c)){
dataRow.Division_FB__c = True;
missingField = false;
}
System.debug('missingField Division__c'+missingField); */
            if(String.isBlank(dataRow.Item_code__c)){
                dataRow.Item_code_FB__c = True;
                missingField = false;
            }
            System.debug('missingField Item_code__c'+missingField);
           /* if(String.isBlank(dataRow.Mainetti_Brand__c)){
                dataRow.Mainetti_Brand_FB__c = True;
                missingField = false;
            }
            System.debug('missingField Mainetti_Brand__c'+missingField); */
            if(String.isBlank(dataRow.Order_Type__c)){
                dataRow.Order_Type_FB__c = True;
                missingField = false;
            }
            System.debug('missingField Order_Type__c'+missingField);
            if(String.isBlank(dataRow.Customer__c)){
                dataRow.Customer_FB__c = True;
                missingField = false;
            }
            System.debug('missingField Customer__c'+missingField);
            if(String.isBlank(dataRow.Transaction_Currency__c)){
                dataRow.Transaction_Currency_FB__c = True;
                missingField = false;
            }
            System.debug('missingField Transaction_Currency__c'+missingField);
            if(String.isBlank(dataRow.ExRate_to_EUR__C)){
                dataRow.ExRate_to_EUR_FB__C = True;
                missingField = false;
            }
            System.debug('missingField ExRate_to_EUR__C'+missingField);
            if(String.isBlank(dataRow.ExRate_to_USD__C)){
                dataRow.ExRate_to_USD_FB__C = True;
                missingField = false;
            }
            System.debug('missingField ExRate_to_USD__C'+missingField);
            if(String.isBlank(dataRow.Sales_Transaction_Currency__c)){
                dataRow.STC_FB__c = True;
                missingField = false;
            }
            System.debug('missingField Sales_Transaction_Currency__c'+missingField);
            if(String.isBlank(dataRow.Sales_USD__c)){
                dataRow.Sales_USD_FB__c = True;
                missingField = false;
            }
            System.debug('missingField Sales_USD__c'+missingField);
            if(String.isBlank(dataRow.Sales_EUR__c)){
                dataRow.Sales_EUR_FB__c = True;
                missingField = false;
            }
            System.debug('missingField Sales_EUR__c'+missingField);
            if(String.isBlank(dataRow.Unit_Price_100_USD__c)){
                dataRow.Unit_Price_100_USD_FB__c = True;
                missingField = false;
            }
            System.debug('missingField Unit_Price_100_USD__c'+missingField);
            if(String.isBlank(dataRow.Unit_Price_100_EUR__c)){
                dataRow.Unit_Price_100_EUR_FB__c = True;
                missingField = false;
            }
            System.debug('missingField Unit_Price_100_EUR__c'+missingField);
            /*  if(String.isBlank(dataRow.Local_Net_Unit_Pirce_100__c)){
dataRow.Local_Net_Unit_Pirce_FB__c = True;
missingField = false;
} 
System.debug('missingField Local_Net_Unit_Pirce_100__c'+missingField); */
          /*  if(String.isBlank(dataRow.Net_Unit_Price_100__c)){
                dataRow.Net_Unit_Price_100_FB__c = True;
                missingField = false;
            }
            System.debug('missingField Net_Unit_Price_100__c'+missingField); */
            if(String.isBlank(dataRow.Month__c)){
                dataRow.Month_FB__c = True;
                missingField = false;
            }         
            System.debug('missingField Month__c'+missingField);
            if(String.isBlank(dataRow.Source__c)){
                dataRow.Source_FB__c = True;
                missingField = false;
            }
            System.debug('missingField Source__c'+missingField);
            if(String.isBlank(dataRow.Unit_Sold__c)){
                dataRow.Unit_Sold_FB__c = True;
                missingField = false;
            }
            System.debug('missingField Unit_Sold__c'+missingField);
            if(String.isBlank(dataRow.Week__c)){
                dataRow.Week_FB__c = True;
                missingField = false;
            }
            System.debug('missingField Week__c'+missingField);
            if(String.isBlank(dataRow.Year__c)){
                dataRow.Year_FB__c = True;
                missingField = false;
            }
            System.debug('missingField Year__c'+missingField);
          /*  if(String.isBlank(dataRow.SO_Number__c)){
                dataRow.SO_Number_FB__c = True;
                missingField = false;
            }
            System.debug('missingField SO_Number__c'+missingField); */
           /* if(String.isBlank(dataRow.LOB__c)){
                dataRow.LOB_FB__c = True;
                missingField = false;
            }
            System.debug('missingField LOB__c'+missingField); */
            /*   if(String.isBlank(dataRow.Gross_Sales_USD__c)){
dataRow.Gross_Sales_USD_FB__c = True;
missingField = false;
}else{
String grossValue = dataRow.Gross_Sales_USD__c;
decimal grossValueReturned = isValueNumeric(grossValue);
if(grossValueReturned == null){
system.debug('dataRow.Row_No__c'+dataRow.Row_No__c);

if(inCorrectFormatMap.ContainsKey(dataRow.Row_No__c) ){
system.debug('inCorrectFormatMap'+inCorrectFormatMap);
Map<string,string> formatMap = inCorrectFormatMap.get(dataRow.Row_No__c);
formatMap.put('Gross', 'Wrong Number Format for Gross Sales:'+grossValue);
inCorrectFormatMap.put(dataRow.Row_No__c,formatMap);
}else{
Map<string,string> formatMap = new Map<string,string>();
formatMap.put('Gross', 'Wrong Number Format for Gross Sales:'+grossValue);
inCorrectFormatMap.put(dataRow.Row_No__c,formatMap);
}
}  
}      
System.debug('missingField Gross_Sales_USD__c'+missingField); */
            /* if(String.isBlank(dataRow.Freight_Charge_USD__c)){
dataRow.Freight_Charge_USD_FB__c = True;
missingField = false;
}else{
String freightValue = dataRow.Freight_Charge_USD__c;
decimal freightValueReturned = isValueNumeric(freightValue);
if(freightValueReturned == null){
if(inCorrectFormatMap.ContainsKey(dataRow.Row_No__c) ){
System.debug('inCorrectFormatMap :'+inCorrectFormatMap);
system.debug('dataRow.Row_No__c'+dataRow.Row_No__c);
Map<string,string> formatMap = inCorrectFormatMap.get(dataRow.Row_No__c);
formatMap.put('Freight', 'Wrong Number Format for Freight charge:'+freightValue);
inCorrectFormatMap.put(dataRow.Row_No__c,formatMap);
}else{
Map<string,string> formatMap = new Map<string,string>();
formatMap.put('Freight', 'Wrong Number Format for Freight charge::'+freightValue);
inCorrectFormatMap.put(dataRow.Row_No__c,formatMap);
}
}  
} */
        }
        System.debug('missingField Freight_Charge_USD__c'+missingField);
        return missingField;
    }
    
    //############################################################33
    //***This Method does the reconcilidation of each row with the Sales Error Maps and the data rows which 
    //has been changed or column is updated back with the error map data before they are set for validation
    //
    
    /* public  boolean  reconcileDataWithSalesErrorMap(List<Sales_Transaction_Stage__c> salesTransStagRecForReconciliation,Map<string,Map<string,Map<string,string>>> fullSalesErrorMap){            
//system.debug('INSIDE ############## reconcileDataWithSalesErrorMap####################');
boolean reconcileComplete = true;
List<Sales_Transaction_Stage__c> reconcileDataRowForUpdate = new List<Sales_Transaction_Stage__c>();

if(salesTransStagRecForReconciliation.size()>0){

for (Sales_Transaction_Stage__c dataRow : salesTransStagRecForReconciliation) {

if(dataRow != null){

Sales_Transaction_Stage__c rowUpdate = new Sales_Transaction_Stage__c();
rowUpdate.Id =  dataRow.Id;
boolean dataReconciled = false;  
boolean isErrorInRecord = false;
boolean isRawMapAvailable = false;
Map<string,Map<string,string>> rawDataFieldMap;
Map<string,string> mapFromToValueMap;
String pickListValues='';
if(String.isNotBlank(dataRow.Company__c)){
rawDataFieldMap = fullSalesErrorMap.get(dataRow.Company__c);
if(rawDataFieldMap != null){
isRawMapAvailable = true;                                                        
}
}               
if(String.isNotBlank(dataRow.Year__c)){
if(isRawMapAvailable){
mapFromToValueMap = rawDataFieldMap.get('Year');
if(mapFromToValueMap != null){
String mapFromValue = dataRow.Year__c;
if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
if(String.isNotBlank(mapToValue)){
rowUpdate.Year__c = mapToValue;                       
dataReconciled = true;
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'Year';
}else{
pickListValues = 'Year';
}                                    
dataReconciled = true;
isErrorInRecord = true;
}                                
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'Year';
}else{
pickListValues = 'Year';
}           
dataReconciled = true;
isErrorInRecord = true;
}                     
}            
if(String.isNotBlank(dataRow.Week__c)){
if(isRawMapAvailable){
mapFromToValueMap = rawDataFieldMap.get('Week');
if(mapFromToValueMap != null){
String mapFromValue = dataRow.Week__c;
if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
if(String.isNotBlank(mapToValue)){
rowUpdate.Week__c = mapToValue;                       
dataReconciled = true;
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'Week';
}else{
pickListValues = 'Week';
}                               
dataReconciled = true;
isErrorInRecord = true;
}
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'Week';
}else{
pickListValues = 'Week';
}      
dataReconciled = true;
isErrorInRecord = true;
}      
}
if(String.isNotBlank(dataRow.Month__c)){
if(isRawMapAvailable){
mapFromToValueMap = rawDataFieldMap.get('Month');
if(mapFromToValueMap != null){
String mapFromValue = dataRow.Month__c;
if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
if(String.isNotBlank(mapToValue)){
rowUpdate.Month__c = mapToValue;                       
dataReconciled = true;
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'Month';
}else{
pickListValues = 'Month';
}      
dataReconciled = true;
isErrorInRecord = true;
}
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'Month';
}else{
pickListValues = 'Month';
}      
dataReconciled = true;
isErrorInRecord = true;
}     
}   
if(String.isNotBlank(dataRow.Item_code__c)){
if(isRawMapAvailable){
mapFromToValueMap = rawDataFieldMap.get('ItemCode');
if(mapFromToValueMap != null){
String mapFromValue = dataRow.Item_code__c;
if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
if(String.isNotBlank(mapToValue)){
rowUpdate.Item_code__c = mapToValue;                       
dataReconciled = true;
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'ItemCode';
}else{
pickListValues = 'ItemCode';
}      
dataReconciled = true;
isErrorInRecord = true;
}                                
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'ItemCode';
}else{
pickListValues = 'ItemCode';
}  
dataReconciled = true;
isErrorInRecord = true;
}        
}
if(String.isNotBlank(dataRow.Material__c)){
if(isRawMapAvailable){
mapFromToValueMap = rawDataFieldMap.get('Material');
if(mapFromToValueMap != null){
String mapFromValue = dataRow.Material__c;
if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
if(String.isNotBlank(mapToValue)){
rowUpdate.Material__c = mapToValue;                       
dataReconciled = true;
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'Material';
}else{
pickListValues = 'Material';
}  
dataReconciled = true;
isErrorInRecord = true;
}                               
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'Material';
}else{
pickListValues = 'Material';
}  
dataReconciled = true;
isErrorInRecord = true;
}   
}
if(String.isNotBlank(dataRow.Source__c)){
if(isRawMapAvailable){
mapFromToValueMap = rawDataFieldMap.get('Source');
if(mapFromToValueMap != null){
String mapFromValue = dataRow.Source__c;
if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
if(String.isNotBlank(mapToValue)){
rowUpdate.Source__c = mapToValue;                       
dataReconciled = true;
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'Source';
}else{
pickListValues = 'Source';
}  
dataReconciled = true;
isErrorInRecord = true;
}                         
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'Source';
}else{
pickListValues = 'Source';
}  
dataReconciled = true;
isErrorInRecord = true;
}      
}

if(String.isNotBlank(dataRow.Printed_Logo__c)){
if(isRawMapAvailable){
mapFromToValueMap = rawDataFieldMap.get('PrintedLogo');
if(mapFromToValueMap != null){
String mapFromValue = dataRow.Printed_Logo__c;
if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
if(String.isNotBlank(mapToValue)){
rowUpdate.Printed_Logo__c = mapToValue;                       
dataReconciled = true;
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'PrintedLogo';
}else{
pickListValues = 'PrintedLogo';
}  
dataReconciled = true;
isErrorInRecord = true;
}                              
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'PrintedLogo';
}else{
pickListValues = 'PrintedLogo';
}  
dataReconciled = true;
isErrorInRecord = true;
}       
}            
if(String.isNotBlank(dataRow.Color__c)){
if(isRawMapAvailable){
mapFromToValueMap = rawDataFieldMap.get('Color');
if(mapFromToValueMap != null){
String mapFromValue = dataRow.Color__c;
if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){                                    
String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
if(String.isNotBlank(mapToValue)){
rowUpdate.Color__c = mapToValue;                       
dataReconciled = true;
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'Color';
}else{
pickListValues = 'Color';
}  
dataReconciled = true;
isErrorInRecord = true;
}                              
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'Color';
}else{
pickListValues = 'Color';
}  
dataReconciled = true;
isErrorInRecord = true;
}           
}
if(String.isNotBlank(dataRow.Customer__c)){
if(isRawMapAvailable){
mapFromToValueMap = rawDataFieldMap.get('Customer');
if(mapFromToValueMap != null){
String mapFromValue = dataRow.Customer__c;
if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
if(String.isNotBlank(mapToValue)){
rowUpdate.Customer__c = mapToValue;                       
dataReconciled = true;
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'Customer';
}else{
pickListValues = 'Customer';
}  
dataReconciled = true;
isErrorInRecord = true;
}                          
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'Customer';
}else{
pickListValues = 'Customer';
}  
dataReconciled = true;
isErrorInRecord = true;
}      
}
if(String.isNotBlank(dataRow.Customer_local_name__c)){
if(isRawMapAvailable){
mapFromToValueMap = rawDataFieldMap.get('LocalName');
if(mapFromToValueMap != null){
String mapFromValue = dataRow.Customer_local_name__c;
if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
if(String.isNotBlank(mapToValue)){
rowUpdate.Customer_local_name__c = mapToValue;                       
dataReconciled = true;
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'LocalName';
}else{
pickListValues = 'LocalName';
}  
dataReconciled = true;
isErrorInRecord = true;
}
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'LocalName';
}else{
pickListValues = 'LocalName';
}  
dataReconciled = true;
isErrorInRecord = true;
}   
}
if(String.isNotBlank(dataRow.Mainetti_Brand__c)){
if(isRawMapAvailable){
mapFromToValueMap = rawDataFieldMap.get('MainettiBrand');
if(mapFromToValueMap != null){
String mapFromValue = dataRow.Mainetti_Brand__c;
if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
if(String.isNotBlank(mapToValue)){
rowUpdate.Mainetti_Brand__c = mapToValue;                       
dataReconciled = true;
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'MainettiBrand';
}else{
pickListValues = 'MainettiBrand';
}  
dataReconciled = true;
isErrorInRecord = true;
}
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'MainettiBrand';
}else{
pickListValues = 'MainettiBrand';
}  
dataReconciled = true;
isErrorInRecord = true;
}   
}
if(String.isNotBlank(dataRow.Category__c)){                        
if(isRawMapAvailable){
mapFromToValueMap = rawDataFieldMap.get('Category');                      
if(mapFromToValueMap != null){                                
String mapFromValue = dataRow.Category__c;
if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){ 

String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());                               
if(String.isNotBlank(mapToValue)){
rowUpdate.Category__c = mapToValue;                       
dataReconciled = true;
}
}else{  

if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'Category';
}else{
pickListValues = 'Category';
}  
dataReconciled = true;
isErrorInRecord = true;
}                               
}
}else{                            
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'Category';
}else{
pickListValues = 'Category';

}
dataReconciled = true;
isErrorInRecord = true;
}   
}

if(String.isNotBlank(dataRow.Sub_Category__c)){
if(isRawMapAvailable){
mapFromToValueMap = rawDataFieldMap.get('SubCategory');
if(mapFromToValueMap != null){
String mapFromValue = dataRow.Sub_Category__c;
if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
if(String.isNotBlank(mapToValue)){
rowUpdate.Sub_Category__c = mapToValue;                       
dataReconciled = true;
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'SubCategory';
}else{
pickListValues = 'SubCategory';
} 
dataReconciled = true;
isErrorInRecord = true;
}
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'SubCategory';
}else{
pickListValues = 'SubCategory';
} 
dataReconciled = true;
isErrorInRecord = true;
}   
}
if(String.isNotBlank(dataRow.Family__c)){
if(isRawMapAvailable){
mapFromToValueMap = rawDataFieldMap.get('Family');
if(mapFromToValueMap != null){
String mapFromValue = dataRow.Family__c;
if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());

if(String.isNotBlank(mapToValue)){
rowUpdate.Family__c = mapToValue;                       
dataReconciled = true;
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'Family';
}else{
pickListValues = 'Family';
} 
dataReconciled = true;
isErrorInRecord = true;
}
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'Family';
}else{
pickListValues = 'Family';
} 
dataReconciled = true;
isErrorInRecord = true;
}   
}              
if(String.isNotBlank(dataRow.Order_Type__c)){
if(isRawMapAvailable){
mapFromToValueMap = rawDataFieldMap.get('OrderType');
if(mapFromToValueMap != null){
String mapFromValue = dataRow.Order_Type__c;
if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
if(String.isNotBlank(mapToValue)){
rowUpdate.Order_Type__c = mapToValue;                       
dataReconciled = true;
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'OrderType';
}else{
pickListValues = 'OrderType';
} 
dataReconciled = true;
isErrorInRecord = true;
}
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'OrderType';
}else{
pickListValues = 'OrderType';
} 
dataReconciled = true;
isErrorInRecord = true;
}   
}
if(String.isNotBlank(dataRow.Unit_Sold__c)){
if(isRawMapAvailable){
mapFromToValueMap = rawDataFieldMap.get('UnitSold');
if(mapFromToValueMap != null){
String mapFromValue = dataRow.Unit_Sold__c;
if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
if(String.isNotBlank(mapToValue)){
rowUpdate.Unit_Sold__c = mapToValue;                       
dataReconciled = true;
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'UnitSold';
}else{
pickListValues = 'UnitSold';
} 
dataReconciled = true;
isErrorInRecord = true;
}                                
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'UnitSold';
}else{
pickListValues = 'UnitSold';
} 
dataReconciled = true;
isErrorInRecord = true;
}         
}
if(String.isNotBlank(dataRow.Local_Currency__c)){
if(isRawMapAvailable){
mapFromToValueMap = rawDataFieldMap.get('LocalCurrency');
if(mapFromToValueMap != null){
String mapFromValue = dataRow.Local_Currency__c;
if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
if(String.isNotBlank(mapToValue)){
rowUpdate.Local_Currency__c = mapToValue;                       
dataReconciled = true;
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'LocalCurrency';
}else{
pickListValues = 'LocalCurrency';
} 
dataReconciled = true;
isErrorInRecord = true;
}
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'LocalCurrency';
}else{
pickListValues = 'LocalCurrency';
} 
dataReconciled = true;
isErrorInRecord = true;
}          
}
if(String.isNotBlank(dataRow.Shipped_To_Factory__c)){
if(isRawMapAvailable){
mapFromToValueMap = rawDataFieldMap.get('ShippedToFactory');
if(mapFromToValueMap != null){
String mapFromValue = dataRow.Shipped_To_Factory__c;
if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
if(String.isNotBlank(mapToValue)){
rowUpdate.Shipped_To_Factory__c = mapToValue;                       
dataReconciled = true;
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'ShippedToFactory';
}else{
pickListValues = 'ShippedToFactory';
} 
dataReconciled = true;
isErrorInRecord = true;
}                                
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'ShippedToFactory';
}else{
pickListValues = 'ShippedToFactory';
} 
dataReconciled = true;
isErrorInRecord = true;
}          
}
if(String.isNotBlank(dataRow.Shipped_To_Country__c)){
if(isRawMapAvailable){
mapFromToValueMap = rawDataFieldMap.get('ShippedToCountry');
if(mapFromToValueMap != null){
String mapFromValue = dataRow.Shipped_To_Country__c;
if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
if(String.isNotBlank(mapToValue)){
rowUpdate.Shipped_To_Country__c = mapToValue;                       
dataReconciled = true;
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'ShippedToCountry';
}else{
pickListValues = 'ShippedToCountry';
} 
dataReconciled = true;
isErrorInRecord = true;
}                                
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'ShippedToCountry';
}else{
pickListValues = 'ShippedToCountry';
} 
dataReconciled = true;
isErrorInRecord = true;
}             
}
if(String.isNotBlank(dataRow.Label__c)){
if(isRawMapAvailable){
mapFromToValueMap = rawDataFieldMap.get('Label');
if(mapFromToValueMap != null){
String mapFromValue = dataRow.Label__c;
if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
if(String.isNotBlank(mapToValue)){
rowUpdate.Label__c = mapToValue;                       
dataReconciled = true;
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'Label';
}else{
pickListValues = 'Label';
} 
dataReconciled = true;
isErrorInRecord = true;
}                                 
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'Label';
}else{
pickListValues = 'Label';
} 
dataReconciled = true;
isErrorInRecord = true;
}           
}
if(String.isNotBlank(dataRow.End_user__c)){
if(isRawMapAvailable){
mapFromToValueMap = rawDataFieldMap.get('EndUser');
if(mapFromToValueMap != null){
String mapFromValue = dataRow.End_user__c;
if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
if(String.isNotBlank(mapToValue)){
rowUpdate.End_user__c = mapToValue;                       
dataReconciled = true;
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'EndUser';
}else{
pickListValues = 'EndUser';
} 
dataReconciled = true;
isErrorInRecord = true;
}                                
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'EndUser';
}else{
pickListValues = 'EndUser';
} 
dataReconciled = true;
isErrorInRecord = true;
}        
}

if(String.isNotBlank(dataRow.Vendor__c)){
if(isRawMapAvailable){
mapFromToValueMap = rawDataFieldMap.get('Vendor');
if(mapFromToValueMap != null){
String mapFromValue = dataRow.Vendor__c;
if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
if(String.isNotBlank(mapToValue)){
rowUpdate.Vendor__c = mapToValue;                       
dataReconciled = true;
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'Vendor';
}else{
pickListValues = 'Vendor';
} 
dataReconciled = true;
isErrorInRecord = true;
}                                 
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'Vendor';
}else{
pickListValues = 'Vendor';
} 
dataReconciled = true;
isErrorInRecord = true;
}       
}      
if(String.isNotBlank(dataRow.Division__c)){
if(isRawMapAvailable){
mapFromToValueMap = rawDataFieldMap.get('Division');
if(mapFromToValueMap != null){
String mapFromValue = dataRow.Division__c;
if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
if(String.isNotBlank(mapToValue)){
rowUpdate.Division__c = mapToValue;                       
dataReconciled = true;
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'Division';
}else{
pickListValues = 'Division';
} 
dataReconciled = true;
isErrorInRecord = true;
}                                 
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'Division';
}else{
pickListValues = 'Division';
} 
dataReconciled = true;
isErrorInRecord = true;
}       
}
if(String.isNotBlank(dataRow.Retailer_Brand__c)){
if(isRawMapAvailable){
mapFromToValueMap = rawDataFieldMap.get('RetailerBrand');
if(mapFromToValueMap != null){
String mapFromValue = dataRow.Retailer_Brand__c;
if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
if(String.isNotBlank(mapToValue)){
rowUpdate.Retailer_Brand__c = mapToValue;                       
dataReconciled = true;
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'RetailerBrand';
}else{
pickListValues = 'RetailerBrand';
} 
dataReconciled = true;
isErrorInRecord = true;
}                                 
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'RetailerBrand';
}else{
pickListValues = 'RetailerBrand';
} 
dataReconciled = true;
isErrorInRecord = true;
}    
}
if(String.isNotBlank(dataRow.Royalty_Rate__c)){
if(isRawMapAvailable){
mapFromToValueMap = rawDataFieldMap.get('RoyaltyRate');
if(mapFromToValueMap != null){
String mapFromValue = dataRow.Royalty_Rate__c;
if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
if(String.isNotBlank(mapToValue)){
rowUpdate.Royalty_Rate__c = mapToValue;                       
dataReconciled = true;
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'RoyaltyRate';
}else{
pickListValues = 'RoyaltyRate';
} 
dataReconciled = true;
isErrorInRecord = true;
}                                 
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'RoyaltyRate';
}else{
pickListValues = 'RoyaltyRate';
} 
dataReconciled = true;
isErrorInRecord = true;
}      
}
if(String.isNotBlank(dataRow.Market__c)){
if(isRawMapAvailable){
mapFromToValueMap = rawDataFieldMap.get('Market');
if(mapFromToValueMap != null){
String mapFromValue = dataRow.Market__c;
if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
if(String.isNotBlank(mapToValue)){
rowUpdate.Market__c = mapToValue;                       
dataReconciled = true;
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'Market';
}else{
pickListValues = 'Market';
} 
dataReconciled = true;
isErrorInRecord = true;
}                                 
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'Market';
}else{
pickListValues = 'Market';
} 
dataReconciled = true;
isErrorInRecord = true;
}       
}
if(String.isNotBlank(dataRow.Remarks__c)){
if(isRawMapAvailable){
mapFromToValueMap = rawDataFieldMap.get('Remarks');
if(mapFromToValueMap != null){
String mapFromValue = dataRow.Remarks__c;
if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
if(String.isNotBlank(mapToValue)){
rowUpdate.Remarks__c = mapToValue;                       
dataReconciled = true;
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'Remark';
}else{
pickListValues = 'Remark';
}                                    
dataReconciled = true;
isErrorInRecord = true;
}                                 
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'Remark';
}else{
pickListValues = 'Remark';
}    
dataReconciled = true;
isErrorInRecord = true;
}         
}
if(String.isNotBlank(dataRow.LOB__c)){
if(isRawMapAvailable){
mapFromToValueMap = rawDataFieldMap.get('LOB');
if(mapFromToValueMap != null){
String mapFromValue = dataRow.LOB__c;
if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
if(String.isNotBlank(mapToValue)){
rowUpdate.LOB__c = mapToValue;                       
dataReconciled = true;
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'LOB';
}else{
pickListValues = 'LOB';
}    
dataReconciled = true;
isErrorInRecord = true;
}                                
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'LOB';
}else{
pickListValues = 'LOB';
}  
dataReconciled = true;
isErrorInRecord = true;
}          
}
if(String.isNotBlank(dataRow.SO_Number__c)){
if(isRawMapAvailable){
mapFromToValueMap = rawDataFieldMap.get('SONumber');
if(mapFromToValueMap != null){
String mapFromValue = dataRow.SO_Number__c;
if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
if(String.isNotBlank(mapToValue)){
rowUpdate.SO_Number__c = mapToValue;                       
dataReconciled = true;
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'SONumber';
}else{
pickListValues = 'SONumber';
}  
dataReconciled = true;
isErrorInRecord = true;
}                                 
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'SONumber';
}else{
pickListValues = 'SONumber';
}  
dataReconciled = true;
isErrorInRecord = true;
}         
}
if(String.isNotBlank(dataRow.Production_Country__c)){
if(isRawMapAvailable){
mapFromToValueMap = rawDataFieldMap.get('ProductionCountry');
if(mapFromToValueMap != null){
String mapFromValue = dataRow.Production_Country__c;
if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
if(String.isNotBlank(mapToValue)){
rowUpdate.Production_Country__c = mapToValue;                       
dataReconciled = true;
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'ProductionCountry';
}else{
pickListValues = 'ProductionCountry';
}  
dataReconciled = true;
isErrorInRecord = true;
}                                
}
}else{
if(String.isNotBlank(pickListValues)){
pickListValues += ';'+ 'ProductionCountry';
}else{
pickListValues = 'ProductionCountry';
}  
dataReconciled = true;
isErrorInRecord = true;
}          
} 
System.debug('::::::PROCESS SALES DATA :::::dataReconciled:::::::::::::::::::::::::'+dataReconciled);
if(dataReconciled){                 
if(isErrorInRecord){
rowUpdate.ErrorMapData__c = pickListValues;
rowUpdate.Record_Status__c = '1 - Error In Data Validation';
reconcileComplete = false; 
}
reconcileDataRowForUpdate.add(rowUpdate);                                        
}else{
reconcileDataRowForUpdate.add(rowUpdate);
}
}
}
/// Updating the reconciled data back into the stage table
if(reconcileDataRowForUpdate.size() > 0){
update reconcileDataRowForUpdate;            
}


}
return reconcileComplete;
}*/
    
    public decimal isValueNumeric(String valuePassed){
        decimal isStock = null;
        try{
            isStock = decimal.valueOf(valuePassed);           
        }catch(Exception e){}
        return isStock;
    }
    
    public class applicationException extends Exception {}
    
    public static map<string,string> getSalesWeekCountNew(string selMonth, string selYear) {
        //system.debug('selMonth:'+selMonth+'selYear:'+selYear);
        Map <String, Integer> monthNumber = new Map <String, Integer> {'jan'=>1, 'feb'=>2
            , 'mar'=>3, 'apr'=>4, 'may'=>5, 'jun'=>6, 'jul'=>7, 'aug'=>8, 'sep'=>9
            , 'oct'=>10, 'nov'=>11, 'dec'=>12};
                Map <String, String> monthString = new Map <String, String> {'1'=>'jan', '2'=>'feb'
                    , '3'=>'mar', '4'=>'apr', '5'=>'may', '6'=>'jun', '7'=>'jul', '8'=>'aug', '9'=>'sep'
                    , '10'=>'oct', '11'=>'nov', '12'=>'dec'};
                        //Date today = Date.today();        
                        
                        Integer dayStart = Integer.valueOf('01');
        Integer monthStart = monthNumber.get(selMonth.toLowerCase());
        Integer yearStart = Integer.valueOf(selYear);    
        Date parsedDateStart = Date.newInstance(yearStart,monthStart,dayStart); 
        //System.debug('parsedDateStart'+parsedDateStart); 
        
        Integer dayEnd = Integer.valueOf('01');
        Integer monthEnd = parsedDateStart.month();
        Integer yearEnd = parsedDateStart.year();
        Integer nextYear= parsedDateStart.year();
        boolean checkNxtYear = false;
        if(monthEnd == 12){
            monthEnd = 01;
            nextYear ++;
            checkNxtYear = true;
        }else{
            monthEnd++;
        }
        
        Date parsedDateEnd = Date.newInstance(nextYear,monthEnd,dayStart);        
        
        Integer startWeek = processSalesData.weeknumber(parsedDateStart);
        Integer endWeek = processSalesData.weeknumber(parsedDateEnd);
        if(checkNxtYear){
            if(endWeek == 1){
                endWeek=52;
            }
        }
        Integer difference = (endWeek - startWeek) ;
        
        Integer countOfWeeks = startWeek;
        Map<string,string> yearWeekMonth = new Map<string,string>();
        
        for (Integer k = 0; k <= difference; k++) { 
            yearWeekMonth.put(yearStart+'#'+'wk'+getTwoDigit(countOfWeeks)+'#'+monthString.get(String.valueOf(monthStart)), yearStart+'#'+'wk'+getTwoDigit(countOfWeeks)+'#'+monthString.get(String.valueOf(monthStart)));                    
            countOfWeeks++;
        }
        
        return yearWeekMonth;
    }
    //***************************************************************//
    //This method returns the start of the week number for a given date ie for a month
    public static Integer weeknumber(Date startdate){
        
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
        Integer currentyear = startdate.year();
        
        Date yearstartdate = date.newinstance(currentyear, 01, 01);
        Date year2ndweek = yearstartdate.adddays(7).tostartofweek();
        
        if(startdate<year2ndweek)
            return 1;
        integer numberDaysDue = year2ndweek.daysBetween(todaydateinstance);
        
        Integer numberOfWeek;
        if(math.mod(numberDaysDue,7)==0)
            numberOfWeek = math.MOD(Integer.valueof(math.FLOOR( ( numberDaysDue )/7)),52)+1;
        else
            numberOfWeek = math.MOD(Integer.valueof(math.FLOOR( ( numberDaysDue )/7)),52)+2;
        
        //system.debug('numberOfWeek'+numberOfWeek);
        return numberOfWeek;
        
    }
    
    public static integer getWeekCount(Date d) {
        Integer days = Date.daysInMonth(d.year(), d.month()); 
        decimal dec = decimal.valueOf(days);
        decimal weekCount =(dec/7).setScale(4);
        integer weeksCounts = integer.valueOf(Math.ceil(weekCount));
        return weeksCounts;
    }
    public static string getTwoDigit(integer intMonth) {
        string weekCount = String.valueOf(intMonth);
        string formatWeekCount;
        if(weekCount.length() == 1){            
            formatWeekCount = '0'+weekCount;
        }else{
            formatWeekCount = weekCount;
        }
        return formatWeekCount;
    }
    public static map<string,string> getSalesWeekList(string selMonth, string selYear, String selcomp) {
        //system.debug('selMonth:'+selMonth+'selYear:'+selYear+' '+'selcomp:'+selcomp);
        Map <String, Integer> monthNumber = new Map <String, Integer> {'jan'=>1, 'feb'=>2
            , 'mar'=>3, 'apr'=>4, 'may'=>5, 'jun'=>6, 'jul'=>7, 'aug'=>8, 'sep'=>9
            , 'oct'=>10, 'nov'=>11, 'dec'=>12};
                Map <String, String> monthString = new Map <String, String> {'1'=>'jan', '2'=>'feb'
                    , '3'=>'mar', '4'=>'apr', '5'=>'may', '6'=>'jun', '7'=>'jul', '8'=>'aug', '9'=>'sep'
                    , '10'=>'oct', '11'=>'nov', '12'=>'dec'};       
                        
                        Integer dayStart = Integer.valueOf('01');
        Integer monthStart = monthNumber.get(selMonth.toLowerCase());
        Integer yearStart = Integer.valueOf(selYear);    
        Date parsedDateStart = Date.newInstance(yearStart,monthStart,dayStart);
        
        Integer dayEnd = Integer.valueOf('01');
        Integer monthEnd = parsedDateStart.month();
        Integer yearEnd = parsedDateStart.year();
        Integer nextYear= parsedDateStart.year();
        boolean checkNxtYear = false;
        if(monthEnd == 12){
            monthEnd = 01;
            nextYear ++;
            checkNxtYear = true;
        }else{
            monthEnd++;
        }
        
        Date parsedDateEnd = Date.newInstance(nextYear,monthEnd,dayStart);       
        
        Integer startWeek = processSalesData.weeknumber(parsedDateStart);
        Integer endWeek = processSalesData.weeknumber(parsedDateEnd);
        if(checkNxtYear){
            if(endWeek == 1){
                endWeek=52;
            }
        }
        Integer difference = (endWeek - startWeek) ;
        
        Integer countOfWeeks = startWeek;
        Map<string,string> yearWeekMonth = new Map<string,string>();
        //getSalesMasterData getSalesMaster = new getSalesMasterData();
        //System.debug('INSIDE getSalesWeekCountWithPartnerCompanyNewCompanyList:: before getSalesOnlyCompanyMap'+batchId);
        //Map<string,string> partnerCompanyMap = getSalesMaster.getSalesOnlyCompanyMap(batchId);               
        for (Integer k = 0; k <= difference; k++) {
            //if(partnerCompanyMap != null){
            //for(string objVar : partnerCompanyMap.keySet()){
            //string partnerCmpName = partnerCompanyMap.get(objVar);
            string partnerCmpName = selcomp;
            yearWeekMonth.put('wk'+getTwoDigit(countOfWeeks),'wk'+getTwoDigit(countOfWeeks));  
            
            //}
            countOfWeeks++;
            //}           
        }       
        return yearWeekMonth;
    }
    
    public static map<string,string> getSalesWeekCountWithPartnerCompanyNewCompanyList(string selMonth, string selYear, String selcomp) {
        //system.debug('selMonth:'+selMonth+'selYear:'+selYear+' '+'selcomp:'+selcomp);
        Map <String, Integer> monthNumber = new Map <String, Integer> {'jan'=>1, 'feb'=>2
            , 'mar'=>3, 'apr'=>4, 'may'=>5, 'jun'=>6, 'jul'=>7, 'aug'=>8, 'sep'=>9
            , 'oct'=>10, 'nov'=>11, 'dec'=>12};
                Map <String, String> monthString = new Map <String, String> {'1'=>'jan', '2'=>'feb'
                    , '3'=>'mar', '4'=>'apr', '5'=>'may', '6'=>'jun', '7'=>'jul', '8'=>'aug', '9'=>'sep'
                    , '10'=>'oct', '11'=>'nov', '12'=>'dec'};       
                        
                        Integer dayStart = Integer.valueOf('01');
        Integer monthStart = monthNumber.get(selMonth.toLowerCase());
        Integer yearStart = Integer.valueOf(selYear);    
        Date parsedDateStart = Date.newInstance(yearStart,monthStart,dayStart);
        
        Integer dayEnd = Integer.valueOf('01');
        Integer monthEnd = parsedDateStart.month();
        Integer yearEnd = parsedDateStart.year();
        Integer nextYear= parsedDateStart.year();
        boolean checkNxtYear = false;
        if(monthEnd == 12){
            monthEnd = 01;
            nextYear ++;
            checkNxtYear = true;
        }else{
            monthEnd++;
        }
        
        Date parsedDateEnd = Date.newInstance(nextYear,monthEnd,dayStart);       
        
        Integer startWeek = processSalesData.weeknumber(parsedDateStart);
        Integer endWeek = processSalesData.weeknumber(parsedDateEnd);
        if(checkNxtYear){
            if(endWeek == 1){
                endWeek=52;
            }
        }
        Integer difference = (endWeek - startWeek) ;
        
        Integer countOfWeeks = startWeek;
        Map<string,string> yearWeekMonth = new Map<string,string>();
        //getSalesMasterData getSalesMaster = new getSalesMasterData();
        //System.debug('INSIDE getSalesWeekCountWithPartnerCompanyNewCompanyList:: before getSalesOnlyCompanyMap'+batchId);
        //Map<string,string> partnerCompanyMap = getSalesMaster.getSalesOnlyCompanyMap(batchId);               
        for (Integer k = 0; k <= difference; k++) {
            //if(partnerCompanyMap != null){
            //for(string objVar : partnerCompanyMap.keySet()){
            //string partnerCmpName = partnerCompanyMap.get(objVar);
            string partnerCmpName = selcomp;
            yearWeekMonth.put(yearStart+'#'+'wk'+getTwoDigit(countOfWeeks)+'#'+monthString.get(String.valueOf(monthStart))+'#'+partnerCmpName.toLowerCase(), partnerCmpName.toLowerCase()+'::'+'wk'+getTwoDigit(countOfWeeks));                    
            //}
            countOfWeeks++;
            //}           
        }       
        return yearWeekMonth;
    }
    
    public static Map<string,string> getRetailerLob(){
        Sales_Transaction__c customData = Sales_Transaction__c.getInstance();
        string vendorValues = customData.Vendor__c.toLowerCase();
        List<string> valueFormated = vendorValues.split(',');
        Set<String> retailerName = new Set<String>();
        for (string valFormt : valueFormated){
            retailerName.add(valFormt);
        }
        list<Retailer_Code__c> retailer = [Select  Name, JDE_LOB__c from Retailer_Code__c where Name IN:retailerName];
        
        Map<string,string> vendorListMap = new Map<string,string>();
        for (Retailer_Code__c retVal : retailer){
            vendorListMap.put(retVal.Name, retVal.JDE_LOB__c);
        }
        return vendorListMap;
    }
    //***************getting the field with the object for the FieldName passed along with the Object****/
    //
    public static void getfieldWithObject(String fieldName, String newValue,Sales_Transaction_Stage__c salesTransStage){
        
        if(String.isNotBlank(fieldName)){            
            if(fieldName.equalsIgnoreCase('Year')){
                salesTransStage.Year__c = newValue ;
            }else if(fieldName.equalsIgnoreCase('Week')){
                salesTransStage.Week__c = newValue ;
            }else if(fieldName.equalsIgnoreCase('Month')){
                salesTransStage.Month__c = newValue ;
            }else if(fieldName.equalsIgnoreCase('Material')){
                salesTransStage.Material__c = newValue ;
            }else if(fieldName.equalsIgnoreCase('Source')){
                salesTransStage.Source__c = newValue ;
            }else if(fieldName.equalsIgnoreCase('Category')){
                salesTransStage.Category__c = newValue ;
            }else if(fieldName.equalsIgnoreCase('Family')){
                salesTransStage.Family__c = newValue ;
            }else if(fieldName.equalsIgnoreCase('Label')){
                salesTransStage.Label__c = newValue ;
            }else if(fieldName.equalsIgnoreCase('Vendor')){
                salesTransStage.Vendor__c = newValue ;
            }else if(fieldName.equalsIgnoreCase('Division')){
                salesTransStage.Division__c = newValue ;
            }else if(fieldName.equalsIgnoreCase('Market')){
                salesTransStage.Market__c = newValue ;
            }else if(fieldName.equalsIgnoreCase('Remark')){
                salesTransStage.Remark__c = newValue ;
            }else if(fieldName.equalsIgnoreCase('LOB')){
                salesTransStage.LOB__c = newValue ;
            }else if(fieldName.equalsIgnoreCase('ItemCode')){
                salesTransStage.Item_code__c = newValue ;
            }else if(fieldName.equalsIgnoreCase('Model')){
                salesTransStage.Model__c = newValue ;
            }else if(fieldName.equalsIgnoreCase('PrintedLogo')){
                salesTransStage.Printed_Logo__c = newValue ;
            }else if(fieldName.equalsIgnoreCase('Color')){
                salesTransStage.Color__c = newValue ;
            }else if(fieldName.equalsIgnoreCase('Customer')){
                salesTransStage.Customer__c = newValue ;
            }else if(fieldName.equalsIgnoreCase('LocalName')){
                salesTransStage.Customer_local_name__c = newValue ;
            }else if(fieldName.equalsIgnoreCase('MainettiBrand')){
                salesTransStage.Mainetti_Brand__c = newValue ;
            }else if(fieldName.equalsIgnoreCase('SubCategory')){
                salesTransStage.Sub_Category__c = newValue ;
            }else if(fieldName.equalsIgnoreCase('OrderType')){
                salesTransStage.Order_Type__c = newValue ;
            }else if(fieldName.equalsIgnoreCase('UnitSold')){
                salesTransStage.Unit_Sold__c = newValue ;
            }else if(fieldName.equalsIgnoreCase('LocalCurrency')){
                salesTransStage.Local_Currency__c = newValue ;
            }else if(fieldName.equalsIgnoreCase('ShippedToFactory')){
                salesTransStage.Shipped_To_Factory__c = newValue ;
            }else if(fieldName.equalsIgnoreCase('ShippedToCountry')){
                salesTransStage.Shipped_To_Country__c = newValue ;
            }else if(fieldName.equalsIgnoreCase('EndUser')){
                salesTransStage.End_user__c = newValue ;
            }else if(fieldName.equalsIgnoreCase('RetailerBrand')){
                salesTransStage.Retailer_Brand__c = newValue ;
            }else if(fieldName.equalsIgnoreCase('RoyaltyRate')){
                salesTransStage.Royalty_Rate__c = newValue ;
            }else if(fieldName.equalsIgnoreCase('SONumber')){
                salesTransStage.SO_Number__c = newValue ;
            }else if(fieldName.equalsIgnoreCase('ProductionCountry')){
                salesTransStage.Production_Country__c = newValue ;
            }
        }
        
    }
    //**** This method returns the field API name based on the fieldName
    public boolean updateTransStagNInsertErrorMapValues(String fieldName,String oldValue,String newValue,String batchId,String companyName,String errMap,String pickListToRemove){
        Boolean transactionStatus = true;
        String fieldApiName;
        if(String.isNotBlank(fieldName)){
            
            if(fieldName.equalsIgnoreCase('Year')){
                fieldApiName ='Year__c';
            }else if(fieldName.equalsIgnoreCase('Week')){
                fieldApiName ='Week__c';
            }else if(fieldName.equalsIgnoreCase('Month')){
                fieldApiName ='Month__c';
            }else if(fieldName.equalsIgnoreCase('Material')){
                fieldApiName ='Material__c';
            }else if(fieldName.equalsIgnoreCase('Source')){
                fieldApiName ='Source__c';
            }else if(fieldName.equalsIgnoreCase('Category')){
                fieldApiName ='Category__c';
            }else if(fieldName.equalsIgnoreCase('Family')){
                fieldApiName ='Family__c';
            }else if(fieldName.equalsIgnoreCase('Label')){
                fieldApiName ='Label__c';
            }else if(fieldName.equalsIgnoreCase('Vendor')){
                fieldApiName ='Vendor__c';
            }else if(fieldName.equalsIgnoreCase('Division')){
                fieldApiName ='Division__c';
            }else if(fieldName.equalsIgnoreCase('Market')){
                fieldApiName ='Market__c';
            }else if(fieldName.equalsIgnoreCase('Remark')){
                fieldApiName ='Remark__c';
            }else if(fieldName.equalsIgnoreCase('LOB')){
                fieldApiName ='LOB__c';
            }else if(fieldName.equalsIgnoreCase('ItemCode')){
                fieldApiName ='Item_code__c';
            }else if(fieldName.equalsIgnoreCase('Model')){
                fieldApiName ='Model__c';
            }else if(fieldName.equalsIgnoreCase('PrintedLogo')){
                fieldApiName ='Printed_Logo__c	';
            }else if(fieldName.equalsIgnoreCase('Color')){
                fieldApiName ='Color__c';
            }else if(fieldName.equalsIgnoreCase('Customer')){
                fieldApiName ='Customer__c';
            }else if(fieldName.equalsIgnoreCase('LocalName')){
                fieldApiName ='Customer_local_name__c';
            }else if(fieldName.equalsIgnoreCase('MainettiBrand')){
                fieldApiName ='Mainetti_Brand__c';
            }else if(fieldName.equalsIgnoreCase('SubCategory')){
                fieldApiName ='Sub_Category__c';
            }else if(fieldName.equalsIgnoreCase('OrderType')){
                fieldApiName ='Order_Type__c';
            }else if(fieldName.equalsIgnoreCase('UnitSold')){
                fieldApiName ='Unit_Sold__c';
            }else if(fieldName.equalsIgnoreCase('LocalCurrency')){
                fieldApiName ='Local_Currency__c';
            }else if(fieldName.equalsIgnoreCase('ShippedToFactory')){
                fieldApiName ='Shipped_To_Factory__c';
            }else if(fieldName.equalsIgnoreCase('ShippedToCountry')){
                fieldApiName ='Shipped_To_Country__c';
            }else if(fieldName.equalsIgnoreCase('EndUser')){
                fieldApiName ='End_user__c';
            }else if(fieldName.equalsIgnoreCase('RetailerBrand')){
                fieldApiName ='Retailer_Brand__c';
            }else if(fieldName.equalsIgnoreCase('RoyaltyRate')){
                fieldApiName ='Royalty_Rate__c';
            }else if(fieldName.equalsIgnoreCase('SONumber')){
                fieldApiName ='SO_Number__c';
            }else if(fieldName.equalsIgnoreCase('ProductionCountry')){
                fieldApiName ='Production_Country__c';
            }
        }
        
        String picklist = getPickListValues(errMap,pickListToRemove);
        List<Sales_Transaction_Stage__c> updateNewValueStage = new List<Sales_Transaction_Stage__c>();
        String queryString = 'Select Id, '+fieldApiName+' from Sales_Transaction_Stage__c where ' +fieldApiName +'=\'' + String.escapeSingleQuotes(oldValue) + '\'   and Upload_Batch_No__c= \'' + String.escapeSingleQuotes(batchId) + '\'  and Company__c=\'' + String.escapeSingleQuotes(companyName) + '\'';
        List<Sales_Transaction_Stage__c> stageOldValueData  = Database.query(queryString);
        for(Sales_Transaction_Stage__c oldStageObj :stageOldValueData)
        {
            getfieldWithObject(fieldName,newValue,oldStageObj);                       
            oldStageObj.ErrorMapData__c = picklist;   
            updateNewValueStage.add(oldStageObj);
        }
        
        Sales_Error_Mapping__c insertSalesError =  insertSalesErrorMapping(fieldName,newValue,oldValue,companyName);
        
        try{
            if(insertSalesError != null && updateNewValueStage.size() > 0) {
                update updateNewValueStage;    
                insert insertSalesError; 
            }            
        }catch(DMLException e){
            System.debug('Exception during the Update and Insert of Error Map and Stage values'+e.getMessage());
            transactionStatus = false;
        }
        return transactionStatus;
    }
    public static Sales_Error_Mapping__c insertSalesErrorMapping(string recordType ,string newValue,string oldValue,String companyName)
    {
        Sales_Error_Mapping__c salesErrorMapObj = new Sales_Error_Mapping__c();
        
        salesErrorMapObj.Company__c = companyName;
        salesErrorMapObj.Raw_Data_Field__c = recordType;
        salesErrorMapObj.Map_From_Value__c = oldValue ;
        salesErrorMapObj.Map_To_Value__c = newValue;   
        
        return salesErrorMapObj;
    }
    Public static string getPickListValues(String errMap,string pickListToRemove){        
        String pickListValue=''; 
        if(String.isNotBlank(errMap)){
            List<String> errMapLst = errMap.split(';');                   
            String removeValue = pickListToRemove;        
            for (String mapLst : errMapLst) {            
                if(mapLst != removeValue){                
                    pickListValue += mapLst+';';                
                }            
            }    
        }
        return pickListValue;         
    }
    //*******This method generates the key for the map for groupping of the error field values as per the field name
    public static String generateMapKeyString(Sales_Transaction_Stage__c salesTransStage){
        System.debug('salesTransStage:'+salesTransStage);
        String fieldsWithError = salesTransStage.ErrorMapData__c;
        //System.debug('ErrorMapData__c:'+ErrorMapData__c);
        System.debug('fieldsWithError:'+fieldsWithError);
        String generatedMapKeyString='';     
        if(fieldsWithError.contains('Year')){
            generatedMapKeyString = 'Year='+ salesTransStage.Year__c ;
        }else if(fieldsWithError.contains('Week')){
            if(String.isNotBlank(generatedMapKeyString)){
                generatedMapKeyString += '#Week='+ salesTransStage.Week__c ;
            }else{
                generatedMapKeyString = 'Week='+ salesTransStage.Week__c ;
            }                
        }else if(fieldsWithError.contains('Month')){
            if(String.isNotBlank(generatedMapKeyString)){
                generatedMapKeyString += '#Month='+ salesTransStage.Month__c ;
            }else{
                generatedMapKeyString = 'Month='+ salesTransStage.Month__c ;
            }                       
        }else if(fieldsWithError.contains('Material')){
            if(String.isNotBlank(generatedMapKeyString)){
                generatedMapKeyString += '#Material='+ salesTransStage.Material__c ;
            }else{
                generatedMapKeyString = 'Material='+ salesTransStage.Material__c ;
            }                 
        }else if(fieldsWithError.contains('Source')){
            if(String.isNotBlank(generatedMapKeyString)){
                generatedMapKeyString += '#Source='+ salesTransStage.Source__c ;
            }else{
                generatedMapKeyString = 'Source='+ salesTransStage.Source__c ;
            }                   
        }else if(fieldsWithError.contains('Category')){
            if(String.isNotBlank(generatedMapKeyString)){
                generatedMapKeyString += '#Category='+ salesTransStage.Category__c ;
            }else{
                generatedMapKeyString = 'Category='+ salesTransStage.Category__c ;
            }  
        }else if(fieldsWithError.contains('Family')){
            if(String.isNotBlank(generatedMapKeyString)){
                generatedMapKeyString += '#Family='+ salesTransStage.Family__c ;
            }else{
                generatedMapKeyString = 'Family='+ salesTransStage.Family__c ;
            } 
        }else if(fieldsWithError.contains('Label')){
            if(String.isNotBlank(generatedMapKeyString)){
                generatedMapKeyString += '#Label='+ salesTransStage.Label__c ;
            }else{
                generatedMapKeyString = 'Label='+ salesTransStage.Label__c ;
            } 
        }else if(fieldsWithError.contains('Vendor')){
            if(String.isNotBlank(generatedMapKeyString)){
                generatedMapKeyString += '#Vendor='+ salesTransStage.Vendor__c;
            }else{
                generatedMapKeyString = 'Vendor='+ salesTransStage.Vendor__c;
            } 
        }else if(fieldsWithError.contains('Division')){
            if(String.isNotBlank(generatedMapKeyString)){
                generatedMapKeyString += '#Division='+ salesTransStage.Division__c;
            }else{
                generatedMapKeyString = 'Division='+ salesTransStage.Division__c;
            } 
        }else if(fieldsWithError.contains('Market')){
            if(String.isNotBlank(generatedMapKeyString)){
                generatedMapKeyString += '#Market='+ salesTransStage.Market__c;
            }else{
                generatedMapKeyString = 'Market='+ salesTransStage.Market__c;
            } 
        }else if(fieldsWithError.contains('Remark')){
            if(String.isNotBlank(generatedMapKeyString)){
                generatedMapKeyString += '#Remark='+ salesTransStage.Remark__c;
            }else{
                generatedMapKeyString = 'Remark='+ salesTransStage.Remark__c;
            } 
        }else if(fieldsWithError.contains('LOB')){
            if(String.isNotBlank(generatedMapKeyString)){
                generatedMapKeyString += '#LOB='+ salesTransStage.LOB__c;
            }else{
                generatedMapKeyString = 'LOB='+ salesTransStage.LOB__c;
            } 
        }else if(fieldsWithError.contains('ItemCode')){
            if(String.isNotBlank(generatedMapKeyString)){
                generatedMapKeyString += '#ItemCode='+ salesTransStage.Item_code__c;
            }else{
                generatedMapKeyString = 'ItemCode='+ salesTransStage.Item_code__c;
            } 
        }else if(fieldsWithError.contains('Model')){
            if(String.isNotBlank(generatedMapKeyString)){
                generatedMapKeyString += '#Model='+ salesTransStage.Model__c;
            }else{
                generatedMapKeyString = 'Model='+ salesTransStage.Model__c;
            } 
        }else if(fieldsWithError.contains('PrintedLogo')){
            if(String.isNotBlank(generatedMapKeyString)){
                generatedMapKeyString += '#PrintedLogo='+ salesTransStage.Printed_Logo__c;
            }else{
                generatedMapKeyString = 'PrintedLogo='+ salesTransStage.Printed_Logo__c;
            } 
        }else if(fieldsWithError.contains('Color')){
            if(String.isNotBlank(generatedMapKeyString)){
                generatedMapKeyString += '#Color='+ salesTransStage.Color__c;
            }else{
                generatedMapKeyString = 'Color='+ salesTransStage.Color__c;
            } 
        }else if(fieldsWithError.contains('Customer')){
            if(String.isNotBlank(generatedMapKeyString)){
                generatedMapKeyString += '#Customer='+ salesTransStage.Customer__c;
            }else{
                generatedMapKeyString = 'Customer='+ salesTransStage.Customer__c;
            } 
        }else if(fieldsWithError.contains('LocalName')){
            if(String.isNotBlank(generatedMapKeyString)){
                generatedMapKeyString += '#LocalName='+ salesTransStage.Customer_local_name__c;
            }else{
                generatedMapKeyString = 'LocalName='+ salesTransStage.Customer_local_name__c;
            } 
        }else if(fieldsWithError.contains('MainettiBrand')){
            if(String.isNotBlank(generatedMapKeyString)){
                generatedMapKeyString += '#MainettiBrand='+ salesTransStage.Mainetti_Brand__c;
            }else{
                generatedMapKeyString = 'MainettiBrand='+ salesTransStage.Mainetti_Brand__c;
            } 
        }else if(fieldsWithError.contains('SubCategory')){
            if(String.isNotBlank(generatedMapKeyString)){
                generatedMapKeyString += '#SubCategory='+ salesTransStage.Sub_Category__c;
            }else{
                generatedMapKeyString = 'SubCategory='+ salesTransStage.Sub_Category__c;
            } 
        }else if(fieldsWithError.contains('OrderType')){
            if(String.isNotBlank(generatedMapKeyString)){
                generatedMapKeyString += '#OrderType='+ salesTransStage.Order_Type__c;
            }else{
                generatedMapKeyString = 'OrderType='+ salesTransStage.Order_Type__c;
            } 
        }else if(fieldsWithError.equalsIgnoreCase('UnitSold')){
            if(String.isNotBlank(generatedMapKeyString)){
                generatedMapKeyString += '#UnitSold='+ salesTransStage.Unit_Sold__c;
            }else{
                generatedMapKeyString = 'UnitSold='+ salesTransStage.Unit_Sold__c;
            } 
        }else if(fieldsWithError.contains('LocalCurrency')){
            if(String.isNotBlank(generatedMapKeyString)){
                generatedMapKeyString += '#LocalCurrency='+ salesTransStage.Local_Currency__c;
            }else{
                generatedMapKeyString = 'LocalCurrency='+ salesTransStage.Local_Currency__c;
            } 
        }else if(fieldsWithError.contains('ShippedToFactory')){
            if(String.isNotBlank(generatedMapKeyString)){
                generatedMapKeyString += '#ShippedToFactory='+ salesTransStage.Shipped_To_Factory__c;
            }else{
                generatedMapKeyString = 'ShippedToFactory='+ salesTransStage.Shipped_To_Factory__c;
            } 
        }else if(fieldsWithError.contains('ShippedToCountry')){
            if(String.isNotBlank(generatedMapKeyString)){
                generatedMapKeyString += '#ShippedToCountry='+ salesTransStage.Shipped_To_Country__c;
            }else{
                generatedMapKeyString = 'ShippedToCountry='+ salesTransStage.Shipped_To_Country__c;
            } 
        }else if(fieldsWithError.contains('EndUser')){
            if(String.isNotBlank(generatedMapKeyString)){
                generatedMapKeyString += '#EndUser='+ salesTransStage.End_user__c;
            }else{
                generatedMapKeyString = 'EndUser='+ salesTransStage.End_user__c;
            } 
        }else if(fieldsWithError.contains('RetailerBrand')){
            if(String.isNotBlank(generatedMapKeyString)){
                generatedMapKeyString += '#RetailerBrand='+ salesTransStage.Retailer_Brand__c;
            }else{
                generatedMapKeyString = 'RetailerBrand='+ salesTransStage.Retailer_Brand__c;
            } 
        }else if(fieldsWithError.contains('RoyaltyRate')){
            if(String.isNotBlank(generatedMapKeyString)){
                generatedMapKeyString += '#RoyaltyRate='+ salesTransStage.Royalty_Rate__c;
            }else{
                generatedMapKeyString = 'RoyaltyRate='+ salesTransStage.Royalty_Rate__c;
            } 
        }else if(fieldsWithError.contains('SONumber')){
            if(String.isNotBlank(generatedMapKeyString)){
                generatedMapKeyString += '#SONumber='+ salesTransStage.SO_Number__c;
            }else{
                generatedMapKeyString = 'SONumber='+ salesTransStage.SO_Number__c;
            } 
        }else if(fieldsWithError.contains('ProductionCountry')){
            if(String.isNotBlank(generatedMapKeyString)){
                generatedMapKeyString += '#ProductionCountry='+ salesTransStage.Production_Country__c;
            }else{
                generatedMapKeyString = 'ProductionCountry='+ salesTransStage.Production_Country__c;
            } 
        }      
        return generatedMapKeyString;           
    }
    public static string callingCustomSettings(){
        Sales_Transaction__c customData = Sales_Transaction__c.getInstance();
        string vendorProduction = string.valueOf(customData.Production_Country__c);
        List<String> vendorProductionResult = vendorProduction.split(',');
        string vendorColor = string.valueOf(customData.Color__c);
        List<String> vendorColorResult = vendorColor.split(',');
        string vendorDivision = string.valueOf(customData.Division__c);
        List<String> vendorDivisionResult = vendorDivision.split(',');
        string vendorLabel = string.valueOf(customData.Label__c);
        List<String> vendorLabelResult = vendorLabel.split(',');
        string vendorBrand = string.valueOf(customData.Brand__c);
        List<String> vendorBrandResult = vendorBrand.split(',');
        return vendorProduction;
    }
    /*   public static string nullFieldDataValidation(Sales_Transaction_Stage__c dataRow,Sales_Transaction_Stage__c rowUpdate,String remarks,Boolean isDataValid)
{
System.debug('#####Insdie nullFieldDataValidation');
Sales_Transaction__c customData = Sales_Transaction__c.getInstance();
string vendorProduction = string.valueOf(customData.Production_Country__c);
string vendorColor = string.valueOf(customData.Color__c);
string vendorDivision = string.valueOf(customData.Division__c);
string vendorLabel = string.valueOf(customData.Label__c);
string vendorBrand = string.valueOf(customData.Brand__c);
String label = dataRow.Label__c;
String orderType = dataRow.Order_Type__c;

System.debug('#####Before IsBlank');
if(String.isNotBlank(dataRow.Vendor__c))
{ 
if(String.isNotBlank(vendorProduction))
{
if(vendorProduction.contains(dataRow.Vendor__c))
{
if(String.isBlank(dataRow.Production_Country__c)){                   
rowUpdate.Production_Country_FB__c = True;
isDataValid = false;
remarks += '\r\n Production Country cannot be empty for Vendor:'+dataRow.Vendor__c;
}
}
}
if(String.isNotBlank(vendorColor))
{
if(vendorColor.contains(dataRow.Vendor__c))
{
if(String.isBlank(dataRow.Color__c)){
rowUpdate.Color_FB__c = True;
isDataValid = false;
remarks += '\r\n Color cannot be empty for Vendor:'+dataRow.Vendor__c;
//system.debug('Color Ending');
}
}
}
if(String.isNotBlank(vendorDivision))
{
if(vendorDivision.contains(dataRow.Vendor__c))
{
if(String.isBlank(dataRow.Division__c)){
rowUpdate.Division_FB__c = True;
isDataValid = false;
remarks += '\r\n Division cannot be empty for Vendor:'+dataRow.Vendor__c;
}
if(vendorDivision.contains(dataRow.Vendor__c))
{  String vendorMacy = dataRow.Vendor__c;
if(vendorMacy.containsIgnoreCase('macy')){
if( String.isNotBlank(label) && String.isNotBlank(orderType))
{
if(label.containsIgnoreCase('PL') && orderType != 'IC'){
if(String.isBlank(dataRow.Division__c)){
rowUpdate.Division_FB__c = True;
isDataValid = false;
remarks += '\r\n Division  cannot be empty for Vendor:'+dataRow.Vendor__c;
}
}
}
}
}
}
}
if(String.isNotBlank(vendorLabel))
{
//System.debug('### dataRow.Vendor__c'+dataRow.Vendor__c);
if(vendorLabel.contains(dataRow.Vendor__c))
{
//System.debug('### dataRow.LOB__c'+dataRow.LOB__c);
if(String.isBlank(dataRow.Label__c) && String.isNotBlank(dataRow.LOB__c)){
if(!dataRow.LOB__c.equalsIgnoreCase('leg')){
rowUpdate.Label_FB__c = True;
isDataValid = false;
remarks += '\r\n Label cannot be empty for Vendor:'+dataRow.Vendor__c;
}
}
}
}
if(String.isNotBlank(vendorBrand))
{
if(vendorBrand.contains(dataRow.Vendor__c))
{    String category = dataRow.Category__c;

if(vendorBrand.contains('DEBENHAMS') && String.isNotBlank(category))
{
if(category.containsIgnoreCase('Hangers')){
if(String.isBlank(dataRow.Retailer_Brand__c)){
rowUpdate.Retailer_Brand_FB__c = True;
isDataValid = false;
remarks += '\r\n Retailer Brand cannot be empty for Vendor:'+dataRow.Vendor__c;
}
}
}
if(  vendorBrand.contains(dataRow.Vendor__c) )
{		if(dataRow.Vendor__c != 'DEBENHAMS'){
if(String.isBlank(dataRow.Retailer_Brand__c)){
rowUpdate.Retailer_Brand_FB__c = True;
isDataValid = false;
remarks += '\r\n Retailer Brand cannot be empty for Vendor:'+dataRow.Vendor__c;
}
}
}
}
}
}
return remarks;
} */
    //--------------------------------------------------------------------------
    public static string nullFieldDataValidationforBulk(Sales_Transaction_Stage__c dataRow,String remarks,Boolean isDataValid)
    {
        System.debug('#####Insdie nullFieldDataValidation');
        Sales_Transaction__c customData = Sales_Transaction__c.getInstance();
        string vendorProduction = string.valueOf(customData.Production_Country__c);
        string vendorColor = string.valueOf(customData.Color__c);
        string vendorDivision = string.valueOf(customData.Division__c);
        string vendorLabel = string.valueOf(customData.Label__c);
        string vendorBrand = string.valueOf(customData.Brand__c);
        String label = dataRow.Label__c;
        String orderType = dataRow.Order_Type__c;
        
        System.debug('#####Before IsBlank');
        if(String.isNotBlank(dataRow.Vendor__c))
        { 
            if(String.isNotBlank(vendorProduction))
            {
                system.debug('vendorProduction:::'+vendorProduction);
                if(vendorProduction.contains(dataRow.Vendor__c))
                {
                    if(String.isBlank(dataRow.Production_Country__c)){                   
                        dataRow.Production_Country_FB__c = True;
                        isDataValid = false;
                        remarks += '\r\n Production Country cannot be empty for Vendor:'+dataRow.Vendor__c;
                    }
                }
            }
            if(String.isNotBlank(vendorColor))
            {
                if(vendorColor.contains(dataRow.Vendor__c))
                {
                    if(String.isBlank(dataRow.Color__c)){
                        dataRow.Color_FB__c = True;
                        isDataValid = false;
                        remarks += '\r\n Color cannot be empty for Vendor:'+dataRow.Vendor__c;
                        //system.debug('Color Ending');
                    }
                }
            }
            if(String.isNotBlank(vendorDivision))
            {
                if(vendorDivision.contains(dataRow.Vendor__c))
                {
                    if(String.isBlank(dataRow.Division__c)){
                        dataRow.Division_FB__c = True;
                        isDataValid = false;
                        remarks += '\r\n Division cannot be empty for Vendor:'+dataRow.Vendor__c;
                    }
                    if(vendorDivision.contains(dataRow.Vendor__c))
                    {  String vendorMacy = dataRow.Vendor__c;
                     if(vendorMacy.containsIgnoreCase('macy')){
                         if( String.isNotBlank(label) && String.isNotBlank(orderType))
                         {
                             if(label.containsIgnoreCase('PL') && orderType != 'IC'){
                                 if(String.isBlank(dataRow.Division__c)){
                                     dataRow.Division_FB__c = True;
                                     isDataValid = false;
                                     remarks += '\r\n Division  cannot be empty for Vendor:'+dataRow.Vendor__c;
                                 }
                             }
                         }
                     }
                    }
                }
            }
            if(String.isNotBlank(vendorLabel))
            {
                //System.debug('### dataRow.Vendor__c'+dataRow.Vendor__c);
                if(vendorLabel.contains(dataRow.Vendor__c))
                {
                    System.debug('### dataRow.LOB__c'+dataRow.LOB__c);
                    if(String.isBlank(dataRow.Label__c) && String.isNotBlank(dataRow.LOB__c)){
                        if(!dataRow.LOB__c.equalsIgnoreCase('leg')){
                            dataRow.Label_FB__c = True;
                            isDataValid = false;
                            remarks += '\r\n Label cannot be empty for Vendor:'+dataRow.Vendor__c;
                        }
                    }
                }
            }
            if(String.isNotBlank(vendorBrand))
            {
                if(vendorBrand.contains(dataRow.Vendor__c))
                {    String category = dataRow.Category__c;
                 System.debug('vendorBrand:::'+vendorBrand);
                 if(vendorBrand.contains('DEBENHAMS') && String.isNotBlank(category))
                 {
                     if(category.containsIgnoreCase('Hangers')){
                         if(String.isBlank(dataRow.Retailer_Brand__c)){
                             dataRow.Retailer_Brand_FB__c = True;
                             isDataValid = false;
                             remarks += '\r\n Retailer Brand cannot be empty for Vendor:'+dataRow.Vendor__c;
                         }
                     }
                 }
                 if(  vendorBrand.contains(dataRow.Vendor__c) )
                 {		if(dataRow.Vendor__c != 'DEBENHAMS'){
                     if(String.isBlank(dataRow.Retailer_Brand__c)){
                         dataRow.Retailer_Brand_FB__c = True;
                         isDataValid = false;
                         remarks += '\r\n Retailer Brand cannot be empty for Vendor:'+dataRow.Vendor__c;
                     }
                 }
                 }
                }
            }
        }
        return remarks;
    }
    
    //############################################################################
    public List<Sales_Transaction_Stage__c> processSalesDataChunk(List<Sales_Transaction_Stage__c> salesTransStagRec,string selcomp,string selMonth,string selYear,Map<Decimal,Map<string,string>>inCorrectFormatMap,Map<string,string>colorMap,Map<string,string> marketMap,Map<string,string>lululemonModelMap,Map<string,string>debenhanModelMap,Map<string,string>debenhanModelBrandKeyMap,Map<string,string>debenhanBrandMap,Map<string,string>vendorDivisionBrandLabelMap,Map<string,string>productionCoungtryMap,Map<string,string>modelWarningMap,Map<string,string>modelCompKeyMap,Map<string,string>dateMap,Map<string,string>companyOnlyMap,Map<string,string>vendorMap,validateSalesRowsBulk.recordValidationStatus recordStatus ,Map<string,Map<string,string>> getNewVendorDivisionBrandLabelMap,Map<string,Retailer_Code__c> getRetailersLabelDivisionBrandCheckMap,Map<string,string> getModelandColorMap,Map<string,string> getSalesDataUploadCheckMap,Map<string,string> getSalesDataUploadColorCheckMap,Map<string,string> checkColorwithModel,Map<string,string> getModelCatFamilyMap,Map<string,string> categoryMap,Map<string,string> subcategoryMap ,Map<string,string> modelwithCatSubCatFamily){
        System.debug('#### Start processSalesDataChunk## recordStatus###'+recordStatus.validateStatus);
        List<Sales_Transaction_Stage__c> salesTransStagUpdate = new List<Sales_Transaction_Stage__c>();
        System.debug('processSalesDataChunk::::processSalesDataChunk'+salesTransStagRec.size());
        for (Sales_Transaction_Stage__c dataRow : salesTransStagRec) {
            // Sales_Transaction_Stage__c rowUpdate = new Sales_Transaction_Stage__c();
            //datarowUpdate.Id = dataRow.Id;            
            Boolean isDataValid = true; 
            String remarks = '';
            System.debug('##### Before missingFieldValue');
            //checking for Missing column values
            boolean missingField =  missingFieldValueBulk(dataRow,inCorrectFormatMap);
            // boolean missingField =  missingFieldValue(dataRow,inCorrectFormatMap);
            
            
           if(!missingField)
            {
                isDataValid = false;
            }
            System.debug('##### BEFORE nullFieldDataValidation after missingField isDataValid'+isDataValid); 
            string vendorValRemarks = nullFieldDataValidationforBulk(dataRow,remarks,isDataValid);
            // string vendorValRemarks = nullFieldDataValidation(dataRow,remarks,isDataValid);
            remarks += vendorValRemarks;
            System.debug('####### AFTER isDataValid:::'+isDataValid);
            //checking the Gross sales and Freight charge values format and data type.
            system.debug('inCorrectFormatMap :'+inCorrectFormatMap);            
            if(inCorrectFormatMap.containsKey(dataRow.Row_No__c)){
                Map<string,string> valuesReturned = inCorrectFormatMap.get(dataRow.Row_No__c);
                
                if(!String.isBlank(valuesReturned.get('Gross'))){
                    remarks = valuesReturned.get('Gross')+ '\r\n' ;
                }
                if(!String.isBlank(valuesReturned.get('Freight'))){
                    remarks += valuesReturned.get('Freight');
                }
                //rowUpdate.Remarks__c =  remarks;
                isDataValid = false;
            }     
            System.debug('isDataValid:::Row_No__c::'+isDataValid);
            // checking for color exits ?
            if(String.isNotBlank(dataRow.Color__c)){
                if(!colorMap.containsKey(dataRow.Color__c.toLowerCase())){
                    dataRow.Color_NF__c = True;
                    isDataValid = false;
                    remarks += '\r\n Color not found';
                }
            }
            System.debug('isDataValid::Color__c:::'+isDataValid+'::dataRow.Color__c:::'+dataRow.Color__c); 
            // checking for market exits ?
            if(String.isNotBlank(dataRow.Market__c)){
                if(!marketMap.containsKey(dataRow.Market__c.toLowerCase())){
                    dataRow.Market_NF__c = True;
                    isDataValid = false;
                    remarks += '\r\n Market not found';
                }
            } 
            System.debug('isDataValid:::::Market__c::'+isDataValid+'::dataRow.Market__c:::'+dataRow.Market__c);
            // checking for vendor exits ?
            if(String.isNotBlank(dataRow.Vendor__c)){                
                if(!vendorMap.containsKey(dataRow.Vendor__c.toLowerCase())){
                    dataRow.Vendor_NF__c = True;
                    isDataValid = false;
                    remarks += '\r\n Vendor not found';
                }
            }
            System.debug('isDataValid:::::Vendor__c::'+isDataValid+'::dataRow.Vendor__c:::'+dataRow.Vendor__c);
            if(String.isNotBlank(dataRow.Company__c)){
                if(dataRow.Company__c != selcomp){
                    dataRow.Company_NF__c = True;
                    isDataValid = false;
                    remarks += '\r\n Company not found';
                }
            } 
            System.debug('isDataValid:::::Company__c::'+isDataValid+'::dataRow.Company__c:::'+dataRow.Company__c);
            // checking for selected month and year.
            string cmpMonYeaValue = '';
            string cmpMonYeaSel = '';
            cmpMonYeaValue =  dataRow.Month__c+'#'+dataRow.Year__c;
            cmpMonYeaSel = selMonth+'#'+selYear;
            if(String.isNotBlank(dataRow.Month__c) && String.isNotBlank(dataRow.Year__c)){
                if(cmpMonYeaValue.toLowerCase() != cmpMonYeaSel.toLowerCase()){
                    dataRow.selected_ui_values__c = True;
                    isDataValid = false;
                    remarks += '\r\n Mismatch with Selected month or year';
                }
            }
            System.debug('isDataValid:::::Year__c::'+isDataValid+'::dataRow.Year__c:::'+dataRow.Year__c);
            // checking for SO number ?            
            if(String.isNotBlank(dataRow.SO_Number__c)){
                if(dataRow.SO_Number__c.length()>15){
                    dataRow.SO_Number_NF__c = True;
                    isDataValid = false;
                    remarks += '\r\n SO Number should not be more than 15 characters';
                }
            }
            System.debug('isDataValid:::::SO_Number__c::'+isDataValid+'::dataRow.SO_Number__c:::'+dataRow.SO_Number__c);
            // checking for LOB ?            
            if(String.isNotBlank(dataRow.LOB__c)){
                if(dataRow.LOB__c.length()>15){
                    dataRow.LOB_NF__c = True;
                    isDataValid = false;
                    remarks += '\r\n LOB should not be more than 15 characters';
                }
            }
            System.debug('isDataValid:::::LOB__c::'+isDataValid+'::dataRow.LOB__c:::'+dataRow.LOB__c);
            //validating calculation
            if(String.isNotBlank(dataRow.Unit_Sold__c)){
                if(dataRow.Unit_Sold__c == '0'){
                    dataRow.unit_sold_warning__c = True;
                    isDataValid = false; 
                }
            }
            System.debug('isDataValid:::::Unit_Sold__c::'+isDataValid+'::dataRow.Unit_Sold__c:::'+dataRow.Unit_Sold__c);
            if(String.isNotBlank(dataRow.ExRate_to_USD__c) && String.isNotBlank(dataRow.ExRate_to_EUR__c)){
                decimal valueOfUsd = decimal.valueOf(dataRow.ExRate_to_USD__c.replaceAll(',',''));
                decimal valueOfEur = decimal.valueOf(dataRow.ExRate_to_EUR__c.replaceAll(',',''));
                if(valueOfUsd!= 0 || valueOfEur!=0){
                    if(valueOfUsd >= valueOfEur){
                        dataRow.ExRate_to_USD_NF__c = True;
                        dataRow.ExRate_to_EUR_NF__c = True;
                        isDataValid = false;
                        remarks += '\r\n ExRate to USD should not be more than ExRate to EUR';
                    }
                }
            }
            System.debug('isDataValid:::::ExRate_to_USD__c::'+isDataValid+'::dataRow.ExRate_to_USD__c:::'+dataRow.ExRate_to_USD__c);
            if(String.isNotBlank(dataRow.Sales_Transaction_Currency__c) && String.isNotBlank(dataRow.ExRate_to_USD__c)){                
                if(String.isNotBlank(dataRow.Sales_USD__c)){
                    if(dataRow.Sales_Transaction_Currency__c != '0' && dataRow.ExRate_to_USD__c != '0' && dataRow.Sales_USD__c != '0'){
                        integer afterDecimalScale = Decimal.valueOf(dataRow.Sales_USD__c.replaceAll(',','')).scale();                            
                        decimal slUsd = (decimal.valueOf(dataRow.Sales_Transaction_Currency__c.replaceAll(',','')) / decimal.valueOf(dataRow.ExRate_to_USD__c.replaceAll(',',''))).setScale(afterDecimalScale);
                        if(decimal.valueOf(dataRow.Sales_USD__c.replaceAll(',','')) != slUsd){
                            dataRow.Calculation_Failed__c = True;
                            isDataValid = false;
                        }
                    }
                }
            }
            System.debug('isDataValid:::::Sales_USD__c::'+isDataValid+'::dataRow.Sales_USD__c:::'+dataRow.Sales_USD__c);
            if(String.isNotBlank(dataRow.Sales_Transaction_Currency__c) && String.isNotBlank(dataRow.ExRate_to_EUR__c)){
                if(String.isNotBlank(dataRow.Sales_EUR__c)){
                    if(dataRow.Sales_Transaction_Currency__c != '0' && dataRow.ExRate_to_EUR__c != '0' && dataRow.Sales_EUR__c != '0'){
                        integer afterDecimalScale = Decimal.valueOf(dataRow.Sales_EUR__c.replaceAll(',','')).scale();
                        decimal slEur = (decimal.valueOf(dataRow.Sales_Transaction_Currency__c.replaceAll(',','')) / decimal.valueOf(dataRow.ExRate_to_EUR__c.replaceAll(',',''))).setScale(afterDecimalScale);
                        if(decimal.valueOf(dataRow.Sales_EUR__c.replaceAll(',','')) != slEur){
                            dataRow.Calculation_Failed__c = True;
                            isDataValid = false;
                        }
                    }
                }
            }
            System.debug('isDataValid:::::Sales_Transaction_Currency__c::'+isDataValid+'::dataRow.Sales_Transaction_Currency__c:::'+dataRow.Sales_Transaction_Currency__c);
            if(String.isNotBlank(dataRow.Sales_USD__c) && String.isNotBlank(dataRow.Unit_Sold__c)){
                if(String.isNotBlank(dataRow.Unit_Price_100_USD__c)){
                    if(dataRow.Sales_USD__c != '0' && dataRow.Unit_Sold__c != '0' && dataRow.Unit_Price_100_USD__c != '0'){
                        integer afterDecimalScale = Decimal.valueOf(dataRow.Unit_Price_100_USD__c.replaceAll(',','')).scale();
                        decimal upUsd = ((decimal.valueOf(dataRow.Sales_USD__c.replaceAll(',','')) / decimal.valueOf(dataRow.Unit_Sold__c.replaceAll(',','')))*100).setScale(afterDecimalScale);
                        if(decimal.valueOf(dataRow.Unit_Price_100_USD__c) != upUsd){
                            dataRow.Calculation_Failed__c = True;
                            isDataValid = false;
                        }
                    }
                }
            }
            System.debug('isDataValid:::::Sales_USD__c::'+isDataValid+'::dataRow.Sales_USD__c:::'+dataRow.Sales_USD__c);
            if(String.isNotBlank(dataRow.Sales_EUR__c) && String.isNotBlank(dataRow.Unit_Sold__c)){
                if(String.isNotBlank(dataRow.Unit_Price_100_EUR__c)){
                    if(dataRow.Sales_EUR__c != '0' && dataRow.Unit_Sold__c != '0' && dataRow.Unit_Price_100_EUR__c != '0'){
                        integer afterDecimalScale = Decimal.valueOf(dataRow.Unit_Price_100_EUR__c.replaceAll(',','')).scale();
                        decimal upEur = ((decimal.valueOf(dataRow.Sales_EUR__c.replaceAll(',','')) / decimal.valueOf(dataRow.Unit_Sold__c.replaceAll(',','')))*100).setScale(afterDecimalScale);
                        if(decimal.valueOf(dataRow.Unit_Price_100_EUR__c) != upEur){
                            dataRow.Calculation_Failed__c = True;
                            isDataValid = false;
                        }
                    }
                }
            }
            System.debug('isDataValid:::::Sales_USD__c::'+isDataValid+'::decimal.valueOf(dataRow.Unit_Price_100_EUR__c) != upEur');
            //[Sales USD]*[Exchange Rate_USD]=[Sales (Transaction Currency)]
            if(String.isNotBlank(dataRow.Sales_USD__c) && String.isNotBlank(dataRow.ExRate_to_USD__c)){                
                if(String.isNotBlank(dataRow.Sales_Transaction_Currency__c)){
                    if(dataRow.Sales_Transaction_Currency__c != '0' && dataRow.ExRate_to_USD__c != '0' && dataRow.Sales_USD__c != '0' && dataRow.Transaction_Currency__c == 'USD' ){
                        integer afterDecimalScale = Decimal.valueOf(dataRow.Sales_Transaction_Currency__c.replaceAll(',','')).scale(); 
                        decimal slTransCurrency = (decimal.valueOf(dataRow.Sales_USD__c.replaceAll(',','')) * decimal.valueOf(dataRow.ExRate_to_USD__c.replaceAll(',',''))).setScale(afterDecimalScale);
                        if(decimal.valueOf(dataRow.Sales_Transaction_Currency__c.replaceAll(',','')) != slTransCurrency){
                            remarks += '\r\n SalesTrnsCurrncy = SalesUsd * ExcRateUsd';
                            dataRow.STC_NF__c = True;
                            isDataValid = false;
                        }
                    }
                }
            }
            else
            {  
                //[Sales EUR]*[Exchange Rate_EUR]=[Sales (Transaction Currency)]
                if(String.isNotBlank(dataRow.Sales_EUR__c) && String.isNotBlank(dataRow.ExRate_to_EUR__C)){                
                    if(String.isNotBlank(dataRow.Sales_Transaction_Currency__c)){
                        if(dataRow.Sales_Transaction_Currency__c != '0' && dataRow.ExRate_to_EUR__C != '0' && dataRow.Sales_EUR__c != '0'){
                            integer afterDecimalScale = Decimal.valueOf(dataRow.Sales_Transaction_Currency__c.replaceAll(',','')).scale(); 
                            decimal slTransCurrency = (decimal.valueOf(dataRow.Sales_EUR__c.replaceAll(',','')) * decimal.valueOf(dataRow.ExRate_to_EUR__C.replaceAll(',',''))).setScale(afterDecimalScale);
                            if(decimal.valueOf(dataRow.Sales_Transaction_Currency__c.replaceAll(',','')) != slTransCurrency){
                                remarks += '\r\n SalesTrnsCurrncy = SalesEur * ExcRateEur';
                                dataRow.STC_NF__c = True;
                                isDataValid = false;
                            }
                        }
                    }
                }
            }
            
            System.debug('isDataValid:::::Sales_USD__c::'+isDataValid+'::Sales_Transaction_Currency__c.replaceAll()) != slTransCurrency');
            // Model validation.
            if(String.isNotBlank(dataRow.Model__c) && String.isNotBlank(dataRow.Vendor__c)){
                boolean modelMatch = true;
                if(dataRow.Vendor__c.containsIgnoreCase('lululemon')){ 
                    if(!lululemonModelMap.containsKey(dataRow.Model__c.toLowerCase())){  
                        remarks += '\r\n Model not found for:'+dataRow.Vendor__c;
                        //modelMatch = false;
                        dataRow.Model_NF__c = True; 
                        
                    }
                   
                }else if(dataRow.Vendor__c.containsIgnoreCase('debenham')){
                    if(!debenhanModelMap.containsKey(dataRow.Model__c.toLowerCase())){
                        remarks += '\r\n Model not found for:'+dataRow.Vendor__c;
                        //modelMatch = false;
                        dataRow.Model_NF__c = True;
                        
                    }                   
                    if(String.isNotBlank(dataRow.Retailer_Brand__c) && dataRow.Model_NF__c != True){
                        string modBrandKey = dataRow.Model__c+'#'+dataRow.Retailer_Brand__c;
                        if(!debenhanModelBrandKeyMap.containsKey(modBrandKey.toLowerCase())){
                            remarks += '\r\n Combination of Model and Brand not found for:'+dataRow.Vendor__c;
                            modelMatch = false;
                            
                        }
                    } 
                    
                } else{ 
                    string salesDataUploadChecked = getSalesDataUploadCheckMap.get(dataRow.Vendor__c.toLowerCase());
                system.debug('salesDataUploadChecked:::'+salesDataUploadChecked);
                    if(salesDataUploadChecked.equalsIgnoreCase('false')){
                    if(!modelWarningMap.containsKey(dataRow.Model__c.toLowerCase())){
                        remarks += '\r\n Model not found';
                        dataRow.Model_NF__c = True;
                        isDataValid = false;
                        //modelMatch = false;
                    }
                    }
                }
                System.debug('isDataValid:::::Model__c::::debenham::::::'+isDataValid+'::Model__c:::'+dataRow.Model__c);
                if(!modelMatch){
                    dataRow.warning_consolidate_key__c = True;
                    isDataValid = false;  
                }
            }
            System.debug('isDataValid::warning_consolidate_key__c:'+isDataValid);
            //Retailer brand validation
            //Retailer_brand cannot be empty for debenham and Retailer_brand should be in debenham pricebook.
            if(String.isNotBlank(dataRow.Vendor__c)){
                if(dataRow.Vendor__c.containsIgnoreCase('debenham')){
                    if(String.isBlank(dataRow.Retailer_Brand__c)){
                        dataRow.Retailer_Brand_FB__c = True;
                        isDataValid = false;
                        remarks += '\r\n Retailer Brand cannot be empty for Retailer:'+dataRow.Vendor__c;
                    }
                    if(String.isNotBlank(dataRow.Retailer_Brand__c)){
                        if(!debenhanBrandMap.containsKey(dataRow.Retailer_Brand__c.toLowerCase())){
                            dataRow.Retailer_Brand_NF__c = True;
                            isDataValid = false;
                            remarks += '\r\n Retailer Brand not found for:'+dataRow.Vendor__c;
                        }
                    }
                }
            }
            System.debug('isDataValid:::'+isDataValid+':::::Retailer_Brand__c:'+dataRow.Retailer_Brand__c);
            //vendor + Division + Brand + Label validation
            System.debug('getRetailersLabelDivisionBrandCheckMap:::'+getRetailersLabelDivisionBrandCheckMap);
            System.debug('dataRow.Vendor__c:::'+dataRow.Vendor__c);
            Retailer_Code__c labelDivisionBrandCheck = getRetailersLabelDivisionBrandCheckMap.get(dataRow.Vendor__c);
            System.debug('labelDivisionBrandCheck:::'+labelDivisionBrandCheck);
            
            if(labelDivisionBrandCheck != null)
            {
                map<String,String> labelDivisionBrand =  getNewVendorDivisionBrandLabelMap.get(dataRow.Vendor__c);
                if(labelDivisionBrand != null)
                {
                    if(labelDivisionBrandCheck.Label_Check__c == True && labelDivisionBrandCheck.Division_check__c== True){
                        string labelDivsionKey = dataRow.Label__c+'#'+dataRow.Division__c;
                        if(!labelDivisionBrand.containsKey(labelDivsionKey)){
                            dataRow.warning_consolidate_key__c = True;
                            isDataValid = false;
                            remarks += '\r\n Combination of Label and Division not found';
                        }
                        
                    }
                    System.debug('isDataValid:::'+isDataValid+':::::Combination of Label and Division not found:');
                    if(labelDivisionBrandCheck.Label_Check__c == True && labelDivisionBrandCheck.Retailer_Brand_Check__c== True){
                        string labelBrandKey = dataRow.Label__c+'#'+dataRow.Retailer_Brand__c;
                        if(!labelDivisionBrand.containsKey(labelBrandKey)){
                            dataRow.warning_consolidate_key__c = True;
                            isDataValid = false;
                            remarks += '\r\n Combination of Label and Brand not found';
                        }
                    }
                    System.debug('isDataValid:::'+isDataValid+':::::Combination of Label and Brand not found');
                    if(labelDivisionBrandCheck.Division_check__c == True && labelDivisionBrandCheck.Retailer_Brand_Check__c== True){
                        //  string divisionKey = dataRow.Division__c;
                        //  if(String.isNotBlank(divisionKey)){
                        string divsionBrandKey = dataRow.Division__c+'#'+dataRow.Retailer_Brand__c;
                        if(!labelDivisionBrand.containsKey(divsionBrandKey)){
                            dataRow.warning_consolidate_key__c = True;
                            isDataValid = false;
                            remarks += '\r\n Combination of Division and Brand not found';
                        }
                        //  }
                    } 
                     System.debug('isDataValid:::'+isDataValid+':::::Combination of Division and Brand not found');
                    // Single Check Box Validation for Label
                    if(labelDivisionBrandCheck.Label_Check__c == True ){
                        string labelKey = dataRow.Label__c;
                        if(!labelDivisionBrand.containsKey(labelKey)){
                            dataRow.warning_consolidate_key__c = True;
                            isDataValid = false;
                            remarks += '\r\n Label not found in Label Division';
                        }
                    }
                    System.debug('isDataValid:::'+isDataValid+':::::Label not found in Label Division');
                    // Single Check Box Validation for Division
                    if(labelDivisionBrandCheck.Division_check__c == True ){
                        string divisionKey = dataRow.Division__c;
                        if(!labelDivisionBrand.containsKey(divisionKey)){
                            dataRow.warning_consolidate_key__c = True;
                            isDataValid = false;
                            remarks += '\r\n Division not found in Label Division';
                        }
                    }
                    System.debug('isDataValid:::'+isDataValid+':::::Division not found in Label Division');
                    // Single Check Box Validation for Brand
                    if(labelDivisionBrandCheck.Retailer_Brand_Check__c == True ){
                        string retailerBrandKey = dataRow.Retailer_Brand__c;
                        if(!labelDivisionBrand.containsKey(retailerBrandKey)){
                            dataRow.warning_consolidate_key__c = True;
                            isDataValid = false;
                            remarks += '\r\n Retailer Brand not found in Label Division';
                        }
                    }
                     System.debug('isDataValid:::'+isDataValid+':::::Retailer Brand not found in Label Division');
                }
            }
            ///////////////////////////////////START OF MODEL VALIDATION/////////////////////////
            System.debug('///////////////////////////////////START OF MODEL VALIDATION/////////////////////////');
            string salesDataUploadChecked = getSalesDataUploadCheckMap.get(dataRow.Vendor__c.toLowerCase());
            system.debug('salesDataUploadChecked:::'+salesDataUploadChecked);
            if(salesDataUploadChecked.equalsIgnoreCase('true')){
                 // Checking the Model when the salesDataUploadCheck Box Checked
                    string compositeKey = dataRow.Model__c;
                	System.debug('checkColorwithModel:::::'+checkColorwithModel);
                    if(!checkColorwithModel.containsKey(compositeKey)){
                        dataRow.Model_NF__c = True;
                        isDataValid = false;
                        remarks += '\r\n Model is  not found in Price Specification Book Product';
                        system.debug('Model is  not found in Price Specification Book Product:::'+compositeKey);
                    }else{
                        system.debug('Model found in Price Specification Book Product');
                        //Auto population of Category/Sub-Category/Family 
                        string valueReturned = modelwithCatSubCatFamily.get(dataRow.Model__c.toLowerCase());                   
                        if(String.isNotBlank(valueReturned)){
                            List<String> result = valueReturned.split('#');
                            dataRow.Category__c = result[0];
                            dataRow.ProductCategory__c = result[1];
                            dataRow.Sub_Category__c = result[2];
                            dataRow.Family__c = result[3];                            
                        }
                        //Checking the combination of Model and Color
                        string salesDataUploadColorCheckMap = getSalesDataUploadColorCheckMap.get(dataRow.Vendor__c.toLowerCase());
                        system.debug('salesDataUploadColorCheckMap::::'+salesDataUploadColorCheckMap);
                        if(salesDataUploadColorCheckMap.equalsIgnoreCase('true')){
                            string compositeKeyModelColor = dataRow.Model__c+'#'+dataRow.Color__c;
                            if(!getModelandColorMap.containsKey(compositeKeyModelColor)){
                                dataRow.warning_consolidate_key__c = True;
                                isDataValid = false;
                                remarks += '\r\n Combination of Model and Color is not found in in Price Specification Book Product';
                                 system.debug('Combination of Model and Color is not found in in Price Specification Book Product:::'+compositeKeyModelColor);
                            }
                        }
                        
                    }
            }else{
                ///When the check is not checked we will validate the Model from the Product Object.
                if(String.isNotBlank(dataRow.Category__c)){
                    if(dataRow.Category__c.equalsIgnoreCase('hangers & accessories')){
                        system.debug('Category is  hangers & accessories');
                        System.debug('######### modelCompKeyMap:::'+modelCompKeyMap);
                        if(modelWarningMap.containsKey(dataRow.Model__c.trim().toLowerCase())){
                            string valueReturned = modelCompKeyMap.get(dataRow.Model__c.trim().toLowerCase());
                            System.debug('Category Hangers and Accessories cat subcat family:::'+dataRow.Model__c.trim().toLowerCase()+'::::valueReturned::'+valueReturned);
                            if(String.isNotBlank(valueReturned)){
                                List<String> result = valueReturned.split('#');
                                dataRow.Category__c = result[0];
                                dataRow.ProductCategory__c = result[1];
                                dataRow.Sub_Category__c = result[2];
                                dataRow.Family__c = result[3];    
                            }
                        }else{
                            dataRow.Model_NF__c = True;
                            isDataValid = false;
                            remarks += '\r\n Model is  not found in Products Master';
                            system.debug('Model is  not found in Products Master:::'+dataRow.Model__c);
                        }
                    } else{
                        system.debug('Category NOT is  hangers & accessories but OThers');
                        String businessVertical = 'Business_Vertical__c';
                        String subCategory   = 'Sub_category__c';  
                        String productCategory   = 'Product_Type__c';  
                        String productFamily   = 'Product_Family__c'; 
                        
                        String businessVerticalRowVal  =  dataRow.Category__c;
                        //String productCategoryRowVal = dataRow.ProductCategory__c;
                        String subCategoryRowVal = dataRow.Sub_Category__c;
                        String productFamilyRowVal =    dataRow.Family__c;
						system.debug('Before checking whether the Category:::'+businessVerticalRowVal+':: Sub Category:::'+subCategoryRowVal+'::: Family::::'+productFamilyRowVal);                        
                        sObject sProduct = new Product__c(); 
                        Map<String, List<String>> businessVertProdCatPickValue =  productDependentPicklist.getDependentMap(sProduct,businessVertical,productCategory);
                        Map<String, List<String>> prodCatSubCatPickValue =  productDependentPicklist.getDependentMap(sProduct,productCategory,subCategory);
                        Map<String, List<String>> subCatProdFamilyPickValue =  productDependentPicklist.getDependentMap(sProduct,subCategory,productFamily);
                        
                        system.debug('Dependent picklist business vertical and product category::'+businessVertProdCatPickValue);
                        system.debug('Dependent picklist product category and sub category::'+prodCatSubCatPickValue);
                        system.debug('Dependent picklist sub category and product family::'+subCatProdFamilyPickValue);
                        //Validating the business vertical or category 
                        Boolean productCategoryExists = false;
                        for (String category : businessVertProdCatPickValue.keySet()){
                             //System.debug('Category:::'+category+'::::Row Category::'+businessVerticalRowVal);
                            if(category.equalsIgnoreCase(businessVerticalRowVal)){
                                productCategoryExists=true;
                                system.debug('Product Category Field Value found:::'+businessVerticalRowVal);  
                                break;
                            }
                        }
                        if(!productCategoryExists){
                            dataRow.Category_NF__c = True;
                            isDataValid = false;
                            remarks += '\r\n Product Category Field Value Not found';
                            system.debug('Product Category Field Value Not found:::'+businessVerticalRowVal);                            
                        }
                        
                        //Getting the product sub Category based on Business Vertical.
                        List<String> fullSubCategoryList = new List<String>();
                        for (String productCat : prodCatSubCatPickValue.keySet()){
                            //checking only for the product category
                            //if(productCat.containsIgnoreCase(businessVerticalRowVal)){
                                List<String> subCategoryPickListVal = prodCatSubCatPickValue.get(productCat);
                                fullSubCategoryList.addAll(subCategoryPickListVal);
                            //}
                        }
                        
                        Boolean subCategoryExists = false;
        				for (String subCat : fullSubCategoryList){
                            //System.debug('SubCategory:::'+subCat+'::::Row Sub Category::'+subCategoryRowVal);
                            if(subCat.equalsIgnoreCase(subCategoryRowVal)){
                                subCategoryExists=true;
                                 system.debug('Product Sub Category Field Value found:::'+subCategoryRowVal);     
                                break;
                            }
                        }
                        if(!subCategoryExists){
                            dataRow.Sub_Category_NF__c = True;
                            isDataValid = false;
                            remarks += '\r\n Product Sub Category Field Value Not found';
                            system.debug('Product Sub Category Field Value Not found:::'+subCategoryRowVal);     
                        }
                        
                        //Getting the product Family based on Sub Category.
                        List<String> fullFamilyList = new List<String>();
                        for (String subCatgory : subCatProdFamilyPickValue.keySet()){
                           List<String> familyPickListVal = subCatProdFamilyPickValue.get(subCatgory);
                            fullFamilyList.addAll(familyPickListVal);
                        }
                        
                        Boolean familyExists = false;
        				for (String family : fullFamilyList){
                             //System.debug('Family :::'+family+'::::Row Family::'+productFamilyRowVal);
                            if(family.equalsIgnoreCase(productFamilyRowVal)){
                                familyExists=true;
                                system.debug('Product Family Field Value found:::'+productFamilyRowVal); 
                                break;
                            }
                        }
                        if(!familyExists){
                            dataRow.Family_NF__c = True;
                            isDataValid = false;
                            remarks += '\r\n Product Family Field Value Not found';
                            system.debug('Product Family Field Value Not found:::'+productFamilyRowVal); 
                        }
        				 //System.debug('pickValue::::'+pickValue);
                    }
                }else{
                    dataRow.Category_NF__c= True;
                    isDataValid = false;
                    remarks += '\r\n Category for the Product Model Validation is blank';
                    system.debug('Category for the Product Model Validation is blank');
                }
            }
            ////////////////////////////////////END OF MODEL VALIDATION//////////////////////////
            system.debug('////////////////////////////////////END OF MODEL VALIDATION//////////////////////////');
            // Model Validation
            // Added by Sai 07-05-2020
           /* if(String.isNotBlank(dataRow.Model__c) && String.isNotBlank(dataRow.Color__c)){
                string salesDataUploadChecked = getSalesDataUploadCheckMap.get(dataRow.Vendor__c.toLowerCase());                
                if(salesDataUploadChecked.equalsIgnoreCase('true')){                   
                    System.debug('isDataValid:::'+isDataValid+'::::: Model is  not found');
                    // Auto Populating the Category,Subcategory,Family Based on the Model (If the Model is Valid)
                    // Checking the Model & Color when the salesDataUploadColorCheck Box Checked               
                System.debug('isDataValid:::'+isDataValid+':::::Combination of Model and Color');
                }

           } 
            else
            {
                if(String.isNotBlank(dataRow.Model__c))
                {
                    string salesDataUploadChecked = getSalesDataUploadCheckMap.get(dataRow.Vendor__c.toLowerCase());
                    system.debug('salesDataUploadChecked:::'+salesDataUploadChecked);
                    if(salesDataUploadChecked.equalsIgnoreCase('false')){
                        string valueReturned = modelCompKeyMap.get(dataRow.Model__c.toLowerCase());
                        if(String.isNotBlank(valueReturned)){
                            List<String> result = valueReturned.split('#');
                            dataRow.Category__c = result[0];
                            dataRow.ProductCategory__c = result[1];
                            dataRow.Sub_Category__c = result[2];
                            dataRow.Family__c = result[3];
                            
                        }                    
                    }
                }
            }*/
            ////////////////////////////////////////////////////////////////////////////////////
            // Auto Populating the Category,Subcategory,Family Based on the Model (If the Model is Valid)
            // Added by Sai 08-05-2020
        /*   if(String.isNotBlank(dataRow.Model__c)){
                string compositeKey = dataRow.Model__c;
                if(checkColorwithModel.containsKey(compositeKey)){
                    string valueReturned = modelwithCatSubCatFamily.get(dataRow.Model__c.toLowerCase());                   
                    if(String.isNotBlank(valueReturned)){
                        List<String> result = valueReturned.split('#');
                        dataRow.Category__c = result[0];
                        dataRow.Sub_Category__c = result[1];
                        dataRow.Family__c = result[2];
                        
                    }                                                        
                }
            }  */
            
            ///////////////////////////////////////////////////////////////////////////////////
            // Model & Color Validation
            // Added by Sai 07-05-2020
        /*    if(String.isNotBlank(dataRow.Model__c) && String.isNotBlank(dataRow.Color__c)){
                string salesDataUploadColorCheckMap = getSalesDataUploadColorCheckMap.get(dataRow.Vendor__c.toLowerCase());
                system.debug('salesDataUploadColorCheckMap::::'+salesDataUploadColorCheckMap);
             //   if(String.isNotBlank(salesDataUploadColorCheckMap)){
                    if(salesDataUploadColorCheckMap.equalsIgnoreCase('true')){
                        string compositeKey = dataRow.Model__c+'#'+dataRow.Color__c;
                        if(!getModelandColorMap.containsKey(compositeKey)){
                            dataRow.warning_consolidate_key__c = True;
                            isDataValid = false;
                            remarks += '\r\n Combination of Model and Color is not found in in Price Specification Book Product';
                        }
                    }
             //   }               
            } 
             System.debug('isDataValid:::'+isDataValid+':::::Color is not Found for the Model'); */
            
            
            
            //Production country cannot be empty if production_country checkbox is checked for perticular retailer code(vendor).
         /*   if(String.isNotBlank(dataRow.Vendor__c)){
                string prodCountChecked = productionCoungtryMap.get(dataRow.Vendor__c.toLowerCase());                
                if(String.isNotBlank(prodCountChecked)){
                    if(prodCountChecked.equalsIgnoreCase('true')){
                        if(String.isBlank(dataRow.Production_Country__c)){                            
                            dataRow.Production_Country_FB__c = True;
                            isDataValid = false;
                            remarks += '\r\n Production Country cannot be empty for Retailer:'+dataRow.Vendor__c;
                        }
                    }
                }
            }
            System.debug('isDataValid:::'+isDataValid+':::::dataRow.Vendor__c::'+dataRow.Vendor__c); */
            // Category = 'Hangers and Accessories' validation
      /*    if(String.isNotBlank(dataRow.Category__c) && String.isNotBlank(dataRow.Model__c)){
                if(dataRow.Category__c.equalsIgnoreCase('hangers & accessories')){
                    if(modelWarningMap.containsKey(dataRow.Model__c.trim().toLowerCase())){
                        string valueReturned = modelCompKeyMap.get(dataRow.Model__c.trim().toLowerCase());
                        string errorMapPicklist = dataRow.ErrorMapData__c;
                        string afterRemovingPicklist1 = getPicklistValues(errorMapPicklist,'SubCategory');
                        string afterRemovingPicklist2 = getPicklistValues(afterRemovingPicklist1,'Family');
                        List<String> result = valueReturned.split('#');
                        dataRow.Sub_Category__c = result[1];
                        dataRow.Family__c = result[2];
                        dataRow.ErrorMapData__c = afterRemovingPicklist2;                            
                    }
                }/*else{
string valueReturned = modelCompKeyMap.get(dataRow.Model__c.trim().toLowerCase());
if(String.isNotBlank(valueReturned)){
string errorMapPicklist = dataRow.ErrorMapData__c;
string afterRemovingPicklist1 = getPicklistValues(errorMapPicklist,'SubCategory');
string afterRemovingPicklist2 = getPicklistValues(afterRemovingPicklist1,'Family');
string afterRemovingPicklist3 = getPicklistValues(afterRemovingPicklist2,'Category');
List<String> result = valueReturned.split('#');
dataRow.Category__c = result[0];
dataRow.Sub_Category__c = result[1];
dataRow.Family__c = result[2];
dataRow.ErrorMapData__c = afterRemovingPicklist3;                          
}
}
            } */
            
            
            /*if(String.isNotBlank(dataRow.Category__c) && String.isNotBlank(dataRow.Model__c) && String.isNotBlank(dataRow.Sub_Category__c) && String.isNotBlank(dataRow.Family__c)){
                if(dataRow.Category__c.equalsIgnoreCase('Flexible Packaging') || dataRow.Category__c.equalsIgnoreCase('LABELS & TICKETS') || dataRow.Category__c.equalsIgnoreCase('TLA') || dataRow.Category__c.equalsIgnoreCase('EAS & RFID'))
                {                 
                    //string getModelCat = getModelCatFamilyMap.get(dataRow.Model__c);
                    // system.debug('getModelCat::::'+getModelCat);
                    string getModel = dataRow.Model__c;
                 //   string getModelCat = dataRow.Category__c+'#'+dataRow.Sub_Category__c+'#'+dataRow.Family__c;
                    if(!getModelCatFamilyMap.containsKey(getModel)){
                        // dataRow.warning_consolidate_key__c = True;
                        isDataValid = false;
                        remarks += '\r\n Combibation of Category , Sub-Category , Family  is not Found for the Model';
                    }
                }
            } */
            System.debug('isDataValid:::'+isDataValid+':::::Combibation of Category , Sub-Category , Family::'+dataRow.Category__c);
            ////////// When Category = '' OR Category Contains "Hanger Business" /////// Starting ///
        /*  if(String.isBlank(dataRow.Category__c) ){
                dataRow.Category__c = 'HANGERS & ACCESSORIES';
                remarks += '\r\n Auto Populating when Category is Empty ';
            } */
            ////////// When Category = '' OR Category Contains "Hanger Business" /////// Ending ///
             
            // checking for Category exits ?
          /*  if( String.isNotBlank(dataRow.Category__c)){
                if(!categoryMap.containsKey(dataRow.Category__c.toLowerCase())){
                    dataRow.Category__c = 'HANGERS & ACCESSORIES';
                    dataRow.Category_NF__c = False;                   
                  //  isDataValid = false;
                    remarks += '\r\n Auto Populating when Category is Invalid';
                }
            } 
            System.debug('isDataValid:::'+isDataValid+':::::dataRow.Category__c::'+dataRow.Category__c); */
            
            ////////// When Sub-Category = '' /////// Starting ///
         /*  if(String.isBlank(dataRow.Sub_Category__c)){
                dataRow.Sub_Category__c = 'ACCESSORIES';
               remarks += '\r\n Auto Populating when SubCategory is Empty ';
            } */
            ////////// When Sub-Category = ''  /////// Ending ///	
           
            // checking for SubCategory exits ?
          /*  if(String.isNotBlank(dataRow.Sub_Category__c)){
                if(!subcategoryMap.containsKey(dataRow.Sub_Category__c.toLowerCase())){
                    dataRow.Sub_Category__c = 'ACCESSORIES';
                    dataRow.Sub_Category_NF__c = False;
                  //  isDataValid = false;
                    remarks += '\r\n Auto Populating when SubCategory is Invalid ';
                }
            } 
            System.debug('isDataValid:::'+isDataValid+':::::dataRow.Sub_Category__c::'+dataRow.Sub_Category__c); */
            ////////// When Label = "PL" OR Label = "NL" /////// Starting ///
            if(String.isNotBlank(dataRow.Label__c))
            {
                if(!dataRow.Label__c.equalsIgnoreCase('pl')){
                    if(!dataRow.Label__c.equalsIgnoreCase('nl')){
                        dataRow.Label_NF__c = True;
                        isDataValid = false;
                        remarks += '\r\n Label should be either PL or NL';
                    }
                }   
            } 
            System.debug('isDataValid:::'+isDataValid+':::::dataRow.Label__c::'+dataRow.Label__c);
            ////////// When Label = "PL" OR Label = "NL" /////// Ending ///
            
            // validating source.
            if(String.isNotBlank(dataRow.Source__c) && String.isNotBlank(dataRow.Sub_Category__c)){
                if(dataRow.Sub_Category__c.equalsIgnoreCase('hangers')){
                    if(!dataRow.Source__c.equalsIgnoreCase('virgin')){
                        if(!dataRow.Source__c.equalsIgnoreCase('reused')){
                            dataRow.Source_NF__c = True;
                            isDataValid = false;
                            remarks += '\r\n Source should be either Virgin or reused';
                        }
                    }                    
                }else{
                    if(!dataRow.Source__c.equalsIgnoreCase('virgin')){
                        dataRow.Source_NF__c = True;
                        isDataValid = false;
                        remarks += '\r\n Source must be Virgin';
                    }
                }
            }
            System.debug('isDataValid:::'+isDataValid+':::::dataRow.Source__c::'+dataRow.Source__c);
            if(String.isNotBlank(dataRow.Vendor__c) && String.isNotBlank(dataRow.LOB__c)){
                if(dataRow.Vendor__c.containsIgnoreCase('macy') && dataRow.LOB__c.equalsIgnoreCase('leg')){
                    dataRow.Label__c = 'NL';
                    dataRow.Label_FB__c = false;
                }
            }
            // system.debug('LabelAfter:'+rowUpdate.Label_FB__c);
            //checking week,year and month
            string dateValue = '';
            boolean isDateFormatValid = true;
            dateValue =  dataRow.Year__c+'#'+dataRow.Week__c+'#'+dataRow.Month__c;
            if(String.isNotBlank(dataRow.Year__c) && String.isNotBlank(dataRow.Week__c) && String.isNotBlank(dataRow.Month__c)){
                if(!dateMap.containsKey(dateValue.toLowerCase())){
                    dataRow.wrong_date__c = True;
                    remarks += '\r\n Year,Week and Month Mismatch';
                    isDataValid = false;
                    isDateFormatValid = false;
                }
            }
            System.debug('isDataValid:::'+isDataValid+':::::.dateValue::'+dateValue);
            if(String.isNotBlank(dataRow.Company__c) && String.isNotBlank(dataRow.Year__c) && String.isNotBlank(dataRow.Week__c) && String.isNotBlank(dataRow.Month__c)){
                if(isDateFormatValid){
                    if(dataRow.Month__c == selMonth){
                        string dateCompanyValue =  dataRow.Year__c+'#'+dataRow.Week__c+'#'+dataRow.Month__c+'#'+dataRow.Company__c;                                                
                        if(companyOnlyMap.containsKey(dateCompanyValue.trim().toLowerCase())){
                            companyOnlyMap.remove(dateCompanyValue.trim().toLowerCase());                    
                        }
                    }else{
                        dataRow.wrong_date__c = True;
                    }
                }
            }
           /* if(String.isNotBlank(dataRow.ErrorMapData__c)){
                isDataValid = false;
            }
            System.debug('isDataValid:::'+isDataValid+':::dataRow.ErrorMapData__c'+dataRow.ErrorMapData__c); */
            // reprocessing for admin snippet starts here
            if(dataRow.Model_FB__c != True && dataRow.Color_FB__c != True && dataRow.Category_FB__c != True 
               && dataRow.Market_FB__c != True && dataRow.Vendor_FB__c != True && dataRow.Company_FB__c != True 
               && dataRow.Material_FB__c != True && dataRow.Shipped_To_Factory_FB__c != True && dataRow.Shipped_To_Country_FB__c != True               
               && dataRow.Division_FB__c != True && dataRow.Item_code_FB__c != True && dataRow.Mainetti_Brand_FB__c != True 
               && dataRow.Order_Type_FB__c != True && dataRow.Customer_FB__c != True && dataRow.Transaction_Currency_FB__c != True
               && dataRow.ExRate_to_EUR_FB__C != True && dataRow.ExRate_to_USD_FB__C != True && dataRow.STC_FB__c != True
               && dataRow.Sales_USD_FB__c != True && dataRow.Sales_EUR_FB__c != True && dataRow.Unit_Price_100_USD_FB__c != True
               && dataRow.Unit_Price_100_EUR_FB__c != True && dataRow.Local_Net_Unit_Pirce_FB__c != True && dataRow.Net_Unit_Price_100_FB__c != True
               && dataRow.Month_FB__c != True && dataRow.Source_FB__c != True && dataRow.Unit_Sold_FB__c != True
               && dataRow.Week_FB__c != True && dataRow.Year_FB__c != True && dataRow.SO_Number_FB__c != True 
               && dataRow.LOB_FB__c != True && dataRow.Gross_Sales_USD_FB__c != True && dataRow.Freight_Charge_USD_FB__c != True
               && dataRow.Production_Country_FB__c != True && dataRow.Label_FB__c != True && dataRow.Retailer_Brand_FB__c != True               
               && dataRow.Color_NF__c != True && dataRow.Market_NF__c != True && dataRow.Vendor_NF__c != True
               && dataRow.Company_NF__c != True && dataRow.selected_ui_values__c != True && dataRow.SO_Number_NF__c != True
               && dataRow.LOB_NF__c != True && dataRow.unit_sold_warning__c != True && dataRow.ExRate_to_USD_NF__c != True
               && dataRow.ExRate_to_EUR_NF__c != True && dataRow.Calculation_Failed__c != True && dataRow.STC_NF__c != True 
               && dataRow.Retailer_Brand_NF__c != True && dataRow.warning_consolidate_key__c != True && dataRow.Source_NF__c != True  
               && dataRow.wrong_date__c != True && dataRow.Vendor_FB__c != True && dataRow.Company_FB__c != True               
               && dataRow.Model_NF__c == True){                   
                   dataRow.Model_Check__c = True;
                   isDataValid = false;
               }
            System.debug('isDataValid::COMPLEX-1:'+isDataValid);
            if(dataRow.Model_FB__c != True && dataRow.Color_FB__c != True && dataRow.Category_FB__c != True 
               && dataRow.Market_FB__c != True && dataRow.Vendor_FB__c != True && dataRow.Company_FB__c != True 
               && dataRow.Material_FB__c != True && dataRow.Shipped_To_Factory_FB__c != True && dataRow.Shipped_To_Country_FB__c != True               
               && dataRow.Division_FB__c != True && dataRow.Item_code_FB__c != True && dataRow.Mainetti_Brand_FB__c != True 
               && dataRow.Order_Type_FB__c != True && dataRow.Customer_FB__c != True && dataRow.Transaction_Currency_FB__c != True
               && dataRow.ExRate_to_EUR_FB__C != True && dataRow.ExRate_to_USD_FB__C != True && dataRow.STC_FB__c != True
               && dataRow.Sales_USD_FB__c != True && dataRow.Sales_EUR_FB__c != True && dataRow.Unit_Price_100_USD_FB__c != True
               && dataRow.Unit_Price_100_EUR_FB__c != True && dataRow.Local_Net_Unit_Pirce_FB__c != True && dataRow.Net_Unit_Price_100_FB__c != True
               && dataRow.Month_FB__c != True && dataRow.Source_FB__c != True && dataRow.Unit_Sold_FB__c != True
               && dataRow.Week_FB__c != True && dataRow.Year_FB__c != True && dataRow.SO_Number_FB__c != True 
               && dataRow.LOB_FB__c != True && dataRow.Gross_Sales_USD_FB__c != True && dataRow.Freight_Charge_USD_FB__c != True
               && dataRow.Production_Country_FB__c != True && dataRow.Label_FB__c != True && dataRow.Retailer_Brand_FB__c != True               
               && dataRow.Color_NF__c != True && dataRow.Market_NF__c != True
               && dataRow.Company_NF__c != True && dataRow.selected_ui_values__c != True && dataRow.SO_Number_NF__c != True
               && dataRow.LOB_NF__c != True && dataRow.unit_sold_warning__c != True && dataRow.ExRate_to_USD_NF__c != True
               && dataRow.ExRate_to_EUR_NF__c != True && dataRow.Calculation_Failed__c != True && dataRow.STC_NF__c != True 
               && dataRow.Retailer_Brand_NF__c != True && dataRow.warning_consolidate_key__c != True && dataRow.Source_NF__c != True  
               && dataRow.wrong_date__c != True && dataRow.Vendor_FB__c != True && dataRow.Company_FB__c != True               
               && dataRow.Vendor_NF__c == True){                   
                   dataRow.Retailer_Check__c = True;
                   isDataValid = false;
               }
            System.debug('isDataValid::COMPLEX21:'+isDataValid);
            /* if(dataRow.Retailer_Check__c == True || dataRow.Model_Check__c == True){

recordStatus.updateCheckbox = True;
System.debug('###### Inside Processing recordStatus.updateCheckbox'+recordStatus.updateCheckbox);
}*/
            // reprocessing for admin snippet ends here
            if(!isDataValid){
                dataRow.Record_Status__c = '1 - Error In Data Validation';
                dataRow.Remarks__c =  remarks;
                recordStatus.validateStatus= false;
                System.debug('###### Processing validateStatus'+recordStatus.validateStatus);
            }else{
                dataRow.Record_Status__c = '2 - Data Validation Successful';
            }
            System.debug('#### End processSalesDataChunk## recordStatus###'+recordStatus.validateStatus);
            //system.debug('LabelFinal:'+rowUpdate.Label_FB__c);
            salesTransStagUpdate.add(dataRow);
        }
        System.debug('##### Count salesTransStagUpdate'+salesTransStagUpdate.size());
        return salesTransStagUpdate;
    }
    
    public  List<Sales_Transaction_Stage__c>  reconcileDataWithSalesErrorMapBulk(List<Sales_Transaction_Stage__c> salesTransStagRecForReconciliation,Map<string,Map<string,Map<string,string>>> fullSalesErrorMap){            
        //system.debug('INSIDE ############## reconcileDataWithSalesErrorMap####################');
        boolean reconcileComplete = true;
        List<Sales_Transaction_Stage__c> reconcileDataRowForUpdate = new List<Sales_Transaction_Stage__c>();
        
        if(salesTransStagRecForReconciliation.size()>0){
            
            for (Sales_Transaction_Stage__c dataRow : salesTransStagRecForReconciliation) {
                
                if(dataRow != null){
                    
                    //Sales_Transaction_Stage__c rowUpdate = new Sales_Transaction_Stage__c();
                    //rowUpdate.Id =  dataRow.Id;
                    boolean dataReconciled = false;  
                    boolean isErrorInRecord = false;
                    boolean isRawMapAvailable = false;
                    Map<string,Map<string,string>> rawDataFieldMap;
                    Map<string,string> mapFromToValueMap;
                    String pickListValues='';
                    if(String.isNotBlank(dataRow.Company__c)){
                        rawDataFieldMap = fullSalesErrorMap.get(dataRow.Company__c);
                        //system.debug('fullSalesErrorMap:'+fullSalesErrorMap);
                        //system.debug('rawDataFieldMap:'+rawDataFieldMap);
                        if(rawDataFieldMap != null){
                            isRawMapAvailable = true;                                                        
                        }
                    }               
                    if(String.isNotBlank(dataRow.Year__c)){
                        if(isRawMapAvailable){
                            mapFromToValueMap = rawDataFieldMap.get('Year');
                            if(mapFromToValueMap != null){
                                String mapFromValue = dataRow.Year__c;
                                if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
                                    String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
                                    if(String.isNotBlank(mapToValue)){
                                        dataRow.Year__c = mapToValue;                       
                                        dataReconciled = true;
                                    }
                                }else{
                                    if(String.isNotBlank(pickListValues)){
                                        pickListValues += ';'+ 'Year';
                                    }else{
                                        pickListValues = 'Year';
                                    }                                    
                                    dataReconciled = true;
                                    isErrorInRecord = true;
                                }                                
                            }
                        }else{
                            if(String.isNotBlank(pickListValues)){
                                pickListValues += ';'+ 'Year';
                            }else{
                                pickListValues = 'Year';
                            }           
                            dataReconciled = true;
                            isErrorInRecord = true;
                        }                     
                    }            
                    if(String.isNotBlank(dataRow.Week__c)){
                        if(isRawMapAvailable){
                            mapFromToValueMap = rawDataFieldMap.get('Week');
                            if(mapFromToValueMap != null){
                                String mapFromValue = dataRow.Week__c;
                                if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
                                    String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
                                    if(String.isNotBlank(mapToValue)){
                                        dataRow.Week__c = mapToValue;                       
                                        dataReconciled = true;
                                    }
                                }else{
                                    if(String.isNotBlank(pickListValues)){
                                        pickListValues += ';'+ 'Week';
                                    }else{
                                        pickListValues = 'Week';
                                    }                               
                                    dataReconciled = true;
                                    isErrorInRecord = true;
                                }
                            }
                        }else{
                            if(String.isNotBlank(pickListValues)){
                                pickListValues += ';'+ 'Week';
                            }else{
                                pickListValues = 'Week';
                            }      
                            dataReconciled = true;
                            isErrorInRecord = true;
                        }      
                    }
                    if(String.isNotBlank(dataRow.Month__c)){
                        if(isRawMapAvailable){
                            mapFromToValueMap = rawDataFieldMap.get('Month');
                            if(mapFromToValueMap != null){
                                String mapFromValue = dataRow.Month__c;
                                if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
                                    String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
                                    if(String.isNotBlank(mapToValue)){
                                        dataRow.Month__c = mapToValue;                       
                                        dataReconciled = true;
                                    }
                                }else{
                                    if(String.isNotBlank(pickListValues)){
                                        pickListValues += ';'+ 'Month';
                                    }else{
                                        pickListValues = 'Month';
                                    }      
                                    dataReconciled = true;
                                    isErrorInRecord = true;
                                }
                            }
                        }else{
                            if(String.isNotBlank(pickListValues)){
                                pickListValues += ';'+ 'Month';
                            }else{
                                pickListValues = 'Month';
                            }      
                            dataReconciled = true;
                            isErrorInRecord = true;
                        }     
                    }   
                    if(String.isNotBlank(dataRow.Item_code__c)){
                        if(isRawMapAvailable){
                            mapFromToValueMap = rawDataFieldMap.get('ItemCode');
                            if(mapFromToValueMap != null){
                                String mapFromValue = dataRow.Item_code__c;
                                if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
                                    String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
                                    if(String.isNotBlank(mapToValue)){
                                        dataRow.Item_code__c = mapToValue;                       
                                        dataReconciled = true;
                                    }
                                }else{
                                    if(String.isNotBlank(pickListValues)){
                                        pickListValues += ';'+ 'ItemCode';
                                    }else{
                                        pickListValues = 'ItemCode';
                                    }      
                                    dataReconciled = true;
                                    isErrorInRecord = true;
                                }                                
                            }
                        }else{
                            if(String.isNotBlank(pickListValues)){
                                pickListValues += ';'+ 'ItemCode';
                            }else{
                                pickListValues = 'ItemCode';
                            }  
                            dataReconciled = true;
                            isErrorInRecord = true;
                        }        
                    }
                    if(String.isNotBlank(dataRow.Material__c)){
                        if(isRawMapAvailable){
                            mapFromToValueMap = rawDataFieldMap.get('Material');
                            if(mapFromToValueMap != null){
                                String mapFromValue = dataRow.Material__c;
                                if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
                                    String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
                                    if(String.isNotBlank(mapToValue)){
                                        dataRow.Material__c = mapToValue;                       
                                        dataReconciled = true;
                                    }
                                }else{
                                    if(String.isNotBlank(pickListValues)){
                                        pickListValues += ';'+ 'Material';
                                    }else{
                                        pickListValues = 'Material';
                                    }  
                                    dataReconciled = true;
                                    isErrorInRecord = true;
                                }                               
                            }
                        }else{
                            if(String.isNotBlank(pickListValues)){
                                pickListValues += ';'+ 'Material';
                            }else{
                                pickListValues = 'Material';
                            }  
                            dataReconciled = true;
                            isErrorInRecord = true;
                        }   
                    }
                    if(String.isNotBlank(dataRow.Source__c)){
                        if(isRawMapAvailable){
                            mapFromToValueMap = rawDataFieldMap.get('Source');
                            if(mapFromToValueMap != null){
                                String mapFromValue = dataRow.Source__c;
                                if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
                                    String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
                                    if(String.isNotBlank(mapToValue)){
                                        dataRow.Source__c = mapToValue;                       
                                        dataReconciled = true;
                                    }
                                }else{
                                    if(String.isNotBlank(pickListValues)){
                                        pickListValues += ';'+ 'Source';
                                    }else{
                                        pickListValues = 'Source';
                                    }  
                                    dataReconciled = true;
                                    isErrorInRecord = true;
                                }                         
                            }
                        }else{
                            if(String.isNotBlank(pickListValues)){
                                pickListValues += ';'+ 'Source';
                            }else{
                                pickListValues = 'Source';
                            }  
                            dataReconciled = true;
                            isErrorInRecord = true;
                        }      
                    }
                    
                    if(String.isNotBlank(dataRow.Printed_Logo__c)){
                        if(isRawMapAvailable){
                            mapFromToValueMap = rawDataFieldMap.get('PrintedLogo');
                            if(mapFromToValueMap != null){
                                String mapFromValue = dataRow.Printed_Logo__c;
                                if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
                                    String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
                                    if(String.isNotBlank(mapToValue)){
                                        dataRow.Printed_Logo__c = mapToValue;                       
                                        dataReconciled = true;
                                    }
                                }else{
                                    if(String.isNotBlank(pickListValues)){
                                        pickListValues += ';'+ 'PrintedLogo';
                                    }else{
                                        pickListValues = 'PrintedLogo';
                                    }  
                                    dataReconciled = true;
                                    isErrorInRecord = true;
                                }                              
                            }
                        }else{
                            if(String.isNotBlank(pickListValues)){
                                pickListValues += ';'+ 'PrintedLogo';
                            }else{
                                pickListValues = 'PrintedLogo';
                            }  
                            dataReconciled = true;
                            isErrorInRecord = true;
                        }       
                    }            
                    if(String.isNotBlank(dataRow.Color__c)){
                        if(isRawMapAvailable){
                            mapFromToValueMap = rawDataFieldMap.get('Color');
                            if(mapFromToValueMap != null){
                                String mapFromValue = dataRow.Color__c;
                                if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){                                    
                                    String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
                                    if(String.isNotBlank(mapToValue)){
                                        dataRow.Color__c = mapToValue;                       
                                        dataReconciled = true;
                                    }
                                }else{
                                    if(String.isNotBlank(pickListValues)){
                                        pickListValues += ';'+ 'Color';
                                    }else{
                                        pickListValues = 'Color';
                                    }  
                                    dataReconciled = true;
                                    isErrorInRecord = true;
                                }                              
                            }
                        }else{
                            if(String.isNotBlank(pickListValues)){
                                pickListValues += ';'+ 'Color';
                            }else{
                                pickListValues = 'Color';
                            }  
                            dataReconciled = true;
                            isErrorInRecord = true;
                        }           
                    }
                    if(String.isNotBlank(dataRow.Customer__c)){
                        if(isRawMapAvailable){
                            mapFromToValueMap = rawDataFieldMap.get('Customer');
                            if(mapFromToValueMap != null){
                                String mapFromValue = dataRow.Customer__c;
                                if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
                                    String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
                                    if(String.isNotBlank(mapToValue)){
                                        dataRow.Customer__c = mapToValue;                       
                                        dataReconciled = true;
                                    }
                                }else{
                                    if(String.isNotBlank(pickListValues)){
                                        pickListValues += ';'+ 'Customer';
                                    }else{
                                        pickListValues = 'Customer';
                                    }  
                                    dataReconciled = true;
                                    isErrorInRecord = true;
                                }                          
                            }
                        }else{
                            if(String.isNotBlank(pickListValues)){
                                pickListValues += ';'+ 'Customer';
                            }else{
                                pickListValues = 'Customer';
                            }  
                            dataReconciled = true;
                            isErrorInRecord = true;
                        }      
                    }
                    if(String.isNotBlank(dataRow.Customer_local_name__c)){
                        if(isRawMapAvailable){
                            mapFromToValueMap = rawDataFieldMap.get('LocalName');
                            if(mapFromToValueMap != null){
                                String mapFromValue = dataRow.Customer_local_name__c;
                                if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
                                    String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
                                    if(String.isNotBlank(mapToValue)){
                                        dataRow.Customer_local_name__c = mapToValue;                       
                                        dataReconciled = true;
                                    }
                                }else{
                                    if(String.isNotBlank(pickListValues)){
                                        pickListValues += ';'+ 'LocalName';
                                    }else{
                                        pickListValues = 'LocalName';
                                    }  
                                    dataReconciled = true;
                                    isErrorInRecord = true;
                                }
                            }
                        }else{
                            if(String.isNotBlank(pickListValues)){
                                pickListValues += ';'+ 'LocalName';
                            }else{
                                pickListValues = 'LocalName';
                            }  
                            dataReconciled = true;
                            isErrorInRecord = true;
                        }   
                    }
                    if(String.isNotBlank(dataRow.Mainetti_Brand__c)){
                        if(isRawMapAvailable){
                            mapFromToValueMap = rawDataFieldMap.get('MainettiBrand');
                            if(mapFromToValueMap != null){
                                String mapFromValue = dataRow.Mainetti_Brand__c;
                                if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
                                    String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
                                    if(String.isNotBlank(mapToValue)){
                                        dataRow.Mainetti_Brand__c = mapToValue;                       
                                        dataReconciled = true;
                                    }
                                }else{
                                    if(String.isNotBlank(pickListValues)){
                                        pickListValues += ';'+ 'MainettiBrand';
                                    }else{
                                        pickListValues = 'MainettiBrand';
                                    }  
                                    dataReconciled = true;
                                    isErrorInRecord = true;
                                }
                            }
                        }else{
                            if(String.isNotBlank(pickListValues)){
                                pickListValues += ';'+ 'MainettiBrand';
                            }else{
                                pickListValues = 'MainettiBrand';
                            }  
                            dataReconciled = true;
                            isErrorInRecord = true;
                        }   
                    }
                    if(String.isNotBlank(dataRow.Category__c)){                        
                        if(isRawMapAvailable){
                            mapFromToValueMap = rawDataFieldMap.get('Category');                      
                            if(mapFromToValueMap != null){                                
                                String mapFromValue = dataRow.Category__c;
                                if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){ 
                                    
                                    String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());                               
                                    if(String.isNotBlank(mapToValue)){
                                        dataRow.Category__c = mapToValue;                       
                                        dataReconciled = true;
                                    }
                                }else{  
                                    
                                    if(String.isNotBlank(pickListValues)){
                                        pickListValues += ';'+ 'Category';
                                    }else{
                                        pickListValues = 'Category';
                                    }  
                                    dataReconciled = true;
                                    isErrorInRecord = true;
                                }                               
                            }
                        }else{                            
                            if(String.isNotBlank(pickListValues)){
                                pickListValues += ';'+ 'Category';
                            }else{
                                pickListValues = 'Category';
                                
                            }
                            dataReconciled = true;
                            isErrorInRecord = true;
                        }   
                    }
                    
                    if(String.isNotBlank(dataRow.Sub_Category__c)){
                        if(isRawMapAvailable){
                            mapFromToValueMap = rawDataFieldMap.get('SubCategory');
                            if(mapFromToValueMap != null){
                                String mapFromValue = dataRow.Sub_Category__c;
                                if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
                                    String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
                                    if(String.isNotBlank(mapToValue)){
                                        dataRow.Sub_Category__c = mapToValue;                       
                                        dataReconciled = true;
                                    }
                                }else{
                                    if(String.isNotBlank(pickListValues)){
                                        pickListValues += ';'+ 'SubCategory';
                                    }else{
                                        pickListValues = 'SubCategory';
                                    } 
                                    dataReconciled = true;
                                    isErrorInRecord = true;
                                }
                            }
                        }else{
                            if(String.isNotBlank(pickListValues)){
                                pickListValues += ';'+ 'SubCategory';
                            }else{
                                pickListValues = 'SubCategory';
                            } 
                            dataReconciled = true;
                            isErrorInRecord = true;
                        }   
                    }
                    if(String.isNotBlank(dataRow.Family__c)){
                        if(isRawMapAvailable){
                            mapFromToValueMap = rawDataFieldMap.get('Family');
                            if(mapFromToValueMap != null){
                                String mapFromValue = dataRow.Family__c;
                                if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
                                    String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
                                    
                                    if(String.isNotBlank(mapToValue)){
                                        dataRow.Family__c = mapToValue;                       
                                        dataReconciled = true;
                                    }
                                }else{
                                    if(String.isNotBlank(pickListValues)){
                                        pickListValues += ';'+ 'Family';
                                    }else{
                                        pickListValues = 'Family';
                                    } 
                                    dataReconciled = true;
                                    isErrorInRecord = true;
                                }
                            }
                        }else{
                            if(String.isNotBlank(pickListValues)){
                                pickListValues += ';'+ 'Family';
                            }else{
                                pickListValues = 'Family';
                            } 
                            dataReconciled = true;
                            isErrorInRecord = true;
                        }   
                    }              
                    if(String.isNotBlank(dataRow.Order_Type__c)){
                        if(isRawMapAvailable){
                            mapFromToValueMap = rawDataFieldMap.get('OrderType');
                            if(mapFromToValueMap != null){
                                String mapFromValue = dataRow.Order_Type__c;
                                if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
                                    String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
                                    if(String.isNotBlank(mapToValue)){
                                        dataRow.Order_Type__c = mapToValue;                       
                                        dataReconciled = true;
                                    }
                                }else{
                                    if(String.isNotBlank(pickListValues)){
                                        pickListValues += ';'+ 'OrderType';
                                    }else{
                                        pickListValues = 'OrderType';
                                    } 
                                    dataReconciled = true;
                                    isErrorInRecord = true;
                                }
                            }
                        }else{
                            if(String.isNotBlank(pickListValues)){
                                pickListValues += ';'+ 'OrderType';
                            }else{
                                pickListValues = 'OrderType';
                            } 
                            dataReconciled = true;
                            isErrorInRecord = true;
                        }   
                    }
                    if(String.isNotBlank(dataRow.Unit_Sold__c)){
                        if(isRawMapAvailable){
                            mapFromToValueMap = rawDataFieldMap.get('UnitSold');
                            if(mapFromToValueMap != null){
                                String mapFromValue = dataRow.Unit_Sold__c;
                                if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
                                    String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
                                    if(String.isNotBlank(mapToValue)){
                                        dataRow.Unit_Sold__c = mapToValue;                       
                                        dataReconciled = true;
                                    }
                                }else{
                                    if(String.isNotBlank(pickListValues)){
                                        pickListValues += ';'+ 'UnitSold';
                                    }else{
                                        pickListValues = 'UnitSold';
                                    } 
                                    dataReconciled = true;
                                    isErrorInRecord = true;
                                }                                
                            }
                        }else{
                            if(String.isNotBlank(pickListValues)){
                                pickListValues += ';'+ 'UnitSold';
                            }else{
                                pickListValues = 'UnitSold';
                            } 
                            dataReconciled = true;
                            isErrorInRecord = true;
                        }         
                    }
                    if(String.isNotBlank(dataRow.Local_Currency__c)){
                        if(isRawMapAvailable){
                            mapFromToValueMap = rawDataFieldMap.get('LocalCurrency');
                            if(mapFromToValueMap != null){
                                String mapFromValue = dataRow.Local_Currency__c;
                                if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
                                    String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
                                    if(String.isNotBlank(mapToValue)){
                                        dataRow.Local_Currency__c = mapToValue;                       
                                        dataReconciled = true;
                                    }
                                }else{
                                    if(String.isNotBlank(pickListValues)){
                                        pickListValues += ';'+ 'LocalCurrency';
                                    }else{
                                        pickListValues = 'LocalCurrency';
                                    } 
                                    dataReconciled = true;
                                    isErrorInRecord = true;
                                }
                            }
                        }else{
                            if(String.isNotBlank(pickListValues)){
                                pickListValues += ';'+ 'LocalCurrency';
                            }else{
                                pickListValues = 'LocalCurrency';
                            } 
                            dataReconciled = true;
                            isErrorInRecord = true;
                        }          
                    }
                    if(String.isNotBlank(dataRow.Shipped_To_Factory__c)){
                        if(isRawMapAvailable){
                            mapFromToValueMap = rawDataFieldMap.get('ShippedToFactory');
                            if(mapFromToValueMap != null){
                                String mapFromValue = dataRow.Shipped_To_Factory__c;
                                if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
                                    String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
                                    if(String.isNotBlank(mapToValue)){
                                        dataRow.Shipped_To_Factory__c = mapToValue;                       
                                        dataReconciled = true;
                                    }
                                }else{
                                    if(String.isNotBlank(pickListValues)){
                                        pickListValues += ';'+ 'ShippedToFactory';
                                    }else{
                                        pickListValues = 'ShippedToFactory';
                                    } 
                                    dataReconciled = true;
                                    isErrorInRecord = true;
                                }                                
                            }
                        }else{
                            if(String.isNotBlank(pickListValues)){
                                pickListValues += ';'+ 'ShippedToFactory';
                            }else{
                                pickListValues = 'ShippedToFactory';
                            } 
                            dataReconciled = true;
                            isErrorInRecord = true;
                        }          
                    }
                    if(String.isNotBlank(dataRow.Shipped_To_Country__c)){
                        if(isRawMapAvailable){
                            mapFromToValueMap = rawDataFieldMap.get('ShippedToCountry');
                            if(mapFromToValueMap != null){
                                String mapFromValue = dataRow.Shipped_To_Country__c;
                                if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
                                    String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
                                    if(String.isNotBlank(mapToValue)){
                                        dataRow.Shipped_To_Country__c = mapToValue;                       
                                        dataReconciled = true;
                                    }
                                }else{
                                    if(String.isNotBlank(pickListValues)){
                                        pickListValues += ';'+ 'ShippedToCountry';
                                    }else{
                                        pickListValues = 'ShippedToCountry';
                                    } 
                                    dataReconciled = true;
                                    isErrorInRecord = true;
                                }                                
                            }
                        }else{
                            if(String.isNotBlank(pickListValues)){
                                pickListValues += ';'+ 'ShippedToCountry';
                            }else{
                                pickListValues = 'ShippedToCountry';
                            } 
                            dataReconciled = true;
                            isErrorInRecord = true;
                        }             
                    }
                    if(String.isNotBlank(dataRow.Label__c)){
                        if(isRawMapAvailable){
                            mapFromToValueMap = rawDataFieldMap.get('Label');
                            if(mapFromToValueMap != null){
                                String mapFromValue = dataRow.Label__c;
                                if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
                                    String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
                                    if(String.isNotBlank(mapToValue)){
                                        dataRow.Label__c = mapToValue;                       
                                        dataReconciled = true;
                                    }
                                }else{
                                    if(String.isNotBlank(pickListValues)){
                                        pickListValues += ';'+ 'Label';
                                    }else{
                                        pickListValues = 'Label';
                                    } 
                                    dataReconciled = true;
                                    isErrorInRecord = true;
                                }                                 
                            }
                        }else{
                            if(String.isNotBlank(pickListValues)){
                                pickListValues += ';'+ 'Label';
                            }else{
                                pickListValues = 'Label';
                            } 
                            dataReconciled = true;
                            isErrorInRecord = true;
                        }           
                    }
                    if(String.isNotBlank(dataRow.End_user__c)){
                        if(isRawMapAvailable){
                            mapFromToValueMap = rawDataFieldMap.get('EndUser');
                            if(mapFromToValueMap != null){
                                String mapFromValue = dataRow.End_user__c;
                                if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
                                    String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
                                    if(String.isNotBlank(mapToValue)){
                                        dataRow.End_user__c = mapToValue;                       
                                        dataReconciled = true;
                                    }
                                }else{
                                    if(String.isNotBlank(pickListValues)){
                                        pickListValues += ';'+ 'EndUser';
                                    }else{
                                        pickListValues = 'EndUser';
                                    } 
                                    dataReconciled = true;
                                    isErrorInRecord = true;
                                }                                
                            }
                        }else{
                            if(String.isNotBlank(pickListValues)){
                                pickListValues += ';'+ 'EndUser';
                            }else{
                                pickListValues = 'EndUser';
                            } 
                            dataReconciled = true;
                            isErrorInRecord = true;
                        }        
                    }
                    
                    if(String.isNotBlank(dataRow.Vendor__c)){
                        if(isRawMapAvailable){
                            mapFromToValueMap = rawDataFieldMap.get('Vendor');
                            if(mapFromToValueMap != null){
                                String mapFromValue = dataRow.Vendor__c;
                                if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
                                    String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
                                    if(String.isNotBlank(mapToValue)){
                                        dataRow.Vendor__c = mapToValue;                       
                                        dataReconciled = true;
                                    }
                                }else{
                                    if(String.isNotBlank(pickListValues)){
                                        pickListValues += ';'+ 'Vendor';
                                    }else{
                                        pickListValues = 'Vendor';
                                    } 
                                    dataReconciled = true;
                                    isErrorInRecord = true;
                                }                                 
                            }
                        }else{
                            if(String.isNotBlank(pickListValues)){
                                pickListValues += ';'+ 'Vendor';
                            }else{
                                pickListValues = 'Vendor';
                            } 
                            dataReconciled = true;
                            isErrorInRecord = true;
                        }       
                    }      
                    if(String.isNotBlank(dataRow.Division__c)){
                        if(isRawMapAvailable){
                            mapFromToValueMap = rawDataFieldMap.get('Division');
                            if(mapFromToValueMap != null){
                                String mapFromValue = dataRow.Division__c;
                                if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
                                    String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
                                    if(String.isNotBlank(mapToValue)){
                                        dataRow.Division__c = mapToValue;                       
                                        dataReconciled = true;
                                    }
                                }else{
                                    if(String.isNotBlank(pickListValues)){
                                        pickListValues += ';'+ 'Division';
                                    }else{
                                        pickListValues = 'Division';
                                    } 
                                    dataReconciled = true;
                                    isErrorInRecord = true;
                                }                                 
                            }
                        }else{
                            if(String.isNotBlank(pickListValues)){
                                pickListValues += ';'+ 'Division';
                            }else{
                                pickListValues = 'Division';
                            } 
                            dataReconciled = true;
                            isErrorInRecord = true;
                        }       
                    }
                    if(String.isNotBlank(dataRow.Retailer_Brand__c)){
                        if(isRawMapAvailable){
                            mapFromToValueMap = rawDataFieldMap.get('RetailerBrand');
                            if(mapFromToValueMap != null){
                                String mapFromValue = dataRow.Retailer_Brand__c;
                                if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
                                    String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
                                    if(String.isNotBlank(mapToValue)){
                                        dataRow.Retailer_Brand__c = mapToValue;                       
                                        dataReconciled = true;
                                    }
                                }else{
                                    if(String.isNotBlank(pickListValues)){
                                        pickListValues += ';'+ 'RetailerBrand';
                                    }else{
                                        pickListValues = 'RetailerBrand';
                                    } 
                                    dataReconciled = true;
                                    isErrorInRecord = true;
                                }                                 
                            }
                        }else{
                            if(String.isNotBlank(pickListValues)){
                                pickListValues += ';'+ 'RetailerBrand';
                            }else{
                                pickListValues = 'RetailerBrand';
                            } 
                            dataReconciled = true;
                            isErrorInRecord = true;
                        }    
                    }
                    if(String.isNotBlank(dataRow.Royalty_Rate__c)){
                        if(isRawMapAvailable){
                            mapFromToValueMap = rawDataFieldMap.get('RoyaltyRate');
                            if(mapFromToValueMap != null){
                                String mapFromValue = dataRow.Royalty_Rate__c;
                                if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
                                    String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
                                    if(String.isNotBlank(mapToValue)){
                                        dataRow.Royalty_Rate__c = mapToValue;                       
                                        dataReconciled = true;
                                    }
                                }else{
                                    if(String.isNotBlank(pickListValues)){
                                        pickListValues += ';'+ 'RoyaltyRate';
                                    }else{
                                        pickListValues = 'RoyaltyRate';
                                    } 
                                    dataReconciled = true;
                                    isErrorInRecord = true;
                                }                                 
                            }
                        }else{
                            if(String.isNotBlank(pickListValues)){
                                pickListValues += ';'+ 'RoyaltyRate';
                            }else{
                                pickListValues = 'RoyaltyRate';
                            } 
                            dataReconciled = true;
                            isErrorInRecord = true;
                        }      
                    }
                    if(String.isNotBlank(dataRow.Market__c)){
                        if(isRawMapAvailable){
                            mapFromToValueMap = rawDataFieldMap.get('Market');
                            if(mapFromToValueMap != null){
                                String mapFromValue = dataRow.Market__c;
                                if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
                                    String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
                                    if(String.isNotBlank(mapToValue)){
                                        dataRow.Market__c = mapToValue;                       
                                        dataReconciled = true;
                                    }
                                }else{
                                    if(String.isNotBlank(pickListValues)){
                                        pickListValues += ';'+ 'Market';
                                    }else{
                                        pickListValues = 'Market';
                                    } 
                                    dataReconciled = true;
                                    isErrorInRecord = true;
                                }                                 
                            }
                        }else{
                            if(String.isNotBlank(pickListValues)){
                                pickListValues += ';'+ 'Market';
                            }else{
                                pickListValues = 'Market';
                            } 
                            dataReconciled = true;
                            isErrorInRecord = true;
                        }       
                    }
                    if(String.isNotBlank(dataRow.Remarks__c)){
                        if(isRawMapAvailable){
                            mapFromToValueMap = rawDataFieldMap.get('Remarks');
                            if(mapFromToValueMap != null){
                                String mapFromValue = dataRow.Remarks__c;
                                if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
                                    String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
                                    if(String.isNotBlank(mapToValue)){
                                        dataRow.Remarks__c = mapToValue;                       
                                        dataReconciled = true;
                                    }
                                }else{
                                    if(String.isNotBlank(pickListValues)){
                                        pickListValues += ';'+ 'Remark';
                                    }else{
                                        pickListValues = 'Remark';
                                    }                                    
                                    dataReconciled = true;
                                    isErrorInRecord = true;
                                }                                 
                            }
                        }else{
                            if(String.isNotBlank(pickListValues)){
                                pickListValues += ';'+ 'Remark';
                            }else{
                                pickListValues = 'Remark';
                            }    
                            dataReconciled = true;
                            isErrorInRecord = true;
                        }         
                    }
                    if(String.isNotBlank(dataRow.LOB__c)){
                        if(isRawMapAvailable){
                            mapFromToValueMap = rawDataFieldMap.get('LOB');
                            if(mapFromToValueMap != null){
                                String mapFromValue = dataRow.LOB__c;
                                if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
                                    String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
                                    if(String.isNotBlank(mapToValue)){
                                        dataRow.LOB__c = mapToValue;                       
                                        dataReconciled = true;
                                    }
                                }else{
                                    if(String.isNotBlank(pickListValues)){
                                        pickListValues += ';'+ 'LOB';
                                    }else{
                                        pickListValues = 'LOB';
                                    }    
                                    dataReconciled = true;
                                    isErrorInRecord = true;
                                }                                
                            }
                        }else{
                            if(String.isNotBlank(pickListValues)){
                                pickListValues += ';'+ 'LOB';
                            }else{
                                pickListValues = 'LOB';
                            }  
                            dataReconciled = true;
                            isErrorInRecord = true;
                        }          
                    }
                    if(String.isNotBlank(dataRow.SO_Number__c)){
                        if(isRawMapAvailable){
                            mapFromToValueMap = rawDataFieldMap.get('SONumber');
                            if(mapFromToValueMap != null){
                                String mapFromValue = dataRow.SO_Number__c;
                                if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
                                    String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
                                    if(String.isNotBlank(mapToValue)){
                                        dataRow.SO_Number__c = mapToValue;                       
                                        dataReconciled = true;
                                    }
                                }else{
                                    if(String.isNotBlank(pickListValues)){
                                        pickListValues += ';'+ 'SONumber';
                                    }else{
                                        pickListValues = 'SONumber';
                                    }  
                                    dataReconciled = true;
                                    isErrorInRecord = true;
                                }                                 
                            }
                        }else{
                            if(String.isNotBlank(pickListValues)){
                                pickListValues += ';'+ 'SONumber';
                            }else{
                                pickListValues = 'SONumber';
                            }  
                            dataReconciled = true;
                            isErrorInRecord = true;
                        }         
                    }
                    if(String.isNotBlank(dataRow.Production_Country__c)){
                        if(isRawMapAvailable){
                            mapFromToValueMap = rawDataFieldMap.get('ProductionCountry');
                            if(mapFromToValueMap != null){
                                String mapFromValue = dataRow.Production_Country__c;
                                if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
                                    String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
                                    if(String.isNotBlank(mapToValue)){
                                        dataRow.Production_Country__c = mapToValue;                       
                                        dataReconciled = true;
                                    }
                                }else{
                                    if(String.isNotBlank(pickListValues)){
                                        pickListValues += ';'+ 'ProductionCountry';
                                    }else{
                                        pickListValues = 'ProductionCountry';
                                    }  
                                    dataReconciled = true;
                                    isErrorInRecord = true;
                                }                                
                            }
                        }else{
                            if(String.isNotBlank(pickListValues)){
                                pickListValues += ';'+ 'ProductionCountry';
                            }else{
                                pickListValues = 'ProductionCountry';
                            }  
                            dataReconciled = true;
                            isErrorInRecord = true;
                        }          
                    } 
                    if(dataReconciled){                 
                        if(isErrorInRecord){
                            dataRow.ErrorMapData__c = pickListValues;
                            dataRow.Record_Status__c = '1 - Error In Data Validation';
                            reconcileComplete = false; 
                        }
                        reconcileDataRowForUpdate.add(dataRow);                                        
                    }else{
                        reconcileDataRowForUpdate.add(dataRow);
                    }
                }
            }
            System.debug('::::::PROCESS SALES DATA :::::reconcileDataRowForUpdate:::::::::::::::::::::::::'+reconcileDataRowForUpdate.size());
            /// Updating the reconciled data back into the stage table
            /*if(reconcileDataRowForUpdate.size() > 0){
update reconcileDataRowForUpdate;            
}*/
        }
        return reconcileDataRowForUpdate;
    }   
}