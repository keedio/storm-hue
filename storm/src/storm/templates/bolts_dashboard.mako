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

${commonheader("Bolts Detail", app_name, user) | n,unicode}

<%namespace name="storm" file="navigation_bar.mako" />
<%namespace name="graphsHUE" file="common_dashboard.mako" />
<%namespace name="Templates" file="templates.mako" />
<%namespace name="JavaScript" file="js.mako" />

## Use double hashes for a mako template comment
## Main body

<link href="/storm/static/css/storm.css" rel="stylesheet">

${ graphsHUE.import_charts() }
${ JavaScript.import_js() }

<script type="text/javascript" charset="utf-8"> 
   $(document).ready(function() {
      var StormModel = new StormViewModel();
      ko.applyBindings(StormModel);
      
      $('#tblTopologyBolts').dataTable( {	    
	    	"sPaginationType": "bootstrap",
	    	"bLengthChange": true,
	    	"autoWidth": true,
	        "sDom": "<'row-fluid'<l><f>r>t<'row-fluid'<'dt-pages'p><'dt-records'i>>"        
	    } );

         var dataPieBolts1 = [];
         var dataBarBolts1 = [];
         var iTasks = 0;
         var iExecutors = 0;
         
         var sData = "${Data['jBolts']}";   
         var swData = sData.replace(/&quot;/ig,'"')   
         var jsonBolts = JSON.parse(swData);
         
         for (var i=0; i<Object.keys(jsonBolts).length; i++) {
            iTasks+=jsonBolts[i].tasks;
            iExecutors+=jsonBolts[i].executors;     
            dataBarBolts1.push({"key": jsonBolts[i].boltId, "values": [ {"x": "${ _('Emitted') }", "y": jsonBolts[i].emitted},
                                                                         {"x": "${ _('Transferred') }", "y": jsonBolts[i].transferred},
                                                                         {"x": "${ _('Executed') }", "y": jsonBolts[i].executed},
                                                                         {"x": "${ _('Acked') }", "y": jsonBolts[i].acked},
                                                                         {"x": "${ _('Failed') }", "y": jsonBolts[i].failed}
                                                                       ]
                                });            
         };      
         
         dataPieBolts1.push({"label": "${ _('Tasks') }", "value" : iTasks}, {"label": "${ _('Executors') }", "value" : iExecutors});                                 

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
   });
</script>

<%
  _breadcrumbs = [
    [_('Storm Dashboard'), url('storm:storm_dashboard')],    
    [_('Topology') + Data['topology']['id'] + _(' Detail'), url('storm:detail_dashboard', topology_id = Data['topology']['id'], system_id = 0)],
    [_('Bolts Detail'), url('storm:bolts_dashboard', topology_id = Data['topology']['id'])]
  ]
%>

${ storm.menubar(section = 'Bolts Detail')}
${Templates.tblSubmitTopology(Data['frmNewTopology'])}
${Templates.tblSaveTopology(Data['frmHDFS'])}

% if Data['error'] == 1:
  <div class="container-fluid">
    <div class="card">
      <div class="card-body">
        <div class="alert alert-error">
          <h2>${ _('Error connecting to the Storm UI server:') } <b>${Data['storm_ui']}</b></h2>
          <h3>${ _('Please contact your administrator to solve this.') }</h3>
        </div>
      </div>
    </div>
  </div>  
% else:
${ storm.header(_breadcrumbs) }

<div id="divPrincipal" class="container-fluid">
  <div class="card">        
    <div class="card-body">
       <table width="100%" height="100%" border="0" cellpadding="6" cellspacing="0">   
          ${Templates.ControlPanelTopology(Data['topology'], "bolts_dashboard")} 
          <tr>
             <td colspan="2">                
                ${Templates.tblRebalanceTopology(Data['topology'])}
             </td>
          </tr>
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
                         <i class="fa fa-pie-chart fa-fw"></i> ${ _('Executors/Tasks') }
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
                                  <th> ${ _('Id.') } </th>
                                  <th> ${ _('Executors') } </th>
                                  <th> ${ _('Tasks') } </th>
                                  <th> ${ _('Emitted') } </th>
                                  <th> ${ _('Transferred') } </th>
                                  <th> ${ _('Capacity (last 10m)') } </th>                         
                                  <th> ${ _('Execute latency (ms)') } </th>
                                  <th> ${ _('Executed') } </th>
                                  <th> ${ _('Process latency (ms)') } </th>
                                  <th> ${ _('Acked') } </th>
                                  <th> ${ _('Failed') } </th>
                                  <th> ${ _('Last error') } </th>
                               </tr>
                            </thead>
                            <tbody>
                               % for row in Data['bolts']:
                                  <tr>                                     
                                     <td>
                                        <a class="fa fa-tachometer" href="${url('storm:components_dashboard', topology_id = Data['topology']['id'], component_id = row["boltId"], system_id = 0)}"></a>
                                        <a href="${url('storm:components', topology_id = Data['topology']['id'], component_id = row["boltId"], system_id = 0)}"> ${row["boltId"]} </a>                                                 
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
                                                 ${ _('ERROR') }
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
% endif
${commonfooter(messages) | n,unicode}
