({
    getProductId: function (component, event) {
        let id = component.get("v.pageReference");
        const urlAddress = window.location.href;
        const result = urlAddress.match(new RegExp('Product2/' + "(.*)" + '/view'));
        component.set("v.recordId", result[1]);
    },

    setSecondStep: function (component, event) {
        const record = event.getParam("response");
        const productId = record.id;
        component.set("v.productAdded", true);
        component.set("v.currentStep", "step2");
        component.set("v.recordId", productId);
    },

    setThirdStep: function (component, event) {
        component.set("v.currentStep", "step3");
        let setPicture = component.get("c.setPicture");
        setPicture.setParams({
            "mainPictureId": component.get("v.mainPictureId"),
            "productId": component.get("v.recordId"),
        });
        $A.enqueueAction(setPicture);
    },

    backToFirstStep: function (component, event) {
        component.set("v.currentStep", "step1");
    },

    backToSecondStep: function (component, event) {
        component.set("v.currentStep", "step2");
    },

    saveNewProduct: function (component) {
        const helper = this;
        var fieldValue = component.find("price").get("v.validity");
        if(fieldValue.valueMissing === false){
        let setPrice = component.get("c.setPrice");
        setPrice.setParams({
            "price": component.get("v.standardPrice"),
            "productId": component.get("v.recordId"),
        });
        $A.enqueueAction(setPrice);
        this.showSuccessToast($A.get("$Label.c.Product_has_been_added"));
        let recordId = component.get("v.recordId");
         component.find("navService").navigate({
           "type": "standard__recordPage",
                "attributes": {
                    "recordId": recordId,
                    "objectApiName": "Product2",
                    "actionName": "view"
                }
        });
        component.set("v.mainPictureId", null);
        component.set("v.standardPrice", null);
        component.set("v.prod", null);
        component.set("v.recordId", "");
        component.set("v.currentStep", "step1");
        } else {
        this.showErrorToast($A.get("$Label.c.Complete_this_field"));
        }
    },

    saveUpdatedProduct: function (component) {
        const helper = this;
        var fieldValue = component.find("price").get("v.validity");
        if(fieldValue.valueMissing === false){
        let setPrice = component.get("c.setPrice");
        setPrice.setParams({
            "price": component.get("v.standardPrice"),
            "productId": component.get("v.recordId"),
        });
        $A.enqueueAction(setPrice);
        this.showSuccessToast($A.get("$Label.c.Product_has_been_updated"));
        let recordId = component.get("v.recordId");
         component.find("navService").navigate({
           "type": "standard__recordPage",
                "attributes": {
                    "recordId": recordId,
                    "objectApiName": "Product2",
                    "actionName": "view"
                }
        });
        component.set("v.mainPictureId", null);
        component.set("v.standardPrice", null);
        component.set("v.prod", null);
        component.set("v.recordId", "");
        component.set("v.currentStep", "step1");
        } else {
        this.showErrorToast($A.get("$Label.c.Complete_this_field"));
        }
    },

    saveAndNewProduct: function (component) {
        const helper = this;
        var fieldValue = component.find("price").get("v.validity");
        if(fieldValue.valueMissing === false){
        let setPrice = component.get("c.setPrice");
        setPrice.setParams({
            "price": component.get("v.standardPrice"),
            "productId": component.get("v.recordId"),
        });
        $A.enqueueAction(setPrice);
        this.showSuccessToast($A.get("$Label.c.Product_has_been_added"));
        component.set("v.mainPictureId", null);
        component.set("v.standardPrice", null);
        component.set("v.prod", null);
        component.set("v.recordId", "");
        component.set("v.currentStep", "step1");
        } else {
        this.showErrorToast($A.get("$Label.c.Complete_this_field"));
        }
    },

    cancel: function (component){
        const helper = this;
        this.navigateToRecordPage(component);
    },

    showSuccessToast: function (message){
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": $A.get("$Label.c.Success"),
            "message": message,
            "type": "success",
        });
        toastEvent.fire();
    },

    showErrorToast: function (message){
        const toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": $A.get("$Label.c.Error"),
            "message": message,
            "type": "error"
        });
        toastEvent.fire();
    },

    navigateToRecordPage: function (component){
      var navEvent = $A.get("e.force:navigateToList");
                 navEvent.setParams({
                     "scope": "Product2"
                 });
                 navEvent.fire();

    const action = component.get("c.deleteProduct");
    action.setParams({
        "productId": component.get("v.recordId"),
    });
    $A.enqueueAction(action);
    component.set("v.mainPictureId", null);
    component.set("v.standardPrice", null);
    component.set("v.prod", null);
    component.set("v.recordId", "");
    component.set("v.currentStep", "step1");
    },

})