({
    onInit: function (component, event, helper) {
        helper.getProductId(component, event);
        helper.getProductPrice(component, event);
        helper.getProductMainImageId(component, event);
    },
})