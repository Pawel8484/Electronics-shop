/**
 * Created by BRITENET on 29.09.2021.
 */

@IsTest
private class GD_SearchHospitalsSoapAppControllerTest {

    @isTest
    static void testShouldGetHospitals() {

        GD_SearchHospitalsSoapAppController kamilSoapApi = new GD_SearchHospitalsSoapAppController(null);
        kamilSoapApi.name = '';
        kamilSoapApi.street = '';
        kamilSoapApi.city = '';
        kamilSoapApi.country = '';

        Test.startTest();
        Test.setMock(WebServiceMock.class, new GD_WebServiceMockImpl());
        List<Hospital__c> hospitals = kamilSoapApi.searchHospitalsResponse();
        Test.stopTest();

        System.assertEquals('Szpital Rejonowy', hospitals[0].Name);
        System.assertEquals('Szczecin', hospitals[0].City__c);
    }

    @isTest
    static void testShouldCreateHospital() {

        GD_SearchHospitalsSoapAppController kamilSoapApi = new GD_SearchHospitalsSoapAppController(null);
        kamilSoapApi.name = '';
        kamilSoapApi.street = '';
        kamilSoapApi.city = '';
        kamilSoapApi.country = '';

        Test.startTest();
        Test.setMock(WebServiceMock.class, new GD_WebServiceMockImpl());
        List<soapSforceComSchemasClassHhrSoapse.HospitalDTO> hospitalsDTOs = kamilSoapApi.addNewHospitalResponse();
        Test.stopTest();
        System.debug('hospitals: ' + hospitalsDTOs[0]);

        System.assertEquals('Szpital Rejonowy', hospitalsDTOs[0].hospitalName);
        System.assertEquals('Szczecin', hospitalsDTOs[0].city);
    }

    @isTest
    static void testShouldUpdateHospital() {

        GD_SearchHospitalsSoapAppController kamilSoapApi = new GD_SearchHospitalsSoapAppController(null);

        Test.startTest();
        Test.setMock(WebServiceMock.class, new GD_WebServiceMockImpl());
        List<soapSforceComSchemasClassHhrSoapse.HospitalDTO> hospitalsDTOs = kamilSoapApi.updateHospitalResponse();
        Test.stopTest();

        System.assertEquals('Szpital Rejonowy', hospitalsDTOs[0].hospitalName);
        System.assertEquals('Szczecin', hospitalsDTOs[0].city);
    }

    @isTest
    static void testShouldDeleteHospital() {

        GD_SearchHospitalsSoapAppController kamilSoapApi = new GD_SearchHospitalsSoapAppController(null);
        kamilSoapApi.name = '';
        kamilSoapApi.street = '';
        kamilSoapApi.city = '';
        kamilSoapApi.country = '';

        Test.startTest();
        Test.setMock(WebServiceMock.class, new GD_WebServiceMockImpl());
        soapSforceComSchemasClassHhrSoapse.SOAPResponse response = kamilSoapApi.deleteHospitalResponse();
        Test.stopTest();
        System.assertEquals('Success Operation', response.error);
    }

    @isTest
    static void testFlagChanges(){
        GD_SearchHospitalsSoapAppController GD_SearchHospitalsSoapAppController = new GD_SearchHospitalsSoapAppController(null);
        GD_SearchHospitalsSoapAppController.hospital = new Hospital__c();
        GD_SearchHospitalsSoapAppController.hospital.Name = 'HospitalTest';

        GD_SearchHospitalsSoapAppController.changeFlag();
        GD_SearchHospitalsSoapAppController.changeFlag2();
        GD_SearchHospitalsSoapAppController.changeFlag3();
        GD_SearchHospitalsSoapAppController.openDeleteHospitalConfirmationWindow();

        System.assertEquals(false, GD_SearchHospitalsSoapAppController.recordUpdated, 'recordUpdated should be false but actual true');
        System.assertEquals(false, GD_SearchHospitalsSoapAppController.recordAdded, 'recordAdded should be false but actual true');
        System.assertEquals(false, GD_SearchHospitalsSoapAppController.recordDeleted, 'recordDeleted should be false but actual true');
        System.assertEquals(true, GD_SearchHospitalsSoapAppController.deleteHospitalPopup);
    }
}