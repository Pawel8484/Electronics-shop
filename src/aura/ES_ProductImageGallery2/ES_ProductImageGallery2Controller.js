({
    onInit: function (component, event, helper) {
        helper.downloadPictures(component, event);
    },

    getSelectedFile : function(component,event,helper){
        component.set("v.hasModalOpen" , true);
        component.set("v.selectedDocumentId" , event.currentTarget.getAttribute("data-Id"));
    },

    closeModel: function(component, event, helper) {
        component.set("v.hasModalOpen", false);
        component.set("v.selectedDocumentId" , null);
    },
})