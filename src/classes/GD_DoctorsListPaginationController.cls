public class GD_DoctorsListPaginationController {
    Public Integer size{get;set;} 
    Public Integer noOfRecords{get; set;} 
    public List<SelectOption> paginationSizeOptions{get;set;}
    
    public GD_DoctorsListPaginationController(DoctorsListWithController controller){
        size=10;
        paginationSizeOptions = new List<SelectOption>();
        paginationSizeOptions.add(new SelectOption('5','5'));
        paginationSizeOptions.add(new SelectOption('10','10'));
        paginationSizeOptions.add(new SelectOption('20','20'));
        paginationSizeOptions.add(new SelectOption('50','50'));
        paginationSizeOptions.add(new SelectOption('100','100'));
    }
    
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {                
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Name, Last_Name__c, Email__c, License_Number__c, Street__c, Postal_Code__c, City__c, Country__c from Doctor__c]));
                setCon.setPageSize(size);  
                noOfRecords = setCon.getResultSize();
            }            
            return setCon;
        }
        set;
    }
    
    //Changes the size of pagination
    public PageReference refreshPageSize() {
        setCon.setPageSize(size);
        return null;
    }
    
    // Initialize setCon and return a list of record    
    
    public List<Doctor__c> getDoctors() {
        return (List<Doctor__c>) setCon.getRecords();
    }
}