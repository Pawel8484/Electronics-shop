public with sharing class ES_ProductSearchExpCloudService {

    public static ProductsWrap getProductsWrapper(String searchName) {
        List<ProductItem> productListToWrap = new List<ProductItem>();
        String name1 = String.escapeSingleQuotes('%' + searchName + '%');
        List<Product2> productList = [SELECT Id, Name, Family, MainPicture__c FROM Product2 WHERE Name LIKE :name1];
        List<PricebookEntry> priceList = [SELECT Id, Product2Id, Product2.Name, Product2.IsActive, UnitPrice, Pricebook2.IsStandard FROM PricebookEntry WHERE Product2.IsActive = true AND Pricebook2.IsStandard = true AND Product2Id IN (SELECT Id FROM Product2 WHERE Name LIKE :name1)];
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
        System.debug(productsWrap);
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