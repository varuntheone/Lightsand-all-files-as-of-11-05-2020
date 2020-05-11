public class SearchFrontControllerWithPagination{

//Pagination variables start
 private integer counter=0;  //keeps track of the offset
   private integer list_size=10; //sets the page size or number of rows
   public integer total_size; //used to show user the total size of the list
   private integer tempTotal_size=0;
   private integer totalRecordsInCurrentPage=0;
   public integer getTotalRecordsInCurrentPage(){
   if(totalRecordsInCurrentPage==0){
   totalRecordsInCurrentPage = list_size;
   }
   if(totalRecordsInCurrentPage>total_size){
   return total_size;
   }
   return totalRecordsInCurrentPage;
   }
      
   public integer getCounter(){
   return counter;
   }
   public integer getList_size(){
   return list_size;
   }
//Pagination variables end
private final integer searchChars=2;

List<Mould__c> products;


List<DisplaySearchProperties> noOfRows;

List<DisplaySearchProperties> searchResList;

public SearchFrontControllerWithPagination(){
System.debug('####### Inside Constructor ########');
DisplaySearchProperties displaySearchProperties = new DisplaySearchProperties();
noOfRows = new List<DisplaySearchProperties >();
noOfRows.add(displaySearchProperties );
noOfRows.add(displaySearchProperties );
noOfRows.add(displaySearchProperties );
//total_size = [select count() from Mould__c where Mould_Status__c='Active'];
//total_size=getMouldCountWithBuildQuery();
//this.search();
}

private String fieldName1 = '';
public String getFieldName1(){
return fieldName1;
}
public void setFieldName1(String name1){
fieldName1 = name1;
}
private String searchCriteria1{get; set;}

private String fieldName2 = '';
public String getFieldName2(){
return fieldName2;
}
public void setFieldName2(String name2){
fieldName2 = name2;
}
private String searchCriteria2{get; set;}

private String fieldName3 = '';
public String getFieldName3(){
return fieldName3;
}
public void setFieldName3(String name3){
fieldName3 = name3;
}
private String searchCriteria3{get; set;}

private String fieldName4 = '';
public String getFieldName4(){
return fieldName4;
}
public void setFieldName4(String name4){
fieldName4 = name4;
}


private String fieldName5 = '';
public String getFieldName5(){
return fieldName5;
}
public void setFieldName5(String name5){
fieldName5 = name5;
}


private String fieldName6 = '';
public String getFieldName6(){
return fieldName6;
}
public void setFieldName6(String name6){
fieldName6 = name6;
}

private String fieldName7 = '';
public String getFieldName7(){
return fieldName7;
}
public void setFieldName7(String name7){
fieldName7 = name7;
}

private String fieldName8 = '';
public String getFieldName8(){
return fieldName8;
}
public void setFieldName8(String name8){
fieldName8 = name8;
}

private String fieldName9 = '';
public String getFieldName9(){
return fieldName9;
}
public void setFieldName9(String name9){
fieldName9 = name9;
}

private String fieldName10 = '';
public String getFieldName10(){
return fieldName10;
}
public void setFieldName10(String name10){
fieldName10 = name10;
}

private String fieldName11 = '';
public String getFieldName11(){
return fieldName11;
}
public void setFieldName11(String name11){
fieldName11 = name11;
}


private String fieldName12 = '';
public String getFieldName12(){
return fieldName12;
}
public void setFieldName12(String name12){
fieldName12 = name12;
}

private String fieldName13 = '';
public String getFieldName13(){
return fieldName13;
}
public void setFieldName13(String name13){
fieldName13 = name13;
}

private String fieldName14 = '';
public String getFieldName14(){
return fieldName14;
}
public void setFieldName14(String name14){
fieldName14 = name14;
}


private String fieldName15 = '';
public String getFieldName15(){
return fieldName15;
}
public void setFieldName15(String name15){
fieldName15 = name15;
}

//For Error Messages Start
public boolean errorForFieldName1=false;
public boolean getErrorForFieldName1(){
return errorForFieldName1;
}
public void setErrorForFieldName1(boolean error){
this.errorForFieldName1 = error;
}
public String errorMessage {get;set;}
public boolean indicatorToPopulateErrorMessageBasedOnSearchCriteriaEmpty = true;
//For Error Messages End
public List<DisplaySearchProperties> getNoOfRows(){
return noOfRows;
}

public void setNoOfRows(List<DisplaySearchProperties> rows){
noOfRows = rows;
}

public void search(){
indicatorToPopulateErrorMessageBasedOnSearchCriteriaEmpty = true;
System.debug('Testing['+fieldName1+']');

System.debug('Testing['+fieldName1+']');

System.debug('###Offset['+counter+']');

System.debug('###Total No Of Records['+total_size+']');
//products=[SELECT Id,Mould_ID__c, Name,Model__c, Mould_Status__c from Mould__c where Name Like :fieldName1+'%' AND Model__c LIKE :fieldName3+'%' AND Mould_ID__c LIKE :fieldName2+'%' AND Mould_Status__c='Active'];
total_size=getMouldCountWithBuildQuery();
//For Pagination display records start
if(searchResList == null){
tempTotal_size=total_size;
}
if(tempTotal_size!=total_size){
counter=0;
totalRecordsInCurrentPage=0;
}
//For Pagination display records end
products = getBuildedMouldQuery();
//System.debug(##List Size###+searchList.size());
Integer I=1;

/*for (Mould__c tmp : [select Name from Mould__c where Mould_Status__c='Active']) {
// Perform some actions on the single merchandise record.

System.debug('Count['+I+'] ###Name:'+tmp.name);
i++;
}*/
searchResList = getSearchResFromProducts(products);
//For Error Messages Start
if(indicatorToPopulateErrorMessageBasedOnSearchCriteriaEmpty && (fieldName1==null || fieldName1=='' || fieldName1.length()<searchChars)){
this.setErrorForFieldName1(true);
}else{
indicatorToPopulateErrorMessageBasedOnSearchCriteriaEmpty=false;
this.setErrorForFieldName1(false);
}
if(indicatorToPopulateErrorMessageBasedOnSearchCriteriaEmpty && (fieldName2==null || fieldName2=='' || fieldName2.length()<searchChars)){
this.setErrorForFieldName1(true);
}else{
indicatorToPopulateErrorMessageBasedOnSearchCriteriaEmpty=false;
this.setErrorForFieldName1(false);
}
if(indicatorToPopulateErrorMessageBasedOnSearchCriteriaEmpty && (fieldName3==null || fieldName3=='' || fieldName3.length()<searchChars)){
this.setErrorForFieldName1(true);
}else{
indicatorToPopulateErrorMessageBasedOnSearchCriteriaEmpty=false;
this.setErrorForFieldName1(false);
}
if(indicatorToPopulateErrorMessageBasedOnSearchCriteriaEmpty && (fieldName4==null || fieldName4=='')){
this.setErrorForFieldName1(true);
}else{
indicatorToPopulateErrorMessageBasedOnSearchCriteriaEmpty=false;
this.setErrorForFieldName1(false);
}
if(indicatorToPopulateErrorMessageBasedOnSearchCriteriaEmpty && (fieldName5==null || fieldName5=='' || fieldName5.length()<searchChars)){
this.setErrorForFieldName1(true);
}else{
indicatorToPopulateErrorMessageBasedOnSearchCriteriaEmpty=false;
this.setErrorForFieldName1(false);
}
if(indicatorToPopulateErrorMessageBasedOnSearchCriteriaEmpty && (fieldName6==null || fieldName6=='' || fieldName6.length()<searchChars)){
this.setErrorForFieldName1(true);
}else{
indicatorToPopulateErrorMessageBasedOnSearchCriteriaEmpty=false;
this.setErrorForFieldName1(false);
}
if(indicatorToPopulateErrorMessageBasedOnSearchCriteriaEmpty && (fieldName7==null || fieldName7=='' || fieldName7.length()<searchChars)){
this.setErrorForFieldName1(true);
}else{
indicatorToPopulateErrorMessageBasedOnSearchCriteriaEmpty=false;
this.setErrorForFieldName1(false);
}
if(indicatorToPopulateErrorMessageBasedOnSearchCriteriaEmpty && (fieldName8==null || fieldName8=='' || fieldName8.length()<searchChars)){
this.setErrorForFieldName1(true);
}else{
indicatorToPopulateErrorMessageBasedOnSearchCriteriaEmpty=false;
this.setErrorForFieldName1(false);
}
if(indicatorToPopulateErrorMessageBasedOnSearchCriteriaEmpty && (fieldName9==null || fieldName9=='' || fieldName9.length()<searchChars)){
this.setErrorForFieldName1(true);
}else{
indicatorToPopulateErrorMessageBasedOnSearchCriteriaEmpty=false;
this.setErrorForFieldName1(false);
}
if(indicatorToPopulateErrorMessageBasedOnSearchCriteriaEmpty && (fieldName10==null || fieldName10=='' || fieldName10.length()<searchChars)){
this.setErrorForFieldName1(true);
}else{
indicatorToPopulateErrorMessageBasedOnSearchCriteriaEmpty=false;
this.setErrorForFieldName1(false);
}
if(indicatorToPopulateErrorMessageBasedOnSearchCriteriaEmpty && (fieldName11==null || fieldName11=='' || fieldName11.length()<searchChars)){
this.setErrorForFieldName1(true);
}else{
indicatorToPopulateErrorMessageBasedOnSearchCriteriaEmpty=false;
this.setErrorForFieldName1(false);
}
if(indicatorToPopulateErrorMessageBasedOnSearchCriteriaEmpty && (fieldName12==null || fieldName12=='' || fieldName12.length()<searchChars)){
this.setErrorForFieldName1(true);
}else{
indicatorToPopulateErrorMessageBasedOnSearchCriteriaEmpty=false;
this.setErrorForFieldName1(false);
}
if(indicatorToPopulateErrorMessageBasedOnSearchCriteriaEmpty && (fieldName13==null || fieldName13=='' || fieldName13.length()<searchChars)){
this.setErrorForFieldName1(true);
}else{
indicatorToPopulateErrorMessageBasedOnSearchCriteriaEmpty=false;
this.setErrorForFieldName1(false);
}
if(indicatorToPopulateErrorMessageBasedOnSearchCriteriaEmpty && (fieldName14==null || fieldName14=='' || fieldName14.length()<searchChars)){
this.setErrorForFieldName1(true);
}else{
indicatorToPopulateErrorMessageBasedOnSearchCriteriaEmpty=false;
this.setErrorForFieldName1(false);
}
if(indicatorToPopulateErrorMessageBasedOnSearchCriteriaEmpty && (fieldName15==null || fieldName15=='' || fieldName15.length()<searchChars)){
this.setErrorForFieldName1(true);
}else{
indicatorToPopulateErrorMessageBasedOnSearchCriteriaEmpty=false;
this.setErrorForFieldName1(false);
}
if (errorForFieldName1) {
           // classInputPostalCode = 'error';  // put the errorclass, red borders
            errorMessage = 'One of the field in search criteria must have at-least 2 characters or Cavity field should have an exact value';
            searchResList = null;
            total_size=0;
        } else {
         //   classInputPostalCode = '';
            errorMessage = '';
    }
//For Error Messages End

}

public List<DisplaySearchProperties> getSearchResFromProducts(List<Mould__c> products){
List<DisplaySearchProperties> tempsearchResList = new List<DisplaySearchProperties>();
for(Mould__c eachMould : products){
DisplaySearchProperties displaySearchProp = new DisplaySearchProperties();
displaySearchProp.setName(eachMould.name);
displaySearchProp.setId(eachMould.Mould_ID__c);
displaySearchProp.setModel(eachMould.Model__c);
//System.debug('###Model###'+eachMould.Model__c);
displaySearchProp.setStatus(eachMould.Mould_Status__c);

displaySearchProp.setCavity(eachMould.Cavity__c);
displaySearchProp.setOriginalBrand(eachMould.Original_Brand__c);
displaySearchProp.setEngravedLogo(eachMould.Engraved_Logo__c);
displaySearchProp.setCountry(eachMould.Country__c);
displaySearchProp.setFactory(eachMould.Factory_Name__c);
displaySearchProp.setHolderCompany(eachMould.Holder_Company__c);
displaySearchProp.setOwnerCompany(eachMould.Owner_Company__c);
displaySearchProp.setMouldUsability(eachMould.Mould_Usability__c);
displaySearchProp.setMouldCondition(eachMould.Mould_Condition__c);
displaySearchProp.setMouldType(eachMould.Mould_Type__c);
displaySearchProp.setProductType(eachMould.Product_Type__c);
displaySearchProp.setRefProjectNo(eachMould.Ref_Project_No__c);

tempsearchResList.add(displaySearchProp);
}
return tempsearchResList;
}

public List<DisplaySearchProperties> getSearchResList(){
return searchResList;
}

public void setSearchResList(List<DisplaySearchProperties> searchListRecs){
searchResList = searchListRecs;
}


public List<Mould__c> getProducts(){

return products;
}




    
    
   private String nameSearch1{get; set;}
   private String nameSearch2{get; set;}
   private String nameSearch3{get; set;}
   
   
   
public class DisplaySearchProperties{

private String id;
public String getId(){
return id;
}   
public void setId(String idOfRec){
id=idOfRec;
}
private String name;
public String getName(){
return name;
}
public void setName(String nameOfRec){
name = nameOfRec;
}

private String model;
public String getModel(){
return model;
}
public void setModel(String modelOfRec){
model=modelOfRec;
}
private String status;
public String getStatus(){
return status;
}
public void setStatus(String statusOfRec){
status=statusOfRec;
}

private Decimal cavity;

    public Decimal getCavity() {
        return cavity;
    }

    public void setCavity(Decimal cavityOfRec) {
        this.cavity = cavityOfRec;
    }

    private String originalBrand;

    public String getOriginalBrand() {
        return originalBrand;
    }

    public void setOriginalBrand(String originalBrandOfRec) {
        this.originalBrand = originalBrandOfRec;
    }

    private String engravedLogo;

    public String getEngravedLogo() {
        return engravedLogo;
    }

    public void setEngravedLogo(String engravedLogoOfRec) {
        this.engravedLogo = engravedLogoOfRec;
    }

    private String country;

    public String getCountry() {
        return country;
    }

    private String factory;

    public void setCountry(String country) {
        this.country = country;
    }

    public String getFactory() {
        return factory;
    }

    public void setFactory(String factory) {
        this.factory = factory;
    }

    private String holderCompany;

    public String getHolderCompany() {
        return holderCompany;
    }

    public void setHolderCompany(String holderCompany) {
        this.holderCompany = holderCompany;
    }

    private String ownerCompany;

    public String getOwnerCompany() {
        return ownerCompany;
    }

    public void setOwnerCompany(String ownerCompany) {
        this.ownerCompany = ownerCompany;
    }

    private String mouldUsability;

    public String getMouldUsability() {
        return mouldUsability;
    }

    public void setMouldUsability(String mouldUsability) {
        this.mouldUsability = mouldUsability;
    }

    private String mouldCondition;

    public String getMouldCondition() {
        return mouldCondition;
    }

    public void setMouldCondition(String mouldCondition) {
        this.mouldCondition = mouldCondition;
    }

    private String mouldType;

    public String getMouldType() {
        return mouldType;
    }

    public void setMouldType(String mouldType) {
        this.mouldType = mouldType;
    }

    private String productType;

    public String getProductType() {
        return productType;
    }

    public void setProductType(String productType) {
        this.productType = productType;
    }

    private String refProjectNo;

    public String getRefProjectNo() {
        return refProjectNo;
    }

    public void setRefProjectNo(String refProjectNo) {
        this.refProjectNo = refProjectNo;
    }

public void DisplaySearchProperties(String nameOfRec, String idOfRec, String modelOfRec){
name = nameOfRec;
id=idOfRec;
model=modelOfRec;
}

}
//Picklist fiels Start
public List<SelectOption> getOriginalBrand(){
 List<SelectOption> options = new List<SelectOption>();
  options.add(new SelectOption ('Begins With','Begins With'));
  options.add(new SelectOption ('Begins With','Begins With'));
  options.add(new SelectOption ('Begins With','Begins With'));
  return options;
}
public List<SelectOption> getEngravedLogo(){
 List<SelectOption> options = new List<SelectOption>();
  options.add(new SelectOption ('Begins With','Begins With'));
  options.add(new SelectOption ('Begins With','Begins With'));
  options.add(new SelectOption ('Begins With','Begins With'));
  return options;
}
public List<SelectOption> getCountry(){
 List<SelectOption> options = new List<SelectOption>();
  options.add(new SelectOption ('Begins With','Begins With'));
  options.add(new SelectOption ('Begins With','Begins With'));
  options.add(new SelectOption ('Begins With','Begins With'));
  return options;
}
public List<SelectOption> getFactory(){
 List<SelectOption> options = new List<SelectOption>();
  options.add(new SelectOption ('Begins With','Begins With'));
  options.add(new SelectOption ('Begins With','Begins With'));
  options.add(new SelectOption ('Begins With','Begins With'));
  return options;
}
public List<SelectOption> getHolderCompany(){
 List<SelectOption> options = new List<SelectOption>();
  options.add(new SelectOption ('Begins With','Begins With'));
  options.add(new SelectOption ('Begins With','Begins With'));
  options.add(new SelectOption ('Begins With','Begins With'));
  return options;
}
public List<SelectOption> getOwnerCompany(){
 List<SelectOption> options = new List<SelectOption>();
  options.add(new SelectOption ('Begins With','Begins With'));
  options.add(new SelectOption ('Begins With','Begins With'));
  options.add(new SelectOption ('Begins With','Begins With'));
  return options;
}
public List<SelectOption> getMouldUsablity(){
 List<SelectOption> options = new List<SelectOption>();
  options.add(new SelectOption ('Begins With','Begins With'));
  options.add(new SelectOption ('Begins With','Begins With'));
  options.add(new SelectOption ('Begins With','Begins With'));
  return options;
}
public List<SelectOption> getMouldCondition(){
 List<SelectOption> options = new List<SelectOption>();
  options.add(new SelectOption ('Begins With','Begins With'));
  options.add(new SelectOption ('Begins With','Begins With'));
  options.add(new SelectOption ('Begins With','Begins With'));
  return options;
}
public List<SelectOption> getMouldType(){
 List<SelectOption> options = new List<SelectOption>();
  options.add(new SelectOption ('Begins With','Begins With'));
  options.add(new SelectOption ('Begins With','Begins With'));
  options.add(new SelectOption ('Begins With','Begins With'));
  return options;
}
public List<SelectOption> getProductType(){
 List<SelectOption> options = new List<SelectOption>();
  options.add(new SelectOption ('Begins With','Begins With'));
  options.add(new SelectOption ('Begins With','Begins With'));
  options.add(new SelectOption ('Begins With','Begins With'));
  return options;
}

//Picklist fiels Ends
//Page Block Methods Start
public PageReference Beginning() { //user clicked beginning
      counter = 0;
     this.search();
      totalRecordsInCurrentPage = this.getTotalRecordsInCurrentPage();
      if(total_size<list_size){
      totalRecordsInCurrentPage = total_size;
      }else{
      totalRecordsInCurrentPage = list_size;
      }
      return null;
   }
 
   public PageReference Previous() { //user clicked previous button
      counter -= list_size;
      this.search();
       totalRecordsInCurrentPage = this.getTotalRecordsInCurrentPage();
       totalRecordsInCurrentPage = totalRecordsInCurrentPage -list_size;
       if(totalRecordsInCurrentPage - counter!=list_size){
       totalRecordsInCurrentPage = totalRecordsInCurrentPage +(list_size-(totalRecordsInCurrentPage - counter));
       }
      return null;
   }
 
   public PageReference Next() { //user clicked next button
      counter += list_size;
        this.search();
        totalRecordsInCurrentPage = this.getTotalRecordsInCurrentPage();
        totalRecordsInCurrentPage = totalRecordsInCurrentPage +list_size;
        if(totalRecordsInCurrentPage > total_size){
        totalRecordsInCurrentPage = total_size;
        }
      return null;
   }
 
   public PageReference End() { //user clicked end
      counter = total_size - math.mod(total_size, list_size);
      this.search();
       totalRecordsInCurrentPage = this.getTotalRecordsInCurrentPage();
      totalRecordsInCurrentPage = total_size;
      return null;
   }
 
   public Boolean getDisablePrevious() { 
      //this will disable the previous and beginning buttons
      if (counter>0) return false; else return true;
   }
 
   public Boolean getDisableNext() { //this will disable the next and end buttons
      if (counter + list_size < total_size) return false; else return true;
   }
 
   public Integer getTotal_size() {
      return total_size;
   }
 
   public Integer getPageNumber() {
      return counter/list_size + 1;
   }
   public Integer getTotalPages() {
      if (math.mod(total_size, list_size) > 0) {
         return total_size/list_size + 1;
      } else {
         return (total_size/list_size);
      }
   }
//Page Block Methods Ends
//Build SQL Query Start
public String buildSOQLQuery(Boolean isConstructor){
String finalSQLQuery = '';
String finalSQLQueryPart1 = '';
if(isConstructor){
finalSQLQueryPart1 = 'SELECT count() FROM MOULD__c WHERE Mould_Status__c=\'Active\'';
}else{
finalSQLQueryPart1 = 'SELECT Id,Mould_ID__c, Name,Model__c, Cavity__c, Original_Brand__c, Engraved_Logo__c, Country__c, Factory_Name__c, Holder_Company__c, Owner_Company__c, Mould_Usability__c, Mould_Condition__c, Mould_Type__c, Product_Type__c, Ref_Project_No__c, Mould_Status__c FROM MOULD__c WHERE Mould_Status__c=\'Active\'';
}
String finalSQLQueryPart2 = getSQLQueryPart2();
finalSQLQuery = finalSQLQueryPart1 + finalSQLQueryPart2;
return finalSQLQuery;
}
public String getSQLQueryPart2(){
String queryPart2 = '';
if(!isEmptyOrNullOrNone(fieldName1)){
queryPart2 = queryPart2+' AND ';
queryPart2 = queryPart2+' Name ';
queryPart2 = queryPart2+' LIKE ';
queryPart2 = queryPart2+'\'';
queryPart2 = queryPart2+'%';    
queryPart2 = queryPart2+fieldName1;
queryPart2 = queryPart2+'%';
queryPart2 = queryPart2+'\'';
}

if(!isEmptyOrNullOrNone(fieldName2)){
queryPart2 = queryPart2+' AND ';
queryPart2 = queryPart2+' Mould_ID__c ';
queryPart2 = queryPart2+' LIKE ';
queryPart2 = queryPart2+'\''; 
queryPart2 = queryPart2+'%';
queryPart2 = queryPart2+fieldName2;
queryPart2 = queryPart2+'%';
queryPart2 = queryPart2+'\''; 
}

if(!isEmptyOrNullOrNone(fieldName3)){
queryPart2 = queryPart2+' AND ';
queryPart2 = queryPart2+' Model__c ';
queryPart2 = queryPart2+' LIKE ';
queryPart2 = queryPart2+'\''; 
queryPart2 = queryPart2+'%';
queryPart2 = queryPart2+fieldName3;
queryPart2 = queryPart2+'%';
queryPart2 = queryPart2+'\''; 
}

if(!isEmptyOrNullOrNone(fieldName4)){
queryPart2 = queryPart2+' AND ';
queryPart2 = queryPart2+' Cavity__c ';
queryPart2 = queryPart2+' = ';
//queryPart2 = queryPart2+'\''; 
queryPart2 = queryPart2+fieldName4;
//queryPart2 = queryPart2+'%';
//queryPart2 = queryPart2+'\''; 
}

if(!isEmptyOrNullOrNone(fieldName5)){
queryPart2 = queryPart2+' AND ';
queryPart2 = queryPart2+' Original_Brand__c ';
queryPart2 = queryPart2+' LIKE ';
queryPart2 = queryPart2+'\'';
queryPart2 = queryPart2+'%'; 
queryPart2 = queryPart2+fieldName5;
queryPart2 = queryPart2+'%';
queryPart2 = queryPart2+'\''; 
}

if(!isEmptyOrNullOrNone(fieldName6)){
queryPart2 = queryPart2+' AND ';
queryPart2 = queryPart2+' Engraved_Logo__c ';
queryPart2 = queryPart2+' LIKE ';
queryPart2 = queryPart2+'\''; 
queryPart2 = queryPart2+'%';
queryPart2 = queryPart2+fieldName6;
queryPart2 = queryPart2+'%';
queryPart2 = queryPart2+'\''; 
}

if(!isEmptyOrNullOrNone(fieldName7)){
queryPart2 = queryPart2+' AND ';
queryPart2 = queryPart2+' Country__c ';
queryPart2 = queryPart2+' LIKE ';
queryPart2 = queryPart2+'\''; 
queryPart2 = queryPart2+'%';
queryPart2 = queryPart2+fieldName7;
queryPart2 = queryPart2+'%';
queryPart2 = queryPart2+'\''; 
}

if(!isEmptyOrNullOrNone(fieldName8)){
queryPart2 = queryPart2+' AND ';
queryPart2 = queryPart2+' Factory_Name__c ';
queryPart2 = queryPart2+' LIKE ';
queryPart2 = queryPart2+'\''; 
queryPart2 = queryPart2+'%';
queryPart2 = queryPart2+fieldName8;
queryPart2 = queryPart2+'%';
queryPart2 = queryPart2+'\''; 
}

if(!isEmptyOrNullOrNone(fieldName9)){
queryPart2 = queryPart2+' AND ';
queryPart2 = queryPart2+' Holder_Company__c ';
queryPart2 = queryPart2+' LIKE ';
queryPart2 = queryPart2+'\''; 
queryPart2 = queryPart2+'%';
queryPart2 = queryPart2+fieldName9;
queryPart2 = queryPart2+'%';
queryPart2 = queryPart2+'\''; 
}

if(!isEmptyOrNullOrNone(fieldName10)){
queryPart2 = queryPart2+' AND ';
queryPart2 = queryPart2+' Owner_Company__c ';
queryPart2 = queryPart2+' LIKE ';
queryPart2 = queryPart2+'\''; 
queryPart2 = queryPart2+'%';
queryPart2 = queryPart2+fieldName10;
queryPart2 = queryPart2+'%';
queryPart2 = queryPart2+'\''; 
}

if(!isEmptyOrNullOrNone(fieldName11)){
queryPart2 = queryPart2+' AND ';
queryPart2 = queryPart2+' Mould_Usability__c ';
queryPart2 = queryPart2+' LIKE ';
queryPart2 = queryPart2+'\''; 
queryPart2 = queryPart2+'%';
queryPart2 = queryPart2+fieldName11;
queryPart2 = queryPart2+'%';
queryPart2 = queryPart2+'\''; 
}

if(!isEmptyOrNullOrNone(fieldName12)){
queryPart2 = queryPart2+' AND ';
queryPart2 = queryPart2+' Mould_Condition__c ';
queryPart2 = queryPart2+' LIKE ';
queryPart2 = queryPart2+'\''; 
queryPart2 = queryPart2+'%';
queryPart2 = queryPart2+fieldName12;
queryPart2 = queryPart2+'%';
queryPart2 = queryPart2+'\''; 
}

if(!isEmptyOrNullOrNone(fieldName13)){
queryPart2 = queryPart2+' AND ';
queryPart2 = queryPart2+' Mould_Type__c ';
queryPart2 = queryPart2+' LIKE ';
queryPart2 = queryPart2+'\''; 
queryPart2 = queryPart2+'%';
queryPart2 = queryPart2+fieldName13;
queryPart2 = queryPart2+'%';
queryPart2 = queryPart2+'\''; 
}

if(!isEmptyOrNullOrNone(fieldName14)){
queryPart2 = queryPart2+' AND ';
queryPart2 = queryPart2+' Product_Type__c ';
queryPart2 = queryPart2+' LIKE ';
queryPart2 = queryPart2+'\''; 
queryPart2 = queryPart2+'%';
queryPart2 = queryPart2+fieldName14;
queryPart2 = queryPart2+'%';
queryPart2 = queryPart2+'\''; 
}

if(!isEmptyOrNullOrNone(fieldName15)){
queryPart2 = queryPart2+' AND ';
queryPart2 = queryPart2+' Ref_Project_No__c ';
queryPart2 = queryPart2+' LIKE ';
queryPart2 = queryPart2+'\''; 
queryPart2 = queryPart2+'%';
queryPart2 = queryPart2+fieldName15;
queryPart2 = queryPart2+'%';
queryPart2 = queryPart2+'\''; 
}

return queryPart2;
}
public static Boolean isEmptyOrNullOrNone(String fieldName){
if(fieldName==null||fieldName.equals('')||fieldName.length()==0){
return true;
}else{
return false;
}

return false;
}
public Integer getMouldCountWithBuildQuery(){
        Integer totalRecordsCount=0;
        String queryStr = buildSOQLQuery(true);
        System.debug('Query String:'+queryStr);
         totalRecordsCount = Database.countQuery(queryStr);
            System.debug('####TotalSize####'+totalRecordsCount);
        return totalRecordsCount;
       }
public List<Mould__c> getBuildedMouldQuery(){
        List<Mould__c> moulds;
        String queryStr = buildSOQLQuery(false);
        queryStr = queryStr+' LIMIT '+list_size+' OFFSET '+counter;
        moulds = Database.query(queryStr);
        return moulds;
    }       
//Build SQL Query End

}