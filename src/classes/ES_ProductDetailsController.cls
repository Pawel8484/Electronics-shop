public with sharing class ES_ProductDetailsController {

    @AuraEnabled(Cacheable=true)
    public static ES_PriceManagerService.ProductWrapper getProductWrapper(Id productId) {
        try {
            return ES_ProductDetailsService.getProductsWrapper(productId).get(0);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}