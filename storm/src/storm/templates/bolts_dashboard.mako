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

<%!from desktop.views import commonheader, commonfooter %>

${commonheader("Bolts Detail", app_name, user) | n,unicode}

<%namespace name="storm" file="navigation_bar.mako" />
<%namespace name="graphsHUE" file="common_dashboard.mako" />
<%namespace name="Templates" file="templates.mako" />
<%namespace name="JavaScript" file="js.mako" />

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
${ JavaScript.import_js() }

<script type="text/javascript" charset="utf-8"> 
   $(document).ready(function() {
      $('#tblTopologyBolts').dataTable( {	    
	    	"sPaginationType": "bootstrap",
	    	"bLengthChange": true,
	    	"autoWidth": true,
	        "sDom": "<'row-fluid'<l><f>r>t<'row-fluid'<'dt-pages'p><'dt-records'i>>"        
	    } );
   });
   
   var dataPieBolts1 = [];
   var dataBarBolts1 = [];
   var iTasks = 0;
   var iExecutors = 0;
   
   var sData = "${Bolts}";   
   var swData = sData.replace(/&quot;/ig,'"')   
   var jsonBolts = JSON.parse(swData);
   
   for (var i=0; i<Object.keys(jsonBolts).length; i++) {
      iTasks+=jsonBolts[i].tasks;
      iExecutors+=jsonBolts[i].executors;     
      dataBarBolts1.push({"key": jsonBolts[i].boltId, "values": [ {"x": "Emitted", "y": jsonBolts[i].emitted},
                                                                   {"x": "Transferred", "y": jsonBolts[i].transferred},
                                                                   {"x": "Executed", "y": jsonBolts[i].executed},
                                                                   {"x": "Acked", "y": jsonBolts[i].acked},
                                                                   {"x": "Failed", "y": jsonBolts[i].failed}
                                                                 ]
                          });
      dataPieBolts1.push({"label": "Tasks", "value" : iTasks}, {"label": "Executors", "value" : iExecutors});                                 
      
   };      
   
   nv.addGraph(function() {
                  var chart = nv.models.pieChart()
                                       .x(function(d) { return d.label })
                                       .y(function(d) { return d.value })
                                       .valueFormat(d3.format(".0f"))
                                       .color(['#468847', '#f89406'])
                                       .showLabels(false);

                  d3.select("#pieBolts1 svg")
                    .datum(dataPieBolts1)
                    .transition().duration(350)
                    .call(chart);
 
                  return chart;
   });   
   
   nv.addGraph(function() {
                 var graphBolts1 = nv.models.multiBarChart()
                                           .transitionDuration(350)
                                           .reduceXTicks(true)   //If 'false', every single x-axis tick label will be rendered.
                                           .rotateLabels(0)      //Angle to rotate x-axis labels.                                           
                                           .groupSpacing(0.1)    //Distance between each group of bars.                                
                                           .showControls(true);
                                  
                                  graphBolts1.multibar.stacked(false);         
    
                                  graphBolts1.yAxis
                                            .tickFormat(d3.format('d'));
        
                                  d3.select('#barBolts1 svg')
                                    .datum(dataBarBolts1)
                                    .call(graphBolts1);

                                  nv.utils.windowResize(graphBolts1.update);

                                  return graphBolts1;
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
    ["Bolts Detail", url('storm:bolts_dashboard', topology_id = Topology[0])]
  ]
%>

${ storm.header(_breadcrumbs) }

${ storm.menubar(section = 'Bolts Detail')}

<div id="divPrincipal" class="container-fluid">
  <div class="card">        
    <div class="card-body">
       <table width="100%" height="100%" border="0" cellpadding="6" cellspacing="0">
          ${Templates.ControlPanelTopology("bolts_dashboard")}
          <tr valign="top">
             <td width="60%">
                <div class="col-lg-4">
                   <div class="panel panel-default">
                      <div class="panel-heading">
                         <i class="fa fa-bar-chart fa-fw"></i> Stats
                      </div>
                      <div class="panel-body">
                         <div id="barBolts1"><svg style="min-height: 220px; margin: 10px auto"></svg></div>
                      </div>                        
                   </div>
                </div>
             </td>
             <td width="40%">
                <div class="col-lg-4">
                   <div class="panel panel-default">
                      <div class="panel-heading">
                         <i class="fa fa-pie-chart fa-fw"></i> Executors/Tasks
                      </div>
                      <div class="panel-body">
                         <div id="pieBolts1"><svg style="min-height: 240px; margin: 10px auto"></svg></div>
                      </div>                        
                   </div>
                </div>
             </td>             
          </tr>
          <tr valign="top">
             <td colspan="2">
                <div class="col-lg-4">
                   <div class="panel panel-default">
                      <div class="panel-heading">
                         <i class="fa fa-bar-chart fa-fw"></i> Summary
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
                               % for row in aBolts:
                                  <tr>                                     
                                     <td>
                                        <a class="fa fa-tachometer" href="${url('storm:components_dashboard', topology_id = Topology[0], component_id = row["boltId"], system_id = 0)}"></a>
                                        <a href="${url('storm:components', topology_id = Topology[0], component_id = row["boltId"], system_id = 0)}"> ${row["boltId"]} </a>                                                 
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
  </div>
</div>

${commonfooter(messages) | n,unicode}
