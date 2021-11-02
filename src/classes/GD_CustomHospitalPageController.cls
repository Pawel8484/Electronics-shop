public with sharing class GD_CustomHospitalPageController {

    public Hospital__c hospital;
    public Hospital__c record { get; set; }
    public Doctor__c doctor { get; set; }
    public Contract__c contract { get; set; }
    public List<Doctor__c> doctorsList { get; set; }
    public Boolean showResult { get; set; }
    public Boolean noRecord { get; set; }
    public Id doctorIdSel { get; set; }
    public Id hospitalIdSel { get; set; }
    public Id hospitalId { get; set; }
    public String doctorLastNameSel { get; set; }
    public Boolean okInfo { get; set; }
    public String isSend { get; set; }

    public GD_CustomHospitalPageController(ApexPages.StandardController controller) {
        hospital = (Hospital__c) controller.getRecord();
        record = new Hospital__c();
        doctor = new Doctor__c();
        contract = new Contract__c();
        updateHospital(controller);
        okInfo = false;
    }

    public PageReference newHospital() {
        PageReference pr = null;
        if (record.Name == null || record.Phone_Number__c == null || record.Street__c == null || record.City__c == null || record.Country__c == null) {
            record.Name.addError(System.Label.Error_You_must_enter_a_value);
            record.Phone_Number__c.addError(System.Label.Error_You_must_enter_a_value);
            record.Street__c.addError(System.Label.Error_You_must_enter_a_value);
            record.City__c.addError(System.Label.Error_You_must_enter_a_value);
            record.Country__c.addError(System.Label.Error_You_must_enter_a_value);
        } else {
            createHospitalRecord();
            upsert hospital;
            pr = new ApexPages.StandardController(hospital).view();
            pr.setRedirect(true);
        }
        return pr;
    }

    public void updateHospital(ApexPages.StandardController controller) {
        if (controller.getRecord().Id != null) {
            hospitalId = controller.getRecord().Id;
            hospital = [SELECT Id, Name, No_Ambulances__c, Phone_Number__c, Fax_Number__c, Street__c, Postal_Code__c, City__c, Country__c, Helicopter_Access__c FROM Hospital__c WHERE Id = :hospitalId];
            updateHospitalRecord();
        }
    }

    public PageReference editHospital() {
        hospitalId = hospital.Id;
        PageReference pr = new PageReference('/apex/GD_CustomHospital?id=' + hospitalId);
        pr.setRedirect(true);
        return pr;
    }

    public PageReference deleteHospital() {
        delete hospital;
        PageReference pr = new PageReference('/a02/o');
        pr.setRedirect(true);
        return pr;
    }

    public PageReference saveAndNew() {
        PageReference pr = null;
        if (record.Name == null || record.Phone_Number__c == null || record.Street__c == null || record.City__c == null || record.Country__c == null) {
            record.Name.addError(System.Label.Error_You_must_enter_a_value);
            record.Phone_Number__c.addError(System.Label.Error_You_must_enter_a_value);
            record.Street__c.addError(System.Label.Error_You_must_enter_a_value);
            record.City__c.addError(System.Label.Error_You_must_enter_a_value);
            record.Country__c.addError(System.Label.Error_You_must_enter_a_value);
        } else {
            createHospitalRecord();
            upsert hospital;
            pr = ApexPages.currentPage();
            pr.setRedirect(true);
            return pr;
        }
        return pr;
    }

    public void createHospitalRecord() {
        hospital.Name = record.Name;
        hospital.No_Ambulances__c = record.No_Ambulances__c;
        hospital.Phone_Number__c = record.Phone_Number__c;
        hospital.Fax_Number__c = record.Fax_Number__c;
        hospital.Street__c = record.Street__c;
        hospital.Postal_Code__c = record.Postal_Code__c;
        hospital.City__c = record.City__c;
        hospital.Country__c = record.Country__c;
        hospital.Helicopter_Access__c = record.Helicopter_Access__c;
    }

    public void updateHospitalRecord() {
        record.Name = hospital.Name;
        record.No_Ambulances__c = hospital.No_Ambulances__c;
        record.Phone_Number__c = hospital.Phone_Number__c;
        record.Fax_Number__c = hospital.Fax_Number__c;
        record.Street__c = hospital.Street__c;
        record.Postal_Code__c = hospital.Postal_Code__c;
        record.City__c = hospital.City__c;
        record.Country__c = hospital.Country__c;
        record.Helicopter_Access__c = hospital.Helicopter_Access__c;
    }

    public PageReference sharingHospital() {
        hospitalId = hospital.Id;
        PageReference pr = new PageReference('/p/share/CustomObjectSharingDetail?parentId=' + hospitalId);
        pr.setRedirect(true);
        return pr;
    }

    public void searchDoctor() {
        doctorsList = getDoctorsList();
        showResult = false;
        noRecord = false;
        if (doctorsList.size() == 0) {
            noRecord = true;
            showResult = false;
        } else {
            showResult = true;
            noRecord = false;
        }
    }

    public List<Doctor__c> getDoctorsList() {
        if (String.isBlank(doctor.Name) && String.isBlank(doctor.Last_Name__c) && String.isBlank(doctor.Email__c) && String.isBlank(doctor.Country__c)) {
            doctorsList = Database.query('SELECT Id, Name, Last_Name__c, Email__c, License_Number__c, Street__c, Postal_Code__c, City__c, Country__c FROM Doctor__c');
        } else {
            String sFirstName = String.escapeSingleQuotes('%' + doctor.Name + '%');
            String sLastName = String.escapeSingleQuotes('%' + doctor.Last_Name__c + '%');
            String sEmail = String.escapeSingleQuotes('%' + doctor.Email__c + '%');
            String sCountry = String.escapeSingleQuotes('%' + doctor.Country__c + '%');
            listOfDoctors(sFirstName, sLastName, sEmail, sCountry);
            hospitalIdSel = hospitalId;
        }
        return doctorsList;
    }

    private void listOfDoctors(String sFirstName, String sLastName, String sEmail, String sCountry) {

        doctorsList = Database.query('SELECT Id, Name, Last_Name__c, Email__c, License_Number__c, Street__c, Postal_Code__c, City__c, Country__c FROM Doctor__c WHERE Name LIKE :sFirstName AND Last_Name__c LIKE :sLastName\n' +
                '                    AND Email__c LIKE :sEmail AND Country__c LIKE :sCountry');
    }
    
    public PageReference hire() {
        Contract__c newContract = new Contract__c();
        newContract.Doctor__c = doctorIdSel;
        newContract.Hospital__c = hospitalIdSel;
        newContract.Start_Date__c = contract.Start_Date__c;
        newContract.End_Date__c = contract.End_Date__c;
        newContract.Supervisor__c = contract.Supervisor__c;
        newContract.Part_Time__c = contract.Part_Time__c;
        List<Contract__c> contracts = new List<Contract__c>();
        contracts.add(newContract);

        Database.SaveResult[] srList = Database.insert(contracts, false);

        if (srList[0].isSuccess()) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, System.Label.Contract_concluded));
            isSend = 'yes';
            okInfo = true;
        } else {
            for (Database.Error err : srList[0].getErrors()) {
                if (err.getMessage().contains('End Date must be after Start Date')) {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, System.Label.Start_date_must_be_before_end_date));
                    isSend = 'no';
                }
                if (err.getMessage().contains('This contract is overlapping')) {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, err.getMessage()));
                    isSend = 'no';
                }
            }
        }
        return null;
    }

    public void changeFlag() {
        isSend = 'no';
    }
}