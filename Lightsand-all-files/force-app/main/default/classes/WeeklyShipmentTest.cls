@isTest
public class WeeklyShipmentTest {
@isTest
    
    static void getShipmentSummary(){
        Date startdate = date.today();  
        Date todaydateinstance = date.newinstance(startdate.year(), startdate.month(), startdate.day()); 
        Date weekStartDate = todaydateinstance.toStartOfWeek();
        Date weekEndDate = todaydateinstance.adddays(7).tostartofweek();
        
        String mainettiCompany = 'Hong Kong - Mainetti (HK) Ltd';
        String retailerCode = 'GU';
        String model = 'GUSC-XS';
        String weekStart = String.valueOf(weekStartDate);
        String weekEnd = String.valueOf(weekEndDate);
        boolean isCurrentWeek =true ;
        Integer pageNumber = 1;
        Integer recordToDisplay = 10;
        Integer totalShipmentQty = 5;
        
        String mainettiCompany1 = '';
        String retailerCode1 = '';
        String weekStart1 = String.valueOf(weekStartDate);
        String weekEnd1 = '';
        boolean isCurrentWeek1 =false ;
            
        
        
         
        String weekStart2 = '';
        String weekEnd2 = String.valueOf(weekEndDate);
        boolean isCurrentWeek2 =false ;
            
       
        String mainettiCompany2 = 'Hong Kong - Mainetti (HK) Ltd';
        String retailerCode2 = 'GU';
        String weekStart3 = '';
        String weekEnd3 = '';
        boolean isCurrentWeek3 =false ;
            
        
        
        String mainettiCompany3 = '';
        String retailerCode3 = 'GU';
        String weekStart4 = '';
        String weekEnd4 = '';
        boolean isCurrentWeek4 =false ;
            
        
        String mainettiCompany4 = '';
        String retailerCode4 = '';
        String model4 = 'GUSC-XS';
        String weekStart5 = '';
        String weekEnd5 = '';
        boolean isCurrentWeek5 =false ;
            
        
       /* Weekly_Shipment_Summary__c weeklyShipmentSummary = new Weekly_Shipment_Summary__c();
        weeklyShipmentSummary.Mainetti_Company__c = 'Hong Kong - Mainetti (HK) Ltd';
         weeklyShipmentSummary.Color__c = 'GRAY';
        weeklyShipmentSummary.Quantity__c = 2000;
        weeklyShipmentSummary.Week_Start_Date__c = weekStartDate ;
        insert weeklyShipmentSummary;*/
        
        
        Test.startTest();
        WeeklyShipmentApx.fetchWeeklyShipmentBySearch(mainettiCompany, retailerCode, model, weekStart, weekEnd,isCurrentWeek, pageNumber , recordToDisplay,totalShipmentQty);
        WeeklyShipmentApx.fetchWeeklyShipmentBySearch(mainettiCompany1, retailerCode1, model, weekStart1, weekEnd1,isCurrentWeek1, pageNumber , recordToDisplay,totalShipmentQty);
        WeeklyShipmentApx.fetchWeeklyShipmentBySearch(mainettiCompany1, retailerCode1, model, weekStart2, weekEnd2,isCurrentWeek2, pageNumber , recordToDisplay,totalShipmentQty);
        WeeklyShipmentApx.fetchWeeklyShipmentBySearch(mainettiCompany2, retailerCode2, model, weekStart3, weekEnd3,isCurrentWeek3, pageNumber , recordToDisplay,totalShipmentQty);
        WeeklyShipmentApx.fetchWeeklyShipmentBySearch(mainettiCompany3, retailerCode3, model, weekStart4, weekEnd4,isCurrentWeek4, pageNumber , recordToDisplay,totalShipmentQty);
        WeeklyShipmentApx.fetchWeeklyShipmentBySearch(mainettiCompany4, retailerCode4, model4, weekStart5, weekEnd5,isCurrentWeek5, pageNumber , recordToDisplay,totalShipmentQty);
        Test.stopTest();
        
        
}
}