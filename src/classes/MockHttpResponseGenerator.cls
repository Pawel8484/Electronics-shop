@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock{

    global HTTPResponse respond(HTTPRequest req) {
        System.assertEquals('http://example.com/example/test', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"results": [{"street": "Kręta 21","startOfCareer": null,"speciality": "Chirurg","postalCode": "0","phone": "888458478","licenseNumber": 25447321,"lastName": "Jankowski","id": "a000900000Gjb2pAAB","firstName": "Jan","email": "jj@wp.pl","dateOfBirth": "1978-09-20","country": "Polska","city": "Poznań"}],"error": ""}');
        res.setStatusCode(200);
        return res;
    }
}