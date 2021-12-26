public with sharing class ES_CartController {

    @AuraEnabled(Cacheable=true)
    public static ES_CartService.Cart getCart(List<Id> productIds) {
        try {
            return ES_CartService.getCart(new Set<Id>(productIds));
        } catch (Exception e) {
            throw e;
            //aura handled exception
        }
    }
}