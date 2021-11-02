@isTest
public with sharing class GD_KamilSoapApiTest {

    @isTest
    static void testShouldGetHospitals() {
        soapSforceComSchemasClassHhrSoapse.HospitalDTO dto = new soapSforceComSchemasClassHhrSoapse.HospitalDTO();

        Test.startTest();
        Test.setMock(WebServiceMock.class, new GD_WebServiceMockImpl());
        List<soapSforceComSchemasClassHhrSoapse.HospitalDTO> hospitalsDtos = GD_KamilSoapApi.searchHospitalsResponse(dto);
        Test.stopTest();

        System.assertEquals('Szpital Rejonowy', hospitalsDtos[0].hospitalName);
        System.assertEquals('Szczecin', hospitalsDtos[0].city);
    }

    @isTest
    static void testShouldCreateHospital() {

        Hospital__c hospital = new Hospital__c();

        Test.startTest();
        Test.setMock(WebServiceMock.class, new GD_WebServiceMockImpl());
        List<soapSforceComSchemasClassHhrSoapse.HospitalDTO> hospitalsDTOs = GD_KamilSoapApi.addNewHospitalResponse(hospital);
        Test.stopTest();

        System.assertEquals('Szpital Rejonowy', hospitalsDTOs[0].hospitalName);
        System.assertEquals('Szczecin', hospitalsDTOs[0].city);
    }

    @isTest
    static void testShouldUpdateHospital() {

        Hospital__c hospital = new Hospital__c();

        Test.startTest();
        Test.setMock(WebServiceMock.class, new GD_WebServiceMockImpl());
        List<soapSforceComSchemasClassHhrSoapse.HospitalDTO> hospitalsDTOs = GD_KamilSoapApi.updateHospitalResponse(hospital);
        Test.stopTest();

        System.assertEquals('Szpital Rejonowy', hospitalsDTOs[0].hospitalName);
        System.assertEquals('Szczecin', hospitalsDTOs[0].city);
    }

    @isTest
    static void testShouldDeleteHospital() {

        List<Id> idsToDelete = new List<Id>();

        Test.startTest();
        Test.setMock(WebServiceMock.class, new GD_WebServiceMockImpl());
        soapSforceComSchemasClassHhrSoapse.SOAPResponse response = GD_KamilSoapApi.deleteHospitalResponse(idsToDelete);
        Test.stopTest();
        System.assertEquals('Success Operation', response.error);
    }

    @isTest
    static void testShouldReturnRequiredFieldMissingError() {

        Hospital__c hospital = new Hospital__c();
        String errorMessage;

        try {
            Test.startTest();
            Test.setMock(WebServiceMock.class, new GD_WebServiceMockImpl('ERROR'));
            soapSforceComSchemasClassHhrSoapse.SOAPResponse resp = new soapSforceComSchemasClassHhrSoapse.SOAPResponse();
            List<soapSforceComSchemasClassHhrSoapse.HospitalDTO> hospitalsDTOs = GD_KamilSoapApi.addNewHospitalResponse(hospital);
            Test.stopTest();
        } catch (Exception e) {
            errorMessage = e.getMessage();
        } finally {
            System.assertEquals(System.Label.Fill_all_required_fields + ' (*)', errorMessage);
        }
    }
}