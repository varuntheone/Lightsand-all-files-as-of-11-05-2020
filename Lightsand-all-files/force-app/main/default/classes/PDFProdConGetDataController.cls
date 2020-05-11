public class PDFProdConGetDataController{
    public String manufacturerCode { get; set; }
    public List<Document> urlpolybag1 {set;get;}
    public List<Document> urlpolybag2 {set;get;}
    public List<Document> urlpolybag3 {set;get;}
    public List<Document> urlpolybag4 {set;get;}
    public List<Document> urlhandle1 {set;get;}
    public List<Document> urlhandle2 {set;get;}
    public List<Document> urlhandle3 {set;get;}
    public List<Document> twopiecebox {set;get;}
    public List<Document> flodingbox {set;get;}
    public List<Document> shouldertypebox {set;get;}
    public List<Document> Matchboxtype {set;get;}
    public List<Document> Collapsiblebox {set;get;}
    
    public List
    <String> args = new String[]{'0','number','###,###,##0.00'};
    public Product_Configurator__c ProdConForPDF {get; set;}
    public Opportunity_Item_Master__c OpportunityItem {get; set;}
     public Date Today { get { return Date.today(); }}
    public String customerInternalPO{get;set;}
    

    
    public PDFProdConGetDataController(){
        System.debug('##Inside Constructor');
        String ProdConId = ApexPages.currentPage().getparameters().get('id');
        System.debug('##ProdConId:'+ProdConId);

        try{
        if(!String.isEmpty(ProdConId) && ProdConId.length()>0){
                try{
                 ProdConForPDF  = [Select OwnerId,Bottom_Gusset_mm__c,Side_Gusset_mm__c,Length_mm__c,Name,Flap__c,RecordTypeId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, LastViewedDate, LastReferencedDate, Overall_Dimension_cm__c, Finished_Dimension_cm__c, Variable_Data_s__c, Sample_Quantity__c, Quotation__c, Artwork__c, Sample__c, Production__c, Front_num_of_Color__c, Front_Pantone__c, Front_CMYK__c, Exterior_Numof_Colors__c, Eyelet_Knot_to_Hole_Length_mm__c, Front_Material__c, Customer_Information__c, Clips_Metallic__c, Back_Pantone__c, Back_CMYK__c, Back_Coating__c, Back_Finishing__c, Front_Finishing_Others__c, Back_Finishing_Others__c, Back_Material__c, Back_Weight__c, PFL_Security__c, Security_Special_Function_Others__c, Clips_Plastic_mm__c, Accessories_Eyelet_Color__c, Accessories_Eyelet_OthersAccessories__c, Accessories_String_Length_mm__c, Bottom_Paper_Weight__c, Accessories_String_Color__c, Accessories_String_Material__c, Accessories_String_Others__c, Accessories_Others__c, Packing_Requirement__c, Remark__c,    Production_Quantity__c, Ref_Sample__c, Color_Standard__c, Wash_Test_Method_if_any__c, Customer_Name__c, Washing_Temp_degree_celsius__c, Dry_Method__c, Customer_Requirement_Others__c, Washing_Requirement_Others__c, Material_Type__c, Material_Color__c, Front_Spot__c, Back_Spot__c, Accessories_Knot_to_Hole_Length_mm__c, Folding_Type_Others__c, Woven_Special_Finishing_Process__c, Special_Finishing_Process_Others__c, Created_Date__c, Exterior_Weight__c, Spot_Color__c, PFL_Special_Finishing_Process__c, Woven_Folding_Type__c, Weaving_Quality_Others__c, Yarn_Type__c, Trims_Product_Type__c, Yarn_Type_Others__c, Front_Weight__c, Interior_of_Colors__c, Print_Size_High_cm__c, Garment_Bag_Type__c, Garment_Bag_Bottom__c, Paper_Product_Type__c, Front_Finishing__c, Front_Coating__c, Interior_Coating__c, Exterior_Coating__c, Interior_Finishing__c, Exterior_Finishing__c, Metal_Eyelet_Size_mm__c, Interior_Coating_Others__c, Exterior_Pantone__c, Interior_Pantone__c, Interior_CMYK__c, Exterior_CMYK__c, Material__c, No_of_Cycle__c, Interior_Material__c, Exterior_Material__c, FoldingType__c, Loom_Type__c, Weaving_Quality__c, Top_Pantone__c, Top_CMYK__c, Top_Paper_Material__c, Loom_Others__c, Gusset_cm__c, Bottom_Pantone__c, Bottom_CMYK__c, Bottom_Paper_Material__c, Woven_Security_Special_Function__c, Handle_Material__c, Handle_Color__c, Header__c, Handle_Attached_Method__c, Finishing_Others__c, Finishing_Size__c, Two_Piece_Box_Image__c, Two_Piece_Box__c, Folding_Box_with_Magnet_Closure__c, Shoulder_Type_Box__c, Matchbox_Type__c, Collapsible_Box__c, Others_Box_Type__c, Folding_Box_with_Magnet_Closure_Image__c, Shoulder_Type_Box_Image__c, Matchbox_Type_Image__c, Collapsible_Box_Image__c, Structure__c, Outer_Dimension_cm__c, Grip_Lock__c, Bottom_Size_cm__c, Magnet_pcs__c, Ribbon_pcs__c, Divider_pcs__c, Garmentbag_Shape1_Image__c, GarmentBag_Shape2_Image__c, Garmentbag_Shape3_Image__c, Garmentbag_Shape4_Image__c, Garmentbag_Shape1__c, GarmentBag_Shape2__c, Garmentbag_Shape3__c, Garmentbag_Shape4__c, Handles_No_Handle_image__c, Handle_Stiched_on_the_Edge_Image__c, Handles_Stiched_Over_Strip_Image__c, Handles_No_Handle__c, Handle_Stiched_on_the_Edge__c, Handle_Stiched_Over_Strip__c, Handles_Material__c, PVC_mm__c, PVC_Color__c, PVC_Others__c, PEVA_mm__c, PEVA_color__c, PEVA_others__c, Cotton__c, Polyester__c, Polyester_Color__c, PP_Non_Woven__c, Polyester_Others__c, PP_Non_Woven_Color__c, PP_Non_Woven_Others__c, Cotton_Color__c, Cotton_Others__c, Edges__c, Edges_Color__c, Print_Size_Width_cm__c, Dimension_Tolerances__c, Print_Color_Pantone1__c, Print_Color_Pantone2__c, Print_Color_Pantone3__c, Print_Sides__c, Print_Type__c, Slant_Straight_Bottom_Seal__c, Zip_Color__c, Aperture_Hook__c, Film__c, Clips_Metallic_Color__c, Clips_Plastic_Color__c, Metallic_Corners__c, Metallic_Corners_Color__c, Micron__c, Metal_Eyelet_Color__c, Print_Method__c, PVC_Window_mm__c, PVC_Pocket_mm__c, Zip_all_around__c, Num_of_Color__c, Back_numof_Color__c, Accessories_Eyelet_Diameter_mm__c, Bottom_of_Color__c, Height_cm__c, Zip_Size__c, Width_cm__c, Weight__c, Top_Paper_Weight__c, Handle_Length__c, Interior_Weight__c, Lid_Size_cm__c, Pocket_with_Zip_mm__c, Top_of_Color__c, Inner_Dimension_cm__c, Substrate_Tolerances__c, Product_Reference__c, Ex_Factory_Price_50k_pcs__c, Ex_Factory_Price_100k_pcs__c, Description__c FROM Product_Configurator__c  where Id=:ProdConId];        
                 OpportunityItem= [Select Name,Visual__c from Opportunity_Item_Master__c where Product_Configurator__c = : ProdConId LIMIT 1];

                
                urlpolybag1 = [Select Id from Document where NAME like'%PolyBag Shape 1%' ORDER by CREATEDDATE LIMIT 1]; 
                urlpolybag2 = [Select Id from Document where NAME like'%PolyBag Shape 2%' ORDER by CREATEDDATE LIMIT 1]; 
                urlpolybag3 = [Select Id from Document where NAME like'%PolyBag Shape 3%' ORDER by CREATEDDATE LIMIT 1]; 
                urlpolybag4 = [Select Id from Document where NAME like'%PolyBag Shape 4%' ORDER by CREATEDDATE LIMIT 1]; 
                urlhandle1 = [Select Id from Document where NAME like'%Polybag Handle 1%' ORDER by CREATEDDATE LIMIT 1]; 
                urlhandle2 = [Select Id from Document where NAME like'%Polybag Handle 2%' ORDER by CREATEDDATE LIMIT 1]; 
                urlhandle3 = [Select Id from Document where NAME like'%Polybag Handle 3%' ORDER by CREATEDDATE LIMIT 1]; 
                //
                twopiecebox = [Select Id from Document where NAME like'%Two Piece Box%' ORDER by CREATEDDATE LIMIT 1]; 
                flodingbox = [Select Id from Document where NAME like'%Folding Box with Magnet Closure%' ORDER by CREATEDDATE LIMIT 1]; 
                shouldertypebox = [Select Id from Document where NAME like'%Shoulder Type Box%' ORDER by CREATEDDATE LIMIT 1]; 
                Matchboxtype = [Select Id from Document where NAME like'%Matchbox Type%' ORDER by CREATEDDATE LIMIT 1]; 
                Collapsiblebox = [Select Id from Document where NAME like'%Collapsible Box%' ORDER by CREATEDDATE LIMIT 1]; 
                }catch(System.Exception ProdConForPDFQueryEx){
                System.debug('##ProdConForPDF Query:'+ProdConForPDFQueryEx.getStackTraceString()); 
                             }
                }
                            }catch(System.Exception e){
                System.debug('##GlobalEx:'+e.getStackTraceString());
                //showRemarks = false;
            }
    }
}