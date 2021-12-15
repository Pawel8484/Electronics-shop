public with sharing class ES_ProductSearchExpCloudController {

    @AuraEnabled(Cacheable=true)
    public static ES_PriceManagerService.ProductWrapper[] getProductsWrapper(String searchName) {
//        System.debug('SEARCH: ' + searchRequestJson);
        try {
            ES_ProductSearchExpCloudService.SearchRequest searchRequest = new ES_ProductSearchExpCloudService.SearchRequest();
            searchRequest.searchName = searchName;
//            ES_ProductSearchExpCloudService.SearchRequest searchRequest = (ES_ProductSearchExpCloudService.SearchRequest) JSON.deserialize(searchRequestJson, ES_ProductSearchExpCloudService.SearchRequest.class);
            return ES_ProductSearchExpCloudService.getProductsWrapper(searchRequest);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}