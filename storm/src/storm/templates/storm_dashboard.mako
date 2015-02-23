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

${commonheader("Storm Dashboard", app_name, user) | n,unicode}

<%namespace name="storm" file="navigation_bar.mako" />
<%namespace name="graphsHUE" file="common_dashboard.mako" />
<%namespace name="Templates" file="templates.mako" />
<%namespace name="JavaScript" file="js.mako" />

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

<script type='text/javascript'>    
   $(document).ready(function() {                      
      //ko.applyBindings(new StormViewModel());       
      var StormModel = new StormViewModel();
      ko.applyBindings(StormModel);
      
      $('#tblTopology').dataTable( {
                "sPaginationType": "bootstrap",
	    	"bLengthChange": true,
	    	"autoWidth": true,
	        "sDom": "<'row-fluid'<l><f>r>t<'row-fluid'<'dt-pages'p><'dt-records'i>>"        
	    } );
   });
   
   var dataTopologyStats = [ { "label": "${ _('Active') }",                               
                               "value" : "${Active}"
                             },
                             { "label": "${ _('Inactive') }",                               
                               "value" : "${Inactive}"
                             }
                           ];
                  
   nv.addGraph(function() {
                  var chart = nv.models.pieChart()
                                       .x(function(d) { return d.label })
                                       .y(function(d) { return d.value })
                                       .valueFormat(d3.format(".0f"))
                                       .color(['#468847', '#f89406'])
                                       .showLabels(false);

                  d3.select("#pieTopologyStats svg")
                    .datum(dataTopologyStats)
                    .transition().duration(350)
                    .call(chart);
 
                  return chart;
   });

   var dataExecWorkers = [ { "label": "${ _('Executors') }",
                             "value" : "${Executors}"
                           },
                           { "label": "${ _('Workers') }",
                             "value" : "${Workers}"
                           },
                           { "label": "${ _('Tasks') }",
                             "value" : "${Tasks}"
                           }
                         ];
                           
   nv.addGraph(function() {
                  var chart = nv.models.pieChart()
                                       .x(function(d) { return d.label })
                                       .y(function(d) { return d.value })
                                       .valueFormat(d3.format(".0f"))
                                       .showLabels(false);

                  d3.select("#pieExecWorkers svg")
                    .datum(dataExecWorkers)
                    .transition().duration(350)
                    .call(chart);
 
                  return chart;
   });
               
</script>

<%
  _breadcrumbs = [
    [_('Storm Dashboard'), url('storm:storm_dashboard')]
  ]
%>

${ storm.header(_breadcrumbs) }

${ storm.menubar(section = 'Storm Dashboard')}

${Templates.tblSubmitTopology(frmNewTopology)}
${Templates.tblSaveTopology(frmHDFS)}
  
