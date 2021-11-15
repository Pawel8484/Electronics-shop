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
        Pricebook2 standardPB = [select id from Pricebook2 where isStandard = true];
        PricebookEntry pricebookEntry = new PricebookEntry();
        pricebookEntry.Pricebook2Id = standardPB.Id;
        pricebookEntry.Product2Id = productId;
        pricebookEntry.UnitPrice = Decimal.valueOf(price);
        pricebookEntry.IsActive = true;
        try {
            upsert pricebookEntry;
        } catch (Exception ex) {
            System.debug(ex.getMessage());
        } finally {
            PricebookEntry secondPricebookEntry = [SELECT Id From PricebookEntry Where Product2Id = :productId AND Pricebook2Id = :standardPB.Id];
            pricebookEntry.Id = secondPricebookEntry.Id;
            update pricebookEntry;
        }
    }

    public static PricebookEntry getPrice(String productId) {
        Pricebook2 standardPB = [select id from Pricebook2 where isStandard = true];
        return [SELECT Id, UnitPrice FROM PricebookEntry WHERE Product2Id = :productId AND Pricebook2Id = :standardPB.Id LIMIT 1];
    }

    public static Product2 getMainPictureId(String productId) {
        return [SELECT MainPicture__c FROM Product2 WHERE Id = :productId LIMIT 1];
    }

}