public with sharing class ES_ProductSearchExpCloudService {

    public static ES_PriceManagerService.ProductWrapper[] getProductsWrapper(SearchRequest searchRequest) {
        Set<Id> productsIds = getFilteredProductIds(searchRequest);
        Pricebook2 activePricebook = ES_PriceManagerService.getActivePricebook();
        System.debug('AP: ' + activePricebook);
        return ES_PriceManagerService.getProductWrappers(activePricebook.Id, productsIds);
    }

    private static Set<Id> getFilteredProductIds(SearchRequest searchRequest) {
        String name1 = String.escapeSingleQuotes('%' + searchRequest.searchName + '%');
        List<Product2> productList = [SELECT Id, Name, Family, MainPicture__c FROM Product2 WHERE Name LIKE :name1];
        return new Map<Id, Product2>(productList).keySet();
    }

    public class SearchRequest {
        public String searchName;
    }

}