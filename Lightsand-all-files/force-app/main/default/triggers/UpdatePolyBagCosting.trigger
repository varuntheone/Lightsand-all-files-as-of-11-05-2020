trigger UpdatePolyBagCosting on Polybag_Costing__c (before update, before insert) {
    for (Polybag_Costing__c PC: Trigger.new)
    {
        // Master Book
                PC.Sys_Check_by_Admin_Used__c=TRUE;
        List<Product_Costing_Book__c> Book = [SELECT Id,Extrusion_Scrap_Rate__c,Distribution_Multiplier__c,Full_Cost_of_New_Machines__c,Ink_to_Material_Cost__c
                                              ,Printing_Scrap_Rate__c,SG_A_Multiplier_on_Ind_Cost__c,Cost_of_New_Machines_per_year__c,Bag_Cutting_Scrap_Rate__c
                                              FROM Product_Costing_Book__c WHERE Mainetti_Company1__c=:PC.Mainetti_Company__c and Book_Status__c='Active']; 
        for(Product_Costing_Book__c P: Book)
        {
            PC.Extrusion_Scrap_Rate__c = P.Extrusion_Scrap_Rate__c;
            PC.Distribution_Multiplier__c = P.Distribution_Multiplier__c;
            PC.Bag_Cutting_Scrap_Rate__c = P.Bag_Cutting_Scrap_Rate__c;
            PC.Printing_Scrap_Rate__c = P.Printing_Scrap_Rate__c;
            PC.SG_A_Multiplier_on_Ind_Cost__c = P.SG_A_Multiplier_on_Ind_Cost__c;
            PC.Full_Cost_of_New_Machines_RMB__c = P.Full_Cost_of_New_Machines__c;
            PC.Cost_of_New_Machines_per_year_RMB__c = P.Cost_of_New_Machines_per_year__c;
   
        } 
        //Actual Length
        PC.temp_Actual_Length__c = PC.temp_Length_of_Plastic_Printing_Mould__c/ PC.Number_of_logo_on_1_Printing_Plate__c ;
        //masterbatch Cost
        List<Product_Costing__c> MasterMiddleC = [SELECT Id,Purchase_Price__c
                                                FROM Product_Costing__c WHERE Id =: PC.Middle_Film_Masterbatch__c]   ; 
        for(Product_Costing__c P: MasterMiddleC)
        {
           PC.Inner_Masterbatch_Cost__c=P.Purchase_Price__c;
            
        }
        List<Product_Costing__c> MasterInnerC = [SELECT Id,Purchase_Price__c
                                                FROM Product_Costing__c WHERE Id =: PC.Inner_Film_Masterbatch__c]   ; 
        for(Product_Costing__c P: MasterInnerC)
        {
           PC.Inner_Masterbatch_Cost__c=P.Purchase_Price__c;
            
        }
        
        //Resin Cost

        List<Product_Costing__c> ResinC = [SELECT Id,Resin_Cost_KG__c,Purchase_Price__c,Weight_ratio_kg_1000_sq_cm_x_mm__c
                                                FROM Product_Costing__c WHERE Id =: PC.Film_Type_and_Thickness__c]   ; 
        for(Product_Costing__c P: ResinC)
        {
            PC.Temp_Resin_Cost__c = P.Resin_Cost_KG__c;
          PC.Outer_Weight__c=P.Weight_ratio_kg_1000_sq_cm_x_mm__c;
            
        }
        List<Product_Costing__c> ResinC1 = [SELECT Id,Resin_Cost_KG__c,Purchase_Price__c,Weight_ratio_kg_1000_sq_cm_x_mm__c
                                                FROM Product_Costing__c WHERE Id =: PC.Middle_Film_Type__c]   ; 
        for(Product_Costing__c P: ResinC1)
        {
            PC.Temp_Resin_Cost1__c = P.Resin_Cost_KG__c;
            PC.Middle_Masterbatch_Cost__c=P.Purchase_Price__c;
            PC.Middle_Weight__c=P.Weight_ratio_kg_1000_sq_cm_x_mm__c;
            
        }
        List<Product_Costing__c> ResinC2 = [SELECT Id,Resin_Cost_KG__c,Purchase_Price__c,Weight_ratio_kg_1000_sq_cm_x_mm__c
                                                FROM Product_Costing__c WHERE Id =: PC.Inner_Film_Type__c]   ; 
        for(Product_Costing__c P: ResinC2)
        {
            PC.Temp_Resin_Cost2__c = P.Resin_Cost_KG__c;
            PC.Inner_Weight__c=P.Weight_ratio_kg_1000_sq_cm_x_mm__c;
                     
        }
        if(PC.of_Outer_Film_Thickness__c !=0 && PC.of_Middle_Film_Thickness__c!=0 && PC.of_Inner_Film_Thickness__c !=0)
            {
			PC.temp_weight_ratio__c= PC.Outer_Weight__c* PC.of_Outer_Film_Thickness__c/100 + PC.Middle_Weight__c * PC.of_Middle_Film_Thickness__c/100 + PC.of_Inner_Film_Thickness__c /100* PC.Inner_Weight__c;
                }
        else if(PC.of_Outer_Film_Thickness__c !=0 && PC.of_Middle_Film_Thickness__c!=0 )
            {
                PC.temp_weight_ratio__c=  PC.Outer_Weight__c* PC.of_Outer_Film_Thickness__c/100 +PC.Middle_Weight__c * PC.of_Middle_Film_Thickness__c/100;
                }
        else if(PC.of_Outer_Film_Thickness__c != 0)
            {
                 PC.temp_weight_ratio__c= PC.Outer_Weight__c* PC.of_Outer_Film_Thickness__c/100;
                }
        else
        {
            PC.temp_weight_ratio__c=0;
        }
        
         //Weight_per_1000_bags
       PC.temp_Weight_per_1000_bags__c=PC.Actual_Length_for_Printing1__c*PC.temp_weight_ratio__c*PC.Actual_Width_for_Extrusion__c*  PC.Total_Thickness_mm__c;
        //Final_Length_of_Printing__c  Actual_Length_for_Printing1__c
        //PC.Actual_Length__c*  PC.Total_Thickness_mm__c;
       //PC.Weight_ratio_kg_1000_sq_cm_x_mm__c
        
            
         //Masterbach - Extrustion
        If(PC.Masterbatch_Cost_1000_bags__c != 0)
        {
            List<Product_Costing__c> ProdC = [SELECT Id,Labour_Cost_Printing_Set_Up__c,Material_Loss__c
                                              FROM Product_Costing__c WHERE MasterBactch__c = 'With' and Mainetti_Company__c=:PC.Mainetti_Company__c and Active__c=TRUE]; 
            for(Product_Costing__c P: ProdC)
            {
                PC.temp_Extrusion_Labor__c = P.Labour_Cost_Printing_Set_Up__c;
                PC.Temp_Extrusion_Material__c = P.Material_Loss__c*PC.Resin_Purchase_Price_KG__c;
                
            }
        }
        else
        {
            List<Product_Costing__c> ProdC = [SELECT Id,Labour_Cost_Printing_Set_Up__c,Material_Loss__c
                                              FROM Product_Costing__c WHERE MasterBactch__c = 'Without' and Mainetti_Company__c=:PC.Mainetti_Company__c and Active__c=TRUE]; 
            for(Product_Costing__c P: ProdC)
            {
                PC.temp_Extrusion_Labor__c = P.Labour_Cost_Printing_Set_Up__c;
                PC.Temp_Extrusion_Material__c = P.Material_Loss__c*PC.Resin_Purchase_Price_KG__c;
                
            } 
        }
        //Cutting Labour Cost
        List<Product_Costing__c> CLabourPrinting = [SELECT Id, Labor_Cost_per_1000_Pcs__c
                                                    FROM Product_Costing__c WHERE Cutting_Machine_Type__c = :PC.Cutting_Machine_Type__c AND Lower_Limit__c <=:PC.Final_Length_of_Printing__c AND Upper_Limit__c >: PC.Final_Length_of_Printing__c and Mainetti_Company__c=:PC.Mainetti_Company__c and Active__c=TRUE]; 
        for(Product_Costing__c P: CLabourPrinting)
        {
            PC.temp_Labor_Cutting__c = P.Labor_Cost_per_1000_Pcs__c;
        }
        //Extrusion
        List<Product_Costing__c> Extrusion = [SELECT Id, Cost_per_unit__c
                                              FROM Product_Costing__c WHERE Product_Family__c ='LABOUR COST' and Mainetti_Company__c=:PC.Mainetti_Company__c and Active__c=TRUE]; 
        for(Product_Costing__c P: Extrusion)
        {
            PC.temp_extrusion_cost_per_unit__c = P.Cost_per_unit__c;
            
        }
        //Labour-Printing
        List<Product_Costing__c> LabourPrinting = [SELECT Id, Hourly_Output_length_A__c,Effective_Number_of_labour__c,Labor_Hourly_Wage__c,Number_of_Labour__c,Scrap_Rate__c
                                                   FROM Product_Costing__c WHERE Printing_Plate_Type__c = :PC.Printing_Plate_Type__c AND Printing_Area_A__c =:PC.temp_printing_area__c AND Number_of_Color__c =: PC.Number_of_Colour__c and Mainetti_Company__c=:PC.Mainetti_Company__c and Active__c=TRUE]; 
        for(Product_Costing__c P: LabourPrinting)
        {
            //PC.temp_Labor_Printing__c = P.Hourly_Output_length_A__c*P.Labor_Hourly_Wage__c;
            PC.Effective_Number_of_labour__c = P.Hourly_Output_length_A__c/(P.Number_of_Labour__c/(1-(P.Scrap_Rate__c/100)));        
            PC.temp_Effective_Number_of_Labour__c = P.Effective_Number_of_labour__c;
            PC.temp_Printing_Labour_Hourly_Wages__c = P.Labor_Hourly_Wage__c;
        }
        if(PC.Printing_Plate_Type__c!=null)
        {
           PC.temp_Labor_Printing__c= (PC.Final_Length_of_Printing__c  /PC.Effective_Number_of_labour__c   )*1000*PC.temp_Printing_Labour_Hourly_Wages__c;
            //Final_Length_of_Printing__c, Actual_Length_for_Printing1__c
        }
        else
            PC.temp_Labor_Printing__c=0;
        //Scrap

       // PC.temp_Scrap_Material_Cost__c=((PC.Polymer_Cost_1000_bags__c + PC.Masterbatch_Cost_1000_bags__c )* 
          //  (1- (1- PC.Extrusion_Scrap_Rate2__c ) * (1- PC.Printing_Scrap_Rate2__c ) * (1- PC.Bag_Cutting_Scrap_Rate2__c ))/2)+
            //(PC.Ink_1000_bags__c * (1-(1- PC.Printing_Scrap_Rate2__c ) * (1- PC.Bag_Cutting_Scrap_Rate2__c )));

            
        //(PC.Ink_1000_bags__c * (1-(1- PC.Printing_Scrap_Rate2__c ) * (1- PC.Bag_Cutting_Scrap_Rate2__c )))
        PC.temp_Scrap_Material_Cost__c=PC.Scrap_Cost_1000_bags_Extrusion_Cost__c + PC.Scrap_Cost_1000_bags_Printing_Cost__c + PC.Scrap_Cost_1000_bags_Finish_Cost__c;       
        //Total Material Cost
        PC.Temp_Total_Material_Cost_1000_bags__c=PC.Polymer_Cost_1000_bags__c +  PC.Masterbatch__c +  PC.Ink__c + PC.Hook__c + PC.Zipper__c + 
            PC.Ziplock_Material_Cost__c +   PC.Handle_Material_Cost__c +  PC.Adhesive_Strip_Material_Cost__c +  
            PC.Stickers_Material_Cost__c + PC.Cardboard_Material_Cost__c +  PC.Patch_Material_Cost__c +  PC.String_Material_Cost__c +  
            PC.Eyelet_Material_Cost__c +  PC.temp_Scrap_Material_Cost__c;
        //Total Industrial Cost
        PC.Temp_Industrial_Cost_1000_bags__C=PC.Temp_Total_Material_Cost_1000_bags__c +  PC.Total_Production_Labor_Cost__c +  PC.VPOH_Cost__c +  PC.Subcontracting_Cost__c +  
            PC.Electricity_Cost__c +  PC.FPOH_Cost__c +  PC.Depreciation_Cost__c+PC.Tooling_Set_up_Cost_1000_bags__c+PC.Setup_Cost_1000_bags__c;
        //Total Direct Cost
        PC.Temp_Total_Direct_Cost_1000_bags__c = PC.Labor_Extrusion_Industrial__c + PC.Labor_Printing__c + PC.Labor_Cutting__c + PC.Labor_Craftwork__c;
         PC.temp_ttl_Production_overhead_Cost__C =PC.VPOH_Cost__c +  PC.Subcontracting_Cost__c +  PC.Electricity_Cost__c +PC.FPOH_Cost__c +  PC.Depreciation_Cost__c;
        //Top Cardboard Cost
        List<Product_Costing__c> TopCost = [SELECT Id,Name,Purchase_Price__c FROM Product_Costing__c
                                            WHERE Product_Family__c = 'CARDBOARD'
                                               and Id = : PC.Cardboard__c 
                                               and Mainetti_Company__c=:PC.Mainetti_Company__c and Active__c=TRUE]   ; 
        for(Product_Costing__c P: TopCost)
        {
            PC.Top_Cardboard_Cost__c = P.Purchase_Price__c;

            
        }
        //Bottom Cardboard Cost
        List<Product_Costing__c> BottomCost = [SELECT Id,Name,Purchase_Price__c FROM Product_Costing__c
                                            WHERE Product_Family__c = 'CARDBOARD'
                                               and Id = : PC.Cardboard_2_Color__c 
                                               and Mainetti_Company__c=:PC.Mainetti_Company__c and Active__c=TRUE]   ; 
        for(Product_Costing__c P: BottomCost)
        {
            PC.Bottom_Cardboard_Cost__c = P.Purchase_Price__c;

            
        }
        //Soft Handle Cost
        List<Product_Costing__c> SoftHandleCost = [SELECT Id,Name,Purchase_Price__c FROM Product_Costing__c
                                            WHERE Product_Family__c = 'SOFT HANDLE'
                                               and Id = : PC.Soft_Handle__c 
                                               and Mainetti_Company__c=:PC.Mainetti_Company__c and Active__c=TRUE]   ; 
        for(Product_Costing__c P: SoftHandleCost)
        {
            PC.Soft_Handle_Cost__c = P.Purchase_Price__c;

            
        }
       // PC.Bottom_Cardboard_Cost__c=PC.Bottom_Cardboard_Cost__c*PC.Length_of_Cardboard_per_bag_cm__c * PC.Width_of_Cardboard_per_bag_cm__c* PC.Number_of_Cardboard_2__c;
        //Total
        //PC.temp_Total_Industrial_Cost_1000_bags__c=PC.Temp_Total_Direct_Cost_1000_bags__c+PC.temp_ttl_Production_overhead_Cost__C+PC.Temp_Total_Material_Cost_1000_bags__c+PC.Temp_Total_Set_Up_Cost_1000_bags__C;
        
        //+PC.Total_Production_Labor_Cost__c
        //PC.temp_extrusion_cost_per_unit__c * PC.Weight_per_1000_bags_KG__c + PC.Labor_Printing__c + PC.temp_Labor_Cutting__c + PC.Labor_Craftwork__c
        //scarp rate
        //PC.Bag_Cutting_Scrap_Rate__c = PC.Material_Scrap_Rate__c*2;
        //PC.Extrusion_Scrap_Rate__c = PC.Material_Scrap_Rate__c * 2;
        //PC.Printing_Scrap_Rate__c = PC.Material_Scrap_Rate__c*2;
        
        
        //Printing Type - Set up Cost
        List<Product_Costing__c> PrintSetupC = [SELECT Id,Labour_Cost_Printing_Set_Up__c,Material_Loss__c,Material_Length_for_testing_cm__c
                                                FROM Product_Costing__c WHERE Printing_Plate_Type__c =: PC.Printing_Plate_Type__c and Number_of_Color__c = : PC.Number_of_Colour__c and Product_Family__C='SET UP COST' and Mainetti_Company__c=:PC.Mainetti_Company__c and Active__c=TRUE]   ; 
        for(Product_Costing__c P: PrintSetupC)
        {
            PC.Temp_Printing_Labor__c = P.Labour_Cost_Printing_Set_Up__c;
            PC.temp_Printing_Material__c = P.Material_Length_for_testing_cm__c;
            
        }
        //Cutting - Set Up Cost
        List<Product_Costing__c> ProdC_Cut = [SELECT Id,Labour_Cost_Printing_Set_Up__c,Material_Loss__c,Material_Length_for_testing_cm__c
                                              FROM Product_Costing__c WHERE Cutting_Machine_Type__c =: PC.Cutting_Machine_Type__c and Product_Family__C='SET UP COST' and Mainetti_Company__c=:PC.Mainetti_Company__c and Active__c=TRUE]; 
        for(Product_Costing__c P: ProdC_Cut)
        {
            PC.Temp_Cutting_Labor__c = P.Labour_Cost_Printing_Set_Up__c;
            PC.Temp_Cutting_Material__c = P.Material_Length_for_testing_cm__c;
        }
        //Printing Plate - Purchase Cost
        List<Product_Costing__c> ProdC_Print_Cost = [SELECT Id,Purchase_Price__c
                                                     FROM Product_Costing__c WHERE Product_Family__c ='PRINTING PLATE' and Printing_Plate_Type__c = :PC.Printing_Plate_Type__c and Mainetti_Company__c=:PC.Mainetti_Company__c and Active__c=TRUE]; 
        for(Product_Costing__c P: ProdC_Print_Cost)
        {
            PC.Temp_Copper_or_Plastic_Plate_1000_bags__c = P.Purchase_Price__c;
            
        }
        
        
        
        //Craftwork Labour Cost
        List<Product_Costing__c> CraftLabourhook = [SELECT Id, Labor_Cost_per_1000_Pcs__c
                                                    FROM Product_Costing__c WHERE Craftwork_Type__c='Hook' and Mainetti_Company__c=:PC.Mainetti_Company__c and Active__c=TRUE]; 
        for(Product_Costing__c P: CraftLabourhook)
        {
            PC.temp_Craft_work_wage_of_Hook_per_bag__c = P.Labor_Cost_per_1000_Pcs__c;
        }
        List<Product_Costing__c> CraftLabourZiplock = [SELECT Id, Labor_Cost_per_1000_Pcs__c
                                                       FROM Product_Costing__c WHERE Craftwork_Type__c='Zipper' and Mainetti_Company__c=:PC.Mainetti_Company__c and Active__c=TRUE]; 
        for(Product_Costing__c P: CraftLabourZiplock)
        {
            PC.temp_Craft_work_wage_of_Ziplock_per_bag__c = P.Labor_Cost_per_1000_Pcs__c;
        }
        List<Product_Costing__c> CraftLabourHandle = [SELECT Id, Labor_Cost_per_1000_Pcs__c
                                                      FROM Product_Costing__c WHERE Craftwork_Type__c='Hard Handle' and Mainetti_Company__c=:PC.Mainetti_Company__c and Active__c=TRUE]; 
        for(Product_Costing__c P: CraftLabourHandle)
        {
            PC.temp_Craft_work_wage_of_Handle_per_bag__c = P.Labor_Cost_per_1000_Pcs__c;
        }
        List<Product_Costing__c> CraftLabourSHandle = [SELECT Id, Labor_Cost_per_1000_Pcs__c
                                                      FROM Product_Costing__c WHERE Craftwork_Type__c='Soft Handle' and Mainetti_Company__c=:PC.Mainetti_Company__c and Active__c=TRUE]; 
        for(Product_Costing__c P: CraftLabourSHandle)
        {
            PC.temp_Craft_work_wage_of_S_Handle_per_bag__c = P.Labor_Cost_per_1000_Pcs__c;
        }
        List<Product_Costing__c> CraftLabourAdhesiveStrips = [SELECT Id, Labor_Cost_per_1000_Pcs__c
                                                              FROM Product_Costing__c WHERE Craftwork_Type__c='Adhesive Strips' and Mainetti_Company__c=:PC.Mainetti_Company__c and Active__c=TRUE]; 
        for(Product_Costing__c P: CraftLabourAdhesiveStrips)
        {
            PC.temp_Craft_work_wage_of_Adhesive_Strips__c = P.Labor_Cost_per_1000_Pcs__c;
        }
        List<Product_Costing__c> CraftLabourSticker = [SELECT Id, Labor_Cost_per_1000_Pcs__c
                                                       FROM Product_Costing__c WHERE Craftwork_Type__c='Sticker' and Mainetti_Company__c=:PC.Mainetti_Company__c and Active__c=TRUE]; 
        for(Product_Costing__c P: CraftLabourSticker)
        {
            PC.temp_Craft_work_wage_of_Sticker_per_bag__c = P.Labor_Cost_per_1000_Pcs__c;
        }
        List<Product_Costing__c> CraftLabourCardboard = [SELECT Id, Labor_Cost_per_1000_Pcs__c
                                                         FROM Product_Costing__c WHERE Craftwork_Type__c='Cardboard' and Mainetti_Company__c=:PC.Mainetti_Company__c and Active__c=TRUE]; 
        for(Product_Costing__c P: CraftLabourCardboard)
        {
            PC.temp_Area_of_Cardboard_per_bag_sq_cm__c = P.Labor_Cost_per_1000_Pcs__c;
        }
        List<Product_Costing__c> CraftLabourPatch = [SELECT Id, Labor_Cost_per_1000_Pcs__c
                                                     FROM Product_Costing__c WHERE Craftwork_Type__c='Patch' and Mainetti_Company__c=:PC.Mainetti_Company__c and Active__c=TRUE]; 
        for(Product_Costing__c P: CraftLabourPatch)
        {
            PC.temp_Craft_work_wage_of_Patch_per_bag__c = P.Labor_Cost_per_1000_Pcs__c;
        }
        List<Product_Costing__c> CraftLabourString = [SELECT Id, Labor_Cost_per_1000_Pcs__c
                                                      FROM Product_Costing__c WHERE Craftwork_Type__c='String' and Mainetti_Company__c=:PC.Mainetti_Company__c and Active__c=TRUE]; 
        for(Product_Costing__c P: CraftLabourString)
        {
            PC.temp_Craft_work_wage_of_String_per_bag__c = P.Labor_Cost_per_1000_Pcs__c;
        }
        List<Product_Costing__c> CraftLabourEyeletSet = [SELECT Id, Labor_Cost_per_1000_Pcs__c
                                                         FROM Product_Costing__c WHERE Craftwork_Type__c='Eyelet Set' and Mainetti_Company__c=:PC.Mainetti_Company__c and Active__c=TRUE]; 
        for(Product_Costing__c P: CraftLabourEyeletSet)
        {
            PC.temp_Craft_work_wage_of_Eyelet_Set_per_b__c = P.Labor_Cost_per_1000_Pcs__c;
        }
        //End Craftwork Labour Cost
        //VPOH Cost
        List<Product_Costing__c> VPOHCOST = [SELECT Id, FPOH_of_Extrusion__c,FPOH_of_Printing__c,FPOH_of_Cutting__c,FPOH_of_Manual_Work__c
                                             FROM Product_Costing__c WHERE Department_Type__c='VPOH' and Mainetti_Company__c=:PC.Mainetti_Company__c and Active__c=TRUE]; 
        for(Product_Costing__c P: VPOHCOST)
        {
            PC.Temp_E_VPOH__c = P.FPOH_of_Extrusion__c;
            PC.Temp_P_VPOH__c = P.FPOH_of_Printing__c;
            PC.Temp_C_VPOH__c = P.FPOH_of_Cutting__c;
            PC.Temp_M_VPOH__c = P.FPOH_of_Manual_Work__c;
        }
        //FPOH Cost
        List<Product_Costing__c> FPOHCOST = [SELECT Id, FPOH_of_Extrusion__c,FPOH_of_Printing__c,FPOH_of_Cutting__c,FPOH_of_Manual_Work__c
                                             FROM Product_Costing__c WHERE Department_Type__c='FPOH' and Mainetti_Company__c=:PC.Mainetti_Company__c and Active__c=TRUE]; 
        for(Product_Costing__c P: FPOHCOST)
        {
            PC.Temp_E_FPOH__c = P.FPOH_of_Extrusion__c;
            PC.Temp_P_FPOH__c = P.FPOH_of_Printing__c;
            PC.Temp_C_FPOH__c = P.FPOH_of_Cutting__c;
            PC.Temp_M_FPOH__c = P.FPOH_of_Manual_Work__c;
        }
        //Electricity Cost
        List<Product_Costing__c> ElectricityCost = [SELECT Id, Electricity_of_Extrusion_Cost_kg__c,Electricity_of_Printing_Cost_kg__c,Electricity_of_Cutting_Cost_kg__c,Electricity_of_Manual_Work_Cost_kg__c
                                                    FROM Product_Costing__c WHERE Product_Family__c='ELECTRICITY COST' and Mainetti_Company__c=:PC.Mainetti_Company__c and Active__c=TRUE]; 
        for(Product_Costing__c P: ElectricityCost)
        {
            PC.Temp_E_Electricity__c = P.Electricity_of_Extrusion_Cost_kg__c;
            PC.Temp_P_Electricity__c = P.Electricity_of_Printing_Cost_kg__c;
            PC.Temp_C_Electricity__c = P.Electricity_of_Cutting_Cost_kg__c  ;
            PC.Temp_M_Electricity__c = P.Electricity_of_Manual_Work_Cost_kg__c;
        }
        //Depreciation Cost
        List<Product_Costing__c> DepreCost = [SELECT Id, FPOH_of_Extrusion__c,FPOH_of_Printing__c,FPOH_of_Cutting__c,FPOH_of_Manual_Work__c
                                              FROM Product_Costing__c WHERE Department_Type__c='Depreciation' and Mainetti_Company__c=:PC.Mainetti_Company__c and Active__c=TRUE ]; 
        for(Product_Costing__c P: DepreCost)
        {
            PC.Temp_E_Depre__c = P.FPOH_of_Extrusion__c;
            PC.Temp_P_Depre__c = P.FPOH_of_Printing__c;
            PC.Temp_C_Depre__c = P.FPOH_of_Cutting__c;
            PC.Temp_M_Depre__c = P.FPOH_of_Manual_Work__c;
        }
		//Total Industrial Cost
		///PC.Temp_Total_Material_Cost_1000_bags__c 
        PC.temp_Total_Industrial_Cost_1000_bags__c=PC.Temp_Total_Material_Cost_1000_bags__c 
            +PC.Labor_Extrusion_Industrial__c + PC.Labor_Printing__c + PC.Labor_Cutting__c + PC.Labor_Craftwork__c+      
            PC.VPOH_Cost__c+PC.Subcontracting_Cost__c+PC.Electricity_Cost__c+PC.FPOH_Cost__c+
            +PC.Depreciation_Cost__c+((PC.temp_Extrusion_Labor__c + PC.Temp_Extrusion_Material__c + PC.Temp_Printing_Labor__c + PC.Printing_Material_incl_ink__c 
                                      + PC.Temp_Cutting_Labor__c + PC.Cutting_Material__c) /PC.Production_Run_Quantity__c  *1000)+PC.Tooling_Set_up_Cost_1000_bags__c;

		//Total Setup Cost
        PC.Temp_Total_Set_Up_Cost_1000_bags__C=((PC.temp_Extrusion_Labor__c + PC.Temp_Extrusion_Material__c + PC.Temp_Printing_Labor__c + PC.Printing_Material_incl_ink__c 
                                      + PC.Temp_Cutting_Labor__c + PC.Cutting_Material__c) /PC.Production_Run_Quantity__c  *1000)+PC.Tooling_Set_up_Cost_1000_bags__c;
        
        //end
        
    }
}