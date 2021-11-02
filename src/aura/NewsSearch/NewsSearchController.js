({
        doInit : function(component, event, helper) {
            const urlParams = new URL(window.location.href).searchParams;
            const searchParams = urlParams.get("c__searchParams");
            console.log(JSON.parse(searchParams));
            component.set("v.requestData", JSON.parse(searchParams));
        },

        onRequestData : function(component, event, helper) {
            var data = event.getParam("formData");
            console.log('Start');
            console.log(JSON.parse(JSON.stringify(data)));
            console.log('Stop');
            component.set("v.requestData", data);
        },


})