<script>
		var j$ = jQuery.noConflict();
        var defualtColor = function() {
        j$(".statusId").attr("style","background:#2081A1;");
        j$(".pick").attr("style","background:#2081A1;");
        
        }
       j$(document).ready(function(event){
           defualtColor();
   
            j$("select").on("change",function(event){
            var selectedValue = j$(this).val();
            console.log(selectedValue); 
            if(selectedValue === 'Request for Approval') {
                j$(this).attr("style","background:#2081A1;");
                j$(this).closest(".pick").attr("style","background:#2081A1;");
                j$(this).closest("#items").attr("style","background:#2081A1;");
            }   

            if(selectedValue === 'On-hold') {
                j$(this).attr("style","background:pink;");
                j$(this).closest(".pick").attr("style","background:pink;");
                j$(this).child("#items").attr("style","background:pink;");
            }    
        });
    
       });
</script>
        