({
        doInit : function(component, event, helper) {
             const searchParams = {};
                        helper.getNewsFromSalesforce(component, searchParams);
              },
})