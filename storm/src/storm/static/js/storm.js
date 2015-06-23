
function changeDisplay(id1, id2) {
   document.getElementById(id1).style.display = "";
   document.getElementById(id2).style.display = "none";            
};

function post_topology_status(psId, psAction, pbWait, piWait) {    
   $("#btnNo"+psAction).hide();
   $("#btnYes"+psAction).hide();
   $("#divError"+psAction).hide();
   $("#imgLoading"+psAction).show();        
   $.post("/storm/post_topology_status/", { sId: psId,
                                               sAction: psAction,
   	                                           bWait: pbWait,
	                                             iWait: piWait
                                             }, function(data){
                                                   if (data == 200) {
                                                      window.location.reload();
                                                   }
                                                   else {
                                                      $("#divError"+psAction).show();
                                                   }
                                                   $("#btnNo"+psAction).show();
                                                   $("#btnYes"+psAction).show();
                                                   $("#imgLoading"+psAction).hide();
                                                }, "text");         
};

function StormViewModel() {
   var self = this;         
   
   self.set_topology_status = function() {                  
      var sName = "";
      var iExecutors = 0;
      var aComponents = [];
      var aList = [];
      
      $("#btnCancel").hide();
      $("#btnSubmit").hide();
      $("#divErrorRebalance").hide();
      $("#imgLoading").show();

      var sAction = document.getElementById("sAction").value;
      var sNameTopology = document.getElementById("sNameTopology").value;
      var iNumWorkers = document.getElementById("iNumWorkers").value;
      var iWaitSecs = document.getElementById("iWaitSecs").value;            
      var checks = document.getElementsByTagName("input");      
      
      for(var i = 0; i < checks.length; i++) {  
	     if ((checks[i].type == 'checkbox') && (checks[i].name.substring(0, 3) == 'cp_') && (checks[i].checked)) {
            sName = checks[i].name;
	          iExecutors = document.getElementById("numExecutors_" + sName.substring(3)).value;
            aComponents.push(sName.substring(3),iExecutors);            
	     }
      }            
      
      $.post("/storm/set_topology_status/", { psAction: sAction,
        	 									                  psNameTopology: sNameTopology,
		         		                              piNumWorkers: iNumWorkers,
		            		                          piWaitSecs: iWaitSecs,
		                    		                  paComponents: aComponents
                                            }, function(data){
						      						                      jsonResult = JSON.parse(data)
                                                    if (jsonResult.status == 0) {                                                         
                                                         window.location.reload();
                                                    }
                                                    else {                                               
						         						                         $("#divErrorRebalance").show();
						      						                      }
                                                    $("#btnCancel").show();
                                                    $("#btnSubmit").show();
                                                    $("#imgLoading").hide();
                                               }, "text");         
   };   
};