public with sharing class ES_ProductDetailsService {

    public static ES_PriceManagerService.ProductWrapper[] getProductsWrapper(Id productId) {
        Pricebook2 activePricebook = ES_PriceManagerService.getActivePricebook();
        Set<Id> productsIds = getFilteredProductIds(productId, activePricebook);
        System.debug('AP: ' + activePricebook);
//        return ES_PriceManagerService.getProductWrappers(activePricebook.Id, productsIds);
        return ES_PriceManagerService.getProductWrappers(activePricebook.Id, productsIds);
    }

    private static Set<Id> getFilteredProductIds(Id productId, Pricebook2 activePricebook) {
        PricebookEntry[] pbes = [SELECT Product2Id FROM PricebookEntry WHERE  Product2Id = :productId AND Pricebook2Id = :activePricebook.Id];

        Set<Id> productIds = new Set<Id>();
        for(PricebookEntry pbe : pbes) {
            productIds.add(pbe.Product2Id);
        }

        return productIds;
    }

}