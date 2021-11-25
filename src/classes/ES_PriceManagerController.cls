public with sharing class ES_PriceManagerController {

    @AuraEnabled(Cacheable=true)
    public static ES_PriceManagerService.ProductWrapper[] getProductWrappers() {
        try {
            return ES_PriceManagerService.getProductWrappers();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(Cacheable=true)
    public static ES_PriceManagerService.PriceBookWrapper[] getPriceBookWrappers() {
        try {
            return ES_PriceManagerService.getPriceBookWrappers();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}