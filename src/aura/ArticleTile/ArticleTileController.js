({

        doInit: function(component, event, helper) {
        const article = component.get("v.article");
        const action = component.get("c.isArticleInDatabase");
            action.setParams({
                selectedArticle: JSON.stringify(article)
            });
        action.setCallback(this, function(response) {
        const isInDatabase = response.getReturnValue();
        component.set("v.isInDatabase", isInDatabase);
           });
             $A.enqueueAction(action);

        },

        selectedArticle: function(component, event, helper) {
        const selectedArticle = component.get("v.article");
        const searchParams = component.get("v.searchParams");
        const pageReference = {
                type: 'standard__component',
                attributes: {
                    componentName: 'c__articleDetails',
                },
                state: {
                    c__selectedArticle: JSON.stringify(selectedArticle),
                    c__searchParams: JSON.stringify(searchParams)
                }
            };
            console.log('UUU: ' + selectedArticle);
            component.set("v.pageReference", pageReference);

            const navService = component.find("navService");
                    event.preventDefault();
                    navService.navigate(pageReference);
         },

            imageError: function(component,event,helper){
                   event.target.src = 'https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg';
             },
});

//        selectedArticle: function(component, event, helper) {
//            const articleObject = component.get('v.article');
//        const objectTransfer = $A.get("e.c:objectTransfer");
//                objectTransfer.setParams({
//                    articleObject: articleObject
//                });
//                objectTransfer.fire();
//        },