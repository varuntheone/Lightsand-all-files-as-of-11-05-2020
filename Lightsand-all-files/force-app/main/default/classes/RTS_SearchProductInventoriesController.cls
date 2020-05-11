public with sharing class RTS_SearchProductInventoriesController {

    public pageReference redirect() {

        PageReference redirectAddress = new PageReference(
            String.valueOf(URL.getSalesforceBaseUrl().toExternalForm())
          + System.Label.RTS_SearchProductInventoryUrl
        );

        redirectAddress.setRedirect(true);
        return redirectAddress;

    }

}