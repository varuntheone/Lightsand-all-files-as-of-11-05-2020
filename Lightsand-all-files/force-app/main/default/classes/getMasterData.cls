public class getMasterData {
    public   map<string,string> getManitteCompanyMap()
    {
        //system.debug('Starting Point');
        list<Partner__c> partner = new list<Partner__c>();
        Map<string,string> mainettiCompanyMap = new Map<string,string>();        
        partner = [Select  Name, Default_Order_to_Company__c from Partner__c where Default_Order_to_Company__c != null and Partner_Status__c = 'Active' and  RecordType.Name in('Mainetti Company','Licensee Partner')]; 
        for ( Partner__c ptn : partner ){
            mainettiCompanyMap.put(ptn.Name.toLowerCase(),ptn.Default_Order_to_Company__c); 
        }             
        //system.debug('Ending Point');
        return mainettiCompanyMap;
    }
    public   map<string,string> getManitteCompanyPicklistMap()
    {
        //system.debug('Starting Point');
        list<Partner__c> partner = new list<Partner__c>();
        Map<string,string> mainettiCompanyMap = new Map<string,string>();        
        partner = [Select  Name, Default_Order_to_Company__c from Partner__c where Default_Order_to_Company__c != null and Partner_Status__c = 'Active' and  RecordType.Name in('Mainetti Company','Licensee Partner') order by Name]; 
        for ( Partner__c ptn : partner ){
            mainettiCompanyMap.put(ptn.Name,ptn.Default_Order_to_Company__c);            
        }             
        //system.debug('Ending Point');
        return mainettiCompanyMap;
    }
    
    public   map<string,string> getManitteOrgCompanyMap()
    {        
        map<string,string> manitteOrgMap = new map<string,string>();
        list<Partner__c> partner = [Select  Name, 	Default_Order_to_Company__c from Partner__c where Default_Order_to_Company__c != null and Partner_Status__c = 'Active' and  RecordType.Name in('Mainetti Company','Licensee Partner')]; 
        if(partner.size()>0){
            for ( Partner__c ptn : partner ) {
                manitteOrgMap.put(ptn.Default_Order_to_Company__c,ptn.Name.toLowerCase());
            }
        }
        //system.debug('Ending Point');
        return manitteOrgMap;
    }
    public   map<string,Id> getManitteCompanyIdMap()
    {
        // system.debug('Starting Point');
        list<Partner__c> partner = new list<Partner__c>();
        map<string,Id> manitteMap = new map<string,Id>();
        partner = [Select Id, Name  from Partner__c where Default_Order_to_Company__c != null and Partner_Status__c = 'Active' and  RecordType.Name in('Mainetti Company','Licensee Partner')]; 
        
        for ( Partner__c ptn : partner ) {
            manitteMap.put(ptn.Name.toLowerCase(),ptn.Id);
        }
        //system.debug('Ending Point');
        return manitteMap;
    }
    public  map<string,string> getRetailerCodeMap()
    {
        //system.debug('Starting Point');        
        Map<string,string> retailerCodeMap = new Map<string,string>();        
        list<Retailer_Code__c> retailerCode = [Select Name from Retailer_Code__c];        
        for ( Retailer_Code__c retail : retailerCode ){
            retailerCodeMap.put(retail.Name.toLowerCase(),retail.Name.toLowerCase());
        }
        // system.debug('Ending Point');
        return retailerCodeMap;
    }
    public  map<string,Id> getRetailerCodeIdMap()
    {
        //system.debug('Starting Point');
        list<Retailer_Code__c> retailerCode = new list<Retailer_Code__c>();
        Map<string,Id> retailerCodeMap = new Map<string,Id>();        
        retailerCode = [Select Id, Name from Retailer_Code__c];        
        for ( Retailer_Code__c retail : retailerCode ){
            retailerCodeMap.put(retail.Name.toLowerCase(),retail.Id);
        }
        //system.debug('Ending Point getRetailerCodeIdMap');
        return retailerCodeMap; 
    }
    
    /* public   Map<string,string> getListOfTransManitteCompany(String BatchId){
List<Inventory_Transaction_Stage__c> mainettiCompany = [SELECT Mainetti_Company__c FROM Inventory_Transaction_Stage__c  Where Upload_Batch_No__c=:BatchId ];
Map<string,string> mainCompMap = getManitteCompanyMap();
Map<string,string> invTransOrderToCompMap = new Map<string,string>();
Map<string,string> invTransStagManitte = new Map<string,string>();
if(mainettiCompany.size()>0)
{
for ( Inventory_Transaction_Stage__c maniComp : mainettiCompany ){
if(!String.isBlank(maniComp.Mainetti_Company__c)){
invTransStagManitte.put(maniComp.Mainetti_Company__c.toLowerCase(),maniComp.Mainetti_Company__c.toLowerCase());
}
}            
for(String manitteVal : invTransStagManitte.keyset()){
invTransOrderToCompMap.put(mainCompMap.get(manitteVal),mainCompMap.get(manitteVal));
}
}
return invTransOrderToCompMap;
}*/
    
    public  Map<string,Map<string,string>> getRTSModelMap(Inventory_Transaction_Master__c updateBatchStatus)
    {
        Map<string,Map<string,string>> modelPriceMap = new Map<string,Map<string,string>>();
        Map<string,string> mainCompMap = getManitteCompanyMap();
        Map<string,string> rtsModelMap = new Map<string,string>();
        Map<string,string> rtsPriceMap = new Map<string,string>();
        list<Price_Specification_Book_Product__c> priceBookSpecProd = new list<Price_Specification_Book_Product__c>();
        String orderToCompany = mainCompMap.get(updateBatchStatus.Mainetti_Company__c.toLowerCase());
        System.Debug('getRTSModelMap::::updateBatchStatus.Mainetti_Company__c:::::'+updateBatchStatus.Mainetti_Company__c);
        System.Debug('getRTSModelMap::::orderToCompany:::::'+orderToCompany);
        priceBookSpecProd = [Select Name,Retailer_Code__r.Name,Color__c,Sizer_Print__c,Order_to_Company__c from Price_Specification_Book_Product__c where Order_to_Company__c =: orderToCompany  and Active__c=true and Retailer_Code__r.Name <> null];
        string manittieOrgCompany = updateBatchStatus.Mainetti_Company__c.toLowerCase();
        for (Price_Specification_Book_Product__c priceBook : priceBookSpecProd){
            rtsModelMap.put(priceBook.Name.toLowerCase(),priceBook.Name.toLowerCase());
            /*String manittieOrgCompany = null;
            for(string objVar : mainCompMap.keySet()){
                if(mainCompMap.get(objVar).equals(priceBook.Order_to_Company__c)){
                    manittieOrgCompany =objVar;
                    break;
                }                
            }*/
            
            string pricbookspec = '';
            if(priceBook.Retailer_Code__r.Name.equalsIgnoreCase('LOJAS RENNER')){
                pricbookspec =  priceBook.Name+'#'+priceBook.Retailer_Code__r.Name+'#'+manittieOrgCompany+'#'+priceBook.Color__c+'#'+priceBook.Sizer_Print__c;
            }else{
                pricbookspec =  priceBook.Name+'#'+priceBook.Retailer_Code__r.Name+'#'+manittieOrgCompany+'#'+priceBook.Color__c;
            }            
            //System.Debug('getRTSModelMap::::pricbookspec:::::'+pricbookspec.toLowerCase());
            rtsPriceMap.put(pricbookspec.toLowerCase(), priceBook.Id);              
        }               	
        // system.debug('Ending Point');
        modelPriceMap.put('Model',rtsModelMap);
        modelPriceMap.put('Price',rtsPriceMap);
        return modelPriceMap;
    } 
    public  Map<string,string> getSizePrintMap(Inventory_Transaction_Master__c updateBatchStatus)
    {
        Map<string,string> sizePrintMap = new Map<string,string>();
        Map<string,string> mainCompMap = getManitteCompanyMap();
        list<Price_Specification_Book_Product__c> priceBookSpecProd = new list<Price_Specification_Book_Product__c>();      
        // System.Debug('getSizePrintMap::::orderToCompany:::::'+orderToCompany);        
        priceBookSpecProd = [Select Sizer_Print__c from Price_Specification_Book_Product__c where Order_to_Company__c =: mainCompMap.get(updateBatchStatus.Mainetti_Company__c.toLowerCase()) and Active__c=true];
        system.debug('priceBookSpecProd:::::::'+priceBookSpecProd);
        if(priceBookSpecProd.size() > 0)
        {
            for (Price_Specification_Book_Product__c priceBook : priceBookSpecProd) {
                if(String.isNotBlank(priceBook.Sizer_Print__c)){
                    sizePrintMap.put(priceBook.Sizer_Print__c.toLowerCase(),priceBook.Sizer_Print__c.toLowerCase());     
                }  
            }
        }    
        system.debug('sizePrintMap:'+sizePrintMap);
        return sizePrintMap;
    }
    public  Map<string,string> getPickListColorMap(Inventory_Transaction_Master__c updateBatchStatus){
        Map<string,string> pickListValMap = new Map<string,string>();
        Map<string,string> mainCompMap = getManitteCompanyMap();
        list<Price_Specification_Book_Product__c> priceBookSpecProd = new list<Price_Specification_Book_Product__c>();      
        System.Debug('getSizePrintMap::::mainettiCompany:::::'+updateBatchStatus.Mainetti_Company__c);        
        priceBookSpecProd = [Select Color__c from Price_Specification_Book_Product__c where Order_to_Company__c =: mainCompMap.get(updateBatchStatus.Mainetti_Company__c.toLowerCase()) and Active__c=true];
        system.debug('priceBookSpecProd:::::::'+priceBookSpecProd);
        if(priceBookSpecProd.size() > 0)
        {
            for (Price_Specification_Book_Product__c priceBook : priceBookSpecProd) {
                if(String.isNotBlank(priceBook.Color__c)){
                    pickListValMap.put(priceBook.Color__c.toLowerCase(),priceBook.Color__c.toLowerCase());     
                }  
            }
        }         
        return pickListValMap;
    } 
    public  Map<string,string> getPickListMap(String ObjectName,String fieldName){
        Map<string,string> pickListValMap = new Map<string,string>();
        Schema.SObjectType tarType = Schema.getGlobalDescribe().get(ObjectName); 
        Sobject Object_name = tarType.newSObject();                 
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); 
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); 
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();        
        List<Schema.PicklistEntry> pick_list_values = field_map.get(fieldName).getDescribe().getPickListValues();        
        for (Schema.PicklistEntry a : pick_list_values) { 
            String colorPicklist = a.getValue();
            //system.debug('colorPicklist.toLowerCase()'+colorPicklist.toLowerCase());
            pickListValMap.put(colorPicklist.toLowerCase(),colorPicklist.toLowerCase());
        }        
        return pickListValMap;
    }
    public List<Inventory_Transaction_Stage__c> getInventoryStagRows(String BatchId){
        List<Inventory_Transaction_Stage__c> invTransStagRec = new List<Inventory_Transaction_Stage__c>();
        if(!String.isBlank(BatchId)){
            invTransStagRec = [Select Row_No__c,Color__c,Color_NF__c,Inventory_Model__c,Inventory_Model_NF__c,Name,Local_System_SKU__c,Mainetti_Company__c,MC_NF__c,Price_Book_Spec_NF__c,Record_Status__c,Remarks__c,Retailer_Code__c,Retailer_Code_NF__c,Sizer_Print__c,Sizer_Print_NF__c,Source__c,Stock_In_Date__c,Stock_In_Qty__c,Upload_Batch_No__c,Warehouse__c,Warehouse_NF__c from Inventory_Transaction_Stage__c where Upload_Batch_No__c=:BatchId];
        }
        return invTransStagRec;  
    }
    /* Reterieveing the file from  the contentverion for upload into Azure */ 
    public  ContentVersion getCSVFile(String batchId){
        ContentVersion contVer = new ContentVersion();
        ContentDocumentLink[] contentLink = [SELECT ContentDocumentId from ContentDocumentLink where LinkedEntityId=:batchId LIMIT 1];
        System.debug('contentLink:'+contentLink);
        if(contentLink.size()>0){
            contVer = [SELECT Title, VersionData, PathOnClient, FileType FROM ContentVersion WHERE ContentDocumentId = :contentLink[0].ContentDocumentId
                       AND IsLatest = true];            
        } 
         System.debug('contVer:::::'+contVer);
        return contVer;        
    }
    /*Deleting the csv file from the content version once the file has been uploaded into Azure*/
    public boolean deleteCSVFile(String batchId){
        boolean delStatus = true;       
        try{
            
            list<ContentDocument> contentList = new list<ContentDocument>();
            //ContentDocumentLink[] contentLink = [SELECT ContentDocumentId from ContentDocumentLink where LinkedEntityId=:batchId];
            ContentDocument[] content = [Select Id, Title, FileExtension, CreatedDate From ContentDocument USING SCOPE Everything];
             System.debug('###########content SIZE'+content.size()); 
            Date Today = system.Today();
            for ( ContentDocument cont : content ){ 
                 Datetime recCreateDt = cont.CreatedDate;
                Date StartDateParsed = date.newinstance(recCreateDt.year(), recCreateDt.month(), recCreateDt.day());                
                if(cont.Title == 'Inventory Data File Uplaod'){
                    System.debug('###########StartDateParsed'+StartDateParsed+'::::Today'+Today); 
                    if(StartDateParsed < Today){ 
                        System.debug('########Inside True'); 
                        contentList.add(cont);
                      }
                  }                   
              }
             System.debug('###########content LIST SIZE'+contentList.size());              
            if(contentList.size()>0){
                delete contentList;
            }
        }catch(DMLException ex){
            delStatus = false;
            System.debug('Error during deleteCSVFile'+EX.getMessage());          
        }       
        return delStatus;        
    }
   
    /*** Creating an temporary storage of the csv file before it is moved into Azure*/
    public boolean createDocument(String batchId,String csvJason,String fileName){
        boolean insertStatus = true;
        try{            
            ContentVersion invenotryFile = new ContentVersion();
            invenotryFile.ContentLocation = 'S';
            invenotryFile.VersionData = Blob.valueOf(csvJason);
            invenotryFile.Title = 'Inventory Data File Uplaod';
            invenotryFile.PathOnClient = fileName;            
            insert invenotryFile;            
            ContentVersion inventoryVerContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :invenotryFile.Id];            
            ContentDocumentLink contentlink=new ContentDocumentLink();
            contentlink.LinkedEntityId=batchid;
            contentlink.ShareType= 'V';
            contentlink.ContentDocumentId=inventoryVerContent.ContentDocumentId;            
            insert contentlink;           
        }catch(DMLException ex){
            insertStatus = false;
            System.debug('CONTENT NOT ABLE TO CREATE'+EX.getMessage());
        }   
        return insertStatus;
    }
    
}