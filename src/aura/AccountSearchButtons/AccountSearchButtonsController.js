({
    handleButtonClick : function(component, event, helper) {
        const button = event.getSource();
        const action = button.get('v.value');

        const actionEvent = component.getEvent('AccountListAction');
        actionEvent.setParams({
                "action" : action
        });
        actionEvent.fire();
    },
})