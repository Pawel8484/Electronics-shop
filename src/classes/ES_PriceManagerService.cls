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
                SELECT Id, Name, Description
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
    }

    public static ProductWrapper[] getProductWrappers() {
        ProductWrapper[] productWrappers = new ProductWrapper[]{};

        for (ES_Product productDTO : ES_ProductService.getProductDTOs()) {
            ProductWrapper productWrapper = new ProductWrapper(productDTO);
            productWrappers.add(productWrapper);
        }

        return productWrappers;
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
            this.customPrice = 0;
        }
    }
}