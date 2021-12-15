public with sharing class ES_PriceManagerService {

    public static Pricebook2 getActivePricebook() {
        List<Pricebook2> activePricebook = [SELECT Id, ValidFrom__c, ValidTo__c, IsActive FROM Pricebook2 WHERE ValidFrom__c <= TODAY AND ValidTo__c >= TODAY AND IsActive = TRUE];
        return activePricebook.isEmpty() ? [SELECT Id FROM Pricebook2 WHERE IsStandard = TRUE] : activePricebook;
    }

    public static PriceBookWrapper[] getPriceBookWrappers(String searchName, Datetime searchStartDate, Datetime searchEndDate) {
        PriceBookWrapper[] priceBookWrappers = new PriceBookWrapper[]{
        };

        for (Pricebook2 pb : getPriceBooks(searchName, searchStartDate, searchEndDate)) {
            PriceBookWrapper pbWrapper = new PriceBookWrapper(pb);
            priceBookWrappers.add(pbWrapper);
        }

        return priceBookWrappers;
    }

    private static Pricebook2[] getPriceBooks(String searchName, Datetime searchStartDate, Datetime searchEndDate) {
        String searchKeyword = '%' + searchName + '%';

        return [
                SELECT Id, Name, Description, PhotoUrl__c, ValidFrom__c, ValidTo__c, IsActive
                FROM Pricebook2
                WHERE Name LIKE :searchKeyword
                AND ValidFrom__c >= :searchStartDate AND ValidTo__c <= :searchEndDate
                ORDER BY ValidFrom__c ASC
        ];
    }

    public class PriceBookWrapper {
        @AuraEnabled
        public Id id;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String photoUrl;
        @AuraEnabled
        public Datetime validFrom;
        @AuraEnabled
        public Datetime validTo;
        @AuraEnabled
        public Boolean isActive;

        public PriceBookWrapper(Pricebook2 pb) {
            this.id = pb.Id;
            this.name = pb.Name;
            this.photoUrl = pb.PhotoUrl__c;
            this.validFrom = pb.ValidFrom__c;
            this.validTo = pb.ValidTo__c;
            this.isActive = pb.IsActive;
        }

        public Pricebook2 getPricebook() {
            Pricebook2 pb = new Pricebook2(
                    Name = this.name,
                    ValidFrom__c = this.validFrom,
                    ValidTo__c = this.validTo,
                    PhotoUrl__c = this.photoUrl,
                    IsActive = this.isActive
            );
            if (this.id != null) {
                pb.Id = this.id;
            }
            return pb;
        }
    }

    public static ProductWrapper[] getProductWrappers() {
        return getProductWrappers(null, new Set<Id>());
    }

    public static ProductWrapper[] getProductWrappers(Id pricebookId) {
        return getProductWrappers(pricebookId, new Set<Id>());
    }

    public static ProductWrapper[] getProductWrappers(Id pricebookId, Set<Id> productIds) {
        ProductWrapper[] productWrappers = new ProductWrapper[]{
        };

        for (ES_Product productDTO : ES_ProductService.getProductDTOs(productIds)) {
            ProductWrapper productWrapper = new ProductWrapper(productDTO);
            if (pricebookId != null) {
                productWrapper.initializeCustomPrice(pricebookId, productDTO);
            }
            productWrappers.add(productWrapper);
        }
        return productWrappers;
    }

    public static Id savePriceBookWithProducts(PriceBookWrapper priceBookWrapper, ProductWrapper[] productWrappers) {
        Pricebook2 newPricebook = priceBookWrapper.getPricebook();
        upsert newPricebook;

        PricebookEntry[] newPricebookEntries = new PricebookEntry[]{
        };
        for (ProductWrapper productWrapper : productWrappers) {
            PricebookEntry pbe = productWrapper.getPricebookEntry(newPricebook.Id);
            newPricebookEntries.add(pbe);
        }
        upsert newPricebookEntries;
        return newPricebook.Id;
    }

    public static void checkIfNewPricebookOverlapWithOther(PriceBookWrapper priceBookWrapper) {

        if (priceBookWrapper.isActive) {
            String overlapMessage = System.Label.This_Price_Book_overlaps_the_following_active_Price_Books +' ';

            List<Pricebook2> overlapPricebookList = [
                    SELECT Id, Name, Description, PhotoUrl__c, ValidFrom__c, ValidTo__c, IsActive
                    FROM Pricebook2
                    WHERE IsActive = true AND ValidFrom__c <= :priceBookWrapper.validTo AND ValidTo__c >= :priceBookWrapper.validFrom AND (NOT Id = :priceBookWrapper.id)
            ];

            if (overlapPricebookList.size() != 0) {
                for (Pricebook2 pricebook2 : overlapPricebookList) {
                    overlapMessage += pricebook2.Name + ', ';
                }
                overlapMessage = overlapMessage.removeEnd(', ');
                throw new PriceBookValidationException(overlapMessage);
            }
        }
    }

    public class ProductWrapper {
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String productFamily;
        @AuraEnabled
        public String mainPicture;
        @AuraEnabled
        public Decimal standardPrice;
        @AuraEnabled
        public Decimal customPrice;
        @AuraEnabled
        public Id pbeId;

        public ProductWrapper(ES_Product productDTO) {
            this.id = productDTO.product.Id;
            this.name = productDTO.product.Name;
            this.productFamily = productDTO.product.Family;
            this.mainPicture = productDTO.product.MainPicture__c;
            this.standardPrice = productDTO.standardPrice;
            this.customPrice = this.standardPrice;
        }

        public void initializeCustomPrice(Id pricebookId, ES_Product productDTO) {
            System.debug(productDTO);
            this.customPrice = productDTO.customPrice?.getPrice(pricebookId) != null ? productDTO.customPrice.getPrice(pricebookId) : this.standardPrice;
            this.pbeId = productDTO.customPrice.getPriceBookEntryId(pricebookId);
        }


        public PricebookEntry getPricebookEntry(Id pricebookId) {
            PricebookEntry pbe = new PricebookEntry(
                    Pricebook2Id = pricebookId,
                    Product2Id = this.id,
                    UnitPrice = this.customPrice,
                    IsActive = true
            );
            if (this.pbeId != null) {
                pbe.Id = pbeId;
            }
            return pbe;
        }
    }

    public class PriceBookValidationException extends Exception {

    }
}