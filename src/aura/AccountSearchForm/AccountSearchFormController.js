({
    doInit : function(component, event, helper) {
        helper.LoadBillingCountries(component,event);
                var sbc = component.get("v.selectedBillingCountry");
                console.log("Seleted account in doint :"+sbc);
    },

    onCountryChange :function(component, event, helper) {

        component.set("v.selectedBillingCountry", component.find("accounts").get("v.value"));
        console.log("onCountryChange :" + component.find("accounts").get("v.value"));

    },
    onFormSubmit : function(component,event) {
        var accountId = component.find("accounts").get("v.value");
        var accountName = component.find("name").get("v.value");
         console.log("accountId :" + accountId + "accountName: " + accountName);
        var data = {
            accountId : accountId,
            accountName : accountName
        };

        var formsubmit = $A.get("e.c:Formsubmit");
        formsubmit.setParams({
            formData: data
        });
        console.log('Before fire: ' + data.accountId + ' name: ' + data.accountName);

        formsubmit.fire();
    },
})