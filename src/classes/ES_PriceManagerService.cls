public with sharing class ES_PriceManagerService {

    public static PriceBookWrapper[] getPriceBookWrappers() {
        PriceBookWrapper[] priceBookWrappers = new PriceBookWrapper[]{};

        for (Pricebook2 pb : getPriceBooks()) {
            PriceBookWrapper pbWrapper = new PriceBookWrapper(pb);
            priceBookWrappers.add(pbWrapper);
        }

        return priceBookWrappers;
    }

    private static Pricebook2[] getPriceBooks() {
        return [
                SELECT Id, Name, Description, PhotoUrl__c, ValidFrom__c, ValidTo__c
                FROM Pricebook2
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

        public PriceBookWrapper(Pricebook2 pb) {
            this.id = pb.Id;
            this.name = pb.Name;
            this.photoUrl = pb.PhotoUrl__c;
            this.validFrom = pb.ValidFrom__c;
            this.validTo = pb.ValidTo__c;
        }

        public Pricebook2 getPricebook() {
            return new Pricebook2(
                    Name = this.name,
                    ValidFrom__c = this.validFrom,
                    ValidTo__c = this.validTo,
                    PhotoUrl__c = this.photoUrl
            );
        }
    }

    public static ProductWrapper[] getProductWrappers() {
        return getProductWrappers(null);
    }

    public static ProductWrapper[] getProductWrappers(Id pricebookId) {
        ProductWrapper[] productWrappers = new ProductWrapper[]{};

        for (ES_Product productDTO : ES_ProductService.getProductDTOs()) {
            ProductWrapper productWrapper = new ProductWrapper(productDTO);
            if (pricebookId != null) {
                productWrapper.initializeCustomPrice(pricebookId, productDTO);
            }
            productWrappers.add(productWrapper);
        }
        return productWrappers;
    }

    public static Id savePriceBookWithProducts(PriceBookWrapper priceBookWrapper, ProductWrapper[] productWrappers){
            Pricebook2 newPricebook = priceBookWrapper.getPricebook();
            insert newPricebook;

            PricebookEntry[] newPricebookEntries = new PricebookEntry[]{};
            for (ProductWrapper productWrapper : productWrappers) {
                PricebookEntry pbe = productWrapper.getPricebookEntry(newPricebook.Id);
                newPricebookEntries.add(pbe);
            }
//            insert pbe;
            insert newPricebookEntries;
            return newPricebook.Id;
    }

    public class ProductWrapper {
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String productFamily;
        @AuraEnabled
        public Decimal standardPrice;
        @AuraEnabled
        public Decimal customPrice;

        public ProductWrapper(ES_Product productDTO) {
            this.id = productDTO.product.Id;
            this.name = productDTO.product.Name;
            this.productFamily = productDTO.product.Family;
            this.standardPrice = productDTO.standardPrice;
            this.customPrice = this.standardPrice;
        }

        public void initializeCustomPrice(Id pricebookId, ES_Product productDTO) {
            this.customPrice = productDTO.customPrice.getPrice(pricebookId);
        }

        public PricebookEntry getPricebookEntry(Id pricebookId) {
            return new PricebookEntry(
                    Pricebook2Id = pricebookId,
                    Product2Id = this.id,
                    UnitPrice = this.customPrice
            );
        }
    }
}