({
    doInit: function (component, event, helper) {
        const initialData = component.get("v.initialData");
        component.find("searchInput").set("v.value", initialData.searchTerm);
        component.find("selectedCategory").set("v.value", initialData.selectedCategory);
        component.find("selectedStartDate").set("v.value", initialData.selectedStartDate);
        component.find("selectedEndDate").set("v.value", initialData.selectedEndDate);
    },

    handleChange: function (component, event) {
        // This will contain the string of the "value" attribute of the selected option
//        var selectedOptionValue = event.getParam("value");
//        alert("Option selected with value: '" + selectedOptionValue + "'");
    },

    onFormSubmit : function(component,event) {
        const searchTerm = component.find("searchInput").get("v.value");
        const selectedCategory = component.find("selectedCategory").get("v.value");
        const selectedStartDate = component.find("selectedStartDate").get("v.value");
        const selectedEndDate = component.find("selectedEndDate").get("v.value");
        const requestData = component.getEvent("requestData");
        console.log("input :" + searchTerm + " electedCategory: " + selectedCategory + ' selectedStartDate: ' + selectedStartDate + ' selectedEndDate :' + selectedEndDate);
        const data = {
                searchTerm: searchTerm,
                selectedCategory: selectedCategory,
                selectedStartDate: selectedStartDate,
                selectedEndDate: selectedEndDate
            };
//                    const requestData = $A.get("e.c:requestData");
                    requestData.setParams({
                        formData: data
                    });
                    console.log('Before fire: ' + data.searchTerm + ' name: ' + data.selectedCategory);

                    requestData.fire();
         },


// POPRZEDNIE
//    onFormSubmit : function(component,event) {
//        const searchTerm = component.find("searchInput").get("v.value");
//        const selectedCategory = component.find("selectedCategory").get("v.value");
//        const selectedStartDate = component.find("selectedStartDate").get("v.value");
//        const selectedEndDate = component.find("selectedEndDate").get("v.value");
//        console.log("input :" + searchTerm + " electedCategory: " + selectedCategory + ' selectedStartDate: ' + selectedStartDate + ' selectedEndDate :' + selectedEndDate);
//        const pageReference = {
//                type: 'standard__component',
//                attributes: {
//                    componentName: 'c__newsSearchResults',
//                },
//                state: {}
//            };
//
//            if (searchTerm !== null && searchTerm !== undefined && searchTerm !== '') {
//                pageReference.state.c__term = searchTerm;
//            }
//
//            if (selectedCategory !== null && selectedCategory !== undefined && selectedCategory !== '') {
//                pageReference.state.c__category = selectedCategory;
//            }
//
//            if (selectedStartDate !== null && selectedStartDate !== undefined && selectedStartDate !== '') {
//                pageReference.state.c__startDate = selectedStartDate;
//            }
//
//            if (selectedEndDate !== null && selectedEndDate !== undefined && selectedEndDate !== '') {
//                pageReference.state.c__endDate = selectedEndDate;
//            }
//
//            component.set("v.pageReference", pageReference);
//
//            const navService = component.find("navService");
//                    event.preventDefault();
//                    navService.navigate(pageReference);
//         },
});