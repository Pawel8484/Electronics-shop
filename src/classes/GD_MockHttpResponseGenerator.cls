public with sharing class GD_MockHttpResponseGenerator implements HttpCalloutMock {
    private static final Map<String, MockedResponse> RESULTS = new Map<String, MockedResponse>{
            'GET' => new MockedResponse().asGet(),
            'POST' => new MockedResponse().asPost(),
            'PUT' => new MockedResponse().asPut(),
            'DELETE' => new MockedResponse().asDelete()
    };

    private static final Map<String, MockedResponse> ERROR_RESULTS = new Map<String, MockedResponse>{
            'GET' => new MockedResponse().asGet(),
            'POST' => new MockedResponse().asPost().withError(),
            'PUT' => new MockedResponse().asPut().withError()
    };

    private String method;
    private Boolean hasError = false;

    public GD_MockHttpResponseGenerator(String method) {
        this.method = method;
    }

    public GD_MockHttpResponseGenerator withError() {
        this.hasError = true;
        return this;
    }

    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');

        MockedResponse mockedResp;
        if (hasError) {
            res.setStatusCode(500);
            mockedResp = ERROR_RESULTS.get(method);
        } else {
            res.setStatusCode(200);
            mockedResp = RESULTS.get(method);
        }
        res.setBody(mockedResp.getResponse());
        return res;
    }

    public class MockedResponse {
        GD_KamilRestApi.DoctorWrap doctorResponse;
        String deleteResponse;

        public String getResponse() {
            return String.isEmpty(deleteResponse) ? JSON.serialize(doctorResponse) : deleteResponse;
        }

        public MockedResponse asGet() {
            List<GD_KamilRestApi.DoctorWrapper> doctorWrappers = new List<GD_KamilRestApi.DoctorWrapper>();
            doctorWrappers.add(createDoctorWrapper());
            doctorResponse = new GD_KamilRestApi.DoctorWrap(null, doctorWrappers);
            return this;
        }

        public MockedResponse asPost() {
            List<GD_KamilRestApi.DoctorWrapper> doctorWrappers = new List<GD_KamilRestApi.DoctorWrapper>();
            doctorWrappers.add(createDoctorWrapper());
            doctorResponse = new GD_KamilRestApi.DoctorWrap(null, doctorWrappers);
            return this;
        }

        public MockedResponse asPut() {
            List<GD_KamilRestApi.DoctorWrapper> doctorWrappers = new List<GD_KamilRestApi.DoctorWrapper>();
            doctorWrappers.add(createDoctorWrapper());
            doctorResponse = new GD_KamilRestApi.DoctorWrap(null, doctorWrappers);
            return this;
        }

        public MockedResponse asDelete() {
            deleteResponse = 'true';
            return this;
        }

        public MockedResponse withError() {
            doctorResponse.error = 'INVALID_EMAIL_ADDRESS';
            return this;
        }

        private GD_KamilRestApi.DoctorWrapper createDoctorWrapper() {
            GD_KamilRestApi.DoctorWrapper wrapper = new GD_KamilRestApi.DoctorWrapper();
            wrapper.id = 'a000900000Gjb2pAAB';
            wrapper.firstName = 'Jan';
            wrapper.lastName = 'Jankowski';
            wrapper.speciality = 'Chirurg';
            return wrapper;
        }
    }
}