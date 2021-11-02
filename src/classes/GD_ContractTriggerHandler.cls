public with sharing class GD_ContractTriggerHandler extends TriggerHandler {

    protected override void beforeInsert() {
        validateContractsDate();
    }

    protected override void beforeUpdate() {

    }

    private void validateContractsDate() {

        Set<Id> doctorIds = new Set<Id>();
        List<Contract__c> newContractsList = Trigger.new;

        checkIfNewContractsDoNotOverlapWithEachOther(newContractsList);

        for (Contract__c contract : newContractsList) {
            doctorIds.add(contract.Doctor__c);
        }
        List<Contract__c> doctorsContractsList = [SELECT Start_Date__c, End_Date__c, Doctor__c, Hospital__c, Name FROM Contract__c WHERE Doctor__c IN :doctorIds];

        for (Contract__c newContract : newContractsList) {
            for (Contract__c contract : doctorsContractsList) {
                if (newContract.Doctor__c == contract.Doctor__c
                        && newContract.Hospital__c == contract.Hospital__c
                        && newContract.Start_Date__c <= contract.End_Date__c
                        && newContract.End_Date__c >= contract.Start_Date__c) {
                    newContract.addError(String.format(System.Label.Contract_Error_Message,
                            new List<Object>{contract.Name, contract.Start_Date__c, contract.End_Date__c}));
                }
            }
        }
    }
    private static void checkIfNewContractsDoNotOverlapWithEachOther(List<Contract__c> newContractsList) {
        for (Integer i = 0; i < newContractsList.size(); i++) {
            Contract__c contractToCheck = newContractsList.get(i);
            for (Integer j = i + 1; j < newContractsList.size(); j++) {
                Contract__c anotherContract = newContractsList.get(i);
                if (contractToCheck.Doctor__c == anotherContract.Doctor__c
                        && contractToCheck.Hospital__c == anotherContract.Hospital__c
                        && contractToCheck.Start_Date__c <= anotherContract.End_Date__c
                        && contractToCheck.End_Date__c >= anotherContract.Start_Date__c) {
                    contractToCheck.addError(System.Label.New_Contract_Error_Message);
                }
            }
        }
    }
}