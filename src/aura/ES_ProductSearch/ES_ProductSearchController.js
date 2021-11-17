({
    onRequestData : function(component, event, helper) {
        var data = event.getParam("formData");
        component.set("v.requestData", data);
        component.set("v.isAllProductDisplayed", false);
    },
})