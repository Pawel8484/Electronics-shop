@isTest
public class CalloutClassTest {
    @isTest static void testCallout() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock.
        HttpResponse res = CalloutClass.getInfoFromExternalService();

        // Verify response received contains fake values
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"results": [{"street": "Kręta 21","startOfCareer": null,"speciality": "Chirurg","postalCode": "0","phone": "888458478","licenseNumber": 25447321,"lastName": "Jankowski","id": "a000900000Gjb2pAAB","firstName": "Jan","email": "jj@wp.pl","dateOfBirth": "1978-09-20","country": "Polska","city": "Poznań"}],"error": ""}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
    }
}