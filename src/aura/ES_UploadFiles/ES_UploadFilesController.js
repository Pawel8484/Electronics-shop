({
    onInit: function (component, event, helper) {
        helper.downloadPictures(component, event);
        helper.downloadMainPictureId(component, event);
    },

    handleUploadFinished: function (component, event, helper) {
        helper.handleUploadFinished (component, event);
    },

    onClickRow: function (component, event, helper) {
        helper.onClickRow (component, event);
    }
})