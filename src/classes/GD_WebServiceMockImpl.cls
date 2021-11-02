@isTest
global class GD_WebServiceMockImpl implements WebServiceMock {

    private String input;

    public GD_WebServiceMockImpl() {
    }

    public GD_WebServiceMockImpl(String input) {
        this.input = input;
    }

    global void doInvoke(Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) {
        soapSforceComSchemasClassHhrSoapse.HospitalDTO dto = new soapSforceComSchemasClassHhrSoapse.HospitalDTO();
        dto.hospitalName = 'Szpital Rejonowy';
        dto.phone = '883 221 223';
        dto.street = 'Leśna 28';
        dto.city = 'Szczecin';
        dto.country = 'Polska';

        if (requestName == 'login') {
            partnerSoapSforceCom.loginResponse_element loginResponse_element = new partnerSoapSforceCom.loginResponse_element();
            partnerSoapSforceCom.LoginResult loginResult = new partnerSoapSforceCom.LoginResult();
            loginResult.sessionId = 'aaaaa';
            loginResponse_element.result = loginResult;
            response.put('response_x', loginResponse_element);
            return;
        }

        if (input == 'ERROR') {
            soapSforceComSchemasClassHhrSoapse.SOAPResponse responseWrapper = new soapSforceComSchemasClassHhrSoapse.SOAPResponse();
            List<soapSforceComSchemasClassHhrSoapse.HospitalDTO> wrapper = new List<soapSforceComSchemasClassHhrSoapse.HospitalDTO>();

            if (requestName == 'addHospitals') {
                soapSforceComSchemasClassHhrSoapse.addHospitalsResponse_element responseElement = new soapSforceComSchemasClassHhrSoapse.addHospitalsResponse_element();
                soapSforceComSchemasClassHhrSoapse.SOAPResponse resp = new soapSforceComSchemasClassHhrSoapse.SOAPResponse();
                resp.error = 'REQUIRED_FIELD_MISSING';
                responseElement.result = resp;
                response.put('response_x', responseElement);
            }
        } else {
            soapSforceComSchemasClassHhrSoapse.SOAPResponse responseWrapper = new soapSforceComSchemasClassHhrSoapse.SOAPResponse();
            List<soapSforceComSchemasClassHhrSoapse.HospitalDTO> wrapper = new List<soapSforceComSchemasClassHhrSoapse.HospitalDTO>{
                    dto
            };
            responseWrapper.error = 'Success Operation';
            responseWrapper.hospitalsDTO = wrapper;
            if (requestName == 'getHospitalsByParameters') {
                soapSforceComSchemasClassHhrSoapse.getHospitalsByParametersResponse_element responseElement = new soapSforceComSchemasClassHhrSoapse.getHospitalsByParametersResponse_element();
                responseElement.result = responseWrapper;
                response.put('response_x', responseElement);
            }

            if (requestName == 'addHospitals') {
                soapSforceComSchemasClassHhrSoapse.addHospitalsResponse_element responseElement = new soapSforceComSchemasClassHhrSoapse.addHospitalsResponse_element();
                responseElement.result = responseWrapper;
                response.put('response_x', responseElement);
            }

            if (requestName == 'updateHospital') {
                soapSforceComSchemasClassHhrSoapse.updateHospitalResponse_element responseElement = new soapSforceComSchemasClassHhrSoapse.updateHospitalResponse_element();
                responseElement.result = responseWrapper;
                response.put('response_x', responseElement);
            }

            if (requestName == 'deleteHospitals') {
                soapSforceComSchemasClassHhrSoapse.deleteHospitalsResponse_element responseElement = new soapSforceComSchemasClassHhrSoapse.deleteHospitalsResponse_element();
                soapSforceComSchemasClassHhrSoapse.SOAPResponse resp = new soapSforceComSchemasClassHhrSoapse.SOAPResponse();
                resp.error = 'Success Operation';
                responseElement.result = resp;
                response.put('response_x', responseElement);
            }
        }
    }
}