global class ES_ScheduledDeactivateOldPriceBooks implements Schedulable{
    global void execute(SchedulableContext SC) {
        List<Pricebook2> oldPriceBooks = [SELECT Id, Name, ValidTo__c FROM Pricebook2 WHERE ValidTo__c < TODAY];

        for (Pricebook2 pricebook: oldPriceBooks) {
            pricebook.IsActive = false;
        }
        update oldPriceBooks;
    }

}