@isTest
public with sharing class GD_KamilRestApiTest {

    @isTest
    static void testShouldGetDoctors() {

        GD_KamilRestApi kamilRestApi = new GD_KamilRestApi(null);
        HttpResponse res;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GD_MockHttpResponseGenerator('GET'));
        res = kamilRestApi.getRestDoctorsResponse();
        Test.stopTest();

        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        GD_KamilRestApi.DoctorWrap doctorsResult = (GD_KamilRestApi.DoctorWrap) JSON.deserialize(actualValue, GD_KamilRestApi.DoctorWrap.class);
        System.assertEquals('Jan', doctorsResult.results[0].firstName);
        System.assertEquals('Jankowski', doctorsResult.results[0].lastName);
        System.assertEquals('Chirurg', doctorsResult.results[0].speciality);
        System.assertEquals(200, res.getStatusCode());
    }

    @isTest
    static void testShouldGetDoctorsWithError() {

        GD_KamilRestApi kamilRestApi = new GD_KamilRestApi(null);
        HttpResponse res;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GD_MockHttpResponseGenerator('GET').withError());
        res = kamilRestApi.getRestDoctorsResponse();
        Test.stopTest();

        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        System.assertEquals(500, res.getStatusCode());
    }

    @isTest
    static void testShouldInsertDoctor() {
        GD_KamilRestApi kamilRestApi = new GD_KamilRestApi(null);
        HttpResponse res;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GD_MockHttpResponseGenerator('POST'));
        res = kamilRestApi.postRestDoctorResponse();
        Test.stopTest();

        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        GD_KamilRestApi.DoctorWrap doctorsResult = (GD_KamilRestApi.DoctorWrap) JSON.deserialize(actualValue, GD_KamilRestApi.DoctorWrap.class);
        System.assertEquals('a000900000Gjb2pAAB', doctorsResult.results[0].id);
        System.assertEquals('Jan', doctorsResult.results[0].firstName);
        System.assertEquals('Jankowski', doctorsResult.results[0].lastName);
        System.assertEquals('Chirurg', doctorsResult.results[0].speciality);
        System.assertEquals(200, res.getStatusCode());
    }

    @isTest
    static void testShouldInsertDoctorWithError() {
        GD_KamilRestApi kamilRestApi = new GD_KamilRestApi(null);
        HttpResponse res;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GD_MockHttpResponseGenerator('POST').withError());
        res = kamilRestApi.postRestDoctorResponse();
        Test.stopTest();

        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        GD_KamilRestApi.DoctorWrap doctorsResult = (GD_KamilRestApi.DoctorWrap) JSON.deserialize(actualValue, GD_KamilRestApi.DoctorWrap.class);
        System.assertEquals('INVALID_EMAIL_ADDRESS', doctorsResult.error);
        System.assertEquals(500, res.getStatusCode());
    }

    @isTest
    static void testShouldUpdateDoctor() {
        GD_KamilRestApi kamilRestApi = new GD_KamilRestApi(null);
        HttpResponse res;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GD_MockHttpResponseGenerator('PUT'));
        res = kamilRestApi.putRestDoctorResponse('');
        Test.stopTest();

        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        GD_KamilRestApi.DoctorWrap doctorsResult = (GD_KamilRestApi.DoctorWrap) JSON.deserialize(actualValue, GD_KamilRestApi.DoctorWrap.class);
        System.assertEquals('Jan', doctorsResult.results[0].firstName);
        System.assertEquals('Jankowski', doctorsResult.results[0].lastName);
        System.assertEquals('Chirurg', doctorsResult.results[0].speciality);
        System.assertEquals(200, res.getStatusCode());
    }

    @isTest
    static void testShouldUpdateDoctorWithError() {
        GD_KamilRestApi kamilRestApi = new GD_KamilRestApi(null);
        HttpResponse res;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GD_MockHttpResponseGenerator('PUT').withError());
        res = kamilRestApi.putRestDoctorResponse('');
        Test.stopTest();

        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        GD_KamilRestApi.DoctorWrap doctorsResult = (GD_KamilRestApi.DoctorWrap) JSON.deserialize(actualValue, GD_KamilRestApi.DoctorWrap.class);
        System.assertEquals('INVALID_EMAIL_ADDRESS', doctorsResult.error);
        System.assertEquals(500, res.getStatusCode());
    }

    @isTest
    static void testShouldDeleteDoctor() {
        GD_KamilRestApi kamilRestApi = new GD_KamilRestApi(null);
        HttpResponse res;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GD_MockHttpResponseGenerator('DELETE'));
        res = kamilRestApi.deleteRestDoctorResponse();
        Test.stopTest();

        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = 'true';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
    }
}