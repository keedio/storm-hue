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

${commonheader("Failed", app_name, user) | n,unicode}

<%namespace name="storm" file="navigation_bar.mako" />
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

${ JavaScript.import_js() }

<script type='text/javascript'>    
   $(document).ready(function() {                                    
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
</script>

<%
  _breadcrumbs = [
    [_('Storm Dashboard'), url('storm:storm_dashboard')]
  ]
%>

${ storm.header(_breadcrumbs) }

${ storm.menubar(section = 'Failed')}

<div class="container-fluid">
   <div class="card">        
      <div class="card-body">         
         <table width="100%" height="100%" border="0" cellpadding="6" cellspacing="0">          
            <tr>               
               <td>                                    
                  <table width="100%" height="100%" border="0" cellpadding="6" cellspacing="0">                                                        
                   % if idComponent == 1:
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
                                           <th> ${ _('Window') } </th>
                                           <th> ${ _('Emitted') } </th>
                                           <th> ${ _('Transferred') } </th>
                                           <th> ${ _('Complete Latency (ms)') } </th>
                                           <th> ${ _('Acked') } </th>
                                           <th> ${ _('Failed') } </th>                         
                                        </tr>
                                     </thead>
                                     <tbody>
                                        % for row in Component:
                                           <tr>
                                              <td>
                                                 <a class="fa fa-tachometer" title="${ _('Topology Stats Dashboard') }" href="${url('storm:topology_dashboard', topology_id = idTopology, window_id = row['window'])}"></a>
                                                 <a title="${ _('Topology Stats Detail') }" href="${url('storm:topology', topology_id = idTopology, window_id = row['window'])}"> ${row["windowPretty"]} </a>
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
                   % endif
                   % if idComponent == 2:
                   <tr>
                      <td>
                         <div class="col-lg-4">
                            <div class="panel panel-default">
                               <div class="panel-heading">
                                  <i class="fa fa-table fa-fw"></i> ${ _('Spouts (All Time)') }
                               </div>
                               <div class="panel-body">                         
                                  <table class="table datatables table-striped table-hover table-condensed" id="tblTopologySpouts" data-tablescroller-disable="true">
                                     <thead>
                                        <tr>
                                           <th> ${ _('Id.') } </th>
                                           <th> ${ _('Executors') } </th>
                                           <th> ${ _('Tasks') } </th>
                                           <th> ${ _('Emitted') } </th>
                                           <th> ${ _('Transferred') } </th>
                                           <th> ${ _('Complete Latency (ms)') } </th>                         
                                           <th> ${ _('Acked') } </th>
                                           <th> ${ _('Failed') } </th>
                                           <th> ${ _('Last Error') } </th>
                                        </tr>
                                     </thead>
                                     <tbody>
                                        % for row in Component:
                                           <tr>                                     
                                              <td>
                                                 <a class="fa fa-tachometer" title="${ _('Spout Dashboard') }" href="${url('storm:components_dashboard', topology_id = idTopology, component_id = row["spoutId"], system_id = 0)}"></a>                                                 
                                                 <a title="${ _('Spout Detail') }" href="${url('storm:components', topology_id = idTopology, component_id = row["spoutId"], system_id = 0)}"> ${row["spoutId"]} </a>
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
                   % endif
                   % if idComponent == 3:
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
                                        % for row in Component:
                                           <tr>                                     
                                              <td>
                                                 <a class="fa fa-tachometer" title="${ _('Bolt Dashboard') }" href="${url('storm:components_dashboard', topology_id = idTopology, component_id = row["boltId"], system_id = 0)}"></a>
                                                 <a title="${ _('Bolt Detail') }" href="${url('storm:components', topology_id = idTopology, component_id = row["boltId"], system_id = 0)}"> ${row["boltId"]} </a>                                                 
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
                   % endif
                </table>
               </td>
            </tr>           
         </table>
      </div>
   </div>
</div>

${commonfooter(messages) | n,unicode}
