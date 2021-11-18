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
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success",
            "message": "Product has been added.",
            "type": "success",
        });
        toastEvent.fire();
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
        this.showErrorToast("Complete this field.");
        }
    },

    saveUpdatedProduct: function (component) {
        var fieldValue = component.find("price").get("v.validity");
        if(fieldValue.valueMissing === false){
        let setPrice = component.get("c.setPrice");
        setPrice.setParams({
            "price": component.get("v.standardPrice"),
            "productId": component.get("v.recordId"),
        });
        $A.enqueueAction(setPrice);
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success",
            "message": "Product has been updated.",
            "type": "success",
        });
        toastEvent.fire();
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
        this.showErrorToast("Complete this field.");
        }
    },

    saveAndNewProduct: function (component) {
        var fieldValue = component.find("price").get("v.validity");
        if(fieldValue.valueMissing === false){
        let setPrice = component.get("c.setPrice");
        setPrice.setParams({
            "price": component.get("v.standardPrice"),
            "productId": component.get("v.recordId"),
        });
        $A.enqueueAction(setPrice);
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success",
            "message": "Product has been added.",
            "type": "success",
        });
        component.set("v.mainPictureId", null);
        component.set("v.standardPrice", null);
        component.set("v.prod", null);
        component.set("v.recordId", "");
        component.set("v.currentStep", "step1");
        } else {
        this.showErrorToast("Complete this field.");//todo add custom label
        }
    },

    cancel: function (component){
        const helper = this;
        this.navigateToRecordPage(component);
    },

    showErrorToast: function (message){
        const toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error",
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