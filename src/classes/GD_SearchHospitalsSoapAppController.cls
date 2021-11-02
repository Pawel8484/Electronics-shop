public with sharing class GD_SearchHospitalsSoapAppController {
    public Hospital__c hospital { get; set; }
    public String name { get; set; }
    public String street { get; set; }
    public String city { get; set; }
    public String country { get; set; }
    public Id hospitalIdsel { get; set; }
    public Boolean addNewPopup { get; set; }
    public Boolean showError { get; set; }
    public Boolean showResult { get; set; }
    public Boolean showNewHospitalError { get; set; }
    public String errorMessage { get; set; }
    public String deleteConfirmationMessage { get; set; }
    public List<Hospital__c> hospitalsList { get; set; }
    public Boolean newHospitalPopup { get; set; }
    public Boolean updateHospitalPopup { get; set; }
    public Boolean deleteHospitalPopup { get; set; }
    public Hospital__c hospitalToPost { get; set; }
    public Hospital__c hospitalToUpdate { get; set; }
    public Boolean recordUpdated { get; set; }
    public Boolean recordAdded { get; set; }
    public Boolean recordDeleted { get; set; }

    public GD_SearchHospitalsSoapAppController(ApexPages.StandardController controller) {
        hospitalToPost = new Hospital__c();
        hospitalToUpdate = new Hospital__c();
        hospitalsList = new List<Hospital__c>();
    }

    public void searchHospitals() {
        try {
            soapSforceComSchemasClassHhrSoapse.HospitalDTO dto = prepareSearchDto();
            List<soapSforceComSchemasClassHhrSoapse.HospitalDTO> searchResults = GD_KamilSoapApi.searchHospitalsResponse(dto);
            handleSearchResults(searchResults);
        } catch (Exception e) {
            ApexPages.addMessages(e);
        }
    }

    private soapSforceComSchemasClassHhrSoapse.HospitalDTO prepareSearchDto() {
        soapSforceComSchemasClassHhrSoapse.HospitalDTO dto = new soapSforceComSchemasClassHhrSoapse.HospitalDTO();

        String eName = String.escapeSingleQuotes(name);
        String eStreet = String.escapeSingleQuotes(street);
        String eCity = String.escapeSingleQuotes(city);
        String eCountry = String.escapeSingleQuotes(country);

        dto.hospitalName = eName;
        dto.street = eStreet;
        dto.city = eCity;
        dto.country = eCountry;

        return dto;
    }

    private List<Hospital__c> handleSearchResults(List<soapSforceComSchemasClassHhrSoapse.HospitalDTO> searchResults) {
        hospitalsList = new List<Hospital__c>();

        for (soapSforceComSchemasClassHhrSoapse.HospitalDTO hospitalDTO : searchResults) {
            Hospital__c hospital = new Hospital__c();
            hospital.Name = hospitalDTO.hospitalName;
            hospital.Phone_number__c = hospitalDTO.phone;

            hospital.Country__c = hospitalDTO.country;
            hospital.Street__c = hospitalDTO.street;
            hospital.City__c = hospitalDTO.city;

            hospital.Fax_number__c = hospitalDTO.fax;
            hospital.Helicopter_Access__c = hospitalDTO.helicopterAccess;
            hospital.No_Ambulances__c = Integer.valueOf(hospitalDTO.ambulanceNumber);

            hospital.External_Id__c = hospitalDTO.hospitalId;
            hospitalsList.add(hospital);
            if (hospitalsList.size() > 0) {
                showResult = true;
            }
        }

        return hospitalsList;
    }

    public void addNewHospital() {
        try {
            GD_KamilSoapApi.addNewHospitalResponse(hospitalToPost);
            recordAdded = true;
            newHospitalPopup = false;
            showNewHospitalError = false;
            hospitalToPost = new Hospital__c();
            searchHospitals();
        } catch (Exception e) {
            errorMessage = e.getMessage();
            showNewHospitalError = true;
        }
    }

    public void editHospital() {
        for (Hospital__c hospital : hospitalsList) {
            if (hospital.External_Id__c == hospitalIdsel) {
                hospitalToUpdate = hospital;
            }
        }
        updateHospitalPopup = true;
    }

    public void updateHospital() {
        try{
            GD_KamilSoapApi.updateHospitalResponse(hospitalToUpdate);
            updateHospitalPopup = false;
            showError = false;
            recordUpdated = true;
        } catch (Exception e){
            errorMessage = e.getMessage();
            showError = true;
        }
    }

    public void deleteHospital() {
        try {
            List<Id> idsToDelete = new List<Id>();
            idsToDelete.add(hospitalIdsel);
            GD_KamilSoapApi.deleteHospitalResponse(idsToDelete);
            deleteHospitalPopup = false;
            recordDeleted = true;
            searchHospitals();
            if (hospitalsList.size() <= 1) {
                showResult = false;
            }
        } catch (Exception e) {
            ApexPages.addMessages(e);
        }

    }

    public void openNewHospitalWindow() {
        newHospitalPopup = true;
    }

    public void openDeleteHospitalConfirmationWindow() {
        for (Hospital__c hospitalDel : hospitalsList) {
            if (hospitalDel.External_Id__c == hospitalIdsel) {
                hospital = hospitalDel;
            }
        }
        deleteConfirmationMessage = System.Label.Are_you_sure_you_want_to_delete_this_record + ': ' + hospital.Name + ' ?';
        deleteHospitalPopup = true;
    }

    public void closeDeleteHospitalConfirmationWindow() {
        deleteHospitalPopup = false;
    }

    public void closeUpdateHospitalWindow() {
        updateHospitalPopup = false;
        showError = false;
    }

    public PageReference clear() {
        PageReference newpage = new PageReference(System.currentPageReference().getURL());
        newpage.setRedirect(true);
        return newpage;
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
}