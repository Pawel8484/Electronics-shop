({
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
})