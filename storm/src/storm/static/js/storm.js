// Licensed to Cloudera, Inc. under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  Cloudera, Inc. licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

//var StormViewModel = function() {
function StormViewModel() {
   var self = this;         
   
   self.set_topology_status = function() {                  
      var sName = "";
      var iExecutors = 0;
      var aComponents = [];
      var aList = [];
      
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
      
      if (confirm('Are you sure you want to '  + sAction +  ' this Topology?')) {
         // Accept.
         $.post("/storm/set_topology_status/", { psAction: sAction,
	                                             psNameTopology: sNameTopology,
		         		                         piNumWorkers: iNumWorkers,
		            		                     piWaitSecs: iWaitSecs,
		                    		             paComponents: aComponents
                                                }, 
                                                function(data){
						      						jsonResult = JSON.parse(data)
						      
                                                    if (jsonResult.output == 'None') {
                                                         window.location.reload();
                                                    }
                                                    else {
						         						$("#divError").show();
						      						}
                                                }, "text");
      } 
      else {
         // Cancel.
      }         
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