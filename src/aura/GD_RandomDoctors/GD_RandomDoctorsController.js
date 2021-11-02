({
	invoke : function(component, event, helper) {
		var action=component.get("c.getDoctors");
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state==='SUCCESS'){
               /* console.log('Success');
                console.log(response.getReturnValue());
                var result = JSON.stringify(response.getReturnValue());
                console.log(result); */
                component.set("v.drList", response.getReturnValue());
            }else{
                console.log('Failed');
            }
        });
        $A.enqueueAction(action);
	}
})