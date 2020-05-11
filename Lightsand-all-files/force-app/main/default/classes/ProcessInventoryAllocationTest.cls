@isTest
public class ProcessInventoryAllocationTest {
    
         static testMethod void upsertAllDemandSummaryFortheWeekTest(){
                     
             Date startdate = date.today();  
             Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
             Date weekStartDate = todaydateinstance.toStartOfWeek();
             Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
             
             
             ProcessInventoryAllocation processInv = new ProcessInventoryAllocation();
                          
             Retailer_Code__c retailerCode = new Retailer_Code__c();
             retailerCode.Name = 'GU';
             insert retailerCode ;
             
             Online_Enquiry__c onlineEnquiry1 = new Online_Enquiry__c();
             onlineEnquiry1.Order_Country__c = 'Hong Kong - Mainetti (HK) Ltd';
             onlineEnquiry1.Retailer_Code__c = retailerCode.Id;
             onlineEnquiry1.External_Id__c = '40220201502';
             onlineEnquiry1.RecordTypeId = '01290000000nQZMAA2';
             insert onlineEnquiry1;
       
             Online_Detail__c onlineDetail = new Online_Detail__c();            
             onlineDetail.Model__c = 'a02p00000088auXAAQ';
             onlineDetail.Color__c = 'GRAY';
             onlineDetail.Qty__c = 2000;
             onlineDetail.RecordTypeId = '01290000000TNpeAAG';
             onlineDetail.Online_Details_Status__c = 'New';
             onlineDetail.TransactionID__c = onlineEnquiry1.Id;
             
             Online_Detail__c onlineDetail1 = new Online_Detail__c();            
             onlineDetail1.Model__c = 'a02p00000088aueAAA';
             onlineDetail1.Color__c = 'GRAY';
             onlineDetail1.Qty__c = 0;
             onlineDetail1.RecordTypeId = '01290000000TNpeAAG';
             onlineDetail1.Online_Details_Status__c = 'New';
             onlineDetail1.TransactionID__c = onlineEnquiry1.Id;
             
             
             Price_Specification_Book_Product__c productName = new Price_Specification_Book_Product__c();
             productName.Name = 'TNGU139';
             productName.Retailer_Code__c = retailerCode.Id;
             productName.Color__c = 'GRAY';
             productName.Price_100pcs__c = 82.524;
             productName.Freight_Terms__c = '';
             productName.Country__c = 'China - South';
             productName.Id = onlineDetail.Model__c;
             upsert productName;
             
             Price_Specification_Book_Product__c productNames = new Price_Specification_Book_Product__c();
             productNames.Name = 'GUSC-S';
             productNames.Retailer_Code__c = retailerCode.Id;
             productNames.Color__c = 'GRAY';
             productNames.Price_100pcs__c = 82.524;
             productNames.Freight_Terms__c = '';
             productNames.Country__c = 'China - South';
             productNames.Id = onlineDetail.Model__c;
             upsert productNames;
             insert onlineDetail;
             
             Price_Specification_Book_Product__c productName1 = new Price_Specification_Book_Product__c();
             productName1.Name = 'TNGU139';
             productName1.Retailer_Code__c = 'a00p0000008NzFPAA0';
             productName1.Color__c = 'GRAY';
             productName1.Price_100pcs__c = 82.524;
             productName1.Freight_Terms__c = '';
             productName1.Country__c = 'China - South';
             productName1.Id = onlineDetail1.Model__c;
             upsert productName1;
             
             insert onlineDetail1;
             
             Partner__c partners = new Partner__c();
             partners.Name = 'Jinjin (Cambodia) Ltd.';
             partners.Default_Order_to_Company__c = 'Cambodia - Jinjin (Cambodia) Ltd.';
             insert partners; 
             
             
             Weekly_Demand_Summary__c  weeklyDemandSummary = new Weekly_Demand_Summary__c();
             weeklyDemandSummary.Mainetti_Model__c = productName.Id;
             weeklyDemandSummary.Order_to_Company__c = partners.Id;
             weeklyDemandSummary.Retailer_Code__c = retailerCode.Id;
             weeklyDemandSummary.Week_Start_Date__c = weekStartDate;
             weeklyDemandSummary.Week_End_Date__c = weekEndDate;
             weeklyDemandSummary.Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
             weeklyDemandSummary.Quantity__c = 15;
             weeklyDemandSummary.Color__c = 'DARKYELLOW P-7559C';
             weeklyDemandSummary.Sizer_Print__c = 'S';
             weeklyDemandSummary.External_Id__c = '1583311605387_1';
             insert weeklyDemandSummary;
             
             Weekly_Demand_Summary__c  weeklyDemandSummarys = new Weekly_Demand_Summary__c();
             weeklyDemandSummarys.Mainetti_Model__c = productName1.Id;
             weeklyDemandSummarys.Order_to_Company__c = partners.Id;
             weeklyDemandSummarys.Retailer_Code__c = retailerCode.Id;
             weeklyDemandSummarys.Week_Start_Date__c = weekStartDate;
             weeklyDemandSummarys.Week_End_Date__c = weekEndDate;
             weeklyDemandSummarys.Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
             weeklyDemandSummarys.Quantity__c = 15;
             weeklyDemandSummarys.Color__c = 'GRAY';
             weeklyDemandSummarys.Sizer_Print__c = 'XS';
             weeklyDemandSummarys.External_Id__c = '1583311605387_5';
             insert weeklyDemandSummarys;
             
             Weekly_Demand_Consolidated_Order_Id__c WeeklyDemand = new Weekly_Demand_Consolidated_Order_Id__c();
             //WeeklyDemand.Weekly_Demand_Summary__c = weeklyDemandSummarys.Id;
              WeeklyDemand.Weekly_Demand_Summary__c = 'a25p0000000ls5hAAA';
             WeeklyDemand.Online_Enquiry__c =onlineEnquiry1.Id;
             WeeklyDemand.External_Id__c = '1581917465582_1';
             WeeklyDemand.Sales_Order__c = 'a2Bp0000000KKVAEA4';
             WeeklyDemand.Week_Start_Date__c = weekStartDate;
             WeeklyDemand.Week_End_Date__c = weekEndDate;
             insert WeeklyDemand;
             
             Weekly_Demand_Consolidated_Order_Id__c WeeklyDemandId = new Weekly_Demand_Consolidated_Order_Id__c();
             WeeklyDemandId.Weekly_Demand_Summary__c = 'a25p0000000ls5hAAA';
             WeeklyDemandId.Online_Enquiry__c ='a0fp0000008VBdfAAG' ;
             WeeklyDemandId.External_Id__c = '1583311605387_1';
             WeeklyDemandId.Sales_Order__c = 'a2Bp0000000KKVAEA4';
             WeeklyDemandId.Week_Start_Date__c = weekStartDate;
             WeeklyDemandId.Week_End_Date__c = weekEndDate;
             insert WeeklyDemandId;         
             
             Online_Enquiry_Shipment_Invoice__c OnlineShipmentEnquiry =  new Online_Enquiry_Shipment_Invoice__c();
             OnlineShipmentEnquiry.Online_Enquiry_No__c = 'a0fp0000008VBdfAAG';
             OnlineShipmentEnquiry.Product_Name__c = 'JGU138';
             OnlineShipmentEnquiry.Shipped_Qty__c = 15;
             insert OnlineShipmentEnquiry; 
             
             Online_Enquiry_Shipment_Invoice__c OnlineShipmentEnquirys =  new Online_Enquiry_Shipment_Invoice__c();
             OnlineShipmentEnquirys.Online_Enquiry_No__c = 'a0fp0000008VBdfAAG';
             OnlineShipmentEnquirys.Product_Name__c = 'GUSC-S';
             OnlineShipmentEnquirys.Shipped_Qty__c = 50;
             insert OnlineShipmentEnquirys; 
             
             
             Sales_Order__c salesOrder = new Sales_Order__c();
             //salesOrder.Name = 'a2Bp0000000MKaZEAW';
             salesOrder.Company__c = 'Hong Kong - Mainetti (HK) Ltd';
             salesOrder.Retailer_Code1__c = 'a00p0000008NzFPAA0';
             salesOrder.Status__c = 'New Order';
             salesOrder.Link_To_ERP__c = 'New';
             //salesOrder.CurrencyIsoCode = 'USD - U.S. Dollar';
             insert salesOrder;
             
             Sales_Order_Line_Items__c salesOderLineItem = new Sales_Order_Line_Items__c();
             salesOderLineItem.Status__c = 'Under Processing';
             salesOderLineItem.Quantity__c = '50';
             salesOderLineItem.Ordered_Quantity__c = 10;
             salesOderLineItem.Supply_Quantity__c = '5';
             salesOderLineItem.Remaining_Qty__c = 0;
             salesOderLineItem.Price_Specification_Book_Product__c = 'a02p00000088auXAAQ';
             salesOderLineItem.Colour__c = 'GRAY';
             salesOderLineItem.Sales_Order__c = salesOrder.Id;
             insert salesOderLineItem;
             
             Sales_Order_Line_Items__c salesOderLineItems = new Sales_Order_Line_Items__c();
             salesOderLineItems.Status__c = 'Under Processing';
             salesOderLineItems.Quantity__c = '50';
             salesOderLineItems.Ordered_Quantity__c = 10;
             salesOderLineItems.Supply_Quantity__c = '5';
             salesOderLineItems.Remaining_Qty__c = 0;
             salesOderLineItems.Price_Specification_Book_Product__c = 'a02p00000088auiAAA';
             salesOderLineItems.Colour__c = 'GRAY';
             salesOderLineItems.Sales_Order__c = salesOrder.Id;
             insert salesOderLineItems;
             
              
             
             Data_Upload_Transaction__c DataUpload = new Data_Upload_Transaction__c();
             DataUpload.Mainetti_Company__c = partners.Id; 
            // DataUpload.Mainetti_Company__c = partners.Id;
             DataUpload.Retailer_Code__c = 'a00p0000008NzFPAA0';
             DataUpload.Inventory_Model__c = 'a02p00000088aueAAA';
             DataUpload.Color__c = 'GRAY';
             DataUpload.Sizer_Print__c = 'XS';
             DataUpload.Warehouse__c = 'Ningbo Warehouse';
             DataUpload.Stock_In_Qty__c = 15; 
             DataUpload.Record_Type__c ='Inventory';
             DataUpload.Source__c = 'Virgin';
             insert DataUpload;       
             
             Data_Upload_Transaction__c DataUploads = new Data_Upload_Transaction__c();
             DataUploads.Mainetti_Company__c = partners.Id;  
             DataUploads.Retailer_Code__c = 'a00p0000008NzFPAA0';
             DataUploads.Inventory_Model__c =  productName.Id;
             DataUploads.Color__c = 'GRAY';
             DataUploads.Sizer_Print__c = 'XS';
             DataUploads.Warehouse__c = 'Ningbo Warehouse';
             DataUploads.Stock_In_Qty__c = 15; 
             DataUploads.Record_Type__c ='Inventory';
             DataUploads.Source__c = 'Virgin';
             insert DataUploads;      
            
             
             Data_Upload_Transaction__c DataUpload1 = new Data_Upload_Transaction__c();
             DataUpload1.Mainetti_Company__c = partners.Id;  
             DataUpload1.Retailer_Code__c = 'a00p0000008NzFPAA0';
             DataUpload1.Inventory_Model__c =  productName.Id;
             DataUpload1.Color__c = 'GRAY';
             DataUpload1.Sizer_Print__c = 'XS';
             DataUpload1.Warehouse__c = 'Ningbo Warehouse';
             DataUpload1.Stock_In_Qty__c = 15; 
             DataUpload1.Record_Type__c ='Inventory';
             DataUpload1.Source__c = 'Reuse';
             insert DataUpload1;       
             
             Data_Upload_Transaction__c DataUploading = new Data_Upload_Transaction__c();
             DataUploading.Mainetti_Company__c = partners.Id;  
             DataUploading.Retailer_Code__c = 'a00p0000008NzFPAA0';
             DataUploading.Inventory_Model__c =  productName.Id;
             DataUploading.Color__c = 'GRAY';
             DataUploading.Sizer_Print__c = 'XS';
             DataUploading.Warehouse__c = 'Ningbo Warehouse';
             DataUploading.Stock_In_Qty__c = 15; 
             DataUploading.Record_Type__c ='Inventory';
             DataUploading.Source__c = 'Reuse';
             insert DataUploading;
             
             Retailer_Code__c retailer = new Retailer_Code__c();
             retailer.Name = 'GU';
             insert retailer ;
             
              Weekly_Supply_Summary__c WeeklySupply1 = new Weekly_Supply_Summary__c();
             
             WeeklySupply1.Mainetti_Company__c = partners.Id;  
             WeeklySupply1.Mainetti_Model__c = productName.Id;
             WeeklySupply1.Retailer_Code__c = retailerCode.Id;
             WeeklySupply1.Warehouse__c = 'LongHua Factory';
             WeeklySupply1.Color__c = 'GRAY';
             WeeklySupply1.Sizer_Print__c = 'XS';
             WeeklySupply1.Week_Start_Date__c = System.today() +5;
             WeeklySupply1.Week_End_Date__c =  System.today() -5; 
             WeeklySupply1.Source__c = 'Reuse';
             WeeklySupply1.Quantity__c = 15;
             insert WeeklySupply1;
             
             Weekly_Supply_Summary__c WeeklySupply = new Weekly_Supply_Summary__c();
             
             WeeklySupply.Mainetti_Company__c = partners.Id;  
             WeeklySupply.Mainetti_Model__c = productName.Id;
             WeeklySupply.Retailer_Code__c = retailerCode.Id;
             WeeklySupply.Warehouse__c = 'LongHua Factory';
             WeeklySupply.Color__c = 'GRAY';
             WeeklySupply.Sizer_Print__c = 'XS';
             WeeklySupply.Week_Start_Date__c = System.today() +5;
             WeeklySupply.Week_End_Date__c =  System.today() -5; 
             WeeklySupply.Source__c = 'Reuse';
             WeeklySupply.Quantity__c = 15;
             insert WeeklySupply;      
             
            
             
             
             Weekly_Supply_Summary__c WeeklySupplySum = new Weekly_Supply_Summary__c();
            
             WeeklySupplySum.Mainetti_Company__c = 'Cambodia - Jinjin (Cambodia) Ltd.';  
             WeeklySupplySum.Mainetti_Model__c = productName.Id;
             WeeklySupplySum.Retailer_Code__c = retailer.Id;
             WeeklySupplySum.Warehouse__c = 'Ningbo Warehouse';
             WeeklySupplySum.Color__c = 'GRAY';
             WeeklySupplySum.Sizer_Print__c = 'XS';
             WeeklySupplySum.Week_Start_Date__c = System.today() +5;
             WeeklySupplySum.Week_End_Date__c = System.today() -5; 
             WeeklySupplySum.Quantity__c = 15;
             WeeklySupplySum.Source__c = 'Virgin';
             insert WeeklySupplySum;      
             
             
             Weekly_Shipment_Summary__c shipmentSummary = new Weekly_Shipment_Summary__c();
             shipmentSummary.Weekly_Demand_Summary__c =  weeklyDemandSummarys.Id; 
             shipmentSummary.Quantity__c = 50;
             shipmentSummary.Color__c = 'GRAY';
             shipmentSummary.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
             shipmentSummary.Week_Start_Date__c = weekStartDate;
             insert shipmentSummary; 
             
             Weekly_Shipment_Summary__c shipmentSummary1 = new Weekly_Shipment_Summary__c();
             shipmentSummary1.Weekly_Demand_Summary__c =  weeklyDemandSummarys.Id; 
             shipmentSummary1.Quantity__c = 50;
             shipmentSummary1.Color__c = 'GRAY';
             shipmentSummary1.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
             shipmentSummary1.Week_Start_Date__c = weekStartDate;
             insert shipmentSummary1; 
             
             Shipment_Line_Item__c shipmentItem = new Shipment_Line_Item__c();
             shipmentItem.Shipment__c = 'a2Hp0000000ZKt1EAG';
             shipmentItem.Mainetti_Order_Line_Item__c = salesOderLineItems.Id;
             shipmentItem.Shipped_Quantity__c = 15;
             insert shipmentItem; 
             
             Weekly_Supply_Consolidated_Id__c weekConId = new Weekly_Supply_Consolidated_Id__c();
             weekConId.Data_Upload_Transaction__c = DataUpload1.Id;
             weekConId.Week_Start_Date__c = System.today() +5;
             weekConId.Week_End_Date__c = System.today() - 5;
             insert weekConId;
             
             List<Weekly_Supply_Consolidated_Id__c> weeklySupplpyConsolidatedList  = new List<Weekly_Supply_Consolidated_Id__c>();
             //List<Weekly_Supply_Summary__c> weeklySupplySummaryList = new List<Weekly_Supply_Summary__c>();
             for(Integer i=0; i<=9901; i++){
                 Weekly_Supply_Consolidated_Id__c weekdemconsol = new Weekly_Supply_Consolidated_Id__c();
                // Weekly_Supply_Summary__c weekSuply = new Weekly_Supply_Summary__c();
                 weeklySupplpyConsolidatedList.add(weekdemconsol);
                 //weeklySupplySummaryList.add(weekSuply);
             }
             
             String weekNumber = '10';
             Date weekStartDate1 = null;
             Date weekEndDate1 = null;
             Date weekStartDate2 = system.today() +5;
             Date weekEndDate2 = System.today() - 5;
             String weekNumber1 = '10';
            
             boolean flag = true;
             Test.startTest();             
             processInv.upsertAllDemandSummaryFortheWeek( weekNumber,weekStartDate ,weekEndDate); 
             processInv.upsertAllDemandSummaryFortheWeek( weekNumber,weekStartDate ,weekEndDate);
             processInv.upsertAllDemandSummaryFortheWeek( weekNumber1,weekStartDate1 ,weekEndDate1);
             processInv.upsertAllDemandSummaryFortheWeek( weekNumber1,weekStartDate2 ,weekEndDate2);
           
             processInv.upsertAllSupplySummaryFortheWeek( weekNumber,weekStartDate,weekEndDate);
             processInv.upsertAllSupplySummaryFortheWeek( weekNumber1,weekStartDate2,weekEndDate2);
             processInv.upsertAllShipmentSummaryFortheWeek( weekNumber,weekStartDate ,weekEndDate); 
             processInv.upsertAllShipmentSummaryFortheWeek( weekNumber1,weekStartDate1 ,weekEndDate1); 
             processInv.splitConsolidateSupplyListForUpsert( weeklySupplpyConsolidatedList); 
            
             Test.stopTest();
             System.assertEquals(true, flag); 
                         }
            
