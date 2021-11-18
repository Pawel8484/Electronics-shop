({
    getSelectedProducts: function(component, searchParams) {
        const helper = this;
        const action = component.get("c.getSelectedProductsList");
        action.setParams({"searchParams": JSON.stringify(searchParams)});
        action.setCallback(this,function(response) {
            const state = response.getState();
              if(state ==='SUCCESS'){
                  const wrapProducts = response.getReturnValue();
                  component.set("v.wrapProducts", wrapProducts);
              } else {
                  this.handleErrors(response.getError());
              }
        });
        $A.enqueueAction(action);
    },

    handleErrors: function(errors) {
        if (errors) {
            if (errors[0] && errors[0].message) {
                this.showError(errors[0].message);
            }
        } else {
            this.showError($A.get("$Label.Unknown_error"));
        }
    },

    showError: function(error) {
        const toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": $A.get("$Label.Error"),
            "message": error,
            "type": "error"
        });
        toastEvent.fire();
    },
})