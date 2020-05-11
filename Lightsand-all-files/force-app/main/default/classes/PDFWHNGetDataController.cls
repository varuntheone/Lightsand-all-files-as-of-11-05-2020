public class PDFWHNGetDataController{
    public String manufacturerCode { get; set; }
    public List<ContentVersion> contentversionListModel {set;get;}
    public List<ContentVersion> contentversionListWoodBody {set;get;}
    public List<ContentVersion> contentversionListMetalHook {set;get;}
    public List<ContentVersion> contentversionListMetalClip {set;get;}
    public List<ContentVersion> contentversionListLacquer {set;get;}
    public List<ContentVersion> contentversionListAccessory {set;get;}
    public List<ContentVersion> contentversionListLogo {set;get;}
    public List<ContentVersion> contentversionListPacking {set;get;}
    public List<ContentVersion> contentversionList {set;get;}
    
    public List
<String> args = new String[]{'0','number','###,###,##0.00'};
    public Wooden_Hanger_Requisition_Form__c WHNForPDF{get; set;}
     public Date Today { get { return Date.today(); }}
    public String customerInternalPO{get;set;}
    
    public PDFWHNGetDataController(){
        System.debug('##Inside Constructor');
        String WHNId = ApexPages.currentPage().getparameters().get('id');
        System.debug('##WHNId:'+WHNId);

        try{
        if(!String.isEmpty(WHNId) && WHNId.length()>0){
                try{
                 WHNForPDF = [select Name,Sample_Number__c,Order_to_Company__c,Contact__c,Contact_Person__c,Generation_Date__c,Customer_Information__c,Country__c,Projection__c,Model__c,Remark_Model__c,Length__c,Width__c,Wood_Type__c,wood_spec__c,Wood_Body_Remark__c,Unit_Price__c,Utilization_rate__c,Produce__c,Hook__c,Metal_Plating__c,Metal_Clips_Remark__c,Metal_Remark__c,Production_Loss__c,Metal_Other__c,Clips__c,Clip_Type__c,Clips_Spec__c,Clips_Metal_Plating__c,Clip_Production_Loss__c,Collection__c,Lacquer_Remark__c,Process__c,Shininess__c,Notches__c,Anti_slip__c,Wood_Metal_Metal_Bar__c,Others_Remark__c,Logo__c,Loog__c,Logo_Remark__c,Logo_color__c,Logo_Others__c,Others_Spec__c,Mainetti_Stamp__c,Made_in_China__c,FSC__c,Mainetti_Stamp_Remark__c,Box_Qty__c,Remark_Packing__c,Carton_box_size__c,NW_GW_kg__c,Plastic_Bag__c,Remark_IC__c,Remark__c,Wood_factory_Remark__c     from Wooden_Hanger_Requisition_Form__c where Id=:WHNId];        
                
                 List<ContentDocumentLink> ContentDocumentLinkList =  [Select Id,contentDocumentId from ContentDocumentLink where LinkedEntityId = :WHNId];
        
                List<String> contentDocumentIdList = new   List<String> ();               
                for(ContentDocumentLink eachContentDocumentLink : ContentDocumentLinkList){
                    contentDocumentIdList.add(eachContentDocumentLink.contentDocumentId);
                }                
                 if(contentDocumentIdList!=null && contentDocumentIdList.size()>0){             
                                           contentversionListModel = [Select Id,ContentDocumentId,contentbodyId,FileType  from ContentVersion where ContentDocumentId IN :contentDocumentIdList AND description IN ('Model 型號')];  
                                           contentversionListWoodBody = [Select Id,ContentDocumentId,contentbodyId,FileType  from ContentVersion where ContentDocumentId IN :contentDocumentIdList AND description IN ('Wood Type 木身部份')];
                                           contentversionListMetalHook = [Select Id,ContentDocumentId,contentbodyId,FileType  from ContentVersion where ContentDocumentId IN :contentDocumentIdList AND description IN ('Metal Hook 五金鈎形')];                                                
                                           contentversionListMetalClip = [Select Id,ContentDocumentId,contentbodyId,FileType  from ContentVersion where ContentDocumentId IN :contentDocumentIdList AND description IN ('Metal Clip 五金夾片')];   
                                           contentversionListLacquer = [Select Id,ContentDocumentId,contentbodyId,FileType  from ContentVersion where ContentDocumentId IN :contentDocumentIdList AND description IN ('Lacquer 油漆部份')];   
                                           contentversionListAccessory = [Select Id,ContentDocumentId,contentbodyId,FileType  from ContentVersion where ContentDocumentId IN :contentDocumentIdList AND description IN ('Accessory 配件')];
                                           contentversionListLogo = [Select Id,ContentDocumentId,contentbodyId,FileType  from ContentVersion where ContentDocumentId IN :contentDocumentIdList AND description IN ('Logo 印字')];
                                           contentversionListPacking = [Select Id,ContentDocumentId,contentbodyId,FileType  from ContentVersion where ContentDocumentId IN :contentDocumentIdList AND description IN ('Packing 包裝')];   
                                            
                                           contentversionList = [Select Id,ContentDocumentId,contentbodyId,FileType  from ContentVersion where ContentDocumentId IN :contentDocumentIdList AND description IN ('Model 型號')];                                                   
                
                }
                
                
                }catch(System.Exception WHNForPDFQueryEx){
                System.debug('##WHNForPDFQuery:'+WHNForPDFQueryEx.getStackTraceString());              }
                }
                            }catch(System.Exception e){
                System.debug('##GlobalEx:'+e.getStackTraceString());
                //showRemarks = false;
            }
    }
                }