% if (len(Topologies) > 0):
   <div class="container-fluid">
     <div class="card">        
       <div class="card-body">              
          <table width="100%" height="100%" border="0" cellpadding="6" cellspacing="0">             
             <tr valign="top">
                <td width="33%" rowspan="3">
                   <div class="col-lg-4">
                      <div class="panel panel-default">
                         <div class="panel-heading">
                            <i class="fa fa-pie-chart fa-fw"></i> ${ _('Topologies Status') }
                         </div>
                         <div class="panel-body">
                            <div id="pieTopologyStats"><svg style="min-height: 240px; margin: 10px auto"></svg></div>
                         </div>                        
                      </div>
                   </div> 
                </td>
                <td width="33%" rowspan="3">
                   <div class="col-lg-4">
                      <div class="panel panel-default">
                         <div class="panel-heading">
                            <i class="fa fa-pie-chart fa-fw"></i> ${ _('Topologies Stats') }
                         </div>
                         <div class="panel-body">
                            <div id="pieExecWorkers"><svg style="min-height: 240px; margin: 10px auto"></svg></div>
                         </div>                        
                      </div>
                   </div>
                </td>                                
                <td width="34%">
                   <%
                      iMax = 0
                      iMin = 0
                      iTemp = 0
                      sNameMin = ""
                      sNameMax = ""
                      sIdMax = ""
                      sIdMin = ""
                      sUptimeMin = ""
                      sUptimeMax = ""
                      iCount = 0     
          
                      while (iCount < len(Topologies)):
                         iTemp = Topologies[iCount]['seconds']
                         
                         if (iTemp >= iMax):	                 	                                  
                            iMax = iTemp                              
                            sUptimeMax = Topologies[iCount]["uptime"]
                            sNameMax = Topologies[iCount]["name"]
                            sIdMax = Topologies[iCount]["id"]
                            
                            if (iMin == 0):
   	                       iMin = iMax                  
                               sUptimeMin = sUptimeMax
                               sNameMin = sNameMax
                               sIdMin = sIdMax                            
                         else:                            
                            if (iTemp < iMin):
                               iMin = iTemp
                               sUptimeMin = Topologies[iCount]["uptime"]
                               sNameMin = Topologies[iCount]["name"]
                               sIdMin = Topologies[iCount]["id"]                                           
                            
                         iCount+=1                                                                                
                   %>
                                                  
                   <div class="panel panel-primary">
                      <div class="panel-heading">
                         <div class="row">
                            <div class="col-xs-3">
                               <i class="fa fa-plus-circle fa-3x"></i>
                            </div>
                            <div class="col-xs-9 text-right">
                               <div class="huge">${sUptimeMax}</div>
                               <div>${ _('Max Uptime') }</div>
                            </div>
                         </div>
                      </div>
                      <a href="${url('storm:detail_dashboard', topology_id = sIdMax, system_id = 0)}">                               
                         <div class="panel-footer">
                            <span class="pull-left">${sNameMax}</span>
                            <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                            <div class="clearfix"></div>
                         </div>
                      </a>
                   </div>
                </td>             
             </tr>             
             <tr valign="top">
                <td>
                   <div class="panel panel-primary">
                      <div class="panel-heading">
                         <div class="row">
                            <div class="col-xs-3">
                               <i class="fa fa-minus-circle fa-3x"></i>
                            </div>
                            <div class="col-xs-9 text-right">
                               <div class="huge">${sUptimeMin}</div>
                               <div>${ _('Min Uptime') }</div>
                            </div>
                         </div>
                      </div>
                      <a href="${url('storm:detail_dashboard', topology_id = sIdMin, system_id = 0)}">                               
                         <div class="panel-footer">
                            <span class="pull-left">${sNameMin}</span>
                            <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                            <div class="clearfix"></div>
                         </div>
                      </a>
                   </div>                                                       
                </td>             
             </tr>
             <tr valign="top">
                <td>
                   <div class="panel panel-green">
                      <div class="panel-heading">
                         <div class="row">
                            <div class="col-xs-3">
                               <i class="fa fa-check-circle fa-3x"></i>
                            </div>
                            <div class="col-xs-9 text-right">
                               <div class="huge">0 ${ _('Failed') }</div>
                               <div>${ _('Topology Stats') }</div>
                            </div>
                         </div>
                      </div>
                      <a href="#">                               
                         <div class="panel-footer">
                            <span class="pull-left">${ _('View Details') }</span>
                            <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                            <div class="clearfix"></div>
                         </div>
                      </a>
                   </div>
                </td>
             <tr>
             <tr>
                <td colspan="3">
                   <div class="col-lg-4">
                      <div class="panel panel-default">
                         <div class="panel-heading">
                            <i class="fa fa-table fa-fw"></i> ${ _('Topology Summary') }
                         </div>
                         <div class="panel-body">
                            <table class="table datatables table-striped table-hover table-condensed" id="tblTopology" data-tablescroller-disable="true">
                               <thead>
                                  <tr>
                                     <th> ${ _('Name') } </th>
                                     <th> ${ _('Id.') } </th>
                                     <th> ${ _('Status') } </th>
                                     <th> ${ _('Uptime') } </th>
                                     <th> ${ _('Num.Workers') } </th>
                                     <th> ${ _('Num.Executors') } </th>
                                     <th> ${ _('Num.Tasks') } </th>
                                  </tr>
                               </thead>        
                               <tbody> 
                                  % for row in Topologies:                                  
                                     <tr>
                                        <td>
                                           <a href="${url('storm:detail_dashboard', topology_id = row['id'], system_id = 0)}"> ${row["name"]} </a>   
                                        </td>
                                        <td>${row["id"]}</td>                                                        
                                        <td>
                                           % if row["status"] == "ACTIVE":
                                              <span class="label label-success"> ${row["status"]} </span>
                                           % else:
                                              <span class="label label-warning"> ${row["status"]} </span>
                                           % endif
                                        </td>
                                        <td>${row["uptime"]}</td>
                                        <td>${row["workersTotal"]}</td>
                                        <td>${row["executorsTotal"]}</td>
                                        <td>${row["tasksTotal"]}</td>
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
% else:
   ${Templates.divWithoutData()}   
% endif

${commonfooter(messages) | n,unicode}
