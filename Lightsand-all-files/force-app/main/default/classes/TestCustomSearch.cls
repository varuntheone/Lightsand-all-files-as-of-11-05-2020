@isTest
public class TestCustomSearch{
      
    static testMethod void testPositiveScenario() {
     
         SearchFrontControllerWithPagination sf = new SearchFrontControllerWithPagination();
         sf.setFieldName1('abc');
         sf.setFieldName2('efg');
         sf.setFieldName3('efg');
         sf.setFieldName4('12');
         sf.setFieldName5('efg');
         sf.setFieldName6('efg');
         sf.setFieldName7('efg');
         sf.setFieldName8('efg');
         sf.setFieldName9('efg');
         sf.setFieldName10('efg');
         sf.setFieldName11('efg');
         sf.setFieldName12('efg');
         sf.setFieldName13('efg');
         sf.setFieldName14('efg');
         sf.setFieldName15('efg');
         sf.search();
         sf.setFieldName1(sf.getFieldName1());
         sf.setFieldName2(sf.getFieldName2());
         sf.setFieldName3(sf.getFieldName3());
         sf.setFieldName4(sf.getFieldName4());
         sf.setFieldName5(sf.getFieldName5());
         sf.setFieldName6(sf.getFieldName6());
         sf.setFieldName7(sf.getFieldName7());
         sf.setFieldName8(sf.getFieldName8());
         sf.setFieldName9(sf.getFieldName9());
         sf.setFieldName10(sf.getFieldName10());
         sf.setFieldName11(sf.getFieldName11());
         sf.setFieldName12(sf.getFieldName12());
         sf.setFieldName13(sf.getFieldName13());
         sf.setFieldName14(sf.getFieldName14());
         sf.setFieldName15(sf.getFieldName15());
         sf.search();
        // sf.search();
       //  sf.search();
       sf.getTotalRecordsInCurrentPage();
       sf.getCounter();
       sf.getList_size();
       sf.getErrorForFieldName1();
       sf.getNoOfRows();
       List<SearchFrontControllerWithPagination.DisplaySearchProperties> dispSear = new List<SearchFrontControllerWithPagination.DisplaySearchProperties>();
      // List<DisplaySearchProperties> tempsearchResList = new List<DisplaySearchProperties>();
       sf.setNoOfRows(dispSear );
       
       sf.getOriginalBrand();
       sf.getEngravedLogo();
       sf.getCountry();
       sf.getFactory();
       sf.getHolderCompany();
       sf.getOwnerCompany();
       sf.getMouldUsablity();
       sf.getMouldCondition();
       sf.getMouldType();
       sf.getProductType();
       
       sf.Beginning();
      // sf.Next();
       //sf.Previous();
       sf.End();
       sf.getDisablePrevious();
       sf.getDisableNext();
       sf.getTotal_size();
       sf.getPageNumber();
       sf.getTotalPages();
       
       //Part 2 Start
       
       SearchFrontControllerWithPagination.DisplaySearchProperties displaySearchProp = new SearchFrontControllerWithPagination.DisplaySearchProperties();
       displaySearchProp.setName('Test');
displaySearchProp.setId('Id');
displaySearchProp.setModel('ModelTest');

displaySearchProp.setStatus('StatusTest');

displaySearchProp.setCavity(12);
displaySearchProp.setOriginalBrand('OriginalBrandTest');
displaySearchProp.setEngravedLogo('Eng Logo Test');
displaySearchProp.setCountry('India test');
displaySearchProp.setFactory('Factory Name Test');
displaySearchProp.setHolderCompany('Company Name Test');
displaySearchProp.setOwnerCompany('Owner Company test');
displaySearchProp.setMouldUsability('Mould Usability test');
displaySearchProp.setMouldCondition('Mould Condition test');
displaySearchProp.setMouldType('Mould Type test');
displaySearchProp.setProductType('Product Type test');
displaySearchProp.setRefProjectNo('Ref Proj No Test');

displaySearchProp.getName();
displaySearchProp.getId();
displaySearchProp.getModel();

displaySearchProp.getStatus();

displaySearchProp.getCavity();
displaySearchProp.getOriginalBrand();
displaySearchProp.getEngravedLogo();
displaySearchProp.getCountry();
displaySearchProp.getFactory();
displaySearchProp.getHolderCompany();
displaySearchProp.getOwnerCompany();
displaySearchProp.getMouldUsability();
displaySearchProp.getMouldCondition();
displaySearchProp.getMouldType();
displaySearchProp.getProductType();
displaySearchProp.getRefProjectNo();
       
       
       
        
    }
    static testMethod void testNegativeScenario() {
         SearchFrontControllerWithPagination sf = new SearchFrontControllerWithPagination();
        sf.search();
    }

}