            static testMethod void upsertAllSupplySummaryFortheWeekTest(){
                     
                Date startdate = date.today();  
                Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
                Date weekStartDate = todaydateinstance.toStartOfWeek();
                Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
                 String weekNumber1 = '10';
                 Date weekStartDate2 = system.today() +5;
             Date weekEndDate2 = System.today() - 5;
                
                ProcessInventoryAllocation processInv = new ProcessInventoryAllocation();
                Retailer_Code__c retailerCode = new Retailer_Code__c();
                retailerCode.Name = 'GU';
                insert retailerCode ;
                
                Online_Enquiry__c onlineEnquiry1 = new Online_Enquiry__c();
                onlineEnquiry1.Order_Country__c = 'Hong Kong - Mainetti (HK) Ltd';
                onlineEnquiry1.Retailer_Code__c = retailerCode.Id;
                onlineEnquiry1.External_Id__c = '40220201502';
                onlineEnquiry1.RecordTypeId = '01290000000nQZMAA2';
                insert onlineEnquiry1;
             
             
                Online_Detail__c onlineDetail = new Online_Detail__c();            
                onlineDetail.Model__c = 'a02p00000088auXAAQ';
                onlineDetail.Color__c = 'GRAY';
                onlineDetail.Qty__c = 2000;
                onlineDetail.RecordTypeId = '01290000000TNpeAAG';
                onlineDetail.Online_Details_Status__c = 'New';
                onlineDetail.TransactionID__c = onlineEnquiry1.Id;
                
                Price_Specification_Book_Product__c productName = new Price_Specification_Book_Product__c();
                productName.Name = 'TNGU139';
                productName.Retailer_Code__c = 'a00p0000008NzFPAA0';
                productName.Color__c = 'GRAY';
                productName.Price_100pcs__c = 82.524;
                productName.Freight_Terms__c = '';
                productName.Country__c = 'China - South';
                productName.Id = onlineDetail.Model__c;
                upsert productName;
                
                insert onlineDetail;
                
               Partner__c partners = new Partner__c();
                partners.Name = 'Jinjin (Cambodia) Ltd.';
                partners.Default_Order_to_Company__c = 'Cambodia - Jinjin (Cambodia) Ltd.';
                insert partners; 
                
                Weekly_Demand_Summary__c  weeklyDemandSummary = new Weekly_Demand_Summary__c();
                weeklyDemandSummary.Mainetti_Model__c = productName.Id;
                weeklyDemandSummary.Retailer_Code__c = retailerCode.Id;
                weeklyDemandSummary.Week_Start_Date__c = weekStartDate;
                weeklyDemandSummary.Week_End_Date__c = weekEndDate;
                weeklyDemandSummary.Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
                weeklyDemandSummary.Quantity__c = 15;
                weeklyDemandSummary.Color__c = 'GRAY';
                weeklyDemandSummary.Sizer_Print__c = 'xs';
                insert weeklyDemandSummary;
                
                Weekly_Demand_Consolidated_Order_Id__c WeeklyDemand = new Weekly_Demand_Consolidated_Order_Id__c();
               WeeklyDemand.Weekly_Demand_Summary__c = weeklyDemandSummary.Id;
                WeeklyDemand.Online_Enquiry__c ='a0fp0000008VFHEAA4' ;
                //WeeklyDemand.External_Id__c = '1581917465582_1';
                WeeklyDemand.Sales_Order__c = 'a2Bp0000000KKVAEA4';
                WeeklyDemand.Week_Start_Date__c = weekStartDate;
                WeeklyDemand.Week_End_Date__c = weekEndDate;
                insert WeeklyDemand;
                
                
                Sales_Order__c salesOrder = new Sales_Order__c();
                //salesOrder.Name = 'a2Bp0000000MKaZEAW';
                salesOrder.Company__c = 'Hong Kong - Mainetti (HK) Ltd';
                salesOrder.Retailer_Code1__c = 'a00p0000008NzFPAA0';
                salesOrder.Status__c = 'Old';
                salesOrder.Link_To_ERP__c = 'New';
                //salesOrder.CurrencyIsoCode = 'USD - U.S. Dollar';
                insert salesOrder;
                
                
                Sales_Order_Line_Items__c salesOderLineItems1 = new Sales_Order_Line_Items__c();
                salesOderLineItems1.Status__c = 'Shipped';
                salesOderLineItems1.Quantity__c = '50';
                salesOderLineItems1.Ordered_Quantity__c = 10;
                salesOderLineItems1.Supply_Quantity__c = '5';
                salesOderLineItems1.Remaining_Qty__c = 0;
                salesOderLineItems1.Price_Specification_Book_Product__c = 'a02p00000088auXAAQ';
                salesOderLineItems1.Colour__c = 'GRAY';
                salesOderLineItems1.Sales_Order__c = salesOrder.Id;
                insert salesOderLineItems1;
                
                Data_Upload_Transaction__c DataUpload = new Data_Upload_Transaction__c();
                DataUpload.Mainetti_Company__c = partners.Id;  
                DataUpload.Retailer_Code__c = 'a00p0000008NzFPAA0';
                DataUpload.Inventory_Model__c = 'a02p00000088aueAAA';
                DataUpload.Color__c = 'GRAY';
                DataUpload.Sizer_Print__c = 'XS';
                DataUpload.Warehouse__c = 'Ningbo Warehouse';
                DataUpload.Stock_In_Qty__c = 15; 
                DataUpload.Record_Type__c ='Inventory';
                DataUpload.Source__c = 'Virgin';
                insert DataUpload;       
                
                Data_Upload_Transaction__c DataUploads = new Data_Upload_Transaction__c();
                DataUploads.Mainetti_Company__c = partners.Id;  
                DataUploads.Retailer_Code__c = 'a00p0000008NzFPAA0';
                DataUploads.Inventory_Model__c = 'a02p00000088aueAAA';
                DataUploads.Color__c = 'GRAY';
                DataUploads.Sizer_Print__c = 'XS';
                DataUploads.Warehouse__c = 'Ningbo Warehouse';
                DataUploads.Stock_In_Qty__c = 15; 
                DataUploads.Record_Type__c ='Inventory';
                DataUploads.Source__c = 'Virgin';
                insert DataUploads;  
                
                 Weekly_Supply_Summary__c WeeklySupplySum = new Weekly_Supply_Summary__c();
                
                WeeklySupplySum.Mainetti_Company__c = partners.Id;  
                WeeklySupplySum.Mainetti_Model__c = productName.Id;
                WeeklySupplySum.Retailer_Code__c = retailerCode.Id;
                WeeklySupplySum.Warehouse__c = 'Ningbo Warehouse';
                WeeklySupplySum.Color__c = 'GRAY';
                WeeklySupplySum.Sizer_Print__c = 'XS';
                WeeklySupplySum.Week_Start_Date__c = System.today() +5;
                WeeklySupplySum.Week_End_Date__c = System.today() -5; 
                WeeklySupplySum.Quantity__c = 15;
                WeeklySupplySum.Source__c = 'Virgin';
                insert WeeklySupplySum;      
                
                
                
                
                Weekly_Supply_Summary__c WeeklySupply = new Weekly_Supply_Summary__c();
                
                WeeklySupply.Mainetti_Company__c = 'Cambodia - Jinjin (Cambodia) Ltd.';  
                WeeklySupply.Mainetti_Model__c = productName.Id;
                WeeklySupply.Retailer_Code__c = retailerCode.Id;
                WeeklySupply.Warehouse__c = 'LongHua Factory';
                WeeklySupply.Color__c = 'GRAY';
                WeeklySupply.Sizer_Print__c = 'XS';
                WeeklySupply.Week_Start_Date__c = System.today() +5;
                WeeklySupply.Week_End_Date__c =  System.today() -5; 
                WeeklySupply.Source__c = 'Reuse';
                WeeklySupply.Quantity__c = 15;
                insert WeeklySupply;      
                
              /*   Weekly_Supply_Summary__c WeeklySupply1 = new Weekly_Supply_Summary__c();
                
                WeeklySupply1.Mainetti_Company__c = partners.Id;  
                WeeklySupply1.Mainetti_Model__c = productName.Id;
                WeeklySupply1.Retailer_Code__c = retailerCode.Id;
                WeeklySupply1.Warehouse__c = 'Ningbo Warehouse';
                WeeklySupply1.Color__c = 'GRAY';
                WeeklySupply1.Sizer_Print__c = 'XS';
                WeeklySupply1.Week_Start_Date__c = System.today() +5;
                WeeklySupply1.Week_End_Date__c =  System.today() -5; 
                WeeklySupply1.Source__c = 'Reuse';
                WeeklySupply1.Quantity__c = 15;
                insert WeeklySupply1;      
                */
                
               
                
                Weekly_Shipment_Summary__c shipmentSummary = new Weekly_Shipment_Summary__c();
                shipmentSummary.Weekly_Demand_Summary__c =  weeklyDemandSummary.Id; 
                shipmentSummary.Quantity__c = 50;
                shipmentSummary.Color__c = 'GRAY';
                shipmentSummary.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
                shipmentSummary.Week_Start_Date__c = weekStartDate;
                insert shipmentSummary; 
                
                Shipment_Line_Item__c shipmentItem = new Shipment_Line_Item__c();
                shipmentItem.Shipment__c = 'a2Hp0000000ZKt1EAG';
                shipmentItem.Mainetti_Order_Line_Item__c = salesOderLineItems1.Id;
                shipmentItem.Shipped_Quantity__c = 15;
                insert shipmentItem; 
                
                Weekly_Supply_Consolidated_Id__c weekConId = new Weekly_Supply_Consolidated_Id__c();
                weekConId.Data_Upload_Transaction__c = DataUpload.Id;
                weekConId.Week_Start_Date__c = System.today() +5;
                weekConId.Week_End_Date__c = System.today() - 5;
                insert weekConId;
                
                List<Weekly_Supply_Summary__c> weeklySupplySummaryList = new List<Weekly_Supply_Summary__c>();
                for(Integer i=0; i<=9901; i++){
                    Weekly_Supply_Summary__c weekSuply = new Weekly_Supply_Summary__c();
                    weekSuply.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
                    weekSuply.Color__c = 'GRAY';
                    weekSuply.Week_Start_Date__c = weekStartDate;
                    weekSuply.Week_End_Date__c = weekEndDate;
                    weekSuply.Quantity__c = 25;
                    weekSuply.Warehouse__c = 'LongHua Factory';
                    weeklySupplySummaryList.add(weekSuply);
             }
               
                String weekNumber = '10';
                boolean flag = true;
                Test.startTest();
                processInv.upsertAllDemandSummaryFortheWeek( weekNumber,weekStartDate ,weekEndDate); 
                processInv.upsertAllSupplySummaryFortheWeek( weekNumber,weekStartDate ,weekEndDate);
                processInv.upsertAllSupplySummaryFortheWeek( weekNumber1,weekStartDate2 ,weekEndDate2);
                processInv.upsertAllShipmentSummaryFortheWeek( weekNumber,weekStartDate ,weekEndDate); 
                processInv.upsertAllShipmentSummaryFortheWeek( weekNumber,weekStartDate ,weekEndDate); 
                processInv.splitSupplyListForUpsert(weeklySupplySummaryList);
                 
                Test.stopTest();
                System.assertEquals(true, flag);
                         }
             
