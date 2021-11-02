global with sharing class GD_CustomDoctorPageController {

    public Doctor__c doctor;
    public Doctor__c record { get; set; }
    global String doctorEmailAddress { get; set; }
    public String orgWideAddressId { get; set; }
    List<OrgWideEmailAddress>orgAddresses;
    public List<SelectOption> orgEmails { get; set; }
    global static String emailSubject { get; set; }
    global static String emailBody { get; set; }
    public String isSend { get; set; }
    public Boolean okInfo { get; set; }

    public GD_CustomDoctorPageController(ApexPages.StandardController controller) {
        doctor = (Doctor__c) controller.getRecord();
        record = new Doctor__c();
        updateDoctor(controller);
        OrgWideEmailAddress orgAddress1 = [SELECT Id, Address FROM OrgWideEmailAddress WHERE Id = '0D209000000L0NaCAK' LIMIT 1];
        OrgWideEmailAddress orgAddress2 = [SELECT Id, Address FROM OrgWideEmailAddress WHERE Id = '0D209000000L0RPCA0' LIMIT 1];
        orgEmails = new List<SelectOption>();
        orgEmails.add(new SelectOption(orgAddress1.Id, orgAddress1.Address));
        orgEmails.add(new SelectOption(orgAddress2.Id, orgAddress2.Address));
        doctorEmailAddress = doctor.Email__c;
        okInfo = false;
    }

    public PageReference newDoctor() {
        PageReference pr = null;
        if (record.Name == null || record.Last_Name__c == null) {
            record.Name.addError(System.Label.Error_You_must_enter_a_value);
            record.Last_Name__c.addError(System.Label.Error_You_must_enter_a_value);
        } else {
            createDoctorRecord();
            upsert doctor;
            pr = new PageReference('/apex/GD_CustomDoctorView?id=' + doctor.Id);
            pr.setRedirect(true);
        }
        return pr;
    }

    public void updateDoctor(ApexPages.StandardController controller) {
        if (controller.getRecord().Id != null) {
            Id doctorId = controller.getRecord().Id;
            doctor = [
                    SELECT Id, Name, Last_Name__c, Date_Of_Birth__c, Nationality__c, License_Number__c, Speciality__c,
                            Start_Of_Career__c, Phone__c, Email__c, Street__c, Postal_Code__c, City__c, Country__c
                    FROM Doctor__c
                    WHERE Id = :doctorId
            ];
            updateDoctorRecord();
        }
    }

    public PageReference deleteDoctor() {
        delete doctor;
        PageReference pr = new PageReference('/a01/o');
        pr.setRedirect(true);
        return pr;
    }

    public PageReference saveAndNew() {
        PageReference pr = null;
        if (record.Name == null || record.Last_Name__c == null) {
            record.Name.addError(System.Label.Error_You_must_enter_a_value);
            record.Last_Name__c.addError(System.Label.Error_You_must_enter_a_value);
        } else {
            createDoctorRecord();
            upsert doctor;
            pr = ApexPages.currentPage();
            pr.setRedirect(true);
            return pr;
        }
        return pr;
    }
    public void createDoctorRecord() {
        doctor.Name = record.Name;
        doctor.Last_Name__c = record.Last_Name__c;
        doctor.Date_Of_Birth__c = record.Date_Of_Birth__c;
        doctor.Nationality__c = record.Nationality__c;
        doctor.License_Number__c = record.License_Number__c;
        doctor.Speciality__c = record.Speciality__c;
        doctor.Start_Of_Career__c = record.Start_Of_Career__c;
        doctor.Phone__c = record.Phone__c;
        doctor.Email__c = record.Email__c;
        doctor.Street__c = record.Street__c;
        doctor.Postal_Code__c = record.Postal_Code__c;
        doctor.City__c = record.City__c;
        doctor.Country__c = record.Country__c;
    }

    public void updateDoctorRecord() {
        record.Name = doctor.Name;
        record.Last_Name__c = doctor.Last_Name__c;
        record.Date_Of_Birth__c = doctor.Date_Of_Birth__c;
        record.Nationality__c = doctor.Nationality__c;
        record.License_Number__c = doctor.License_Number__c;
        record.Speciality__c = doctor.Speciality__c;
        record.Start_Of_Career__c = doctor.Start_Of_Career__c;
        record.Phone__c = doctor.Phone__c;
        record.Email__c = doctor.Email__c;
        record.Street__c = doctor.Street__c;
        record.Postal_Code__c = doctor.Postal_Code__c;
        record.City__c = doctor.City__c;
        record.Country__c = doctor.Country__c;
    }

    public PageReference editDoctor() {
        Id doctorId = doctor.Id;
        PageReference pr = new PageReference('/apex/GD_CustomDoctor?id=' + doctorId);
        pr.setRedirect(true);
        return pr;
    }

    public PageReference sharingDoctor() {
        Id doctorId = doctor.Id;
        PageReference pr = new PageReference('/p/share/CustomObjectSharingDetail?parentId=' + doctorId);
        pr.setRedirect(true);
        return pr;
    }

    public PageReference sendEmail() {
        if (emailBody == null || emailBody == '') {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, System.Label.Fill_In_The_Blank_Fields));
        } else {
            Id userId = UserInfo.getUserId();
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setToAddresses(new List<String>{
                    doctor.Email__c
            });
            message.setWhatId(userId);
            message.saveAsActivity = false;
            message.setSubject(emailSubject);
            message.setPlainTextBody(emailBody);
            message.setOrgWideEmailAddressId(orgWideAddressId);

            Messaging.SendEmailResult[] res;
            try {
                res = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{
                        message
                });
                if (res[0].isSuccess() || res[0] != null) {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, System.Label.Email_Was_Sent));
                    isSend = 'yes';
                    okInfo = true;
                } else {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, System.Label.Fill_In_The_Blank_Fields));
                    isSend = 'no';
                }
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, System.Label.Fill_In_The_Blank_Fields));
                isSend = 'no';
            }
        }
        return null;
    }
    public void changeFlag() {
        isSend = 'no';
        emailSubject = '';
        emailBody = '';
    }

}