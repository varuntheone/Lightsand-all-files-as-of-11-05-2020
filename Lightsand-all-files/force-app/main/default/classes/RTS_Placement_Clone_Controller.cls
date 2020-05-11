public class RTS_Placement_Clone_Controller{

    //instance variable for the standard controller
    public ApexPages.StandardController controller {get; set;}
    
    //instance for the variables being passed by id on the url
    public RTS_Placement__c order {get;set;}
    
    //set the id of the record that is created 
    public ID newRecordId {get;set;}
    public string selects;
    // initialize the controller
    public RTS_Placement_Clone_Controller(ApexPages.StandardController controller){
        //initialize the standard controller
        this.controller = controller;      
        // load the current record
        order = (RTS_Placement__c)controller.getRecord();
    }
    

    
    // method called from the VF's action attribute to clone the order
    public PageReference cloneWithItems(){
        //setup the save point for rollback
        Savepoint sp = Database.setSavepoint();
        RTS_Placement__c newOrder;
        try {
            //copy the order - ONLY INCLUDE THE FIELDS YOU WANT TO CLONE
            String queryMaster = 'SELECT ';
            
            //Get all api names of RTS_Placement__c fields
            Schema.DescribeSObjectResult objDescribeResPlacement = RTS_Placement__c.sObjectType.getDescribe();

            for(string apiName : objDescribeResPlacement.fields.getMap().keySet()){
                queryMaster += apiName + ',';//form query
            }
            queryMaster = queryMaster.removeEnd(',');
            String orderId = order.id;
            queryMaster += ' FROM RTS_Placement__c where Id =: orderId';
            System.debug(queryMaster);
            
            
            
            List<RTS_Placement__c > orderList = new List<RTS_Placement__c >();
            RTS_Placement__c order = Database.query(queryMaster);
            RTS_Placement__c clonedOrder = order.clone(false, true);
            // clonedOrder.Placement_Status__c = 'Open Order';
            clonedOrder.Placement_Date__c = System.today();
            clonedOrder.Expected_Ship_Date__c = NULL;
            clonedOrder.Sys_Requested_for_Approval__c = false;
            clonedOrder.Sys_Cancelled__c = false;     
            string Id = [SELECT id from RecordType where Name ='Replacement Order'].Id;
            
            clonedOrder.RecordTypeId = Id;
            
            clonedOrder.Original_Placement_Order__c = order.Id;
            insert clonedOrder ;
            // set the id of the new po created for testing
            newRecordId = clonedOrder.id;
            //Form query for RTS_Placement_Detail__c
            String queryDetail = 'SELECT ';
            Schema.DescribeSObjectResult sObjectRes = RTS_Placement_Detail__c.sObjectType.getDescribe();

            for(string apiName : sObjectRes.fields.getMap().keySet()){
                queryDetail += apiName + ',';//form query
            }
            queryDetail = queryDetail.removeEnd(',');
            
            queryDetail += ' FROM RTS_Placement_Detail__c where RTS_Placement__c =: orderId';
            System.debug(queryDetail);
            
            
            
            // copy over the line items - ONLY INCLUDE THE FIELDS YOU WANT TO CLONE
            List<RTS_Placement_Detail__c> items = new List<RTS_Placement_Detail__c>();
                for (RTS_Placement_Detail__c pi : Database.query(queryDetail)) {
                    RTS_Placement_Detail__c newPI = pi.clone(false,true);
                    newPI.RTS_Placement__c = clonedOrder.id;
                    newPI.Expected_Ship_Date__c = NULL;
                    newPI.Order_Line_Status__c = System.Label.RTS_Open;
                    newPI.Order_Line_Sub_Status__c = NULL;
                    system.debug('=========newPI ==='+newPI );
                    items.add(newPI);
                }
                system.debug('=========ITEMS==='+items);
                insert items;
 
        }
        catch (Exception e){
            // roll everything back in case of error
            Database.rollback(sp);
            ApexPages.addMessages(e);
            return null;
        }

        return new PageReference('/'+newRecordId+'?retURL=%2F'+newRecordId);
    }

}