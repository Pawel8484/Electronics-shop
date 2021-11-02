({
    /**
    Opens modal
    */
    openModal: function(component){
        $A.util.addClass(component.find('backdrop'), "slds-backdrop_open");
        $A.util.addClass(component.find('modal'), "slds-slide-down-cancel");
    },
    /**
    Closes modal
    */
    closeModal : function(component) {
        $A.util.removeClass(component.find('backdrop'), "slds-backdrop_open");
        $A.util.removeClass(component.find('modal'), "slds-slide-down-cancel");
    },
})