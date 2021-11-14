({
    handleUploadFinished: function (component, event) {
        let newUploadedFiles = event.getParam("files");
        let uploadedFiles = component.get("v.files");
        for (const file of newUploadedFiles) {
            uploadedFiles.push(file);
            console.log(file);
        }
        component.set("v.files", uploadedFiles);
        component.set("v.selectedMain", uploadedFiles[0].contentVersionId);
        component.set("v.uploadFinished", true);
        let setPicture = $A.get("e.c:ES_SetMainImage");
        setPicture.setParams({
            "mainPictureId": uploadedFiles[0].contentVersionId
        });
        setPicture.fire();
    },

    downloadPictures: function (component, event) {
                    let picsAction = component.get("c.getPicturesList");
                    picsAction.setParams({
                        "productId": component.get("v.recordId"),
                    });
                     picsAction.setCallback(this, function(response) {
                         let state = response.getState();
                         console.log(state);
                         if(state==='SUCCESS'){
                         let downloadedPics = response.getReturnValue();
                            let uploadedFiles = component.get("v.files");
                            for (const file of downloadedPics) {
                                let fileWrap = new Object();

                                fileWrap.contentVersionId = file.Id;
                                fileWrap.documentId = file.ContentDocumentId;
                                fileWrap.name = file.Title;
                                uploadedFiles.push(fileWrap);
                                console.log(file);
                            }
                            component.set("v.files", uploadedFiles);
                              }
                          });
                    $A.enqueueAction(picsAction);
                },

    onClickRow: function (component, event) {
        let index = event.currentTarget.dataset.index;
        let imagesList = component.get("v.files");
        let file = imagesList[index];
        component.set("v.selectedMain", file.contentVersionId);
        let setPicture = $A.get("e.c:ES_SetMainImage");
        setPicture.setParams({
            "mainPictureId": file.contentVersionId
        });
        setPicture.fire();
    },
})