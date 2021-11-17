public with sharing class ES_ProductSearchController {

//    @AuraEnabled
//    public static List<Product2> getSelectedProductsList(String searchParams) {
//        try {
//            ES_ProductSearchService.SelectedProductRequest selectedProductRequest = (ES_ProductSearchService.SelectedProductRequest) JSON.deserialize(searchParams, ES_ProductSearchService.SelectedProductRequest.class);
//            return ES_ProductSearchService.getSelectedProductsList(selectedProductRequest);
//        } catch (Exception e) {
//            throw new AuraHandledException(e.getMessage());
//        }
//    }

    @AuraEnabled
    public static ES_ProductSearchService.ProductsWrap getSelectedProductsList(String searchParams) {
        try {
            ES_ProductSearchService.SelectedProductRequest selectedProductRequest = (ES_ProductSearchService.SelectedProductRequest) JSON.deserialize(searchParams, ES_ProductSearchService.SelectedProductRequest.class);
            return ES_ProductSearchService.getSelectedProductsList(selectedProductRequest);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}