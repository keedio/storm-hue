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

${commonheader("Topology Detail", app_name, user) | n,unicode}

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


${ JavaScript.import_js() }
${ graphsHUE.import_charts() } 

<script type="text/javascript"> 
   $(document).ready(function() {
      //ko.applyBindings(new StormViewModel());
      var StormModel = new StormViewModel();
      ko.applyBindings(StormModel);

      var sData = "${Visualization}";   
      var swData = sData.replace(/&quot;/ig,'"')   
      var jsonVisualization = JSON.parse(swData);            
      
      //Call without button.
      show_visualization(null, "${Topology[0]}", jsonVisualization);
      //Call with button.
      //$("#show-hide-visualization").click(function () { show_visualization(null, "${Topology[0]}", jsonVisualization) });

      $('#tblTopologySummary').dataTable( {    
	    	"sPaginationType": "bootstrap",
	    	"bLengthChange": true,
	    	"bAutoWidth": true,
	        "sDom": ""        
	    } );
      
      $('#tblTopologyStats').dataTable( {
	    	"sPaginationType": "bootstrap",
	    	"bLengthChange": true,
	    	"autoWidth": true,
	        "sDom": "<'row-fluid'<l><f>r>t<'row-fluid'<'dt-pages'p><'dt-records'i>>"        
	    } );
	    
      $('#tblTopologySpouts').dataTable( {
	    	"sPaginationType": "bootstrap",
	    	"bLengthChange": true,
	    	"bAutoWidth": true,
	        "sDom": "<'row-fluid'<l><f>r>t<'row-fluid'<'dt-pages'p><'dt-records'i>>"        
	    } );
	    
      $('#tblTopologyBolts').dataTable( {
	    	"sPaginationType": "bootstrap",
	    	"bLengthChange": true,
	    	"bAutoWidth": true,
	        "sDom": "<'row-fluid'<l><f>r>t<'row-fluid'<'dt-pages'p><'dt-records'i>>"        
	    } );    
   });         
   
   var margin = {top: 50, right: 50, bottom: 120, left: 70};
   var dataBarStats = [];
   
   var sData = "${jStats}";   
   var swData = sData.replace(/&quot;/ig,'"')   
   var jsonStats = JSON.parse(swData);   
   
   for (var i=0; i<Object.keys(jsonStats).length; i++) {      
      dataBarStats.push({"key": jsonStats[i].windowPretty, "values": [ {"x": "Emitted", "y": jsonStats[i].emitted},
                                                                       {"x": "Transferred", "y": jsonStats[i].transferred},
                                                                       {"x": "Acked", "y": jsonStats[i].acked},
                                                                       {"x": "Failed", "y": jsonStats[i].failed}
                                                                     ]
                         });
      
   };
   
    nv.addGraph(function() {
                 var graphStats = nv.models.multiBarChart()
                                           .transitionDuration(350)
                                           .reduceXTicks(false)   //If 'false', every single x-axis tick label will be rendered.
                                           .rotateLabels(15)      //Angle to rotate x-axis labels.                                           
                                           .groupSpacing(0.1)     //Distance between each group of bars.    
                                           .showControls(true);
                                  
                                  graphStats.legend.margin({top: 15, right:0, left:0, bottom: 0});                                  
                                  graphStats.multibar.stacked(false);                                           
                                  graphStats.yAxis
                                            .tickFormat(d3.format('d'));
        
                                  d3.select('#barStats svg')
                                    .datum(dataBarStats)
                                    .call(graphStats)
                                    .attr('transform', 'translate(-10,-270)');

                                  nv.utils.windowResize(graphStats.update);

                                  return graphStats;
   });
   
   var dataBarSpouts = [];
   
   var sData = "${jSpouts}";   
   var swData = sData.replace(/&quot;/ig,'"')   
   var jsonSpouts = JSON.parse(swData);
   
   for (var i=0; i<Object.keys(jsonSpouts).length; i++) {      
      dataBarSpouts.push({"key": jsonSpouts[i].spoutId, "values": [ {"x": "Emitted", "y": jsonSpouts[i].emitted},
                                                                    {"x": "Transferred", "y": jsonSpouts[i].transferred},
                                                                    {"x": "Acked", "y": jsonSpouts[i].acked},
                                                                    {"x": "Failed", "y": jsonSpouts[i].failed}
                                                                  ]
                         });
      
   };
   
    nv.addGraph(function() {
                 var graphSpouts = nv.models.multiBarChart()
                                           .transitionDuration(350)
                                           .reduceXTicks(false)   //If 'false', every single x-axis tick label will be rendered.
                                           .rotateLabels(15)      //Angle to rotate x-axis labels.                                           
                                           .groupSpacing(0.1)    //Distance between each group of bars.                                
                                           .showControls(true);
                                  
                                  graphSpouts.legend.margin({top: 15, right:0, left:20, bottom: 0});
                                  graphSpouts.multibar.stacked(false);             
                                  graphSpouts.yAxis
                                            .tickFormat(d3.format('d'));
        
                                  d3.select('#barSpouts svg')
                                    .datum(dataBarSpouts)
                                    .call(graphSpouts);

                                  nv.utils.windowResize(graphSpouts.update);

                                  return graphSpouts;
   });
   
   var dataBarBolts = [];        
   var sData = "${jBolts}";      
   var swData = sData.replace(/&quot;/ig,'"');            
   var jsonBolts = JSON.parse(swData);
   
   for (var i=0; i<Object.keys(jsonBolts).length; i++) {         
      dataBarBolts.push({"key": jsonBolts[i].boltId, "values": [ {"x": "Emitted", "y": jsonBolts[i].emitted},
                                                                   {"x": "Transferred", "y": jsonBolts[i].transferred},
                                                                   {"x": "Executed", "y": jsonBolts[i].executed},
                                                                   {"x": "Acked", "y": jsonBolts[i].acked},
                                                                   {"x": "Failed", "y": jsonBolts[i].failed}
                                                                 ]
                          });
      
   };            
   
   nv.addGraph(function() {
                 var graphBolts = nv.models.multiBarChart()
                                           .transitionDuration(350)
                                           .reduceXTicks(false)   //If 'false', every single x-axis tick label will be rendered.
                                           .rotateLabels(15)      //Angle to rotate x-axis labels.                                           
                                           .groupSpacing(0.1)    //Distance between each group of bars.                                                 
                                           .showControls(true);
                                  
                                  graphBolts.legend.margin({top: 15, right:0, left:20, bottom: 0});
                                  graphBolts.multibar.stacked(false);             
                                  graphBolts.yAxis
                                            .tickFormat(d3.format('d'));
        
                                   d3.select('#barBolts svg')
                                    .datum(dataBarBolts)
                                    .call(graphBolts);

                                  nv.utils.windowResize(graphBolts.update);

                                  return graphBolts;
   });               
