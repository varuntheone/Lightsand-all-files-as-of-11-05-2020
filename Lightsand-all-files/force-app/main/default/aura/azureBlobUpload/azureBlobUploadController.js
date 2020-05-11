({
    doInit : function(component) {
        var vfOrigin = "https://" + component.get("v.vfHost");
        
        window.addEventListener("message", function(event) {
            console.log("event.origin::"+event.origin);
            if (event.origin !== vfOrigin) {
                console.log("inside lightning"+event.data);
                // Not the expected origin: Reject the message!
                return;
            }
            // Handle the message
            console.log(event.data);
        }, false);
    },
    handleClick : function(component) {
         var vfOrigin = "https://" + component.get("v.vfHost");
        window.open(vfOrigin+'/apex/azureVFLightInt','','');
    }

})