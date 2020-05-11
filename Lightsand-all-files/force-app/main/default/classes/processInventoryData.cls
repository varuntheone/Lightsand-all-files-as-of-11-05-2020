public class processInventoryData {
    
    public boolean validateUploadRows(Inventory_Transaction_Master__c updateBatchStatus){
        boolean validateStatus = true;
        getMasterData masterData = new  getMasterData();
        Map<Decimal,string> missingFieldValMap = new Map<Decimal,string>();   
        Map<Decimal,Map<string,string>> inCorrectFormatMap = new Map<Decimal,Map<string,string>>();        
        List<Inventory_Transaction_Stage__c> invTransStagUpdate = new List<Inventory_Transaction_Stage__c>();
        List<Inventory_Transaction_Stage__c> invTransStagRec = masterData.getInventoryStagRows(updateBatchStatus.Id);
        Map<string,string> manitteCompanyMap =  masterData.getManitteCompanyMap();
        //System.Debug('manitteCompanyMap::::::'+manitteCompanyMap);
        Map<string,string> manitteOrgCompanyMap =  masterData.getManitteOrgCompanyMap();
        //System.Debug('manitteOrgCompanyMap::::::'+manitteOrgCompanyMap);
        Map<string,string> retailerCodeMap =  masterData.getRetailerCodeMap();
        //System.Debug('retailerCodeMap::::::'+retailerCodeMap);
       // Map<string,string> invTransOrderToCompMap = masterData.getListOfTransManitteCompany(updateBatchStatus.Id);
        Map<string,Map<string,string>> modelPriceMap = masterData.getRTSModelMap(updateBatchStatus);        
        Map<string,string> rtsModelMap =  modelPriceMap.get('Model');
        Map<string,string> rtsPriceMap = modelPriceMap.get('Price');
        //System.Debug('rtsModelMap::::::'+rtsModelMap);
        Map<string,string> colorMap =  masterData.getPickListColorMap(updateBatchStatus);
        //Map<string,string> colorMap =  masterData.getPickListMap('Price_Specification_Book_Product__c','Color__c');
        System.Debug('colorMap::::::'+colorMap);
        //Map<string,string> inventoryMap =  masterData.getPickListMap('Price_Specification_Book_Product__c','Color__c');
        Map<string,string> wareHouseMap =  masterData.getPickListMap('Data_Upload_Transaction__c','Warehouse__c');
        // System.Debug('wareHouseMap::::::'+wareHouseMap);
        Map<string,string> sourceMap =  masterData.getPickListMap('Data_Upload_Transaction__c','Source__c');
        System.Debug('sourceMap::::::'+sourceMap);
        Map<string,string> sizerPrintMap = masterData.getSizePrintMap(updateBatchStatus);
        //System.Debug('sizerPrintMap::::::'+sizerPrintMap);
        
        /* getting user email for notifying admin for which user the reprocessing notification to be sent */
        /*String userName = UserInfo.getUserName();
        User activeUser = [Select Email From User where Username = : userName limit 1];
        String userEmailNotify = activeUser.Email;*/
        
        // Update Failure Notification for admin on reupload.
        /*Inventory_Transaction_Master__c updateFailureCheckbox = new Inventory_Transaction_Master__c();
        updateFailureCheckbox.Id = updateBatchStatus.Id;
        updateFailureCheckbox.Failure_Notification__c = false;
        update updateFailureCheckbox;*/
        
        if(invTransStagRec.size()>0){      
        for (Inventory_Transaction_Stage__c dataRow : invTransStagRec) {
            Inventory_Transaction_Stage__c rowUpdate = new Inventory_Transaction_Stage__c();
            rowUpdate.Id = dataRow.Id;            
            Boolean isDataValid = true; 
            String remarks = '';
            //checking for Missing column values
           boolean missingField =  missingFieldValue(dataRow, rowUpdate,inCorrectFormatMap); 
            if(!missingField)
            {
                isDataValid = false;
            }
            //checking the Stock Date and Stock Qty date format and Qty data type
              System.Debug('inCorrectFormatMap:::::'+inCorrectFormatMap);            
            if(inCorrectFormatMap.containsKey(dataRow.Row_No__c)){
                Map<string,string> stockDateQty = inCorrectFormatMap.get(dataRow.Row_No__c);
                System.Debug('stockDateQty:::::'+stockDateQty);            

                if(!String.isBlank(stockDateQty.get('Date'))){
                    remarks = stockDateQty.get('Date')+ '\r\n' ;
                }
                if(!String.isBlank(stockDateQty.get('Stock'))){
                    remarks += stockDateQty.get('Stock');
                }
                //rowUpdate.Remarks__c =  remarks;
                isDataValid = false;
            }else{
                rowUpdate.Remarks__c = '';               
            }
            // checking for retailer code exits ?
            if(String.isNotBlank(dataRow.Retailer_Code__c)){
                if(!retailerCodeMap.containsKey(dataRow.Retailer_Code__c.toLowerCase())){
                    rowUpdate.Retailer_Code_NF__c = True;
                    isDataValid = false;                    
                      //remarks += '\r\n Missmatch:RC with Uploaded file RC';
                      remarks += '\r\n Missmatch Retailer Code';
                }
            }else
            {
                //rowUpdate.Retailer_Code_NF__c = True;
                //isDataValid = false;
            }
            // checking for manitte Company exits ?
            if(String.isNotBlank(dataRow.Mainetti_Company__c)){                
                string rowMainettiComp = dataRow.Mainetti_Company__c.toLowerCase();
                string masterDataMainetti = updateBatchStatus.Mainetti_Company__c;                
                if(String.isNotBlank(rowMainettiComp) && String.isNotBlank(masterDataMainetti)){
                    if(!rowMainettiComp.equalsIgnoreCase(masterDataMainetti.toLowerCase())){                        
                        rowUpdate.MC_NF__c = True;
                         //remarks +=  '\r\n Missmatch:Row MC with Upload Selected MC';
                         remarks +=  '\r\n Missmatch Mainetti Company';
                        isDataValid = false;
                    }
                }
                if(!manitteCompanyMap.containsKey(dataRow.Mainetti_Company__c.toLowerCase())){
                    rowUpdate.MC_NF__c = True;
                    // remarks += '\r\n Missmatch:Row MC with Upload Selected MC';
                    remarks +=  '\r\n Missmatch  Mainetti Company';
                    isDataValid = false;
                }                
            }else
            {
                //rowUpdate.MC_NF__c = True;
                //isDataValid = false;
            }
            // checking for RTS Model exits ?
            if(String.isNotBlank(dataRow.Inventory_Model__c)){
                //system.debug('dataRow.Inventory_Model__c.toLowerCase()::'+dataRow.Inventory_Model__c.toLowerCase());
                //system.debug('dataRow.Inventory_Model__c.toLowerCase()::'+rtsModelMap.get(dataRow.Inventory_Model__c.toLowerCase()));
                if(!rtsModelMap.containsKey(dataRow.Inventory_Model__c.toLowerCase())){
                    rowUpdate.Inventory_Model_NF__c = True;
                     remarks += '\r\n Missmatch:Model with Uploaded file Model';
                    isDataValid = false;
                }
            }
            else
            {
                //rowUpdate.Inventory_Model_NF__c = True;
                //isDataValid = false;  
            }
            
            // checking for color exits ?
            if(String.isNotBlank(dataRow.Color__c)){
                System.Debug('color:'+dataRow.Color__c.toLowerCase());
                System.Debug('colorContains:'+colorMap.containsKey(dataRow.Color__c.toLowerCase()));
                if(!colorMap.containsKey(dataRow.Color__c.toLowerCase())){
                    rowUpdate.Color_NF__c = True;
                    isDataValid = false;
                     remarks += '\r\n Missmatch:Color with Uploaded file Color';
                }
            }  else{
                //rowUpdate.Color_NF__c = True;
                //isDataValid = false;
            }
            
            // checking for Warehouse exits ?            
            if(String.isNotBlank(dataRow.Warehouse__c)){
                if(!wareHouseMap.containsKey(dataRow.Warehouse__c.toLowerCase())){
                    rowUpdate.Warehouse_NF__c = True;
                    isDataValid = false;
                     remarks += '\r\n Missmatch Warehouse';
                }
            }else
            {
                //rowUpdate.Warehouse_NF__c = True;
                //isDataValid = false;
            }
            if(String.isNotBlank(dataRow.Source__c)){
                //system.debug('dataRow.Source__c:'+dataRow.Source__c);
                //system.debug('dataRow.Source__c:'+dataRow.Source__c);
                if(!sourceMap.containsKey(dataRow.Source__c.toLowerCase())){
                    rowUpdate.Source_NF__c = True;
                    isDataValid = false;
                     remarks += '\r\n Missmatch:Source is not found';
                }
            }
            
            //checking the sizer printer only if the retailer code is lojas.
            if(String.isNotBlank(dataRow.Retailer_Code__c)){
                if(dataRow.Retailer_Code__c.equalsIgnoreCase('LOJAS RENNER')){
                    system.debug('inside logas renner');
                    // checking for Sizer Printer exits ?
                    if(String.isNotBlank(dataRow.Sizer_Print__c)){
                        system.debug('inside logas renner if print is not empty');
                        if(!sizerPrintMap.containsKey(dataRow.Sizer_Print__c.toLowerCase())){                            
                            rowUpdate.Sizer_Print_NF__c = True;
                            isDataValid = false;
                             remarks += '\r\n Missmatch with LOJAS RENNER Print';
                        } 
                    }
                }
                /*else
                {
                    if(String.isNotBlank(dataRow.Sizer_Print__c)){
                        if(!sizerPrintMap.containsKey(dataRow.Sizer_Print__c.toLowerCase())){                                
                            rowUpdate.Sizer_Print_NF__c = True;
                            isDataValid = false;
                             remarks += '\r\n Missmatch:Print is not found';
                        } 
                    }
                }*/
            }
            
            // checking for Model exits ?
            string pricbookspec = '';
            if(String.isNotBlank(dataRow.Retailer_Code__c)){
                if(dataRow.Retailer_Code__c.equalsIgnoreCase('LOJAS RENNER')){
                    pricbookspec =  dataRow.Inventory_Model__c+'#'+dataRow.Retailer_Code__c+'#'+dataRow.Mainetti_Company__c+'#'+dataRow.Color__c+'#'+dataRow.Sizer_Print__c;
                }else{
                    pricbookspec =  dataRow.Inventory_Model__c+'#'+dataRow.Retailer_Code__c+'#'+dataRow.Mainetti_Company__c+'#'+dataRow.Color__c;
                }
            }else{
                pricbookspec =  dataRow.Inventory_Model__c+'#'+dataRow.Retailer_Code__c+'#'+dataRow.Mainetti_Company__c+'#'+dataRow.Color__c;
            }    
            //System.Debug('PRICEBOOKspec::::::'+pricbookspec.toLowerCase());
            if(!rtsPriceMap.containsKey(pricbookspec.toLowerCase())){
                if(String.isNotBlank(dataRow.Retailer_Code__c)){
                    if(dataRow.Retailer_Code__c.equalsIgnoreCase('LOJAS RENNER')){
                        
                        if(isDataValid){
                            if(rowUpdate.Retailer_Code_NF__c != True &&rowUpdate.MC_NF__c != True &&rowUpdate.Inventory_Model_NF__c != True &&rowUpdate.Color_NF__c != True &&rowUpdate.Warehouse_NF__c != True && rowUpdate.Sizer_Print_NF__c != True)
                            {
                                rowUpdate.Price_Book_Spec_NF__c = True;
                                isDataValid = false; 
                                 remarks += '\r\n Missmatch:PriceBook Model data';
                            }
                        }
                    }
                    else
                    {
                        system.debug('isDataValid:'+isDataValid);
                        if(isDataValid){
                            if(rowUpdate.Retailer_Code_NF__c != True &&rowUpdate.MC_NF__c != True &&rowUpdate.Inventory_Model_NF__c != True &&rowUpdate.Color_NF__c != True &&rowUpdate.Warehouse_NF__c != True)
                            {
                                rowUpdate.Price_Book_Spec_NF__c = True;
                                isDataValid = false; 
                                remarks += '\r\n Missmatch:PriceBook Model data';
                                 
                            }
                        }
                    }
                }
                
                
            }  
            /* reprocessing for admin snippet starts here*/
            /*if(rowUpdate.Retailer_Code_FB__c != True && rowUpdate.Sizer_Print_FB__c != True && rowUpdate.Manitte_Company_FB__c != True 
               && rowUpdate.Inventory_Model_FB__c != True && rowUpdate.Color_FB__c != True && rowUpdate.Warehouse_FB__c != True 
               && rowUpdate.Source_FB__c != True && rowUpdate.Stock_In_Date_FB__c != True && rowUpdate.Stock_In_Qty_FB__c != True               
               && rowUpdate.MC_NF__c != True && rowUpdate.Color_NF__c != True && rowUpdate.Warehouse_NF__c != True 
               && rowUpdate.Source_NF__c != True && rowUpdate.Sizer_Print_NF__c != True && rowUpdate.Price_Book_Spec_NF__c != True
               && rowUpdate.Retailer_Code_NF__c == True){
                   
                   rowUpdate.Retailer_Check__c = True;
                   isDataValid = false;
               }
            
            if(rowUpdate.Retailer_Code_FB__c != True && rowUpdate.Sizer_Print_FB__c != True && rowUpdate.Manitte_Company_FB__c != True 
               && rowUpdate.Inventory_Model_FB__c != True && rowUpdate.Color_FB__c != True && rowUpdate.Warehouse_FB__c != True 
               && rowUpdate.Source_FB__c != True && rowUpdate.Stock_In_Date_FB__c != True && rowUpdate.Stock_In_Qty_FB__c != True               
               && rowUpdate.MC_NF__c != True && rowUpdate.Color_NF__c != True && rowUpdate.Warehouse_NF__c != True 
               && rowUpdate.Source_NF__c != True && rowUpdate.Sizer_Print_NF__c != True && rowUpdate.Price_Book_Spec_NF__c != True
               && rowUpdate.Inventory_Model_NF__c == True){
                   
                   rowUpdate.Model_Check__c = True;
                   isDataValid = false;
               }
            if(rowUpdate.Retailer_Check__c == True || rowUpdate.Model_Check__c == True){
                Inventory_Transaction_Master__c updateCheckbox = new Inventory_Transaction_Master__c();
                updateCheckbox.Id = updateBatchStatus.Id;
                updateCheckbox.Reprocessing__c = true;
                //updateCheckbox.Failure_Notification__c = false;
                updateCheckbox.Reprocess_Email_Notify__c = userEmailNotify;
                update updateCheckbox;
            }*/
            /* reprocessing for admin snippet ends here*/
            if(!isDataValid){
                rowUpdate.Record_Status__c = '1 - Error In Data Validation';
                rowUpdate.Remarks__c =  remarks;
                validateStatus= false;
            }
            invTransStagUpdate.add(rowUpdate);
        }
    }
        if(invTransStagUpdate != null && invTransStagUpdate.size() > 0){
            //System.Debug('invTransStagUpdate::::::'+invTransStagUpdate);
        }try{
            update invTransStagUpdate;
        }catch(DMLException e){    
            validateStatus= false;
            system.debug('Error in processInventoryData: during DataUploadTransaction'+e.getMessage());            
        }
        return validateStatus;          
    }
    public boolean missingFieldValue(Inventory_Transaction_Stage__c dataRow,Inventory_Transaction_Stage__c rowUpdate, Map<Decimal,Map<string,string>> inCorrectFormatMap){            
        boolean missingField = true;
        if(dataRow != null){
            if(String.isBlank(dataRow.Retailer_Code__c)){
                rowUpdate.Retailer_Code_FB__c = True;
                missingField = false;
            }else{
                if(dataRow.Retailer_Code__c.equalsIgnoreCase('LOJAS RENNER')){
                    if(String.isBlank(dataRow.Sizer_Print__c)){
                        //rowUpdate.Sizer_Print_FB__c = True;
                        //missingField = false;
                    }
                }
            }
            if(String.isBlank(dataRow.Mainetti_Company__c)){
                rowUpdate.Manitte_Company_FB__c = True;
                missingField = false;
            }
            if(String.isBlank(dataRow.Inventory_Model__c)){
                rowUpdate.Inventory_Model_FB__c = True;
                missingField = false;
            }
            if(String.isBlank(dataRow.Color__c)){
                rowUpdate.Color_FB__c = True;
                missingField = false;
            }
            if(String.isBlank(dataRow.Warehouse__c)){
                rowUpdate.Warehouse_FB__c = True;
                missingField = false;
            }          
            if(String.isBlank(dataRow.Source__c)){
                rowUpdate.Source_FB__c = True;
                missingField = false;
            }
            if(String.isBlank(dataRow.Stock_In_Date__c)){
                rowUpdate.Stock_In_Date_FB__c = True;
                missingField = false;
            }else{
                String dateValue = dataRow.Stock_In_Date__c;
                Date stockInDate = parseLongDate(dateValue); 
                if(stockInDate == null){
                    if( inCorrectFormatMap.ContainsKey(dataRow.Row_No__c) ){
                        Map<string,string> formatMap = inCorrectFormatMap.get(dataRow.Row_No__c);
                        formatMap.put('Date', 'Wrong Date Format::'+dateValue);
                        inCorrectFormatMap.put(dataRow.Row_No__c,formatMap);
                    }else{
                        Map<string,string> formatMap = new Map<string,string>();
                        formatMap.put('Date', 'Wrong Date Format::'+dateValue);
                        inCorrectFormatMap.put(dataRow.Row_No__c,formatMap);
                    }
                }                
            }
            if(String.isBlank(dataRow.Stock_In_Qty__c)){
                rowUpdate.Stock_In_Qty_FB__c = True;
                missingField = false;
            } else{
                String stockQtyValue = dataRow.Stock_In_Qty__c;
                integer stockInQty = isStockInQtyNumeric(stockQtyValue);  
                if(stockInQty == null){
                    if(inCorrectFormatMap.ContainsKey(dataRow.Row_No__c) ){
                        Map<string,string> formatMap = inCorrectFormatMap.get(dataRow.Row_No__c);
                        formatMap.put('Stock', 'Wrong Number Format::'+stockQtyValue);
                        inCorrectFormatMap.put(dataRow.Row_No__c,formatMap);
                    }else{
                        Map<string,string> formatMap = new Map<string,string>();
                        formatMap.put('Stock', 'Wrong Number Format::'+stockQtyValue);
                        inCorrectFormatMap.put(dataRow.Row_No__c,formatMap);
                    }
                }                
            }
        }
        return missingField;
    }
    
    public  Date parseLongDate(String dateString){        
        Map <String, Integer> months = new Map <String, Integer> {'jan'=>1, 'feb'=>2
            , 'mar'=>3, 'apr'=>4, 'may'=>5, 'jun'=>6, 'jul'=>7, 'aug'=>8, 'sep'=>9
            , 'oct'=>10, 'nov'=>11, 'dec'=>12};
                List <String> dateParts = dateString.toLowerCase().split('-');
        Date parsedDate = null;
        
        try{  
            if(dateParts!= null && dateParts.size()==3){  
                Integer day = Integer.valueOf(dateParts[0]);
                Integer month = months.get(dateParts[1]);
                string columnYear = dateParts[2];
                Integer year;
                if(columnYear.length()>2){
                    throw new applicationException('Invalid Year');  
                }else{
                    year = Integer.valueOf('20'+dateParts[2]);
                }
                parsedDate = Date.newInstance(year,month,day);
            }            
        }catch(Exception e){}
        return parsedDate;
    }
    public integer isStockInQtyNumeric(String stockInQty){
        integer isStock = null;
        try{
            isStock = integer.valueOf(stockInQty);           
        }catch(Exception e){}
        return isStock;
    }
    public class applicationException extends Exception {}
}