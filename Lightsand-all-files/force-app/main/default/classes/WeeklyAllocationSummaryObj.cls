public class WeeklyAllocationSummaryObj {
    
    @AuraEnabled
    public String mainettiCompany;
    @AuraEnabled
    public String retailerCode;
    @AuraEnabled
    public String model;
    @AuraEnabled
    public String sizerPrinter;
    @AuraEnabled
    public String color;
    @AuraEnabled
    public String inventoryallocationtype;
    @AuraEnabled
    public Double quantity;
    @AuraEnabled
    public String inventoryallocationdemand;
    @AuraEnabled
    public String inventoryallocationsupply;
    @AuraEnabled
    public Date weekstartdate;
    @AuraEnabled
    public Date weekenddate;
    @AuraEnabled
    public String allocationType;
    /* @AuraEnabled
public String isNegative;
@AuraEnabled
public Double totalBalance;*/
    @AuraEnabled
    public List<Inventory_Allocation__c> inventoryAllocation;
     @AuraEnabled
    public List<Weekly_Demand_Summary__c> demandSummaryList;
    
    
    @AuraEnabled
    public ID weeklyAllocationId;
    @AuraEnabled
    public ID Id;
    
    
    public string getMainettiCompany()
    {
        return mainettiCompany;
    }
    public void setMainettiCompany(String mainettiCompany)
    {
        this.mainettiCompany=mainettiCompany;
    }
    public string getRetailerCode()
    {
        return retailerCode;
    }
    public void setRetailerCode(String retailerCode)
    {
        this.retailerCode=retailerCode;
    } 
    public string getmainettiModel()
    {
        return model;
    }
    public void setModel(String model)
    {
        this.model=model;
    } 
    public string getColor()
    {
        return color;
    }
    public void setColor(String color)
    {
        this.color=color;
    } 
    public string getsizerPrinter()
    {
        return sizerPrinter;
    }
    public void setsizerPrinter(String sizerPrinter)
    {
        this.sizerPrinter=sizerPrinter;
    } 
    
    public string getInventoryAllocationType()
    {
        return InventoryAllocationType;
    }
    public void setInventoryAllocationType(String InventoryAllocationType)
    {
        this.InventoryAllocationType=InventoryAllocationType;
    } 
    public Double getquantity()
    {
        return quantity;
    }
    public void setquantity(Double quantity)
    {
        this.quantity=quantity;
    } 
    public string getinventoryallocationdemand()
    {
        return inventoryallocationdemand;
    }
    public void setinventoryallocationdemand(String inventoryallocationdemand)
    {
        this.inventoryallocationdemand=inventoryallocationdemand;
    } 
    public string getinventoryallocationsupply()
    {
        return inventoryallocationsupply;
    }
    public void setinventoryallocationsupply(String inventoryallocationsupply)
    {
        this.inventoryallocationsupply=inventoryallocationsupply;
    } 
    public Date getweekstartdate()
    {
        return weekstartdate;
    }
    public void setweekstartdate(Date weekstartdate)
    {
        this.weekstartdate=weekstartdate;
    } 
    public Date getweekenddate()
    {
        return weekenddate;
    }
    public void setweekenddate(Date weekenddate)
    {
        this.weekenddate=weekenddate;
    } 
    public string getallocationType()
    {
        return allocationType;
    }
    public void setallocationType(String allocationType)
    {
        this.allocationType=allocationType;
    }
    
    
    /* public string getIsNegative()
{
return isNegative;
}
public void setIsNegative(String isNegative)
{
this.isNegative=isNegative;
} */
    
    
    public List<Inventory_Allocation__c> getInventoryAllocation()
    {
        return inventoryAllocation;
    }
    public void setInventoryAllocation(List<Inventory_Allocation__c> inventoryAllocation)
    {
        this.inventoryAllocation=inventoryAllocation;
    } 
    
    public List<Weekly_Demand_Summary__c> getDemandSummaryList()
    {
        return demandSummaryList;
    }
    public void setDemandSummaryList(List<Weekly_Demand_Summary__c> demandSummaryList)
    {
        this.demandSummaryList=demandSummaryList;
    } 
    
    
    public ID getWeeklyAllocationId()
    {
        return weeklyAllocationId;
    }
    public void setWeeklyAllocationId(ID weeklyAllocationId)
    {
        this.weeklyAllocationId=weeklyAllocationId;
    } 
    
    public ID getId()
    {
        return Id;
    }
    public void setId(ID Id)
    {
        this.Id=Id;
    } 
}