({
         doInit: function(component,event,helper){
                helper.selectedArticle(component);
                helper.isSavedArticle(component);
                helper.setSearchParamsValue(component);
                helper.getSubscriberList(component);
         },

        onSelectedArticle: function(component, event, helper) {
                helper.selectedArticle(component);
                helper.isSavedArticle(component);
                helper.setSearchParamsValue(component);
                helper.getSubscriberList(component);
        },

        saveArticle: function(component, event, helper) {
                helper.saveArticle(component, event);
//            const articleObject = component.get('v.article');
//            const action = component.get("c.saveSelectedArticle");
//            action.setParams({
//                selectedArticle: JSON.stringify(articleObject)
//            });
//
//            helper.showSpinner(component);
//            action.setCallback(this, function(response) {
//                helper.hideSpinner(component);
//                const state = response.getState();
//                if (state === 'SUCCESS') {
//                component.set("v.isSaved", true);
//                helper.successToast("Article has been saved");
//                } else {
//                    // Handle the 'ERROR' or 'INCOMPLETE' state
//                }
//            });
//                    $A.enqueueAction(action);
        },

        backToResults: function(component, event, helper) {
            helper.navigateToOtherPage(component, event, "Search");
//            const pageReference = {
//            "type": "standard__navItemPage",
//            "attributes": {
//                "apiName": "Search"
//                }
//            };
//            const navService = component.find("navService");
//            event.preventDefault();
//            navService.navigate(pageReference);
        },

         imageError: function(component,event,helper){
             event.target.src = 'https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg';
             },

         deleteArticle: function(component, event, helper){
             helper.deleteArticle(component, event, "Articles");
//             const article = component.get("v.pageReference").state.c__selectedArticle;
//             const action = component.get("c.deleteSelectedArticle");
//             action.setParams({
//                        selectedArticleId: JSON.parse(article).id
//             });
//                   action.setCallback(this, function(response) {
//                      var state = response.getState();
//                      if (state === 'SUCCESS'){
//                         $A.get('e.force:refreshView').fire();
//                    const pageReference = {
//                    "type": "standard__navItemPage",
//                    "attributes": {
//                        "apiName": "Articles"
//                        }
//              };
//                    const navService = component.find("navService");
//                    event.preventDefault();
//                    navService.navigate(pageReference);
//                    helper.successToast("Article has been deleted");
//                         } else {
//                        // Handle the 'ERROR' or 'INCOMPLETE' state
//                         }
//                   });
//               $A.enqueueAction(action);

         },

        openModal: function(component,event,helper){
        const modal = component.find('modal');
        modal.openModal();
        },

        handleChange: function(component, event, helper) {
            var userId = event.getParam("value")[0];
            component.set("v.userId", userId);
        },

        shareArticle: function(component, event, helper) {
            helper.shareArticle(component, event);
//        const article = component.get("v.pageReference").state.c__selectedArticle;
//        const userId = component.get("v.userId");
//        const action = component.get("c.sendNotification");
//        action.setParams({
//                            articleId: JSON.parse(article).id,
//                            articleUrl: JSON.parse(article).url,
//                            userId: userId
//                     });
//        action.setCallback(this, function(response) {
//             helper.hideSpinner(component);
//             const state = response.getState();
//             if (state === 'SUCCESS') {
//               const modal = component.find('modal');
//               modal.closeModal();
//               helper.successToast("Notification was sent");
//             } else {
//                 helper.handleErrors(response.getError());
//             }
//        });
//                $A.enqueueAction(action);
        },
})