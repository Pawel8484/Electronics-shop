({
//    afterScriptsLoaded : function(component, event, helper) {
//            helper.setupCarousel(component);
//    },


    afterScriptsLoaded : function(component, event, helper) {
        const selectedCategory = component.get('v.category');
                         const searchParams = {
                             "dataSource": 'api',
                             "category": selectedCategory,
                         };
                    helper.getNewsPage(component, searchParams);
//            helper.setupCarousel(component);
    },

    onArticleSelect: function(component, event, helper) {
        const articleObject = event.getParam("hotNewsObject");
        component.set("v.selectedArticle", articleObject);
    },

    changeSelectedArticleValueToNull: function(component, event, helper) {
        component.set("v.selectedArticle", null);
        const callAfterScriptsLoadedMethodAgain = component.get('c.afterScriptsLoaded');
        $A.enqueueAction(callAfterScriptsLoadedMethodAgain);
     },
})