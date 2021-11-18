public with sharing class ES_ProductController {

    @AuraEnabled
    public static List<ContentVersion> getPicturesList(String productId) {
        return ES_ProductService.getPictures(productId);
    }

    @AuraEnabled
    public static void setPicture(String mainPictureId, String productId) {
        ES_ProductService.setMainPicture(mainPictureId, productId);
    }

    @AuraEnabled
    public static void setPrice(String price, String productId) {
        ES_ProductService.setPrice(price, productId);
    }

    @AuraEnabled
    public static Double getPrice(String productId) {
        PricebookEntry pbe = ES_ProductService.getPrice(productId);
        return pbe.UnitPrice;
    }

    @AuraEnabled
    public static String getMainPictureId(String productId) {
        return ES_ProductService.getMainPictureId(productId).MainPicture__c;
    }

    @AuraEnabled
    public static void deleteProduct(String productId) {
        ES_ProductService.deleteProduct(productId);
    }



//    @AuraEnabled
//    public static void setUpdatedPrice(String price, String productId) {
//        ES_ProductService.setUpdatedPrice(price, productId);
//    }
}