public class GD_RandomDoctorsList {
    @AuraEnabled
    public static List<Doctor__c> getDoctors(){
        List<Doctor__c> doctors = [SELECT Id, Name, Last_Name__c, Phone__c, License_Number__c FROM Doctor__c LIMIT 10];
        return doctors;
    }
}