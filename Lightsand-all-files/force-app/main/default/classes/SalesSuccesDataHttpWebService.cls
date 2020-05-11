@isTest
public class SalesSuccesDataHttpWebService implements HttpCalloutMock {
    
    public static HttpResponse respond (HTTPRequest request)
    {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        String json=		'{'+
		'  "valid": true,'+
		'  "number": "14158586273",'+
		'  "local_format": "4158586273",'+
		'  "international_format": "+14158586273",'+
		'  "country_prefix": "+1",'+
		'  "country_code": "US",'+
		'  "country_name": "United States of America",'+
		'  "location": "Novato",'+
		'  "carrier": "AT&T Mobility LLC",'+
		'  "line_type": "mobile"'+
		'}      ';
        res.setBody(json);
        res.setStatusCode(200);
        return res;

    }

}