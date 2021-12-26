public class ES_CartService {
    public static Cart getCart(Set<Id> productIds) {
        //getActive pricebook
        //get product wrappers

        Pricebook2 activePricebook = ES_PriceManagerService.getActivePricebook();
        Set<Id> productsIds = getFilteredProductIds(productIds, activePricebook);
        ES_PriceManagerService.ProductWrapper[] productWrappers = ES_PriceManagerService.getProductWrappers(activePricebook.Id, productsIds);
        //new cart
        Cart cart = new Cart();

        //for each product in wrappers
        for (ES_PriceManagerService.ProductWrapper productWrapper : productWrappers) {
            CartItem cartItem = new CartItem(productWrapper);
            cart.addItem(cartItem);
        }
        System.debug(cart);
        return cart;

    }

    private static Set<Id> getFilteredProductIds(Set<Id> productIds, Pricebook2 activePricebook) {
        PricebookEntry[] pbes = [SELECT Product2Id FROM PricebookEntry WHERE  Product2Id IN :productIds AND Pricebook2Id = :activePricebook.Id];

        Set<Id> productIdsList = new Set<Id>();
        for(PricebookEntry pbe : pbes) {
            productIdsList.add(pbe.Product2Id);
        }

        return productIdsList;
    }

        //new cart
        //for each product in wrappers
        //new CartItem(wrapper)
//        cart.addItem(cartItem);

//        return cart;


    public class Cart {
        @AuraEnabled
        public CartItem[] items = new CartItem[]{};

        public void addItem(CartItem item) {
            this.items.add(item);
        }
    }

    public class CartItem {
        @AuraEnabled
        public String id;
        @AuraEnabled
        public ES_PriceManagerService.ProductWrapper product;
        @AuraEnabled
        public Integer quantity = 1;

        public CartItem(ES_PriceManagerService.ProductWrapper product) {
            this.id = product.id;
            this.product = product;
        }
    }
}