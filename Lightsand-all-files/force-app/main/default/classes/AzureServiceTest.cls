@IsTest(SeeAllData = true)
public class AzureServiceTest {
     @IsTest(SeeAllData=true) 
    public static void initilizeRecords() {
        AzureService.azureWrapper aw = AzureService.storageDetails();
     }
}