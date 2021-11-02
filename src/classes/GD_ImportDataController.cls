public with sharing class GD_ImportDataController {

    public Blob csvFileBody { get; set; }
    public string csvAsString { get; set; }
    public String[] csvFileLines { get; set; }
    public List<Doctor__c> doctorsList { get; set; }
    public List<wrapDoctor> wrapDoctorList { get; set; }
    public List<Doctor__c> selectedDoctors { get; set; }
    public Boolean showButtons { get; set; }
    public List<String> statusList { get; set; }

    public GD_ImportDataController() {
        csvFileLines = new String[]{
        };
        doctorsList = new List<Doctor__c>();
    }

    public void insertSelectedDoctors() {
        selectedDoctors = new List<Doctor__c>();
        for (wrapDoctor wrapDoctorObj : wrapDoctorList) {
            if (wrapDoctorObj.selected == true) {
                selectedDoctors.add(wrapDoctorObj.dr);
            }
        }
        Database.SaveResult[] srList = Database.insert(selectedDoctors, false);
        createStatusList(srList);
        addStatus();
    }

    public void importCSVFile() {
        csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n');
        for (Integer i = 1; i < csvFileLines.size(); i++) {
            Doctor__c drObj = new Doctor__c();
            String[] csvRecordData = csvFileLines[i].split('","');
            drObj.name = csvRecordData[0].substring(1);
            System.debug(drObj.name);
            drObj.Last_Name__c = csvRecordData[1];
            drObj.Country__c = csvRecordData[2];
            drObj.City__c = csvRecordData[3];
            drObj.Street__c = csvRecordData[4];
            drObj.Postal_Code__c = Double.valueOf(csvRecordData[5]);
            drObj.License_Number__c = Double.valueOf(csvRecordData[6].substring(0, csvRecordData.size()));
            doctorsList.add(drObj);
        }
        wrapDoctorList();
        showButtons = true;
    }

    public class wrapDoctor {
        public Doctor__c dr { get; set; }
        public Boolean selected { get; set; }
        public String status { get; set; }


        public wrapDoctor(Doctor__c d) {
            dr = d;
            selected = false;
            status = '';
        }
    }

    public void wrapDoctorList() {
        if (wrapDoctorList == null) {
            wrapDoctorList = new List<wrapDoctor>();
            for (Doctor__c d : doctorsList) {
                wrapDoctorList.add(new wrapDoctor(d));
            }
        }
    }

    public void createStatusList(Database.SaveResult[] srList) {
        statusList = new List<String>();
        for (Integer i = 0; i < srList.size(); i++) {
            if (srList.get(i).isSuccess()) {
                statusList.add(System.Label.Success);

            } else {
                for (Database.Error err : srList.get(i).getErrors()) {
                    String errorStatus = String.valueOf(err.getStatusCode());
                    statusList.add(addCustomLabelToError(errorStatus));
                }
            }
        }
    }

    public void addStatus() {
        Integer i = 0;
        for (wrapDoctor wrapDoctorObj : wrapDoctorList) {
            if (wrapDoctorObj.selected == true) {
                wrapDoctorObj.status = statusList[i];
                i++;
            }
        }
    }
    public void selectAll() {
        for (wrapDoctor wrapDoctorObj : wrapDoctorList) {
            wrapDoctorObj.selected = true;
        }
    }

    public void deselect() {
        for (wrapDoctor wrapDoctorObj : wrapDoctorList) {
            wrapDoctorObj.selected = false;
        }
    }

    public void invert() {
        for (wrapDoctor wrapDoctorObj : wrapDoctorList) {
            wrapDoctorObj.selected = !wrapDoctorObj.selected;
        }
    }

    public String addCustomLabelToError(String errorStatus) {
        String errorMessage = '';
        if (errorStatus == 'INVALID_FIELD_FOR_INSERT_UPDATE') {
            errorMessage += System.Label.Failed_Duplicate_found;
        }
        if (errorStatus == 'REQUIRED_FIELD_MISSING') {
            errorMessage += System.Label.Failed_Last_Name_Is_Required;
        }
        return errorMessage;
    }
}