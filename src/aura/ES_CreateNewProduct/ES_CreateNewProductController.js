({
    onInit: function (component, event, helper) {
        helper.getProductId(component, event);
    },

    setSecondStep: function (component, event, helper) {
        helper.setSecondStep(component, event);
    },

    setThirdStep: function (component, event, helper) {
        helper.setThirdStep(component, event);
    },

    backToFirstStep: function (component, event, helper) {
        helper.backToFirstStep(component, event);
    },

    backToSecondStep: function (component, event, helper) {
        helper.backToSecondStep(component, event);
    },

    setMainPicture: function (component, event) {
        component.set("v.mainPictureId", event.getParam("mainPictureId"));
    },

//    addPrice: function (component, event, helper) {
//        helper.addPrice(component);
//    },

    saveNewProduct: function (component, event, helper) {
        helper.saveNewProduct(component);
    },

     saveUpdatedProduct: function (component, event, helper) {
         helper.saveUpdatedProduct(component);
    },

    saveAndNewProduct: function (component, event, helper) {
        helper.saveAndNewProduct(component);
    },
})