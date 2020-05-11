public class OnlineEnquiryPdfGenerator {

    @InvocableMethod(label='On Line Enquiry PDF Generator' description='On Line Enquiry PDF Generator')
    public static void OnLineEnquiryOrderProcessAndPdfGenerator (List<string> inputParams) {
       
       	System.debug('Starting online enquiry process...'+inputParams);
        List<String> pdfList=OnLineEnquiryOrderProcess.OnLineEnquiryOrderProcess(inputParams);
        if(pdfList!=null && pdfList.size()>0){
            System.debug('Generating PDF generation for online enquiry ID: ');
            for(String pdfId:pdfList){
                System.debug('Before Calling PDF generation for online enquiry ID: '+pdfId);
                Utility.getEnquiryPdfContent(pdfId); 
                System.debug('After Calling PDF generation for online enquiry ID: '+pdfId);
            }
            System.debug('END PDF generation for online enquiry ');
                       
        }
        
        System.debug('Starting online enquiry process END');
        
    }
}