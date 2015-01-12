## Licensed to the Apache Software Foundation (ASF) under one
## or more contributor license agreements.  See the NOTICE file
## distributed with this work for additional information
## regarding copyright ownership.  The ASF licenses this file
## to you under the Apache License, Version 2.0 (the
## "License"); you may not use this file except in compliance
## with the License.  You may obtain a copy of the License at
##
## http:# www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.

<%!
   from desktop.views import commonheader, commonfooter
   from django.utils.translation import ugettext as _
%>

${commonheader("Components Dashboard", app_name, user) | n,unicode}

<%namespace name="storm" file="navigation_bar.mako" />
<%namespace name="Templates" file="templates.mako" />
<%namespace name="JavaScript" file="js.mako" />
<%namespace name="graphsHUE" file="common_dashboard.mako" />

## Use double hashes for a mako template comment
## Main body

<link href="/storm/static/css/storm.css" rel="stylesheet">

<style>
   .dataTables_length {
      width: 50%;
      float: left;
      text-align: left;
      vertical-align:top;
   } 
   .dataTables_filter {
      width: 50%;
      float: right;
      text-align: right;
      vertical-align:top;
   }   
</style>

${ graphsHUE.import_charts() }

<script type="text/javascript" charset="utf-8">    
   $(document).ready(function() {
       $('#tblTopologyComponent').dataTable( {	    
	    	"sPaginationType": "bootstrap",
	    	"bLengthChange": false,
	    	"bFilter": false,
	        "sDom": "<'row-fluid'<l><f>r>t<'row-fluid'<'dt-pages'p><'dt-records'i>>"        
	    } );
   });
   
   var dataBarComponentsStats = [];
   var dataBarComponentsTimes = [];
   
   var sData = "${Components}";   
   var swData = sData.replace(/&quot;/ig,'"')   
   var jsonComponents = JSON.parse(swData);
   
   for (var i=0; i<Object.keys(jsonComponents).length; i++) {           
      dataBarComponentsStats.push({"key": jsonComponents[i].windowPretty, 
                                   "values": [ {"x": "Emitted", "y": jsonComponents[i].emitted},
                                               {"x": "Transferred", "y": jsonComponents[i].transferred},                                                                   
                                               {"x": "Acked", "y": jsonComponents[i].acked},
                                               {"x": "Failed", "y": jsonComponents[i].failed}
                                             ]
                          });
      dataBarComponentsTimes.push({"key": jsonComponents[i].windowPretty, 
                                   "values": [ {"x": "Execute Latency (ms)", "y": jsonComponents[i].executeLatency},
                                               {"x": "Process Latency (ms)", "y": jsonComponents[i].processLatency}
                                             ]
                          });                     
   };
   
   nv.addGraph(function() {
                 var graphComponentsStats = nv.models.multiBarChart()
                                           .transitionDuration(350)
                                           .reduceXTicks(false)   //If 'false', every single x-axis tick label will be rendered.
                                           .rotateLabels(0)      //Angle to rotate x-axis labels.                                           
                                           .groupSpacing(0.1)    //Distance between each group of bars.                                
                                           .showControls(true);
                                  
                                  graphComponentsStats.multibar.stacked(false);         
    
                                  graphComponentsStats.yAxis
                                                  .tickFormat(d3.format('d'));
        
                                  d3.select('#barComponentsStats svg')
                                    .datum(dataBarComponentsStats)
                                    .call(graphComponentsStats);

                                  nv.utils.windowResize(graphComponentsStats.update);

                                  return graphComponentsStats;
   });
   
   nv.addGraph(function() {
                 var graphComponentsTimes = nv.models.multiBarChart()
                                           .transitionDuration(350)
                                           .reduceXTicks(false)   //If 'false', every single x-axis tick label will be rendered.
                                           .rotateLabels(0)      //Angle to rotate x-axis labels.                                           
                                           .groupSpacing(0.1)    //Distance between each group of bars.                                
                                           .showControls(true);
                                  
                                  graphComponentsTimes.multibar.stacked(false);         
    
                                  graphComponentsTimes.yAxis
                                                  .tickFormat(d3.format('d'));
        
                                  d3.select('#barComponentsTimes svg')
                                    .datum(dataBarComponentsTimes)
                                    .call(graphComponentsTimes);

                                  nv.utils.windowResize(graphComponentsTimes.update);

                                  return graphComponentsTimes;
   });
   
   var dataBarInputStats = [];
   var dataBarInputTimes = [];
   
   var sData = "${Input}";   
   var swData = sData.replace(/&quot;/ig,'"')   
   var jsonInput = JSON.parse(swData);
   
   for (var i=0; i<Object.keys(jsonInput).length; i++) {
      dataBarInputStats.push({"key": jsonInput[i].stream, 
                              "values": [ {"x": "Executed", "y": jsonInput[i].executed},                                                                        
                                          {"x": "Acked", "y": jsonInput[i].acked},
                                          {"x": "Failed", "y": jsonInput[i].failed}
                                        ]
                          });
      dataBarInputTimes.push({"key": jsonInput[i].stream, 
                              "values": [ {"x": "Execute Latency (ms)", "y": jsonInput[i].executeLatency},
                                          {"x": "Process Latency (ms)", "y": jsonInput[i].processLatency}
                                        ]
                          });                     
   };       
   
   nv.addGraph(function() {
                 var graphInputStats = nv.models.multiBarChart()
                                           .transitionDuration(350)
                                           .reduceXTicks(false)   //If 'false', every single x-axis tick label will be rendered.
                                           .rotateLabels(0)      //Angle to rotate x-axis labels.                                           
                                           .groupSpacing(0.1)    //Distance between each group of bars.                                
                                           .showControls(true);
                                  
                                  graphInputStats.multibar.stacked(false);         
    
                                  graphInputStats.yAxis
                                                  .tickFormat(d3.format('d'));
        
                                  d3.select('#barInputStats svg')
                                    .datum(dataBarInputStats)
                                    .call(graphInputStats);

                                  nv.utils.windowResize(graphInputStats.update);

                                  return graphInputStats;
   });
   
   nv.addGraph(function() {
                 var graphInputTimes = nv.models.multiBarChart()
                                                .transitionDuration(350)
                                                .reduceXTicks(false)   //If 'false', every single x-axis tick label will be rendered.
                                                .rotateLabels(0)      //Angle to rotate x-axis labels.                                           
                                                .groupSpacing(0.1)    //Distance between each group of bars.                                
                                                .showControls(true);
                                  
                                  graphInputTimes.multibar.stacked(false);         
    
                                  graphInputTimes.yAxis
                                                 .tickFormat(d3.format('d'));
        
                                  d3.select('#barInputTimes svg')
                                    .datum(dataBarInputTimes)
                                    .call(graphInputTimes);

                                  nv.utils.windowResize(graphInputTimes.update);

                                  return graphInputTimes;
   });
   
   var dataBarOutputStats = [];
   
   var sData = "${Output}";   
   var swData = sData.replace(/&quot;/ig,'"')   
   var jsonOutput = JSON.parse(swData);
   
   for (var i=0; i<Object.keys(jsonOutput).length; i++) {
      dataBarOutputStats.push({"key": jsonOutput[i].stream, 
                               "values": [ {"x": "Emitted", "y": jsonOutput[i].emitted},
                                           {"x": "Transferred", "y": jsonOutput[i].transferred},                                                                   
                                           {"x": "Acked", "y": jsonOutput[i].acked},
                                           {"x": "Failed", "y": jsonOutput[i].failed}
                                         ]
                          });
   }; 
   
   nv.addGraph(function() {
                 var graphOutputStats = nv.models.multiBarChart()
                                                 .transitionDuration(350)
                                                 .reduceXTicks(false)   //If 'false', every single x-axis tick label will be rendered.
                                                 .rotateLabels(0)      //Angle to rotate x-axis labels.                                           
                                                 .groupSpacing(0.1)    //Distance between each group of bars.                                
                                                 .showControls(true);
                                  
                                  graphOutputStats.multibar.stacked(false);         
    
                                  graphOutputStats.yAxis
                                                  .tickFormat(d3.format('d'));
        
                                  d3.select('#barOutputStats svg')
                                    .datum(dataBarOutputStats)
                                    .call(graphOutputStats);

                                  nv.utils.windowResize(graphOutputStats.update);

                                  return graphOutputStats;
   });
   
   var dataBarExecutorsStats = [];
   var dataBarExecutorsTimes = [];
   
   var sData = "${Executors}";   
   var swData = sData.replace(/&quot;/ig,'"')   
   var jsonExecutors = JSON.parse(swData);
   
   for (var i=0; i<Object.keys(jsonExecutors).length; i++) {
      if ("${isBolt}" == "1") {
         dataBarExecutorsStats.push({"key": jsonExecutors[i].id, 
                                     "values": [ {"x": "Emitted", "y": jsonExecutors[i].emitted},
                                                 {"x": "Transferred", "y": jsonExecutors[i].transferred},                                                                   
                                                 {"x": "Executed", "y": jsonExecutors[i].executed},
                                                 {"x": "Acked", "y": jsonExecutors[i].acked},
                                                 {"x": "Failed", "y": jsonExecutors[i].failed}
                                               ]
                             });
         dataBarExecutorsTimes.push({"key": jsonExecutors[i].id, 
                                     "values": [ {"x": "Execute Latency (ms)", "y": jsonExecutors[i].executeLatency},
                                                 {"x": "Process Latency (ms)", "y": jsonExecutors[i].processLatency}
                                        ]
                          });                    
      }
      else {
         dataBarExecutorsStats.push({"key": jsonExecutors[i].id, 
                                     "values": [ {"x": "Emitted", "y": jsonExecutors[i].emitted},
                                                 {"x": "Transferred", "y": jsonExecutors[i].transferred},                                                                   
                                                 {"x": "Acked", "y": jsonExecutors[i].acked},
                                                 {"x": "Failed", "y": jsonExecutors[i].failed}
                                               ]
                             });
      };
   }; 
   
   nv.addGraph(function() {
                 var graphExecutors = nv.models.multiBarChart()
                                               .transitionDuration(350)
                                               .reduceXTicks(false)   //If 'false', every single x-axis tick label will be rendered.
                                               .rotateLabels(0)      //Angle to rotate x-axis labels.                                           
                                               .groupSpacing(0.1)    //Distance between each group of bars.                                
                                               .showControls(true);
                                  
                                  graphExecutors.multibar.stacked(false);         
    
                                  graphExecutors.yAxis
                                                .tickFormat(d3.format('d'));
        
                                  d3.select('#barExecutors svg')
                                    .datum(dataBarExecutorsStats)
                                    .call(graphExecutors);

                                  nv.utils.windowResize(graphExecutors.update);

                                  return graphExecutors;
   });
   
    nv.addGraph(function() {
                 var graphExecutorsTimes = nv.models.multiBarChart()
                                                    .transitionDuration(350)
                                                    .reduceXTicks(false)   //If 'false', every single x-axis tick label will be rendered.
                                                    .rotateLabels(0)      //Angle to rotate x-axis labels.                                           
                                                    .groupSpacing(0.1)    //Distance between each group of bars.                                
                                                    .showControls(true);
                                  
                                  graphExecutorsTimes.multibar.stacked(false);         
    
                                  graphExecutorsTimes.yAxis
                                                     .tickFormat(d3.format('d'));
        
                                  d3.select('#barExecutorsTimes svg')
                                    .datum(dataBarExecutorsTimes)
                                    .call(graphExecutorsTimes);

                                  nv.utils.windowResize(graphExecutorsTimes.update);

                                  return graphExecutorsTimes;
   });
   
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
</script>

