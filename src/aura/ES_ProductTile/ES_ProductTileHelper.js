({
    selectedProduct: function(component, event, helper) {
    const selectedProduct = component.get("v.product");
        component.find("navService").navigate({
           "type": "standard__recordPage",
                "attributes": {
                    "recordId": selectedProduct.id,
                    "objectApiName": "Product2",
                    "actionName": "view"
                }
     });
     },
})