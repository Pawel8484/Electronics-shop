@IsTest
public with sharing class GD_ContractTriggerHandlerTest {

    @TestSetup
    private static void testSetup() {

        List<Doctor__c> testDoctorsList = new List<Doctor__c>();
        Doctor__c doctor = new Doctor__c(Name = 'Piotr');
        testDoctorsList.add(doctor);
        Doctor__c doctor1 = new Doctor__c(Name = 'Mariusz');
        testDoctorsList.add(doctor1);
        insert testDoctorsList;

        List<Hospital__c> testHospitalsList = new List<Hospital__c>();
        Hospital__c hospital = new Hospital__c(Name = 'East Road Hospital');
        testHospitalsList.add(hospital);
        Hospital__c hospital1 = new Hospital__c(Name = 'St. Helen Hospital');
        testHospitalsList.add(hospital1);
        insert testHospitalsList;

        Contract__c contract = new Contract__c(Doctor__c = doctor.Id, Hospital__c = hospital.Id, Start_Date__c = Date.newInstance(2021, 02, 01),
                End_Date__c = Date.newInstance(2021, 02, 28));
        insert contract;
    }

    @IsTest
    private static void shouldReturnTrue_TheSamePeriodDifferentHospitals() {
//        Given
        Doctor__c doctor = [SELECT Name FROM Doctor__c WHERE Name = 'Piotr'];
        Hospital__c hospital = [SELECT Name FROM Hospital__c WHERE Name = 'St. Helen Hospital'];
        Contract__c contract1 = new Contract__c(Doctor__c = doctor.Id, Hospital__c = hospital.Id, Start_Date__c = Date.newInstance(2021, 02, 01),
                End_Date__c = Date.newInstance(2021, 02, 28));
//        When
        Test.startTest();
        insert contract1;
        Test.stopTest();
//        Then
        System.assertEquals(2, [SELECT Id FROM Contract__c WHERE Doctor__c = :doctor.Id].size(), 'We expect 2 contracts');
    }

    @IsTest
    private static void shouldReturnFalse_NewContractBeginsWhenPreviousContractHasNotEndedInTheSameHospital() {

        Doctor__c doctor = [SELECT Name FROM Doctor__c WHERE Name = 'Piotr'];
        Hospital__c hospital = [SELECT Name FROM Hospital__c WHERE Name = 'East Road Hospital'];
        Contract__c contract2 = new Contract__c(Doctor__c = doctor.Id, Hospital__c = hospital.Id, Start_Date__c = Date.newInstance(2021, 02, 25),
                End_Date__c = Date.newInstance(2021, 04, 25));

        Test.startTest();
        Database.SaveResult result = Database.insert(contract2, false);
        Test.stopTest();

        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        String errorExtract = result.getErrors()[0].getMessage().substring(0,33);
        System.assertEquals(System.Label.Contract_Error_Message_Test,
                errorExtract);
    }

    @IsTest
    private static void shouldReturnFalse_NewContractStartsOnTheLastDayOfAnotherContractInTheSameHospital() {

        Doctor__c doctor = [SELECT Name FROM Doctor__c WHERE Name = 'Piotr'];
        Hospital__c hospital = [SELECT Name FROM Hospital__c WHERE Name = 'East Road Hospital'];
        Contract__c contract3 = new Contract__c(Doctor__c = doctor.Id, Hospital__c = hospital.Id, Start_Date__c = Date.newInstance(2021, 02, 28),
                End_Date__c = Date.newInstance(2021, 04, 28));

        Test.startTest();
        Database.SaveResult result = Database.insert(contract3, false);
        Test.stopTest();

        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        String errorExtract = result.getErrors()[0].getMessage().substring(0,33);
        System.assertEquals(System.Label.Contract_Error_Message_Test,
                errorExtract);
    }

    @IsTest
    private static void shouldReturnFalse_NewContractStartsBeforeAnotherContractAndEndsAfterItInTheSameHospital() {

        Doctor__c doctor = [SELECT Name FROM Doctor__c WHERE Name = 'Piotr'];
        Hospital__c hospital = [SELECT Name FROM Hospital__c WHERE Name = 'East Road Hospital'];
        Contract__c contract4 = new Contract__c(Doctor__c = doctor.Id, Hospital__c = hospital.Id, Start_Date__c = Date.newInstance(2021, 01, 01),
                End_Date__c = Date.newInstance(2021, 04, 28));

        Test.startTest();
        Database.SaveResult result = Database.insert(contract4, false);
        Test.stopTest();

        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        String errorExtract = result.getErrors()[0].getMessage().substring(0,33);
        System.assertEquals(System.Label.Contract_Error_Message_Test,
                errorExtract);
    }
}