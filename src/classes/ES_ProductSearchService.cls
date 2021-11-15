public with sharing class ES_ProductSearchService {

    public static List<Product2> getSelectedProductsList(SelectedProductRequest selectedProductRequest) {
        String term = String.escapeSingleQuotes('%' + selectedProductRequest.term + '%');
        String category = categoryVerification(selectedProductRequest.category);
        System.debug('term: ' + term + 'category: ' + category);
        List<Product2> productList = [SELECT Id, Name, Family, MainPicture__c FROM Product2 WHERE Name LIKE :term AND Family LIKE :category];
        System.debug(productList);
        return productList;
    }

    private static String categoryVerification(String category) {
        if (category == 'all' || category == 'Select category...') {
            return '%%';
        }
        return '%' + category + '%';
    }

    public class SelectedProductRequest {
        public String term;
        public String category;
    }

}