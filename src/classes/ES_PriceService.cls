public with sharing class ES_PriceService {
    private static ES_PriceService instance;

    private Map<Id, PricebookEntry> standardPricebookEntriesByProductId = new Map<Id, PricebookEntry>();

    private ES_PriceService() {
        getStandardPrices();
    }

    public static ES_PriceService getInstance() {
        if (instance == null) {
            instance = new ES_PriceService();
        }

        return instance;
    }

    public Decimal getStandardPrice(Id productId) {
        return standardPricebookEntriesByProductId.get(productId).UnitPrice;
    }

    public Decimal getPrices(Id productId) {
        return null; //todo
    }

    private static void getStandardPrices(String priceBookId){
        for (PricebookEntry pbe : getStandardPricebookEntries()) {
            standardPricebookEntriesByProductId.put(pbe.Product2Id, pbe);
        }
    }

    private static PricebookEntry[] getStandardPricebookEntries() {
        return [SELECT Product2Id, UnitPrice FROM PriceBookEntry WHERE Pricebook2.IsStandard = TRUE];
    }
}