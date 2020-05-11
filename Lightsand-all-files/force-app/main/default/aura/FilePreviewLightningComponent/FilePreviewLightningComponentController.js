({
    preview : function(component, event, helper) {
        $A.get('e.lightning:openFiles').fire({
            recordIds: [component.get("v.contentId")]
        });
    }
})