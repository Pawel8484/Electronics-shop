global class GD_StartContractReminderEmail implements Database.Batchable<sObject>, Schedulable {

    global String query;

    global GD_StartContractReminderEmail() {

    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        query = 'SELECT Name, Hospital__r.Name, Doctor__r.Name, Doctor_Email__c FROM Contract__c WHERE Start_Date__c = TODAY';
        System.debug(query);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Contract__c> scope) {
        GD_EmailManager.sendMail(scope);
    }

    global void finish(Database.BatchableContext bc) {

    }

    global void execute(SchedulableContext ctx){
        GD_StartContractReminderEmail batch = new GD_StartContractReminderEmail();
        Database.executeBatch(batch);
    }
}