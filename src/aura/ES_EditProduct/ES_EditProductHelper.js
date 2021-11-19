({
    getProductId: function (component, event) {
        let id = component.get("v.pageReference");
        const urlAddress = window.location.href;
        const result = urlAddress.match(new RegExp('Product2/' + "(.*)" + '/view'));
        component.set("v.recordId", result[1]);
    },

    getProductPrice: function (component, event) {
        const action = component.get("c.getPrice");
        action.setParams({
            "productId": component.get("v.recordId"),
        });
         action.setCallback(this, function(response) {
             const state = response.getState();
             if(state==='SUCCESS'){
             const price = response.getReturnValue();
             component.set("v.standardPrice", price);
                  }
              });
        $A.enqueueAction(action);
    },

    getProductMainImageId: function (component, event) {
        const action = component.get("c.getMainPictureId");
        action.setParams({
            "productId": component.get("v.recordId"),
        });
         action.setCallback(this, function(response) {
             const state = response.getState();
             if(state==='SUCCESS'){
             const mainPictureId = response.getReturnValue();
             component.set("v.mainPictureId", mainPictureId);
                  }
              });
        $A.enqueueAction(action);
    },
})