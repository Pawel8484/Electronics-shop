({
    onInit : function(component, event, helper) {
               const searchParams = {
                     "term": '',
                     "category": '',
                 };
        helper.getSelectedProducts(component, searchParams);
    },

    dataChange : function(component, event, helper) {
        const actualRequestData = JSON.parse(JSON.stringify(event.getParam("value")));
               const searchParams = {
                     "term": actualRequestData.searchTerm,
                     "category": actualRequestData.selectedCategory,
                 };
        helper.getSelectedProducts(component, searchParams);
    },
})