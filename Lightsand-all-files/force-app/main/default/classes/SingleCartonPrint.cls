public class SingleCartonPrint {

    private final Carton_Details__c carton;

    public SingleCartonPrint(ApexPages.StandardController stdController) {
        this.carton =[select Id,Status__c from Carton_Details__c where Id =: stdController.getId() ] ;

    }
    
    Public void updateCartonStatus(){
        
        if(carton.Id != null && carton.Status__c == 'New'){
            //carton.Status__c = 'Printed';
            carton.Status__c = 'Active';
            update carton;
        }
    
    }

}