public with sharing class ES_ProductSearchExpCloudController {

    @AuraEnabled(Cacheable=true)
    public static ES_PriceManagerService.ProductWrapper[] getProductsWrapper(String searchRequestJson) {
        System.debug('SEARCH: ' + searchRequestJson);
        try {
            ES_ProductSearchExpCloudService.SearchRequest searchRequest = (ES_ProductSearchExpCloudService.SearchRequest) JSON.deserialize(searchRequestJson, ES_ProductSearchExpCloudService.SearchRequest.class);
            System.debug(searchRequest);
            return ES_ProductSearchExpCloudService.getProductsWrapper(searchRequest);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}