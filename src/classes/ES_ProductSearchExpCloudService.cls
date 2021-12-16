public with sharing class ES_ProductSearchExpCloudService {

//    public static ES_PriceManagerService.ProductWrapper[] getProductsWrapper(SearchRequest searchRequest) {
//        Set<Id> productsIds = getFilteredProductIds(searchRequest);
//        Pricebook2 activePricebook = ES_PriceManagerService.getActivePricebook();
//        System.debug('AP: ' + activePricebook);
//        return ES_PriceManagerService.getProductWrappers(activePricebook.Id, productsIds);
//    }

    public static ES_PriceManagerService.ProductWrapper[] getProductsWrapper(SearchRequest searchRequest) {
        Pricebook2 activePricebook = ES_PriceManagerService.getActivePricebook();
        Set<Id> productsIds = getFilteredProductIds(searchRequest, activePricebook);
        System.debug('AP: ' + activePricebook);
//        return ES_PriceManagerService.getProductWrappers(activePricebook.Id, productsIds);
        return productsIds.isEmpty() ? null : ES_PriceManagerService.getProductWrappers(activePricebook.Id, productsIds);
    }

//    private static Set<Id> getFilteredProductIds(SearchRequest searchRequest) {
//        String name1 = String.escapeSingleQuotes('%' + searchRequest.searchName + '%');
//        String minPrice = searchRequest.searchMinPrice;
//        String maxPrice = searchRequest.searchMaxPrice;
//        System.debug(minPrice + '......' + maxPrice);
//        List<Product2> productList = [SELECT Id, Name, Family, MainPicture__c FROM Product2 WHERE Name LIKE :name1];
//        return new Map<Id, Product2>(productList).keySet();
//    }

    private static Set<Id> getFilteredProductIds(SearchRequest searchRequest, Pricebook2 activePricebook) {
        String name1 = String.escapeSingleQuotes('%' + searchRequest.searchName + '%');
//        String name1 = searchRequest.searchName;
        Integer minPrice = searchRequest.minPrice;
        Integer maxPrice = searchRequest.maxPrice;
        System.debug(name1 +'  ' + minPrice + '......' + maxPrice + 'AP: ' + activePricebook);
//        List<Product2> productList = [SELECT Id, Name, Family, MainPicture__c FROM Product2 WHERE Name LIKE :name1];
//        List<Product2> productList = [SELECT Product2, Product2.Id FROM PricebookEntry WHERE Product2.Id IN :[SELECT Product2.Id, Product2.Name, Pricebook2.Id, UnitPrice FROM PricebookEntry WHERE Product2.Name LIKE :name1 AND UnitPrice >= :minPrice AND UnitPrice <= :maxPrice]];

//        PricebookEntry[] pbes = new PricebookEntry[]{};
//        PricebookEntry[] pbes = [SELECT Product2Id FROM PricebookEntry WHERE Product2.Name LIKE :name1 AND UnitPrice >= :minPrice AND UnitPrice <= :maxPrice AND Product2.Family IN :categories AND Product2.BrandName__c IN :brandNames];
        PricebookEntry[] pbes = [SELECT Product2Id FROM PricebookEntry WHERE Product2.Name LIKE :name1 AND UnitPrice >= :minPrice AND UnitPrice <= :maxPrice AND Pricebook2Id = :activePricebook.Id];

        Set<Id> productIds = new Set<Id>();
        for(PricebookEntry pbe : pbes) {
            productIds.add(pbe.Product2Id);
        }

        return productIds;
    }

    public class SearchRequest {
        public String searchName;
        public Integer minPrice;
        public Integer maxPrice;
    }

}