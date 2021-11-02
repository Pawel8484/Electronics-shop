public class GD_SearchDoctorsInKamilApp {

    public Boolean showResult { get; set; }
    public Integer noOfRecords { get; set; }
    public Integer size { get; set; }
    public List<SelectOption> paginationSizeOptions { get; set; }
    public String name { get; set; }
    public String lastName { get; set; }
    public String email { get; set; }
    public String country { get; set; }
    public Doctor__c record { get; set; }
    public List<Doctor__c> doctorsList;
    private String sortDirection = 'ASC';
    private String sortExp = 'Last_Name__c';
    public Id recId { get; set; }
    public ApexPages.StandardSetController setCon { get; set; }

    public GD_SearchDoctorsInKamilApp() {
        record = new Doctor__c();
        size = 10;
        sortDirection = 'ASC';
        noOfRecords = 0;
        recId = ApexPages.CurrentPage().getParameters().get('id');
        setCon = new ApexPages.StandardSetController(new List<Doctor__c>());
        paginationSizeOptions = new List<SelectOption>();
        paginationSizeOptions.add(new SelectOption('10', '10'));
        paginationSizeOptions.add(new SelectOption('20', '20'));
        paginationSizeOptions.add(new SelectOption('30', '30'));
    }

    public void search() {
        List<Doctor__c> doctorsList = getDoctorsList();
        setCon = new ApexPages.StandardSetController(doctorsList);
        System.debug(doctorsList);
        if (setCon.getResultSize() > 0) {
            showResult = true;
        }
    }


    public List<Doctor__c> getDoctorsList() {
        if (String.isBlank(name) && String.isBlank(lastName) && String.isBlank(email) && String.isBlank(country)) {
            doctorsList = new List<Doctor__c>();
        } else {
            String sFirstName = String.escapeSingleQuotes('%' + name + '%');
            String sLastName = String.escapeSingleQuotes('%' + lastName + '%');
            String sEmail = String.escapeSingleQuotes('%' + email + '%');
            String sCountry = String.escapeSingleQuotes('%' + country + '%');
            listOfDoctors(sFirstName, sLastName, sEmail, sCountry);
        }
        return doctorsList;
    }

//    private void listOfDoctors(String sFirstName, String sLastName, String sEmail, String sCountry) {
//        doctorsList = Database.query('SELECT Id, Name, Last_Name__c, Email__c, License_Number__c, Street__c, Postal_Code__c, City__c, Country__c FROM Doctor__c WHERE Name LIKE :sFirstName AND Last_Name__c LIKE :sLastName\n' +
//                '                    AND Email__c LIKE :sEmail AND Country__c LIKE :sCountry');
//        System.debug('DOCTOR LIST' + doctorsList);
//    }

    private void listOfDoctors(String sFirstName, String sLastName, String sEmail, String sCountry) {
//        doctorsList = GD_KamilRestApi.getRestDoctors(sFirstName, sLastName, sEmail, sCountry);
    }
//        doctorsList = Database.query('SELECT Id, Name, Last_Name__c, Email__c, License_Number__c, Street__c, Postal_Code__c, City__c, Country__c FROM Doctor__c WHERE Name LIKE :sFirstName AND Last_Name__c LIKE :sLastName\n' +
//                '                    AND Email__c LIKE :sEmail AND Country__c LIKE :sCountry');
//        System.debug('DOCTOR LIST' + doctorsList);

    public PageReference clear() {
        PageReference newpage = new PageReference(System.currentPageReference().getURL());
        newpage.setRedirect(true);
        return newpage;
    }

    public List<Doctor__c> getDoctors() {
        if (setCon.getResultSize() > 0) {
            setCon.setPageSize(size);
            noOfRecords = setCon.getResultSize();
            return (List<Doctor__c>) setCon.getRecords();
        }
        return null;
    }

    public void refreshPageSize() {
        setCon.setPageSize(size);
    }
}