            static testMethod void upsertAllShipmentSummaryFortheWeekTest(){
                
                Date startdate = date.today();  
                Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
                Date weekStartDate = todaydateinstance.toStartOfWeek();
                Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
                
                
                ProcessInventoryAllocation processInv = new ProcessInventoryAllocation();
                
                Date weekStartDate1 = null;
                Date weekEndDate1 = null;
                Date weekStartDate2 = system.today() +5;
                Date weekEndDate2 = System.today() - 5;
                String weekNumber1 = '10';
                
                String weekNumber = '10';
                Retailer_Code__c retailerCode = new Retailer_Code__c();
                retailerCode.Name = 'GU';
                insert retailerCode ;
                
                Online_Enquiry__c onlineEnquiry1 = new Online_Enquiry__c();
                onlineEnquiry1.Order_Country__c = 'Hong Kong - Mainetti (HK) Ltd';
                onlineEnquiry1.Retailer_Code__c = 'a00p0000008NzFPAA0';
                onlineEnquiry1.RecordTypeId = '01290000000nQZMAA2';
                insert onlineEnquiry1;
             
             
                Online_Detail__c onlineDetail = new Online_Detail__c();            
                onlineDetail.Model__c = 'a02p00000088auXAAQ';
                onlineDetail.Color__c = 'GRAY';
                onlineDetail.Qty__c = 2000;
                onlineDetail.RecordTypeId = '01290000000TNpeAAG';
                onlineDetail.Online_Details_Status__c = 'New';
                onlineDetail.TransactionID__c = onlineEnquiry1.Id;
                
                Price_Specification_Book_Product__c productName = new Price_Specification_Book_Product__c();
                productName.Name = 'TNGU139';
                productName.Retailer_Code__c = 'a00p0000008NzFPAA0';
                productName.Color__c = 'GRAY';
                productName.Price_100pcs__c = 82.524;
                productName.Freight_Terms__c = '';
                productName.Country__c = 'China - South';
                productName.Id = onlineDetail.Model__c;
                upsert productName;
                
                insert onlineDetail;
                
                Partner__c partners = new Partner__c();
                partners.Name = 'Jinjin (Cambodia) Ltd.';
                partners.Default_Order_to_Company__c = 'Cambodia - Jinjin (Cambodia) Ltd.';
                insert partners; 
                
                 Weekly_Supply_Summary__c WeeklySupply = new Weekly_Supply_Summary__c();
                
                WeeklySupply.Mainetti_Company__c = 'Cambodia - Jinjin (Cambodia) Ltd.';  
                WeeklySupply.Mainetti_Model__c = productName.Id;
                WeeklySupply.Retailer_Code__c = retailerCode.Id;
                WeeklySupply.Warehouse__c = 'LongHua Factory';
                WeeklySupply.Color__c = 'GRAY';
                WeeklySupply.Sizer_Print__c = 'XS';
                WeeklySupply.Week_Start_Date__c = System.today() +5;
                WeeklySupply.Week_End_Date__c =  System.today() -5; 
                WeeklySupply.Source__c = 'Reuse';
                WeeklySupply.Quantity__c = 15;
                insert WeeklySupply; 
                
                 Weekly_Supply_Summary__c WeeklySupply1 = new Weekly_Supply_Summary__c();
                
                WeeklySupply1.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';  
                WeeklySupply1.Mainetti_Model__c = productName.Id;
                WeeklySupply1.Retailer_Code__c = retailerCode.Id;
                WeeklySupply1.Warehouse__c = 'LongHua Factory';
                WeeklySupply1.Color__c = 'GRAY';
                WeeklySupply1.Sizer_Print__c = 'XS';
                WeeklySupply1.Week_Start_Date__c = System.today() +5;
                WeeklySupply1.Week_End_Date__c =  System.today() -5; 
                WeeklySupply1.Source__c = 'Reuse';
                WeeklySupply1.Quantity__c = 15;
                insert WeeklySupply1; 
                
                 Data_Upload_Transaction__c DataUpload = new Data_Upload_Transaction__c();
                DataUpload.Mainetti_Company__c = partners.Id;  
                DataUpload.Retailer_Code__c = 'a00p0000008NzFPAA0';
                DataUpload.Inventory_Model__c = 'a02p00000088aueAAA';
                DataUpload.Color__c = 'GRAY';
                DataUpload.Sizer_Print__c = 'XS';
                DataUpload.Warehouse__c = 'LongHua Factory';
                DataUpload.Stock_In_Qty__c = 15; 
                DataUpload.Record_Type__c ='Inventory';
                DataUpload.Source__c = 'Reuse';
                insert DataUpload; 
                
                List<Weekly_Demand_Summary__c> weeklyDemandSummaryList = new List<Weekly_Demand_Summary__c>();
                for(Integer i=0; i<=9901; i++){
                    Weekly_Demand_Summary__c weekDemand = new Weekly_Demand_Summary__c();
                    weekDemand.Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
                    weekDemand.Color__c = 'GRAY';
                    weekDemand.Week_Start_Date__c = weekStartDate;
                    weekDemand.Week_End_Date__c = weekEndDate;
                    weekDemand.Quantity__c = 25;
                    weeklyDemandSummaryList.add(weekDemand);
                }

                
                boolean flag = true;
                Test.startTest();
                processInv.upsertAllSupplySummaryFortheWeek( weekNumber,weekStartDate ,weekEndDate);
                processInv.upsertAllShipmentSummaryFortheWeek( weekNumber,weekStartDate ,weekEndDate);
                processInv.upsertAllSupplySummaryFortheWeek( weekNumber1,weekStartDate1 ,weekEndDate1);
                processInv.upsertAllShipmentSummaryFortheWeek( weekNumber1,weekStartDate1 ,weekEndDate1);
                processInv.splitDemandListForUpsert(weeklyDemandSummaryList);
                Test.stopTest();
                System.assertEquals(true, flag);
            }
   
