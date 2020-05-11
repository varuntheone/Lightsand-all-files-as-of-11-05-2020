public class DateUtils{

     /*Utility Method - Returns the Formated Date - START*/
    public static String getFormattedDate(Date dateValue){
            Datetime tempDateValue = null;
            String formattedDate = '';
            if(dateValue!=null){
                tempDateValue = Datetime.newInstance(dateValue.year(), dateValue.month(), dateValue.day());
                System.debug('Non Formatted Date--->'+dateValue);
                formattedDate = tempDateValue.format('yyyy-MM-dd');
                System.debug('Formatted Date--->'+tempDateValue);
            }
            return formattedDate;
    }
     /*Utility Method - Returns the Formated Date - END*/
}