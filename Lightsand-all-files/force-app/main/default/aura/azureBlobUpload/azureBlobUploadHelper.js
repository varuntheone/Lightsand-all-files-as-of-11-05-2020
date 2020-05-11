({
	uploadAzureWindowForFileUpload: function(component,helper,batchId) {
        var w = 400;
        var h = 200;
        var left = Number((screen.width/2)-(w/2));
        var tops = Number((screen.height/2)-(h/2));
        var file = new File(["kasetti"], "inventoryFile.txt", {
          type: "text/plain",
        });
       //alert(file.name);
       var winObj = window.open('/apex/azureInventoryFileUpload?Id=' + batchId, 'Inventory Data Upload','directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=false,width='+w+', height='+h+', top='+tops+', left='+left);
        //winObj.uploadFileToAzure(file);
        winObj.postMessage(file, "http://azure.com");
    }
})