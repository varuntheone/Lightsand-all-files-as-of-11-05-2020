({
    updateCheck11_helper : function(c,e,h) {
        // alert('Success!');
        var caseId = c.get("v.recordId");
        var save_action = c.get("c.updateCheck");
        save_action.setParams({
            caseId : caseId
        });
        save_action.setCallback(this, function(response) {
            if(response.getState() == "SUCCESS") {
                console.log("Created New Product Configurator");
                var rec = response.getReturnValue();
                console.log(rec.caseId);
                //alert('Success!');
            }
        });
        
        $A.enqueueAction(save_action);
        $A.get('e.force:refreshView').fire();
    }
})