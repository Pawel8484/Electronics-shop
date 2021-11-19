public with sharing class ES_ProductSearchService {

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

    public static ProductsWrap getSelectedProductsList(SelectedProductRequest selectedProductRequest) {
        List<ProductItem> productListToWrap = new List<ProductItem>();
        String term = String.escapeSingleQuotes('%' + selectedProductRequest.term + '%');
        String category = categoryVerification(selectedProductRequest.category);
        List<Product2> productList = [SELECT Id, Name, Family, MainPicture__c FROM Product2 WHERE Name LIKE :term AND Family LIKE :category];
        List<PricebookEntry> priceList = [SELECT Id, Product2Id, Product2.Name, Product2.IsActive, UnitPrice FROM PricebookEntry WHERE Product2.IsActive = true AND Product2Id IN (SELECT Id FROM Product2 WHERE Name LIKE :term AND Family LIKE :category)];
                for (Product2 product : productList) {
                    for (PricebookEntry pricebookEntry : priceList) {
                        if(product.Id == pricebookEntry.Product2Id){
                            ProductItem productItem = new ProductItem();
                            productItem.id = product.Id;
                            productItem.name = product.Name;
                            productItem.mainPicture = product.MainPicture__c;
                            productItem.price = pricebookEntry.UnitPrice;
                            productListToWrap.add(productItem);
                        }
                    }
                }
        ProductsWrap productsWrap = new ProductsWrap();
        productsWrap.products = productListToWrap;
                return productsWrap;
    }

    public class ProductsWrap {
        @AuraEnabled
        public List<ProductItem> products;
    }

    public class ProductItem {
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String mainPicture;
        @AuraEnabled
        public Decimal price;
    }

}