global with sharing class GD_HospitalSoapApi {

    webservice static SOAPResponse getHospitals() {
        List<HospitalDTO> hospitalDTOs = new List<HospitalDTO>();
        List<Hospital__c> hospitals = [
                SELECT Id, Name, Country__c, Street__c, City__c, Postal_Code__c, Phone_number__c, Fax_number__c, Helicopter_access__c, No_Ambulances__c
                FROM Hospital__c
        ];

        if (hospitals.isEmpty()) {
            return new SOAPResponse(GD_HospitalSoapApiHelper.noRecords, null);
        }

        for (Hospital__c hospital : hospitals) {
            HospitalDTO hospitalDTO = new HospitalDTO(hospital);
            hospitalDTOs.add(hospitalDTO);
        }

        return new SOAPResponse(GD_HospitalSoapApiHelper.success, hospitalDTOs);
    }

    webservice static SOAPResponse getHospitalsByParameters(HospitalDTO hospitalParameters) {
        List<HospitalDTO> hospitalDTOs = new List<HospitalDTO>();
        List<Hospital__c> hospitals = searchHospital(hospitalParameters);

        if (hospitals.isEmpty()) {
            return new SOAPResponse(GD_HospitalSoapApiHelper.noRecords, null);
        }

        for (Hospital__c hospital : hospitals) {
            HospitalDTO hospitalDTO = new HospitalDTO(hospital);
            hospitalDTOs.add(hospitalDTO);
        }
        return new SOAPResponse(GD_HospitalSoapApiHelper.success, hospitalDTOs);
    }

    webService static SOAPResponse addHospitals(List<HospitalDTO> hospitalDTOs) {
        List<Hospital__c> hospitals = new List<Hospital__c>();
        for (HospitalDTO hospitalDTO : hospitalDTOs) {
            Hospital__c hospital = new Hospital__c();
            hospital.Name = hospitalDTO.hospitalName;
            hospital.Country__c = hospitalDTO.country;
            hospital.City__c = hospitalDTO.city;
            hospital.Street__c = hospitalDTO.street;
            hospital.Phone_number__c = hospitalDTO.phone;
            hospital.Fax_number__c = hospitalDTO.fax;
            hospital.No_Ambulances__c = hospitalDTO.ambulanceNumber;
            hospital.Helicopter_access__c = hospitalDTO.helicopterAccess;
            hospitals.add(hospital);
        }
        try {
            insert hospitals;
        } catch (System.DmlException e) {
            return new SOAPResponse(e.getMessage(), null);
        }
        for (Integer i = 0; i < hospitals.size(); i++) {
            hospitalDTOs.get(i).hospitalId = hospitals.get(i).Id;
        }
        return new SOAPResponse(GD_HospitalSoapApiHelper.success, hospitalDTOs);
    }

    webService static SOAPResponse updateHospital(List<HospitalDTO> hospitalDTOs) {
        List<Id> hospitalsId = new List<Id>();
        for (HospitalDTO hospitalDTO : hospitalDTOs) {
            hospitalsId.add(hospitalDTO.hospitalId);
        }

        List<Hospital__c> hospitals = [
                SELECT Id, Name, Country__c, Street__c, City__c, Postal_Code__c, Phone_number__c, Fax_number__c, Helicopter_access__c, No_Ambulances__c
                FROM Hospital__c
                WHERE Id IN :hospitalsId
        ];

        if (hospitals.isEmpty()) {
            return new SOAPResponse(GD_HospitalSoapApiHelper.noRecordWithId, null);
        }

        Map<Id, HospitalDTO> updateHospitals = new Map<Id, HospitalDTO>();
        for (HospitalDTO updateHospital : hospitalDTOs) {
            updateHospitals.put(updateHospital.hospitalId, updateHospital);
        }

        for (Hospital__c hospital : hospitals) {
            HospitalDTO newHospitalData = updateHospitals.get(hospital.Id);
            hospital.Name = newHospitalData.hospitalName != null ? newHospitalData.hospitalName : hospital.Name;
            hospital.Country__c = newHospitalData.country;
            hospital.Street__c = newHospitalData.street;
            hospital.City__c = newHospitalData.city;
            hospital.Phone_number__c = newHospitalData.phone;
            hospital.Fax_number__c = newHospitalData.fax;
            hospital.Helicopter_access__c = newHospitalData.helicopterAccess;
            hospital.No_Ambulances__c = newHospitalData.ambulanceNumber;
        }
        try {
            update hospitals;
        } catch (Exception e) {
            return new SOAPResponse(e.getMessage(), null);
        }
        return new SOAPResponse(GD_HospitalSoapApiHelper.success, getHospitalDTOFromList(hospitals));
    }

    webService static SOAPResponse deleteHospitals(List<Id> hospitalIds) {
        List<Hospital__c> hospitals = getHospitals(hospitalIds);
        if (hospitals.isEmpty()) {
            return new SOAPResponse(GD_HospitalSoapApiHelper.noRecordWithId, null);
        }

        for (Hospital__c hospital : hospitals) {
            delete hospital;
        }
        return new SOAPResponse(GD_HospitalSoapApiHelper.success, null);
    }

    public static List<Hospital__c> getHospitals(List<Id> hospitalIds) {
        List<Hospital__c> hospitals = [
                SELECT Id
                FROM Hospital__c
                WHERE Id IN :hospitalIds
        ];

        return hospitals;
    }

    public static List<HospitalDTO> getHospitalDTOFromList(List<Hospital__c> hospitals) {
        List<HospitalDTO> hospitalDTOs = new List<HospitalDTO>();
        for (Hospital__c hospital : hospitals) {
            hospitalDTO hospitalDTO = new HospitalDTO();
            hospitalDTO.hospitalId = hospital.Id;
            hospitalDTO.hospitalName = hospital.Name;
            hospitalDTO.country = hospital.Country__c;
            hospitalDTO.street = hospital.Street__c;
            hospitalDTO.city = hospital.City__c;
            hospitalDTO.phone = hospital.Phone_number__c;
            hospitalDTO.fax = hospital.Fax_number__c;
            hospitalDTO.helicopterAccess = hospital.Helicopter_access__c;
            hospitalDTO.ambulanceNumber = hospital.No_Ambulances__c;
            hospitalDTOs.add(hospitalDTO);
        }
        return hospitalDTOs;
    }

    public static List<Hospital__c> searchHospital(HospitalDTO hospital) {
        List<Hospital__c> hospitals = new List<Hospital__c>();
        List<String> conditions = new List<String>();
        String query = ' SELECT Id, Name, Country__c, Street__c, City__c, Postal_Code__c, Phone_number__c, Fax_number__c, Helicopter_access__c, No_Ambulances__c FROM Hospital__c ';
        conditions.clear();


        if (hospital.hospitalName != null && hospital.hospitalName != '') {
            conditions.add('Name LIKE' + '\'%' + String.escapeSingleQuotes(hospital.hospitalName) + '%\'');
        }
        if (hospital.street != null && hospital.street != '') {
            conditions.add('Street__c LIKE' + '\'%' + String.escapeSingleQuotes(hospital.street) + '%\'');
        }
        if (hospital.country != null && hospital.country != '') {
            conditions.add('Country__c LIKE' + '\'%' + String.escapeSingleQuotes(hospital.country) + '%\'');
        }
        if (hospital.city != null && hospital.city != '') {
            conditions.add('City__c LIKE' + '\'%' + String.escapeSingleQuotes(hospital.city) + '%\'');
        }

        if (conditions.size() > 0) {
            query += 'WHERE ' + conditions[0];
            for (Integer i = 1; i < conditions.size(); i++) {
                query += ' AND ' + conditions[i];
            }
        }
        hospitals = Database.query(query);
        return hospitals;
    }

    global class HospitalDTO {
        webService Id hospitalId { get; set; }
        webService String hospitalName { get; set; }
        webService String country { get; set; }
        webService String city { get; set; }
        webService String street { get; set; }
        webService String phone { get; set; }
        webService String fax { get; set; }
        webService Boolean helicopterAccess { get; set; }
        webService Double ambulanceNumber { get; set; }

        global HospitalDTO() {
        }

        public HospitalDTO(Hospital__c hospital) {
            this.hospitalId = hospital.Id;
            this.hospitalName = hospital.Name;
            this.country = hospital.Country__c;
            this.city = hospital.City__c;
            this.street = hospital.Street__c;
            this.phone = hospital.Phone_number__c;
            this.fax = hospital.Fax_number__c;
            this.ambulanceNumber = hospital.No_Ambulances__c;
            this.helicopterAccess = hospital.Helicopter_access__c;
        }
    }

    global class SOAPResponse {
        webService String error { get; set; }
        webService List<HospitalDTO> hospitalsDTO { get; set; }

        global SOAPResponse(String error, List<HospitalDTO> hospitalsDTO) {
            this.error = error;
            this.hospitalsDTO = hospitalsDTO;
        }
    }
}