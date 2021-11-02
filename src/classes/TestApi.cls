global with sharing class TestApi {


    public static List<Doctor__c> getDoctorInfo(String sFirstName, String sLastName, String sEmail, String sCountry) {
        RestDoctorWrap restDoctorWrap;
        List<DoctorWrapper> doctorsList;
        List<Doctor__c> doctorsListToInsert = new List<Doctor__c>();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://britenet-3b-dev-ed.my.salesforce.com/services/oauth2/token?grant_type=password&client_id=3MVG9SOw8KERNN09iYfnLn2iw4o3ipZJAHYo4RECaUbEzNgr0sxzzPP3HAharNnhgpU2Odi3DcSnOT7e.sMHY&client_secret=4CEF27ECE52EDF3453765F143D9B2AF5FE322D69BF389570F8A36C5EDA834CA3&username=kamil.sieczkowski2@britenet.com.pl&password=DrugiOrg2RL27zU1F0MhSUHZ5LC5moCz0');
        req.setMethod('POST');
        Http http = new Http();
        HttpResponse res = new HttpResponse();
        res = http.send(req);
        System.debug((res.getBody()));
        Oauth objAuthInfo = (Oauth) JSON.deserialize(res.getBody(), Oauth.class);
        if (objAuthInfo.access_token != null) {
            HttpRequest req1 = new HttpRequest();
//            req1.setEndpoint('https://britenet-3b-dev-ed.my.salesforce.com/services/apexrest/Doctors/?name=&lastName=&email=gmail.com&country=');


            PageReference pr = new PageReference('https://britenet-3b-dev-ed.my.salesforce.com/services/apexrest/Doctors/');
            Map<String, String> params = pr.getParameters();
            params.put('name', sFirstName);
            params.put('lastName', sLastName);
            params.put('email', sEmail);
            params.put('country', sCountry);
            req1.setEndpoint(pr.getUrl());

            req1.setMethod('GET');
            req1.setHeader('Content-Type', 'application/json');
            req1.setHeader('Authorization', 'Bearer ' + objAuthInfo.access_token);
            Http http1 = new Http();
            HttpResponse res1 = new HttpResponse();
            res1 = http.send(req1);
            System.debug((res1.getBody()));


//            List<DoctorWrapper> drwrapper = (List<DoctorWrapper>)JSON.deserialize(res1.getBody(), List<DoctorWrapper>.class);
//            System.debug(drwrapper);
//            List<DoctorWrapper> doctors = wrapDoctor1.result;
//            System.debug(doctors);

            restDoctorWrap = (RestDoctorWrap)JSON.deserialize(res1.getBody(), RestDoctorWrap.class);
            System.debug('RESTDOCTORWRAP ' + restDoctorWrap);
            List<DoctorWrapper> docwrap = restDoctorWrap.results;
            System.debug('RESULTS ' + docwrap);
//            doctorsList = (List<DoctorWrapper>)JSON.deserialize(res1.getBody(), List<DoctorWrapper>.class);

//            List<DoctorWrapper> wrapDoctorsList = (List<DoctorWrapper>) JSON.deserialize(docwrap.toString(), List<DoctorWrapper>.class);
            for (DoctorWrapper doctorWrapper : docwrap) {
                doctorsListToInsert.add(doctorWrapper.getDoctor());

            }
//            List<DoctorWrapper> wrapDoctorsList = (List<DoctorWrapper>) JSON.deserialize(restDoctorWrap.results, List<DoctorWrapper>.class);
//            for (DoctorWrapper doctorWrapper : wrapDoctorsList) {
//                doctorsListToInsert.add(doctorWrapper.getDoctor());
//            }

//            List<DoctorWrapper> wrapDoctorsList = (List<DoctorWrapper>) JSON.deserialize(res.getBody(), List<DoctorWrapper>.class);
//            System.debug('WWWWRAPPPPP' + wrapDoctorsList);
//            for (DoctorWrapper doctorWrapper : wrapDoctorsList) {
//                doctorsListToInsert.add(doctorWrapper.getDoctor());
//            }
        }
        System.debug('First ' + doctorsListToInsert);
        return doctorsListToInsert;
    }
    public class Oauth {
        public String access_token { get; set; }
        public String instance_url { get; set; }
        public String id { get; set; }
        public String token_type { get; set; }
        public String issued_at { get; set; }
        public String signature { get; set; }

    }

    global class RestDoctorWrap {
        String error { get; set; }
        List<DoctorWrapper>results { get; set; }

        RestDoctorWrap(String error, List<DoctorWrapper>doctors) {
            this.error = error;
            this.results = doctors;
        }
    }

    global class DoctorWrapper {
        global Id id;
        global String firstName;
        global String name;
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

        public DoctorWrapper(Doctor__c doctor) {
            this.id = doctor.Id;
            this.firstName = doctor.Name;
            this.name = doctor.Last_Name__c;
            this.dateOfBirth = doctor.Date_Of_Birth__c;
            this.speciality = doctor.Speciality__c;
            this.licenseNumber = doctor.License_Number__c;
            this.startOfCareer = doctor.Start_Of_Career__c;
            this.phone = doctor.Phone__c;
            this.email = doctor.Email__c;
            this.street = doctor.Street__c;
//            this.postalCode = doctor.Postal_Code__c;
            this.city = doctor.City__c;
            this.country = doctor.Country__c;
        }

        Doctor__c getDoctor() {
//            return new Doctor__c(Last_Name__c = name, name = firstName, Date_Of_Birth__c = dateOfBirth, Speciality__c = speciality, License_Number__c = licenseNumber,
//                    Start_Of_Career__c = startOfCareer, Phone__c = phone, Email__c = email, Street__c = street, City__c = city, Country__c = country);
            return new Doctor__c(Last_Name__c = name, name = firstName,
                    Email__c = email, City__c = city, Country__c = country);
        }
    }


}