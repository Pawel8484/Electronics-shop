({
    select: function(component, event, helper) {
        component.set('v.checked', true);
    },

    deselect: function(component, event, helper) {
        component.set('v.checked', false);
    },

    toggle: function(component, event, helper) {
        component.set('v.checked', !component.get('v.checked'));

    },
    
    activate: function(component, event, helper) {
        const isChecked = component.get('v.checked');
        if(isChecked){
        const pickerElement = component.find('picker');
        $A.util.addClass(pickerElement, 'pickerActive');
        }

    },

   isSelected: function(component, event, helper) {
        const isChecked = component.get('v.checked');
        return isChecked;

    },

    handleClick: function(component, event, helper) {
        const checked = event.target.checked;
        component.set('v.checked', checked);
    },
})