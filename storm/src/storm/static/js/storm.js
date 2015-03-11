function reloadDiv(id) {
   window.location.reload();
};

function changeDisplay(id1, id2) {
   document.getElementById(id1).style.display = "";
   document.getElementById(id2).style.display = "none";            
};
   
function changeTopologyStatus(psId, psAction, pbWait, piWait) {            
   $.post("/storm/changeTopologyStatus/", { sId: psId,
                                               sAction: psAction,
   	                                           bWait: pbWait,
	                                             iWait: piWait
                                             }, function(data){                                                 
                                                   if (data == 200) {
                                                      window.location.reload();
                                                   }
                                                   else {
                                                      console.log("ERROR");
                                                      
                                                   }
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
                                                }, 
                                                function(data){
						      						                      jsonResult = JSON.parse(data)
						                                        console.log(jsonResult.status);
                                                    if (jsonResult.status == 0) {                                                         
                                                         window.location.reload();
                                                    }
                                                    else {                                               
						         						                         $("#divError").show();

						      						                      }
                                                    $("#btnCancel").show();
                                                    $("#btnSubmit").show();
                                                    $("#imgLoading").hide();
                                                }, "text");         
   };   
   
   self.getData = function() {  
       var sUrl = "/api/v1/cluster/summary";              
       
       $.ajaxSetup({
             "error": function(jqXHR, textStatus, response) {
                         console.log("jqXHR: " + jqXHR);
			 console.log("textStatus: " + textStatus);    
			 console.log("Response: " + response);    
                      }
       });
       
       $.getJSON(sUrl, function(response,status,jqXHR) {
          alert(response); 
       });
   

       /*
       $.ajax({
           url: sUrl,           
           dataType: 'jsonp',   
           success: function(response) {
                       console.log('Data OK ... ');
                    },
           error: function(xhr, status, error) {
                      console.log('Status: ' + status);
		      console.log('ERROR: ' + error);
                      console.log('InText: ' + xhr.responseText);		      		      
                  }	   
       });
       */      
       
    }; 
};

//ko.applyBindings(new StormViewModel());
//var StormModel = new StormViewModel();
//ko.applyBindings(StormModel);