public class ES_Product {
    public Product2 product;
    public Decimal standardPrice = 0;
//    public Map<Id, Decimal> priceByPriceBookId = new Map<Id, Decimal>();

    public ES_Product(Product2 product) {
        this.product = product;
        this.standardPrice = ES_PriceService.getInstance().getStandardPrice(product.Id);
        //this.priceByPriceBookId = ES_PriceService.getInstance().getPrices(product.Id);
    }
}