public class DoctorsListWithController {

    public Boolean showResult { get; set; }
    public Integer noOfRecords { get; set; }
    public Integer size { get; set; }
    public List<SelectOption> paginationSizeOptions { get; set; }
    public String name { get; set; }
    public String lastName { get; set; }
    public String country { get; set; }
    public Doctor__c record { get; set; }
    public List<Doctor__c> doctorsList;
    private String sortDirection = 'ASC';
    private String sortExp = 'Last_Name__c';
    public Id recId { get; set; }
    public ApexPages.StandardSetController setCon { get; set; }

    public DoctorsListWithController() {
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
        if (record.Email__c == null) {
            record.Email__c.addError(System.Label.Error_You_must_enter_a_value);
            showResult = false;
        } else {
            if (setCon.getResultSize() > 0) {
                showResult = true;
            }
        }
    }

    public List<Doctor__c> getDoctorsList() {
        if (String.isBlank(name) && String.isBlank(lastName) && String.isBlank(record.Email__c) && String.isBlank(country)) {
            doctorsList = new List<Doctor__c>();
        } else {
            String sFirstName = String.escapeSingleQuotes('%' + name + '%');
            String sLastName = String.escapeSingleQuotes('%' + lastName + '%');
            String sEmail = String.escapeSingleQuotes('%' + record.Email__c + '%');
            String sCountry = String.escapeSingleQuotes('%' + country + '%');
            listOfDoctors(sFirstName, sLastName, sEmail, sCountry);
        }
        return doctorsList;
    }

    private void listOfDoctors(String sFirstName, String sLastName, String sEmail, String sCountry) {

        string sortFullExp = sortExpression + ' ' + sortDirection;

        doctorsList = Database.query('SELECT Id, Name, Last_Name__c, Email__c, License_Number__c, Street__c, Postal_Code__c, City__c, Country__c FROM Doctor__c WHERE Name LIKE :sFirstName AND Last_Name__c LIKE :sLastName\n' +
                '                    AND Email__c LIKE :sEmail AND Country__c LIKE :sCountry ORDER BY ' + sortFullExp + ' NULLS LAST');
    }

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

    public String sortExpression {
        get {
            return sortExp;
        }
        set {
            if (value == sortExp)
                sortDirection = (sortDirection == 'ASC') ? 'DESC' : 'ASC'; else
                    sortDirection = 'ASC';
            sortExp = value;
        }
    }

    public String getSortDirection() {
        if (sortExpression == null || sortExpression == '')
            return 'ASC'; else
                return sortDirection;
    }

    public void setSortDirection(String value) {
        sortDirection = value;
    }

    public String getToCSV() {

        String header = 'Record Full Name; Email; License Number; Full Address \n';
        String finalStr = header;
        for (Doctor__c dr : doctorsList) {
            String recordString = String.join(new List<String>{
                    dr.Last_Name__c + ' ' + dr.Name, dr.Email__c, String.valueOf(dr.License_Number__c), dr.Country__c + ' ' + dr.Street__c + ' ' + dr.Postal_Code__c + ' ' + dr.City__c
            }, ';');
            finalStr += recordString + '\n';
        }
        return finalStr;
    }
}