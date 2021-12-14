public with sharing class ES_ProductSearchExpCloudController {

    @AuraEnabled(Cacheable=true)
    public static ES_ProductSearchExpCloudService.ProductsWrap getProductsWrapper(String searchName) {
        System.debug('SEARCH: ' + searchName);
        try {
            return ES_ProductSearchExpCloudService.getProductsWrapper(searchName);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}