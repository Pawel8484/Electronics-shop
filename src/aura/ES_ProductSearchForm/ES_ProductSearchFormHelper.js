({
    onFormSubmit : function(component,event) {
        const searchTerm = component.find("searchInput").get("v.value");
        const selectedCategory = component.find("selectedCategory").get("v.value");
        const requestData = component.getEvent("requestData");
        const data = {
                searchTerm: searchTerm,
                selectedCategory: selectedCategory,
            };
        requestData.setParams({
            formData: data
        });
        requestData.fire();
    },
})