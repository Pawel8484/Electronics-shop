public class AccountSearchController {
    @AuraEnabled
    public static List<AggregateResult> getBillingCountry(){
        return [SELECT COUNT(Id), BillingCountry FROM Account GROUP BY BillingCountry];
    }
}