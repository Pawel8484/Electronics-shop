public with sharing class ES_PriceManagerController {
    @AuraEnabled
    public static ES_PriceManagerService.ProductWrapper[] getProductWrappers() {
        try {
            return ES_PriceManagerService.getProductWrappers();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}