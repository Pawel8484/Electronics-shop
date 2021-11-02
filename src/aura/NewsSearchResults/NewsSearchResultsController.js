({
        doInit : function(component, event, helper) {
            const useSalesforceData = component.get('v.useSalesforceData');

            let searchParams = {};

            if (useSalesforceData === false) {
                searchParams = {
                     "dataSource": 'api',
                 };
            }

            helper.getNewsPage(component, searchParams);
        },

    dataChange : function(component, event, helper) {
        const actualRequestData = JSON.parse(JSON.stringify(event.getParam("value")));
        console.log(actualRequestData);
            const useSalesforceData = component.get('v.useSalesforceData');
            let searchParams = {};

            if (useSalesforceData === false) {
                searchParams = {
                     "term": actualRequestData.searchTerm,
                     "category": actualRequestData.selectedCategory,
                     "startDate": actualRequestData.selectedStartDate,
                     "endDate": actualRequestData.selectedEndDate,
                     "dataSource": 'api',
                 };
            }
            helper.getNewsPage(component, searchParams);

//       component.set("v.actualRequestData", actualRequestData);
//       console.log('NSR !!!!!!!!!!!!!!!!!!!');
//        console.log(JSON.stringify(actualRequestData));
    },

    onArticleSelect: function(component, event, helper) {
        const articleObject = event.getParam("articleObject");
        component.set("v.selectedArticle", articleObject);
    },

    changeSelectedArticleValueToNull: function(component, event, helper) {
        component.set("v.selectedArticle", null);
     },
})