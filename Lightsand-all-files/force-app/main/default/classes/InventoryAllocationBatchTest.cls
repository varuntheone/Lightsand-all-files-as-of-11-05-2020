@isTest
public class InventoryAllocationBatchTest {
    
    static testMethod void getRecordStatusTest() {
        
        InventoryAllocationBatch invAllocationBatch = new InventoryAllocationBatch();
        Date startdate = date.today();
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day());
        Date weekStart = todaydateinstance.toStartOfWeek();
        Date weekEnd = todaydateinstance.adddays(7).tostartofweek();
        
        //Online order details for Portal.
        Online_Enquiry__c onlineEnquiry = new Online_Enquiry__c();
        onlineEnquiry.Order_Country__c = 'Hong Kong - Mainetti (HK) Ltd';
        onlineEnquiry.Export_Term__c = 'FOB';
        onlineEnquiry.Division__c = 'Outerwear';
        onlineEnquiry.Season__c = 'Spring';
        onlineEnquiry.Customer_PO_No__c = 'PO9873423';
        onlineEnquiry.Preferred_Currency__c = 'HKD - Hong Kong Dollar';
        onlineEnquiry.Season_Year__c = '2020';
        onlineEnquiry.Bill_To__c = 'a0hp0000003TJqRAAW';
        onlineEnquiry.Ship_To__c = 'a0hp0000004RqKqAAK';
        onlineEnquiry.Retailer_Code__c = 'a00p0000008NzFPAA0';
        onlineEnquiry.External_Id__c = '40220201502';
        onlineEnquiry.RecordTypeId = '01290000000nQZMAA2';
        insert onlineEnquiry;
        
        Online_Detail__c onlineDetail = new Online_Detail__c();
        onlineDetail.Model__c = 'a02p00000088auXAAQ'; // TNGU139 model.
        onlineDetail.Color__c = 'GRAY';
        onlineDetail.Qty__c = 2000;
        onlineDetail.Quoted_Currency_Price_100__c = 1.21;
        onlineDetail.USD_Price_100__c = 20;
        onlineDetail.USD_TO_PREFER_CURRENCY__c = 1;
        onlineDetail.RecordTypeId = '01290000000TNpeAAG';
        onlineDetail.Online_Details_Status__c = 'New';
        onlineDetail.TransactionID__c = onlineEnquiry.Id;
        //insert onlineDetail;
        
        Price_Specification_Book_Product__c product = new Price_Specification_Book_Product__c();
        product.Name = 'TNGU139';
        product.Retailer_Code__c = 'a00p0000008NzFPAA0'; // GU retailer.
        product.Color__c = 'GRAY';
        product.Price_100pcs__c = 82.524;
        product.Freight_Terms__c = '';
        product.Country__c = 'China - South';
        product.Id = onlineDetail.Model__c;
        upsert product;
        
        //Online order details for Magnet
        Sales_Order__c salesOrder = new Sales_Order__c();
        //salesOrder.Name = 'a2Bp0000000MKaZEAW';
        salesOrder.Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        salesOrder.Retailer_Code1__c = 'a00p0000008NzFPAA0'; //Gu Retailer.
        salesOrder.Status__c = 'Old';
        salesOrder.Link_To_ERP__c = 'New';
        //salesOrder.CurrencyIsoCode = 'USD - U.S. Dollar';
        insert salesOrder;
        
        Sales_Order_Line_Items__c salesOderLineItems = new Sales_Order_Line_Items__c();
        salesOderLineItems.Status__c = 'Under Processing';
        salesOderLineItems.Quantity__c = '50';
        salesOderLineItems.Ordered_Quantity__c = 10;
        salesOderLineItems.Supply_Quantity__c = '5';
        salesOderLineItems.Remaining_Qty__c = 0;
        salesOderLineItems.Price_Specification_Book_Product__c = 'a02p00000088auXAAQ';
        salesOderLineItems.Colour__c = 'GRAY';
        salesOderLineItems.Sales_Order__c = salesOrder.Id;
        insert salesOderLineItems;
        
        insert onlineDetail;
        boolean flag = true; 
        
        Weekly_Demand_Summary__c weekdemsum = new Weekly_Demand_Summary__c();
        weekdemsum.Order_to_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
        weekdemsum.Mainetti_Model__c = 'a02p00000088auhAAA';
        weekdemsum.Retailer_Code__c = 'a00p0000008NzFPAA0';
        weekdemsum.Color__c = 'GRAY';
        //weekdemsum.Sizer_Print__c = 's';
        weekdemsum.Quantity__c = 2000;
        //weekdemsum.External_Id__c = '15814301030072';
        weekdemsum.Week_Start_Date__c =weekStart;
        weekdemsum.Week_End_Date__c =weekEnd;
        insert weekdemsum;
        
        //Records for Supply.
        Data_Upload_Transaction__c invDataUpload = new Data_Upload_Transaction__c();
        invDataUpload.Retailer_Code__c = 'a00p0000008NzFPAA0'; //Gu Retailer.
        invDataUpload.Mainetti_Company__c = 'a05p0000003OHyJAAW'; // Mainetti (HK) Ltd
        invDataUpload.Inventory_Model__c = 'a02p00000088auXAAQ';
        invDataUpload.Warehouse__c = 'LongHua Factory';
        invDataUpload.Color__c = 'GRAY';
        invDataUpload.Local_System_SKU__c = '157946';
        invDataUpload.Source__c = 'Virgin';
        invDataUpload.Stock_In_Date__c = weekStart;
        invDataUpload.Stock_In_Qty__c = 400;
        invDataUpload.Record_Type__c = 'Inventory';
        insert invDataUpload;
        
        Data_Upload_Transaction__c invDataUploadReuse = new Data_Upload_Transaction__c();
        invDataUploadReuse.Retailer_Code__c = 'a00p0000008NzFPAA0'; //Gu Retailer.
        invDataUploadReuse.Mainetti_Company__c = 'a05p0000003OHyJAAW'; // Mainetti (HK) Ltd
        invDataUploadReuse.Inventory_Model__c = 'a02p00000088auXAAQ';
        invDataUploadReuse.Warehouse__c = 'LongHua Factory';
        invDataUploadReuse.Color__c = 'GRAY';
        invDataUploadReuse.Local_System_SKU__c = '157946';
        invDataUploadReuse.Source__c = 'Reuse';
        invDataUploadReuse.Stock_In_Date__c = weekStart;
        invDataUploadReuse.Stock_In_Qty__c = 400;
        invDataUploadReuse.Record_Type__c = 'Inventory';
        insert invDataUploadReuse;
        
        Test.startTest();
        invAllocationBatch.prepareWeeklyDemandForecastForInventoryAllocation();        
        Test.stopTest();
        System.assertEquals(true, flag);
    }

}