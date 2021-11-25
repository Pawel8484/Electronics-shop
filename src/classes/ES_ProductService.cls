public with sharing class ES_ProductService {

    public static List<ContentVersion> getPictures(String productId) {
        return [SELECT ContentDocumentId, Title from ContentVersion WHERE FirstPublishLocationId = :productId];
    }

    public static void setMainPicture(String mainPictureId, String productId) {
        List<Product2> product2main = [
                SELECT Id, MainPicture__c
                FROM Product2
                WHERE Product2.Id = :productId
                LIMIT 1
        ];
        for (Product2 product2 : product2main) {
            product2.MainPicture__c = mainPictureId;
        }
        update product2main;
    }

    public static void setPrice(String price, String productId) {
        Pricebook2 standardPB = [SELECT Id FROM Pricebook2 WHERE isStandard = true];
        PricebookEntry pricebookEntry = new PricebookEntry();
        pricebookEntry.Pricebook2Id = standardPB.Id;
        pricebookEntry.Product2Id = productId;
        pricebookEntry.UnitPrice = Decimal.valueOf(price);
        pricebookEntry.IsActive = true;
        insert pricebookEntry;
    }

    public static void setUpdatedPrice(String price, String productId) {
        Pricebook2 standardPB = [SELECT Id FROM Pricebook2 WHERE isStandard = true];
        PricebookEntry pricebookEntry = [SELECT Id FROM PricebookEntry WHERE Product2Id = :productId AND Pricebook2Id = :standardPB.Id];
        pricebookEntry.UnitPrice = Decimal.valueOf(price);
        update pricebookEntry;
    }


    public static PricebookEntry getPrice(String productId) {
        Pricebook2 standardPB = [select id from Pricebook2 where isStandard = true];
        return [SELECT Id, UnitPrice FROM PricebookEntry WHERE Product2Id = :productId AND Pricebook2Id = :standardPB.Id LIMIT 1];
    }

    public static Product2 getMainPictureId(String productId) {
        return [SELECT MainPicture__c FROM Product2 WHERE Id = :productId LIMIT 1];
    }

    public static void deleteProduct(String productId) {
        List<Product2> productToDelete = [SELECT Id FROM Product2 WHERE Id = :productId LIMIT 1];
        delete productToDelete;
    }

    public static ES_Product[] getProductDTOs() {
        ES_Product[] productDTOs = new ES_Product[]{};

        for (Product2 product : getProducts()) {
            ES_Product productDTO = new ES_Product(product);
            productDTOs.add(productDTO);
        }
        return productDTOs;
    }

    private static Product2[] getProducts() {
        return [
                SELECT Id, Name, Family
                FROM Product2
        ];
    }
}