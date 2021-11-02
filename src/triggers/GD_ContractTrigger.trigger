trigger GD_ContractTrigger on Contract__c (before insert, before update, before delete, after insert,
        after update, after delete, after undelete) {

    new GD_ContractTriggerHandler().run();
}