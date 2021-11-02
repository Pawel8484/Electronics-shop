public with sharing class GD_KamilSoapApi {
    private static final String GENERIC_ERROR_MESSAGE = 'Server error';

    public static List<soapSforceComSchemasClassHhrSoapse.HospitalDTO> searchHospitalsResponse(soapSforceComSchemasClassHhrSoapse.HospitalDTO dto) {
        soapSforceComSchemasClassHhrSoapse.HHR_SOAPService hospitalApi = connect();
        soapSforceComSchemasClassHhrSoapse.SOAPResponse responseSearchHospitals = hospitalApi.getHospitalsByParameters(dto);
        return responseSearchHospitals.hospitalsDTO;
    }

    public static List<soapSforceComSchemasClassHhrSoapse.HospitalDTO> addNewHospitalResponse(Hospital__c hospitalToPost) {
        soapSforceComSchemasClassHhrSoapse.HHR_SOAPService hospitalApi = connect();

        List<soapSforceComSchemasClassHhrSoapse.HospitalDTO> dtoList = new List<soapSforceComSchemasClassHhrSoapse.HospitalDTO>();
        soapSforceComSchemasClassHhrSoapse.HospitalDTO dto = new soapSforceComSchemasClassHhrSoapse.HospitalDTO();
        dto = wrapHospital(hospitalToPost);
        dtoList.add(dto);

        soapSforceComSchemasClassHhrSoapse.SOAPResponse response = hospitalApi.addHospitals(dtoList);

        if (response.error != 'Success Operation') {
            handleError(response.error);
        }
        return response.hospitalsDTO;
    }

    public static List<soapSforceComSchemasClassHhrSoapse.HospitalDTO> updateHospitalResponse(Hospital__c hospitalToUpdate) {
        soapSforceComSchemasClassHhrSoapse.HHR_SOAPService hospitalApi = connect();

        List<soapSforceComSchemasClassHhrSoapse.HospitalDTO> dtoListToUpdate = new List<soapSforceComSchemasClassHhrSoapse.HospitalDTO>();
        soapSforceComSchemasClassHhrSoapse.HospitalDTO dtoToUpdate = new soapSforceComSchemasClassHhrSoapse.HospitalDTO();
        dtoToUpdate = wrapHospitalToUpdate(hospitalToUpdate);
        dtoListToUpdate.add(dtoToUpdate);

        soapSforceComSchemasClassHhrSoapse.SOAPResponse response = hospitalApi.updateHospital(dtoListToUpdate);

        if (response.error != 'Success Operation') {
            handleError(response.error);
        }
        return response.hospitalsDTO;
    }

    public static soapSforceComSchemasClassHhrSoapse.SOAPResponse deleteHospitalResponse(List<Id> idsToDelete) {
        soapSforceComSchemasClassHhrSoapse.HHR_SOAPService hospitalApi = connect();
        soapSforceComSchemasClassHhrSoapse.SOAPResponse response = hospitalApi.deleteHospitals(idsToDelete);
        return response;
    }

    private static soapSforceComSchemasClassHhrSoapse.HHR_SOAPService connect() {
        partnerSoapSforceCom.LoginResult partnerLoginResult = login();
        soapSforceComSchemasClassHhrSoapse.sessionHeader_element sessionObj = new soapSforceComSchemasClassHhrSoapse.sessionHeader_element();
        sessionObj.sessionId = partnerLoginResult.sessionId;
        soapSforceComSchemasClassHhrSoapse.HHR_SOAPService hospitalApi = new soapSforceComSchemasClassHhrSoapse.HHR_SOAPService();
        hospitalApi.SessionHeader = sessionObj;
        return hospitalApi;
    }

    private static partnerSoapSforceCom.LoginResult login() {
        partnerSoapSforceCom.LoginResult partnerLoginResult;
        if (Test.isRunningTest()) {
            DoctorApp__c setting = DoctorApp__c.getInstance();
            String username = 'abcd1234';
            String password = 'abcd1234';
            partnerSoapSforceCom.Soap myPartnerSoap = new partnerSoapSforceCom.Soap();
            partnerLoginResult = myPartnerSoap.login(username, password);
        } else {
            DoctorApp__c setting = DoctorApp__c.getInstance();
            String username = setting.Username__c;
            String password = setting.Password__c;
            partnerSoapSforceCom.Soap myPartnerSoap = new partnerSoapSforceCom.Soap();
            partnerLoginResult = myPartnerSoap.login(username, password);
        }
        return partnerLoginResult;
    }

    private static void handleError(String error) {
        String errorMessage = GENERIC_ERROR_MESSAGE;

        if (error.contains('REQUIRED_FIELD_MISSING')) {
            errorMessage = System.Label.Fill_all_required_fields + ' (*)';
        }
        if (error.contains('NoRecord With Id')) {
            errorMessage = System.Label.record_doesn_t_exist;
        }
        throw new KamilSoapApiException(errorMessage);
    }

    private static soapSforceComSchemasClassHhrSoapse.HospitalDTO wrapHospital(Hospital__c hospitalToPost) {
        return createHospitalDTO(hospitalToPost);
    }

    private static soapSforceComSchemasClassHhrSoapse.HospitalDTO wrapHospitalToUpdate(Hospital__c hospitalToUpdate) {
        return createHospitalDTO(hospitalToUpdate);
    }

    private static soapSforceComSchemasClassHhrSoapse.HospitalDTO createHospitalDTO(Hospital__c hospital){
        soapSforceComSchemasClassHhrSoapse.HospitalDTO hospitalDTO = new soapSforceComSchemasClassHhrSoapse.HospitalDTO();
        hospitalDTO.hospitalName = hospital.Name;
        hospitalDTO.ambulanceNumber = hospital.No_Ambulances__c;
        hospitalDTO.phone = hospital.Phone_Number__c;
        hospitalDTO.fax = hospital.Fax_Number__c;
        hospitalDTO.street = hospital.Street__c;
        hospitalDTO.city = hospital.City__c;
        hospitalDTO.country = hospital.Country__c;
        hospitalDTO.helicopterAccess = hospital.Helicopter_Access__c;
        hospitalDTO.hospitalId = hospital.External_Id__c;
        return hospitalDTO;
    }

    private class KamilSoapApiException extends Exception {}
}