     static testMethod void upsertAllShipmentSummaryFortheWeekTests(){
         
         Date startdate = date.today();  
         Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
         Date weekStartDate = todaydateinstance.toStartOfWeek();
         Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
         
         
         ProcessInventoryAllocation processInv = new ProcessInventoryAllocation();
         List<Weekly_Demand_Consolidated_Order_Id__c> weeklyDemandConsolidatedList = new List<Weekly_Demand_Consolidated_Order_Id__c>();
         for(Integer i=0; i<=9901; i++){
             Weekly_Demand_Consolidated_Order_Id__c weekDemandorder = new Weekly_Demand_Consolidated_Order_Id__c();
             weekDemandorder.External_Id__c = '1583311605387_1';
             weekDemandorder.Week_Start_Date__c = weekStartDate;
             weekDemandorder.Week_End_Date__c = weekEndDate;
             weekDemandorder.Sales_Order__c = 'a2Bp0000000KKGuEAO';             
             weeklyDemandConsolidatedList.add(weekDemandorder);
             }
         processInv.splitConsolidateDemandListForUpsert(weeklyDemandConsolidatedList);
     }
    
    static testMethod void upsertAllShipmentSummaryFortheWeekTest1(){
         
         Date startdate = date.today();  
         Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
         Date weekStartDate = todaydateinstance.toStartOfWeek();
         Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
         
         
          ProcessInventoryAllocation processInv = new ProcessInventoryAllocation();
        
         Retailer_Code__c retailerCode = new Retailer_Code__c();
             retailerCode.Name = 'GU';
             insert retailerCode ;
        
         Online_Enquiry__c onlineEnquiry1 = new Online_Enquiry__c();
             onlineEnquiry1.Order_Country__c = 'Hong Kong - Mainetti (HK) Ltd';
             onlineEnquiry1.Retailer_Code__c = retailerCode.Id;
             onlineEnquiry1.External_Id__c = '40220201502';
             onlineEnquiry1.RecordTypeId = '01290000000nQZMAA2';
             insert onlineEnquiry1;
       
             Online_Detail__c onlineDetail = new Online_Detail__c();            
             onlineDetail.Model__c = 'a02p00000088auXAAQ';
             onlineDetail.Color__c = 'GRAY';
             onlineDetail.Qty__c = 2000;
             onlineDetail.RecordTypeId = '01290000000TNpeAAG';
             onlineDetail.Online_Details_Status__c = 'New';
             onlineDetail.TransactionID__c = onlineEnquiry1.Id;
        
         Price_Specification_Book_Product__c productName = new Price_Specification_Book_Product__c();
             productName.Name = 'TNGU139';
             productName.Retailer_Code__c = retailerCode.Id;
             productName.Color__c = 'GRAY';
             productName.Price_100pcs__c = 82.524;
             productName.Freight_Terms__c = '';
             productName.Country__c = 'China - South';
             productName.Id = onlineDetail.Model__c;
             upsert productName;

        
         List<Weekly_Shipment_Summary__c> weeklyShipmentSummaryList = new List<Weekly_Shipment_Summary__c>();
         for(Integer i=0; i<=9901; i++){
             Weekly_Shipment_Summary__c weeklyShipment = new Weekly_Shipment_Summary__c();
            weeklyShipment.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
            // weeklyShipment.Mainetti_Model__c = retailerCode.Id;
            // weeklyShipment.Retailer_Code__c = productName.Id;
             weeklyShipment.Week_Start_Date__c = weekStartDate;
             weeklyShipment.Week_End_Date__c = weekEndDate;
             weeklyShipment.Color__c = 'GRAY';
             weeklyShipment.Sizer_Print__c = 'XS';
             weeklyShipment.Quantity__c = 50;
             weeklyShipmentSummaryList.add(weeklyShipment);
             }
         processInv.splitShipmentListForUpsert(weeklyShipmentSummaryList);
     }
}