({
    invoke : function(component,helper) {
        var action=component.get("c.getSalesData");
        action.setCallback(this,function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.data", response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        });
        $A.enqueueAction(action);
    },
    autoPopulateOnReupload : function(component,helper,batchId) {
        
        let monthConvertMap = new Map();
        monthConvertMap.set('Jan',0);
        monthConvertMap.set('Feb',1);
        monthConvertMap.set('Mar',2);
        monthConvertMap.set('Apr',3);
        monthConvertMap.set('May',4);
        monthConvertMap.set('Jun',5);
        monthConvertMap.set('Jul',6);
        monthConvertMap.set('Aug',7);
        monthConvertMap.set('Sep',8);
        monthConvertMap.set('Oct',9);
        monthConvertMap.set('Nov',10);
        monthConvertMap.set('Dec',11);
        
        //alert(batchId);
        var action=component.get("c.getAutoPopulateMasterValues");
        action.setParams({
            "batchId": batchId
        });
        action.setCallback(this,function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                //alert('result:'+result);
                for(var i=0;i<result.length;i++){
                   // alert(result[i].Sales_Company__c);
                   // alert(result[i].Sales_Month__c);
                   // alert(result[i].Sales_Year__c);
                   // component.set("v.selectedValues","");
                    component.set("v.selectedYear",result[i].Sales_Year__c);
                    component.set("v.cmpsales.Name",result[i].Sales_Company__c);
                    //component.set("v.selectedValues",result[i].Sales_Month__c);
                    component.set("v.selectedValues",monthConvertMap.get(result[i].Sales_Month__c));
                }
                //component.set("v.data", response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        });
        $A.enqueueAction(action);
    },
    getDateByWhichFileShouldBeUploadedForSales : function(component,helper) {
        var action=component.get("c.callingCustomSettings");
        action.setCallback(this,function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.companyMonthDate", response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        });
        $A.enqueueAction(action);        
    },
    companyWeekData : function(component,helper,batchId) {
        var selMonthNum = component.get("v.selectedValues");
        var monthsList = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        var selMonth = monthsList[selMonthNum];
        var action=component.get("c.getCompanyWeekData");
        action.setParams({
            "batchid": batchId
        });
        action.setCallback(this,function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.companyWeekData", response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        });
        $A.enqueueAction(action);
    },
    
    currentMonthYear : function(component,helper) {
        var date = new Date();
        var currentMonth = date.getMonth();
        var currentYear = date.getFullYear();
        component.set("v.selectedValues", currentMonth);
        component.set("v.selectedYear", currentYear);
    },
    
    getYear : function(component,helper) {
        
        var action=component.get("c.getPreviousYear");
        action.setCallback(this,function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.yearList", response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        });
        $A.enqueueAction(action);
    },
    defaultSales:function(component,helper)
    {
        component.set("v.appName", "SalesUpload");
        component.set("v.itm.Record_Type__c","Sales");
        component.set("v.selectedRecordType","Sales");
    },
    getMainettiCompanyPicklist: function(component, event) {
        var action = component.get("c.getMainettiMap");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var recordStatusMap = [];
                for(var key in result){
                    recordStatusMap.push({key: key, value: result[key]});
                }
                component.set("v.mainettiCompanyMap", recordStatusMap);
            }
        });
        $A.enqueueAction(action);
    },
    
    getRecordStatusPicklist: function(component, event) {
        var action = component.get("c.getRecordStatus");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var recordStatusMap = [];
                for(var key in result){
                    recordStatusMap.push({key: key, value: result[key]});
                }
                component.set("v.recordStatusMap", recordStatusMap);
            }
        });
        $A.enqueueAction(action);
    },
    
    getBatchStatusPicklist: function(component, event) {
        var action = component.get("c.getBatchStatus");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var batchStatusMap = [];
                for(var key in result){
                    batchStatusMap.push({key: key, value: result[key]});
                }
                component.set("v.batchStatusMap", batchStatusMap);
            }
        });
        $A.enqueueAction(action);
    },
    
    initRecordType : function(component, event, helper) {
        var action=component.get("c.getRecordType");       
        action.setCallback(this,function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.options", response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        });
        $A.enqueueAction(action);
    },
    
    parseFile : function(component,file,batchNo,helper) {
        
        var recordType = component.get("v.selectedRecordType");
                if(recordType == "Sales"){
            var selMonthNum = component.get("v.selectedValues");
            var selYear = component.get("v.selectedYear");
            var selCompany = component.get("v.cmpsales.Name");
            var monthsList = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
            var date = new Date();
            var selMonth = monthsList[selMonthNum];
            var currentMonth = monthsList[date.getMonth()]; 
            var currentYear =   date.getFullYear();
                    //alert('currentYear:::'+currentYear);
            if(selCompany == ""){
                document.getElementById('errorMissing').innerHTML='Please Select the Company!';                    
                component.set("v.toggleSpinner", false);
                return;
            }
            if(selMonthNum == ""){
                document.getElementById('errorMissing').innerHTML='Please Select a Month!';                    
                component.set("v.toggleSpinner", false);
                return;
            }
            if(selYear == ""){
                document.getElementById('errorMissing').innerHTML='Please Select a Year!';                    
                component.set("v.toggleSpinner", false);
                return;
            }            
            var getAppName = component.get("v.appName");
            var the_month = date.getMonth();            
            var month = component.find('monthList').get('v.value');
            var isreupload  = component.get("v.isReupload");
                   // alert('selYear1::::'+selYear+'currentYear:::'+currentYear);
            if(selYear == currentYear && !isreupload ){
               // alert('selYear::::'+selYear+'currentYear:::'+currentYear);
                if (month > the_month) {
                    document.getElementById('errorMissing').innerHTML='Please select a valid Month for your request.\nThe Current Selection occurs after the Current Month.';                
                    component.set("v.toggleSpinner", false);
                    return;
                } 
            }            
            var presentMonthNum = date.getMonth();           
           // helper.isDataAlreadySubmitted(component, event, helper);  
                
        }   
       // component.set("v.openBulkUploadConfirmation",true);
        helper.isDataAlreadySubmitted(component, event, helper);
    }, 
    isDataAlreadySubmitted: function (component, event, helper){
        console.log('##### START isDataAlreadySubmitted #########');
        var selMonthNum = component.get("v.selectedValues");
        var selYear = component.get("v.selectedYear");
        var selCompany = component.get("v.cmpsales.Name");
        var monthsList = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        var date = new Date();
        var selMonth = monthsList[selMonthNum];
        var currentMonth = monthsList[date.getMonth()]; 
        var fileInput = component.find("file").getElement();
        var file = fileInput.files[0];
        var rowsExists = false;
        if (file.size > 0) 
        {
             rowsExists = true;
        }             
        if(rowsExists){
            component.set('v.isChunkDataSubmitted',true);
            var action = component.get("c.errordataSubmitted");
            
            action.setParams({
                "companyArray": selCompany,
                "selmonth": selMonth,
                "selyear": selYear
            });   
            action.setCallback(this, function(response){
                var state = response.getState();
                var batchStatus;
                var isreupload  = component.get("v.isReupload");
                
                if (state === "SUCCESS"){
                    var fetchValue =response.getReturnValue();
                    batchStatus = fetchValue;
                    
                    if(fetchValue != '' && (batchStatus != '8 - Migration Success') && !isreupload  ){
                        component.set("v.toggleSpinner", false);
                        component.set("v.errorReupload", true); 
                        component.set("v.isDataSubmitted", false);
                        helper.openErrorSubmittedModal(component, event, helper);
                        
                    }
                    else{
                        console.log('##### INSIDE ELSE START AFTER ERRORDATA SUBMITTED isDataAlreadySubmitted #########');
                        if((rowsExists &&  isreupload)||(rowsExists && (batchStatus == '' || batchStatus == '8 - Migration Success'))){
                            var action = component.get("c.dataSubmitted");
                            action.setParams({
                                "companyArray": selCompany,
                                "selmonth": selMonth,
                                "selyear": selYear
                            });   
                            action.setCallback(this, function(response){
                                var state = response.getState();
                                if (state === "SUCCESS"){
                                    var fetchValue =response.getReturnValue();
                                    if(fetchValue > 0){
                                        component.set("v.toggleSpinner", false);
                                        component.set("v.isDataSubmitted", false);                                       
                                        helper.openDataSubmittedModal(component, event, helper);                                        
                                    }else{ 
										helper.closeModal(component,helper);
                                        component.set("v.openBulkUploadConfirmation",true);
                                        helper.openBulkUploadConfirmation(component,helper);
                                        var chunk = $A.getCallback(function(results,parser) {
                                            console.log('##### INSIDE CHUNK START #########');
                                            var isreupload  = component.get("v.isReupload");                                           
                                                         
                                            var selMonthNum = component.get("v.selectedValues");
                                            var selYear = component.get("v.selectedYear");                
                                            var selCompany = component.get("v.cmpsales.Name");
                                            var monthsList = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];                
                                            var date = new Date();      
                                            var selMonth = monthsList[selMonthNum];
                                            var currentMonth = monthsList[date.getMonth()];
                                            var getAppName = component.get("v.appName");                
                                            var the_month = date.getMonth();
                                            var month = component.find('monthList').get('v.value');           
                                            var myJson = JSON.stringify(results.data);
                                            var rows = results.data;
                                            var recordType = component.get("v.selectedRecordType");
											var file =  component.find("file").getElement().files[0];
            								var fileName = file.name;                                                                                        
                                            console.log('##### INSIDE CHUNK FileName'+ fileName);
                                            if(rows.length >= 1){       
                                                var chunkCount = component.get("v.chunkCount");                                                 
                                                    if(!parser.paused()){                           
                                                        parser.pause();
                                                        console.log('##### INSIDE Start Pause ChunkCount'+ chunkCount);
                                                    }
												var batchNo=component.get("v.reuploadBatchNo");                                                                                                 
                                                component.set("v.chunkCount",(chunkCount+1)); 
                                                console.log('##### INSIDE CHUNK BEFORE  ####CHUNK COUNT #####'+chunkCount+':BATCHNO:::'+batchNo+':::ROWS LENGTH:::'+rows.length);
                                                var action = component.get("c.insertBulkSales");
                                                action.setParams({
                                                    "jsonin": myJson,
                                                    "batchNo": batchNo,
                                                    "recordType": recordType,
                                                    "selcomp": selCompany,
                                                    "selMonth": selMonth,
                                                    "selYear": selYear,
                                                    "isreupload":isreupload,
                                                    "chunkCount":chunkCount,
                                                    "fileName":fileName
                                                });                                         
                                                action.setCallback(this, function(response){
                                                    var state = response.getState();
                                                    var errors = response.getError();
                                                    if (errors && Array.isArray(errors) && errors.length > 0) {                               
                                                        console.log('error callback post creation of Master Record:'+ errors[0].message);
                                                        helper.openErrorModal(component,helper);
                                                        return;                                
                                                    }                
                                                    if (state === "SUCCESS") {
                                                        
                                                        var batchId =response.getReturnValue();                             
                                                        component.set("v.reuploadBatchNo",batchId);
                                                        /*if(isreupload){
                                                            if(!isReloadDelete){
                                                                component.set("v.isReloadDelete",true);
                                                            }
                                                        }*/          
                                                        console.log('##### INSIDE CHUNK  isDataSubmitted SUCCESS ## batchId ###### '+ batchId +' ####CHUNK COUNT #####'+chunkCount);                                                        
                                                        if(parser.paused()){  
                                                             var isreUpload  = component.get("v.isReupload"); 
                                                            if(isreUpload){
                                                                component.set("v.isReupload",false);
                                                            }
                                                            parser.resume();
                                                            console.log('##### INSIDE CHUNK  RESUME #CHUNK COUNT #####'+chunkCount);                                                             
                                                        }                                                        
                                                    }                            
                                                });
                                                $A.enqueueAction(action);
                                            }else{             
                                                console.log('##### INSIDE CHUNK  isDataSubmitted FALSE ####'+'####CHUNK COUNT #####');
                                                //helper.openErrorFileFormatModal(component,helper);
                                                //component.set("v.toggleSpinner", false);
                                            }     
                                        })
                                        
                                        var chunkComplete = $A.getCallback(function(results) {
                                            var batchNo =  component.get("v.reuploadBatchNo");
                                            var fileInput = component.find("file").getElement();
                                            var file = fileInput.files[0];
                                            var recordType = component.get("v.selectedRecordType");
                                            
                                            console.log('##### START CHUNK COMPLETE   ####'+batchNo);
                                            component.set("v.openBulkUploadConfirmation",false);
                                            helper.parseSalesFileChunk(component,file,batchNo,helper,recordType,true);        
                                            
                                        })
                                        
                                        var fileInput = component.find("file").getElement();
                                        var file = fileInput.files[0];                      
                                        
                                        component.set("v.toggleSpinner", true);
                                        Papa.LocalChunkSize = 1024*768*1;
                                        //Papa.LocalChunkSize = 512*1;
                                        var parser =  Papa.parse(file,{
                                            header: true,
                                            beforeFirstChunk: function( chunk ) {
                                                var rows = chunk.split( /\r\n|\r|\n/ );
                                                var headings = rows[0].split( ',' );
                                                headings[0] = helper.returnSalesHeader(component,helper,headings[0]);
                                                headings[1] = helper.returnSalesHeader(component,helper,headings[1]);
                                                headings[2] = helper.returnSalesHeader(component,helper,headings[2]);
                                                headings[3] = helper.returnSalesHeader(component,helper,headings[3]);
                                                headings[4] = helper.returnSalesHeader(component,helper,headings[4]);
                                                headings[5] = helper.returnSalesHeader(component,helper,headings[5]);
                                                headings[6] = helper.returnSalesHeader(component,helper,headings[6]);
                                                headings[7] = helper.returnSalesHeader(component,helper,headings[7]);
                                                headings[8] = helper.returnSalesHeader(component,helper,headings[8]);
                                                headings[9] = helper.returnSalesHeader(component,helper,headings[9]);
                                                headings[10] = helper.returnSalesHeader(component,helper,headings[10]);
                                                headings[11] = helper.returnSalesHeader(component,helper,headings[11]);
                                                headings[12] = helper.returnSalesHeader(component,helper,headings[12]);
                                                headings[13] = helper.returnSalesHeader(component,helper,headings[13]);
                                                headings[14] = helper.returnSalesHeader(component,helper,headings[14]);
                                                headings[15] = helper.returnSalesHeader(component,helper,headings[15]);
                                                headings[16] = helper.returnSalesHeader(component,helper,headings[16]);
                                                headings[17] = helper.returnSalesHeader(component,helper,headings[17]);
                                                headings[18] = helper.returnSalesHeader(component,helper,headings[18]);
                                                headings[19] = helper.returnSalesHeader(component,helper,headings[19]);
                                                headings[20] = helper.returnSalesHeader(component,helper,headings[20]);
                                                headings[21] = helper.returnSalesHeader(component,helper,headings[21]);
                                                headings[22] = helper.returnSalesHeader(component,helper,headings[22]);
                                                headings[23] = helper.returnSalesHeader(component,helper,headings[23]);
                                                headings[24] = helper.returnSalesHeader(component,helper,headings[24]);
                                                headings[25] = helper.returnSalesHeader(component,helper,headings[25]);
                                                headings[26] = helper.returnSalesHeader(component,helper,headings[26]);
                                                headings[27] = helper.returnSalesHeader(component,helper,headings[27]);
                                                headings[28] = helper.returnSalesHeader(component,helper,headings[28]);
                                                headings[29] = helper.returnSalesHeader(component,helper,headings[29]);
                                                headings[30] = helper.returnSalesHeader(component,helper,headings[30]);
                                                headings[31] = helper.returnSalesHeader(component,helper,headings[31]);
                                                headings[32] = helper.returnSalesHeader(component,helper,headings[32]);
                                                headings[33] = helper.returnSalesHeader(component,helper,headings[33]);
                                                headings[34] = helper.returnSalesHeader(component,helper,headings[34]);
                                                headings[35] = helper.returnSalesHeader(component,helper,headings[35]);
                                                headings[36] = helper.returnSalesHeader(component,helper,headings[36]);
                                                headings[37] = helper.returnSalesHeader(component,helper,headings[37]);
                                                headings[38] = helper.returnSalesHeader(component,helper,headings[38]);
                                                headings[39] = helper.returnSalesHeader(component,helper,headings[39]);
                                                headings[40] = helper.returnSalesHeader(component,helper,headings[40]);
                                                headings[41] = helper.returnSalesHeader(component,helper,headings[41]);
                                               headings[42] = helper.returnSalesHeader(component,helper,headings[42]);
                                                rows[0] = headings.join();
                                                return rows.join( '\n' );
                                            },
                                            chunk: chunk,
                                            complete: chunkComplete});                                        
                                    }
                                }
                            });
                            $A.enqueueAction(action);
                        }
                    }
                }
                
            });
            $A.enqueueAction(action);
            return;
        }
        else{
            component.set("v.toggleSpinner", false); 
           	helper.openErrorFileFormatModal(component, event, helper);
        }
    },
    parseSalesFileChunk : function(component,file,batchNo,helper,recordType,postBulkInsert) {     
        
        console.log('##### START parseSalesFileChunk ####batchNo::'+batchNo+':::recordType::::::'+recordType+'::::postBulkInsert::::::'+postBulkInsert);
        var selMonthNum = component.get("v.selectedValues");
        var selYear = component.get("v.selectedYear");
        //var selCompany = component.get("v.selectedSalesCompany");
        var selCompany = component.get("v.cmpsales.Name");
        var monthsList = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        
        var date = new Date();      
        var selMonth = monthsList[selMonthNum];
        var currentMonth = monthsList[date.getMonth()];
        var getAppName = component.get("v.appName");
        
        var the_month = date.getMonth();
        var month = component.find('monthList').get('v.value');        
        var complete = $A.getCallback(function(results) {     
            
            var myJson = JSON.stringify(results.data); 
            //making the jason empty as bulk data is inserted via chunk
            if(postBulkInsert){
                myJson = "";
            }
            var submitStatus = component.get("v.submitSales"); 
            if(batchNo != '' && submitStatus){
                var action = component.get("c.parseSalesChunk");
                action.setParams({
                    "jsonin": myJson,
                    "batchNo": batchNo,
                    "recordType": recordType,
                    "selcomp": selCompany,
                    "selMonth": selMonth,
                    "selYear": selYear,
                    "postBulkInsert":postBulkInsert                    
                });
                action.setCallback(this, function(response){
                    var state = response.getState();
                    var errors = response.getError();
                    if (errors && Array.isArray(errors) && errors.length > 0) {
                        component.set("v.toggleSpinner", false);
                        console.log('error callback post creation of Master Record:'+ errors[0].message);
                        helper.openErrorModal(component,helper);                   
                    } 
                    if (state === "SUCCESS") {        
                        component.rerenderList();
                        var batchId =response.getReturnValue();
                        console.log('##### INSIDE SUCCES parseSalesFileChunk #### batchId:::'+batchId);
                        helper.closeBulkUploadConfirmation(component,helper); 
                        //if(batchId != ''){   
                        helper.openFileDataSubmittedModal(component,helper);                                    
                        //}                 
                    }
                });
                $A.enqueueAction(action);
            }else{
                helper.openErrorFileFormatModal(component,helper);
                component.set("v.toggleSpinner", false);
            }
        })
        
        var file =  component.find("file").getElement().files[0];
        Papa.parse(file,{
            header: true,
            beforeFirstChunk: function( chunk ) {
                var rows = chunk.split( /\r\n|\r|\n/ );
                var headings = rows[0].split( ',' );
                headings[0] = helper.returnSalesHeader(component,helper,headings[0]);
                headings[1] = helper.returnSalesHeader(component,helper,headings[1]);
                headings[2] = helper.returnSalesHeader(component,helper,headings[2]);
                headings[3] = helper.returnSalesHeader(component,helper,headings[3]);
                headings[4] = helper.returnSalesHeader(component,helper,headings[4]);
                headings[5] = helper.returnSalesHeader(component,helper,headings[5]);
                headings[6] = helper.returnSalesHeader(component,helper,headings[6]);
                headings[7] = helper.returnSalesHeader(component,helper,headings[7]);
                headings[8] = helper.returnSalesHeader(component,helper,headings[8]);
                headings[9] = helper.returnSalesHeader(component,helper,headings[9]);
                headings[10] = helper.returnSalesHeader(component,helper,headings[10]);
                headings[11] = helper.returnSalesHeader(component,helper,headings[11]);
                headings[12] = helper.returnSalesHeader(component,helper,headings[12]);
                headings[13] = helper.returnSalesHeader(component,helper,headings[13]);
                headings[14] = helper.returnSalesHeader(component,helper,headings[14]);
                headings[15] = helper.returnSalesHeader(component,helper,headings[15]);
                headings[16] = helper.returnSalesHeader(component,helper,headings[16]);
                headings[17] = helper.returnSalesHeader(component,helper,headings[17]);
                headings[18] = helper.returnSalesHeader(component,helper,headings[18]);
                headings[19] = helper.returnSalesHeader(component,helper,headings[19]);
                headings[20] = helper.returnSalesHeader(component,helper,headings[20]);
                headings[21] = helper.returnSalesHeader(component,helper,headings[21]);
                headings[22] = helper.returnSalesHeader(component,helper,headings[22]);
                headings[23] = helper.returnSalesHeader(component,helper,headings[23]);
                headings[24] = helper.returnSalesHeader(component,helper,headings[24]);
                headings[25] = helper.returnSalesHeader(component,helper,headings[25]);
                headings[26] = helper.returnSalesHeader(component,helper,headings[26]);
                headings[27] = helper.returnSalesHeader(component,helper,headings[27]);
                headings[28] = helper.returnSalesHeader(component,helper,headings[28]);
                headings[29] = helper.returnSalesHeader(component,helper,headings[29]);
                headings[30] = helper.returnSalesHeader(component,helper,headings[30]);
                headings[31] = helper.returnSalesHeader(component,helper,headings[31]);
                headings[32] = helper.returnSalesHeader(component,helper,headings[32]);
                headings[33] = helper.returnSalesHeader(component,helper,headings[33]);
                headings[34] = helper.returnSalesHeader(component,helper,headings[34]);
                headings[35] = helper.returnSalesHeader(component,helper,headings[35]);
                headings[36] = helper.returnSalesHeader(component,helper,headings[36]);
                headings[37] = helper.returnSalesHeader(component,helper,headings[37]);
                headings[38] = helper.returnSalesHeader(component,helper,headings[38]);
                headings[39] = helper.returnSalesHeader(component,helper,headings[39]);
                headings[40] = helper.returnSalesHeader(component,helper,headings[40]);
                headings[41] = helper.returnSalesHeader(component,helper,headings[41]);
                headings[42] = helper.returnSalesHeader(component,helper,headings[42]);
                rows[0] = headings.join();
                return rows.join( '\n' );
            },
            complete: complete});
    },       
    
    openModal: function(component, event, helper) {
        var modal = component.find("inventoryModal");
        var modalBackdrop = component.find("inventoryModalBackdrop");
        $A.util.addClass(modal,"slds-fade-in-open");
        $A.util.addClass(modalBackdrop,"slds-backdrop_open");
    },
    closeModal: function(component, event, helper) {
        var modal = component.find("inventoryModal");
        var modalBackdrop = component.find("inventoryModalBackdrop");
        $A.util.removeClass(modal,"slds-fade-in-open");
        $A.util.removeClass(modalBackdrop,"slds-backdrop_open");
    },
    
    openBulkUploadConfirmation: function(component, event, helper) { 
        
        component.set("v.openBulkUploadConfirmation",true);
        /* var modal = component.find("salesModalPopUp");
        var modalBackdrop = component.find("salesModalPopUpBackdrop");
        $A.util.addClass(modal,"slds-fade-in-open");
        $A.util.addClass(modalBackdrop,"slds-backdrop_open");*/
        
    },
    closeBulkUploadConfirmation: function(component, event, helper) {
        component.set("v.openBulkUploadConfirmation",false);
        /* var modal = component.find("salesModalPopUp");
        var modalBackdrop = component.find("salesModalPopUpBackdrop");
        $A.util.removeClass(modal,"slds-fade-in-open");
        $A.util.removeClass(modalBackdrop,"slds-backdrop_open");  */   
         
     },
    openFileDataSubmittedModal: function(component, event, helper) {
        component.set("v.openFileDataSubmitted",true);
        var modal = component.find("openFileDataSubmitted");
        var modalBackdrop = component.find("openFileDataSubmittedBackdrop");
        $A.util.addClass(modal,"slds-fade-in-open");
        $A.util.addClass(modalBackdrop,"slds-backdrop_open"); 
        
    },
    closeModalopenFileDataSubmittedModal: function(component, event, helper) {
        
        component.set("v.openFileDataSubmitted",false);
        var modal = component.find("openFileDataSubmitted");
        var modalBackdrop = component.find("openFileDataSubmittedBackdrop");
        $A.util.removeClass(modal,"slds-fade-in-open");
        $A.util.removeClass(modalBackdrop,"slds-backdrop_open");
    },
    openErrorModal: function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: "Error",
            message: 'Error in the data File Uploaded, Please click the Error Details link',
            type: "error",
            mode:"sticky"
        });
        toastEvent.fire();
    },
    closeErrorModal: function(component, event, helper) {
        var modal = component.find("inventoryErrorModal");
        var modalBackdrop = component.find("inventoryErrorModalBackdrop");
        $A.util.removeClass(modal,"slds-fade-in-open");
        $A.util.removeClass(modalBackdrop,"slds-backdrop_open");
    },
    openErrorFileFormatModal: function(component, event, helper) { 
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: "Error",
            message: 'Error in Format of the data File Uploaded',
            type: "error",
            mode:"sticky"
        });
        toastEvent.fire();
    },
    closeErrorFileFormatModal: function(component, event, helper) {
        var modal = component.find("errorFileFormatModal");
        var modalBackdrop = component.find("errorFileFormatModalBackdrop");
        $A.util.removeClass(modal,"slds-fade-in-open");
        $A.util.removeClass(modalBackdrop,"slds-backdrop_open");
    },
    cmpWeekOpen: function(component, event, helper) {
        var modal = component.find("cmpWeekMissing");
        var modalBackdrop = component.find("cmpWeekMissingBackdrop");
        $A.util.addClass(modal,"slds-fade-in-open");
        $A.util.addClass(modalBackdrop,"slds-backdrop_open");
    },
    
    returnColumnHeader: function(component,helper,headerName) {
        if(headerName != ""  && headerName != null )
        {
            if(headerName=='Retailer Code'){
                return 'Retailer_Code__c';
            }else if(headerName=='Mainetti Company'){
                return 'Mainetti_Company__c';
            }else if(headerName=='Inventory Model'){
                return 'Inventory_Model__c';
            }else if(headerName=='Warehouse'){
                return 'Warehouse__c';
            }else if(headerName=='Color'){
                return 'Color__c';
            }else if(headerName=='Sizer Print'){
                return 'Sizer_Print__c';
            }else if(headerName=='Local System SKU'){
                return 'Local_System_SKU__c';
            }else if(headerName=='Source'){
                return 'Source__c';
            }else if(headerName=='Stock In Date'){
                return 'Stock_In_Date__c';
            }else if(headerName=='Stock In Qty'){
                return 'Stock_In_Qty__c';
            }else{
                component.set("v.submit",false);
                return false;
            }
        }
        else{
            component.set("v.submit",false);
            return false;
        }
    },    
    returnSalesHeader: function(component,helper,headerName) {
        if(headerName != ""  && headerName != null )
        {
            if(headerName.toLowerCase() =='Company'.toLowerCase()){
                return 'Company__c';
            }else if(headerName.toLowerCase() =='Year'.toLowerCase()){
                return 'Year__c';
            }else if(headerName.toLowerCase() =='Week'.toLowerCase()){
                return 'Week__c';
            }else if(headerName.toLowerCase() =='Month'.toLowerCase()){
                return 'Month__c';
            }else if(headerName.toLowerCase() =='Item code'.toLowerCase()){
                return 'Item_code__c';
            }else if(headerName.toLowerCase() =='Material'.toLowerCase()){
                return 'Material__c';
            }else if(headerName.toLowerCase() =='Source'.toLowerCase()){
                return 'Source__c';
            }else if(headerName.toLowerCase() =='Model'.toLowerCase()){
                return 'Model__c';
            }else if(headerName.toLowerCase() =='Printed_Logo'.toLowerCase()){
                return 'Printed_Logo__c';
            }else if(headerName.toLowerCase() =='Color'.toLowerCase()){
                return 'Color__c';
            }else if(headerName.toLowerCase() =='Customer'.toLowerCase()){
                return 'Customer__c';
            }else if(headerName.toLowerCase() =='Customer local name'.toLowerCase()){
                return 'Customer_local_name__c';
            }else if(headerName.toLowerCase() =='Mainetti_Brand'.toLowerCase()){
                return 'Mainetti_Brand__c';
            }
                else if(headerName.toLowerCase() =='Category'.toLowerCase()){
                    return 'Category__c';
                }
                    else if(headerName.toLowerCase() =='Sub-Category'.toLowerCase()){
                        return 'Sub_Category__c';
                    }
                        else if(headerName.toLowerCase() =='Family'.toLowerCase()){
                            return 'Family__c';
                        }
                            else if(headerName.toLowerCase() =='Order_Type'.toLowerCase()){
                                return 'Order_Type__c';
                            }
                                else if(headerName.toLowerCase() =='Units Sold'.toLowerCase()){
                                    return 'Unit_Sold__c';
                                }
                                    else if(headerName.toLowerCase() =='Unit Price / 100(EUR)'.toLowerCase()){
                                        return 'Unit_Price_100_EUR__c';
                                    }
                                        else if(headerName.toLowerCase() =='Unit Price / 100(USD)'.toLowerCase()){
                                            return 'Unit_Price_100_USD__c';
                                        }
                                            else if(headerName.toLowerCase() =='Net Unit Price/100'.toLowerCase()){
                                                return 'Net_Unit_Price_100__c';
                                            }
                                                else if(headerName.toLowerCase() =='Sales EUR'.toLowerCase()){
                                                    return 'Sales_EUR__c';
                                                }
                                                    else if(headerName.toLowerCase() =='Sales USD'.toLowerCase()){
                                                        return 'Sales_USD__c';
                                                    }else if(headerName.toLowerCase() =='Transaction Currency'.toLowerCase()){
                                                        return 'Transaction_Currency__c';
                                                    }else if(headerName.toLowerCase() =='Exchange Rate to 1 EUR'.toLowerCase()){
                                                        return 'ExRate_to_EUR__c';
                                                    }else if(headerName.toLowerCase() =='Exchange Rate to 1 USD'.toLowerCase()){
                                                        return 'ExRate_to_USD__c';
                                                    }else if(headerName.toLowerCase() =='Local Net Unit Price/100'.toLowerCase()){
                                                        return 'Local_Net_Unit_Pirce_100__c';
                                                    }else if(headerName.toLowerCase() =='Sales (Transaction Currency)'.toLowerCase()){
                                                        return 'Sales_Transaction_Currency__c';
                                                    }else if(headerName.toLowerCase() =='Shipped To - Factory'.toLowerCase()){
                                                        return 'Shipped_To_Factory__c';
                                                    }else if(headerName.toLowerCase() =='Shipped To - Country'.toLowerCase()){
                                                        return 'Shipped_To_Country__c';
                                                    }else if(headerName.toLowerCase() =='Label'.toLowerCase()){
                                                        return 'Label__c';
                                                    }else if(headerName.toLowerCase() =='End-user'.toLowerCase()){
                                                        return 'End_user__c';
                                                    }else if(headerName.toLowerCase() =='Vendor'.toLowerCase()){
                                                        return 'Vendor__c';
                                                    }else if(headerName.toLowerCase() =='Division'.toLowerCase()){
                                                        return 'Division__c';
                                                    }else if(headerName.toLowerCase() =='Retailer_Brand'.toLowerCase()){
                                                        return 'Retailer_Brand__c';
                                                    }else if(headerName.toLowerCase() =='Royalty Rate'.toLowerCase()){
                                                        return 'Royalty_Rate__c';
                                                    }else if(headerName.toLowerCase() =='Market'.toLowerCase()){
                                                        return 'Market__c';
                                                    }else if(headerName.toLowerCase() =='Remark'.toLowerCase()){
                                                        return 'Remark__c';
                                                    }else if(headerName.toLowerCase() =='LOB'.toLowerCase()){
                                                        return 'LOB__c';
                                                    }else if(headerName.toLowerCase() =='SO_Number'.toLowerCase()){
                                                        return 'SO_Number__c';
                                                    }else if(headerName.toLowerCase() =='Production Country'.toLowerCase()){
                                                        return 'Production_Country__c';
                                                    }else if(headerName.toLowerCase() =='Gross Sales (USD)'.toLowerCase()){
                                                        return 'Gross_Sales_USD__c';
                                                    }else if(headerName.toLowerCase() =='Freight Charge (USD)'.toLowerCase()){
                                                        return 'Freight_Charge_USD__c';
                                                    }else{
                                                        component.set("v.submitSales",false);
                                                        return false;
                                                    }
        }
        else{
            component.set("v.submitSales",false);
            return false;
        }
    },
    month: function (component, event, helper) {
        helper.monthDynamic(
            $A.getCallback(function handleServerResponse(serverResponse) {
                component.set('v.optionss', serverResponse.month);
            })
        );
        var date = new Date();      
        var defaultMonth = date.getMonth();
    },    
    monthDynamic: function (onResponse) {
        setTimeout(function () {
            var serverResponse = {
                //selectedColorId: 2,
                month: [
                    { id: 0, label: 'Jan' },
                    { id: 1, label: 'Feb'} ,
                    { id: 2, label: 'Mar'},
                    { id: 3, label: 'Apr'},
                    { id: 4, label: 'May'},
                    { id: 5, label: 'Jun'},
                    { id: 6, label: 'Jul'},
                    { id: 7, label: 'Aug'},
                    { id: 8, label: 'Sep'},
                    { id: 9, label: 'Oct'},
                    { id: 10, label: 'Nov'},
                    { id: 11, label: 'Dec'}
                    
                ]
            };
            onResponse.call(null, serverResponse);
        }, 2000);
    },    
    // Company For Sales
    getSalesCountryPicklist: function(component, event) {
        var action = component.get("c.getsalesCompanyList");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue(); 
                var partnerCompanyMap = [];
                for(var key in result){
                    partnerCompanyMap.push({key: key, value: result[key]});
                }
                component.set("v.SalesCompanyMap", partnerCompanyMap);
            }
        });
        $A.enqueueAction(action);
    },    
    
    openDataSubmittedModal: function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: "Error",
            message: 'The File data as already been submitted',
            type: "error",
            mode:"sticky"
        });
        toastEvent.fire();
    },
    closeDataSubmittedModal: function(component, event, helper) {
        var modal = component.find("dataSubmittedModal");
        var modalBackdrop = component.find("dataSubmittedModalBackdrop");
        $A.util.removeClass(modal,"slds-fade-in-open");
        $A.util.removeClass(modalBackdrop,"slds-backdrop_open");
    },
    openErrorSubmittedModal: function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: "Error",
            message: 'The Error File data as already been submitted, Please Use Re-Upload Button',
            duration:'5000',
            type: "info",
            mode:"dismissible"
        });
        toastEvent.fire();
    },
    SalesFile: function (file) {
        var file = new File([csvWrapper.csvFileContent], csvWrapper.fileName, {type: "text/plain"});    
        var fileContent = atob(csvWrapper.csvFileContent);
        var fileData = new File([fileContent], csvWrapper.fileName, {type: "text/plain"});
        Papa.parse(fileData,{
            header: true,
            beforeFirstChunk: function( chunk ) {
                var rows = chunk.split( /\r\n|\r|\n/ );
                var headings = rows[0].split( ',' );
                alert(returnSalesHeader(headings[0]));
                headings[0] = returnSalesHeader(headings[0]);
                headings[1] = returnSalesHeader(headings[1]);
                headings[2] = returnSalesHeader(headings[2]);
                headings[3] = returnSalesHeader(headings[3]);
                headings[4] = returnSalesHeader(headings[4]);
                headings[5] = returnSalesHeader(headings[5]);
                headings[6] = returnSalesHeader(headings[6]);
                headings[7] = returnSalesHeader(headings[7]);
                headings[8] = returnSalesHeader(headings[8]);
                headings[9] = returnSalesHeader(headings[9]);
                headings[10] = returnSalesHeader(headings[10]);
                headings[11] = returnSalesHeader(headings[11]);
                headings[12] = returnSalesHeader(headings[12]);
                headings[13] = returnSalesHeader(headings[13]);
                headings[14] = returnSalesHeader(headings[14]);
                headings[15] = returnSalesHeader(headings[15]);
                headings[16] = returnSalesHeader(headings[16]);
                headings[17] = returnSalesHeader(headings[17]);
                headings[18] = returnSalesHeader(headings[18]);
                headings[19] = returnSalesHeader(headings[19]);
                headings[20] = returnSalesHeader(headings[20]);
                headings[21] = returnSalesHeader(headings[21]);
                headings[22] = returnSalesHeader(headings[22]);
                headings[23] = returnSalesHeader(headings[23]);
                headings[24] = returnSalesHeader(headings[24]);
                headings[25] = returnSalesHeader(headings[25]);
                headings[26] = returnSalesHeader(headings[26]);
                headings[27] = returnSalesHeader(headings[27]);
                headings[28] = returnSalesHeader(headings[28]);
                headings[29] = returnSalesHeader(headings[29]);
                headings[30] = returnSalesHeader(headings[30]);
                headings[31] = returnSalesHeader(headings[31]);
                headings[32] = returnSalesHeader(headings[32]);
                headings[33] = returnSalesHeader(headings[33]);
                headings[34] = returnSalesHeader(headings[34]);
                headings[35] = returnSalesHeader(headings[35]);
                headings[36] = returnSalesHeader(headings[36]);
                headings[37] = returnSalesHeader(headings[37]);
                headings[38] = returnSalesHeader(headings[38]);
                headings[39] = returnSalesHeader(headings[39]);
                headings[40] = returnSalesHeader(headings[40]);
                headings[41] = returnSalesHeader(headings[41]);
                headings[42] = returnSalesHeader(headings[42]);
                rows[0] = headings.join();
                return rows.join( '\n' );
            },
            complete: function(results) {
                var myJson = JSON.stringify(results.data);
                //console.log('myjson:'+myJson);
                var csv = Papa.unparse(myJson);
                //console.log('csv:'+csv);
                var file = new File([csv], csvWrapper.fileName, {type: "text/plain"});
                uploadFile(file);
            }
        });
    },
    closeModal: function(component, event, helper) {
        var modal = component.find("inventoryModal");
        var modalBackdrop = component.find("inventoryModalBackdrop");
        $A.util.removeClass(modal,"slds-fade-in-open");
        $A.util.removeClass(modalBackdrop,"slds-backdrop_open");
    },
    /*deleteDefunctBatch: function(component, event,helper,batchId) {
       // var batchId = event.getSource().get("v.name"); 
      //  alert('batchId'+batchId);
        var action=component.get("c.deleteDefunctBatch");
        action.setParams({
            "batchId": batchId            
        });
        action.setCallback(this,function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.toggleSpinner", false);
                console.log('After Success::::::'+response.getReturnValue());
                // component.set("v.data", response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        });
        $A.enqueueAction(action);
    },*/
     deleteDefunctBatch : function(component,helper,batchId) {
         console.log('########INSIDE deleteDefunctBatch:::'+batchId);
        var action=component.get("c.deleteDefunctBatchRecord");
        action.setParams({
            "batchId": batchId
        });
        action.setCallback(this,function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.toggleSpinner", false);
                console.log('Deletion submission successfully');
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        });
        $A.enqueueAction(action);
     },
})