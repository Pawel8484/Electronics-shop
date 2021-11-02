global with sharing class GD_KamilRestApi {

    public List<Doctor__c> unwrapedDoctors { get; set; }
    public String name { get; set; }
    public String lastName { get; set; }
    public String email { get; set; }
    public String country { get; set; }
    public Doctor__c doctor { get; set; }
    public Boolean showResult { get; set; }
    public String errorMessage { get; set; }
    public String pageRefString = 'https://bri-dev-ed--c.visualforce.com/apex/GD_SearchDoctorsInKamilApp?sfdc.tabName=01r0900000058im';
    public Boolean newDoctorPopup { get; set; }

    public static HttpResponse res1;
    public Id doctorToUpdateId { get; set; }
    public Doctor__c doctorToUpdate { get; set; }
    public Doctor__c doctorToPost { get; set; }
    public Id doctorIdsel { get; set; }
    public Id doctorIdToDelete { get; set; }
    public Boolean showModal { get; set; }
    public Boolean recordUpdated { get; set; }
    public Boolean recordAdded { get; set; }
    public Boolean recordDeleted { get; set; }
    public Boolean showError { get; set; }
    public Boolean showNewDoctorError { get; set; }

    public GD_KamilRestApi(ApexPages.StandardController controller) {
        doctorToPost = new Doctor__c();
    }

    private static Oauth authorization() {
        HttpRequest req = new HttpRequest();
        DoctorApp__c setting = DoctorApp__c.getInstance();
        String username = setting.Username__c;
        String password = setting.Password__c;
        String clientId = setting.ClientId__c;
        String clientSecret = setting.ClientSecret__c;
        req.setEndpoint('https://britenet-3b-dev-ed.my.salesforce.com/services/oauth2/token?grant_type=password&client_id=' + clientId + '&client_secret=' + clientSecret + '&username=' + username + '&password=' + password);
        req.setMethod('POST');
        Http http = new Http();
        HttpResponse res = new HttpResponse();
        res = http.send(req);
        return Test.isRunningTest()?new Oauth():(Oauth) JSON.deserialize(res.getBody(), Oauth.class);
    }
    public void changeFlag() {
        recordUpdated = false;
    }

    public void changeFlag2() {
        recordAdded = false;
    }

    public void changeFlag3() {
        recordDeleted = false;
    }

    public void getRestDoctors() {
        getRestDoctorsResponse();
    }

    @TestVisible
    private HttpResponse getRestDoctorsResponse(){
        List<DoctorWrapper> doctorsList;
        Oauth objAuthInfo = authorization();
            HttpResponse res;
        if (objAuthInfo.access_token != null || Test.isRunningTest()) {
            HttpRequest req1 = new HttpRequest();
            PageReference pr = new PageReference('https://britenet-3b-dev-ed.my.salesforce.com/services/apexrest/Doctors/');
            Map<String, String> params = pr.getParameters();
            params.put('FirstName', name);
            params.put('LastName', lastName);
            params.put('Email', email);
            params.put('Country', country);
            req1.setEndpoint(pr.getUrl());
            req1.setMethod('GET');
            req1.setHeader('Content-Type', 'application/json');
            req1.setHeader('Authorization', 'Bearer ' + objAuthInfo.access_token);
            Http http1 = new Http();
            res = http1.send(req1);
            deserialize(res);
        }
        return res;
    }

    public void postRestDoctor(){
        postRestDoctorResponse();
    }

    @TestVisible
    private HttpResponse postRestDoctorResponse() {
        Oauth objAuthInfo = authorization();
            HttpResponse res = new HttpResponse();
        if (objAuthInfo.access_token != null || Test.isRunningTest()) {
            String jsonToPost = wrapDoctor();
            HttpRequest req1 = new HttpRequest();
            PageReference pr = new PageReference('https://britenet-3b-dev-ed.my.salesforce.com/services/apexrest/Doctors/');
            req1.setEndpoint(pr.getUrl());
            req1.setMethod('POST');
            req1.setHeader('Content-Type', 'application/json');
            req1.setHeader('Authorization', 'Bearer ' + objAuthInfo.access_token);
            req1.setBody(jsonToPost);
            Http http1 = new Http();
            res = http1.send(req1);
            DoctorWrap doctorWrap = (DoctorWrap) JSON.deserialize(res.getBody(), DoctorWrap.class);
            errorMessage = doctorWrap.error;
        }
        if (errorMessage == '' || errorMessage == null) {
            recordAdded = true;
            newDoctorPopup = false;
            showNewDoctorError = false;
            doctorToPost = new Doctor__c();

        } else {
            if (errorMessage.contains('INVALID_EMAIL_ADDRESS')) {
                errorMessage = 'Invalid email address';
            }
            if (errorMessage.contains('REQUIRED_FIELD_MISSING')) {
                errorMessage = 'Fill all required fields (*)';
            }
            if (errorMessage.contains('DUPLICATE_VALUE')) {
                errorMessage = 'Another Doctor already has the same license number';
            }
            showNewDoctorError = true;
        }
        closeNewDoctorWindow();
        return res;
    }

    public void putRestDoctor(){
        String jsonToPut = wrapDoctorToPut();
        putRestDoctorResponse(jsonToPut);
    }

    @TestVisible
    private HttpResponse putRestDoctorResponse(String jsonToPut) {
        HttpResponse res = new HttpResponse();
        Oauth objAuthInfo = authorization();
        if (objAuthInfo.access_token != null || Test.isRunningTest()) {
            HttpRequest req1 = new HttpRequest();
            PageReference pr = new PageReference('https://britenet-3b-dev-ed.my.salesforce.com/services/apexrest/Doctors/');
            req1.setEndpoint(pr.getUrl());
            req1.setMethod('PUT');
            req1.setHeader('Content-Type', 'application/json');
            req1.setHeader('Authorization', 'Bearer ' + objAuthInfo.access_token);
            req1.setBody(jsonToPut);
            Http http1 = new Http();
            res = http1.send(req1);

            DoctorWrap doctorWrap = (DoctorWrap) JSON.deserialize(res.getBody(), DoctorWrap.class);
            errorMessage = doctorWrap.error;
        }
        if (errorMessage == '' || errorMessage == null) {
            recordUpdated = true;
            showModal = false;
            showError = false;

        } else {
            if (errorMessage.contains('INVALID_EMAIL_ADDRESS')) {
                errorMessage = 'Invalid email address';
            }
            if (errorMessage.contains('REQUIRED_FIELD_MISSING')) {
                errorMessage = 'Fill all required fields (*)';
            }
            if (errorMessage.contains('DUPLICATE_VALUE')) {
                errorMessage = 'Another Doctor already has the same license number';
            }
            showError = true;
            currentPageReference();
        }
        return res;
    }

    public void deleteRestDoctor(){
        deleteRestDoctorResponse();
    }

    @TestVisible
    private HttpResponse deleteRestDoctorResponse() {
        String idToDelete = doctorIdToDelete;
        HttpResponse res = new HttpResponse();
        DoctorWrapper doctorWrapper = new DoctorWrapper(idToDelete);
        List<DoctorWrapper> doctorsListToDelete = new List<DoctorWrapper>();
        doctorsListToDelete.add(doctorWrapper);
        String jsonToDelete = JSON.serialize(doctorsListToDelete);

        Oauth objAuthInfo = authorization();
        if (objAuthInfo.access_token != null || Test.isRunningTest()) {
            HttpRequest req1 = new HttpRequest();
            PageReference pr = new PageReference('https://britenet-3b-dev-ed.my.salesforce.com/services/apexrest/Doctors/');
            req1.setEndpoint(pr.getUrl());
            req1.setMethod('DELETE');
            req1.setHeader('Content-Type', 'application/json');
            req1.setHeader('Authorization', 'Bearer ' + objAuthInfo.access_token);
            req1.setBody(jsonToDelete);
            Http http1 = new Http();
            res = new HttpResponse();
            res = http1.send(req1);

            String deleteAnswer = res.getBody();
            if (deleteAnswer == 'true') {
                recordDeleted = true;
            }
        }
        return res;
    }

    public PageReference clear() {
        PageReference newpage = new PageReference(System.currentPageReference().getURL());
        newpage.setRedirect(true);
        return newpage;
    }

    public void deserialize(HttpResponse res) {
        DoctorWrap doctorWrap;
        doctorWrap = (DoctorWrap) JSON.deserialize(res.getBody(), DoctorWrap.class);
        List<DoctorWrapper> docwrap = doctorWrap.results;
        errorMessage = doctorWrap.error;
        unwrapedDoctors = unwrapDoctorWrappers(docwrap);
        if (unwrapedDoctors.size() > 0) {
            showResult = true;
        }
    }

    private static List<Doctor__c> unwrapDoctorWrappers(List<DoctorWrapper> docwrap) {
        List<Doctor__c> doctorsListToInsert = new List<Doctor__c>();
        for (DoctorWrapper doctorWrapper : docwrap) {
            Doctor__c dr = new Doctor__c();
            dr.External_Id__c = doctorWrapper.id;
            dr.Name = doctorWrapper.firstName;
            dr.Last_Name__c = doctorWrapper.lastName;
            dr.Speciality__c = doctorWrapper.speciality;
            dr.Date_of_birth__c = doctorWrapper.dateOfBirth;
            dr.Start_of_career__c = doctorWrapper.startOfCareer;
            dr.Phone__c = doctorWrapper.phone;
            dr.Email__c = doctorWrapper.email;
            dr.License_number__c = doctorWrapper.licenseNumber;
            dr.Street__c = doctorWrapper.street;
            dr.City__c = doctorWrapper.city;
            dr.Country__c = doctorWrapper.country;
            doctorsListToInsert.add(dr);
        }
        return doctorsListToInsert;
    }

    private String wrapDoctor() {
        List<DoctorWrapper> wrapDoctorToPost = new List<DoctorWrapper>();
        Doctor__c doctorToPost2 = doctorToPost;
        wrapDoctorToPost.add(new DoctorWrapper(doctorToPost));
        DoctorWrap doctorWrap = new DoctorWrap('', wrapDoctorToPost);
        String jsonString = JSON.serialize(wrapDoctorToPost);
        return jsonString;
    }

    public PageReference updateDoctor() {
        return null;
    }

    public String wrapDoctorToPut() {
        List<DoctorWrapper> doctorToPut = new List<DoctorWrapper>();
        Doctor__c dr = new Doctor__c();
        doctorToPut.add(new DoctorWrapper(doctorToUpdate));
        DoctorWrap doctorWrap = new DoctorWrap('', doctorToPut);
        String jsonString = JSON.serialize(doctorToPut);
        return jsonString;
    }

    public void openNewDoctorWindow() {
        newDoctorPopup = true;
    }

    public void editDoc() {
        for (Doctor__c doctor : unwrapedDoctors) {
            if (doctor.External_Id__c == doctorIdsel) {
                doctorToUpdate = doctor;
            }
        }
        showModal = true;
    }

    public void closeModal() {
        showModal = false;
    }

    public PageReference closeNewDoctorWindow() {
        PageReference newpage = new PageReference(pageRefString);
        newpage.setRedirect(true);
        return newpage;
    }

    public PageReference closeUpdateDoctorWindow() {
        PageReference newpage = new PageReference(pageRefString);
        newpage.setRedirect(true);
        return newpage;
    }

    public PageReference currentPageReference() {
        PageReference newpage = new PageReference(pageRefString);
        newpage.setRedirect(true);
        return newpage;
    }

    public class Oauth {
        public String access_token { get; set; }
        public String instance_url { get; set; }
        public String id { get; set; }
        public String token_type { get; set; }
        public String issued_at { get; set; }
        public String signature { get; set; }
    }

    global class DoctorWrap {
        global String error { get; set; }
        global List<DoctorWrapper>results { get; set; }

        global DoctorWrap(String error, List<DoctorWrapper>doctors) {
            this.error = error;
            this.results = doctors;
        }
    }

    global class DoctorWrapper {
        global Id id;
        global String firstName;
        global String lastName;
        global Date dateOfBirth;
        global String speciality;
        global Decimal licenseNumber;
        global Date startOfCareer;
        global String phone;
        global String email;
        global String street;
        global String postalCode;
        global String city;
        global String country;

        public DoctorWrapper() {}

        public DoctorWrapper(String doctorIdToDelete) {
            this.id = doctorIdToDelete;
        }

        public DoctorWrapper(Doctor__c doctor) {
            this.id = doctor.External_Id__c;
            this.firstName = doctor.Name;
            this.lastName = doctor.Last_Name__c;
            this.dateOfBirth = doctor.Date_Of_Birth__c;
            this.speciality = doctor.Speciality__c;
            this.licenseNumber = doctor.License_Number__c;
            this.startOfCareer = doctor.Start_Of_Career__c;
            this.phone = doctor.Phone__c;
            this.email = doctor.Email__c;
            this.street = doctor.Street__c;
            this.postalCode = String.valueOf(doctor.Postal_Code__c);
            this.city = doctor.City__c;
            this.country = doctor.Country__c;
        }

        Doctor__c getDoctor() {
            return new Doctor__c(id = id, name = firstName, Last_Name__c = lastName, Date_Of_Birth__c = dateOfBirth, Speciality__c = speciality, License_Number__c = licenseNumber, Start_Of_Career__c = startOfCareer, Phone__c = phone, Email__c = email, Street__c = street, Postal_Code__c = Decimal.valueOf(postalCode), External_Id__c = id, City__c = city, Country__c = country);
        }
    }
}