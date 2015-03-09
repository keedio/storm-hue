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

${ graphsHUE.import_charts() }
${ JavaScript.import_js() }

<script type="text/javascript" charset="utf-8">    
   $(document).ready(function() {
       $('#tblTopologyComponent').dataTable( {	    
	    	"sPaginationType": "bootstrap",
	    	"bLengthChange": false,
	    	"bFilter": false,
	        "sDom": "<'row-fluid'<l><f>r>t<'row-fluid'<'dt-pages'p><'dt-records'i>>"        
	    } );

         var dataBarComponentsStats = [];
       var dataBarComponentsTimes = [];
       
       var sData = "${Data['components']}";   
       var swData = sData.replace(/&quot;/ig,'"')   
       var jsonComponents = JSON.parse(swData);
       
       for (var i=0; i<Object.keys(jsonComponents).length; i++) {           
          dataBarComponentsStats.push({"key": jsonComponents[i].windowPretty, 
                                       "values": [ {"x": "${ _('Emitted') }", "y": jsonComponents[i].emitted},
                                                   {"x": "${ _('Transferred') }", "y": jsonComponents[i].transferred},                                                                   
                                                   {"x": "${ _('Acked') }", "y": jsonComponents[i].acked},
                                                   {"x": "${ _('Failed') }", "y": jsonComponents[i].failed}
                                                 ]
                              });
          dataBarComponentsTimes.push({"key": jsonComponents[i].windowPretty, 
                                       "values": [ {"x": "${ _('Execute Latency (ms)') }", "y": jsonComponents[i].executeLatency},
                                                   {"x": "${ _('Process Latency (ms)') }", "y": jsonComponents[i].processLatency}
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
       
       var sData = "${Data['input']}";   
       var swData = sData.replace(/&quot;/ig,'"')   
       var jsonInput = JSON.parse(swData);
       
       for (var i=0; i<Object.keys(jsonInput).length; i++) {
          dataBarInputStats.push({"key": jsonInput[i].stream, 
                                  "values": [ {"x": "${ _('Executed') }", "y": jsonInput[i].executed},                                                                        
                                              {"x": "${ _('Acked') }", "y": jsonInput[i].acked},
                                              {"x": "${ _('Failed') }", "y": jsonInput[i].failed}
                                            ]
                              });
          dataBarInputTimes.push({"key": jsonInput[i].stream, 
                                  "values": [ {"x": "${ _('Execute Latency (ms)') }", "y": jsonInput[i].executeLatency},
                                              {"x": "${ _('Process Latency (ms)') }", "y": jsonInput[i].processLatency}
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
       
       var sData = "${Data['output']}";   
       var swData = sData.replace(/&quot;/ig,'"')   
       var jsonOutput = JSON.parse(swData);
       
       for (var i=0; i<Object.keys(jsonOutput).length; i++) {
          dataBarOutputStats.push({"key": jsonOutput[i].stream, 
                                   "values": [ {"x": "${ _('Emitted') }", "y": jsonOutput[i].emitted},
                                               {"x": "${ _('Transferred') }", "y": jsonOutput[i].transferred},                                                                   
                                               {"x": "${ _('Acked') }", "y": jsonOutput[i].acked},
                                               {"x": "${ _('Failed') }", "y": jsonOutput[i].failed}
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
       
       var sData = "${Data['executor']}";   
       var swData = sData.replace(/&quot;/ig,'"')   
       var jsonExecutors = JSON.parse(swData);
       
       for (var i=0; i<Object.keys(jsonExecutors).length; i++) {
          if ("${Data['components']['componentType']}" == "bolt") {
             dataBarExecutorsStats.push({"key": jsonExecutors[i].id, 
                                         "values": [ {"x": "${ _('Emitted') }", "y": jsonExecutors[i].emitted},
                                                     {"x": "${ _('Transferred') }", "y": jsonExecutors[i].transferred},                                                                   
                                                     {"x": "${ _('Executed') }", "y": jsonExecutors[i].executed},
                                                     {"x": "${ _('Acked') }", "y": jsonExecutors[i].acked},
                                                     {"x": "${ _('Failed') }", "y": jsonExecutors[i].failed}
                                                   ]
                                 });
             dataBarExecutorsTimes.push({"key": jsonExecutors[i].id, 
                                         "values": [ {"x": "${ _('Execute Latency (ms)') }", "y": jsonExecutors[i].executeLatency},
                                                     {"x": "${ _('Process Latency (ms)') }", "y": jsonExecutors[i].processLatency}
                                            ]
                              });                    
          }
          else {
             dataBarExecutorsStats.push({"key": jsonExecutors[i].id, 
                                         "values": [ {"x": "${ _('Emitted') }", "y": jsonExecutors[i].emitted},
                                                     {"x": "${ _('Transferred') }", "y": jsonExecutors[i].transferred},                                                                   
                                                     {"x": "${ _('Acked') }", "y": jsonExecutors[i].acked},
                                                     {"x": "${ _('Failed') }", "y": jsonExecutors[i].failed}
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
   });
</script>

<%
  _breadcrumbs = [
    [_('Storm Dashboard'), url('storm:storm_dashboard')],    
    [_('Topology ') + Data['topology']['id'] + _(' Detail'), url('storm:detail_dashboard', topology_id = Data['topology']['id'], system_id = 0)],
    [Data['components']['componentType'] + " " + Data['component_id'] + _(' Explain'), url('storm:detail_dashboard', topology_id = Data['topology']['id'], system_id = 0)]
  ]
%>

${ storm.menubar(section = 'Components Dashboard')}
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
            ${Templates.ControlPanelTopology(Data['topology'], "components_dashboard")} 
            <tr>
               <td colspan="2">                
                  ${Templates.tblRebalanceTopology(Data['topology'])}
                  ${Templates.tblAutomaticRebalance(Data['topology'])}
                  ${Templates.tblKill(Data['topology'])}
                  ${Templates.tblActivate(Data['topology'])}
                  ${Templates.tblDeactivate(Data['topology'])}
               </td>
            </tr>
            <tr>                          
               <td colspan="2">                
                  <div class="col-lg-4">
                     <div class="panel panel-default">
                        <div class="panel-heading">
                           <i class="fa fa-table fa-fw"></i> ${ _('Component Summary') }
                        </div>
                        <div class="panel-body">
                           <table class="table datatables table-striped table-hover table-condensed" id="tblTopologyComponent" data-tablescroller-disable="true">
                              <thead>
                                 <tr>
                                    <th> ${ _('Id') } </th>
                                    <th> ${ _('Topology') } </th>
                                    <th> ${ _('Executors') } </th>
                                    <th> ${ _('Tasks') } </th>                         
                                 </tr>
                              </thead>
                              <tbody>
                                 <tr>                         
                                    <td>${Data['component_id']}</td>
                                    <td>${Data['components']['name']}</td>                                                        
                                    <td>${Data['components']['executors']}</td>
                                    <td>${Data['components']['tasks']}</td>                                                 
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
                           <i class="fa fa-trello fa-fw"></i> ${ _('Stats') }
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
               % if (Data['components']['componentType'] == "bolt"):
               <td width="45%">
                  <div class="col-lg-4">
                     <div class="panel panel-default">
                        <div class="panel-heading">
                           <i class="fa fa-trello fa-fw"></i> ${ _('Times') }
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
                           <i class="fa fa-trello fa-fw"></i> ${ _('Executors') }
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
                           <i class="fa fa-trello fa-fw"></i> ${ _('Input') }
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
                           <i class="fa fa-trello fa-fw"></i> ${ _('Output') }
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
% endif
${commonfooter(messages) | n,unicode}
