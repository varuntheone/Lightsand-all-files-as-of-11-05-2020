@IsTest public class DetailDisplayTest{
    @IsTest(SeeAllData=true) public static void testDetailDisplayTest() {
        DetailDisplay detailDisp = new DetailDisplay();
        detailDisp.model = '313';
        detailDisp.color = 'RED';
        detailDisp.descreption = '17 and odd';
        detailDisp.productType = 'HANGERS';
        detailDisp.productFamily = 'HANGERS';
        detailDisp.qty = '100';
        detailDisp.retailerCodeName = 'JC PENNY';
        detailDisp.modelRemark = 'Remark';
    }
}