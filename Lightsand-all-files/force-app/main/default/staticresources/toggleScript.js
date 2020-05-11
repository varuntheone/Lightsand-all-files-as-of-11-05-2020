<script>
var j$ = jQuery.noConflict();
function showDetails(x) {
       
            var name = j$(x).children('img').attr('id');
            var twistie = j$(x).children('img').attr('class');
            console.log('twistie clicked: ' + name + ' ' + twistie);
            if(twistie == 'hideListButton'){
                //hide
                j$('[class~='+name+']').each(function(index){  
                        console.log(j$(this).find('img'));
                        j$(this).find('img[class="hideListButton"]').each(function(index){
                            j$(this).attr('class','showListButton');
                             j$(this).css('width','20px');
                              j$(this).css('height','20px');
                              j$(this).css('background-color', 'black');
                        });                       
                        
                        j$(this).css('display','none');
                });
                j$(x).children('img').attr('class','showListButton');
                 j$(x).children('img').css('background-image' ,"url({!URLFOR($Resource.EUR_CRM_Twisties,'eur_crm_twisties/twisty.gif')})");
                 j$(x).children('img').css('width','20px');
                 j$(x).children('img').css('height','20px');
                  j$(x).children('img').css('background-color', 'black');
                 
            } else {
                //show
                j$('[class$=' + name + ']').each(function(index) {
                    j$(this).css('display', 'table-row');

                });
                j$(x).children('img').attr('class', 'hideListButton');
                j$(x)
                        .children('img')
                        .css('background-image',
                                "url({!URLFOR($Resource.EUR_CRM_Twisties,'eur_crm_twisties/twisty2.gif')})");
                j$(x).children('img').css('width', '20px');
                j$(x).children('img').css('background-color', 'black');
                j$(x).children('img').css('height', '20px');

            }
        }
</script>