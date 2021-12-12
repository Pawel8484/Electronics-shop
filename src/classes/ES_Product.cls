public class ES_Product {
    public Product2 product;
    public Decimal standardPrice = 0;
    public ES_PriceService.ProductPrice customPrice;

    public ES_Product(Product2 product) {
        this.product = product;
        this.standardPrice = ES_PriceService.getInstance().getStandardPrice(product.Id);
        this.customPrice = ES_PriceService.getInstance().getPrices(product.Id);
    }
}