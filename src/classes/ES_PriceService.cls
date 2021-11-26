public with sharing class ES_PriceService {
    private static ES_PriceService instance;

    private Map<Id, PricebookEntry> standardPricebookEntriesByProductId = new Map<Id, PricebookEntry>();
    private Map<Id, ProductPrice> productPricesByProductIds = new Map<Id, ProductPrice>();

    private ES_PriceService() {
        getStandardPrices();
        getAllPrices();
    }

    public static ES_PriceService getInstance() {
        if (instance == null) {
            instance = new ES_PriceService();
        }
        return instance;
    }

    public Decimal getStandardPrice(Id productId) {
        return this.standardPricebookEntriesByProductId.get(productId).UnitPrice;
    }

    public ProductPrice getPrices(Id productId) {
        return this.productPricesByProductIds.get(productId);
    }

    private void getStandardPrices(){
        for (PricebookEntry pbe : getStandardPricebookEntries()) {
            this.standardPricebookEntriesByProductId.put(pbe.Product2Id, pbe);
        }
    }

    private PricebookEntry[] getStandardPricebookEntries() {
        return [SELECT Product2Id, UnitPrice FROM PriceBookEntry WHERE Pricebook2.IsStandard = TRUE];
    }

    private void getAllPrices(){
        for (PricebookEntry pbe : getPricebookEntries()) {
            if (this.productPricesByProductIds.containsKey(pbe.Product2Id)) {
                ProductPrice productPrice = this.productPricesByProductIds.get(pbe.Product2Id);
                productPrice.addPrice(pbe);
            } else {
                ProductPrice productPrice = new ProductPrice();
                productPrice.addPrice(pbe);
                this.productPricesByProductIds.put(pbe.Product2Id, productPrice);
            }
        }
    }

    private PricebookEntry[] getPricebookEntries() {
        return [SELECT Pricebook2Id, Product2Id, UnitPrice FROM PriceBookEntry WHERE Pricebook2.IsStandard = FALSE];
    }

    public class ProductPrice {
        private Map<Id, PricebookEntry> pricebookEntriesByPricebookIds = new Map<Id, PricebookEntry>();

        private void addPrice(PricebookEntry pbe) {
            this.pricebookEntriesByPricebookIds.put(pbe.Pricebook2Id, pbe);
        }

        public Decimal getPrice(Id pricebookId) {
            return pricebookEntriesByPricebookIds?.get(pricebookId)?.UnitPrice;
        }
    }
}