public class WeeklyShipmentObj {
    
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
    public Double totalShipmentQty;
    @AuraEnabled
    public String isNegative;
    @AuraEnabled
    public Double totalBalance;
    
    public List<Inventory_Allocation__c> inventoryAllocation;
    
    
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
    public Double gettotalShipmentQty()
    {
        return totalShipmentQty;
    }
    public void settotalShipmentQty(Double totalShipmentQty)
    {
        this.totalShipmentQty=totalShipmentQty;
    } 
    

    public string getIsNegative()
    {
        return isNegative;
    }
    public void setIsNegative(String isNegative)
    {
        this.isNegative=isNegative;
    } 
     
    
    	

    public List<Inventory_Allocation__c> getInventoryAllocation()
    {
        return inventoryAllocation;
    }
    public void setInventoryAllocation(List<Inventory_Allocation__c> inventoryAllocation)
    {
        this.inventoryAllocation=inventoryAllocation;
    } 
}