public with sharing class GD_RandomDoctorsGeneratorController {

    public GD_RandomDoctorsGeneratorController() {

    }

    public static List<Doctor__c> getDoctors() {
        Integer numberOfDoctors = [SELECT count() FROM Doctor__c];
        Integer randomNumber = Math.floor(Math.random() * numberOfDoctors).intValue();
        List<Doctor__c> doctors = [SELECT Id, Name, Last_Name__c, Phone__c, License_Number__c FROM Doctor__c LIMIT 10 OFFSET :randomNumber];
        return doctors;
    }
}