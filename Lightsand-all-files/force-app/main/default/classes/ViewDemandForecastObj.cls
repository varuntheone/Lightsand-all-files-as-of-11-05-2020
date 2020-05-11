public class ViewDemandForecastObj {
    
    @AuraEnabled
    public String mainettiCompany;
    @AuraEnabled
    public String retailerCode;
    @AuraEnabled
    public String model;
    @AuraEnabled
    public String color;
    @AuraEnabled
    public String sizerPrinter;
    @AuraEnabled
    public Double totalDemandQty;
    @AuraEnabled
    public Double totalSupplyQty;
    @AuraEnabled
    public Double totalShipmentQty;
    @AuraEnabled
    public Double totalAllocationQty;
    @AuraEnabled
    public Double variance;
    @AuraEnabled
    public String isNegative;
    @AuraEnabled
    public Double totalBalance;
    @AuraEnabled
    public ID weeklyDemandId;
    @AuraEnabled
    public ID weeklySupplyId;
    @AuraEnabled
    public ID weeklyShipmentId;
    @AuraEnabled
    public List<Inventory_Allocation__c> inventoryAllocation;
    @AuraEnabled
    public String hasAccessToAllocate;
    @AuraEnabled
    public String source;
    @AuraEnabled
    public String warehouse;
    @AuraEnabled
    public Double allocationNotReceived;
    
    
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
    public string getModel()
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
    public string getSizerPrinter()
    {
        return sizerPrinter;
    }
    public void setSizerPrinter(String sizerPrinter)
    {
        this.sizerPrinter=sizerPrinter;
    } 
    public Double getTotalDemandQty()
    {
        return totalDemandQty;
    }
    public void setTotalDemandQty(Double totalDemandQty)
    {
        this.totalDemandQty=totalDemandQty;
    } 
    public Double getTotalSupplyQty()
    {
        return totalSupplyQty;
    }
    public void setTotalSupplyQty(Double totalSupplyQty)
    {
        this.totalSupplyQty=totalSupplyQty;
    } 
    public Double getTotalShipmentQty()
    {
        return totalShipmentQty;
    }
    public void setTotalShipmentQty(Double totalShipmentQty)
    {
        this.totalShipmentQty=totalShipmentQty;
    } 
    
    public Double getTotalAllocationQty()
    {
        return totalAllocationQty;
    }
    public void setTotalAllocationQty(Double totalAllocationQty)
    {
        this.totalAllocationQty=totalAllocationQty;
    } 
    public Double getVariance()
    {
        return variance;
    }
    public void setVariance(Double variance)
    {
        this.variance=variance;
    } 

    public string getIsNegative()
    {
        return isNegative;
    }
    public void setIsNegative(String isNegative)
    {
        this.isNegative=isNegative;
    } 
     
    public ID getWeeklyDemandId()
    {
        return weeklyDemandId;
    }
    public void setWeeklyDemandId(ID weeklyDemandId)
    {
        this.weeklyDemandId=weeklyDemandId;
    } 
    public ID getweeklySupplyId()
    {
        return weeklySupplyId;
    }
    public void setWeeklySupplyId(ID weeklySupplyId)
    {
        this.weeklySupplyId=weeklySupplyId;
    } 
    public ID getWeeklyShipmentId()
    {
        return weeklyShipmentId;
    }
    public void setWeeklyShipmentId(ID weeklyShipmentId)
    {
        this.weeklyShipmentId=weeklyShipmentId;
    } 
    public List<Inventory_Allocation__c> getInventoryAllocation()
    {
        return inventoryAllocation;
    }
    public void setInventoryAllocation(List<Inventory_Allocation__c> inventoryAllocation)
    {
        this.inventoryAllocation=inventoryAllocation;
    } 
    
    public string getHasAccessToAllocate()
    {
        return hasAccessToAllocate;
    }
    public void setHasAccessToAllocate(String hasAccessToAllocate)
    {
        this.hasAccessToAllocate=hasAccessToAllocate;
    } 
    public string getSource()
    {
        return source;
    }
    public void setSource(String source)
    {
        this.source=source;
    } 
    public string getWarehouse()
    {
        return warehouse;
    }
    public void setWarehouse(String warehouse)
    {
        this.warehouse=warehouse;
    } 
    public Double getAllocationNotReceived()
    {
        return allocationNotReceived;
    }
    public void setAllocationNotReceived(Double allocationNotReceived)
    {
        this.allocationNotReceived=allocationNotReceived;
    } 
}