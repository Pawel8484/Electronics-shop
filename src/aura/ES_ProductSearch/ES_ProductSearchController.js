({
    onRequestData : function(component, event, helper) {
        var data = event.getParam("formData");
        console.log('Start');
        console.log(JSON.parse(JSON.stringify(data)));
        console.log('Stop');
        component.set("v.requestData", data);
    },
})