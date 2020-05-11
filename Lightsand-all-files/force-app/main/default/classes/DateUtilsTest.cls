@IsTest public class DateUtilsTest{
    
    @IsTest(SeeAllData=true) public static void testDateUtilsTest(){
        Online_Enquiry__c enq = new Online_Enquiry__c(Enquiry_Date__c=Date.today());
        System.debug(DateUtils.getFormattedDate(enq.Enquiry_Date__c));
    }

}