<%
  _breadcrumbs = [
    ["Storm Dashboard", url('storm:storm_dashboard')],    
    ["Topology " + Topology[0] + " Detail", url('storm:detail_dashboard', topology_id = Topology[0], system_id = 0)],
    [Component[4] + Component[0] + " Explain", url('storm:detail_dashboard', topology_id = Topology[0], system_id = 0)]
  ]
%>

${ storm.header(_breadcrumbs) }

${ storm.menubar(section = 'Components Dashboard')}

<div id="divPrincipal" class="container-fluid">
  <div class="card">        
    <div class="card-body">
       <table width="100%" height="100%" border="0" cellpadding="6" cellspacing="0">                              
          ${Templates.ControlPanelTopology("components_dashboard")}
          <tr>                          
             <td colspan="2">                
                <div class="col-lg-4">
                   <div class="panel panel-default">
                      <div class="panel-heading">
                         <i class="fa fa-table fa-fw"></i> Component Summary
                      </div>
                      <div class="panel-body">
                         <table class="table datatables table-striped table-hover table-condensed" id="tblTopologyComponent" data-tablescroller-disable="true">
                            <thead>
                               <tr>
                                  <th> Id </th>
                                  <th> Topology </th>
                                  <th> Executors </th>
                                  <th> Tasks </th>                         
                               </tr>
                            </thead>
                            <tbody>
                               <tr>                         
                                  <td>${Component[0]}</td>
                                  <td>${Component[1]}</td>                                                        
                                  <td>${Component[2]}</td>
                                  <td>${Component[3]}</td>                                                 
                               </tr>                      
                            </tbody>
                         </table>
                      </div>
                   </div>
                </div>
             </td>             
          </tr>
          <tr valign="top">
             <td width="55%">
                <div class="col-lg-4">
                   <div class="panel panel-default">
                      <div class="panel-heading">
                         <i class="fa fa-bar-chart fa-fw"></i> Stats
                      </div>
                      <div class="panel-body">
                         <table width="100%" height="100%" border="0" cellpadding="6" cellspacing="0">
                            <tr>
                               <td>
                                  <div id="barComponentsStats"><svg style="min-height: 220px; margin: 10px auto"></svg></div>
                               </td>
                            </tr>
                         </table>         
                      </div>                        
                   </div>
                </div>
             </td> 
             % if (isBolt == 1):
             <td width="45%">
                <div class="col-lg-4">
                   <div class="panel panel-default">
                      <div class="panel-heading">
                         <i class="fa fa-bar-chart fa-fw"></i> Times
                      </div>                      
                      <div class="panel-body">
                         <div id="barComponentsTimes"><svg style="min-height: 220px; margin: 10px auto"></svg></div>
                      </div>                      
                   </div>
                </div>
             </td>
             % endif
          </tr>
          <tr valign="top">
             <td colspan="2">
                <div class="col-lg-4">
                   <div class="panel panel-default">
                      <div class="panel-heading">
                         <i class="fa fa-bar-chart fa-fw"></i> Executors
                      </div>
                      <div class="panel-body">                         
                         <table width="100%" height="100%" border="0" cellpadding="6" cellspacing="0">
                            <tr>
                               <td>
                                  <div id="barExecutors"><svg style="min-height: 220px; margin: 10px auto"></svg></div>
                               </td>
                               % if (isBolt == 1):
                               <td>
                                  <div id="barExecutorsTimes"><svg style="min-height: 220px; margin: 10px auto"></svg></div>
                               </td>
                               % endif
                            </tr>                            
                         </table>
                      </div>                        
                   </div>
                </div>
             </td>                
          </tr>
          <tr valign="top">             
             % if Input:
             <td>
                <div class="col-lg-4">
                   <div class="panel panel-default">
                      <div class="panel-heading">
                         <i class="fa fa-bar-chart fa-fw"></i> Input
                      </div>
                      <div class="panel-body">                      
                         <table width="100%" height="100%" border="0" cellpadding="6" cellspacing="0">
                            <tr>
                               <td>
                                  <div id="barInputStats"><svg style="min-height: 220px; margin: 10px auto"></svg></div>
                               </td>
                               <td>
                                  <div id="barInputTimes"><svg style="min-height: 220px; margin: 10px auto"></svg></div>
                               </td>
                            </tr>                            
                         </table>   
                      </div>                        
                   </div>
                </div>
             </td>
             % endif
             % if Output:
             <td>
                <div class="col-lg-4">
                   <div class="panel panel-default">
                      <div class="panel-heading">
                         <i class="fa fa-bar-chart fa-fw"></i> Output
                      </div>
                      <div class="panel-body">
                         <table width="100%" height="100%" border="0" cellpadding="6" cellspacing="0">
                            <tr>
                               <td>
                                  <div id="barOutputStats"><svg style="min-height: 220px; margin: 10px auto"></svg></div>
                               </td>
                            </tr>
                         </table>         
                      </div>                        
                   </div>
                </div>
             </td>
             % endif
          </tr>          
       </table>             
    </div>
  </div>
</div>

${commonfooter(messages) | n,unicode}
