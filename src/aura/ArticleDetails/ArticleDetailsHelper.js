({
    selectedArticle: function(component, pageRequest) {
        const helper = this;
        const article = component.get("v.pageReference").state.c__selectedArticle;
        const articleId = component.get("v.pageReference").state.c__articleId;

        if(article === null || article === undefined){
             const action = component.get("c.findSavedArticle");
             action.setParams({
                         articleId: articleId
                     });
        action.setCallback(this, function(response) {
                     const state = response.getState();
                     if (state === 'SUCCESS') {
        const articleDetails = response.getReturnValue();
        component.set("v.article", articleDetails);
        } else {
           this.handleErrors(response.getError());
                  }
            });
            $A.enqueueAction(action);
        } else {
            component.set("v.article", JSON.parse(article));
        }
//        const action = component.get("c.isArticleSaved");
//        action.setParams({
//            articleUrl:  JSON.parse(article).url
//        });
//        action.setCallback(this, function(response) {
//        const isSaved = response.getReturnValue();
//        component.set("v.isSaved", isSaved);
//        });
//           $A.enqueueAction(action);
    },

    isSavedArticle: function(component, event){
        const article = component.get("v.pageReference").state.c__selectedArticle;
        const articleId = component.get("v.pageReference").state.c__articleId;

        if(article === null || article === undefined){
            const action = component.get("c.isArticleSaved");
                    action.setParams({
                          articleId: articleId
                              });
                           action.setCallback(this, function(response) {
                                   const isSaved = response.getReturnValue();
                                   component.set("v.isSaved", isSaved);
                                      });
                                   $A.enqueueAction(action);
        } else {

        const action = component.get("c.isArticleSaved");
        action.setParams({
                     articleUrl: JSON.parse(article).url
                     });
        action.setCallback(this, function(response) {
        const isSaved = response.getReturnValue();
        component.set("v.isSaved", isSaved);
           });
             $A.enqueueAction(action);
             }
    },

    saveArticle: function(component, event) {
            const helper = this;
            const articleObject = component.get('v.article');
            const action = component.get("c.saveSelectedArticle");
            action.setParams({
                selectedArticle: JSON.stringify(articleObject)
            });

            this.showSpinner(component);
            action.setCallback(this, function(response) {
                this.hideSpinner(component);
                const state = response.getState();
                if (state === 'SUCCESS') {
                component.set("v.isSaved", true);
                this.successToast("Article has been saved");
                } else {
                    this.handleErrors(response.getError());
                }
            });
                    $A.enqueueAction(action);
    },

    navigateToOtherPage: function(component, event, apiName){
        const searchParams = component.get('v.searchParams');
            const pageReference = {
            "type": "standard__navItemPage",
            "attributes": {
                "apiName": apiName
                },
            "state": {
                c__searchParams: JSON.stringify(searchParams)
            }
            };
            const navService = component.find("navService");
            event.preventDefault();
            navService.navigate(pageReference);
    },

    deleteArticle: function(component, event, apiName){
        const helper = this;
        const article = component.get("v.pageReference").state.c__selectedArticle;
        const action = component.get("c.deleteSelectedArticle");
        action.setParams({
                    selectedArticleId: JSON.parse(article).id
         });
               action.setCallback(this, function(response) {
                  var state = response.getState();
                  if (state === 'SUCCESS'){
                     $A.get('e.force:refreshView').fire();
                const pageReference = {
                "type": "standard__navItemPage",
                "attributes": {
                    "apiName": apiName
                    }
          };
                const navService = component.find("navService");
                event.preventDefault();
                navService.navigate(pageReference);
                this.successToast("Article has been deleted");
                     } else {
                    this.handleErrors(response.getError());
                     }
               });
           $A.enqueueAction(action);
    },

//    shareArticle: function(component, event){
//        const helper = this;
//        const article = component.get("v.pageReference").state.c__selectedArticle;
//        const articleObject = component.get('v.article');
//        const pageRef = component.get("v.pageReference");
//        const userId = component.get("v.userId");
//        const isSaved = component.get("v.isSaved");
//        if(isSaved == false){
//            const action = component.get("c.saveShareArticle");
//            action.setParams({
//                selectedArticle: JSON.stringify(articleObject)
//            });
//
//            action.setCallback(this, function(response) {
//                const state = response.getState();
//                if (state === 'SUCCESS') {
//                  const modal = component.find('modal');
//                  modal.closeModal();
//                  this.successToast("Notification was sent");
//                } else {
//                    this.handleErrors(response.getError());
//                }
//            });
//                    $A.enqueueAction(action);
//
//        } else {
//                   const action = component.get("c.sendNotification");
//                   action.setParams({
//                                       articleId: JSON.parse(article).id,
//                                       userId: userId
//                                });
//                   action.setCallback(this, function(response) {
//                        const state = response.getState();
//                        if (state === 'SUCCESS') {
//                          const modal = component.find('modal');
//                          modal.closeModal();
//                          this.successToast("Notification was sent");
//                        } else {
//                           this.handleErrors(response.getError());
//                        }
//                   });
//                           $A.enqueueAction(action);
//
//        }
//    },



    shareArticle: function(component, event){
        const helper = this;
        const article = component.get("v.pageReference").state.c__selectedArticle;
        const pageRef = component.get("v.pageReference");
        const userId = component.get("v.userId");
        const action = component.get("c.sendNotification");
        action.setParams({
                            articleId: JSON.parse(article).id,
//                            articleUrl: JSON.parse(article).url,
                            userId: userId
                     });
        action.setCallback(this, function(response) {
             const state = response.getState();
             if (state === 'SUCCESS') {
               const modal = component.find('modal');
               modal.closeModal();
               this.successToast("Notification was sent");
             } else {
                this.handleErrors(response.getError());
             }
        });
                $A.enqueueAction(action);
    },


    getSubscriberList: function(component, event) {
        const article = component.get("v.pageReference").state.c__selectedArticle;
        const action = component.get("c.getSubscribers");
                       action.setParams({
                                           articleId: JSON.parse(article).id
                                    });
                       action.setCallback(this, function(response) {
                            const state = response.getState();
                            if (state === 'SUCCESS') {
                             const subscribers = response.getReturnValue();
                             component.set('v.subscribers', subscribers);
                            } else {
                               this.handleErrors(response.getError());
                            }
                       });
                               $A.enqueueAction(action);
    },

    setSearchParamsValue: function(component, event, apiName){
        const searchParams = component.get("v.pageReference").state.c__searchParams;
        component.set('v.searchParams', JSON.parse(searchParams));
    },

    showSpinner: function(component) {
        component.set('v.showSpinner', true);
    },

    hideSpinner: function(component) {
        component.set('v.showSpinner', false);
    },

    handleErrors: function(errors) {
        if (errors) {
            if (errors[0] && errors[0].message) {
                this.showError(errors[0].message);
            }
        } else {
            this.showError('Unknown error');
        }

    },

    showError: function(error) {
        const toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Server Error",
            "message": error,
            "type": "error"
        });
        toastEvent.fire();
    },

    successToast: function(text) {
        const toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success",
            "message": text,
            "type": "success"
        });
        toastEvent.fire();
    },

})