</script>

<%
  _breadcrumbs = [
    ["Storm Dashboard", url('storm:storm_dashboard')],    
    ["Topology " + Topology[0] + " Detail", url('storm:detail_dashboard', topology_id = Topology[0], system_id = 0)]
  ]
%>

${ storm.header(_breadcrumbs) }

${ storm.menubar(section = 'Detail Dashboard')}

${Templates.tblSubmitTopology(frmNewTopology, frmHDFS)}

<div id="divPrincipal" class="container-fluid">
  <div class="card">        
    <div class="card-body">
       <table width="100%" height="100%" border="0" cellpadding="6" cellspacing="0">                              
          ${Templates.ControlPanelTopology("detail_dashboard")}          
          <tr>
             <td colspan="2">
                ${Templates.tblTopologySummary()}
                ${Templates.tblRebalanceTopology(Topology[1])}
             </td>
          </tr>         
          <tr>
             <td colspan="2">
             <!-- ***************************************************************************************************************************** -->             
             <div id="divTables" style="display: none">                 
                <table width="100%" height="100%" border="0" cellpadding="6" cellspacing="0">                                                        
                   <tr>
                      <td>
                         <div class="col-lg-4">
                            <div class="panel panel-default">
                               <div class="panel-heading">
                                  <i class="fa fa-table fa-fw"></i> Topology Stats
                               </div>
                               <div class="panel-body">
                                  <table class="table datatables table-striped table-hover table-condensed" id="tblTopologyStats" data-tablescroller-disable="true">
                                     <thead>
                                        <tr>
                                           <th> Window </th>
                                           <th> Emitted </th>
                                           <th> Transferred </th>
                                           <th> Complete Latency (ms) </th>
                                           <th> Acked </th>
                                           <th> Failed </th>                         
                                        </tr>
                                     </thead>
                                     <tbody>
                                        % for row in Stats:
                                           <tr>
                                              <td>
                                                 <a class="fa fa-tachometer" title="Topology Stats Dashboard" href="${url('storm:topology_dashboard', topology_id = Topology[0], window_id = row['window'])}"></a>
                                                 <a title="Topology Stats Detail" href="${url('storm:topology', topology_id = Topology[0], window_id = row['window'])}"> ${row["windowPretty"]} </a>
                                              </td>
                                              <td>${row["emitted"]}</td>                                                        
                                              <td>${row["transferred"]}</td>
                                              <td>${row["completeLatency"]}</td>
                                              <td>
                                                 <span style="color: green; font-weight: bold">
                                                    ${row["acked"]}
                                                 </span>
                                              </td>
                                              <td>
                                                 <span style="color: red; font-weight: bold">
                                                    ${row["failed"]}
                                                 </span>
                                              </td>                         
                                           </tr>
                                        % endfor   
                                     </tbody>
                                  </table>                         
                               </div>                        
                            </div>
                         </div>                                         
                      </td>
                   </tr>
                   <tr>
                      <td>
                         <div class="col-lg-4">
                            <div class="panel panel-default">
                               <div class="panel-heading">
                                  <i class="fa fa-table fa-fw"></i> Spouts (All Time)
                               </div>
                               <div class="panel-body">                         
                                  <table class="table datatables table-striped table-hover table-condensed" id="tblTopologySpouts" data-tablescroller-disable="true">
                                     <thead>
                                        <tr>
                                           <th> Id. </th>
                                           <th> Executors </th>
                                           <th> Tasks </th>
                                           <th> Emitted </th>
                                           <th> Transferred </th>
                                           <th> Complete Latency (ms) </th>                         
                                           <th> Acked </th>
                                           <th> Failed </th>
                                           <th> Last Error </th>
                                        </tr>
                                     </thead>
                                     <tbody>
                                        % for row in Spouts:
                                           <tr>                                     
                                              <td>
                                                 <a class="fa fa-tachometer" title="Spout Dashboard" href="${url('storm:components_dashboard', topology_id = Topology[0], component_id = row["spoutId"], system_id = 0)}"></a>                                                 
                                                 <a title="Spout Detail" href="${url('storm:components', topology_id = Topology[0], component_id = row["spoutId"], system_id = 0)}"> ${row["spoutId"]} </a>
                                              </td>
                                              <td>${row["executors"]}</td>                                                        
                                              <td>${row["tasks"]}</td>
                                              <td>${row["emitted"]}</td>
                                              <td>${row["transferred"]}</td>
                                              <td>${row["completeLatency"]}</td>
                                              <td>
                                                 <span style="color: green; font-weight: bold">
                                                    ${row["acked"]}
                                                 </span>
                                              </td>
                                              <td>
                                                 <span style="color: red; font-weight: bold">
                                                    ${row["failed"]}
                                                 </span></td>
                                              % if (row["lastError"] == ""):
                                                 <td></td>
                                              % else:   
                                                 <td>
                                                    <span class="label label-important">
                                                       <a href="#" data-target="#divERROR" data-toggle="modal">                                                          
                                                          ERROR
                                                       </a>
                                                    </span>                                                                                                        
                                                    ${Templates.divERROR(row["lastError"])}
                                                 </td>
                                              % endif   
                                           </tr>
                                        % endfor
                                     </tbody>
                                  </table>
                               </div>
                            </div>
                         </div>   
                      </td>
                   </tr>
                   <tr>
                      <td>
                         <div class="col-lg-4">
                            <div class="panel panel-default">
                               <div class="panel-heading">
                                  <i class="fa fa-table fa-fw"></i> Bolts (All Time)
                               </div>
                               <div class="panel-body">                  
                                  <table class="table datatables table-striped table-hover table-condensed" id="tblTopologyBolts" data-tablescroller-disable="true">
                                     <thead>
                                        <tr>
                                           <th> Id. </th>
                                           <th> Executors </th>
                                           <th> Tasks </th>
                                           <th> Emitted </th>
                                           <th> Transferred </th>
                                           <th> Capacity (last 10m) </th>                         
                                           <th> Execute latency (ms) </th>
                                           <th> Executed </th>
                                           <th> Process latency (ms) </th>
                                           <th> Acked </th>
                                           <th> Failed </th>
                                           <th> Last error </th>
                                        </tr>
                                     </thead>
                                     <tbody>
                                        % for row in Bolts:
                                           <tr>                                     
                                              <td>
                                                 <a class="fa fa-tachometer" title="Bolt Dashboard" href="${url('storm:components_dashboard', topology_id = Topology[0], component_id = row["boltId"], system_id = 0)}"></a>
                                                 <a title="Bolt Detail" href="${url('storm:components', topology_id = Topology[0], component_id = row["boltId"], system_id = 0)}"> ${row["boltId"]} </a>                                                 
                                              </td>
                                              <td>${row["executors"]}</td>                                                        
                                              <td>${row["tasks"]}</td>
                                              <td>${row["emitted"]}</td>
                                              <td>${row["transferred"]}</td>
                                              <td>${row["capacity"]}</td>
                                              <td>${row["executeLatency"]}</td>
                                              <td>${row["executed"]}</td>
                                              <td>${row["processLatency"]}</td>
                                              <td>
                                                 <span style="color: green; font-weight: bold">
                                                    ${row["acked"]}
                                                 </span>
                                              </td>
                                              <td>
                                                 <span style="color: red; font-weight: bold">
                                                    ${row["failed"]}
                                                 </span>
                                              </td>
                                              % if (row["lastError"] == ""):
                                                 <td></td>
                                              % else:   
                                                 <td>
                                                    <span class="label label-important">
                                                       <a href="#" data-target="#divERROR" data-toggle="modal">                                                          
                                                          ERROR
                                                       </a>
                                                    </span>                                                                                                        
                                                    ${Templates.divERROR(row["lastError"])}
                                                 </td>
                                              % endif
                                           </tr>
                                        % endfor
                                     </tbody>
                                  </table>
                               </div>
                            </div>
                         </div>   
                      </td>
                   </tr>
                </table>              
             </div>
             </td>
          </tr>   
          <!-- ***************************************************************************************************************************** -->
          <!-- DASHBOARD -->
          <!-- ***************************************************************************************************************************** -->
          <tr>
             <td colspan="2">
                <div id="divDashboard">
                   <table width="100%" height="100%" border="0" cellpadding="6" cellspacing="0">
                      <tr valign="top">
                         <td width="33%">
                            % if Failed[0] <> 0:
                            <div class="panel panel-red">
                            % else:
                            <div class="panel panel-green">
                            % endif
                               <div class="panel-heading">
                                  <div class="row">
                                     <div class="col-xs-3">
                                        % if Failed[0] <> 0:
                                        <i class="fa fa-warning fa-2x"></i>
                                        % else:
                                        <i class="fa fa-check-circle fa-2x"></i>
                                        % endif
                                     </div>
                                     <div class="col-xs-9 text-right">
                                        <div class="huge">${Failed[0]} Failed</div>
                                        <div>Topology Stats</div>
                                     </div>
                                  </div>
                               </div>
                               <a href="/storm/failed/${Topology[0]}/1/0">                               
                                  <div class="panel-footer">
                                     <span class="pull-left">View Details</span>
                                     <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                     <div class="clearfix"></div>
                                  </div>
                               </a>
                            </div>
                         </td>
                         <td width="34%">
                            % if Failed[1] <> 0:
                            <div class="panel panel-red">
                            % else:
                            <div class="panel panel-green">
                            % endif
                               <div class="panel-heading">
                                  <div class="row">
                                     <div class="col-xs-3">
                                        % if Failed[1] <> 0:
                                        <i class="fa fa-warning fa-2x"></i>
                                        % else:
                                        <i class="fa fa-check-circle fa-2x"></i>
                                        % endif
                                     </div>
                                     <div class="col-xs-9 text-right">
                                        <div class="huge">${Failed[1]} Failed</div>
                                        <div>Spouts</div>
                                     </div>
                                  </div>
                               </div>
                               <a href="/storm/failed/${Topology[0]}/2/0">                               
                                  <div class="panel-footer">
                                     <span class="pull-left">View Details</span>
                                     <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                     <div class="clearfix"></div>
                                  </div>
                               </a>
                            </div>
                         </td>
                         <td width="33%">
                            % if Failed[1] <> 0:
                            <div class="panel panel-red">
                            % else:
                            <div class="panel panel-green">
                            % endif
                               <div class="panel-heading">
                                  <div class="row">
                                     <div class="col-xs-3">
                                        % if Failed[2] <> 0:
                                        <i class="fa fa-warning fa-2x"></i>
                                        % else:
                                        <i class="fa fa-check-circle fa-2x"></i>
                                        % endif
                                     </div>
                                     <div class="col-xs-9 text-right">
                                        <div class="huge">${Failed[2]} Failed</div>
                                        <div>Bolts</div>
                                     </div>
                                  </div>
                               </div>
                               <a href="/storm/failed/${Topology[0]}/3/0">                               
                                  <div class="panel-footer">
                                     <span class="pull-left">View Details</span>
                                     <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                     <div class="clearfix"></div>
                                  </div>
                               </a>
                            </div>
                         </td>
                      </tr>
                      <tr valign="top">
                         <td width="33%">
                            <div class="col-lg-4">
                               <div class="panel panel-default">
                                  <div class="panel-heading">                                     
                                     <a href="${url('storm:detail_dashboard', topology_id = Topology[0], system_id = 0)}" title="Topology Stats Detail"> 
                                        <i class="fa fa-table fa-fw"></i>
                                        Stats 
                                     </a>
                                  </div>
                                  <div class="panel-body">
                                     <div id="barStats"><svg style="max-width: 512px; min-height: 400px; margin: 10px auto"></svg></div>
                                  </div>
                               </div>
                            </div>   
                         </td>
                         <td width="34%">
                            <div class="col-lg-4">
                               <div class="panel panel-default">
                                  <div class="panel-heading">
                                     <a href="${url('storm:spouts_dashboard', topology_id = Topology[0])}" title="Spouts Detail"> 
                                        <i class="fa fa-table fa-fw"></i>
                                        Spouts
                                     </a>                                     
                                  </div>
                                  <div class="panel-body">
                                     <div id="barSpouts"><svg style="max-width: 512px; min-height: 400px; margin: 10px auto"></svg></div>
                                  </div>
                               </div>
                            </div>   
                         </td>
                         <td width="34%">
                            <div class="col-lg-4">
                               <div class="panel panel-default">
                                  <div class="panel-heading">
                                     <a href="${url('storm:bolts_dashboard', topology_id = Topology[0])}" title="Bolts Detail"> 
                                        <i class="fa fa-table fa-fw"></i>
                                        Bolts
                                     </a>                                     
                                  </div>
                                  <div class="panel-body">
                                     <div id="barBolts"><svg style="max-width: 512px; min-height: 400px; margin: 10px auto"></svg></div>
                                  </div>
                               </div>
                            </div>   
                         </td>
                      </tr>
                      <tr>
                         <td colspan="3">
                            <div class="col-lg-4">
                               <div class="panel panel-default">
                                  <div class="panel-heading">
                                     <i class="fa fa-table fa-fw"></i> Topology Visualization
                                  </div>
                                  <div class="panel-body">
                                     <!-- <input type="button" id="show-hide-visualization" value="Show Visualization"/> -->
                                     <div id="topology-visualization"> </div>
                                        <div id="visualization-container">
                                           <p>
                                              <table class="zebra-striped">
                                                 <thead>
                                                    <tr>
                                                        <th align="left" class="header" colspan=4>
                                                           Streams
                                                        </th>
                                                    </tr>
                                                 </thead>          
                                                 <tr>                                        
                                                    <td>
                                                       <input type="checkbox" id="default1544803905" class="stream-box" checked /> default              
                                                    </td>
                                                    <td>
                                                       <input type="checkbox" id="s__ack_ack1278315507" class="stream-box"/> __ack_ack             
                                                    </td>
                                                    <td>
                                                       <input type="checkbox" id="s__ack_init973324006" class="stream-box"/> __ack_init    
                                                    </td>
                                                    <td>
                                                       <input type="checkbox" id="s__ack_fail973222132" class="stream-box"/> __ack_fail   
                                                    </td>
                                                 </tr>          
                                              </table>
                                           </p>
                                           <canvas id="topoGraph" style="max-width: 1024px; min-height: 400px; margin: 10px auto">
                                        </div>
                                     </div>                                                                                       
                                  </div>
                               </div>
                            </div>   
                         </td>
                      </tr>                                                                  
                   </table>
                </div>   
             </td>
          </tr>
          <!-- ***************************************************************************************************************************** -->                                
       </table>             
    </div>
  </div>
</div>

${commonfooter(messages) | n,unicode}
