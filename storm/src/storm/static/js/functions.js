function changeDisplay(id1, id2) {
   document.getElementById(id1).style.display = "";
   document.getElementById(id2).style.display = "none";            
};
   
function changeTopologyStatus(psId, psAction, pbWait, piWait) {            
   if (confirm('Are you sure you want too '  + psAction +  ' this Topology?')) {
      // Accept.
      $.post("/storm/changeTopologyStatus/", { sId: psId,
                                               sAction: psAction,
   	                                           bWait: pbWait,
	                                           iWait: piWait
                                             }, function(data){                                                    
                                                   if (data = 200) {
                                                      window.location.reload();
                                                   }
                                                }, "text");
   } 
   else {
      // Cancel.
   }         
};