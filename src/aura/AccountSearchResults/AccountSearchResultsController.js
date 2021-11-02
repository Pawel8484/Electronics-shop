({
    doInit : function(component, event, helper) {
    },

//    doSearch : function(component, event, helper) {
//        var params = event.getParam('arguments');
//        component.set("v.accountId", params.accountId);
//        component.set("v.accountName", params.accountName);
//        console.log(params.accountId);
//                   helper.onSearch(component);
//    },

    onFormSubmit : function(component, event, helper) {
        var data = event.getParam("formData");
         helper.onSearch(component, data);
    },

    handleAction: function(component, event, helper) {
        const action = event.getParam('action');
        switch (action) {
          case 'selectAll': {
           helper.selectAll(component);
           break;
          }
          case 'deselect': {
           helper.deselect(component);
           break;
          }
          case 'invert': {
           helper.invert(component);
           break;
          }
          case 'activate': {
          helper.activate(component);
          break;
        }

          case 'remove': {
          helper.remove(component);
          break;
        }

          case 'clone': {
          helper.clone(component);
          break;
        }
    }
    },

})