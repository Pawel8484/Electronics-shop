public with sharing class ES_PriceManagerController {

    @AuraEnabled(Cacheable=true)
    public static ES_PriceManagerService.ProductWrapper[] getProductWrappers(String pricebookId) {
        try {
            return String.isNotEmpty(pricebookId) ? ES_PriceManagerService.getProductWrappers(pricebookId) : ES_PriceManagerService.getProductWrappers();
        } catch (Exception e) {
//            throw e;
            throw new AuraHandledException(e.getMessage());
        }
    }

//    @AuraEnabled(Cacheable=true)
//    public static ES_PriceManagerService.PriceBookWrapper[] getPriceBookWrappers() {
//        try {
//            return ES_PriceManagerService.getPriceBookWrappers();
//        } catch (Exception e) {
//            throw new AuraHandledException(e.getMessage());
//        }
//    }

    @AuraEnabled(Cacheable=true)
    public static ES_PriceManagerService.PriceBookWrapper[] getPriceBookWrappers(String searchName, Datetime searchStartDate, Datetime searchEndDate) {
        try {
            System.debug(searchName + searchStartDate + searchEndDate);
            return ES_PriceManagerService.getPriceBookWrappers(searchName, searchStartDate, searchEndDate);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Id savePriceBookWithProducts(String pricebook, String products) {
        try {
            ES_PriceManagerService.PriceBookWrapper priceBookWrapper = (ES_PriceManagerService.PriceBookWrapper)JSON.deserialize(pricebook, ES_PriceManagerService.PriceBookWrapper.class);
            ES_PriceManagerService.ProductWrapper[] productWrappers = (List<ES_PriceManagerService.ProductWrapper>)JSON.deserialize(products, List<ES_PriceManagerService.ProductWrapper>.class);

            return ES_PriceManagerService.savePriceBookWithProducts(priceBookWrapper, productWrappers);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void checkIfNewPricebookOverlapWithOther(String pricebook) {
        try {
            ES_PriceManagerService.PriceBookWrapper priceBookWrapper = (ES_PriceManagerService.PriceBookWrapper)JSON.deserialize(pricebook, ES_PriceManagerService.PriceBookWrapper.class);
            ES_PriceManagerService.checkIfNewPricebookOverlapWithOther(priceBookWrapper);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}