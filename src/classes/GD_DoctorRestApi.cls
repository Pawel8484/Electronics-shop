@RestResource(urlMapping='/Doctor/*')
global with sharing class GD_DoctorRestApi {

    @HttpGet
    global static WrapDoctor doGet() {
        WrapDoctor wrapDoctor = new WrapDoctor();
        RestResponse res = RestContext.response;
        List<DoctorWrapper> results = new List<DoctorWrapper>();
        String errors = '';
        try {
            RestRequest req = RestContext.request;
            String name = '%' + RestContext.request.params.get('name') + '%';
            String lastName = '%' + RestContext.request.params.get('lastName') + '%';
            String email = '%' + RestContext.request.params.get('email') + '%';
            String country = '%' + RestContext.request.params.get('country') + '%';
            wrapDoctor.result = listOfDoctors(name, lastName, email, country);
        } catch (Exception e) {
            RestContext.response.statusCode = 400;
            errors += e.getMessage();
        }
        wrapDoctor.error = errors;
        return wrapDoctor;
    }

    private static List<DoctorWrapper> listOfDoctors(String name, String lastName, String email, String country) {
        List<DoctorWrapper> wrapperResults = new List<DoctorWrapper>();
        List<Doctor__c> results = [
                SELECT Id, Name, Last_Name__c,Date_Of_Birth__c, Nationality__c, License_Number__c, Speciality__c,
                        Start_Of_Career__c, Phone__c, Email__c, Street__c, Postal_Code__c, City__c, Country__c
                FROM Doctor__c
                WHERE Name LIKE :name AND Last_Name__c LIKE :lastName AND Email__c LIKE :email AND Country__c LIKE :country
        ];
        for (Doctor__c doctor : results) {
            wrapperResults.add(new DoctorWrapper(doctor));
        }
        return wrapperResults;
    }

    @HttpPost
    global static WrapDoctor doPost() {
        WrapDoctor wrapDoctor = new WrapDoctor();
        List<Doctor__c> doctorsListToInsert = new List<Doctor__c>();
        List<DoctorWrapper> doctorsListToReturn = new List<DoctorWrapper>();
        List<Id> successIds = new List<Id>();
        String errors = '';
        try {
            RestRequest req = RestContext.request;
            List<DoctorWrapper> wrapDoctorsList = (List<DoctorWrapper>) JSON.deserialize(req.requestBody.toString(), List<DoctorWrapper>.class);
            for (DoctorWrapper doctorWrapper : wrapDoctorsList) {
                doctorsListToInsert.add(doctorWrapper.getDoctor());
            }
            Database.SaveResult[] srList = Database.insert(doctorsListToInsert, true);
            for (Integer i = 0; i < srList.size(); i++) {
                if (srList.get(i).isSuccess()) {
                    successIds.add(srList.get(i).getId());
                } else {
                    errors += srList.get(i).getErrors();
                }
            }
        } catch (Exception e) {
            RestContext.response.statusCode = 400;
            errors += e.getMessage();
        }
        for (Doctor__c dr : [
                SELECT Id, Name, Last_Name__c, Date_Of_Birth__c, Nationality__c, License_Number__c, Speciality__c,
                        Start_Of_Career__c, Phone__c, Email__c, Street__c, Postal_Code__c, City__c, Country__c
                FROM Doctor__c
        ]) {
            if (successIds.contains(dr.Id)) {
                doctorsListToReturn.add(new DoctorWrapper(dr));
            }
        }
        wrapDoctor.error = errors;
        wrapDoctor.result = doctorsListToReturn;
        return wrapDoctor;
    }

    @httpPut
    global static WrapDoctor doPut() {
        WrapDoctor wrapDoctor = new WrapDoctor();
        List<Doctor__c> doctorsListToInsert = new List<Doctor__c>();
        List<DoctorWrapper> doctorsListToReturn = new List<DoctorWrapper>();
        List<Id> successIds = new List<Id>();
        List<DoctorWrapper> wrapperResults = new List<DoctorWrapper>();
        String errors = '';
        try {
            RestRequest req = RestContext.request;
            List<DoctorWrapper> wrapDoctorsList = (List<DoctorWrapper>) JSON.deserialize(req.requestBody.toString(), List<DoctorWrapper>.class);
            for (DoctorWrapper doctorWrapper : wrapDoctorsList) {
                doctorsListToInsert.add(doctorWrapper.getDoctor());
            }
            Database.SaveResult[] srList = Database.update(doctorsListToInsert, true);
            for (Integer i = 0; i < srList.size(); i++) {
                if (srList.get(i).isSuccess()) {
                    successIds.add(srList.get(i).getId());
                } else {
                    errors += srList.get(i).getErrors();
                }
            }
        } catch (Exception e) {
            RestContext.response.statusCode = 400;
            errors += e.getMessage();
        }
        for (Doctor__c dr : [
                SELECT Id, Name, Last_Name__c, Date_Of_Birth__c, Nationality__c, License_Number__c, Speciality__c,
                        Start_Of_Career__c, Phone__c, Email__c, Street__c, Postal_Code__c, City__c, Country__c
                FROM Doctor__c
        ]) {
            if (successIds.contains(dr.Id)) {
                doctorsListToReturn.add(new DoctorWrapper(dr));
            }
        }
        wrapDoctor.error = errors;
        wrapDoctor.result = doctorsListToReturn;
        return wrapDoctor;
    }

    @httpDelete
    global static Boolean doDelete() {
        String errors = '';
        Boolean deleteStatus;
        List<Id> idsToDelete = new List<Id>();
        Database.DeleteResult[] delResult;
        try {
            deleteStatus = True;
            RestRequest req = RestContext.request;
            List<DoctorWrapper> wrapDoctorsList = (List<DoctorWrapper>) JSON.deserialize(req.requestBody.toString(), List<DoctorWrapper>.class);
            for (DoctorWrapper doctorWrapper : wrapDoctorsList) {
                idsToDelete.add(doctorWrapper.Id);
            }
            delResult = Database.delete(idsToDelete, true);

        } catch (Exception e) {
            RestContext.response.statusCode = 400;
            deleteStatus = False;
            errors += e.getMessage();
        }
        return deleteStatus;
    }

    global class WrapDoctor {
        public String error { get; set; }
        public List<DoctorWrapper> result { get; set; }
        public WrapDoctor() {
            error = '';
            result = new List<DoctorWrapper>();
        }
    }

    global class DoctorWrapper {

        global Id id { get; set; }
        global String name { get; set; }
        global String lastName { get; set; }
        global Date dateOfBirth { get; set; }
        global String speciality { get; set; }
        global Decimal licenseNumber { get; set; }
        global Date startOfCareer { get; set; }
        global String phone { get; set; }
        global String email { get; set; }
        global String street { get; set; }
        global Decimal postalCode { get; set; }
        global String city { get; set; }
        global String country { get; set; }

        public DoctorWrapper(Doctor__c doctor) {
            this.id = doctor.Id;
            this.name = doctor.Name;
            this.lastName = doctor.Last_Name__c;
            this.dateOfBirth = doctor.Date_Of_Birth__c;
            this.speciality = doctor.Speciality__c;
            this.licenseNumber = doctor.License_Number__c;
            this.startOfCareer = doctor.Start_Of_Career__c;
            this.phone = doctor.Phone__c;
            this.email = doctor.Email__c;
            this.street = doctor.Street__c;
            this.postalCode = doctor.Postal_Code__c;
            this.city = doctor.City__c;
            this.country = doctor.Country__c;
        }

        Doctor__c getDoctor() {
            return new Doctor__c(Id = id, Name = name, Last_Name__c = lastName, Date_Of_Birth__c = dateOfBirth, Speciality__c = speciality, License_Number__c = licenseNumber,
                    Start_Of_Career__c = startOfCareer, Phone__c = phone, Email__c = email, Street__c = street, Postal_Code__c = postalCode, City__c = city, Country__c = country);
        }
    }
}